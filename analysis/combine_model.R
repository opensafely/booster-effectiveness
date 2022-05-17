
# # # # # # # # # # # # # # # # # # # # #
# This script combines model info and estimates across all treatments and outcomes, for a given subgroup analysis
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)


if(length(args)==0){
  # use for interactive testing
  removeobs <- FALSE
  subgroup_variable <- "none"
  #subgroup_variable <- "none"
} else {
  removeobs <- TRUE
  subgroup_variable <- args[[1]]
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

output_dir <- here("output", "models", "seqtrialcox", "combined", subgroup_variable)
fs::dir_create(output_dir)

## import globally defined study dates and convert to "Date"
study_dates <-
  jsonlite::read_json(path=here("lib", "design", "study-dates.json")) %>%
  map(as.Date)

postbaselinecuts <- read_rds(here("lib", "design", "postbaselinecuts.rds"))

events_lookup <- read_rds(here("lib", "design", "event-variables.rds"))

## create lookup for treatment / outcome combinations ----

recode_treatment <- c(`BNT162b2` = "pfizer", `mRNA-1273` = "moderna")
recode_outcome <- set_names(events_lookup$event, events_lookup$event_descr)

if(subgroup_variable=="none"){
  recode_subgroup <- c(` `="none")
  recode_subgroup_variable <- c(`Main analysis` = "none")
  recode_subgroup_level <- c(`Any`="none")
  subgroup <- c("none")
}

if(subgroup_variable=="vax12_type"){
  recode_subgroup <- c(
    `Primary vaccine course: BNT162b2-BNT162b2` = "vax12_type-pfizer-pfizer",
    `Primary vaccine course: ChAdOx1-ChAdOx1` = "vax12_type-az-az"#,
    #`mRNA-1273-mRNA-1273` = "vax12_type-moderna-moderna"
  )
  recode_subgroup_variable <- c(`Primary vaccine course` = "vax12_type")
  recode_subgroup_level <- c(
    `BNT162b2-BNT162b2` = "pfizer-pfizer",
    `ChAdOx1-ChAdOx1` = "az-az"#,
    #`mRNA-1273-mRNA-1273` = "moderna-moderna"
  )
}

if(subgroup_variable=="cev"){
  recode_subgroup <- c(
    `Not Clinically Extremely Vulnerable` = "cev-FALSE",
    `Clinically Extremely Vulnerable` = "cev-TRUE"
  )
  recode_subgroup_variable <- c(`Clinically extremely vulnerable` = "cev")
  recode_subgroup_level <- c(
    `Not Clinically Extremely Vulnerable` = "FALSE",
    `Clinically Extremely Vulnerable` = "TRUE"
  )
}

if(subgroup_variable=="age65plus"){
  recode_subgroup <- c(
    `Aged 18-64` = "age65plus-FALSE",
    `Aged 65 and over` = "age65plus-TRUE"
  )
  recode_subgroup_variable <- c(`Age` = "age65plus")
  recode_subgroup_level <- c(
    `Aged 18-64` = "FALSE",
    `Aged 65 and over` = "TRUE"
  )
}

if(subgroup_variable=="prior_covid_infection"){
  recode_subgroup <- c(
    `No prior SARS-CoV-2 infection` = "prior_covid_infection-FALSE",
    `Prior SARS-CoV-2 infection` = "prior_covid_infection-TRUE"
  )
  recode_subgroup_variable <- c(`Prior SARS-CoV-2 infection` = "prior_covid_infection")
  recode_subgroup_level <- c(
    `No prior SARS-CoV-2 infection` = "FALSE",
    `Prior SARS-CoV-2 infection` = "TRUE",
  )
}


if(Sys.getenv("OPENSAFELY_BACKEND") %in% c("", "expectations")){
  model_metaparams <-
    expand_grid(
      treatment = factor(c("pfizer")),
      outcome = factor(c("postest")),
      subgroup = factor(recode_subgroup),
      subgroup_variable = factor(subgroup_variable),
    ) %>%
    mutate(
      subgroup_level = str_split_fixed(subgroup,"-",2)[,2],
      treatment_descr = fct_recode(treatment,  !!!recode_treatment),
      outcome_descr = fct_recode(outcome,  !!!recode_outcome),
      subgroup_descr = fct_recode(recode_subgroup,  !!!recode_subgroup),
      subgroup_variable_descr = fct_recode(subgroup_variable,  !!!recode_subgroup_variable),
      subgroup_level_descr = fct_recode(subgroup_level,  !!!recode_subgroup_level),
    )
} else {
  model_metaparams <-
    expand_grid(
      treatment = factor(c("pfizer", "moderna")),
      outcome = factor(c("postest", "covidemergency", "covidadmittedproxy1", "covidadmitted", "noncovidadmitted", "covidcc", "coviddeath", "noncoviddeath")),
      subgroup = factor(recode_subgroup),
      subgroup_variable = factor(subgroup_variable),
    ) %>%
    mutate(
      subgroup_level = str_split_fixed(subgroup,"-",2)[,2],
      treatment_descr = fct_recode(treatment,  !!!recode_treatment),
      outcome_descr = fct_recode(outcome,  !!!recode_outcome),
      subgroup_descr = fct_recode(subgroup,  !!!recode_subgroup),
      subgroup_variable_descr = fct_recode(subgroup_variable,  !!!recode_subgroup_variable),
      subgroup_level_descr = fct_recode(subgroup_level,  !!!recode_subgroup_level),
    )
}

# combine models ----

## effects ----

model_effects <-
  model_metaparams %>%
  mutate(
    effects = pmap(list(treatment, outcome, subgroup), function(x, y, z) read_csv(here("output", "models", "seqtrialcox", x, y, z, glue("report_effects.csv"))))
  ) %>%
  unnest(effects) %>%
  mutate(
    model_descr = fct_reorder(model_descr, model),
    hr = exp(estimate),
    hr.ll = exp(conf.low),
    hr.ul = exp(conf.high),
    ve = 1-hr,
    ve.ll = 1-hr.ul,
    ve.ul = 1-hr.ll
  ) %>%
  filter(
    # this filtering is necessary for dummy data,
    # so that sec.axis doesn't think `1-x` is a non-monotonic function
    # see - https://github.com/tidyverse/ggplot2/issues/3323#issuecomment-491421372
    #hr !=Inf, hr !=0,
    #hr.ll !=Inf, hr.ll !=0,
    #hr.ul !=Inf, hr.ul !=0,
  )

write_csv(model_effects, path = fs::path(output_dir, "effects.csv"))


model_overalleffects <-
  model_metaparams %>%
  mutate(
    overalleffects = pmap(list(treatment, outcome, subgroup), function(x, y, z) read_csv(here("output", "models", "seqtrialcox", x, y, z, glue("report_overalleffects.csv"))))
  ) %>%
  unnest(overalleffects) %>%
  mutate(
    model_descr = fct_reorder(model_descr, model),
    hr = exp(estimate),
    hr.ll = exp(conf.low),
    hr.ul = exp(conf.high),
    ve = 1-hr,
    ve.ll = 1-hr.ul,
    ve.ul = 1-hr.ll
  ) %>%
  filter(
    # this filtering is necessary for dummy data,
    # so that sec.axis doesn't think `1-x` is a non-monotonic function
    # see - https://github.com/tidyverse/ggplot2/issues/3323#issuecomment-491421372
    #hr !=Inf, hr !=0,
    #hr.ll !=Inf, hr.ll !=0,
    #hr.ul !=Inf, hr.ul !=0,
  )

write_csv(model_overalleffects, path = fs::path(output_dir, "overalleffects.csv"))


model_metaeffects <-
  model_metaparams %>%
  mutate(
    metaeffects = pmap(list(treatment, outcome, subgroup), function(x, y, z) read_csv(here("output", "models", "seqtrialcox", x, y, z, glue("report_metaeffects.csv"))))
  ) %>%
  unnest(metaeffects) %>%
  mutate(
    model_descr = fct_reorder(model_descr, model),
    hr = exp(estimate),
    hr.ll = exp(conf.low),
    hr.ul = exp(conf.high),
    ve = 1-hr,
    ve.ll = 1-hr.ul,
    ve.ul = 1-hr.ll
  ) %>%
  filter(
    # this filtering is necessary for dummy data,
    # so that sec.axis doesn't think `1-x` is a non-monotonic function
    # see - https://github.com/tidyverse/ggplot2/issues/3323#issuecomment-491421372
    #hr !=Inf, hr !=0,
    #hr.ll !=Inf, hr.ll !=0,
    #hr.ul !=Inf, hr.ul !=0,
  )

write_csv(model_metaeffects, path = fs::path(output_dir, "metaeffects.csv"))


model_meta2effects <-
  model_metaparams %>%
  mutate(
    meta2effects = pmap(list(treatment, outcome, subgroup), function(x, y, z) read_csv(here("output", "models", "seqtrialcox", x, y, z, glue("report_meta2effects.csv"))))
  ) %>%
  unnest(meta2effects) %>%
  mutate(
    model_descr = fct_reorder(model_descr, model),
    hr = exp(estimate),
    hr.ll = exp(conf.low),
    hr.ul = exp(conf.high),
    ve = 1-hr,
    ve.ll = 1-hr.ul,
    ve.ul = 1-hr.ll
  )

write_csv(model_meta2effects, path = fs::path(output_dir, "meta2effects.csv"))


formatpercent100 <- function(x,accuracy){
  formatx <- scales::label_percent(accuracy)(x)

  if_else(
    formatx==scales::label_percent(accuracy)(1),
    paste0(">",scales::label_percent(1)((100-accuracy)/100)),
    formatx
  )
}

model_descr = c(
  "Matched" = "0",
  "region- and trial-stratified" = "1",
  "Demographic adjustment" = "2",
  "Matched and fully Adjusted" = "3"
)


y_breaks <- c(0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2)
if(subgroup_variable=="none"){
  legend_position <- "none"
}  else{
  legend_position <- "bottom"
}

plot_effects <-
  model_effects %>%
  filter(
    model %in% c(3)
  ) %>%
  mutate(
    model_descr = fct_recode(as.character(model), !!!model_descr)
  ) %>%
  ggplot() +
  geom_point(aes(y=hr, x=term_midpoint, colour=subgroup_descr), position = position_dodge(width = 1.8))+
  geom_linerange(aes(ymin=hr.ll, ymax=hr.ul, x=term_midpoint, colour=subgroup_descr), position = position_dodge(width = 1.8))+
  geom_hline(aes(yintercept=1), colour='grey')+
  facet_grid(rows=vars(outcome_descr), cols=vars(treatment_descr), switch="y")+
  scale_y_log10(
    breaks=y_breaks,
    limits = c(0.005, 2),
    oob = scales::oob_keep,
    # sec.axis = sec_axis(
    #   ~(1-.),
    #   name="Effectiveness",
    #   breaks = 1-(y_breaks),
    #   labels = function(x){formatpercent100(x, 1)}
    #  )
  )+
  scale_x_continuous(breaks=postbaselinecuts, limits=c(min(postbaselinecuts), max(postbaselinecuts)+1), expand = c(0, 0))+
  scale_colour_brewer(type="qual", palette="Set2", guide=guide_legend(ncol=1))+
  labs(
    y="Hazard ratio",
    x="Days since booster dose",
    colour=NULL
   ) +
  theme_bw()+
  theme(
    panel.border = element_blank(),
    axis.line.y = element_line(colour = "black"),
    axis.line.y.right = element_blank(),

    panel.grid.minor.x = element_blank(),
    panel.grid.minor.y = element_blank(),
    strip.background = element_blank(),
    strip.placement = "outside",
    strip.text.y.left = element_text(angle = 0),

    panel.spacing = unit(0.8, "lines"),

    plot.title = element_text(hjust = 0),
    plot.title.position = "plot",
    plot.caption.position = "plot",
    plot.caption = element_text(hjust = 0, face= "italic"),

    legend.position = legend_position
   ) +
 NULL
plot_effects
## save plot

ggsave(filename=fs::path(output_dir, "effectsplot.svg"), plot_effects, width=20, height=15, units="cm")
ggsave(filename=fs::path(output_dir, "effectsplot.png"), plot_effects, width=20, height=15, units="cm")
ggsave(filename=fs::path(output_dir, "effectsplot.pdf"), plot_effects, width=20, height=15, units="cm")


## diagnostics ----


glance <-
  model_metaparams %>%
  mutate(
    glance = pmap(list(treatment, outcome, subgroup), function(x, y, z) read_csv(here("output", "models", "seqtrialcox", x, y, z, glue("report_glance.csv")))),
  ) %>%
  unnest(glance) %>%
  mutate(
    model_descr = fct_inorder(model_descr),
  )

write_csv(glance, path = fs::path(output_dir, "model_diagnostics.csv"))




## incidence rates ----

incidence <-
  model_metaparams %>%
  mutate(
    incidence = pmap(list(treatment, outcome, subgroup), function(x, y, z) read_csv(here("output", "models", "seqtrialcox", x, y, z, glue("report_incidence.csv"))))
  ) %>%
  unnest(incidence)

write_csv(incidence, fs::path(output_dir, "incidence.csv"))

incidence %>% filter(fup_period=="All") %>% write_csv(fs::path(output_dir, "incidence_all.csv"))

gt_incidence <-
  incidence %>%
  select(-treatment, -outcome, -starts_with("events_"), -starts_with("yearsatrisk_"), -rrE) %>%
  gt(
    groupname_col = c("treatment_descr", "outcome_descr", "subgroup_descr"),
  ) %>%
  cols_label(
    outcome_descr = "Outcome",
    fup_period = "Time since recruitment",

    n_0 = "Patients at risk",
    n_1 = "Patients at risk",

    q_0 = "Events / person-years",
    q_1   = "Events / person-years",

    rate_0 = "Incidence",
    rate_1 = "Incidence",

    rr = "Incidence rate ratio",
    rrCI = "95% CI"
  ) %>%
  tab_spanner(
    label = "Boosted",
    columns = ends_with("1")
  ) %>%
  tab_spanner(
    label = "Unboosted",
    columns = ends_with("0")
  ) %>%
  fmt_number(
    columns = c("rate_0", "rate_1", "rr"),
    decimals = 2
  ) %>%
  fmt_number(
    columns = starts_with(c("n_")),
    decimals = 0,
    sep_mark = ","
  ) %>%
  fmt_missing(
    everything(),
    missing_text="--"
  ) %>%
  cols_align(
    align = "right",
    columns = everything()
  ) %>%
  cols_align(
    align = "left",
    columns = "fup_period"
  )

gtsave(gt_incidence, fs::path(output_dir, "incidence.html"))


## km rates ----

km <- model_metaparams %>%
  mutate(
    km = pmap(list(treatment, outcome, subgroup), function(x, y, z) read_csv(here("output", "models", "seqtrialcox", x, y, z, glue("report_km.csv"))))
  ) %>%
  unnest(km)

write_csv(km, fs::path(output_dir, "km.csv"))



plot_km <-
  km %>%
  mutate(
    treatment_subgroup_descr = paste0(subgroup_descr, " \n", treatment_descr)
  ) %>%
  ggplot(aes(group=treated_descr, colour=treated_descr, fill=treated_descr)) +
  geom_step(aes(x=time, y=1-surv))+
  geom_rect(aes(xmin=time, xmax=time+1, ymin=1-surv.ll, ymax=1-surv.ul), alpha=0.1, colour="transparent")+
  facet_grid(rows=vars(outcome_descr), cols=vars(treatment_subgroup_descr), switch="y")+
  scale_color_brewer(type="qual", palette="Set1", na.value="grey") +
  scale_fill_brewer(type="qual", palette="Set1", guide="none", na.value="grey") +
  scale_x_continuous(breaks = seq(0,600,14), limits=c(min(postbaselinecuts), max(postbaselinecuts)+1), expand = c(0, 0))+
  scale_y_continuous(expand = expansion(mult=c(0,0.01)))+
  coord_cartesian(xlim=c(0, NA))+
  labs(
    x="Days",
    y="Cumulative incidence",
    colour=NULL,
    title=NULL
  )+
  theme_minimal()+
  theme(
    axis.line.x = element_line(colour = "black"),
    panel.grid.minor.x = element_blank(),
    legend.position=c(.05,.95),
    legend.justification = c(0,1),
  )+
  NULL
plot_km
## save plot

ggsave(filename=fs::path(output_dir, "kmplot.svg"), plot_km, width=20, height=15, units="cm")
ggsave(filename=fs::path(output_dir, "kmplot.png"), plot_km, width=20, height=15, units="cm")
ggsave(filename=fs::path(output_dir, "kmplot.pdf"), plot_km, width=20, height=15, units="cm")



## CIF rates ----

cif <- model_metaparams %>%
  mutate(
    cif = pmap(list(treatment, outcome, subgroup), function(x, y, z) read_csv(here("output", "models", "seqtrialcox", x, y, z, glue("report_cif.csv"))))
  ) %>%
  unnest(cif)

write_csv(cif, fs::path(output_dir, "cif.csv"))



plot_cif <-
  cif %>%
  filter(event==outcome) %>%
  mutate(
    treatment_subgroup_descr = paste0(subgroup_descr, " \n", treatment_descr)
  ) %>%
  ggplot(aes(group=treated_descr, colour=treated_descr, fill=treated_descr)) +
  geom_step(aes(x=time, y=cmlinc))+
  geom_rect(aes(xmin=time, xmax=time+1, ymin=cmlinc.ll, ymax=cmlinc.ul), alpha=0.1, colour="transparent")+
  facet_grid(rows=vars(outcome_descr), cols=vars(treatment_subgroup_descr), switch="y")+
  scale_color_brewer(type="qual", palette="Set1", na.value="grey") +
  scale_fill_brewer(type="qual", palette="Set1", guide="none", na.value="grey") +
  scale_x_continuous(breaks = seq(0,600,14), limits=c(min(postbaselinecuts), max(postbaselinecuts)+1), expand = c(0, 0))+
  scale_y_continuous(expand = expansion(mult=c(0,0.01)))+
  coord_cartesian(xlim=c(0, NA))+
  labs(
    x="Days",
    y="Cumulative incidence",
    colour=NULL,
    title=NULL
  )+
  theme_minimal()+
  theme(
    axis.line.x = element_line(colour = "black"),
    panel.grid.minor.x = element_blank(),
    legend.position=c(.05,.95),
    legend.justification = c(0,1),
  )+
  NULL
plot_cif

ggsave(filename=fs::path(output_dir, "cifplot.png"), plot_cif, width=20, height=15, units="cm")
