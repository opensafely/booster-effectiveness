
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

postbaselinecuts <- read_rds(here("lib", "design", "postbaselinecuts.rds"))

# import command-line arguments ----

args <- commandArgs(trailingOnly=TRUE)


if(length(args)==0){
  # use for interactive testing
  removeobs <- FALSE
  treatment <- "pfizer"
  outcome <- "admitted"
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


## Import custom user functi
source(here("lib", "functions", "utility.R"))
source(here("lib", "functions", "survival.R"))


output_dir <- here("output", "models", "seqtrialcox", treatment, outcome)

## import globally defined study dates and convert to "Date"
study_dates <-
  jsonlite::read_json(path=here("lib", "design", "study-dates.json")) %>%
  map(as.Date)

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
    breaks=c(0.25, 0.33, 0.5, 0.67, 0.80, 1, 1.25, 1.5, 2, 3, 4),
    sec.axis = dup_axis(name="<--  favours not boosting  /  favours boosting  -->", breaks = NULL)
  )+
  scale_x_continuous(breaks=unique(model_effects$term_left), limits=c(min(model_effects$term_left), max(model_effects$term_right)+1), expand = c(0, 0))+
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


#
#
# # cumulative risk difference plots ----
#
# model0 <- read_rds(fs::path(output_dir, glue("model_obj0.rds")))
# model1 <- read_rds(fs::path(output_dir, glue("model_obj1.rds")))
# model2 <- read_rds(fs::path(output_dir, glue("model_obj2.rds")))
# model3 <- read_rds(fs::path(output_dir, glue("model_obj3.rds")))
#
# data_seqtrialcox <- read_rds(fs::path(output_dir, "model_data_seqtrialcox.rds"))
#
# baselinehazard <- function(fit, newdata){
#
#   sfit <- survfit(fit, se.fit = FALSE, newdata=newdata, id=patient_id)
#
#   zcoef <- ifelse(is.na(coef(fit)), 0, coef(fit))
#   offset <- sum(fit$means * zcoef)
#   chaz <- sfit$cumhaz * exp(-offset)
#
#   new <- data.frame(hazard = chaz, time = sfit$time)
#   strata <- sfit$strata
#   if (!is.null(strata))
#     new$strata <- factor(rep(names(strata), strata), levels = names(strata))
#   new
# }
#
#
# ## as if everyone was treated at baseline ----
#
# # set every to treated
# data_seqtrialcox1 <- data_seqtrialcox %>% mutate(treated=1)
#
# # cumulative baseline hazard
# model3$data <- data_seqtrialcox
# bh1 <- basehaz(model3, centered=FALSE)
# test <- broom::augment(model3, data=data_seqtrialcox1)
#
# survfit1 <- survfit(model3, se.fit = TRUE, newdata=data_seqtrialcox1, id=patient_id)
#
# broom::tidy(survfit1)
#
# #linear predictor from cox model: beta*X
# lp.trt1 <- predict(model3, newdata=data_seqtrialcox1, type="lp")
#
# #risk estimates at each observed event time for each person
# #rows=individuals, columns=time points
# risk.trt1 <- sapply(1:length(chaz1),FUN=function(x){1-exp(-chaz1[x]*exp(lp.trt1))})
#
# #now take the average across all individuals at each time point
# risk.trt1.mean<-colMeans(risk.trt1)
#
#
#
#
# ## as if everyone was treated at baseline ----
#
# # set every to treated
# data_seqtrialcox0 <- data_seqtrialcox %>% mutate(treated=0)
#
# # cumulative baseline hazard
# chaz0 <- baselinehazard(model3, newdata=data_seqtrialcox)$haz
#
# #linear predictor from cox model: beta*X
# lp.trt0 <- predict(model3, newdata=data_seqtrialcox0, type="lp")
#
# #risk estimates at each observed event time for each person
# #rows=individuals, columns=time points
# risk.trt0 <- sapply(1:length(chaz0),FUN=function(x){1-exp(-chaz0[x]*exp(lp.trt0))})
#
# #now take the average across all individuals at each time point
# risk.trt0.mean<-colMeans(risk.trt0)
#
#
#
#
# times<-survfit(model3, se.fit = FALSE, newdata=data_seqtrialcox)$time
#
# plot(times,risk.trt1.mean,type="s",col="blue")
# points(times,risk.trt0.mean,type="s",add=T,col="red")
#
#
#
