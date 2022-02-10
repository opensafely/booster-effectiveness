
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports processed data
# chooses matching sets for each sequential trial
# reports on matching quality
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

## Import custom user functions from lib

source(here("lib", "functions", "utility.R"))
source(here("lib", "functions", "survival.R"))
source(here("lib", "functions", "redaction.R"))

postbaselinecuts <- read_rds(here("lib", "design", "postbaselinecuts.rds"))
matching_variables <- read_rds(here("lib", "design", "matching_variables.rds"))

if(Sys.getenv("OPENSAFELY_BACKEND") %in% c("", "expectations")){
  recruitment_period_cutoff <- 0.1
} else{
  recruitment_period_cutoff <- read_rds(here("lib", "design", "recruitment_period_cutoff.rds"))
}


# create output directories ----

output_dir <- here("output", "models", "seqtrialcox", treatment)
fs::dir_create(output_dir)

## create special log file ----
cat(glue("## script info for {treatment} ##"), "  \n", file = fs::path(output_dir, glue("match_log.txt")), append = FALSE)

## functions to pass additional log info to seperate file
logoutput <- function(...){
  cat(..., file = fs::path(output_dir, glue("match_log.txt")), sep = "\n  ", append = TRUE)
  cat("\n", file = fs::path(output_dir, glue("match_log.txt")), sep = "\n  ", append = TRUE)
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
    file=fs::path(output_dir, glue("match_log.txt")),
    append=TRUE
  )
  cat("\n", file = fs::path(output_dir, glue("match_log.txt")), sep = "\n  ", append = TRUE)
}

## import globally defined study dates and convert to "Date"
study_dates <-
  jsonlite::read_json(path=here("lib", "design", "study-dates.json")) %>%
  map(as.Date)



## import metadata ----
events <- read_rds(here("lib", "design", "event-variables.rds"))

var_labels <- read_rds(here("lib", "design", "variable-labels.rds"))

# Prepare data ----

## one pow per patient ----
data_cohort <- read_rds(here("output", "data", "data_cohort.rds"))

logoutput_datasize(data_cohort)



### rolling average of boosting per strata ----
select_recruitment_period <- function(index, x, min_x){

  max_index <- length(x)
  # start recruiting when x exceeds min_x, and stop recruiting when x is less than min_x
  start <- match(TRUE, x>=min_x) # recruitment start = first time x is greater than min_x,
  if (is.na(start)) start <- max_index+1
  end <- match(TRUE, x[seq(start+1, max_index)]<min_x)+start-1 # recruitment end = first time after start that x is less than min_x
  if (is.na(end)) end <- max_index

  between(seq_along(index), start, end)
}


# which variables to stratify by when determining "typical" vaccination periods
rolling_variables <- c("jcvi_group", "vax12_type", "region")

rolling_window <- 7

# daily vaccination counts within "rolling" strata
data_rollingstrata_vaxcount <-
  data_cohort %>%
  filter(!is.na(vax3_date), vax3_type %in% treatment) %>%
  group_by(across(all_of(rolling_variables)), vax3_date) %>%
  summarise(
    n=n()
  ) %>%
  # make implicit counts explicit
  complete(
    vax3_date = full_seq(c(.$vax3_date - rolling_window+1), 1), # go X days before to
    fill = list(n=0)
  ) %>%
  arrange(across(all_of(rolling_variables)), vax3_date) %>%
  ungroup() %>%
  group_by(across(all_of(rolling_variables))) %>%
  mutate(
    vax3_time = as.numeric(vax3_date - study_dates$studystart_date),
    cumuln = cumsum(n),
    # calculate rolling weekly average, anchored at end of period
    weight = lag(pmin(rolling_window, row_number()),rolling_window-1),
    rolling_avg = stats::filter(n, filter = rep(1, rolling_window), method="convolution", sides=1)/weight,
    recruit = select_recruitment_period(vax3_time, rolling_avg, recruitment_period_cutoff)
  ) %>%
  filter(vax3_time>=0)



data_nontimevarying <-
  data_cohort %>%
  select(
    patient_id,
    any_of(c(rolling_variables, matching_variables, "vax3_date")),
    prior_covid_infection0
  ) %>%
  left_join(
    data_rollingstrata_vaxcount %>% select(all_of(c(rolling_variables, "vax3_date", "recruit"))),
    by=c(rolling_variables, "vax3_date")
  ) %>%
  mutate(
    treated_within_recruitment_period = replace_na(recruit, FALSE),
    recruit=NULL,
  )


