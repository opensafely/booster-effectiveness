
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


output_dir <- here("output", "models", "seqtrialcox", "combined")
fs::dir_create(output_dir)

## import globally defined study dates and convert to "Date"
study_dates <-
  jsonlite::read_json(path=here("lib", "design", "study-dates.json")) %>%
  map(as.Date)

postbaselinecuts <- read_rds(here("lib", "design", "postbaselinecuts.rds"))

events_lookup <- read_rds(here("lib", "design", "event-variables.rds"))

recode_treatment <- c(
  `BNT162b2` = "pfizer",
  `mRNA-1273` = "moderna"
)

recode_outcome <- set_names(events_lookup$event_descr, events_lookup$event)

if(Sys.getenv("OPENSAFELY_BACKEND") %in% c("", "expectations")){
  model_metaparams <-
    expand_grid(
      treatment = factor(c("pfizer")),
      outcome = factor(c("covidadmitted")),
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


## models ----

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


write_csv(model_effects, path = fs::path(output_dir, "report_effects.csv"))

formatpercent100 <- function(x,accuracy){
  formatx <- scales::label_percent(accuracy)(x)

  if_else(
    formatx==scales::label_percent(accuracy)(1),
    paste0(">",scales::label_percent(1)((100-accuracy)/100)),
    formatx
  )
}

y_breaks <- c(0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1, 2)

plot_effects <-
  ggplot(data = model_effects) +
  geom_point(aes(y=hr, x=term_midpoint, colour=model_descr), position = position_dodge(width = 1.8))+
  geom_linerange(aes(ymin=hr.ll, ymax=hr.ul, x=term_midpoint, colour=model_descr), position = position_dodge(width = 1.8))+
  geom_hline(aes(yintercept=1), colour='grey')+
  facet_grid(rows=vars(outcome), cols=vars(treatment_descr), switch="y")+
  scale_y_log10(
    breaks=y_breaks,
    limits = c(0.05, max(c(1, model_effects$hr.ul))),
    oob = scales::oob_keep,
    # sec.axis = sec_axis(
    #   ~(1-.),
    #   name="Effectiveness",
    #   breaks = 1-(y_breaks),
    #   labels = function(x){formatpercent100(x, 1)}
    # )
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

ggsave(filename=fs::path(output_dir, "report_effectsplot.svg"), plot_effects, width=20, height=15, units="cm")
ggsave(filename=fs::path(output_dir, "report_effectsplot.png"), plot_effects, width=20, height=15, units="cm")
ggsave(filename=fs::path(output_dir, "report_effectsplot.pdf"), plot_effects, width=20, height=15, units="cm")


## glance ----


# glance <-
#   model_metaparams %>%
#   mutate(
#     glance = map2(treatment, outcome, ~read_csv(here("output", "models", "seqtrialcox", .x, .y, glue("model_glance.csv")))),
#   ) %>%
#   unnest(glance) %>%
#   mutate(
#     model_descr = fct_inorder(model_descr),
#   )
#
# write_csv(glance, path = fs::path(output_dir, "report_glance.csv"))


## incidence rates ----

incidences <-
  model_metaparams %>%
  mutate(
    ir = map2(treatment, outcome, ~read_csv(here("output", "models", "seqtrialcox", .x, .y, glue("report_ir.csv"))))
  ) %>%
  unnest(ir)


gt_incidences <-
  incidences %>%
  select(-treatment, -outcome, -starts_with("n_"), -starts_with("yearsatrisk_"), -rrE) %>%
  gt(
    groupname_col = c("treatment_descr", "outcome_descr"),
  ) %>%
  cols_label(
    outcome_descr = "Outcome",
    fup_period = "Time since recruitment",

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
    columns = starts_with(c("rate_", "rr")),
    decimals = 2
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

gtsave(gt_incidences, fs::path(output_dir, "report_ir.html"))

