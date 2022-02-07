
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

## import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)


if(length(args)==0){
  # use for interactive testing
  removeobs <- FALSE
  treatment <- "pfizer"
  outcome <- "postest"
  subgroup <- "vax12_type-pfizer-pfizer"
} else {
  removeobs <- TRUE
  treatment <- args[[1]]
  outcome <- args[[2]]
  subgroup <- args[[3]]
}


## Import libraries ----
library('tidyverse')
library('here')
library('glue')
library('survival')


## Import custom user functions
source(here("lib", "functions", "utility.R"))
source(here("lib", "functions", "survival.R"))
source(here("lib", "functions", "redaction.R"))

output_dir_matched <- here("output", "models", "seqtrialcox", treatment, outcome)
output_dir <- here("output", "models", "seqtrialcox", treatment, outcome, subgroup)

data_seqtrialcox <- read_rds(fs::path(output_dir, "model_data_seqtrialcox.rds"))


## import globally defined study dates and convert to "Date"
study_dates <-
  jsonlite::read_json(path=here("lib", "design", "study-dates.json")) %>%
  map(as.Date)


# report matching info ----

data_matched <- read_rds(fs::path(output_dir_matched, "match_data_matched.rds")) %>%
  mutate(
    day1_date = study_dates$studystart_date
  )

## matching summary ----

match_summary_trial <-
  data_matched %>%
  group_by(jcvi_group, trial_day, treated) %>%
  summarise(
    n=n(),
    fup_sum = sum(tte_stop - tte_recruitment),
    fup_years = sum(tte_stop - tte_recruitment)/365.25,
    fup_mean = mean(tte_stop - tte_recruitment),
    events = sum(tte_outcome <= tte_stop, na.rm=TRUE)
  ) %>%
  arrange(
    jcvi_group, trial_day, treated
  ) %>%
  pivot_wider(
    id_cols = c(jcvi_group, trial_day),
    names_from = treated,
    values_from = c(n, fup_sum, fup_years, fup_mean, events)
  )

write_csv(match_summary_trial, fs::path(output_dir, "report_matchsummary_trial.csv"))


match_summary_treated <-
  data_matched %>%
  group_by(treated) %>%
  summarise(
    n=n(),
    firstrecruitdate = min(tte_recruitment) + first(day1_date),
    lastrecruitdate = max(tte_recruitment) + first(day1_date),
    fup_sum = sum(tte_stop - tte_recruitment),
    fup_years = sum(tte_stop - tte_recruitment)/365.25,
    fup_mean = mean(tte_stop - tte_recruitment),
    outcomes = sum(tte_outcome <= tte_stop, na.rm=TRUE),
  )

write_csv(match_summary_treated, fs::path(output_dir, "report_matchsummary_treated.csv"))

match_summary <-
  data_matched %>%
  summarise(
    n=n(),
    firstrecruitdate = min(tte_recruitment) + first(day1_date),
    lastrecruitdate = max(tte_recruitment) + first(day1_date),
    fup_sum = sum(tte_stop - tte_recruitment),
    fup_years = sum(tte_stop - tte_recruitment)/365.25,
    fup_mean = mean(tte_stop - tte_recruitment),
    outcomes = sum(tte_outcome <= tte_stop, na.rm=TRUE),
  )

write_csv(match_summary, fs::path(output_dir, "report_matchsummary.csv"))

## matching coverage ----

data_matchcoverage <- read_rds(fs::path(output_dir_matched, "match_data_matchcoverage.rds"))
write_csv(data_matchcoverage, fs::path(output_dir, "report_matchcoverage.csv"))

xmin <- min(data_matchcoverage$vax3_date )
xmax <- max(data_matchcoverage$vax3_date )+1

