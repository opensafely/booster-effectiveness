# # # # # # # # # # # # # # # # # # # # #
# This script:
# imports matching data
# reports on matching coverage, matching flowcharts, creates a "table 1", etc
#
# The script must be accompanied by one argument:
# `treatment` - the exposure in the regression model, pfizer or moderna

# # # # # # # # # # # # # # # # # # # # #

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
library('MatchIt')

## Import custom user functions from lib

source(here("lib", "functions", "utility.R"))
source(here("lib", "functions", "survival.R"))
source(here("lib", "functions", "redaction.R"))

postbaselinecuts <- read_rds(here("lib", "design", "postbaselinecuts.rds"))



# create output directories ----

output_dir <- here("output", "match", treatment)
fs::dir_create(output_dir)

## create special log file ----
cat(glue("## script info for {treatment} ##"), "  \n", file = fs::path(output_dir, glue("merge_log.txt")), append = FALSE)

## functions to pass additional log info to seperate file
logoutput <- function(...){
  cat(..., file = fs::path(output_dir, glue("merge_log.txt")), sep = "\n  ", append = TRUE)
  cat("\n", file = fs::path(output_dir, glue("merge_log.txt")), sep = "\n  ", append = TRUE)
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
    file=fs::path(output_dir, glue("merge_log.txt")),
    append=TRUE
  )
  cat("\n", file = fs::path(output_dir, glue("merge_log.txt")), sep = "\n  ", append = TRUE)
}

## import globally defined study dates and convert to "Date"
study_dates <-
  jsonlite::read_json(path=here("lib", "design", "study-dates.json")) %>%
  map(as.Date)



## import metadata ----
events <- read_rds(here("lib", "design", "event-variables.rds"))


## import matching info ----
data_matchstatus <- read_rds(fs::path(output_dir, "match_data_matchstatus.rds"))
data_merged <- read_rds(fs::path(output_dir, "match_data_merged.rds"))
data_rollingstrata_vaxcount <- read_rds(fs::path(output_dir, "match_data_rollingstrata_vaxcount.rds"))
rolling_variables <- group_vars(data_rollingstrata_vaxcount)

# same but trial participants only
data_matched <-
  data_merged %>%
  filter(matched==1L) %>%
  mutate(
    treated_patient_id = paste0(treated, "_", patient_id),
    fup = pmin(tte_matchcensor - tte_recruitment, last(postbaselinecuts))
  )

logoutput_datasize(data_matched)


# matching coverage per trial / day of follow up


status_recode <- c(`Boosted, ineligible` = "ineligible", `Boosted, eligible, unmatched`= "unmatched", `Boosted, eligible, matched` = "matched", `Control` = "control")


# matching coverage for boosted people
data_coverage <-
  data_merged %>%
  filter(treated==1L) %>%
  group_by(across(all_of(rolling_variables)), vax3_date) %>%
  summarise(
    n_treated=sum(treated, na.rm=TRUE),
    n_eligible=sum(eligible, na.rm=TRUE),
    n_matched=sum(matched, na.rm=TRUE)
  ) %>%
  mutate(
    n_unmatched = n_eligible - n_matched,
    n_ineligible = n_treated - n_eligible,
  ) %>%
  pivot_longer(
    cols = c(n_ineligible, n_unmatched, n_matched),
    names_to = "status",
    names_prefix = "n_",
    values_to = "n"
  ) %>%
  arrange(jcvi_group, vax12_type, vax3_date, status) %>%
  group_by(jcvi_group, vax12_type, vax3_date, status) %>%
  summarise(
    n = sum(n),
  ) %>%
  group_by(jcvi_group, vax12_type, status) %>%
  complete(
    vax3_date = full_seq(.$vax3_date, 1), # go X days before to
    fill = list(n=0)
  ) %>%
  mutate(
    cumuln = cumsum(n)
  ) %>%
  ungroup() %>%
  mutate(
    status = factor(status, levels=c("ineligible", "unmatched", "matched")),
    status_descr = fct_recode(status, !!!status_recode[1:3])
  ) %>%
  arrange(status_descr, vax3_date)