data_timevarying <-
  read_rds(here("output", "data", "data_long_timevarying.rds")) %>%
  select(
    patient_id,
    tstart,
    tstop,
    any_of(matching_variables),
    status_hospunplanned,
    mostrecent_anycovid,
  )

### event times ----

## tte = time-to-event, and always indicates time from study start date
data_tte <-
  data_cohort %>%
  transmute(
    patient_id,
    day0_date = study_dates$studystart_date-1, # day before the first trial date
    treatment_date = if_else(vax3_type==treatment, vax3_date, as.Date(NA)),
    competingtreatment_date = if_else(vax3_type!=treatment, vax3_date, as.Date(NA)),

    # person-time is up to and including censor date
    censor_date = pmin(
      dereg_date,
      competingtreatment_date-1, # -1 because we assume vax occurs at the start of the day
      vax4_date-1, # -1 because we assume vax occurs at the start of the day
      death_date,
      study_dates$studyend_date,
      na.rm=TRUE
    ),

    # assume vaccination occurs at the start of the day, and all other events occur at the end of the day.

    tte_censor = tte(day0_date, censor_date, censor_date, na.censor=TRUE),

    tte_treatment = tte(day0_date, treatment_date-1, censor_date, na.censor=TRUE),

    tte_stop = pmin(tte_censor, na.rm=TRUE),

  ) %>%
  filter(
    # remove anyone with competing vaccine on first trial day
    (competingtreatment_date-1>day0_date) | is.na(competingtreatment_date),
  ) %>%
  mutate(
    # convert tte variables (days since day0), to integer to save space
    across(starts_with("tte_"), as.integer),
    # convert logical to integer so that model coefficients print nicely in gtsummary methods
    across(where(is.logical), ~.x*1L)
  )

write_rds(data_tte, fs::path(output_dir, "match_data_tte.rds"))

logoutput_datasize(data_tte)


library("MatchIt")

