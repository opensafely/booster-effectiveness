
library('tidyverse')
library('arrow')
library('here')
library('glue')

#source(here("analysis", "lib", "utility_functions.R"))

remotes::install_github("https://github.com/wjchulme/dd4d")
library('dd4d')


population_size <- 20000

# get nth largest value from list, from https://stackoverflow.com/a/21005136/4269699
nthmax <- function(x, n=1){
  len <- length(x)
  if(n>len){
    warning('n greater than length(x).  Setting n=length(x)')
    n <- length(x)
  }
  sort(x,partial=len-n+1)[len-n+1]
}

# import globally defined repo variables from
study_dates <- jsonlite::read_json(
  path=here("lib", "design", "study-dates.json")
)

index_date <- as.Date(study_dates$index_date)
pfizerstart_date <- as.Date(study_dates$pfizerstart_date)
pfizerend_date <- as.Date(study_dates$pfizerend_date)
modernastart_date <- as.Date(study_dates$modernastart_date)
modernaend_date <- as.Date(study_dates$modernaend_date)

firstpfizer_date <- as.Date(study_dates$firstpfizer_date)
firstaz_date <- as.Date(study_dates$firstaz_date)
firstmoderna_date <- as.Date(study_dates$firstmoderna_date)

index_day <- 0L
pfizerstart_day <- as.integer(pfizerstart_date - index_date)
pfizerend_day <- as.integer(pfizerend_date - index_date)
modernastart_day <- as.integer(modernastart_date - index_date)
modernaend_day <- as.integer(modernaend_date - index_date)

firstpfizer_day <- as.integer(firstpfizer_date - index_date)
firstaz_day <- as.integer(firstaz_date - index_date)
firstmoderna_day <- as.integer(firstmoderna_date - index_date)


known_variables <- c(
  "index_date", "pfizerstart_date", "pfizerend_date", "modernastart_date", "modernaend_date", "firstpfizer_date", "firstaz_date", "firstmoderna_date",
  "index_day", "pfizerstart_day", "pfizerend_day", "modernastart_day", "modernaend_day",  "firstpfizer_day", "firstaz_day", "firstmoderna_day"
)

