
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports merged matching data
# adds outcome variable and restricts follow-up
# fits the Cox models with time-varying effects
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
  outcome <- "covidadmitted"
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
source(here("lib", "functions", "redaction.R"))

postbaselinecuts <- read_rds(here("lib", "design", "postbaselinecuts.rds"))
matching_variables <- read_rds(here("lib", "design", "matching_variables.rds"))

if(Sys.getenv("OPENSAFELY_BACKEND") %in% c("", "expectations")){
  recruitment_period_cutoff <- 0.1
} else{
  recruitment_period_cutoff <- read_rds(here("lib", "design", "recruitment_period_cutoff.rds"))
}


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


data_merged <- read_rds(here("output", "models", "seqtrialcox", treatment, "merge_data_merged.rds"))
data_tte <- read_rds(here("output", "models", "seqtrialcox", treatment, "match_data_tte.rds"))

## create outcome variables ----

data_timevaryingoutcomes <- local({

  data_join <-
    data_tte %>%
    select(patient_id, day1_date, censor_date, tte_stop)

  data_outcome <-
    read_rds(here("output", "data", glue("data_long_{outcome}_dates.rds"))) %>%
    inner_join(data_join, ., by =c("patient_id")) %>%
    mutate(
      tte = tte(day1_date-1, date, censor_date, na.censor=TRUE),
    )

  data_timevaryingoutcomes <-
    tmerge(
      data1 = data_tte %>% select(patient_id),
      data2 = data_tte,
      id = patient_id,
      tstart = 0L,
      tstop = tte_stop
    ) %>%
    tmerge(
      data1 = .,
      data2 = data_outcome,
      id = patient_id,
      ind_outcome = event(tte),
      tte_outcome = event(tte, tte)
    ) %>%
    mutate(
      tte_outcome = if_else(ind_outcome==1L, as.integer(tte_outcome), NA_integer_),
      ind_outcome = NULL
    )

  data_timevaryingoutcomes

})


## combine outcome variables with variables-at-baseline ----

data_seqtrialcox <- local({

  data_st0 <-
    data_merged %>%
    left_join(
      data_timevaryingoutcomes %>% rename(tstart2 = tstart, tstop2 = tstop),
      by = c("patient_id")
    ) %>%
    filter(
      tstart < tstop2,
      tstart >= tstart2
    ) %>%
    select(-tstart2, -tstop2)

  # one row per patient per post-recruitment split time
  fup_split <-
    data_merged %>%
    uncount(weights = length(postbaselinecuts)-1, .id="period_id") %>%
    mutate(
      fup_time = postbaselinecuts[period_id],
      fup_period = timesince_cut(fup_time, postbaselinecuts-1),
      tte_fup = tte_recruitment + fup_time
    ) %>%
    droplevels() %>%
    select(
      patient_id, treated, treated_patient_id, period_id, tte_fup, fup_time,
      fup_period
    )

  # add post-recruitment periods to data
  data_st <-
    # re-initialise tmerge object and add outcome
    tmerge(
      data1 = data_st0,
      data2 = data_st0,
      id = treated_patient_id,
      tstart = tte_recruitment,
      tstop = pmin(tte_stop, tte_outcome, last(postbaselinecuts), na.rm=TRUE),
      ind_outcome = event(tte_outcome)
    ) %>%
    # add post-recruitment periods
    tmerge(
      data1 = .,
      data2 = fup_split,
      id = treated_patient_id,
      fup_period = tdc(tte_fup, fup_period),
      treated_period = tdc(tte_fup, period_id)
    ) %>%
    mutate(
      id = NULL,
      # time-zero is recruitment day
      tstart_calendar = tstart,
      tstop_calendar = tstop,
      tstart = tstart - tte_recruitment,
      tstop = tstop - tte_recruitment
    ) %>%
    fastDummies::dummy_cols(select_columns = c("treated_period"), remove_selected_columns = TRUE) %>%
    mutate(
      across(
        starts_with("treated_period_"),
        ~if_else(treated==1, .x, 0L)
      )
    )

  data_st
})


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
  #strata(jcvi_group) +
  strata(vax12_type)

