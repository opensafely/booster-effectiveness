# # # # # # # # # # # # # # # # # # # # #
# This script combines matching info across all treatments
# so fewer files have to be released
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----


## Import libraries ----
library('tidyverse')
library('here')
library('glue')
library('survival')
library('gt')

## import study parameters, dates, and functions ----
source(here("analysis", "design.R"))
source(here("lib", "functions", "utility.R"))
source(here("lib", "functions", "survival.R"))

output_dir <- here("output", "match", "combined")
fs::dir_create(output_dir)


match_metaparams <-
  treatment_lookup %>%
  filter(
    treatment %in% c("pfizer", "moderna")
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