data_matched <- local({

  ## sequential trial matching routine is as follows:
  # each daily trial includes all n people who were vaccinated on that day (treated=1) and
  # a random sample of n controls (treated=0) who:
  # - had not been vaccinated on or before that day (still at risk of treatment);
  # - had not experienced covid recently (within X TODO days);
  # - still at risk of an outcome (not deregistered or dead);
  # - had not already been selected as a control in a previous trial
  # for each trial, all covariates, including time-dependent covariates, are chosen as at the recruitment date and do not subsequently vary through follow-up
  # within the construct of the model, there are no time-dependent variables, only time-dependent treatment effects (modelled as piecewise constant hazards)


  max_trial_day <- pmin(max(data_tte$tte_treatment, na.rm=TRUE), NA, na.rm=TRUE)
  trials <- seq_len(max_trial_day)

  # initialise list of candidate controls
  candidate_ids0 <- data_tte$patient_id

  # initialise matching summary data
  matched <- NULL

  # matching formula
  matching_formula <- as.formula(str_c("treated ~ ", paste(matching_variables, collapse=" + ")))
  trial=1
  for(trial in trials){

    #cat(trial, "\n")

    trial_time <- trial-1

    data_timevarying_i <-
      filter(
        data_timevarying,
        trial_time>=tstart,
        trial_time<tstop
      )

    # set of people boosted on trial day, + their candidate controls
    matching_candidates_i <-
      data_tte %>%
      arrange(patient_id) %>%
      # join time invariant variables
      left_join(data_nontimevarying, by="patient_id") %>%
      # join time-variant variables
      left_join(data_timevarying_i, by="patient_id") %>%
      mutate(
        prior_covid_infection = prior_covid_infection0 | !is.na(mostrecent_anycovid)
      ) %>%
      filter(
        # remove anyone already censored
        tte_stop > trial_time,
        # remove anyone who has experienced covid within the last 90 days
        !between(mostrecent_anycovid, trial_time-90, trial_time) | is.na(mostrecent_anycovid),
        # remove anyone currently in hospital
        status_hospunplanned==0L
      ) %>%
      mutate(
        # everyone treated on trial day and eligible
        treated = ((tte_treatment %in% trial_time) & treated_within_recruitment_period)*1,
        # everyone not yet treated by trial day, not yet censored, and not already selected as a control
        control_candidate = (((tte_treatment > trial_time) | is.na(tte_treatment)) & (patient_id %in% candidate_ids0))*1
      ) %>%
      filter((treated==1L) | (control_candidate==1L))


    if(sum(matching_candidates_i$treated)<1) {
      message("Skipping trial ", trial, " - No treated people eligible for inclusion.")
      next
    }

    n_treated_all <- sum(matching_candidates_i$treated)

    safely_matchit <- purrr::safely(matchit)

    # run matching algorithm
    matching_i <-
      safely_matchit(
        formula = matching_formula,
        data = matching_candidates_i,
        method = "exact",
        replace = FALSE,
        estimand = "ATE",
        #m.order = "data", # data is sorted on (effectively random) patient ID
        #verbose = TRUE,
        #ratio = 1L # irritatingly you can't set this for "exact" method, so have to filter later
      )[[1]]

    if(is.null(matching_i)) {
      message("Skipping trial ", trial, " - No exact matches found.")
      next
    }
    # summary info for recruited people
    # - one row per person
    # - match_id is within matching_i
    matched_i <-
      as.data.frame(matching_i$X) %>%
      add_column(
        subclass = matching_i$subclass,
        treated = matching_i$treat,
        patient_id = matching_candidates_i$patient_id,
        weight = matching_i$weights,
        trial_day = trial,
      ) %>%

      # filter treated and controls to ensure exact 1:1 matching
      arrange(subclass, desc(treated), patient_id) %>%
      group_by(subclass) %>%
      mutate(
        n_treated = sum(treated),
        n_control = sum(1-treated)
      ) %>%
      group_by(subclass, treated) %>%
      filter(
        row_number() <= pmin(n_treated, n_control),
        !is.na(subclass) # equivalent to weight != 0
      ) %>%
      group_by(treated) %>%
      mutate(
        match_id = row_number()
      ) %>%
      arrange(subclass, match_id, desc(treated)) %>%
      left_join(
        matching_candidates_i %>% select(patient_id, starts_with("tte_")),
        by = "patient_id"
      ) %>%
      select(-n_treated, -n_control) %>%
      group_by(match_id) %>%
      mutate(
        tte_recruitment = trial_time,
        tte_controlistreated = tte_treatment[treated==0],
        tte_stop = pmin(tte_stop, tte_controlistreated, na.rm=TRUE),
      ) %>%
      ungroup()

    n_treated_matched <- sum(matched_i$treated)

    if(n_treated_matched < (0.1*n_treated_all)) {

      message("Skipping trial ", trial, " - Only ", n_treated_matched, "boosted people out of ", n_treated_all, " (", n_treated_matched*100/n_treated_all, "%) had a match.")
      next
    }

    #update list of candidate controls to those who have not already been recruited
    candidate_ids0 <- candidate_ids0[!(candidate_ids0 %in% matched_i$patient_id)]

    matched <- bind_rows(matched, matched_i)

  }

  matched %>%
  select(-subclass) %>%
  mutate(
    treated_patient_id = paste0(treated, "_", patient_id),
  )

})


write_rds(data_matched, fs::path(output_dir, "match_data_matched.rds"))

# number of treated/controls per trial
controls_per_trial <- table(data_matched$trial_day, data_matched$treated)
logoutput_table(controls_per_trial)

# max trial date
max_trial_day <- max(data_matched$trial_day, na.rm=TRUE)
logoutput("max trial day is ", max_trial_day)



# combine matching dataset with all other variables required for modelling ----

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
    immuno,

    vax12_type,
    vax2_week,
    vax3_date,
    vax3_type,

  )
logoutput_datasize(data_baseline)

if(removeobjects) rm(data_cohort)


## create variables-at-time-zero dataset - one row per trial per arm per patient ----
data_merged <-
  # add time-varying info as at recruitment date (= tte_trial)
  data_matched %>%
  left_join(
    data_timevarying %>% select(-any_of(matching_variables)),
    by = c("patient_id")
  ) %>%
  filter(
    tte_recruitment < tstop,
    tte_recruitment >= tstart
  ) %>%
  # add time-non-varying info
  left_join(
    data_baseline %>% select(-any_of(matching_variables)),
    by=c("patient_id")
  ) %>%
  # remaining variables that combine both
  mutate(
    dayssince_anycovid = tstart - mostrecent_anycovid,
  )

