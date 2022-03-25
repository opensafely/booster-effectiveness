
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports processed data
# chooses matching sets for each sequential trial
# outputs matching summary
#
# The script must be accompanied by one arguments:
# `treatment` - the exposure in the regression model, pfizer or moderna

# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----


# import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)


if(length(args)==0){
  # use for interactive testing
  removeobjects <- FALSE
  treatment <- "pfizer"
} else {
  removeobjects <- TRUE
  treatment <- args[[1]]
}



## Import libraries ----
library('tidyverse')
library('here')
library('glue')
library('survival')
library('MatchIt')

## Import custom user functions from lib

source(here("lib", "functions", "utility.R"))
source(here("lib", "functions", "survival.R"))
source(here("lib", "functions", "redaction.R"))

postbaselinecuts <- read_rds(here("lib", "design", "postbaselinecuts.rds"))
matching_variables <- read_rds(here("lib", "design", "matching_variables.rds"))
exact_variables <- read_rds(here("lib", "design", "exact_variables.rds"))
caliper_variables <- read_rds(here("lib", "design", "caliper_variables.rds"))

if(Sys.getenv("OPENSAFELY_BACKEND") %in% c("", "expectations")){
  recruitment_period_cutoff <- 0.1
} else{
  recruitment_period_cutoff <- read_rds(here("lib", "design", "recruitment_period_cutoff.rds"))
}


# create output directories ----

output_dir <- here("output", "match", treatment)
fs::dir_create(output_dir)

## create special log file ----
cat(glue("## script info for {treatment} ##"), "  \n", file = fs::path(output_dir, glue("match_log.txt")), append = FALSE)

## functions to pass additional log info to seperate file
logoutput <- function(...){
  cat(..., file = fs::path(output_dir, glue("match_log.txt")), sep = "\n  ", append = TRUE)
  cat("\n", file = fs::path(output_dir, glue("match_log.txt")), sep = "\n  ", append = TRUE)
}

logoutput_datasize <- function(x){
  nm <- deparse(substitute(x))
  logoutput(
    glue(nm, " data size = ", nrow(x)),
    glue(nm, " memory usage = ", format(object.size(x), units="GB", standard="SI", digits=3L))
  )
}

logoutput_table <- function(x){
  capture.output(
    x,
    file=fs::path(output_dir, glue("match_log.txt")),
    append=TRUE
  )
  cat("\n", file = fs::path(output_dir, glue("match_log.txt")), sep = "\n  ", append = TRUE)
}

## import globally defined study dates and convert to "Date"
study_dates <-
  jsonlite::read_json(path=here("lib", "design", "study-dates.json")) %>%
  map(as.Date)

## import metadata ----
events <- read_rds(here("lib", "design", "event-variables.rds"))

# Prepare data ----

## one pow per patient ----
data_cohort <- read_rds(here("output", "data", "data_cohort.rds"))

logoutput_datasize(data_cohort)



### rolling average of boosting per strata ----
select_recruitment_period <- function(index, x, min_x){

  max_index <- length(x)
  # start recruiting when x exceeds min_x, and stop recruiting when x is less than min_x
  start <- match(TRUE, x>=min_x) # recruitment start = first time x is greater than min_x,
  if (is.na(start)) start <- max_index+1
  end <- match(TRUE, x[seq(start+1, max_index)]<min_x)+start-1 # recruitment end = first time after start that x is less than min_x
  if (is.na(end)) end <- max_index

  between(seq_along(index), start, end)
}


# which variables to stratify by when determining "typical" vaccination periods
rolling_variables <- c("jcvi_group", "vax12_type", "region")

rolling_window <- 7

# daily vaccination counts within "rolling" strata
data_rollingstrata_vaxcount <-
  data_cohort %>%
  filter(!is.na(vax3_date), vax3_type %in% treatment) %>%
  group_by(across(all_of(rolling_variables)), vax3_date) %>%
  summarise(
    n=n()
  ) %>%
  # make implicit counts explicit
  complete(
    vax3_date = full_seq(c(.$vax3_date - rolling_window+1), 1), # go X days before to
    fill = list(n=0)
  ) %>%
  arrange(across(all_of(rolling_variables)), vax3_date) %>%
  ungroup() %>%
  group_by(across(all_of(rolling_variables))) %>%
  mutate(
    vax3_time = as.numeric(vax3_date - study_dates$index_date),
    cumuln = cumsum(n),
    # calculate rolling weekly average, anchored at end of period
    weight = lag(pmin(rolling_window, row_number()),rolling_window-1),
    rolling_avg = stats::filter(n, filter = rep(1, rolling_window), method="convolution", sides=1)/weight,
    recruit = select_recruitment_period(vax3_time, rolling_avg, recruitment_period_cutoff)
  ) %>%
  filter(vax3_time>=0)

