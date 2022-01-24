# # # # # # # # # # # # # # # # # # # # #
# This script:
# creates metadata for aspects of the study design
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('here')
## create output directories ----
fs::dir_create(here("lib", "design"))

# define key dates ----

study_dates <- lst(
  studystart_date = "2021-09-16", #start of follow-up thursday 16 sepetember first booster jabs administered in england
  studyend_date = "2021-12-29", # end of follow-up 15 weeks after start
  lastvax2_date = "2021-08-01", # don't recruit anyone with second vaccination after this date
  lastvax3_date = "2021-12-08", # end of recruitment -- 12 weeks after start
  firstpfizer_date = "2020-12-08", # first pfizer vaccination in national roll-out
  firstaz_date = "2021-01-04", # first az vaccination in national roll-out
  firstmoderna_date = "2021-04-13", # first moderna vaccination in national roll-out
  firstpossiblevax_date = "2020-06-01", # used to catch "real" vaccination dates (eg not 1900-01-01)
)


jsonlite::write_json(study_dates, path = here("lib", "design", "study-dates.json"), auto_unbox=TRUE, pretty =TRUE)

# define outcomes ----

metadata_events <- tribble(
  ~event, ~event_var, ~event_descr,

  # other
  "test", "covid_test_date", "SARS-CoV-2 test",

  # effectiveness
  "postest", "positive_test_1_date", "Positive SARS-CoV-2 test",
  "covidemergency", "emergency_covid_date", "COVID-19 A&E attendance",
  "covidadmitted", "covidadmitted_1_date", "COVID-19 hospitalisation",
  "covidcc", "covidcc_date", "COVID-19 critical care",
  "coviddeath", "coviddeath_date", "COVID-19 death",
  "noncoviddeath", "noncoviddeath_date", "Non-COVID-19 death",
  "death", "death_date", "Any death",

  # safety
  "admitted", "admitted_unplanned_1_date", "Unplanned hospitalisation",
  "emergency", "emergency_date", "A&E attendance",
)

write_rds(metadata_events, here("lib", "design", "event-variables.rds"))


## variable labels
variable_labels <- list(
  vax1_type ~ "Vaccine type",
  vax1_type_descr ~ "Vaccine type",
  age ~ "Age",
  ageband ~ "Age",
  sex ~ "Sex",
  ethnicity_combined ~ "Ethnicity",
  imd_Q5 ~ "IMD",
  region ~ "Region",
  rural_urban_group ~ "Rural/urban category",
  stp ~ "STP",

  sev_obesity ~ "Body Mass Index > 40 kg/m^2",

  chronic_heart_disease ~ "Chronic heart disease",
  chronic_kidney_disease ~ "Chronic kidney disease",
  diabetes ~ "Diabetes",
  chronic_liver_disease ~ "Chronic liver disease",
  chronic_resp_disease ~ "Chronic respiratory disease",
  chronic_neuro_disease ~ "Chronic neurological disease",
  immunosuppressed ~ "Immunosuppressed",
  asplenia ~ "Asplenia or poor spleen function",

  learndis ~ "Learning disabilities",
  sev_mental ~ "Serious mental illness",

  multimorb ~ "Morbidity count",

  prior_covid_infection ~ "Prior SARS-CoV-2 infection",
  prior_tests_cat ~ "Number of SARS-CoV-2 tests in previous 3 months"

) %>%
  set_names(., map_chr(., all.vars))

write_rds(variable_labels, here("lib", "design", "variable-labels.rds"))

# where to split follow-up time after recruitment
postbaselinecuts <- seq(0,7*12, 7)
write_rds(postbaselinecuts, here("lib", "design", "postbaselinecuts.rds"))