logoutput_datasize(data_merged)

write_rds(data_merged, fs::path(output_dir, "match_data_merged.rds"))


# matching coverage per trial / day of follow up

data_coverage <-
  data_matched %>%
  filter(treated==1L) %>%
  left_join(data_tte %>% transmute(patient_id, vax3_date=treatment_date), by="patient_id") %>%
  group_by(across(all_of(rolling_variables)), vax3_date) %>%
  summarise(
    n_matched=n(),
  ) %>%
  left_join(
    data_rollingstrata_vaxcount,
    .
  ) %>%
  mutate(
    n_matched = replace_na(n_matched, 0L),
    n_unmatched = n-n_matched,
    n = NULL
  ) %>%
  pivot_longer(
    cols = c(n_matched, n_unmatched),
    names_to = "matched",
    names_prefix = "n_",
    values_to = "n"
  ) %>%
  arrange(jcvi_group, vax12_type, vax3_date, matched) %>%
  group_by(jcvi_group, vax12_type, vax3_date, matched) %>%
  summarise(
    n = sum(n),
  ) %>%
  group_by(jcvi_group, vax12_type, matched) %>%
  complete(
    vax3_date = full_seq(.$vax3_date, 1), # go X days before to
    fill = list(n=0)
  ) %>%
  mutate(
    cumuln = cumsum(n),
    matched = factor(matched, c("unmatched", "matched"))
  )

write_csv(data_coverage, fs::path(output_dir, "match_data_coverage.csv"))

# report matching info ----

day1_date <- study_dates$studystart_date




## candidate matching summary ----

## matching summary ----

candidate_summary_trial <-
  data_tte %>%
  filter(tte_treatment <= tte_stop) %>%
  mutate(trial_day=tte_treatment+1) %>%
  group_by(trial_day) %>%
  summarise(
    total_treated=n()
  ) %>%
  ungroup()

match_summary_trial <-
  data_matched %>%
  group_by(trial_day, treated) %>%
  summarise(
    n=n(),
    fup_sum = sum(tte_stop - tte_recruitment),
    fup_years = sum(tte_stop - tte_recruitment)/365.25,
    fup_mean = mean(tte_stop - tte_recruitment)
  ) %>%
  arrange(
    trial_day, treated
  ) %>%
  pivot_wider(
    id_cols = c(trial_day),
    names_from = treated,
    values_from = c(n, fup_sum, fup_years, fup_mean)
  ) %>%
  left_join(candidate_summary_trial, by="trial_day") %>%
  mutate(
    prop_recruited = n_1/total_treated
  )

write_csv(match_summary_trial, fs::path(output_dir, "match_summary_trial.csv"))


match_summary_treated <-
  data_matched %>%
  group_by(treated) %>%
  summarise(
    n=n(),
    firstrecruitdate = min(tte_recruitment) + day1_date,
    lastrecruitdate = max(tte_recruitment) + day1_date,
    fup_sum = sum(tte_stop - tte_recruitment),
    fup_years = sum(tte_stop - tte_recruitment)/365.25,
    fup_mean = mean(tte_stop - tte_recruitment)
  )

write_csv(match_summary_treated, fs::path(output_dir, "match_summary_treated.csv"))



candidate_summary <-
  data_tte %>%
  filter(tte_treatment <= tte_stop) %>%
  summarise(
    total_treated=n()
  ) %>%
  ungroup()

match_summary <-
  data_matched %>%
  summarise(
    n=n(),
    firstrecruitdate = min(tte_recruitment) + day1_date,
    lastrecruitdate = max(tte_recruitment) + day1_date,
    fup_sum = sum(tte_stop - tte_recruitment),
    fup_years = sum(tte_stop - tte_recruitment)/365.25,
    fup_mean = mean(tte_stop - tte_recruitment)
  ) %>%
  bind_cols(candidate_summary) %>%
  mutate(
    prop_recruited = (n/2)/total_treated
  )

write_csv(match_summary, fs::path(output_dir, "match_summary.csv"))

## matching coverage ----

