# # # # # # # # # # # # # # # # # # # # #
# This script plots cumulative vaccine coverage in the study population
# # # # # # # # # # # # # # # # # # # # #

# Preliminaries ----

## Import libraries ----
library('tidyverse')
library('here')
library('glue')
library('survival')

## Import custom user functions from lib
source(here("lib", "functions", "utility.R"))
source(here("lib", "functions", "redaction.R"))

args <- commandArgs(trailingOnly=TRUE)
if(length(args)==0){
  # use for interactive testing
  removeobs <- FALSE
} else {
  removeobs <- TRUE
}

## create output directory ----
fs::dir_create(here("output", "descriptive", "vaxdate"))

data_cohort <- read_rds(here::here("output", "data", "data_cohort.rds"))

cumulvax <- data_cohort %>%
  filter(!is.na(vax3_date), vax3_type %in% c("pfizer", "az", "moderna")) %>%
  group_by(vax3_type_descr, vax3_date) %>%
  summarise(
    n=n()
  ) %>%
  # make implicit counts explicit
  complete(
    vax3_date = full_seq(c(.$vax3_date), 1),
    fill = list(n=0)
  ) %>%
  group_by(vax3_type_descr) %>%
  mutate(
    cumuln = cumsum(n),
    # calculate rolling weekly average, anchored at end of period
    rolling7n = stats::filter(n, filter = rep(1, 7), method="convolution", sides=1)
  ) %>%
  arrange(vax3_type_descr, vax3_date)



## plot stacked cumulative booster uptake ----
plot_stack <-
  ggplot(cumulvax)+
  geom_bar(
    aes(
      x=vax3_date+0.5,
      y=cumuln,
      group=vax3_type_descr,
      fill=vax3_type_descr
    ),
    alpha=0.5,
    position=position_stack(),
    stat="identity",
    width=1
  )+
  scale_x_date(
    breaks = seq(min(cumulvax$vax3_date, na.rm=TRUE), max(cumulvax$vax3_date+1, na.rm=TRUE),by=14),
    limits = c(lubridate::floor_date(min(cumulvax$vax3_date, na.rm=TRUE), "1 month"), NA),
    labels = scales::label_date("%d/%m"),
    expand = expansion(add=1),
    sec.axis = sec_axis(
      trans = ~as.Date(.),
      breaks=as.Date(seq(floor_date(min(cumulvax$vax3_date, na.rm=TRUE), "month"), ceiling_date(max(cumulvax$vax3_date, na.rm=TRUE), "month"),by="month")),
      labels = scales::label_date("%B %y")
    )
  )+
  scale_y_continuous(
    labels = scales::label_number(accuracy = 1, big.mark=","),
    expand = expansion(c(0, NA))
  )+
  scale_fill_brewer(type="qual", palette="Set1")+
  labs(
    x="Date",
    y="Booster vaccine uptake",
    colour=NULL,
    fill=NULL,
    alpha=NULL
  ) +
  theme_minimal()+
  theme(
    axis.line.x.bottom = element_line(),
    axis.text.x.top=element_text(hjust=0),
    axis.ticks.x=element_line(),
    legend.position = c(0.3,0.8),
    legend.justification = c(1,0)
  )

## plot stepped cumulative booster uptake ----
plot_step <-
  ggplot(cumulvax)+
  geom_step(
    aes(
      x=vax3_date, y=cumuln,
      group=vax3_type_descr,
      colour=vax3_type_descr
    ),
    direction = "vh",
    size=1
  )+
  scale_x_date(
    breaks = seq(min(cumulvax$vax3_date),max(cumulvax$vax3_date)+1,by=14),
    limits = c(lubridate::floor_date((min(cumulvax$vax3_date)), "1 month"), NA),
    labels = scales::label_date("%d/%m"),
    expand = expansion(add=1),
    sec.axis = sec_axis(
      trans = ~as.Date(.),
      breaks=as.Date(seq(floor_date(min(cumulvax$vax3_date), "month"), ceiling_date(max(cumulvax$vax3_date), "month"),by="month")),
      labels = scales::label_date("%B %y")
    )
  )+
  scale_y_continuous(
    labels = scales::label_number(accuracy = 1, big.mark=","),
    expand = expansion(c(0, NA))
  )+
  scale_colour_brewer(type="qual", palette="Set1")+
  labs(
    x="Date",
    y="Booster vaccine uptake",
    colour=NULL,
    fill=NULL,
    alpha=NULL
  ) +
  theme_minimal()+
  theme(
    axis.line.x.bottom = element_line(),
    axis.text.x.top=element_text(hjust=0),
    axis.ticks.x=element_line(),
    legend.position = c(0.3,0.8),
    legend.justification = c(1,0)
  )



## plot daily booster uptake ----
plot_count <-
  ggplot(cumulvax)+
  geom_col(
    aes(
      x=vax3_date+0.5,
      y= n,
      group=vax3_type_descr,
      fill=vax3_type_descr,
      colour=NULL
    ),
    position=position_identity(),
    alpha=0.4,
    width=1
  )+
  geom_line(
    aes(
      x=vax3_date-2.5,
      y=rolling7n/7,
      group=vax3_type_descr,
      colour=vax3_type_descr
    ),
    size=1,
  )+
  scale_x_date(
    breaks = seq(min(cumulvax$vax3_date),max(cumulvax$vax3_date)+1,by=14),
    limits = c(lubridate::floor_date((min(cumulvax$vax3_date)), "1 month"), NA),
    labels = scales::label_date("%d/%m"),
    expand = expansion(add=1),
    sec.axis = sec_axis(
      trans = ~as.Date(.),
      breaks=as.Date(seq(floor_date(min(cumulvax$vax3_date), "month"), ceiling_date(max(cumulvax$vax3_date), "month"),by="month")),
      labels = scales::label_date("%B %y")
    )
  )+
  scale_y_continuous(
    labels = scales::label_number(accuracy = 1, big.mark=","),
    expand = expansion(c(0, NA))
  )+
  scale_fill_brewer(type="qual", palette="Set2")+
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
    axis.ticks.x=element_line(),
    legend.position = c(0.3,0.8),
    legend.justification = c(1,0)
  )


# write_rds(plot_step, here("output", "descriptive", "vaxdate", "plot_vaxdate_step.rds"))
# write_rds(plot_stack, here("output", "descriptive", "vaxdate", "plot_vaxdate_stack.rds"))
# write_rds(plot_count, here("output", "descriptive", "vaxdate", "plot_vaxdate_count.rds"))

ggsave(plot_step, filename="plot_vaxdate_step.png", path=here("output", "descriptive", "vaxdate"))
ggsave(plot_stack, filename="plot_vaxdate_stack.png", path=here("output", "descriptive", "vaxdate"))
ggsave(plot_count, filename="plot_vaxdate_count.png", path=here("output", "descriptive", "vaxdate"))

ggsave(plot_step, filename="plot_vaxdate_step.svg", path=here("output", "descriptive", "vaxdate"))
ggsave(plot_stack, filename="plot_vaxdate_stack.svg", path=here("output", "descriptive", "vaxdate"))
ggsave(plot_count, filename="plot_vaxdate_count.svg", path=here("output", "descriptive", "vaxdate"))

ggsave(plot_step, filename="plot_vaxdate_step.pdf", path=here("output", "descriptive", "vaxdate"))
ggsave(plot_stack, filename="plot_vaxdate_stack.pdf", path=here("output", "descriptive", "vaxdate"))
ggsave(plot_count, filename="plot_vaxdate_count.pdf", path=here("output", "descriptive", "vaxdate"))
