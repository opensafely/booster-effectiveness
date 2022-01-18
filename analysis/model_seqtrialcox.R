
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports processed data
# fits some Cox models with time-varying effects
#
# The script must be accompanied by one argument:
# `outcome` - the dependent variable in the regression model

# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----


# import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)


if(length(args)==0){
  # use for interactive testing
  removeobjects <- FALSE
  treatment <- "pfizer"
  outcome <- "admitted"
} else {
  removeobjects <- TRUE
  treatment <- args[[1]]
  outcome <- args[[2]]
}



## Import libraries ----
library('tidyverse')
library('here')
library('glue')
library('survival')

## Import custom user functions from lib

source(here("lib", "functions", "utility.R"))
source(here("lib", "functions", "survival.R"))


postbaselinecuts <- read_rds(here("lib", "design", "postbaselinecuts.rds"))

# create output directories ----

output_dir <- here("output", "models", "seqtrialcox", treatment, outcome)
fs::dir_create(output_dir)

## create special log file ----
cat(glue("## script info for {outcome} ##"), "  \n", file = fs::path(output_dir, glue("model_log.txt")), append = FALSE)

## functions to pass additional log info to seperate file
logoutput <- function(...){
  cat(..., file = fs::path(output_dir, glue("model_log.txt")), sep = "\n  ", append = TRUE)
  cat("\n", file = fs::path(output_dir, glue("model_log.txt")), sep = "\n  ", append = TRUE)
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
    file=fs::path(output_dir, glue("model_log.txt")),
    append=TRUE
  )
  cat("\n", file = fs::path(output_dir, glue("model_log.txt")), sep = "\n  ", append = TRUE)
}

## import globally defined study dates and convert to "Date"
study_dates <-
  jsonlite::read_json(path=here("lib", "design", "study-dates.json")) %>%
  map(as.Date)



## import metadata ----
events <- read_rds(here("lib", "design", "event-variables.rds"))
outcome_var <- events$event_var[events$event==outcome]

var_labels <- read_rds(here("lib", "design", "variable-labels.rds"))

# Prepare data ----

## one pow per patient ----
data_cohort <- read_rds(here("output", "data", "data_cohort.rds"))

logoutput_datasize(data_cohort)

data_tte <-
  data_cohort %>%
  transmute(
    patient_id,
    #day1_date = vax2_date + 84, # start follow-up on second vax day + 84
    day1_date = study_dates$studystart_date, # first trial date

    treatment_date = if_else(vax3_type==treatment, vax3_date, as.Date(NA)),
    competingtreatment_date = if_else(vax3_type!=treatment, vax3_date, as.Date(NA)),

    outcome_date = .[[glue("{outcome_var}")]],

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
    tte_censor = tte(day1_date-1, censor_date, censor_date, na.censor=TRUE),
    #ind_censor = censor_indicator(censor_date, censor_date),

    tte_treatment = tte(day1_date, treatment_date, censor_date, na.censor=TRUE),
    #ind_treatment = censor_indicator(treatment_date, censor_date),

    tte_outcome = tte(day1_date-1, outcome_date, censor_date, na.censor=TRUE),
    #ind_outcome = censor_indicator(outcome_date, censor_date),

    tte_stop = pmin(tte_censor, tte_outcome, na.rm=TRUE),

    #tte_vax3 = tte(day0_date, vax3_date, censor_date, na.censor=TRUE),
    #ind_vax3 = censor_indicator(vax3_date, censor_date),
    # vax3_type = if_else(
    #   !is.na(tte_vax3),
    #   as.character(vax3_type),
    #   ""
    # ),

  ) %>%
  # mutate(
  #   # re
  #   t1 = tte_censor>0,
  #   t2 = tte_treatment>=0 | is.na(tte_treatment),
  #   t3 = tte_outcome>0 | is.na(tte_outcome)
  # ) %>%
  filter(
    # remove anyone with competing vaccine on first trial day
    (competingtreatment_date>day1_date) | is.na(competingtreatment_date),
    #tte_censor>0,
    #tte_treatment>=0 | is.na(tte_treatment),
    #tte_outcome>0 | is.na(tte_outcome)
  ) %>%
  mutate(
    # convert tte variables (days since day0), to integer to save space
    across(starts_with("tte_"), as.integer),
    # convert logical to integer so that model coefficients print nicely in gtsummary methods
    across(where(is.logical), ~.x*1L)
  )