formula_demog <- . ~ . +
  poly(age, degree=2, raw=TRUE) +
  sex +
  imd_Q5 +
  ethnicity_combined

formula_clinical <- . ~ . +
  prior_covid_infection +
  prior_tests_cat +
  multimorb +
  learndis +
  sev_mental +
  immunosuppressed +
  asplenia

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




## pre-flight checks ----

### event counts within each covariate level ----


tbltab0 <-
  data_seqtrialcox %>%
  select(ind_outcome, treated, fup_period, all_of(all.vars(formula3_pw)), all_of(matching_variables), -starts_with("treated_period")) %>%
  select(-age, -vax2_week, -tstart, -tstop) %>%
  mutate(
    across(
      where(is.numeric),
      ~as.character(.)
    ),
  )


event_counts <-
  tbltab0 %>%
  split(.["ind_outcome"]) %>%
  map(~select(., -ind_outcome)) %>%
  map(
    function(data){
      map(data, redacted_summary_cat, redaction_threshold=0) %>%
        bind_rows(.id="variable") %>%
        select(-redacted, -pct_nonmiss)
    }
  ) %>%
  bind_rows(.id = "event") %>%
  pivot_wider(
    id_cols=c(variable, .level),
    names_from = event,
    names_glue = "event{event}_{.value}",
    values_from = c(n, pct)
  )

write_csv(event_counts, fs::path(output_dir, "model_preflight.csv"))

### event counts within each follow up period ----

event_counts_period <-
  tbltab0 %>%
  split(.[c("fup_period", "ind_outcome")], sep="..") %>%
  map(~select(., -fup_period, -ind_outcome)) %>%
  map(
    function(data){
      map(data, redacted_summary_cat, redaction_threshold=0) %>%
        bind_rows(.id="variable") %>%
        select(-redacted, -pct_nonmiss)
    }
  ) %>%
  bind_rows(.id = "period..outcome") %>%
  separate(period..outcome, into = c("period", "event"), sep="\\.\\.") %>%
  pivot_wider(
    id_cols=c(variable, .level),
    names_from = c("period", "event"),
    names_glue = "days {period}.{event}_{.value}",
    values_from = c(n, pct)
  )

write_csv(event_counts_period, fs::path(output_dir, "model_preflight_period.csv"))

### event counts within strata levels ----

event_counts_strata <-
  data_seqtrialcox %>%
  mutate(
    strata = strata(!!!syms(all.vars(formula_strata)[-1]))
  ) %>%
  select(ind_outcome, strata, fup_period) %>%
  split(.["ind_outcome"]) %>%
  map(~select(., -ind_outcome)) %>%
  map(
    function(data){
      map(data, redacted_summary_cat, redaction_threshold=0) %>%
        bind_rows(.id="variable") %>%
        select(-redacted, -pct_nonmiss)
    }
  ) %>%
  bind_rows(.id = "event") %>%
  pivot_wider(
    id_cols=c(variable, .level),
    names_from = event,
    names_glue = "event{event}_{.value}",
    values_from = c(n, pct)
  )

write_csv(event_counts_strata, fs::path(output_dir, "model_preflight_strata.csv"))




# gt(
#   event_counts_treated,
#   groupname_col="variable",
# ) %>%
#   tab_spanner_delim("_") %>%
#   fmt_number(
#     columns = ends_with(c("pct")),
#     decimals = 1,
#     scale_by=100,
#     pattern = "({x})"
#   ) %>%
#   gtsave(
#     filename = glue("model_preflight.html"),
#     path=output_dir
#   )


## fit models ----


opt_control <- coxph.control(iter.max = 30)

cox_model <- function(number, formula_cox){
  # fit a time-dependent cox model and output summary functions
  coxmod <- coxph(
    formula = formula_cox,
    data = data_seqtrialcox,
    robust = TRUE,
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
    model_descr = fct_recode(as.character(model), !!!model_descr)
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
    model_descr = fct_recode(as.character(model), !!!model_descr)
  )
write_csv(model_tidy, fs::path(output_dir, "model_tidy.csv"))