sim_list = lst(
  first_vax_type = bn_node(~rcat(n=1, c("pfizer","az","moderna",""), c(0.49,0.4,0.1,0.01)), keep=FALSE),
  covid_vax_pfizer_1_day = bn_node(
    ~as.integer(runif(n=1, firstpfizer_day, firstpfizer_day+60)),
    missing_rate = ~1-(first_vax_type=="pfizer")
  ),
  covid_vax_pfizer_2_day = bn_node(
    ~as.integer(runif(n=1, covid_vax_pfizer_1_day+30, covid_vax_pfizer_1_day+60)),
    needs = c("covid_vax_pfizer_1_day"),
    missing_rate = ~0.01
  ),
  covid_vax_pfizer_3_day = bn_node(
    ~as.integer(runif(n=1, max(covid_vax_pfizer_2_day+15,pfizerstart_day), max(covid_vax_pfizer_2_day, pfizerstart_day)+100)),
    missing_rate = ~0.5
  ),
  covid_vax_pfizer_4_day = bn_node(
    ~as.integer(runif(n=1, covid_vax_pfizer_3_day+120, covid_vax_pfizer_3_day+200)),
    missing_rate = ~1
  ),
  covid_vax_az_1_day = bn_node(
    ~as.integer(runif(n=1, firstaz_day, firstaz_day+60)),
    missing_rate = ~1-(first_vax_type=="az")
  ),
  covid_vax_az_2_day = bn_node(
    ~as.integer(runif(n=1, covid_vax_az_1_day+30, covid_vax_az_1_day+60)),
    needs = c("covid_vax_az_1_day"),
    missing_rate = ~0.01
  ),
  covid_vax_az_3_day = bn_node(
    ~as.integer(runif(n=1, max(covid_vax_az_2_day+15,pfizerstart_day), max(covid_vax_az_2_day,pfizerstart_day)+100)),
    missing_rate = ~0.5
  ),
  covid_vax_az_4_day = bn_node(
    ~as.integer(runif(n=1, covid_vax_az_3_day+120, covid_vax_az_3_day+200)),
    missing_rate = ~1
  ),
  covid_vax_moderna_1_day = bn_node(
    ~as.integer(runif(n=1, firstmoderna_day, firstmoderna_day+60)),
    missing_rate = ~1-(first_vax_type=="moderna")
  ),
  covid_vax_moderna_2_day = bn_node(
    ~as.integer(runif(n=1, covid_vax_moderna_1_day+30, covid_vax_moderna_1_day+60)),
    needs = c("covid_vax_moderna_1_day"),
    missing_rate = ~0.01
  ),
  covid_vax_moderna_3_day = bn_node(
    ~as.integer(runif(n=1, max(covid_vax_moderna_2_day+15, modernastart_day), max(covid_vax_moderna_2_day,modernastart_day)+100)),
    missing_rate = ~0.5
  ),
  covid_vax_moderna_4_day = bn_node(
    ~as.integer(runif(n=1, covid_vax_moderna_3_day+120, covid_vax_moderna_3_day+200)),
    missing_rate = ~1
  ),


  # assumes covid_vax_disease is the same as covid_vax_any though in reality there will be slight differences
  covid_vax_disease_1_day = bn_node(
    ~pmin(covid_vax_pfizer_1_day, covid_vax_az_1_day, covid_vax_moderna_1_day, na.rm=TRUE),
  ),
  covid_vax_disease_2_day = bn_node(
    ~pmin(covid_vax_pfizer_2_day, covid_vax_az_2_day, covid_vax_moderna_2_day, na.rm=TRUE),
  ),
  covid_vax_disease_3_day = bn_node(
    ~pmin(covid_vax_pfizer_3_day, covid_vax_az_3_day, covid_vax_moderna_3_day, na.rm=TRUE),
  ),
  covid_vax_disease_4_day = bn_node(
    ~pmin(covid_vax_pfizer_4_day, covid_vax_az_4_day, covid_vax_moderna_4_day, na.rm=TRUE),
  ),

  dereg_day = bn_node(
    ~as.integer(runif(n=1, index_day, index_day+120)),
    missing_rate = ~0.99
  ),

  has_follow_up_previous_6weeks = bn_node(
    ~rbernoulli(n=1, p=0.999)
  ),

  hscworker = bn_node(
    ~rbernoulli(n=1, p=0.01)
  ),

  age = bn_node(
    ~as.integer(rnorm(n=1, mean=60, sd=15))
  ),

  age_august2021 = bn_node(~age),

  sex = bn_node(
    ~rfactor(n=1, levels = c("F", "M"), p = c(0.51, 0.49)),
    missing_rate = ~0.001 # this is shorthand for ~(rbernoulli(n=1, p = 0.2))
  ),

  bmi = bn_node(
    ~rfactor(n=1, levels = c("Not obese", "Obese I (30-34.9)", "Obese II (35-39.9)", "Obese III (40+)"), p = c(0.5, 0.2, 0.2, 0.1)),
  ),

  ethnicity = bn_node(
    ~rfactor(n=1, levels = c(1,2,3,4,5), p = c(0.8, 0.05, 0.05, 0.05, 0.05)),
    missing_rate = ~ 0.25
  ),

  ethnicity_6_sus = bn_node(
    ~rfactor(n=1, levels = c(0,1,2,3,4,5), p = c(0.1, 0.7, 0.05, 0.05, 0.05, 0.05)),
    missing_rate = ~ 0
  ),

  practice_id = bn_node(
    ~as.integer(runif(n=1, 1, 200))
  ),

  msoa = bn_node(
    ~factor(as.integer(runif(n=1, 1, 100)), levels=1:100),
    missing_rate = ~ 0.005
  ),

  stp = bn_node(
    ~factor(as.integer(runif(n=1, 1, 36)), levels=1:36)
  ),

  region = bn_node(
    variable_formula = ~rfactor(n=1, levels=c(
      "North East",
      "North West",
      "Yorkshire and The Humber",
      "East Midlands",
      "West Midlands",
      "East",
      "London",
      "South East",
      "South West"
    ), p = c(0.2, 0.2, 0.3, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05))
  ),

  imd = bn_node(
    ~factor(plyr::round_any(runif(n=1, 1, 32000), 100), levels=seq(0,32000,100)),
    missing_rate = ~0.02
  ),

  imd_integer = bn_node(
    ~as.integer(as.character(imd)),
    keep=FALSE
  ),

  imd_Q5 = bn_node(
    ~factor(
      case_when(
        (imd_integer >= 0) & (imd_integer < 32844*1/5) ~ "1 (most deprived)",
        (imd_integer >= 32844*1/5) & (imd_integer < 32844*2/5) ~ "2",
        (imd_integer >= 32844*2/5) & (imd_integer < 32844*3/5) ~ "3",
        (imd_integer >= 32844*3/5) & (imd_integer < 32844*4/5) ~ "4",
        (imd_integer >= 32844*4/5) & (imd_integer <= 32844*5/5) ~ "5 (least deprived)",
        TRUE ~ "Unknown"
      ),
      levels= c("1 (most deprived)", "2", "3", "4", "5 (least deprived)", "Unknown")
    ),
    missing_rate = ~0
  ),

  rural_urban = bn_node(
    ~rfactor(n=1, levels = 1:9, p = rep(1/9, 9)),
    missing_rate = ~ 0.1
  ),

  care_home_type = bn_node(
    ~rfactor(n=1, levels=c("Carehome", "Nursinghome", "Mixed", ""), p = c(0.01, 0.01, 0.01, 0.97))
  ),

  care_home_tpp = bn_node(
    ~care_home_type!=""
  ),

  care_home_code = bn_node(
    ~rbernoulli(n=1, p = 0.01)
  ),



  covid_test_0_day = bn_node(
    ~as.integer(runif(n=1, index_day-100, index_day-1)),
    missing_rate = ~0.7
  ),
  covid_test_1_day = bn_node(
    ~as.integer(runif(n=1, index_day, index_day+100)),
    missing_rate = ~0.6
  ),

  primary_care_covid_case_0_day = bn_node(
    ~as.integer(runif(n=1, index_day-100, index_day-1)),
    missing_rate = ~0.99
  ),


  prior_covid_test_frequency = bn_node(
    ~as.integer(rpois(n=1, lambda=3)),
    missing_rate = ~0
  ),


  coviddeath_day = bn_node(
    ~death_day,
    missing_rate = ~0.7,
    needs = "death_day"
  ),

  death_day = bn_node(
    ~as.integer(runif(n=1, index_day, index_day+100)),
    missing_rate = ~0.99
  ),


  asthma = bn_node( ~rbernoulli(n=1, p = 0.02)),
  chronic_neuro_disease = bn_node( ~rbernoulli(n=1, p = 0.02)),
  chronic_resp_disease = bn_node( ~rbernoulli(n=1, p = 0.02)),
  sev_obesity = bn_node( ~rbernoulli(n=1, p = 0.02)),
  diabetes = bn_node( ~rbernoulli(n=1, p = 0.02)),
  sev_mental = bn_node( ~rbernoulli(n=1, p = 0.02)),
  chronic_heart_disease = bn_node( ~rbernoulli(n=1, p = 0.02)),
  chronic_kidney_disease = bn_node( ~rbernoulli(n=1, p = 0.02)),
  chronic_liver_disease = bn_node( ~rbernoulli(n=1, p = 0.02)),
  immunosuppressed = bn_node( ~rbernoulli(n=1, p = 0.02)),
  asplenia = bn_node( ~rbernoulli(n=1, p = 0.02)),
  learndis = bn_node( ~rbernoulli(n=1, p = 0.02)),

  cev_ever = bn_node( ~rbernoulli(n=1, p = 0.02)),
  cev = bn_node( ~rbernoulli(n=1, p = 0.02)),

  endoflife = bn_node( ~rbernoulli(n=1, p = 0.001)),
  housebound = bn_node( ~rbernoulli(n=1, p = 0.001)),


  ## time-varying

  positive_test_0_day = bn_node(
    ~as.integer(runif(n=1, index_day-100, index_day-1)),
    missing_rate = ~0.9
  ),
  positive_test_1_day = bn_node(
    ~as.integer(runif(n=1, index_day, index_day+100)),
    missing_rate = ~0.7
  ),
  positive_test_2_day = bn_node(
    ~as.integer(runif(n=1, positive_test_1_day+1, positive_test_1_day+30)),
    missing_rate = ~0.9,
    needs = "positive_test_1_day"
  ),
  positive_test_3_day = bn_node(
    ~as.integer(runif(n=1, positive_test_2_day+1, positive_test_2_day+30)),
    missing_rate = ~0.9,
    needs = "positive_test_2_day"
  ),
  positive_test_4_day = bn_node(
    ~as.integer(runif(n=1, positive_test_3_day+1, positive_test_3_day+30)),
    missing_rate = ~0.9,
    needs = "positive_test_3_day"
  ),
  positive_test_5_day = bn_node(
    ~as.integer(runif(n=1, positive_test_4_day+1, positive_test_4_day+30)),
    missing_rate = ~0.9,
    needs = "positive_test_4_day"
  ),
  positive_test_6_day = bn_node(
    ~as.integer(runif(n=1, positive_test_5_day+1, positive_test_5_day+30)),
    missing_rate = ~0.9,
    needs = "positive_test_5_day"
  ),

  emergency_1_day = bn_node(
    ~as.integer(runif(n=1, index_day, index_day+100)),
    missing_rate = ~0.9
  ),
  emergency_2_day = bn_node(
    ~as.integer(runif(n=1, emergency_1_day, emergency_1_day+100)),
    missing_rate = ~0.9,
    needs = "emergency_1_day"
  ),
  emergency_3_day = bn_node(
    ~as.integer(runif(n=1, emergency_2_day, emergency_2_day+100)),
    missing_rate = ~0.9,
    needs = "emergency_2_day"
  ),
  emergency_4_day = bn_node(
    ~as.integer(runif(n=1, emergency_3_day, emergency_3_day+100)),
    missing_rate = ~0.9,
    needs = "emergency_3_day"
  ),
  emergency_5_day = bn_node(
    ~as.integer(runif(n=1, emergency_4_day, emergency_4_day+100)),
    missing_rate = ~0.9,
    needs = "emergency_4_day"
  ),
  emergency_6_day = bn_node(
    ~as.integer(runif(n=1, emergency_5_day, emergency_5_day+100)),
    missing_rate = ~0.9,
    needs = "emergency_5_day"
  ),


  admitted_unplanned_0_day = bn_node(
    ~as.integer(runif(n=1, index_day-100, index_day-1)),
    missing_rate = ~0.9
  ),
  admitted_unplanned_1_day = bn_node(
    ~as.integer(runif(n=1, index_day, index_day+100)),
    missing_rate = ~0.7
  ),
  admitted_unplanned_2_day = bn_node(
    ~as.integer(runif(n=1, discharged_unplanned_1_day+1, discharged_unplanned_1_day+30)),
    missing_rate = ~0.9,
    needs = "discharged_unplanned_1_day"
  ),
  admitted_unplanned_3_day = bn_node(
    ~as.integer(runif(n=1, discharged_unplanned_2_day+1, discharged_unplanned_2_day+30)),
    missing_rate = ~0.9,
    needs = "discharged_unplanned_2_day"
  ),
  admitted_unplanned_4_day = bn_node(
    ~as.integer(runif(n=1, discharged_unplanned_3_day+1, discharged_unplanned_3_day+30)),
    missing_rate = ~0.9,
    needs = "discharged_unplanned_3_day"
  ),
  admitted_unplanned_5_day = bn_node(
    ~as.integer(runif(n=1, discharged_unplanned_4_day+1, discharged_unplanned_4_day+30)),
    missing_rate = ~0.9,
    needs = "discharged_unplanned_4_day"
  ),
  admitted_unplanned_6_day = bn_node(
    ~as.integer(runif(n=1, discharged_unplanned_5_day+1, discharged_unplanned_5_day+30)),
    missing_rate = ~0.9,
    needs = "discharged_unplanned_5_day"
  ),


  discharged_unplanned_0_day = bn_node(
    ~as.integer(runif(n=1, admitted_unplanned_0_day+1, admitted_unplanned_0_day+20)),
    needs="admitted_unplanned_0_day"
  ),
  discharged_unplanned_1_day = bn_node(
    ~as.integer(runif(n=1, admitted_unplanned_1_day+1, admitted_unplanned_1_day+20)),
    needs="admitted_unplanned_1_day"
  ),
  discharged_unplanned_2_day = bn_node(
    ~as.integer(runif(n=1, admitted_unplanned_2_day+1, admitted_unplanned_2_day+20)),
    needs="admitted_unplanned_2_day"
  ),
  discharged_unplanned_3_day = bn_node(
    ~as.integer(runif(n=1, admitted_unplanned_3_day+1, admitted_unplanned_3_day+20)),
    needs="admitted_unplanned_3_day"
  ),
  discharged_unplanned_4_day = bn_node(
    ~as.integer(runif(n=1, admitted_unplanned_4_day+1, admitted_unplanned_4_day+20)),
    needs="admitted_unplanned_4_day"
  ),
  discharged_unplanned_5_day = bn_node(
    ~as.integer(runif(n=1, admitted_unplanned_5_day+1, admitted_unplanned_5_day+20)),
    needs="admitted_unplanned_5_day"
  ),
  discharged_unplanned_6_day = bn_node(
    ~as.integer(runif(n=1, admitted_unplanned_6_day+1, admitted_unplanned_6_day+20)),
    needs="admitted_unplanned_6_day"
  ),


  admitted_planned_0_day = bn_node(
    ~as.integer(runif(n=1, index_day-100, index_day-1)),
    missing_rate = ~0.9
  ),
  admitted_planned_1_day = bn_node(
    ~as.integer(runif(n=1, index_day, index_day+100)),
    missing_rate = ~0.7
  ),
  admitted_planned_2_day = bn_node(
    ~as.integer(runif(n=1, discharged_planned_1_day+1, discharged_planned_1_day+30)),
    missing_rate = ~0.9,
    needs = "discharged_planned_1_day"
  ),
  admitted_planned_3_day = bn_node(
    ~as.integer(runif(n=1, discharged_planned_2_day+1, discharged_planned_2_day+30)),
    missing_rate = ~0.9,
    needs = "discharged_planned_2_day",
  ),
  admitted_planned_4_day = bn_node(
    ~as.integer(runif(n=1, discharged_planned_3_day+1, discharged_planned_3_day+30)),
    missing_rate = ~0.9,
    needs = "discharged_planned_3_day"
  ),
  admitted_planned_5_day = bn_node(
    ~as.integer(runif(n=1, discharged_planned_4_day+1, discharged_planned_4_day+30)),
    missing_rate = ~0.9,
    needs = "discharged_planned_4_day"
  ),
  admitted_planned_6_day = bn_node(
    ~as.integer(runif(n=1, discharged_planned_5_day+1, discharged_planned_5_day+30)),
    missing_rate = ~0.9,
    needs = "discharged_planned_5_day"
  ),

  discharged_planned_0_day = bn_node(
    ~as.integer(runif(n=1, admitted_planned_0_day+1, admitted_planned_0_day+20)),
    needs="admitted_planned_0_day"
  ),
  discharged_planned_1_day = bn_node(
    ~as.integer(runif(n=1, admitted_planned_1_day+1, admitted_planned_1_day+20)),
    needs="admitted_planned_1_day"
  ),
  discharged_planned_2_day = bn_node(
    ~as.integer(runif(n=1, admitted_planned_2_day+1, admitted_planned_2_day+20)),
    needs="admitted_planned_2_day"
  ),
  discharged_planned_3_day = bn_node(
    ~as.integer(runif(n=1, admitted_planned_3_day+1, admitted_planned_3_day+20)),
    needs="admitted_planned_3_day"
  ),
  discharged_planned_4_day = bn_node(
    ~as.integer(runif(n=1, admitted_planned_4_day+1, admitted_planned_4_day+20)),
    needs="admitted_planned_4_day"
  ),
  discharged_planned_5_day = bn_node(
    ~as.integer(runif(n=1, admitted_planned_5_day+1, admitted_planned_5_day+20)),
    needs="admitted_planned_5_day"
  ),
  discharged_planned_6_day = bn_node(
    ~as.integer(runif(n=1, admitted_planned_6_day+1, admitted_planned_6_day+20)),
    needs="admitted_planned_6_day"
  ),

  covidemergency_0_day = bn_node(
    ~as.integer(runif(n=1, index_day-100, index_day-1)),
    missing_rate = ~0.99
  ),
  covidemergency_1_day = bn_node(
    ~as.integer(runif(n=1, index_day, index_day+100)),
    missing_rate = ~0.95
  ),
  covidemergency_2_day = bn_node(
    ~as.integer(runif(n=1, covidemergency_1_day+1, covidemergency_1_day+30)),
    missing_rate = ~0.9,
    needs = "covidemergency_1_day"
  ),
  covidemergency_3_day = bn_node(
    ~as.integer(runif(n=1, covidemergency_2_day+1, covidemergency_2_day+30)),
    missing_rate = ~0.9,
    needs = "covidemergency_2_day"
  ),
  covidemergency_4_day = bn_node(
    ~as.integer(runif(n=1, covidemergency_3_day+1, covidemergency_3_day+30)),
    missing_rate = ~0.9,
    needs = "covidemergency_3_day"
  ),


  emergencyhosp_1_day = bn_node(
    ~as.integer(runif(n=1, index_day, index_day+100)),
    missing_rate = ~0.95
  ),
  emergencyhosp_2_day = bn_node(
    ~as.integer(runif(n=1, emergencyhosp_1_day+1, emergencyhosp_1_day+30)),
    missing_rate = ~0.9,
    needs = "emergencyhosp_1_day"
  ),
  emergencyhosp_3_day = bn_node(
    ~as.integer(runif(n=1, emergencyhosp_2_day+1, emergencyhosp_2_day+30)),
    missing_rate = ~0.9,
    needs = "emergencyhosp_2_day"
  ),
  emergencyhosp_4_day = bn_node(
    ~as.integer(runif(n=1, emergencyhosp_3_day+1, emergencyhosp_3_day+30)),
    missing_rate = ~0.9,
    needs = "emergencyhosp_3_day"
  ),

  covidemergencyhosp_1_day = bn_node(
    ~as.integer(runif(n=1, index_day, index_day+100)),
    missing_rate = ~0.95
  ),
  covidemergencyhosp_2_day = bn_node(
    ~as.integer(runif(n=1, covidemergencyhosp_1_day+1, covidemergencyhosp_1_day+30)),
    missing_rate = ~0.9,
    needs = "covidemergencyhosp_1_day"
  ),
  covidemergencyhosp_3_day = bn_node(
    ~as.integer(runif(n=1, covidemergencyhosp_2_day+1, covidemergencyhosp_2_day+30)),
    missing_rate = ~0.9,
    needs = "covidemergencyhosp_2_day"
  ),
  covidemergencyhosp_4_day = bn_node(
    ~as.integer(runif(n=1, covidemergencyhosp_3_day+1, covidemergencyhosp_3_day+30)),
    missing_rate = ~0.9,
    needs = "covidemergencyhosp_3_day"
  ),



  admitted_covid_0_day = bn_node(
    ~as.integer(runif(n=1, index_day-100, index_day-1)),
    missing_rate = ~0.99
  ),
  admitted_covid_1_day = bn_node(
    ~as.integer(runif(n=1, index_day, index_day+100)),
    missing_rate = ~0.7
  ),
  admitted_covid_2_day = bn_node(
    ~as.integer(runif(n=1, admitted_covid_1_day+1, admitted_covid_1_day+30)),
    missing_rate = ~0.9,
    needs = "admitted_covid_1_day"
  ),
  admitted_covid_3_day = bn_node(
    ~as.integer(runif(n=1, admitted_covid_2_day+1, admitted_covid_2_day+30)),
    missing_rate = ~0.9,
    needs = "admitted_covid_2_day"
  ),
  admitted_covid_4_day = bn_node(
    ~as.integer(runif(n=1, admitted_covid_3_day+1, admitted_covid_3_day+30)),
    missing_rate = ~0.9,
    needs = "admitted_covid_3_day"
  ),

  discharged_covid_1_day = bn_node(
    ~as.integer(runif(n=1, admitted_covid_1_day+1, admitted_covid_1_day+20)),
    needs="admitted_covid_1_day"
  ),
  discharged_covid_2_day = bn_node(
    ~as.integer(runif(n=1, admitted_covid_2_day+1, admitted_covid_2_day+20)),
    needs="admitted_covid_2_day"
  ),
  discharged_covid_3_day = bn_node(
    ~as.integer(runif(n=1, admitted_covid_3_day+1, admitted_covid_3_day+20)),
    needs="admitted_covid_3_day"
  ),
  discharged_covid_4_day = bn_node(
    ~as.integer(runif(n=1, admitted_covid_4_day+1, admitted_covid_4_day+20)),
    needs="admitted_covid_4_day"
  ),

  admitted_covid_ccdays_1 = bn_node(
    ~rfactor(n=1, levels = 0:3, p = c(0.7, 0.1, 0.1, 0.1)),
    needs = "admitted_covid_1_day"
  ),
  admitted_covid_ccdays_2 = bn_node(
    ~rfactor(n=1, levels = 0:3, p = c(0.7, 0.1, 0.1, 0.1)),
    needs = "admitted_covid_2_day"
  ),
  admitted_covid_ccdays_3 = bn_node(
    ~rfactor(n=1, levels = 0:3, p = c(0.7, 0.1, 0.1, 0.1)),
    needs = "admitted_covid_3_day"
  ),
  admitted_covid_ccdays_4 = bn_node(
    ~rfactor(n=1, levels = 0:3, p = c(0.7, 0.1, 0.1, 0.1)),
    needs = "admitted_covid_4_day"
  ),

)
bn <- bn_create(sim_list, known_variables = known_variables)

bn_plot(bn)
bn_plot(bn, connected_only=TRUE)


dummydata <-bn_simulate(bn, pop_size = population_size, keep_all = FALSE, .id="patient_id")


dummydata_processed <- dummydata %>%
  mutate(

  ) %>%
  #convert logical to integer as study defs output 0/1 not TRUE/FALSE
  #mutate(across(where(is.logical), ~ as.integer(.))) %>%
  #convert integer days to dates since index date and rename vars
  mutate(across(ends_with("_day"), ~ as.Date(as.character(index_date + .)))) %>%
  rename_with(~str_replace(., "_day", "_date"), ends_with("_day"))


fs::dir_create(here("lib", "dummydata"))
write_feather(dummydata_processed, sink = here("lib", "dummydata", "dummyinput.feather"))