logoutput_datasize(data_tte)

data_baseline <-
  data_cohort %>%
  transmute(
    patient_id,
    age,
    sex,
    ethnicity_combined,
    imd_Q5,
    region,
    jcvi_group,
    rural_urban_group,
    prior_covid_infection,
    prior_tests_cat,
    multimorb,
    learndis,
    sev_mental,
    vax12_type,
    vax2_to_startdate =  study_dates$studystart_date - vax2_date,
  )
logoutput_datasize(data_baseline)

if(removeobjects) rm(data_cohort)

# one row per vaccination or outcome or censoring event ----
data_events <- local({

  ## person-time dataset of vaccination status + outcome
  data_events <-
    data_tte %>%
    select(patient_id) %>%
    tmerge(
      data1 = .,
      data2 = data_tte,
      id = patient_id,
      tstart = 0L,
      tstop = tte_stop,
      treatment_event = event(tte_treatment),
      treatment_status = tdc(tte_treatment),
      outcome_event = event(tte_outcome),
      censor_event = event(tte_censor)
    ) #%>%
    # tmerge(
    #   data1 = .,
    #   data2 = data_tte,
    #   id = patient_id,
    #   vax3_event = event(tte_vax3, vax3_type),
    #   vax3_status = tdc(tte_vax3, vax3_type),
    #   options= list(tdcstart="")
    # ) %>%
    # mutate(
    #   across(where(is.numeric), as.integer),
    #   vax3_event=factor(vax3_event, levels=c("", "pfizer", "az", "moderna")),
    #   vax3_status=factor(vax3_status, levels=c("", "pfizer", "az", "moderna"))
    # )

  data_events

})
logoutput_datasize(data_events)


## one row per time-varying covariate value change ----
data_timevarying <- local({

  data_positive_test <-
    read_rds(here("output", "data", "data_long_positive_test_dates.rds")) %>%
    inner_join(
      data_tte %>% select(patient_id, day1_date, censor_date, tte_stop),
      .,
      by =c("patient_id")
    )  %>%
    mutate(
      tte = tte(day1_date, date, censor_date, na.censor=TRUE),
    )

  data_admitted_unplanned <-
    read_rds(here("output", "data", "data_long_admitted_unplanned_dates.rds")) %>%
    pivot_longer(
      cols=c(admitted_date, discharged_date),
      names_to="status",
      values_to="date",
      values_drop_na = TRUE
    ) %>%
    inner_join(
      data_tte %>% select(patient_id, day1_date, censor_date, tte_stop),
      .,
      by =c("patient_id")
    ) %>%
    mutate(
      tte = tte(day1_date, date, censor_date, na.censor=TRUE) %>% as.integer(),
      admittedunplanned_status = if_else(status=="admitted_date", 1L, 0L)
    )

  data_admitted_planned <-
    read_rds(here("output", "data", "data_long_admitted_planned_dates.rds")) %>%
    pivot_longer(
      cols=c(admitted_date, discharged_date),
      names_to="status",
      values_to="date",
      values_drop_na = TRUE
    ) %>%
    inner_join(
      data_tte %>% select(patient_id, day1_date, censor_date, tte_stop),
      .,
      by =c("patient_id")
    ) %>%
    mutate(
      tte = tte(day1_date, date, censor_date, na.censor=TRUE) %>% as.integer(),
      admittedplanned_status = if_else(status=="admitted_date", 1L, 0L)
    )


  data_timevarying <- data_tte %>%
    arrange(patient_id) %>%
    select(patient_id) %>%
    tmerge(
      data1 = .,
      data2 = data_tte,
      id = patient_id,
      tstart = -1000L,
      tstop = tte_stop,
      treatment_status = tdc(tte_treatment)
    ) %>%
    tmerge(
      data1 = .,
      data2 = data_positive_test,
      id = patient_id,
      postest_mostrecent = tdc(tte,tte)
    ) %>%
    tmerge(
      data1 = .,
      data2 = data_admitted_unplanned,
      id = patient_id,
      admittedunplanned_status = tdc(tte, admittedunplanned_status),
      options = list(tdcstart = 0L)
    ) %>%
    tmerge(
      data1 = .,
      data2 = data_admitted_planned,
      id = patient_id,
      admittedplanned_status = tdc(tte, admittedplanned_status),
      options = list(tdcstart = 0L)
    ) %>%
    select(-id)

  data_timevarying
})
logoutput_datasize(data_timevarying)





