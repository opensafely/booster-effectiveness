
# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports merged matching data
# adds outcome variable and restricts follow-up
# fits the Cox models with time-varying effects
# The script must be accompanied by three arguments:
# `treatment` - the treatment variable, "pfizer" or "moderna"
# `outcome` - the dependent variable in the regression model
# `subgroup` - the subgroup variable for the regression model followed by a hyphen and the level of the subgroup

# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('here')
library('glue')
library('survival')

## import study parameters, dates, and functions ----
source(here("analysis", "design.R"))
source(here("lib", "functions", "utility.R"))
source(here("lib", "functions", "survival.R"))
source(here("lib", "functions", "redaction.R"))

## import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)

if(length(args)==0){
  # use for interactive testing
  removeobjects <- FALSE
  treatment <- "pfizer"
  outcome <- "postest"
  #subgroup <- "none"
  subgroup <- "vax12_type-pfizer-pfizer"
  #subgroup <- "prior_covid_infection-TRUE"
} else {
  removeobjects <- TRUE
  treatment <- args[[1]]
  outcome <- args[[2]]
  subgroup <- args[[3]]
}


# derive subgroup info from "subgroup" parameter
subgroup_variable <-  str_split_fixed(subgroup,"-",2)[,1] # the name name of the subgroup variable
subgroup_level <- str_split_fixed(subgroup,"-",2)[,2] # the level of the subgroup variable
subgroup_dummy <- paste0(subgroup_variable,"_",subgroup_level) # to replicate column names set by `fastDummies::dummy_cols` -- see below


## create output directories ----

output_dir <- here("output", "models", "seqtrialcox", treatment, outcome, subgroup)
fs::dir_create(output_dir)

## create special log file ----
cat(glue("## script info for {outcome} ##"), "  \n", file = fs::path(output_dir, glue("model_log.txt")), append = FALSE)

## functions to pass additional log info to seperate file
logoutput <- function(...){
  cat(..., file = fs::path(output_dir, glue("model_log.txt")), sep = "\n  ", append = TRUE)
  cat("\n", file = fs::path(output_dir, glue("model_log.txt")), sep = "\n  ", append = TRUE)
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
    file=fs::path(output_dir, glue("model_log.txt")),
    append=TRUE
  )
  cat("\n", file = fs::path(output_dir, glue("model_log.txt")), sep = "\n  ", append = TRUE)
}

# import matched data ----

# import data
# add:
# - undefined subgroups
# - treatment-specific patient_id (some patients are in both unboosted and boosted treatment groups)
# - length of follow-up
# select only subgroup-level of interest
data_matched <-
  read_rds(here("output", "match", treatment, "match_data_merged.rds")) %>%
  filter(matched %in% 1L) %>%
  mutate(
    none="",
    age65plus=age>=65,
    treated_patient_id = paste0(treated, "_", patient_id),
    fup = pmin(tte_matchcensor - tte_recruitment, last(postbaselinecuts)),
  ) %>%
  fastDummies::dummy_cols(select_columns = subgroup_variable, remove_selected_columns = FALSE) %>%
  filter(.[[subgroup_dummy]]==1L)

data_tte <-
  read_rds(here("output", "match", treatment, "match_data_tte.rds")) %>%
  filter(patient_id %in% data_matched$patient_id)


## create outcome variables ----
data_timevaryingoutcomes <- local({

  data_join <-
    data_tte %>%
    select(patient_id, day0_date, censor_date, tte_censor)

  data_outcome <-
    read_rds(here("output", "data", glue("data_long_allevents.rds"))) %>%
    filter(event==outcome) %>%
    inner_join(data_join, ., by =c("patient_id")) %>%
    mutate(
      tte = tte(day0_date, date, censor_date, na.censor=TRUE),
    )

  data_timevaryingoutcomes <-
    tmerge(
      data1 = data_tte %>% select(patient_id),
      data2 = data_tte,
      id = patient_id,
      tstart = 0L,
      tstop = tte_censor
    ) %>%
    tmerge(
      data1 = .,
      data2 = data_outcome,
      id = patient_id,
      ind_outcome = event(tte),
      tte_outcome = event(tte, tte)
    ) %>%
    mutate(
      # overwrite default "0" for event(tte, tte) function in tmerge, and remove ind_outcome
      tte_outcome = if_else(ind_outcome==1L, as.integer(tte_outcome), NA_integer_),
      ind_outcome = NULL
    )

  data_timevaryingoutcomes

})


