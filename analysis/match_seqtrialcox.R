
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports processed data
# chooses matching sets for each sequential trial
# reports on matching quality
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

output_dir <- here("output", "models", "seqtrialcox", treatment)
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
    vax3_time = as.numeric(vax3_date - study_dates$studystart_date),
    cumuln = cumsum(n),
    # calculate rolling weekly average, anchored at end of period
    weight = lag(pmin(rolling_window, row_number()),rolling_window-1),
    rolling_avg = stats::filter(n, filter = rep(1, rolling_window), method="convolution", sides=1)/weight,
    recruit = select_recruitment_period(vax3_time, rolling_avg, recruitment_period_cutoff)
  ) %>%
  filter(vax3_time>=0)


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
    day0_date = study_dates$studystart_date-1, # day before the first trial date
    treatment_date = if_else(vax3_type==treatment, vax3_date, as.Date(NA)),
    competingtreatment_date = if_else(vax3_type!=treatment, vax3_date, as.Date(NA)),

    # person-time is up to and including censor date
    censor_date = pmin(
      dereg_date,
      competingtreatment_date-1, # -1 because we assume vax occurs at the start of the day
      vax4_date-1, # -1 because we assume vax occurs at the start of the day
      death_date,
      study_dates$studyend_date,
      na.rm=TRUE
    ),

    # assume vaccination occurs at the start of the day, and all other events occur at the end of the day.

    tte_censor = tte(day0_date, censor_date, censor_date, na.censor=TRUE),

    tte_treatment = tte(day0_date, treatment_date-1, censor_date-1, na.censor=TRUE), # -1 to move censoring forward by one day so that everybody has at least one day of follow up

    tte_stop = pmin(tte_censor, na.rm=TRUE),

  ) %>%
  filter(
    # remove anyone with competing vaccine on first trial day
    (competingtreatment_date-1>day0_date) | is.na(competingtreatment_date),
  ) %>%
  mutate(
    # convert tte variables (days since day0), to integer to save space
    across(starts_with("tte_"), as.integer),
    # convert logical to integer so that model coefficients print nicely in gtsummary methods
    across(where(is.logical), ~.x*1L)
  )

write_rds(data_tte, fs::path(output_dir, "match_data_tte.rds"))

logoutput_datasize(data_tte)

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


  max_trial_time <- study_dates$lastvax3_date - study_dates$studystart_date
  trials <- seq_len(max_trial_time+1)

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
        tte_stop >= trial_time,
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
        control_candidate = (((tte_treatment > trial_time) | is.na(tte_treatment)) & (patient_id %in% candidate_ids0))*1
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
        tte_controlistreated = tte_treatment[treated==0],
        tte_stop = pmin(tte_stop, tte_controlistreated, na.rm=TRUE),
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
    transmute(patient_id, match_id, matched=1L, control=1L-treated, trial_time, tte_recruitment, tte_controlistreated, tte_stop)

  data_summary <<-
    data_treated %>%
    left_join(data_eligible, by=c("patient_id", "trial_time")) %>%
    left_join(data_matched %>% filter(control==0L), by=c("patient_id", "trial_time")) %>%
    mutate(
      eligible = replace_na(eligible, 0L),
      matched = replace_na(matched, 0L),
      control = if_else(matched==1L, 0L, NA_integer_)
    ) %>%
    bind_rows(
      data_matched %>% filter(control==1L)
    )
})

write_rds(data_summary, fs::path(output_dir, "match_data_summary.rds"))

# number of treated/controls per trial
controls_per_trial <- with(data_summary %>% filter(matched==1), table(trial_time, treated))
logoutput_table(controls_per_trial)

# max trial date
max_trial_time <- max(data_summary %>% filter(matched==1) %>% pull(trial_time), na.rm=TRUE)
logoutput("max trial day is ", max_trial_time)






# combine matching dataset with all other variables required for modelling ----

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
    vax3_date,
    vax3_type,

  )
logoutput_datasize(data_baseline)

if(removeobjects) rm(data_cohort)


status_recode <- c(`Treated, ineligible` = "ineligible", `Treated, eligible, unmatched`= "unmatched", `Treated, eligible, matched` = "matched", `Control` = "control")

## create variables-at-time-zero dataset - one row per trial per arm per patient ----
data_merged_all <-
  data_summary %>%
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