# run matching for sequential trials ----

## sequential trial analysis is as follows:
# each daily trial includes all n people who were vaccinated on that day (treated=1) and
# a random sample of n controls (treated=0) who:
# - had not been vaccinated on or before that day (still at risk of treatment);
# - had not experienced the outcome (still at risk of outcome);
# - had not already been selected as a control in a previous trial
# for each trial, all covariates, including time-dependent covariates, are chosen as at the recruitment date and do not subsequently vary through follow-up
# within the construct of the model, there are no time-dependent variables, only time-dependent treatment effects (modelled as piecewise constant hazards)


# function to get sample non-treated without replacement over time
sample_untreated <- function(treatment, censor, id, max_trial_day=NULL, min_arm_size=1L, idname="patient_id"){
  # for each time point:
  # TRUE if treatment occurs
  # TRUE with probability of `n/sum(event==FALSE & not-already-selected)` if outcome has not occurred
  # based on `id` to ensure consistency of samples

  # `treatment` is an integer giving the event time for treatment. NA if no treatment before outcome / censoring
  # `censor` is an integer giving the time to end of followup/censoring. There should not be any NAs.
  # `id` is an identifier with the following properties:
  # - a) consistent between cohort extracts
  # - b) unique
  # - c) completely randomly assigned (no correlation with practice ID, age, registration date, etc etc) which should be true as based on hash of true IDs
  # - d) is an integer strictly greater than zero
  # `max_trial_day` is maximum trial day (ie last recruitment day). select controls up to and including this time


  # set max trial day and define trial days
  maxday <- if(is.null(max_trial_day)) max(treatment, 0L, na.rm=TRUE) else(max_trial_day)
  trials <- seq_len(maxday)

  # set candidate control ids
  candidate0ids <- id

  dat <-
    tidyr::expand_grid(
      id=id,
      treated=c(0L,1L)
    ) %>%
    dplyr::mutate(
      trial_time=NA_integer_,
      #weight=NA_real_
    )

  for(trial in trials){
    trial_time <- trial-1 # represent on time-to-event-since-start-date scale (= time to trial)
    # recruit participants for trial
    # treated participants
    trial_ids1 <- id[(treatment %in% trial_time) & (censor > trial_time)]
    n_treated <- length(trial_ids1)
    if(n_treated < min_arm_size) {
      message("Number of treated people for trial=",trial," is less than ", min_arm_size, ". Skipping this trial.")
      next
    }
    # candidate controls (anyone who hasn't been treated yet (treatment>trial_time), censored yet (censor>trial_time), and anyone who hasn't already been selected as a control (candidate0ids from trial-1))
    candidate0ids <- id[ (censor>trial_time) & ((treatment > trial_time) | is.na(treatment)) & (id %in% candidate0ids)]
    # actual controls - select first n candidates according to ranked id
    trial_ids0 <- candidate0ids[dplyr::dense_rank(candidate0ids)<=n_treated]

    if(length(trial_ids0) != n_treated) {
      message("not enough remaining untreated candidates for trial=",trial,". Outputting samples up to trial=",trial-1, ".")
      break
    }

    dati <- tibble::tibble(
      id = c(trial_ids1, trial_ids0),
      treated = c(rep(1L,n_treated), rep(0L,n_treated)),
      trial_timet = trial_time,
    )

    # remove already sampled individuals from list of candidate samples
    candidate0ids <- candidate0ids[!(candidate0ids %in% dati$id)]

    dat <- dplyr::left_join(dat, dati, by=c("id", "treated")) %>%
      dplyr::mutate(
        trial_time=dplyr::coalesce(trial_time, trial_timet),
      ) %>%
      dplyr::select(
        -trial_timet,
      )
  }

  names(dat)[names(dat) == "id"] <- idname
  dat
}


## strata loop ----
# match controls to boosted participants based on
# jcvi group, region, and doses 1 and 2


strata_variables <- c("jcvi_group", "vax12_type", "region")

strata <-
data_baseline %>%
  group_by(across(all_of(strata_variables))) %>%
  summarise(
    n=n(),
    .groups="drop"
  ) %>%
  mutate(
    strata_id = row_number(),
    strata_name = paste(!!!syms(strata_variables), sep=" ")
  )

