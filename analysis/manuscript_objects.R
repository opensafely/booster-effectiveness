
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports fitted cox models
# outputs time-dependent effect estimates for booster
#
# The script must be accompanied by two arguments,
# `treatment` - the exposure variable in the regression model
# `outcome` - the dependent variable in the regression model
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

# import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)


if(length(args)==0){
  # use for interactive testing
  removeobs <- FALSE
} else {
  removeobs <- TRUE
}


## Import libraries ----
library('tidyverse')
library('here')
library('glue')
library('survival')
library('gt')


## Import custom user functi
source(here("lib", "functions", "utility.R"))
source(here("lib", "functions", "survival.R"))


output_dir <- here("output", "manuscript-objects")
fs::dir_create(output_dir)

## import globally defined study dates and convert to "Date"
study_dates <-
  jsonlite::read_json(path=here("lib", "design", "study-dates.json")) %>%
  map(as.Date)


## cohort ----

fs::file_copy(here("output", "data", "flowchart.csv"), here("output", "manuscript-objects", "flowchart.csv"), overwrite = TRUE)

data_cohort <- read_rds(here("output", "data", "data_cohort.rds"))

cohort_summary <-
  data_cohort %>%
  mutate(
    censor_date = pmin(
      dereg_date,
      vax4_date-1, # -1 because we assume vax occurs at the start of the day
      death_date,
      study_dates$studyend_date,
      na.rm=TRUE
    ),

    # assume vaccination occurs at the start of the day, and all other events occur at the end of the day.

    tte_censor = tte(study_dates$studystart_date-1, censor_date, censor_date, na.censor=TRUE),
    #ind_censor = censor_indicator(censor_date, censor_date),
  ) %>%
  summarise(
    n = n(),
    n_boosted = sum(between(vax3_date, study_dates$studystart_date, study_dates$lastvax3_date), na.rm=TRUE),

    n_12pfizer = sum(vax12_type=="pfizer-pfizer"),
    prop_12pfizer = n_12pfizer/n,
    n_12az = sum(vax12_type=="az-az"),
    prop_12az = n_12az/n,
    n_12moderna = sum(vax12_type=="moderna-moderna"),
    prop_12moderna = n_12moderna/n,
    n_3pfizer = sum(vax3_type=="pfizer" & vax3_date <= study_dates$lastvax3_date, na.rm=TRUE),
    prop_3pfizer = n_3pfizer/n_boosted,
    n_3moderna = sum(vax3_type=="moderna" & vax3_date <= study_dates$lastvax3_date, na.rm=TRUE),
    prop_3moderna = n_3moderna/n_boosted,

    age_median = median(age),
    age_Q1 = quantile(age, 0.25),
    age_Q3 = quantile(age, 0.75),
    female = mean(sex=="Female"),
    fu_years = sum(tte_censor)/365.25,
    fu_median = median(tte_censor),
    priorinfection = mean(prior_covid_infection),
    timesinceseconddose = mean(study_dates$studystart_date - vax2_date),

  )

write_csv(cohort_summary, here("output", "manuscript-objects", "cohortsummary.csv"))


## table 1 ----

fs::file_copy(here("output", "descriptive", "table1", "table1.csv"), here("output", "manuscript-objects", "table1.csv"), overwrite = TRUE)
fs::file_copy(here("output", "descriptive", "table1", "table1_by.csv"), here("output", "manuscript-objects", "table1_by.csv"), overwrite = TRUE)


## vax dates ----

#
# cumulvax_jcvi <- data_cohort %>%
#   filter(!is.na(vax3_date), vax3_type %in% c("pfizer", "moderna")) %>%
#   droplevels() %>%
#   group_by(jcvi_group, vax3_type_descr, vax3_date) %>%
#   summarise(
#     n=n()
#   ) %>%
#   # make implicit counts explicit
#   complete(
#     vax3_date = full_seq(c(.$vax3_date), 1),
#     fill = list(n=0)
#   ) %>%
#   group_by(jcvi_group, vax3_type_descr) %>%
#   mutate(
#     cumuln = cumsum(n),
#     # calculate rolling weekly average, anchored at end of period
#     rolling7n = stats::filter(n, filter = rep(1, 7), method="convolution", sides=1)/7
#   ) %>%
#   arrange(jcvi_group, vax3_type_descr, vax3_date)
#
#
# cumulvax_jcvi_redacted <-
#   cumulvax_jcvi %>%
#   mutate(
#     cumuln = redactor2(n, threshold=5, cumuln),
#     n = redactor2(n, threshold=5),
#   )
# write_csv(cumulvax_jcvi_redacted, here("output", "descriptive", "vaxdate_jcvi_redacted.csv"))

fs::file_copy(here("output", "descriptive", "vaxdate", "plot_vaxdate_count.png"), here("output", "manuscript-objects", "plot_vaxdate_count.png"), overwrite = TRUE)
fs::file_copy(here("output", "descriptive", "vaxdate", "plot_vaxdate_step.png"), here("output", "manuscript-objects", "plot_vaxdate_step.png"), overwrite = TRUE)
fs::file_copy(here("output", "descriptive", "vaxdate", "plot_vaxdate_stack.png"), here("output", "manuscript-objects", "plot_vaxdate_stack.png"), overwrite = TRUE)
fs::file_copy(here("output", "descriptive", "vaxdate", "plot_vaxdate_count_jcvi.png"), here("output", "manuscript-objects", "plot_vaxdate_count_jcvi.png"), overwrite = TRUE)
fs::file_copy(here("output", "descriptive", "vaxdate", "plot_vaxdate_step_jcvi.png"), here("output", "manuscript-objects", "plot_vaxdate_step_jcvi.png"), overwrite = TRUE)
fs::file_copy(here("output", "descriptive", "vaxdate", "plot_vaxdate_stack_jcvi.png"), here("output", "manuscript-objects", "plot_vaxdate_stack_jcvi.png"), overwrite = TRUE)


## matching ----

fs::file_copy(here("output", "models", "seqtrialcox", "combined", "matchcoverage.csv"), here("output", "manuscript-objects", "matchcoverage.csv"), overwrite = TRUE)
fs::file_copy(here("output", "models", "seqtrialcox", "combined", "matchsummary.csv"), here("output", "manuscript-objects", "matchsummary.csv"), overwrite = TRUE)
fs::file_copy(here("output", "models", "seqtrialcox", "combined", "matchsummary_treated.csv"), here("output", "manuscript-objects", "matchsummary_treated.csv"), overwrite = TRUE)


## models ----
fs::file_copy(here("output", "models", "seqtrialcox", "combined", "ir.csv"), here("output", "manuscript-objects", "ir.csv"), overwrite = TRUE)

fs::file_copy(here("output", "models", "seqtrialcox", "combined", "effects.csv"), here("output", "manuscript-objects", "effects.csv"), overwrite = TRUE)


