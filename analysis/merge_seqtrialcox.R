
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports matching data
# adds info as at recruitment date
# reports baseline characteristics
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
library('gt')
library('gtsummary')

## Import custom user functions from lib

source(here("lib", "functions", "utility.R"))
source(here("lib", "functions", "survival.R"))
source(here("lib", "functions", "redaction.R"))

## create output directories ----

output_dir <- here("output", "models", "seqtrialcox", treatment)
fs::dir_create(output_dir)

## create special log file ----
cat(glue("## script info for {treatment} ##"), "  \n", file = fs::path(output_dir, glue("merge_log.txt")), append = FALSE)

## functions to pass additional log info to seperate file
logoutput <- function(...){
  cat(..., file = fs::path(output_dir, glue("merge_log.txt")), sep = "\n  ", append = TRUE)
  cat("\n", file = fs::path(output_dir, glue("merge_log.txt")), sep = "\n  ", append = TRUE)
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
    file=fs::path(output_dir, glue("merge_log.txt")),
    append=TRUE
  )
  cat("\n", file = fs::path(output_dir, glue("merge_log.txt")), sep = "\n  ", append = TRUE)
}


## import globally defined study dates and convert to "Date"
study_dates <-
  jsonlite::read_json(path=here("lib", "design", "study-dates.json")) %>%
  map(as.Date)

## import metadata ----
events <- read_rds(here("lib", "design", "event-variables.rds"))
var_labels <- read_rds(here("lib", "design", "variable-labels.rds"))
postbaselinecuts <- read_rds(here("lib", "design", "postbaselinecuts.rds"))
matching_variables <- read_rds(here("lib", "design", "matching_variables.rds"))


# Prepare data ----

## one pow per patient ----
data_cohort <- read_rds(here("output", "data", "data_cohort.rds"))

# compose modelling dataset ----

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
    rural_urban_group,
    prior_covid_infection,
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
    chronic_neuro_disease,
    immunosuppressed,
    asplenia,

    vax12_type,
    vax2_to_startdate =  study_dates$studystart_date - vax2_date,
    vax2_week,
    vax3_date,
    vax3_type,

  )

logoutput_datasize(data_baseline)

data_matched <-
  read_rds(here("output", "models", "seqtrialcox", treatment, "match_data_matched.rds")) %>%
  mutate(
    treated_patient_id = paste0(treated, "_", patient_id),
  )

data_tte <- read_rds(here("output", "models", "seqtrialcox", treatment, "match_data_tte.rds"))

# one row per vaccination or outcome or censoring event ----
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

logoutput_datasize(data_events)