data_samples0 <- local({

  samples0 <- NULL

  for(id in strata$strata_id){

    stratum <- filter(strata, strata_id==id)

    message(stratum$strata_name)

    tte_stratum <-
      stratum %>%
      left_join(
        data_baseline,
        by=strata_variables
      ) %>%
      select(patient_id) %>%
      left_join(
        data_tte,
        by="patient_id"
      )
    samples_stratum <-
      sample_untreated(
        tte_stratum$tte_treatment,
        tte_stratum$tte_stop,
        tte_stratum$patient_id
      ) %>%
      #filter(!is.na(trial_time)) %>%
      left_join(stratum, ., by=character())

    samples0 <- bind_rows(samples0, samples_stratum)
  }
  samples0
})

# choose treated and their controls
# data_samples0 <- sample_untreated(
#   data_tte$tte_treatment,
#   data_tte$tte_stop,
#   data_tte$patient_id
# )

data_samples <-
  data_samples0 %>%
  filter(!is.na(trial_time)) %>%
  left_join(
    data_tte %>% select(patient_id, starts_with("tte")),
    by=c("patient_id")
  ) %>%
  mutate(
    trial_day = trial_time+1,
    treated_patient_id = paste0(treated, "_", patient_id),
    tte_recruitment = trial_time,
    tte_stop = if_else(treated==1L, tte_stop, pmin(tte_stop, tte_treatment, na.rm=TRUE))
  )


# number of treated/controls per trial
controls_per_trial <- table(data_samples$trial_day, data_samples$treated)
logoutput_table(controls_per_trial)

# max trial date
max_trial_day <- max(data_samples$trial_day, na.rm=TRUE)
logoutput("max trial day is ", max_trial_day)


# create analysis dataset - one row per trial per arm per patient per follow-up week
data_seqtrialcox <- local({
  data_st0 <-
    tmerge(
      data1 = data_samples,
      data2 = data_samples,
      id = treated_patient_id,
      tstart = tte_recruitment,
      tstop = tte_stop
    ) %>%
    select(-id, -starts_with("tte")) %>%

    # add time-varying info as at recruitment date (= tte_trial)
    left_join(
      data_timevarying %>% rename(tstart2 = tstart, tstop2 = tstop),
      by = c("patient_id")
    ) %>%
    filter(
      trial_time < tstop2,
      trial_time >= tstart2
    ) %>%
    select(-tstart2, -tstop2) %>%

    # add time-non-varying info
    left_join(
      data_baseline %>% select(-all_of(strata_variables)),
      by=c("patient_id")
    ) %>%

    # remaining variables that combine both
    mutate(
      vax2_dayssince = vax2_to_startdate+trial_time,
      postest_dayssince = tstart - postest_mostrecent,
      postest_status = fct_case_when(
        is.na(postest_dayssince) & !prior_covid_infection ~ "No previous infection",
        between(postest_dayssince, 0, 21) ~ "Positive test <= 21 days ago",
        postest_dayssince>21 | prior_covid_infection ~ "Positive test > 21 days ago",
        TRUE ~ NA_character_
      ),
    )

  ## create treatment timescale variables ----

  # one row per patient per post-recruitment split time
  fup_split <-
    data_samples %>%
    uncount(weights = length(postbaselinecuts)-1, .id="period_id") %>%
    mutate(
      fup_time = postbaselinecuts[period_id],
      fup_period = timesince_cut(fup_time, postbaselinecuts-1),
      trial_time = trial_time + fup_time
    ) %>%
    droplevels() %>%
    select(
      patient_id, treated, treated_patient_id, period_id, trial_time, fup_time,
      fup_period
   )

  # add post-recruitment periods to data
  data_st <-
    # re-initialise tmerge object
    tmerge(
      data1 = data_st0,
      data2 = data_samples,
      id = treated_patient_id,
      tstart = trial_time,
      tstop = tte_stop,
      ind_outcome = event(tte_outcome)
    ) %>%
    # add post-recruitment periods
    tmerge(
      data1 = .,
      data2 = fup_split,
      id = treated_patient_id,
      fup_period = tdc(trial_time, fup_period),
      treated_period = tdc(trial_time, period_id)
    ) %>%
    mutate(
      id = NULL,
      # time-zero is recruitment day
      tstart = tstart - trial_time,
      tstop = tstop - trial_time
    ) %>%
    fastDummies::dummy_cols(select_columns = c("treated_period"), remove_selected_columns=TRUE) %>%
    mutate(
      across(
        starts_with("treated_period"),
        ~if_else(treated==1, .x, 0L)
      )
    )

  data_st

})
logoutput_datasize(data_seqtrialcox)