write_csv(data_coverage, fs::path(output_dir, "merge_data_coverage.csv"))

# report matching info ----

day1_date <- study_dates$index_date

## candidate matching summary ----

## matching summary ----

# summary of matching, by treatment day
candidate_summary_trial <-
  data_matchstatus %>%
  filter(treated==1L) %>%
  group_by(trial_time) %>%
  summarise(
    n_treated=sum(treated, na.rm=TRUE),
    n_eligible=sum(eligible, na.rm=TRUE),
    n_matched=sum(matched, na.rm=TRUE),
    n_unmatched=n_eligible-n_matched,
  ) %>%
  ungroup()


# summary of trial participants, by trial and treatment group
match_summary_trial <-
  data_matched %>%
  group_by(trial_time, treated) %>%
  summarise(
    n=n(),
    fup_sum = sum(fup),
    fup_years = sum(fup)/365.25,
    fup_mean = mean(fup),
    fup_median = median(fup)
  ) %>%
  arrange(
    trial_time, treated
  ) %>%
  pivot_wider(
    id_cols = c(trial_time),
    names_from = treated,
    values_from = c(n, fup_sum, fup_years, fup_mean)
  ) %>%
  left_join(candidate_summary_trial, by="trial_time") %>%
  mutate(
    prop_matched_treated = n_1/n_treated,
    prop_matched_eligible = n_1/n_eligible,
    prop_eligible_treated = n_eligible/n_treated
  )

write_csv(match_summary_trial, fs::path(output_dir, "merge_summary_trial.csv"))

# summary of trial participants, by treatment group
match_summary_treated <-
  data_matched %>%
  group_by(treated) %>%
  summarise(
    n=n(),
    firstrecruitdate = min(tte_recruitment) + day1_date,
    lastrecruitdate = max(tte_recruitment) + day1_date,
    fup_sum = sum(fup),
    fup_years = sum(fup)/365.25,
    fup_mean = mean(fup),
    fup_median = median(fup),

    n_12pfizer = sum(vax12_type=="pfizer-pfizer"),
    prop_12pfizer = n_12pfizer/n,
    n_12az = sum(vax12_type=="az-az"),
    prop_12az = n_12az/n,
    # n_12moderna = sum(vax12_type=="moderna-moderna"),
    # prop_12moderna = n_12moderna/n,

    age_median = median(age),
    age_Q1 = quantile(age, 0.25),
    age_Q3 = quantile(age, 0.75),
    female = mean(sex=="Female"),
  )

write_csv(match_summary_treated, fs::path(output_dir, "merge_summary_treated.csv"))



# summary of boosted people
candidate_summary <-
  data_matchstatus %>%
  filter(treated==1L) %>%
  summarise(
    n_treated=sum(treated, na.rm=TRUE),
    n_eligible=sum(eligible, na.rm=TRUE),
    n_matched=sum(matched, na.rm=TRUE),
    n_unmatched=n_eligible-n_matched,
  )

# summary of matching, overall
match_summary <-
  data_matched %>%
  summarise(
    n=n(),
    firstrecruitdate = min(tte_recruitment) + day1_date,
    lastrecruitdate = max(tte_recruitment) + day1_date,
    fup_sum = sum(fup),
    fup_years = sum(fup)/365.25,
    fup_mean = mean(fup),
    fup_median = median(fup),

    n_12pfizer = sum(vax12_type=="pfizer-pfizer"),
    prop_12pfizer = n_12pfizer/n,
    n_12az = sum(vax12_type=="az-az"),
    prop_12az = n_12az/n,
    # n_12moderna = sum(vax12_type=="moderna-moderna"),
    # prop_12moderna = n_12moderna/n,

    age_median = median(age),
    age_Q1 = quantile(age, 0.25),
    age_Q3 = quantile(age, 0.75),
    female = mean(sex=="Female"),

  ) %>%
  bind_cols(candidate_summary) %>%
  mutate(
    prop_matched_treated = n_matched/n_treated,
    prop_matched_eligible = n_matched/n_eligible,
    prop_eligible_treated = n_eligible/n_treated
  )

