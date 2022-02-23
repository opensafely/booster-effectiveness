# # # # # # # # # # # # # # # # # # # # #
# This script combines matching info across all treatments
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## import command-line arguments ----

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


## Import custom user functions
source(here("lib", "functions", "utility.R"))
source(here("lib", "functions", "survival.R"))

output_dir <- here("output", "match", "combined")
fs::dir_create(output_dir)

## import globally defined study dates and convert to "Date"
study_dates <-
  jsonlite::read_json(path=here("lib", "design", "study-dates.json")) %>%
  map(as.Date)

postbaselinecuts <- read_rds(here("lib", "design", "postbaselinecuts.rds"))

## create lookup for treatment / outcome combinations ----

recode_treatment <- c(`BNT162b2` = "pfizer", `mRNA-1273` = "moderna")

match_metaparams <-
  tibble(
    treatment = factor(recode_treatment),
    treatment_descr = fct_recode(treatment,  !!!recode_treatment),
  ) %>% filter(
    treatment=="pfizer"
  )

# combine matching ----

## match coverage ---

matchcoverage <-
  match_metaparams %>%
  mutate(
    coverage = map(treatment, ~read_csv(here("output", "match", .x, glue("merge_data_coverage.csv")), guess_max = 999999))
  ) %>%
  unnest(coverage) %>%
  mutate(
    status=fct_inorder(status),
    status_descr=fct_inorder(status_descr),
  ) %>%
  arrange(treatment, vax12_type, status, vax3_date) %>%
  group_by(treatment, treatment_descr, vax12_type, status, status_descr, vax3_date) %>%
  summarise(
    n=sum(n),
  ) %>%
  group_by(treatment, treatment_descr, vax12_type, status, status_descr) %>%
  mutate(
    cumuln = cumsum(n),
    #round to nearest 6
    cumuln = ceiling_any(cumuln, 6),
    n = cumuln - lag(cumuln, 1, 0)
  )

write_csv(matchcoverage, fs::path(output_dir, "coverage.csv"))


## match summary ---

matchsummary <-
  match_metaparams %>%
  mutate(
    summary = map(treatment, ~read_csv(here("output",  "match", .x, glue("merge_summary.csv"))))
  ) %>%
  unnest(summary)

write_csv(matchsummary, fs::path(output_dir, "summary.csv"))


matchsummary_treated <-
  match_metaparams %>%
  mutate(
    summary = map(treatment, ~read_csv(here("output",  "match", .x, glue("merge_summary_treated.csv"))))
  ) %>%
  unnest(summary)

write_csv(matchsummary_treated, fs::path(output_dir, "summary_treated.csv"))


## table 1 ----


table1 <-
  match_metaparams %>%
  mutate(
    table1 = map(treatment, ~read_csv(here("output", "match", .x, glue("merge_table1.csv"))))
  ) %>%
  unnest(table1)

write_csv(table1, fs::path(output_dir, "table1.csv"))

table1by <-
  match_metaparams %>%
  mutate(
    table1by = map(treatment, ~read_csv(here("output", "match", .x, glue("merge_table1by.csv"))))
  ) %>%
  unnest(table1by)

write_csv(table1by, fs::path(output_dir, "table1by.csv"))


matchsmd <-
  match_metaparams %>%
  mutate(
    smd = map(treatment, ~read_csv(here("output", "match", .x, glue("merge_data_smd.csv"))))
  ) %>%
  unnest(smd)

write_csv(matchsmd, fs::path(output_dir, "smd.csv"))


matchflowchart <-
  match_metaparams %>%
  mutate(
    flowchart = map(treatment, ~read_csv(here("output", "match", .x, glue("merge_data_flowchart.csv"))))
  ) %>%
  unnest(flowchart)

write_csv(matchflowchart, fs::path(output_dir, "flowchart.csv"))