## one row per time-varying covariate value change ----
data_timevarying <- local({

  data_join <-
    data_tte %>%
    select(patient_id, day1_date, censor_date, tte_stop)

  data_postest <-
    read_rds(here("output", "data", "data_long_postest_dates.rds")) %>%
    inner_join(data_join, ., by =c("patient_id")) %>%
    mutate(
      tte = tte(day1_date-1, date, censor_date, na.censor=TRUE),
    ) %>%
    filter(!is.na(tte))

  data_admitted_unplanned <-
    read_rds(here("output", "data", "data_long_admitted_unplanned_dates.rds")) %>%
    pivot_longer(
      cols=c(admitted_date, discharged_date),
      names_to="status",
      values_to="date",
      values_drop_na = TRUE
    ) %>%
    inner_join(data_join, ., by =c("patient_id")) %>%
    mutate(
      tte = tte(day1_date-1, date, censor_date, na.censor=TRUE) %>% as.integer(),
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
    inner_join(data_join, ., by =c("patient_id")) %>%
    mutate(
      tte = tte(day1_date-1, date, censor_date, na.censor=TRUE) %>% as.integer(),
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
      data2 = data_postest,
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
    mutate(id=NULL) # remove id column if created by tmerge (depedning on version of survival package)

  data_timevarying
})
logoutput_datasize(data_timevarying)

if(removeobjects) rm(data_cohort)


## create analysis dataset - one row per trial per arm per patient per follow-up week ----
data_merged <-
  tmerge(
    data1 = data_matched,
    data2 = data_matched,
    id = treated_patient_id,
    tstart = tte_recruitment,
    tstop = tte_stop
  ) %>%
  mutate(id=NULL) %>% # remove id column if created by tmerge (depending on version of survival package)

  # add time-varying info as at recruitment date (= tte_trial)
  left_join(
    data_timevarying %>% rename(tstart2 = tstart, tstop2 = tstop),
    by = c("patient_id")
  ) %>%
  filter(
    tstart < tstop2,
    tstart >= tstart2
  ) %>%
  select(-tstart2, -tstop2) %>%

  # add time-non-varying info
  left_join(
    data_baseline %>% select(-all_of(matching_variables)),
    by=c("patient_id")
  ) %>%

  # remaining variables that combine both
  mutate(
    vax2_dayssince = vax2_to_startdate+tte_recruitment,
    postest_dayssince = tstart - postest_mostrecent,
    postest_status = fct_case_when(
      is.na(postest_dayssince) & !prior_covid_infection ~ "No previous infection",
      between(postest_dayssince, 0, 21) ~ "Positive test <= 21 days ago",
      postest_dayssince>21 | prior_covid_infection ~ "Positive test > 21 days ago",
      TRUE ~ NA_character_
    ),
  )

logoutput_datasize(data_merged)

write_rds(data_merged, fs::path(output_dir, "merge_data_merged.rds"))








# table 1 style baseline characteristics ----

var_labels <- list(
  N  ~ "Total N",
  treated_descr ~ "Trial arm",
  vax12_type ~ "Primary vaccination course (doses 1 and 2)",
  age ~ "Age",
  ageband ~ "Age",
  sex ~ "Sex",
  ethnicity_combined ~ "Ethnicity",
  imd_Q5 ~ "IMD",
  region ~ "Region",
  rural_urban_group ~ "Rural/urban category",
  jcvi_group ~ "JCVI group",
  cev ~ "Clinically extremely vulnerable",

  sev_obesity ~ "Body Mass Index > 40 kg/m^2",

  chronic_heart_disease ~ "Chronic heart disease",
  chronic_kidney_disease ~ "Chronic kidney disease",
  diabetes ~ "Diabetes",
  chronic_liver_disease ~ "Chronic liver disease",
  chronic_resp_disease ~ "Chronic respiratory disease",
  chronic_neuro_disease ~ "Chronic neurological disease",

  multimorb ~ "Morbidity count",
  immunosuppressed ~ "Immunosuppressed",
  asplenia ~ "Asplenia or poor spleen function",
  learndis ~ "Learning disabilities",
  sev_mental ~ "Serious mental illness",



  prior_tests_cat ~ "Number of SARS-CoV-2 tests prior to start date",

  postest_status ~ "Positive test status",
  admittedunplanned_status ~ "In hospital (unplanned admission)",
  admittedplanned_status ~ "In hospital (planned admission)"
) %>%
  set_names(., map_chr(., all.vars))

tab_summary_baseline <-
  data_merged %>%
  mutate(
    N = 1L,
    treated_descr = if_else(treated==1L, "Boosted", "Unboosted"),
  ) %>%
  select(
    treated_descr,
    all_of(names(var_labels)),
    -age,
  ) %>%
  #{unname(var_labels[names(.)])}
  tbl_summary(
    by = treated_descr,
    label = unname(var_labels[names(.)]),
    statistic = list(N = "{N}")
  )  %>%
  modify_footnote(starts_with("stat_") ~ NA) %>%
  modify_header(stat_by = "**{level}**") %>%
  bold_labels()

tab_summary_baseline_redacted <- redact_tblsummary(tab_summary_baseline, 5, "[REDACTED]")

raw_stats <- tab_summary_baseline_redacted$meta_data %>%
  select(var_label, df_stats) %>%
  unnest(df_stats)

write_csv(tab_summary_baseline_redacted$table_body, fs::path(output_dir, "merge_table1.csv"))
write_csv(tab_summary_baseline_redacted$df_by, fs::path(output_dir, "merge_table1by.csv"))
gtsave(as_gt(tab_summary_baseline_redacted), fs::path(output_dir, "merge_table1.html"))