## combine all together ----
# outcome variables with variables-at-baseline and add follow-up periods
# create one row per trial per arm per patient per follow-up period

data_seqtrialcox <- local({

  data_st0 <-
    # add tte_outcome variable to matched data
    data_matched %>%
    left_join(
      data_timevaryingoutcomes %>% rename(tstart2 = tstart, tstop2 = tstop),
      by = c("patient_id")
    ) %>%
    filter(
      tte_recruitment < tstop2,
      tte_recruitment >= tstart2
    ) %>%
    select(-tstart2, -tstop2)

  # one row per patient per post-recruitment split time
  fup_split <-
    data_matched %>%
    uncount(weights = length(postbaselinecuts)-1, .id="period_id") %>%
    mutate(
      fup_time = postbaselinecuts[period_id],
      fup_period = timesince_cut(fup_time, postbaselinecuts-1),
      tte_fup = tte_recruitment + fup_time
    ) %>%
    droplevels() %>%
    select(
      patient_id, treated, treated_patient_id, period_id, tte_fup, fup_time,
      fup_period
    )

  # add post-recruitment periods to data
  data_st <-
    # re-initialise tmerge object and add outcome
    tmerge(
      data1 = data_st0,
      data2 = data_st0,
      id = treated_patient_id,
      tstart = tte_recruitment,
      tstop = pmin(tte_matchcensor, tte_outcome, tte_recruitment+last(postbaselinecuts), na.rm=TRUE),
      ind_outcome = event(tte_outcome)
    ) %>%
    # add post-recruitment periods
    tmerge(
      data1 = .,
      data2 = fup_split,
      id = treated_patient_id,
      fup_period = tdc(tte_fup, fup_period),
      treated_period = tdc(tte_fup, period_id)
    ) %>%
    mutate(
      id = NULL,
      # time-zero is recruitment day
      tstart_calendar = tstart,
      tstop_calendar = tstop,
      tstart = tstart - tte_recruitment,
      tstop = tstop - tte_recruitment
    ) %>%
    fastDummies::dummy_cols(select_columns = c("treated_period"), remove_selected_columns = TRUE) %>%
    mutate(
      across(
        starts_with("treated_period_"),
        ~if_else(treated==1, .x, 0L)
      )
    )

  data_st
})


if(removeobjects){rm(data_matched)}

logoutput_datasize(data_seqtrialcox)

write_rds(data_seqtrialcox, fs::path(output_dir, "model_data_seqtrialcox.rds"), compress="gz")

# outcome frequency
outcomes_per_treated <- table(days = data_seqtrialcox$fup_period, outcome=data_seqtrialcox$ind_outcome, treated=data_seqtrialcox$treated)
logoutput_table(outcomes_per_treated)



## define model formulae ----

treated_period_variables <- data_seqtrialcox %>% select(starts_with("treated_period")) %>% names()

# unadjusted
formula_vaxonly <- as.formula(
  str_c(
    "Surv(tstart, tstop, ind_outcome) ~ ",
    str_c(treated_period_variables, collapse = " + ")
  )
)

#formula_vaxonly <- Surv(tstart, tstop, ind_outcome) ~ treated:strata(fup_period)

# cox stratification
formula_strata <- . ~ . +
  strata(trial_time) +
  strata(region) +
  #strata(jcvi_group) +
  strata(vax12_type)

formula_demog <- . ~ . +
  poly(age, degree=2, raw=TRUE) +
  sex +
  imd_Q5 +
  ethnicity_combined

formula_clinical <- . ~ . +
  prior_tests_cat +
  multimorb +
  learndis +
  sev_mental +
  immunosuppressed +
  asplenia

formula_timedependent <- . ~ . +
  prior_covid_infection +
  status_hospplanned


