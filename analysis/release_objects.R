
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


output_dir <- here("output", "release-objects")
fs::dir_create(output_dir)

## import globally defined study dates and convert to "Date"
study_dates <-
  jsonlite::read_json(path=here("lib", "design", "study-dates.json")) %>%
  map(as.Date)


## matching ----

fs::file_copy(here("output", "match", "combined", "table1.csv"), here("output", "release-objects", "matchtable1.csv"), overwrite = TRUE)
fs::file_copy(here("output", "match", "combined", "table1by.csv"), here("output", "release-objects", "matchtable1by.csv"), overwrite = TRUE)
fs::file_copy(here("output", "match", "combined", "coverage.csv"), here("output", "release-objects", "matchcoverage.csv"), overwrite = TRUE)
fs::file_copy(here("output", "match", "combined", "summary.csv"), here("output", "release-objects", "matchsummary.csv"), overwrite = TRUE)
fs::file_copy(here("output", "match", "combined", "summary_treated.csv"), here("output", "release-objects", "matchsummary_treated.csv"), overwrite = TRUE)
fs::file_copy(here("output", "match", "combined", "smd.csv"), here("output", "release-objects", "matchsmd.csv"), overwrite = TRUE)
fs::file_copy(here("output", "match", "combined", "flowchart.csv"), here("output", "release-objects", "matchflowchart.csv"), overwrite = TRUE)


## models ----

for(subgroup_variable in c("none", "vax12_type", "cev", "age65plus", "prior_covid_infection")){
  fs::dir_create(here("output", "release-objects", subgroup_variable))
  fs::file_copy(here("output", "models", "seqtrialcox", "combined", subgroup_variable, "incidence.csv"), here("output", "release-objects", subgroup_variable, "incidence.csv"), overwrite = TRUE)
  fs::file_copy(here("output", "models", "seqtrialcox", "combined", subgroup_variable, "km.csv"), here("output", "release-objects", subgroup_variable, "km.csv"), overwrite = TRUE)
  fs::file_copy(here("output", "models", "seqtrialcox", "combined", subgroup_variable, "cif.csv"), here("output", "release-objects", subgroup_variable, "cif.csv"), overwrite = TRUE)
  fs::file_copy(here("output", "models", "seqtrialcox", "combined", subgroup_variable, "effects.csv"), here("output", "release-objects", subgroup_variable, "effects.csv"), overwrite = TRUE)
  fs::file_copy(here("output", "models", "seqtrialcox", "combined", subgroup_variable, "metaeffects.csv"), here("output", "release-objects", subgroup_variable, "metaeffects.csv"), overwrite = TRUE)
  fs::file_copy(here("output", "models", "seqtrialcox", "combined", subgroup_variable, "meta2effects.csv"), here("output", "release-objects", subgroup_variable, "meta2effects.csv"), overwrite = TRUE)
  fs::file_copy(here("output", "models", "seqtrialcox", "combined", subgroup_variable, "overalleffects.csv"), here("output", "release-objects", subgroup_variable, "overalleffects.csv"), overwrite = TRUE)
}

fs::file_copy(here("output", "models", "seqtrialcox", "combined", "none", "incidence_all.csv"), here("output", "release-objects", "none", "incidence_all.csv"), overwrite = TRUE)

## create text for output review issue ----
fs::dir_ls(here("output", "release-objects"), type="file", recurse =TRUE) %>%
  map_chr(~str_remove(., fixed(here()))) %>%
  map_chr(~paste0("- [ ] ", str_remove(.,fixed("/")))) %>%
  paste(collapse="\n") %>%
  writeLines(here("output", "files-for-release.txt"))

