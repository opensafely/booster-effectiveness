# # # # # # # # # # # # # # # # # # # # #
# This script creates study parameters and other metadata to be used throughout the study
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('here')
## create output directories ----
fs::dir_create(here("lib", "design"))

# define key dates ----

study_dates <- lst(
  index_date = "2021-09-16", # index date for dates as "time since index date" format
  pfizerstart_date = "2021-09-16", #start of recruitment thursday 16 september first pfizer booster jabs administered in england
  pfizerend_date = "2021-12-16", # end of recruitment (13 weeks later)
  #pfizerfollowend_date = "2021-12-31", # end of follow-up

  modernastart_date = "2021-10-29", #start of recruitment friday 29 october first moderna booster jabs administered in england
  modernaend_date = "2021-12-16", # end of recruitment (7 weeks later)
  #modernafollowend_date = "2021-12-31", # end of follow-up

  studyend_date = "2021-12-31", # end of follow-up

  lastvax2_date = "2021-12-01", # don't recruit anyone with second vaccination after this date

  firstpfizer_date = "2020-12-08", # first pfizer vaccination in national roll-out
  firstaz_date = "2021-01-04", # first az vaccination in national roll-out
  firstmoderna_date = "2021-04-13", # first moderna vaccination in national roll-out
  firstpossiblevax_date = "2020-06-01", # used to catch "real" vaccination dates (eg not 1900-01-01)
)

# export dates as json so it can be imported by both R and python
jsonlite::write_json(study_dates, path = here("lib", "design", "study-dates.json"), auto_unbox=TRUE, pretty =TRUE)

# convert to date format
study_dates <- map(study_dates, as.Date)

# define outcomes and treatments ----

# look-up table for outcomes
# - event = short name used for project.yaml parameters
# - event_var = the name of the variable in the study definition
# - event_descr = a description of the variable
events_lookup <- tribble(
  ~event, ~event_var, ~event_descr,

  # other
  "test", "covid_test_date", "SARS-CoV-2 test",

  # effectiveness
  "postest", "positive_test_date", "Positive SARS-CoV-2 test",
  "covidemergency", "covidemergency_date", "COVID-19 A&E attendance",
  "covidadmitted", "covidadmitted_date", "COVID-19 hospitalisation",
  "noncovidadmitted", "noncovidadmitted_date", "Non-COVID-19 hospitalisation",
  "covidadmittedproxy1", "covidadmittedproxy1_date", "COVID-19 hospitalisation (A&E proxy)",
  "covidadmittedproxy2", "covidadmittedproxy2_date", "COVID-19 hospitalisation (A&E proxy v2)",
  "covidcc", "covidcc_date", "COVID-19 critical care",
  "coviddeath", "coviddeath_date", "COVID-19 death",
  "noncoviddeath", "noncoviddeath_date", "Non-COVID-19 death",
  "death", "death_date", "Any death",

  # safety
  "admitted", "admitted_unplanned_1_date", "Unplanned hospitalisation",
  "emergency", "emergency_date", "A&E attendance",
)



# look-up table for treatments
# - treatment = short name used for project.yaml parameters
# - treatment_descr = a description of the variable
treatment_lookup <-
  tribble(
    ~treatment, ~treatment_descr,
    "pfizer", "BNT162b2",
    "az", "ChAdOx1-S",
    "moderna", "mRNA-1273",
    "pfizer-pfizer", "BNT162b2",
    "az-az", "ChAdOx1-S",
    "moderna-moderna", "mRNA-1273"
  )


# where to split follow-up time after recruitment
postbaselinecuts <- c(0,7,14,28,42,70)



# define matching variables ----

# exact matching variables to use
exact_variables <- c(

  "jcvi_ageband",
  "cev_cv",
  "vax12_type",
  #"vax2_week",
  "region",
  #"sex",
  #"cev_cv",

  #"multimorb",
  "prior_covid_infection",
  #"immunosuppressed",
  #"status_hospplanned"
  NULL
)
write_rds(exact_variables, here("lib", "design", "exact_variables.rds"))

# caliper variables
caliper_variables <- c(
  age = 3,
  vax2_day = 7,
  NULL
)
# combine
matching_variables <- c(exact_variables, names(caliper_variables))



# define other bits ----

# cut-off for rolling 7 day average, that determines recruitment period
# if fewer than `cutoff` people within strata defined by [region, vax-type, JCVI group] are vaccinated on any given day, then we DO NOT recruit those people
recruitment_period_cutoff <- 50