formula_remove_outcome <- . ~ .
if(outcome=="postest"){
  formula_remove_outcome = . ~ . - postest_status
}

# remove matching variables from formulae, as treatment groups are already balanced
formula_remove_matching <- as.formula(paste(". ~ . - ", paste(matching_variables, collapse=" -"), "- poly(age, degree=2, raw=TRUE)"))

# unadjusted
formula0_pw <- formula_vaxonly %>% update(formula_remove_matching)

# with stratification
formula1_pw <- formula_vaxonly %>% update(formula_strata) %>% update(formula_remove_matching)

# add demographic variables
formula2_pw <- formula_vaxonly %>% update(formula_strata) %>% update(formula_demog) %>% update(formula_remove_matching)

# add clinical variables
formula3_pw <- formula_vaxonly %>% update(formula_strata) %>% update(formula_demog) %>% update(formula_clinical) %>% update(formula_timedependent) %>% update(formula_remove_outcome) %>% update(formula_remove_matching)

# look-up for model description
model_descr = c(
  "Unadjusted" = "0",
  #"region- and trial-stratified" = "1",
  #"Demographic adjustment" = "2",
  "Full adjustment" = "3"
)


## pre-flight checks ----

### event counts within each covariate level ----

tbltab0 <-
  data_seqtrialcox %>%
  select(ind_outcome, treated, fup_period, all_of(all.vars(formula3_pw)), -starts_with("treated_period")) %>%
  select( -tstart, -tstop) %>%
  mutate(
    across(
      where(is.numeric),
      ~as.character(.)
    ),
  )

event_counts <-
  tbltab0 %>%
  split(.["ind_outcome"]) %>%
  map(~select(., -ind_outcome)) %>%
  map(
    function(data){
      map(data, redacted_summary_cat, redaction_threshold=0) %>%
        bind_rows(.id="variable") %>%
        select(-redacted, -pct_nonmiss)
    }
  ) %>%
  bind_rows(.id = "event") %>%
  pivot_wider(
    id_cols=c(variable, .level),
    names_from = event,
    names_glue = "event{event}_{.value}",
    values_from = c(n, pct)
  )

write_csv(event_counts, fs::path(output_dir, "model_preflight.csv"))

### event counts within each follow up period ----

event_counts_period <-
  tbltab0 %>%
  split(.[c("fup_period", "ind_outcome")], sep="..") %>%
  map(~select(., -fup_period, -ind_outcome)) %>%
  map(
    function(data){
      map(data, redacted_summary_cat, redaction_threshold=0) %>%
        bind_rows(.id="variable") %>%
        select(-redacted, -pct_nonmiss)
    }
  ) %>%
  bind_rows(.id = "period..outcome") %>%
  separate(period..outcome, into = c("period", "event"), sep="\\.\\.") %>%
  pivot_wider(
    id_cols=c(variable, .level),
    names_from = c("period", "event"),
    names_glue = "days {period}.{event}_{.value}",
    values_from = c(n, pct)
  )

write_csv(event_counts_period, fs::path(output_dir, "model_preflight_period.csv"))

### event counts within strata levels ----

event_counts_strata <-
  data_seqtrialcox %>%
  mutate(
    strata = strata(!!!syms(all.vars(formula_strata)[-1]))
  ) %>%
  select(ind_outcome, strata, fup_period) %>%
  split(.["ind_outcome"]) %>%
  map(~select(., -ind_outcome)) %>%
  map(
    function(data){
      map(data, redacted_summary_cat, redaction_threshold=0) %>%
        bind_rows(.id="variable") %>%
        select(-redacted, -pct_nonmiss)
    }
  ) %>%
  bind_rows(.id = "event") %>%
  pivot_wider(
    id_cols=c(variable, .level),
    names_from = event,
    names_glue = "event{event}_{.value}",
    values_from = c(n, pct)
  )

write_csv(event_counts_strata, fs::path(output_dir, "model_preflight_strata.csv"))




