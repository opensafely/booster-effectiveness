
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
  treatment <- "pfizer"
  outcome <- "postest"
} else {
  removeobs <- TRUE
  treatment <- args[[1]]
  outcome <- args[[2]]
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

output_dir <- here("output", "models", "seqtrialcox", treatment, outcome)

data_seqtrialcox <- read_rds(fs::path(output_dir, "model_data_seqtrialcox.rds"))


## import globally defined study dates and convert to "Date"
study_dates <-
  jsonlite::read_json(path=here("lib", "design", "study-dates.json")) %>%
  map(as.Date)

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

## Event incidence following recruitment



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
      yearsatrisk = sum(tstop-tstart)/365.25,
      n = sum(ind_outcome),
      rate = n/yearsatrisk
    ) %>%
    ungroup()


  unredacted_all <-
    data_seqtrialcox %>%
    group_by(treated) %>%
    summarise(
      yearsatrisk = sum(tstop-tstart)/365.25,
      n = sum(ind_outcome),
      rate = n/yearsatrisk
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
      values_from = c(yearsatrisk, n, rate),
      names_glue = "{.value}_{treated}"
    ) %>%
    mutate(
      rr = rate_1 / rate_0,
      rrE = scales::label_number(accuracy=0.01, trim=FALSE)(rr),
      rrCI = rrCI_exact(rate_1, yearsatrisk_1, rate_0, yearsatrisk_0, 0.01),
    )

  redacted <-
    unredacted_wide %>%
    mutate(
      rate_0 = redactor2(rate_0, 5, rate_0),
      rate_1 = redactor2(rate_1, 5, rate_1),

      rr = redactor2(pmin(n_1, n_0), 5, rr),
      rrE = redactor2(pmin(n_1, n_0), 5, rrE),
      rrCI = redactor2(pmin(n_1, n_0), 5, rrCI),

      n_0 = redactor2(n_0, 5),
      n_1 = redactor2(n_1, 5),

      q_0 = format_ratio(n_0, yearsatrisk_0),
      q_1 = format_ratio(n_1, yearsatrisk_1),
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