write_rds(data_rollingstrata_vaxcount, fs::path(output_dir, "match_data_rollingstrata_vaxcount.rds"), compress="gz")

data_nontimevarying <-
  data_cohort %>%
  select(
    patient_id,
    any_of(c(rolling_variables, matching_variables, "vax3_date")),
    prior_covid_infection0
  ) %>%
  left_join(
    data_rollingstrata_vaxcount %>% select(all_of(c(rolling_variables, "vax3_date", "recruit"))),
    by=c(rolling_variables, "vax3_date")
  ) %>%
  mutate(
    treated_within_recruitment_period = replace_na(recruit, FALSE),
    recruit=NULL,
  )

if(removeobjects) rm(data_rollingstrata_vaxcount)

data_timevarying <-
  read_rds(here("output", "data", "data_long_timevarying.rds")) %>%
  select(
    patient_id,
    tstart,
    tstop,
    any_of(matching_variables),
    status_hospunplanned,
    status_hospplanned,
    mostrecent_anycovid,
  )

### event times ----

## tte = time-to-event, and always indicates time from study start date
data_tte <-
  data_cohort %>%
  transmute(
    patient_id,
    day0_date = study_dates$index_date-1, # day before the first trial date
    treatment_date = if_else(vax3_type %in% treatment, vax3_date, as.Date(NA)),
    competingtreatment_date = if_else(!(vax3_type %in% treatment), vax3_date, as.Date(NA)),

    # person-time is up to and including censor date
    censor_date = pmin(
      dereg_date,
      #competingtreatment_date-1, # -1 because we assume vax occurs at the start of the day
      vax4_date-1, # -1 because we assume vax occurs at the start of the day
      death_date,
      study_dates$studyend_date,
      na.rm=TRUE
    ),

    noncompetingcensor_date = pmin(
      dereg_date,
      #competingtreatment_date-1, # -1 because we assume vax occurs at the start of the day
      vax4_date-1, # -1 because we assume vax occurs at the start of the day
      study_dates$studyend_date,
      na.rm=TRUE
    ),

    # assume vaccination occurs at the start of the day, and all other events occur at the end of the day.

    # possible competing events
    tte_coviddeath = tte(day0_date, coviddeath_date, noncompetingcensor_date, na.censor=TRUE),
    tte_noncoviddeath = tte(day0_date, noncoviddeath_date, noncompetingcensor_date, na.censor=TRUE),
    tte_death = tte(day0_date, death_date, noncompetingcensor_date, na.censor=TRUE),

    tte_censor = tte(day0_date, censor_date, censor_date, na.censor=TRUE),

    tte_treatment = tte(day0_date, treatment_date-1, censor_date, na.censor=TRUE),
    tte_competingtreament = tte(day0_date, competingtreatment_date-1, censor_date, na.censor=TRUE),
    tte_vax3 = tte(day0_date, vax3_date-1, censor_date, na.censor=TRUE)

  ) %>%
  filter(
    # remove anyone with competing vaccine on first trial day
    #(competingtreatment_date-1>day0_date) | is.na(competingtreatment_date),
  ) %>%
  mutate(
    # convert tte variables (days since day0), to integer to save space
    across(starts_with("tte_"), as.integer),
    # convert logical to integer so that model coefficients print nicely in gtsummary methods
    across(where(is.logical), ~.x*1L)
  )

write_rds(data_tte, fs::path(output_dir, "match_data_tte.rds"), compress="gz")

logoutput_datasize(data_tte)


## baseline variables ----

data_baseline <-
  data_cohort %>%
  transmute(
    patient_id,
    age,
    ageband,
    sex,
    ethnicity_combined,
    imd_Q5,
    region,
    jcvi_group,
    jcvi_group_descr,
    prior_tests_cat,
    multimorb,
    learndis,
    sev_mental,
    cev,
    cv,
    cev_cv,
    sev_obesity,
    chronic_heart_disease,
    chronic_kidney_disease,
    diabetes,
    chronic_liver_disease,
    chronic_resp_disease,
    asthma,
    chronic_neuro_disease,
    prior_covid_infection0,
    immunosuppressed,
    asplenia,
    immuno,

    vax12_type,
    vax12_type_descr,
    vax2_week,
    vax2_day,
    vax3_date,
    vax3_type,

  )