write_rds(data_seqtrialcox, fs::path(output_dir, "model_data_seqtrialcox.rds"))

# outcome frequency
outcomes_per_treated <- table(days = data_seqtrialcox$fup_period, outcome=data_seqtrialcox$ind_outcome, treated=data_seqtrialcox$treated)
logoutput_table(outcomes_per_treated)

## define model formulae ----

treated_period_variables <- data_seqtrialcox %>% select(starts_with("treated_period")) %>% names()

# unadjusted
formula_vaxonly <- as.formula(
  str_c(
    "Surv(tstart, tstop, ind_outcome) ~ ",
    str_c(treated_period_variables, collapse = " + ")
  )
)

#formula_vaxonly <- Surv(tstart, tstop, ind_outcome) ~ treated:strata(fup_period)

# cox stratification
formula_strata <- . ~ . +
  strata(trial_day) +
  strata(region) +
  strata(jcvi_group) +
  strata(vax12_type)

formula_demog <- . ~ . +
  poly(age, degree=2, raw=TRUE) +
  sex +
  imd_Q5 +
  ethnicity_combined

formula_clinical <- . ~ . +
  vax2_dayssince +
  prior_covid_infection +
  prior_tests_cat +
  multimorb +
  learndis +
  sev_mental

formula_timedependent <- . ~ . +
  postest_status +
  admittedunplanned_status +
  admittedplanned_status


formula_remove_outcome = . ~ .
if(outcome=="postest"){
  formula_remove_outcome = . ~ . - postest_status
}


formula0_pw <- formula_vaxonly
formula1_pw <- formula_vaxonly %>% update(formula_strata)
formula2_pw <- formula_vaxonly %>% update(formula_strata) %>% update(formula_demog)
formula3_pw <- formula_vaxonly %>% update(formula_strata) %>% update(formula_demog) %>% update(formula_clinical) %>% update(formula_timedependent) %>% update(formula_remove_outcome)


model_descr = c(
  "Unadjusted" = "0",
  "region- and trial-stratified" = "1",
  "Demographic adjustment" = "2",
  "Full adjustment" = "3"
)

opt_control <- coxph.control(iter.max = 30)

cox_model <- function(number, formula_cox){
  # fit a time-dependent cox model and output summary functions
  coxmod <- coxph(
    formula = formula_cox,
    data = data_seqtrialcox,
    #robust = TRUE,
    id = patient_id,
    na.action = "na.fail",
    control = opt_control
  )

  print(warnings())
  # logoutput(
  #   glue("model{number} data size = ", coxmod$n),
  #   glue("model{number} memory usage = ", format(object.size(coxmod), units="GB", standard="SI", digits=3L)),
  #   glue("convergence status: ", coxmod$info[["convergence"]])
  # )

  tidy <-
    broom.helpers::tidy_plus_plus(
      coxmod,
      exponentiate = FALSE
    ) %>%
    add_column(
      model = number,
      .before=1
    )

  glance <-
    broom::glance(coxmod) %>%
    add_column(
      model = number,
      convergence = coxmod$info[["convergence"]],
      ram = format(object.size(coxmod), units="GB", standard="SI", digits=3L),
      .before = 1
    )

  # remove data to save space (it's already saved above)
  coxmod$data <- NULL
  write_rds(coxmod, fs::path(output_dir, glue("model_obj{number}.rds")), compress="gz")

  lst(glance, tidy)
}

summary0 <- cox_model(0, formula0_pw)
summary1 <- cox_model(1, formula1_pw)
summary2 <- cox_model(2, formula2_pw)
summary3 <- cox_model(3, formula3_pw)

# combine results
model_glance <-
  bind_rows(
    summary0$glance,
    summary1$glance,
    summary2$glance,
    summary3$glance,
  ) %>%
  mutate(
    model_descr = fct_recode(as.character(model), !!!model_descr),
    outcome = outcome
  )
write_csv(model_glance, fs::path(output_dir, "model_glance.csv"))

model_tidy <-
  bind_rows(
    summary0$tidy,
    summary1$tidy,
    summary2$tidy,
    summary3$tidy,
  ) %>%
  mutate(
    model_descr = fct_recode(as.character(model), !!!model_descr),
    outcome = outcome
  )
write_csv(model_tidy, fs::path(output_dir, "model_tidy.csv"))