xmin <- min(data_coverage$vax3_date )
xmax <- max(data_coverage$vax3_date )+1

plot_coverage_n <-
  data_coverage %>%
  ggplot()+
  geom_col(
    aes(
      x=vax3_date+0.5,
      y=n,
      group=matched,
      fill=matched,
      colour=NULL
    ),
    position=position_stack(),
    alpha=0.8,
    width=1
  )+
  geom_rect(xmin=xmin, xmax= xmax+1, ymin=0, ymax=6, fill="grey", colour="transparent")+
  facet_grid(rows = vars(jcvi_group), cols = vars(vax12_type))+
  scale_x_date(
    breaks = unique(lubridate::ceiling_date(data_coverage$vax3_date, "1 month")),
    limits = c(lubridate::floor_date((xmin), "1 month"), NA),
    labels = scales::label_date("%d/%m"),
    expand = expansion(add=1),
  )+
  scale_y_continuous(
    labels = scales::label_number(accuracy = 1, big.mark=","),
    expand = expansion(c(0, NA))
  )+
  scale_fill_brewer(type="qual", palette="Set2")+
  scale_colour_brewer(type="qual", palette="Set2")+
  labs(
    x="Date",
    y="Booster vaccines per day",
    colour=NULL,
    fill=NULL,
    alpha=NULL
  ) +
  theme_minimal()+
  theme(
    axis.line.x.bottom = element_line(),
    axis.text.x.top=element_text(hjust=0),
    strip.text.y.right = element_text(angle = 0),
    axis.ticks.x=element_line(),
    legend.position = "bottom"
  )+
  NULL

plot_coverage_n

#ggsave(plot_coverage_n, filename="match_coverage_count.svg", path=output_dir)
ggsave(plot_coverage_n, filename="match_coverage_count.png", path=output_dir)
ggsave(plot_coverage_n, filename="match_coverage_count.pdf", path=output_dir)


plot_coverage_cumuln <-
  data_coverage %>%
  ggplot()+
  geom_col(
    aes(
      x=vax3_date+0.5,
      y=cumuln,
      group=matched,
      fill=matched,
      colour=NULL
    ),
    position=position_stack(),
    alpha=0.8,
    width=1
  )+
  geom_rect(xmin=xmin, xmax= xmax+1, ymin=0, ymax=6, fill="grey", colour="transparent")+
  facet_grid(rows = vars(jcvi_group), cols = vars(vax12_type))+
  scale_x_date(
    breaks = unique(lubridate::ceiling_date(data_coverage$vax3_date, "1 month")),
    limits = c(lubridate::floor_date((xmin), "1 month"), NA),
    labels = scales::label_date("%d/%m"),
    expand = expansion(add=1),
  )+
  scale_y_continuous(
    labels = scales::label_number(accuracy = 1, big.mark=","),
    expand = expansion(c(0, NA))
  )+
  scale_fill_brewer(type="qual", palette="Set2")+
  scale_colour_brewer(type="qual", palette="Set2")+
  labs(
    x="Date",
    y="Cumulative booster vaccines",
    colour=NULL,
    fill=NULL,
    alpha=NULL
  ) +
  theme_minimal()+
  theme(
    axis.line.x.bottom = element_line(),
    axis.text.x.top=element_text(hjust=0),
    strip.text.y.right = element_text(angle = 0),
    axis.ticks.x=element_line(),
    legend.position = "bottom"
  )+
  NULL

plot_coverage_cumuln

#ggsave(plot_coverage_cumuln, filename="match_coverage_stack.svg", path=output_dir)
ggsave(plot_coverage_cumuln, filename="match_coverage_stack.png", path=output_dir)
ggsave(plot_coverage_cumuln, filename="match_coverage_stack.pdf", path=output_dir)




# table 1 style baseline characteristics ----

library('gt')
library('gtsummary')

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

  prior_covid_infection ~ "Prior infection",
  status_hospplanned ~ "In hospital (planned admission)"
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

write_csv(tab_summary_baseline_redacted$table_body, fs::path(output_dir, "match_table1.csv"))
write_csv(tab_summary_baseline_redacted$df_by, fs::path(output_dir, "match_table1by.csv"))
gtsave(as_gt(tab_summary_baseline_redacted), fs::path(output_dir, "match_table1.html"))