logoutput_datasize(data_baseline)

if(removeobjects) rm(data_cohort)

local({

  ## sequential trial matching routine is as follows:
  # each daily trial includes all n people who were vaccinated on that day (treated=1) and
  # a random sample of n controls (treated=0) who:
  # - had not been vaccinated on or before that day (still at risk of treatment);
  # - had not experienced covid recently (within X TODO days);
  # - still at risk of an outcome (not deregistered or dead);
  # - had not already been selected as a control in a previous trial
  # for each trial, all covariates, including time-dependent covariates, are chosen as at the recruitment date and do not subsequently vary through follow-up
  # within the construct of the model, there are no time-dependent variables, only time-dependent treatment effects (modelled as piecewise constant hazards)


  end_trial_time <- as.integer(study_dates[[glue("{treatment}end_date")]] + 1 - study_dates[[glue("index_date")]])
  start_trial_time <- as.integer(study_dates[[glue("{treatment}start_date")]] - study_dates[[glue("index_date")]])
  trials <- seq(start_trial_time+1, end_trial_time, 1)

  # initialise list of candidate controls
  candidate_ids0 <- data_tte$patient_id

  # initialise matching summary data
  data_treated <- NULL
  data_eligible <- NULL
  data_matched <- NULL

  # matching formula

  #matching_formula <- as.formula(str_c("treated ~ ", paste(matching_variables, collapse=" + ")))
  matching_formula <- treated ~ 1

  already_stopped <- FALSE

  #trial=1
  for(trial in trials){

    cat("matching trial ", trial, "\n")
    trial_time <- trial-1

    data_timevarying_i <-
      filter(
        data_timevarying,
        trial_time>=tstart,
        trial_time<tstop
      )

    data_treated_i <-
      data_tte %>%
      filter(tte_treatment %in% trial_time) %>%
      transmute(
        patient_id,
        treated=1L,
        trial_time=trial_time,
      )
    data_treated <- bind_rows(data_treated, data_treated_i)

    # set of people boosted on trial day, + their candidate controls
    matching_candidates_i <-
      data_tte %>%
      arrange(patient_id) %>%
      # join time invariant variables
      left_join(data_nontimevarying, by="patient_id") %>%
      # join time-variant variables
      left_join(data_timevarying_i, by="patient_id") %>%
      mutate(
        prior_covid_infection = prior_covid_infection0 | !is.na(mostrecent_anycovid)
      ) %>%
      filter(
        # remove anyone already censored
        tte_censor > trial_time,
        # remove anyone who has experienced covid within the last 90 days
        !between(mostrecent_anycovid, trial_time-90, trial_time) | is.na(mostrecent_anycovid),
        # remove anyone currently in hospital
        status_hospunplanned==0L
      ) %>%
      mutate(
        treated = tte_treatment %in% trial_time,
        # everyone treated on trial day and eligible
        treated_candidate = ((tte_treatment %in% trial_time) & treated_within_recruitment_period)*1,
        # everyone not yet treated by trial day, not yet censored, and not already selected as a control
        control_candidate = (((tte_vax3 > trial_time) | is.na(tte_vax3)) & (patient_id %in% candidate_ids0))*1
      ) %>%
      filter((treated_candidate==1L) | (control_candidate==1L))

    data_eligible_i <-
      matching_candidates_i %>%
      filter(treated_candidate==1L) %>%
      transmute(
        patient_id,
        eligible=1L,
        trial_time=trial_time,
      )
    data_eligible <- bind_rows(data_eligible, data_eligible_i)


    if(sum(matching_candidates_i$treated_candidate)<1 | already_stopped) {
      message("Skipping trial ", trial, " - No treated people eligible for inclusion.")
      next
    }

    n_treated_all <- sum(matching_candidates_i$treated_candidate)

    safely_matchit <- purrr::safely(matchit)
    #distance <- rep(1, nrow(matching_candidates_i))

    # run matching algorithm
    matching_i <-
      safely_matchit(
        formula = matching_formula,
        data = matching_candidates_i,
        method = "nearest", distance = "glm", # these two options don't really do anything because we only want exact + caliper matching
        replace = FALSE,
        estimand = "ATT",
        exact = exact_variables,
        caliper = caliper_variables, std.caliper=FALSE,
        m.order = "data", # data is sorted on (effectively random) patient ID
        #verbose = TRUE,
        ratio = 1L # irritatingly you can't set this for "exact" method, so have to filter later
      )[[1]]


    if(is.null(matching_i) | already_stopped) {
      message("Terminating trial sequence at trial ", trial, " - No exact matches found.")
      already_stopped <- TRUE
      next
    }
    # summary info for recruited people
    # - one row per person
    # - match_id is within matching_i
    data_matched_i <-
      as.data.frame(matching_i$X) %>%
      add_column(
        match_id = matching_i$subclass,
        treated = matching_i$treat,
        patient_id = matching_candidates_i$patient_id,
        weight = matching_i$weights,
        trial_time = trial_time,
      ) %>%

      filter(!is.na(match_id)) %>% # remove unmatched people. equivalent to weight != 0
      arrange(match_id, desc(treated)) %>%
      left_join(
        matching_candidates_i %>% select(patient_id, starts_with("tte_")),
        by = "patient_id"
      ) %>%
      group_by(match_id) %>%
      mutate(
        tte_recruitment = trial_time,
        tte_controlistreated = tte_vax3[treated==0],
        tte_matchcensor = pmin(tte_censor, tte_controlistreated, na.rm=TRUE),
      ) %>%
      ungroup()

    n_treated_matched <- sum(data_matched_i$treated)

    if(n_treated_matched < (0.1*n_treated_all) | already_stopped) {
      message("Terminating trial sequence at trial ", trial, " - Only ", n_treated_matched, "boosted people out of ", n_treated_all, " (", n_treated_matched*100/n_treated_all, "%) had a match.")
      already_stopped <- TRUE
      next
    }

    data_matched <- bind_rows(data_matched, data_matched_i)
    #update list of candidate controls to those who have not already been recruited
    candidate_ids0 <- candidate_ids0[!(candidate_ids0 %in% data_matched_i$patient_id)]


  }

  trial_time <- NULL

  data_matched <-
    data_matched %>%
    transmute(patient_id, match_id, matched=1L, control=1L-treated, trial_time, tte_recruitment, tte_controlistreated, tte_matchcensor)

  data_matchstatus <<-
    data_treated %>%
    left_join(data_eligible, by=c("patient_id", "trial_time")) %>%
    left_join(data_matched %>% filter(control==0L), by=c("patient_id", "trial_time")) %>%
    mutate(
      eligible = replace_na(eligible, 0L),
      matched = replace_na(matched, 0L),
      control = if_else(matched==1L, 0L, NA_integer_)
    ) %>%
    bind_rows(
      data_matched %>% filter(control==1L) %>% mutate(treated=0L)
    )
})

