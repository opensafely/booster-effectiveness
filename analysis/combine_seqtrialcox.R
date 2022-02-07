
# # # # # # # # # # # # # # # # # # # # #
# This script combines matching info and model info and estimates across all treatments and outcomes
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

output_dir <- here("output", "models", "seqtrialcox", "combined")
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

if(Sys.getenv("OPENSAFELY_BACKEND") %in% c("", "expectations")){
  model_metaparams <-
    expand_grid(
      treatment = factor(c("pfizer")),
      outcome = factor(c("postest")),
    ) %>%
    mutate(
      treatment_descr = fct_recode(treatment,  !!!recode_treatment),
      outcome_descr = fct_recode(outcome,  !!!recode_outcome)
    )
} else {
  model_metaparams <-
    expand_grid(
      treatment = factor(c("pfizer", "moderna")),
      outcome = factor(c("postest", "covidemergency", "coviddeath")),
    ) %>%
    mutate(
      treatment_descr = fct_recode(treatment,  !!!recode_treatment),
      outcome_descr = fct_recode(outcome,  !!!recode_outcome)
    )

}

match_metaparams <-
  model_metaparams %>%
  select(treatment, treatment_descr) %>%
  unique()

# combine matching ----

## match coverage ---

matchcoverage <-
  match_metaparams %>%
  mutate(
    coverage = map(treatment,  ~read_csv(here("output", "models", "seqtrialcox", .x, glue("match_data_coverage.csv"))))
  ) %>%
  unnest(coverage)

write_csv(matchcoverage, fs::path(output_dir, "matchcoverage.csv"))



## match summary ---

matchsummary <-
  match_metaparams %>%
  mutate(
    summary = map(treatment, ~read_csv(here("output", "models", "seqtrialcox", .x, glue("match_summary.csv"))))
  ) %>%
  unnest(summary)

write_csv(matchsummary, fs::path(output_dir, "matchsummary.csv"))


matchsummary_treated <-
  match_metaparams %>%
  mutate(
    summary = map(treatment, ~read_csv(here("output", "models", "seqtrialcox", .x, glue("match_summary_treated.csv"))))
  ) %>%
  unnest(summary)

write_csv(matchsummary_treated, fs::path(output_dir, "matchsummary_treated.csv"))


## table 1 ----


table1 <-
  match_metaparams %>%
  mutate(
    table1 = map(treatment, ~read_csv(here("output", "models", "seqtrialcox", .x, glue("merge_table1.csv"))))
  ) %>%
  unnest(table1)

write_csv(table1, fs::path(output_dir, "matchtable1.csv"))

table1by <-
  match_metaparams %>%
  mutate(
    table1by = map(treatment, ~read_csv(here("output", "models", "seqtrialcox", .x, glue("merge_table1by.csv"))))
  ) %>%
  unnest(table1by)

write_csv(table1by, fs::path(output_dir, "matchtable1by.csv"))

# combine models ----

## effects ----

model_effects <-
  model_metaparams %>%
  mutate(
    effects = map2(treatment, outcome, ~read_csv(here("output", "models", "seqtrialcox", .x, .y, glue("report_effects.csv"))))
  ) %>%
  unnest(effects) %>%
  mutate(
    model_descr = fct_reorder(model_descr, model),
    hr = exp(estimate),
    hr.ll = exp(conf.low),
    hr.ul = exp(conf.high)
  ) %>%
  filter(
    # this filtering is necessary for dummy data,
    # so that sec.axis doesn't think `1-x` is a non-monotonic function
    # see - https://github.com/tidyverse/ggplot2/issues/3323#issuecomment-491421372
    hr !=Inf, hr !=0,
    hr.ll !=Inf, hr.ll !=0,
    hr.ul !=Inf, hr.ul !=0,
  )



write_csv(model_effects, path = fs::path(output_dir, "effects.csv"))

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

plot_effects <-
  model_effects %>%
  filter(
    model %in% c(0,3)
  ) %>%
  mutate(
    model_descr = fct_recode(as.character(model), !!!model_descr)
  ) %>%
  ggplot(data = ) +
  geom_point(aes(y=hr, x=term_midpoint, colour=model_descr), position = position_dodge(width = 1.8))+
  geom_linerange(aes(ymin=hr.ll, ymax=hr.ul, x=term_midpoint, colour=model_descr), position = position_dodge(width = 1.8))+
  geom_hline(aes(yintercept=1), colour='grey')+
  facet_grid(rows=vars(outcome_descr), cols=vars(treatment_descr), switch="y")+
  scale_y_log10(
    breaks=y_breaks,
    limits = c(0.005, 2),
    oob = scales::oob_keep,
    sec.axis = sec_axis(
      ~(1-.),
      name="Effectiveness",
      breaks = 1-(y_breaks),
      labels = function(x){formatpercent100(x, 1)}
     )
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

    legend.position = "bottom"
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
    glance = map2(treatment, outcome, ~read_csv(here("output", "models", "seqtrialcox", .x, .y, glue("report_glance.csv")))),
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
    incidence = map2(treatment, outcome, ~read_csv(here("output", "models", "seqtrialcox", .x, .y, glue("report_incidence.csv"))))
  ) %>%
  unnest(incidence)

write_csv(incidence, fs::path(output_dir, "incidence.csv"))


gt_incidence <-
  incidence %>%
  select(-treatment, -outcome, -starts_with("events_"), -starts_with("yearsatrisk_"), -rrE) %>%
  gt(
    groupname_col = c("treatment_descr", "outcome_descr"),
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