# gt(
#   event_counts_treated,
#   groupname_col="variable",
# ) %>%
#   tab_spanner_delim("_") %>%
#   fmt_number(
#     columns = ends_with(c("pct")),
#     decimals = 1,
#     scale_by=100,
#     pattern = "({x})"
#   ) %>%
#   gtsave(
#     filename = glue("model_preflight.html"),
#     path=output_dir
#   )


# fit models ----

opt_control <- coxph.control(iter.max = 30)

cox_model <- function(timesplit, number, formula_cox){

  # fit a time-dependent cox model and output summary functions
  coxmod <- coxph(
    formula = formula_cox,
    data = data_seqtrialcox,
    robust = TRUE,
    id = patient_id,
    na.action = "na.fail",
    control = opt_control
  )

  # use this because warnings aren't printed by default when hit inside a custom function call
  print(warnings())

  tidy <-
    broom.helpers::tidy_plus_plus(
      coxmod,
      exponentiate = FALSE
    ) %>%
    add_column(
      model = number,
      .before=1
    )

  glance <-
    broom::glance(coxmod) %>%
    add_column(
      model = number,
      convergence = coxmod$info[["convergence"]],
      ram = format(object.size(coxmod), units="GB", standard="SI", digits=3L),
      .before = 1
    )

  # remove data to save space (it's already saved above)
  coxmod$data <- NULL
  write_rds(coxmod, fs::path(output_dir, glue("model_obj{number}{timesplit}.rds")), compress="gz")

  lst(glance, tidy)
}

summary0 <- cox_model("", 0, formula0_pw)
#summary1 <- cox_model("", 1, formula1_pw)
#summary2 <- cox_model("", 2, formula2_pw)
summary3 <- cox_model("", 3, formula3_pw)

# combine results
model_glance <-
  bind_rows(
    summary0$glance,
    #summary1$glance,
    #summary2$glance,
    summary3$glance,
  ) %>%
  mutate(
    model_descr = fct_recode(as.character(model), !!!model_descr)
  )
write_csv(model_glance, fs::path(output_dir, "model_glance.csv"))

model_tidy <-
  bind_rows(
    summary0$tidy,
    #summary1$tidy,
    #summary2$tidy,
    summary3$tidy,
  ) %>%
  mutate(
    model_descr = fct_recode(as.character(model), !!!model_descr)
  )
write_csv(model_tidy, fs::path(output_dir, "model_tidy.csv"))


if(removeobjects){rm(summary0, summary1, summary2, summary3)}

## re-run models, but do not split time period ----


formula_vaxonly_overall <- Surv(tstart, tstop, ind_outcome) ~ treated
formula0_overall <- formula_vaxonly_overall %>% update(formula_remove_matching)
formula1_overall <- formula_vaxonly_overall %>% update(formula_strata) %>% update(formula_remove_matching)
formula2_overall <- formula_vaxonly_overall %>% update(formula_strata) %>% update(formula_demog) %>% update(formula_remove_matching)
formula3_overall <- formula_vaxonly_overall %>% update(formula_strata) %>% update(formula_demog) %>% update(formula_clinical) %>% update(formula_timedependent) %>% update(formula_remove_outcome) %>% update(formula_remove_matching)


summary0overall <- cox_model("overall", 0, formula0_overall)
#summary1overall <- cox_model("overall", 1, formula1_overall)
#summary2overall <- cox_model("overall", 2, formula2_overall)
summary3overall <- cox_model("overall", 3, formula3_overall)

# combine results
model_overallglance <-
  bind_rows(
    summary0overall$glance,
    #summary1overall$glance,
    #summary2overall$glance,
    summary3overall$glance,
  ) %>%
  mutate(
    model_descr = fct_recode(as.character(model), !!!model_descr)
  )
write_csv(model_overallglance, fs::path(output_dir, "model_overallglance.csv"))

model_overalltidy <-
  bind_rows(
    summary0overall$tidy,
    #summary1overall$tidy,
    #summary2overall$tidy,
    summary3overall$tidy,
  ) %>%
  mutate(
    model_descr = fct_recode(as.character(model), !!!model_descr)
  )
write_csv(model_overalltidy, fs::path(output_dir, "model_overalltidy.csv"))


