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
library('survival')

# Import custom user functions from lib
source(here("lib", "functions", "utility.R"))

## create output directories ----
fs::dir_create(here("output", "data"))

## Import processed data ----

data_processed <- read_rds(here("output", "data", "data_processed.rds")) %>%
  mutate(
    stop=10000L
  )

# import globally defined study dates and convert to "Date"
study_dates <-
  jsonlite::read_json(path=here("lib", "design", "study-dates.json")) %>%
  map(as.Date)


## create one-row-per-event datasets ----
# for vaccination, positive test, hospitalisation/discharge, covid in primary care, death


data_admitted_unplanned <- data_processed %>%
  select(patient_id, matches("^admitted\\_unplanned\\_\\d+\\_date"), matches("^discharged\\_unplanned\\_\\d+\\_date")) %>%
  pivot_longer(
    cols = -patient_id,
    names_to = c("event", "index"),
    names_pattern = "^(.*)_(\\d+)_date",
    values_to="date",
    values_drop_na = TRUE
  ) %>%
  #select(patient_id, index, admitted_date=admitted_unplanned, discharged_date = discharged_unplanned) %>%
  arrange(patient_id, date)

data_admitted_planned <- data_processed %>%
  select(patient_id, matches("^admitted\\_planned\\_\\d+\\_date"), matches("^discharged\\_planned\\_\\d+\\_date")) %>%
  pivot_longer(
    cols = -patient_id,
    names_to = c("event", "index"),
    names_pattern = "^(.*)_(\\d+)_date",
    values_to="date",
    values_drop_na = TRUE
  ) %>%
  #select(patient_id, index, admitted_date=admitted_planned, discharged_date = discharged_planned) %>%
  arrange(patient_id, date)

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
    names_to = c("event", "index"),
    names_pattern = "^(.*)_(\\d+)_date",
    values_to = "date",
    values_drop_na = TRUE
  ) %>%
  arrange(patient_id, date) %>%
  mutate(event="postest") # need to change name to match "outcome" argument


data_emergencyhosp <- data_processed %>%
  select(patient_id, matches("^emergencyhosp\\_\\d+\\_date")) %>%
  pivot_longer(
    cols = -patient_id,
    names_to = c("event", "index"),
    names_pattern = "^(.*)_(\\d+)_date",
    values_to = "date",
    values_drop_na = TRUE
  ) %>%
  arrange(patient_id, date)

data_covidemergency <- data_processed %>%
  select(patient_id, matches("^covidemergency\\_\\d+\\_date")) %>%
  pivot_longer(
    cols = -patient_id,
    names_to = c("event", "index"),
    names_pattern = "^(.*)_(\\d+)_date",
    values_to = "date",
    values_drop_na = TRUE
  ) %>%
  arrange(patient_id, date)

data_covidemergencyhosp <- data_processed %>%
  select(patient_id, matches("^covidemergencyhosp\\_\\d+\\_date")) %>%
  pivot_longer(
    cols = -patient_id,
    names_to = c("event", "index"),
    names_pattern = "^(.*)_(\\d+)_date",
    values_to = "date",
    values_drop_na = TRUE
  ) %>%
  arrange(patient_id, date)

data_covidadmitted <- data_processed %>%
  select(patient_id, matches("^admitted\\_covid\\_\\d+\\_date")) %>%
  pivot_longer(
    cols = -patient_id,
    names_to = c("event", "index"),
    names_pattern = "^(.*)_(\\d+)_date",
    values_to = "date",
    values_drop_na = TRUE
  ) %>%
  arrange(patient_id, date) %>%
  mutate(event="covidadmitted") # need to change name to match "outcome" argument

data_noncovidadmitted <-
  anti_join(
    data_admitted_unplanned %>% filter(event=="admitted_unplanned"), data_covidadmitted, by=c("patient_id", "date")
  ) %>%
  arrange(patient_id, date) %>%
  group_by(patient_id) %>%
  mutate(
    event="noncovidadmitted",
    index=as.character(row_number())
  ) %>%
  ungroup()

data_covidcc <- data_processed %>%
  select(patient_id, matches("^covidcc\\_\\d+\\_date")) %>%
  pivot_longer(
    cols = -patient_id,
    names_to = c("event", "index"),
    names_pattern = "^(.*)_(\\d+)_date",
    values_to = "date",
    values_drop_na = TRUE
  ) %>%
  arrange(patient_id, date)


# these are included for compatibility, event though there is at most one event per person
data_coviddeath <- data_processed %>%
  select(patient_id, date=coviddeath_date) %>%
  filter(!is.na(date)) %>%
  arrange(patient_id, date) %>%
  mutate(event="coviddeath")

data_noncoviddeath <- data_processed %>%
  select(patient_id, date=noncoviddeath_date) %>%
  filter(!is.na(date)) %>%
  arrange(patient_id, date)%>%
  mutate(event="noncoviddeath")