plot_coverage_n <-
  data_matchcoverage %>%
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
  #geom_rect(xmin=xmin, xmax= xmax+1, ymin=0, ymax=6, fill="grey", colour="transparent")+
  facet_grid(rows = vars(jcvi_group), cols = vars(vax12_type))+
  scale_x_date(
    breaks = unique(lubridate::ceiling_date(data_matchcoverage$vax3_date, "1 month")),
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
ggsave(plot_coverage_n, filename="report_matchcoverage_count.png", path=output_dir)
ggsave(plot_coverage_n, filename="report_matchcoverage_count.pdf", path=output_dir)


plot_coverage_cumuln <-
  data_matchcoverage %>%
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
  #geom_rect(xmin=xmin, xmax= xmax+1, ymin=0, ymax=6, fill="grey", colour="transparent")+
  facet_grid(rows = vars(jcvi_group), cols = vars(vax12_type))+
  scale_x_date(
    breaks = unique(lubridate::ceiling_date(data_matchcoverage$vax3_date, "1 month")),
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

plot_coverage_cumuln

#ggsave(plot_coverage_cumuln, filename="match_coverage_stack.svg", path=output_dir)
ggsave(plot_coverage_cumuln, filename="report_matchcoverage_stack.png", path=output_dir)
ggsave(plot_coverage_cumuln, filename="report_matchcoverage_stack.pdf", path=output_dir)


rm("data_matched")

# report model info ----

## report model diagnostics ----

fs::file_copy(fs::path(output_dir, "model_glance.csv"), fs::path(output_dir, "report_glance.csv"), overwrite = TRUE)


## report model effects ----

postbaselinecuts <- read_rds(here("lib", "design", "postbaselinecuts.rds"))

model_tidy <- read_csv(fs::path(output_dir, "model_tidy.csv"))

model_effects <- model_tidy %>%
  filter(str_detect(term, fixed("treated"))) %>%
  mutate(
    period_id = str_replace(term, pattern=fixed("treated_period_"), ""),
    term_left = postbaselinecuts[as.numeric(period_id)],
    term_right = postbaselinecuts[as.numeric(period_id)+1],
    term_midpoint = (term_right+term_left)/2,
    model_descr = fct_inorder(model_descr)
  )
write_csv(model_effects, path = fs::path(output_dir, "report_effects.csv"))

plot_effects <-
  ggplot(data = model_effects) +
  geom_point(aes(y=exp(estimate), x=term_midpoint, colour=model_descr), position = position_dodge(width = 1.8))+
  geom_linerange(aes(ymin=exp(conf.low), ymax=exp(conf.high), x=term_midpoint, colour=model_descr), position = position_dodge(width = 1.8))+
  geom_hline(aes(yintercept=1), colour='grey')+
  scale_y_log10(
    breaks=c(0.01, 0.02, 0.05, 0.2, 0.1, 0.5, 1, 2),
    sec.axis = dup_axis(name="<--  favours not boosting  /  favours boosting  -->", breaks = NULL)
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


## incidence rates ----

data_seqtrialcox <- read_rds(fs::path(output_dir, "model_data_seqtrialcox.rds"))

### Event incidence following recruitment

rrCI_exact <- function(n, pt, ref_n, ref_pt, accuracy=0.001){

  # use exact methods if incidence is very low for immediate post-vaccine outcomes
  rate <- n/pt
  ref_rate <- ref_n/ref_pt
  rr <- rate/ref_rate

  ll = ref_pt/pt * (n/(ref_n+1)) * 1/qf(2*(ref_n+1), 2*n, p = 0.05/2, lower.tail = FALSE)
  ul = ref_pt/pt * ((n+1)/ref_n) * qf(2*(n+1), 2*ref_n, p = 0.05/2, lower.tail = FALSE)

  paste0("(", scales::number_format(accuracy=accuracy)(ll), "-", scales::number_format(accuracy=accuracy)(ul), ")")

}

format_ratio = function(numer,denom, width=7){
  paste0(
    replace_na(scales::comma_format(accuracy=1)(numer), "--"),
    " /",
    str_pad(replace_na(scales::comma_format(accuracy=1)(denom),"--"), width=width, pad=" ")
  )
}






incidence_rate_redacted <- local({

  unredacted_treated <-
    data_seqtrialcox %>%
    group_by(treated, fup_period) %>%
    summarise(
      n = n_distinct(patient_id),
      yearsatrisk = sum(tstop-tstart)/365.25,
      events = sum(ind_outcome),
      rate = events/yearsatrisk
    ) %>%
    ungroup()


  unredacted_all <-
    data_seqtrialcox %>%
    group_by(treated) %>%
    summarise(
      n = n_distinct(patient_id),
      yearsatrisk = sum(tstop-tstart)/365.25,
      events = sum(ind_outcome),
      rate = events/yearsatrisk
    ) %>%
    ungroup()

  unredacted <-
    bind_rows(
      unredacted_treated,
      unredacted_all
    ) %>%
    mutate(
      fup_period = fct_explicit_na(fup_period, na_level="All")
    ) %>%
    arrange(
      treated, fup_period
    )

  unredacted_wide <-
    unredacted %>%
    pivot_wider(
      id_cols =c(fup_period),
      names_from = treated,
      values_from = c(n, yearsatrisk, events, rate),
      names_glue = "{.value}_{treated}"
    ) %>%
    mutate(
      rr = rate_1 / rate_0,
      rrE = scales::label_number(accuracy=0.01, trim=FALSE)(rr),
      rrCI = rrCI_exact(events_1, yearsatrisk_1, events_0, yearsatrisk_0, 0.01),
    )

  redacted <-
    unredacted_wide %>%
    mutate(
      n_0 = redactor2(n_0, 5, n_0),
      n_1 = redactor2(n_0, 5, n_1),

      rate_0 = redactor2(rate_0, 5, rate_0),
      rate_1 = redactor2(rate_1, 5, rate_1),

      rr = redactor2(pmin(events_1, events_0), 5, rr),
      rrE = redactor2(pmin(events_1, events_0), 5, rrE),
      rrCI = redactor2(pmin(events_1, events_0), 5, rrCI),

      events_0 = redactor2(events_0, 5),
      events_1 = redactor2(events_1, 5),

      q_0 = format_ratio(events_0, yearsatrisk_0),
      q_1 = format_ratio(events_1, yearsatrisk_1),
    )

  redacted

})

write_csv(incidence_rate_redacted, fs::path(output_dir, "report_ir.csv"))


## cumulative risk differences ----

model3 <- read_rds(fs::path(output_dir, "model_obj3.rds"))

tidy_surv <- broom::tidy(survfit(model3)) %>%
  group_by(strata) %>%
  summarise(
    n.event=sum(n.event),
    n.risk=first(n.risk),
    n.censor = sum(n.censor),
  )

if(any(tidy_surv$n.event==0)){
  message("some strata have zero events -- cannot calculate marginalised risk.", "\n")
} else {


  #
  # formula1_pw
  #
  # model3 <- coxph(
  #   formula = Surv(tstop, ind_outcome) ~ treated_period_1 + strata(region),# +
  #     #strata(region) + strata(jcvi_group) + strata(vax12_type),
  #   data = data_seqtrialcox,
  #  # robust = TRUE,
  #  # id = patient_id,
  #   na.action = "na.fail"
  # )


  ## need to redo treatment-time indicators too, as overwriting `treated`` variable not enough

  data_seqtrialcox1 <-
    data_seqtrialcox %>%
    select(-starts_with("treated_period_")) %>%
    rename(treated_period=fup_period) %>%
    fastDummies::dummy_cols(select_columns = c("treated_period")) %>%
    mutate(treated=1L)

  data_seqtrialcox0 <-
    data_seqtrialcox %>%
    mutate(
      across(
        starts_with("treated_period_"),
        ~0L
      ),
      treated = 0L
    )

  times <- seq_len(last(postbaselinecuts)+1)

  surv1 <- survexp(~1, data=data_seqtrialcox1, ratetable = model3, method="ederer", times=times)# times=seq_len(end(postbaselinecuts)))
  surv0 <-  survexp(~1, data=data_seqtrialcox0, ratetable = model3, method="ederer", times=times)# times=seq_len(end(postbaselinecuts)))

  cumulrisk <-
    tibble(
      times,
      surv1 = surv1$surv,
      surv0 = surv0$surv,
      #diff = surv1 - surv0
    ) %>%
    pivot_longer(
      cols=starts_with("surv"),
      names_to="treated",
      values_to="surv"
    ) %>%
    mutate(
      treated_descr = fct_recode(treated, `Not boosted`="surv0", `Boosted`="surv1")
    )


  plot_cumulrisk <- ggplot(cumulrisk)+
    geom_step(aes(x=times, y=1-surv, group=treated_descr, colour=treated_descr))+
    geom_hline(yintercept=0)+ geom_vline(xintercept=0)+
    scale_x_continuous(
      breaks = seq(0,7*52,by=14),
      expand = expansion(0)
    )+
    scale_y_continuous(
      expand = expansion(0)
    )+
    scale_colour_brewer(type="qual", palette="Set1")+
    scale_fill_brewer(type="qual", palette="Set1", guide="none")+
    labs(
      x="Days since booster",
      y="Cumulative incidence",
      colour=NULL,
      fill=NULL
    )+
    theme_minimal()+
    theme(
      legend.position=c(.05,.95),
      legend.justification = c(0,1),
    )


  ggsave(filename=fs::path(output_dir, "report_cumulriskplot.svg"), plot_cumulrisk, width=20, height=15, units="cm")
  ggsave(filename=fs::path(output_dir, "report_cumulriskplot.png"), plot_cumulrisk, width=20, height=15, units="cm")

}