write_rds(data_matchstatus, fs::path(output_dir, "match_data_matchstatus.rds"), compress="gz")

# number of treated/controls per trial
controls_per_trial <- with(data_matchstatus %>% filter(matched==1), table(trial_time, treated))
logoutput_table(controls_per_trial)

# max trial date
max_trial_time <- max(data_matchstatus %>% filter(matched==1) %>% pull(trial_time), na.rm=TRUE)
logoutput("max trial day is ", max_trial_time)



## combine all data together as at recruitment date ----

status_recode <- c(`Boosted, ineligible` = "ineligible", `Boosted, eligible, unmatched`= "unmatched", `Boosted, eligible, matched` = "matched", `Control` = "control")

## create variables-at-time-zero dataset - one row per trial per arm per patient ----
data_merged <-
  data_matchstatus %>%
  mutate(
    status = fct_case_when(
      treated & !eligible ~ "ineligible",
      treated & eligible & !matched ~ "unmatched",
      treated & eligible & matched ~ "matched",
      control==1L ~ "control",
      TRUE ~ NA_character_
    )
  ) %>%
  #filter(treated==1L, matched==1L) %>%
  # add time-varying info as at recruitment date (= tte_trial)
  left_join(data_timevarying, by = c("patient_id")) %>%
  filter(
    trial_time < tstop,
    trial_time >= tstart
  ) %>%
  left_join(data_nontimevarying %>% select(patient_id, treated_within_recruitment_period), by="patient_id") %>%
  mutate(
    treated_within_recruitment_period = if_else(control %in% 1L, NA, treated_within_recruitment_period)
  ) %>%
  # add time-non-varying info
  left_join(data_baseline, by=c("patient_id")) %>%
  # remaining variables that combine both
  mutate(
    prior_covid_infection = prior_covid_infection0 | !is.na(mostrecent_anycovid),
    dayssince_anycovid = tstart - mostrecent_anycovid,
  )

logoutput_datasize(data_merged)

write_rds(data_merged, fs::path(output_dir, "match_data_merged.rds"), compress="gz")