write_csv(match_summary, fs::path(output_dir, "merge_summary.csv"))



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
      group=status,
      fill=status,
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
ggsave(plot_coverage_n, filename="merge_coverage_count.png", path=output_dir)
ggsave(plot_coverage_n, filename="merge_coverage_count.pdf", path=output_dir)


plot_coverage_cumuln <-
  data_coverage %>%
  ggplot()+
  geom_col(
    aes(
      x=vax3_date+0.5,
      y=cumuln,
      group=status,
      fill=status,
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
ggsave(plot_coverage_cumuln, filename="merge_coverage_stack.png", path=output_dir)
ggsave(plot_coverage_cumuln, filename="merge_coverage_stack.pdf", path=output_dir)




# table 1 style baseline characteristics ----

library('gt')
library('gtsummary')

var_labels <- list(
  N  ~ "Total N",
  status_descr ~ "Recruitment status",
  vax12_type_descr ~ "Primary vaccine course",
  #age ~ "Age",
  ageband ~ "Age",
  sex ~ "Sex",
  ethnicity_combined ~ "Ethnicity",
  imd_Q5 ~ "IMD",
  region ~ "Region",
  #rural_urban_group ~ "Rural/urban category",
  #cev ~ "Clinically extremely vulnerable",
  cev_cv ~ "JCVI clinical risk group",

  sev_obesity ~ "Body Mass Index > 40 kg/m^2",

  chronic_heart_disease ~ "Chronic heart disease",
  chronic_kidney_disease ~ "Chronic kidney disease",
  diabetes ~ "Diabetes",
  chronic_liver_disease ~ "Chronic liver disease",
  chronic_resp_disease ~ "Chronic respiratory disease",
  asthma ~ "Asthma",
  chronic_neuro_disease ~ "Chronic neurological disease",

  #multimorb ~ "Morbidity count",
  immunosuppressed ~ "Immunosuppressed",
  asplenia ~ "Asplenia or poor spleen function",
  learndis ~ "Learning disabilities",
  sev_mental ~ "Serious mental illness",

  prior_tests_cat ~ "Number of SARS-CoV-2 tests",

  prior_covid_infection ~ "Prior documented SARS-CoV-2 infection",
  status_hospplanned ~ "In hospital (planned admission)"
) %>%
  set_names(., map_chr(., all.vars))

map_chr(var_labels[-c(1,2)], ~last(as.character(.)))

tab_summary_baseline <-
  data_merged %>%
  mutate(
    N = 1L,
    status_descr = fct_recode(status, !!!status_recode),
    #TODO can remove once data_process has rerun
    cev_cv = case_when(
      cev ~ "Clinically extremely vulnerable",
      cv ~ "Clinically at-risk",
      TRUE ~ "Not Clinically at-risk"
    ),
  ) %>%
  select(
    status_descr,
    all_of(names(var_labels)),
  ) %>%
  tbl_summary(
    by = status_descr,
    label = unname(var_labels[names(.)]),
    statistic = list(N = "{N}")
  ) %>%
  modify_footnote(starts_with("stat_") ~ NA) %>%
  modify_header(stat_by = "**{level}**") %>%
  bold_labels()

tab_summary_baseline_redacted <- redact_tblsummary(tab_summary_baseline, 5, "[REDACTED]")

raw_stats <- tab_summary_baseline_redacted$meta_data %>%
  select(var_label, df_stats) %>%
  unnest(df_stats)

write_csv(tab_summary_baseline_redacted$table_body, fs::path(output_dir, "merge_table1.csv"))
write_csv(tab_summary_baseline_redacted$df_by, fs::path(output_dir, "merge_table1by.csv"))
gtsave(as_gt(tab_summary_baseline_redacted), fs::path(output_dir, "merge_table1.html"))

# love / smd plot ----


data_smd <- tab_summary_baseline$meta_data %>%
  select(var_label, df_stats) %>%
  unnest(df_stats) %>%
  filter(
    by %in% c("Boosted, eligible, matched", "Control"),
    variable != "N"
  ) %>%
  group_by(var_label, variable_levels) %>%
  summarise(
    diff = diff(p),
    sd = sqrt(sum(p*(1-p))),
    smd = diff/sd
  ) %>%
  ungroup() %>%
  mutate(
    variable = factor(var_label, levels=map_chr(var_labels[-c(1,2)], ~last(as.character(.)))),
    variable_card = as.numeric(variable)%%2,
    variable_levels = replace_na(as.character(variable_levels), ""),
  ) %>%
  arrange(variable) %>%
  mutate(
    level = fct_rev(fct_inorder(str_replace(paste(variable, variable_levels, sep=": "),  "\\:\\s$", ""))),
    cardn = row_number()
  )

plot_smd <-
  ggplot(data_smd)+
  geom_point(aes(x=smd, y=level))+
  geom_rect(aes(alpha = variable_card, ymin = rev(cardn)-0.5, ymax =rev(cardn+0.5)), xmin = -Inf, xmax = Inf, fill='grey', colour="transparent") +
  scale_alpha_continuous(range=c(0,0.3), guide=FALSE)+
  labs(
    x="Standardised mean difference",
    y=NULL,
    alpha=NULL
  )+
  theme_minimal() +
  theme(
    strip.placement = "outside",
    strip.background = element_rect(fill="transparent", colour="transparent"),
    strip.text.y.left = element_text(angle = 0, hjust=1),
    panel.grid.major.y = element_blank(),
    panel.grid.minor.y = element_blank(),
    panel.spacing = unit(0, "lines")
  )

write_csv(data_smd, fs::path(output_dir, "merge_data_smd.csv"))
ggsave(plot_smd, filename="merge_plot_smd.png", path=output_dir)
ggsave(plot_smd, filename="merge_plot_smd.pdf", path=output_dir)



# flowchart ----


data_processed <- read_rds(here("output", "data", "data_processed.rds"))

data_criteria <-
  left_join(
    data_processed,
    data_merged %>%
      filter(treated==1L) %>%
      transmute(
        patient_id,
        trial_time,
        matched,
        status_hospunplanned,
        status_hospplanned,
        mostrecent_anycovid = replace_na(mostrecent_anycovid, 10000000),
        status_hospunplanned,
        treated_within_recruitment_period
      ),
    by = "patient_id"
  )
if(removeobjects) rm(data_processed)

data_criteria <-
  data_criteria %>%
  left_join(
    data_merged %>%
      filter(control==1L) %>%
      transmute(
        patient_id,
        control,
      ),
    by = "patient_id"
  ) %>%
  transmute(
    patient_id,
    vax3_treatment = vax3_type == treatment,
    has_age = !is.na(age),
    has_sex = !is.na(sex) & !(sex %in% c("I", "U")),
    has_imd = !is.na(imd),
    has_ethnicity = !is.na(ethnicity_combined),
    has_region = !is.na(region),
    #has_msoa = !is.na(msoa),
    isnot_hscworker = !hscworker,
    isnot_carehomeresident = !care_home_combined,
    isnot_endoflife = !endoflife,
    isnot_housebound = !housebound,
    vax1_afterfirstvaxdate = case_when(
      (vax1_type=="pfizer") & (vax1_date >= study_dates$firstpfizer_date) ~ TRUE,
      (vax1_type=="az") & (vax1_date >= study_dates$firstaz_date) ~ TRUE,
      (vax1_type=="moderna") & (vax1_date >= study_dates$firstmoderna_date) ~ TRUE,
      TRUE ~ FALSE
    ),
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
    vax2_beforelastvaxdate = !is.na(vax2_date) & (vax2_date <= study_dates$lastvax2_date),
    vax3_notbeforestartdate = case_when(
      (vax3_type=="pfizer") & (vax3_date < study_dates$pfizerstart_date) ~ FALSE,
      #(vax3_type=="az") & (vax1_date >= study_dates$azstart_date) ~ TRUE,
      (vax3_type=="moderna") & (vax3_date < study_dates$modernastart_date) ~ FALSE,
      TRUE ~ TRUE
    ),
    vax3_beforeenddate = case_when(
      (vax1_type=="pfizer") & (vax3_date <= study_dates$pfizerend_date) & !is.na(vax3_date) ~ TRUE,
      #(vax1_type=="az") & (vax1_date <= study_dates$azend_date) & !is.na(vax3_date) ~ TRUE,
      (vax1_type=="moderna") & (vax3_date <= study_dates$modernaend_date) & !is.na(vax3_date) ~ TRUE,
      TRUE ~ FALSE
    ),
    vax3_beforecensordate = (vax3_date-1 < censor_date) & !is.na(vax3_date),
    vax12_homologous = vax1_type==vax2_type,
    has_vaxgap12 = vax2_date >= (vax1_date+17), # at least 17 days between first two vaccinations
    has_vaxgap23 = vax3_date >= (vax2_date+17) | is.na(vax3_date), # at least 17 days between second and third vaccinations
    has_knownvax1 = vax1_type %in% c("pfizer", "az"),
    has_knownvax2 = vax2_type %in% c("pfizer", "az"),
    has_expectedvax3type = vax3_type %in% c("pfizer", "moderna"),

    has_norecentcovid = !((mostrecent_anycovid>= trial_time-90) & (mostrecent_anycovid<= trial_time)),
    isnot_inhospital = status_hospunplanned==0L,

    isnot_unusual = treated_within_recruitment_period,

    is_treatedandmatched = matched %in% 1L,

    is_control = control %in% 1L
  )



data_flowchart <-
  data_criteria %>%
  transmute(
    c0 = vax1_afterfirstvaxdate & vax2_beforelastvaxdate & vax3_treatment & vax3_notbeforestartdate & vax3_beforeenddate & vax3_beforecensordate,
    #c1_1yearfup = c0_all & (has_follow_up_previous_year),
    c1 = c0 & (has_vaxgap12 & has_vaxgap23 & has_knownvax1 & has_knownvax2 & vax12_homologous),
    c2 = c1 & (isnot_hscworker ),
    c3 = c2 & (isnot_carehomeresident & isnot_endoflife & isnot_housebound),
    c4 = c3 & (has_age & has_sex & has_imd & has_ethnicity & has_region),
    c5 = c4 & (has_norecentcovid),
    c6 = c5 & (isnot_inhospital),
    c7 = c6 & (isnot_unusual),
    c8 = c7 & (is_treatedandmatched),
    c9 = c8 & (is_control)
  ) %>%
  summarise(
    across(.fns=sum)
  ) %>%
  pivot_longer(
    cols=everything(),
    names_to="criteria",
    values_to="n"
  ) %>%
  mutate(
    n_exclude = lag(n) - n,
    pct_exclude = n_exclude/lag(n),
    pct_all = n / first(n),
    pct_step = n / lag(n),
    crit = str_extract(criteria, "^c\\d+"),
    criteria = fct_case_when(
      crit == "c0" ~ "Aged 18+ and recieved booster dose between 16 September and 1 December 2021 inclusive", # paste0("Aged 18+\n with 2 doses on or before ", format(study_dates$lastvax2_date, "%d %b %Y")),
      crit == "c1" ~ "  with homologous primary vaccination course of BNT162b2 or ChAdOx1-S",
      crit == "c2" ~ "  and not a HSC worker",
      crit == "c3" ~ "  and not a care/nursing home resident, end-of-life or housebound",
      crit == "c4" ~ "  with no missing demographic information",
      crit == "c5" ~ "  and no evidence of SARS-CoV-2 infection within 90 days of boosting",
      crit == "c6" ~ "  and not in hospital when boosted",
      crit == "c7" ~ "  and not boosted at an unusual time given region, priority group, and second dose date",
      crit == "c8" ~ "  and successfully matched to an unboosted control",
      crit == "c9" ~ "  and also selected as a control in an earlier trial",
      TRUE ~ NA_character_
    ),
    stage = fct_case_when(
      crit %in% paste0("c", 0) ~ "Boosted",
      crit %in% paste0("c", 4) ~ "Eligible (people)",
      crit %in% paste0("c", 7) ~ "Eligible (context)",
      crit %in% paste0("c", 8) ~ "Matched"
    )
  )
write_csv(data_flowchart, fs::path(output_dir, "merge_data_flowchart.csv"))