# same but trial participants only
data_merged_matched <-
  data_merged_all %>%
  filter(matched==1L) %>%
  mutate(
    treated_patient_id = paste0(treated, "_", patient_id),
    fup = pmin(tte_stop - tte_recruitment, last(postbaselinecuts))
  )

logoutput_datasize(data_merged_matched)

write_rds(data_merged_matched, fs::path(output_dir, "match_data_merged.rds"))

if(removeobjects) rm(data_merged_matched)
if(removeobjects) rm(data_timevarying)

# matching coverage per trial / day of follow up


# matching coverage for boosted people
data_coverage <-
  data_merged_all %>%
  filter(treated==1L) %>%
  group_by(across(all_of(rolling_variables)), vax3_date) %>%
  summarise(
    n_treated=sum(treated, na.rm=TRUE),
    n_eligible=sum(eligible, na.rm=TRUE),
    n_matched=sum(matched, na.rm=TRUE)
  ) %>%
  mutate(
    n_unmatched = n_eligible - n_matched,
    n_ineligible = n_treated - n_eligible,
  ) %>%
  pivot_longer(
    cols = c(n_ineligible, n_unmatched, n_matched),
    names_to = "status",
    names_prefix = "n_",
    values_to = "n"
  ) %>%
  arrange(jcvi_group, vax12_type, vax3_date, status) %>%
  group_by(jcvi_group, vax12_type, vax3_date, status) %>%
  summarise(
    n = sum(n),
  ) %>%
  group_by(jcvi_group, vax12_type, status) %>%
  complete(
    vax3_date = full_seq(.$vax3_date, 1), # go X days before to
    fill = list(n=0)
  ) %>%
  ungroup() %>%
  mutate(
    cumuln = cumsum(n),
    status_descr = fct_recode(status, !!!status_recode[1:3])
  )

write_csv(data_coverage, fs::path(output_dir, "match_data_coverage.csv"))

# report matching info ----

day1_date <- study_dates$studystart_date

## candidate matching summary ----

## matching summary ----

# summary of matching, by treatment day
candidate_summary_trial <-
  data_summary %>%
  filter(treated==1L) %>%
  group_by(trial_time) %>%
  summarise(
    n_treated=sum(treated, na.rm=TRUE),
    n_eligible=sum(eligible, na.rm=TRUE),
    n_matched=sum(matched, na.rm=TRUE),
    n_unmatched=n_eligible-n_matched,
  ) %>%
  ungroup()


# summary of trial participants, by trial and treatment group
match_summary_trial <-
  data_merged_matched %>%
  group_by(trial_time, treated) %>%
  summarise(
    n=n(),
    fup_sum = sum(fup),
    fup_years = sum(fup)/365.25,
    fup_mean = mean(fup)
  ) %>%
  arrange(
    trial_time, treated
  ) %>%
  pivot_wider(
    id_cols = c(trial_time),
    names_from = treated,
    values_from = c(n, fup_sum, fup_years, fup_mean)
  ) %>%
  left_join(candidate_summary_trial, by="trial_time") %>%
  mutate(
    prop_matched_treated = n_1/n_treated,
    prop_matched_eligible = n_1/n_eligible,
    prop_eligible_treated = n_eligible/n_treated
  )

write_csv(match_summary_trial, fs::path(output_dir, "match_summary_trial.csv"))

# summary of trial participants, by treatment group
match_summary_treated <-
  data_merged_matched %>%
  group_by(treated) %>%
  summarise(
    n=n(),
    firstrecruitdate = min(tte_recruitment) + day1_date,
    lastrecruitdate = max(tte_recruitment) + day1_date,
    fup_sum = sum(fup),
    fup_years = sum(fup)/365.25,
    fup_mean = mean(fup)
  )

write_csv(match_summary_treated, fs::path(output_dir, "match_summary_treated.csv"))


# summary of boosted people
candidate_summary <-
  data_summary %>%
  filter(treated==1L) %>%
  summarise(
    n_treated=sum(treated, na.rm=TRUE),
    n_eligible=sum(eligible, na.rm=TRUE),
    n_matched=sum(matched, na.rm=TRUE),
    n_unmatched=n_eligible-n_matched,
  )

