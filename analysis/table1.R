# # # # # # # # # # # # # # # # # # # # #
# This script creates a table 1 of baseline characteristics by vaccine type
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('here')
library('glue')
library('gt')
library('gtsummary')

## Import custom user functions from lib

source(here("lib", "functions", "utility.R"))
source(here("lib", "functions", "redaction.R"))

## create output directories ----
fs::dir_create(here("output", "descriptive", "table1"))

## import metadata ----
var_labels <- read_rds(here("lib", "design", "variable-labels.rds"))

#list_formula <- read_rds(here("output", "data", "metadata_formulas.rds"))
#list2env(list_formula, globalenv())
#lastfupday <- lastfupday20

## Import processed data ----
data_cohort <- read_rds(here("output", "data", "data_cohort.rds")) %>%
  mutate(
    N=1,
    allpop="All",
    vax12_type = fct_case_when(
      vax12_type == "pfizer-pfizer" ~ "BNT162b2",
      vax12_type == "az-az" ~ "ChAdOx1-S",
      vax12_type == "moderna-moderna" ~ "mRNA-1273",
      TRUE ~ NA_character_
    )
  )



## variable labels
var_labels <-
  list(
    N  ~ "Total N",
    allpop  ~ "All",
    vax12_type ~ "Primary vaccination course (doses 1 and 2)",
    age ~ "Age",
    ageband ~ "Age",
    sex ~ "Sex",
    ethnicity_combined ~ "Ethnicity",
    imd_Q5 ~ "IMD",
    region ~ "Region",
    rural_urban_group ~ "Rural/urban category",
    stp ~ "STP",
    jcvi_group ~ "JCVI group",
    cev ~ "Clinically extremely vulnerable",

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

    prior_covid_infection0 ~ "Prior SARS-CoV-2 infection",
    prior_tests_cat ~ "Number of SARS-CoV-2 tests in previous 3 months"

  ) %>%
  set_names(., map_chr(., all.vars))

## baseline variables
tab_summary_baseline <- data_cohort %>%
  select(
    all_of(names(var_labels)),
    -age, -stp, -jcvi_group
  ) %>%
  tbl_summary(
    by = allpop,
    label=unname(var_labels[names(.)]),
    statistic = list(N = "{N}")
  )  %>%
  modify_footnote(starts_with("stat_") ~ NA) %>%
  modify_header(stat_by = "**{level}**") %>%
  bold_labels()

tab_summary_baseline_redacted <- redact_tblsummary(tab_summary_baseline, 5, "[REDACTED]")

raw_stats <- tab_summary_baseline_redacted$meta_data %>%
  select(var_label, df_stats) %>%
  unnest(df_stats)

write_csv(tab_summary_baseline_redacted$table_body, here("output", "descriptive", "table1", "table1.csv"))
write_csv(tab_summary_baseline_redacted$df_by, here("output", "descriptive", "table1", "table1by.csv"))
gtsave(as_gt(tab_summary_baseline_redacted), here("output", "descriptive", "table1", "table1.html"))


## baseline variables by jcvi group
tab_summary_jcvi <- data_cohort %>%
  select(
    all_of(names(var_labels)),
    -age, -ageband, -stp, -allpop,
  ) %>%
  tbl_summary(
    by = jcvi_group,
    label=unname(var_labels[names(.)]),
    statistic = list(N = "{N}")
  )  %>%
  modify_footnote(starts_with("stat_") ~ NA) %>%
  modify_header(stat_by = "**{level}**") %>%
  bold_labels()

tab_summary_jcvi_redacted <- redact_tblsummary(tab_summary_jcvi, 5, "[REDACTED]")

raw_stats <- tab_summary_jcvi_redacted$meta_data %>%
  select(var_label, df_stats) %>%
  unnest(df_stats)

write_csv(tab_summary_jcvi_redacted$table_body, here("output", "descriptive", "table1", "table1by_jcvi_group.csv"))
#write_csv(tab_summary_jcvi_redacted$df_by, here("output", "descriptive", "tables", "table1_jcvi_by.csv"))
gtsave(as_gt(tab_summary_jcvi_redacted), here("output", "descriptive", "table1", "table1by_jcvi_group.html"))