data_death <- data_processed %>%
  select(patient_id, date=death_date) %>%
  filter(!is.na(date)) %>%
  arrange(patient_id, date)%>%
  mutate(event="death")

# data_death <- data_processed %>%
#   select(patient_id, date=death_date, cause_of_death) %>%
#   filter(!is.na(date)) %>%
#   arrange(patient_id)

## long format ----

data_allevents <-
  bind_rows(
    data_admitted_planned,
    data_admitted_unplanned,
    data_postest,
    data_emergencyhosp,
    data_covidemergency,
    data_covidemergencyhosp,
    data_covidadmitted,
    data_noncovidadmitted,
    data_covidcc,
    data_coviddeath,
    data_noncoviddeath,
    data_death
  ) %>%
  mutate(
    time = as.integer(date - (study_dates$index_date - 1)),
  )



data_timevarying <-
  data_processed %>%
  select(patient_id) %>%
  arrange(patient_id) %>%
  tmerge(
    # initialise tmerge run
    data1 = .,
    data2 = data_processed,
    id = patient_id,
    tstart = -10000L,
    tstop = stop
  ) %>%
  tmerge(
    # add events
    data1=.,
    data2=data_allevents,
    id=patient_id,
    #postest = event(time, (event=="positive_test") *1L),
    postest = event(if_else(event=="postest", time, NA_integer_)),
    emergencyhosp = event(time, (event=="emergencyhosp") *1L),
    covidemergency = event(time, (event=="covidemergency") *1L),
    covidemergencyhosp = event(time, (event=="covidemergencyhosp") *1L),
    covidadmitted = event(time, (event=="covidadmitted") *1L),
    covidcc = event(time, (event=="covidcc") *1L),
    coviddeath = event(time, (event=="coviddeath") *1L),
    death = event(time, (event=="death") *1L),
    anycovid = event(time, (event %in% c("postest", "covidemergency", "covidadmitted", "coviddeath"))*1L),
    mostrecent_anycovid = tdc(time, if_else(event %in% c("postest", "covidemergency", "covidadmitted", "coviddeath"), time, NA_integer_)),
    mostrecent_hospplanned = tdc(time, if_else(event=="discharged_planned", time, NA_integer_)),
    mostrecent_hospunplanned = tdc(time, if_else(event=="discharged_unplanned", time, NA_integer_))
  ) %>%
  tmerge(
    data1=.,
    data2=data_allevents,
    id=patient_id,
    status_hospplanned=tdc(time, case_when(event=="admitted_planned" ~ 1L, event=="discharged_planned" ~ 0L, TRUE ~NA_integer_)),
    status_hospunplanned=tdc(time, case_when(event=="admitted_unplanned" ~ 1L, event=="discharged_unplanned" ~ 0L, TRUE ~NA_integer_)),
    options=list(tdcstart=0L)
  ) %>%
  mutate(
    id=NULL,
    covidadmittedproxy1 = covidemergencyhosp,
    covidadmittedproxy2 = if_else((mostrecent_anycovid<=tstop) & (mostrecent_anycovid>=tstop-14), emergencyhosp, 0L)
  )

write_rds(data_timevarying, here("output", "data", "data_long_timevarying.rds"), compress="gz")


data_allevents <-
 data_allevents %>%
  bind_rows(
    data_timevarying %>% filter(covidadmittedproxy1==1) %>% transmute(patient_id, event="covidadmittedproxy1", date=tstop+(study_dates$index_date-1), time=tstop),
    data_timevarying %>% filter(covidadmittedproxy2==1) %>% transmute(patient_id, event="covidadmittedproxy2", date=tstop+(study_dates$index_date-1), time=tstop)
  )


write_rds(data_allevents, here("output", "data", "data_long_allevents.rds"), compress="gz")



# write_rds(data_pr_probable_covid, here("output", cohort, "data", "data_long_pr_probable_covid_dates.rds"), compress="gz")

#write_rds(data_admitted_unplanned, here("output", "data", "data_long_admitted_unplanned_dates.rds"), compress="gz")
#write_rds(data_admitted_planned, here("output", "data", "data_long_admitted_planned_dates.rds"), compress="gz")
#write_rds(data_postest, here("output", "data", "data_long_postest_dates.rds"), compress="gz")
#write_rds(data_covidemergency, here("output", "data", "data_long_covidemergency_dates.rds"), compress="gz")
#write_rds(data_covidadmitted, here("output", "data", "data_long_covidadmitted_dates.rds"), compress="gz")
#write_rds(data_covidcc, here("output", "data", "data_long_covidcc_dates.rds"), compress="gz")
#write_rds(data_coviddeath, here("output", "data", "data_long_coviddeath_dates.rds"), compress="gz")
#write_rds(data_noncoviddeath, here("output", "data", "data_long_noncoviddeath_dates.rds"), compress="gz")
#write_rds(data_death, here("output", "data", "data_long_death_dates.rds"), compress="gz")