# summary of matching, overall
match_summary <-
  data_merged_matched %>%
  summarise(
    n=n(),
    firstrecruitdate = min(tte_recruitment) + day1_date,
    lastrecruitdate = max(tte_recruitment) + day1_date,
    fup_sum = sum(fup),
    fup_years = sum(fup)/365.25,
    fup_mean = mean(fup)
  ) %>%
  bind_cols(candidate_summary) %>%
  mutate(
    prop_matched_treated = n_matched/n_treated,
    prop_matched_eligible = n_matched/n_eligible,
    prop_eligible_treated = n_eligible/n_treated
  )

write_csv(match_summary, fs::path(output_dir, "match_summary.csv"))



## matching coverage ----

xmin <- min(data_coverage$vax3_date )
xmax <- max(data_coverage$vax3_date )+1

plot_coverage_n <-
  data_coverage %>%
  ggplot()+
  geom_col(
    aes(
      x=vax3_date+0.5,
      y=n,
      group=status,
      fill=status,
      colour=NULL
    ),
    position=position_stack(),
    alpha=0.8,
    width=1
  )+
  geom_rect(xmin=xmin, xmax= xmax+1, ymin=0, ymax=6, fill="grey", colour="transparent")+
  facet_grid(rows = vars(jcvi_group), cols = vars(vax12_type))+
  scale_x_date(
    breaks = unique(lubridate::ceiling_date(data_coverage$vax3_date, "1 month")),
    limits = c(lubridate::floor_date((xmin), "1 month"), NA),
    labels = scales::label_date("%d/%m"),
    expand = expansion(add=1),
  )+
  scale_y_continuous(
    labels = scales::label_number(accuracy = 1, big.mark=","),
    expand = expansion(c(0, NA))
  )+
  scale_fill_brewer(type="qual", palette="Set2")+
  scale_colour_brewer(type="qual", palette="Set2")+
  labs(
    x="Date",
    y="Booster vaccines per day",
    colour=NULL,
    fill=NULL,
    alpha=NULL
  ) +
  theme_minimal()+
  theme(
    axis.line.x.bottom = element_line(),
    axis.text.x.top=element_text(hjust=0),
    strip.text.y.right = element_text(angle = 0),
    axis.ticks.x=element_line(),
    legend.position = "bottom"
  )+
  NULL

plot_coverage_n

#ggsave(plot_coverage_n, filename="match_coverage_count.svg", path=output_dir)
ggsave(plot_coverage_n, filename="match_coverage_count.png", path=output_dir)
ggsave(plot_coverage_n, filename="match_coverage_count.pdf", path=output_dir)


plot_coverage_cumuln <-
  data_coverage %>%
  ggplot()+
  geom_col(
    aes(
      x=vax3_date+0.5,
      y=cumuln,
      group=status,
      fill=status,
      colour=NULL
    ),
    position=position_stack(),
    alpha=0.8,
    width=1
  )+
  geom_rect(xmin=xmin, xmax= xmax+1, ymin=0, ymax=6, fill="grey", colour="transparent")+
  facet_grid(rows = vars(jcvi_group), cols = vars(vax12_type))+
  scale_x_date(
    breaks = unique(lubridate::ceiling_date(data_coverage$vax3_date, "1 month")),
    limits = c(lubridate::floor_date((xmin), "1 month"), NA),
    labels = scales::label_date("%d/%m"),
    expand = expansion(add=1),
  )+
  scale_y_continuous(
    labels = scales::label_number(accuracy = 1, big.mark=","),
    expand = expansion(c(0, NA))
  )+
  scale_fill_brewer(type="qual", palette="Set2")+
  scale_colour_brewer(type="qual", palette="Set2")+
  labs(
    x="Date",
    y="Cumulative booster vaccines",
    colour=NULL,
    fill=NULL,
    alpha=NULL
  ) +
  theme_minimal()+
  theme(
    axis.line.x.bottom = element_line(),
    axis.text.x.top=element_text(hjust=0),
    strip.text.y.right = element_text(angle = 0),
    axis.ticks.x=element_line(),
    legend.position = "bottom"
  )+
  NULL

plot_coverage_cumuln

#ggsave(plot_coverage_cumuln, filename="match_coverage_stack.svg", path=output_dir)
ggsave(plot_coverage_cumuln, filename="match_coverage_stack.png", path=output_dir)
ggsave(plot_coverage_cumuln, filename="match_coverage_stack.pdf", path=output_dir)




