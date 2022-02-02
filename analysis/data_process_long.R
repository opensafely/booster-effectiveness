######################################

# What this script does:
# imports data created by the `data_process.R` script
# converts wide-form time-varying variables into long format
# saves as a one-row-per-event dataset

######################################

# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('here')
library('glue')

# Import custom user functions from lib
source(here("lib", "functions", "utility.R"))

## create output directories ----
fs::dir_create(here("output", "data"))

## Import processed data ----

data_processed <- read_rds(here("output", "data", "data_processed.rds"))

## create one-row-per-event datasets ----
# for vaccination, positive test, hospitalisation/discharge, covid in primary care, death


data_admitted_unplanned <- data_processed %>%
  select(patient_id, matches("^admitted\\_unplanned\\_\\d+\\_date"), matches("^discharged\\_unplanned\\_\\d+\\_date")) %>%
  pivot_longer(
    cols = -patient_id,
    names_to = c(".value", "index"),
    names_pattern = "^(.*)_(\\d+)_date",
    values_drop_na = TRUE
  ) %>%
  select(patient_id, index, admitted_date=admitted_unplanned, discharged_date = discharged_unplanned) %>%
  arrange(patient_id, admitted_date)

data_admitted_planned <- data_processed %>%
  select(patient_id, matches("^admitted\\_planned\\_\\d+\\_date"), matches("^discharged\\_planned\\_\\d+\\_date")) %>%
  pivot_longer(
    cols = -patient_id,
    names_to = c(".value", "index"),
    names_pattern = "^(.*)_(\\d+)_date",
    values_drop_na = TRUE
  ) %>%
  select(patient_id, index, admitted_date=admitted_planned, discharged_date = discharged_planned) %>%
  arrange(patient_id, admitted_date)

#
# data_pr_suspected_covid <- data_processed %>%
#   select(patient_id, matches("^primary_care_suspected_covid\\_\\d+\\_date")) %>%
#   pivot_longer(
#     cols = -patient_id,
#     names_to = c(NA, "suspected_index"),
#     names_pattern = "^(.*)_(\\d+)_date",
#     values_to = "date",
#     values_drop_na = TRUE
#   ) %>%
#   arrange(patient_id, date)
#
# data_pr_probable_covid <- data_processed %>%
#   select(patient_id, matches("^primary_care_probable_covid\\_\\d+\\_date")) %>%
#   pivot_longer(
#     cols = -patient_id
#     names_to = c(NA, "probable_index"),,
#     names_pattern = "^(.*)_(\\d+)_date",
#     values_to = "date",
#     values_drop_na = TRUE
#   ) %>%
#   arrange(patient_id, date)

data_postest <- data_processed %>%
  select(patient_id, matches("^positive\\_test\\_\\d+\\_date")) %>%
  pivot_longer(
    cols = -patient_id,
    names_to = c(NA, "postest_index"),
    names_pattern = "^(.*)_(\\d+)_date",
    values_to = "date",
    values_drop_na = TRUE
  ) %>%
  arrange(patient_id, date)

data_covidemergency <- data_processed %>%
  select(patient_id, matches("^covidemergency\\_\\d+\\_date")) %>%
  pivot_longer(
    cols = -patient_id,
    names_to = c(NA, "covidemergency_index"),
    names_pattern = "^(.*)_(\\d+)_date",
    values_to = "date",
    values_drop_na = TRUE
  ) %>%
  arrange(patient_id, date)

data_covidadmitted <- data_processed %>%
  select(patient_id, matches("^covidadmitted\\_\\d+\\_date")) %>%
  pivot_longer(
    cols = -patient_id,
    names_to = c(NA, "covidadmitted_index"),
    names_pattern = "^(.*)_(\\d+)_date",
    values_to = "date",
    values_drop_na = TRUE
  ) %>%
  arrange(patient_id, date)

data_covidcc <- data_processed %>%
  select(patient_id, matches("^covidcc\\_\\d+\\_date")) %>%
  pivot_longer(
    cols = -patient_id,
    names_to = c(NA, "covidcc_index"),
    names_pattern = "^(.*)_(\\d+)_date",
    values_to = "date",
    values_drop_na = TRUE
  ) %>%
  arrange(patient_id, date)


# these are included for compatibility, event though there is at most one event per person
data_coviddeath <- data_processed %>%
  select(patient_id, date=coviddeath_date) %>%
  arrange(patient_id, date)

data_noncoviddeath <- data_processed %>%
  select(patient_id, date=noncoviddeath_date) %>%
  arrange(patient_id, date)

data_death <- data_processed %>%
  select(patient_id, date=death_date) %>%
  arrange(patient_id, date)

# write_rds(data_pr_probable_covid, here("output", cohort, "data", "data_long_pr_probable_covid_dates.rds"), compress="gz")
# write_rds(data_pr_suspected_covid, here("output", cohort, "data", "data_long_pr_suspected_covid_dates.rds"), compress="gz")

write_rds(data_admitted_unplanned, here("output", "data", "data_long_admitted_unplanned_dates.rds"), compress="gz")
write_rds(data_admitted_planned, here("output", "data", "data_long_admitted_planned_dates.rds"), compress="gz")
write_rds(data_postest, here("output", "data", "data_long_postest_dates.rds"), compress="gz")
write_rds(data_covidemergency, here("output", "data", "data_long_covidemergency_dates.rds"), compress="gz")
write_rds(data_covidadmitted, here("output", "data", "data_long_covidadmitted_dates.rds"), compress="gz")
write_rds(data_covidcc, here("output", "data", "data_long_covidcc_dates.rds"), compress="gz")
write_rds(data_coviddeath, here("output", "data", "data_long_coviddeath_dates.rds"), compress="gz")
write_rds(data_noncoviddeath, here("output", "data", "data_long_noncoviddeath_dates.rds"), compress="gz")
write_rds(data_death, here("output", "data", "data_long_death_dates.rds"), compress="gz")