# table 1 style baseline characteristics ----

library('gt')
library('gtsummary')

var_labels <- list(
  N  ~ "Total N",
  status_descr ~ "Recruitment status",
  vax12_type_descr ~ "Primary vaccination course (doses 1 and 2)",
  #age ~ "Age",
  ageband ~ "Age",
  sex ~ "Sex",
  ethnicity_combined ~ "Ethnicity",
  imd_Q5 ~ "IMD",
  region ~ "Region",
  #rural_urban_group ~ "Rural/urban category",
  cev ~ "Clinically extremely vulnerable",

  sev_obesity ~ "Body Mass Index > 40 kg/m^2",

  chronic_heart_disease ~ "Chronic heart disease",
  chronic_kidney_disease ~ "Chronic kidney disease",
  diabetes ~ "Diabetes",
  chronic_liver_disease ~ "Chronic liver disease",
  chronic_resp_disease ~ "Chronic respiratory disease",
  asthma ~ "Asthma",
  chronic_neuro_disease ~ "Chronic neurological disease",

  #multimorb ~ "Morbidity count",
  immunosuppressed ~ "Immunosuppressed",
  asplenia ~ "Asplenia or poor spleen function",
  learndis ~ "Learning disabilities",
  sev_mental ~ "Serious mental illness",

  prior_tests_cat ~ "Number of SARS-CoV-2 tests prior to start date",

  prior_covid_infection ~ "Prior documented SARS-CoV-2 infection",
  status_hospplanned ~ "In hospital (planned admission)"
) %>%
  set_names(., map_chr(., all.vars))


tab_summary_baseline <-
  data_merged_all %>%
  mutate(
    N = 1L,
    status_descr = fct_recode(status, !!!status_recode),
  ) %>%
  select(
    status_descr,
    all_of(names(var_labels)),
  ) %>%
  tbl_summary(
    by = status_descr,
    label = unname(var_labels[names(.)]),
    statistic = list(N = "{N}")
  ) %>%
  modify_footnote(starts_with("stat_") ~ NA) %>%
  modify_header(stat_by = "**{level}**") %>%
  bold_labels()

tab_summary_baseline_redacted <- redact_tblsummary(tab_summary_baseline, 5, "[REDACTED]")

raw_stats <- tab_summary_baseline_redacted$meta_data %>%
  select(var_label, df_stats) %>%
  unnest(df_stats)

write_csv(tab_summary_baseline_redacted$table_body, fs::path(output_dir, "match_table1.csv"))
write_csv(tab_summary_baseline_redacted$df_by, fs::path(output_dir, "match_table1by.csv"))
gtsave(as_gt(tab_summary_baseline_redacted), fs::path(output_dir, "match_table1.html"))



# flowchart ----


data_processed <- read_rds(here("output", "data", "data_processed.rds"))


data_criteria <-
  left_join(
    data_processed,
    data_merged_all %>%
      filter(treated==1L) %>%
      transmute(
        patient_id,
        trial_time,
        matched,
        status_hospunplanned,
        status_hospplanned,
        mostrecent_anycovid = replace_na(mostrecent_anycovid, 10000000),
        status_hospunplanned,
        treated_within_recruitment_period
      ),
    by = "patient_id"
  ) %>%
  left_join(
    data_merged_all %>%
      filter(control==1L) %>%
      transmute(
        patient_id,
        control,
      ),
    by = "patient_id"
  ) %>%
  transmute(
    patient_id,
    vax3_treatment = vax3_type == treatment,
    has_age = !is.na(age),
    has_sex = !is.na(sex) & !(sex %in% c("I", "U")),
    has_imd = !is.na(imd),
    has_ethnicity = !is.na(ethnicity_combined),
    has_region = !is.na(region),
    #has_msoa = !is.na(msoa),
    isnot_hscworker = !hscworker,
    isnot_carehomeresident = !care_home_combined,
    isnot_endoflife = !endoflife,
    isnot_housebound = !housebound,
    vax1_afterfirstvaxdate = case_when(
      (vax1_type=="pfizer") & (vax1_date >= study_dates$firstpfizer_date) ~ TRUE,
      (vax1_type=="az") & (vax1_date >= study_dates$firstaz_date) ~ TRUE,
      (vax1_type=="moderna") & (vax1_date >= study_dates$firstmoderna_date) ~ TRUE,
      TRUE ~ FALSE
    ),
    competingtreatment_date = if_else(vax3_type!=treatment, vax3_date, as.Date(NA)),

    # person-time is up to and including censor date
    censor_date = pmin(
      dereg_date,
      competingtreatment_date-1, # -1 because we assume vax occurs at the start of the day
      vax4_date-1, # -1 because we assume vax occurs at the start of the day
      death_date,
      study_dates$studyend_date,
      na.rm=TRUE
    ),
    vax2_beforelastvaxdate = !is.na(vax2_date) & (vax2_date <= study_dates$lastvax2_date),
    vax3_afterstudystartdate = (vax3_date >= study_dates$studystart_date) | is.na(vax3_date),
    vax3_beforelastvaxdate = (vax3_date <= study_dates$lastvax3_date) & !is.na(vax3_date),
    vax3_beforecensordate = (vax3_date-1 < censor_date) & !is.na(vax3_date),
    vax12_homologous = vax1_type==vax2_type,
    has_vaxgap12 = vax2_date >= (vax1_date+17), # at least 17 days between first two vaccinations
    has_vaxgap23 = vax3_date >= (vax2_date+17) | is.na(vax3_date), # at least 17 days between second and third vaccinations
    has_knownvax1 = vax1_type %in% c("pfizer", "az"),
    has_knownvax2 = vax2_type %in% c("pfizer", "az"),
    has_expectedvax3type = vax3_type %in% c("pfizer", "moderna"),

    has_norecentcovid = !((mostrecent_anycovid>= trial_time-90) & (mostrecent_anycovid<= trial_time)),
    isnot_inhospital = status_hospunplanned==0L,

    isnot_unusual = treated_within_recruitment_period,

    is_treatedandmatched = matched %in% 1L,

    is_control = control %in% 1L
)



data_flowchart <- data_criteria %>%
  transmute(
    c0 = vax1_afterfirstvaxdate & vax2_beforelastvaxdate & vax3_treatment & vax3_afterstudystartdate & vax3_beforelastvaxdate & vax3_beforecensordate,
    #c1_1yearfup = c0_all & (has_follow_up_previous_year),
    c1 = c0 & (has_age & has_sex & has_imd & has_ethnicity & has_region),
    c2 = c1 & (has_vaxgap12 & has_vaxgap23 & has_knownvax1 & has_knownvax2 & vax12_homologous),
    c3 = c2 & (isnot_hscworker ),
    c4 = c3 & (isnot_carehomeresident & isnot_endoflife & isnot_housebound),
    c5 = c4 & (has_norecentcovid),
    c6 = c5 & (isnot_inhospital),
    c7 = c6 & (isnot_unusual),
    c8 = c7 & (is_treatedandmatched),
    c9 = c8 & (is_control)
  ) %>%
  summarise(
    across(.fns=sum)
  ) %>%
  pivot_longer(
    cols=everything(),
    names_to="criteria",
    values_to="n"
  ) %>%
  mutate(
    n_exclude = lag(n) - n,
    pct_exclude = n_exclude/lag(n),
    pct_all = n / first(n),
    pct_step = n / lag(n),
    crit = str_extract(criteria, "^c\\d+"),
    criteria = fct_case_when(
      crit == "c0" ~ "Aged 18+ and recieved booster dose between 16 September and 1 December 2021 inclusive", # paste0("Aged 18+\n with 2 doses on or before ", format(study_dates$lastvax2_date, "%d %b %Y")),
      crit == "c1" ~ "  with no missing demographic information",
      crit == "c2" ~ "  with homologous primary vaccination course of BNT162b2 or ChAdOx1-S",
      crit == "c3" ~ "  and not a HSC worker",
      crit == "c4" ~ "  and not a care/nursing home resident, end-of-life or housebound",
      crit == "c5" ~ "  and no evidence of SARS-CoV-2 infection within 90 days of boosting",
      crit == "c6" ~ "  and not in hospital",
      crit == "c7" ~ "  and not boosted at an unusual time given region, priority group, and second dose date",
      crit == "c8" ~ "  and successfully matched to unboosted control",
      crit == "c9" ~ "  and also selected as a control in an earlier trial",
      TRUE ~ NA_character_
    )
  )
write_csv(data_flowchart, fs::path(output_dir, "match_data_flowchart.rds"))

