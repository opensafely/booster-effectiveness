
from cohortextractor import (
  StudyDefinition,
  patients,
  codelist_from_csv,
  codelist,
  filter_codes_by_category,
  combine_codelists,
)

# Import Codelists
import codelists

# import json module
import json

# import study dates
with open("./lib/design/study-dates.json") as f:
  study_dates = json.load(f)

# change these in design.R if necessary
firstpossiblevax_date = study_dates["firstpossiblevax_date"]
studystart_date = study_dates["studystart_date"] 
studyend_date = study_dates["studyend_date"]
firstpfizer_date = study_dates["firstpfizer_date"]
firstaz_date = study_dates["firstaz_date"]
firstmoderna_date = study_dates["firstmoderna_date"]


from datetime import datetime, timedelta
def days(datestring, days):
  
  dt = datetime.strptime(datestring, "%Y-%m-%d").date()
  dt_add = dt + timedelta(days)
  datestring_add = datetime.strftime(dt_add, "%Y-%m-%d")

  return datestring_add


## functions for extracting time dependent variables


def vaccination_date_X(name, index_date, n, product_name_matches):
  
  def var_signature(
    name,
    on_or_after,
    product_name_matches
  ):
    return {
      name: patients.with_tpp_vaccination_record(
        product_name_matches=product_name_matches,
        on_or_after=on_or_after,
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD"
      ),
    }
    
  variables = var_signature(f"{name}_1_date", index_date, product_name_matches)
  for i in range(2, n+1):
    variables.update(var_signature(
      f"{name}_{i}_date", 
      f"{name}_{i-1}_date + 1 days", 
      product_name_matches
    ))
  return variables


def covid_test_date_X(name, index_date, n, test_result):
    
  def var_signature(name, on_or_after, test_result):
    return {
      name: patients.with_test_result_in_sgss(
        pathogen="SARS-CoV-2",
        test_result=test_result,
        on_or_after=on_or_after,
        find_first_match_in_period=True,
        restrict_to_earliest_specimen_date=False,
        returning="date",
        date_format="YYYY-MM-DD"
      ),
    }
  variables = var_signature(f"{name}_1_date", index_date, test_result)
  for i in range(2, n+1):
    variables.update(var_signature(f"{name}_{i}_date", f"{name}_{i-1}_date + 1 day", test_result))
  return variables


def emergency_attendance_date_X(
  name, index_date, n
):
    
  def var_signature(name, on_or_after):
    return {
      name: patients.attended_emergency_care(
        returning="date_arrived",
        on_or_after=on_or_after,
        find_first_match_in_period=True,
        date_format="YYYY-MM-DD"
      ),
    }
  variables = var_signature(f"{name}_1_date", index_date)
  for i in range(2, n+1):
      variables.update(var_signature(f"{name}_{i}_date", f"{name}_{i-1}_date + 1 day"))
  return variables



def admitted_date_X(
  name, index_name, index_date, n, returning, 
  with_these_diagnoses=None, 
  with_admission_method=None, 
  with_patient_classification=None
):
  def var_signature(
    name, on_or_after, returning, 
    with_these_diagnoses, 
    with_admission_method, 
    with_patient_classification
  ):
    return {
      name: patients.admitted_to_hospital(
        returning = returning,
        on_or_after = on_or_after,
        find_first_match_in_period = True,
        date_format = "YYYY-MM-DD",
        with_these_diagnoses = with_these_diagnoses,
        with_admission_method = with_admission_method,
        with_patient_classification = with_patient_classification
	   ),
    }
  
  variables = var_signature(
    f"{name}_1_date", 
    index_date, 
    returning, 
    with_these_diagnoses,
    with_admission_method,
    with_patient_classification
  )
  for i in range(2, n+1):
    variables.update(var_signature(
      f"{name}_{i}_date", 
      f"{index_name}_{i-1}_date + 1 day", 
      returning, 
      with_these_diagnoses,
      with_admission_method,
      with_patient_classification
    ))
  return variables


# Specifiy study defeinition
study = StudyDefinition(
  # Configure the expectations framework
  default_expectations={
    "date": {"earliest": "2020-01-01", "latest": studyend_date},
    "rate": "uniform",
    "incidence": 0.2,
    "int": {"distribution": "normal", "mean": 1000, "stddev": 100},
    "float": {"distribution": "normal", "mean": 25, "stddev": 5},
  },
  
  index_date = studystart_date,
  # This line defines the study population
  population=patients.satisfying(
    """
      registered
      AND
      age >= 18
      AND
      NOT has_died
      AND 
      covid_vax_disease_2_date
    """,
    registered=patients.registered_as_of(
      "index_date - 1 day",
    ),
    has_died=patients.died_from_any_cause(
      on_or_before="index_date - 1 day",
      returning="binary_flag",
    ),
    
  ),
  
  
  ###############################################################################
  # COVID VACCINATION
  ###############################################################################
  
  #################################################################
  ## COVID VACCINATION
  #################################################################
  
  # pfizer
  **vaccination_date_X(
    name = "covid_vax_pfizer",
    index_date = "1900-01-01",
    n = 4,
    product_name_matches="COVID-19 mRNA Vaccine Comirnaty 30micrograms/0.3ml dose conc for susp for inj MDV (Pfizer)",
  ),
  
  # az
  **vaccination_date_X(
    name = "covid_vax_az",
    index_date = "1900-01-01",
    n = 4,
    product_name_matches="COVID-19 Vac AstraZeneca (ChAdOx1 S recomb) 5x10000000000 viral particles/0.5ml dose sol for inj MDV",
  ),
  
  # moderna
  **vaccination_date_X(
    name = "covid_vax_moderna",
    index_date = "1900-01-01",
    n = 4,
    product_name_matches="COVID-19 mRNA (nucleoside modified) Vaccine Moderna 0.1mg/0.5mL dose dispersion for inj MDV",
  ),
  
  
  #################################################################
  ## COVID VACCINATION TYPE = any based on disease target
  #################################################################
  
  covid_vax_disease_1_date=patients.with_tpp_vaccination_record(
    target_disease_matches="SARS-2 CORONAVIRUS",
    on_or_after=firstpossiblevax_date,
    find_first_match_in_period=True,
    returning="date",
    date_format="YYYY-MM-DD",
  ),
  
  covid_vax_disease_2_date=patients.with_tpp_vaccination_record(
    target_disease_matches="SARS-2 CORONAVIRUS",
    on_or_after="covid_vax_disease_1_date + 1 days",
    find_first_match_in_period=True,
    returning="date",
    date_format="YYYY-MM-DD",
  ),

  covid_vax_disease_3_date=patients.with_tpp_vaccination_record(
    target_disease_matches="SARS-2 CORONAVIRUS",
    on_or_after="covid_vax_disease_2_date + 1 days",
    find_first_match_in_period=True,
    returning="date",
    date_format="YYYY-MM-DD",
  ),
  
  covid_vax_disease_4_date=patients.with_tpp_vaccination_record(
    target_disease_matches="SARS-2 CORONAVIRUS",
    on_or_after="covid_vax_disease_3_date + 1 days",
    find_first_match_in_period=True,
    returning="date",
    date_format="YYYY-MM-DD",
  ),
  

  ###############################################################################
  # ADMIN AND DEMOGRAPHICS
  ###############################################################################
  
  has_follow_up_previous_6weeks=patients.registered_with_one_practice_between(
    start_date="index_date - 42 days",
    end_date="index_date",
  ),
  
  dereg_date=patients.date_deregistered_from_all_supported_practices(
    on_or_after="index_date",
    date_format="YYYY-MM-DD",
  ),
  
  
  # https://github.com/opensafely/risk-factors-research/issues/49
  age=patients.age_as_of( 
    "index_date - 1 day",
  ),
  
  age_march2020=patients.age_as_of( 
    "2020-03-31",
  ),
  
  # https://github.com/opensafely/risk-factors-research/issues/46
  sex=patients.sex(
    return_expectations={
      "rate": "universal",
      "category": {"ratios": {"M": 0.49, "F": 0.51}},
      "incidence": 1,
    }
  ),
  
  # https://github.com/opensafely/risk-factors-research/issues/51
  bmi=patients.categorised_as(
    {
      "Not obese": "DEFAULT",
      "Obese I (30-34.9)": """ bmi_value >= 30 AND bmi_value < 35""",
      "Obese II (35-39.9)": """ bmi_value >= 35 AND bmi_value < 40""",
      "Obese III (40+)": """ bmi_value >= 40 AND bmi_value < 100""",
      # set maximum to avoid any impossibly extreme values being classified as obese
    },
    bmi_value=patients.most_recent_bmi(
      on_or_after="index_date - 5 years",
      minimum_age_at_measurement=16
    ),
    return_expectations={
      "rate": "universal",
      "category": {
        "ratios": {
          "Not obese": 0.7,
          "Obese I (30-34.9)": 0.1,
          "Obese II (35-39.9)": 0.1,
          "Obese III (40+)": 0.1,
        }
      },
    },
  ),
  
  
  
  # ETHNICITY IN 16 CATEGORIES
  # ethnicity_16=patients.with_these_clinical_events(
  #     ethnicity_16,
  #     returning="category",
  #     find_last_match_in_period=True,
  #     include_date_of_match=False,
  #     return_expectations={
  #         "category": {
  #             "ratios": {
  #                 "1": 0.0625,
  #                 "2": 0.0625,
  #                 "3": 0.0625,
  #                 "4": 0.0625,
  #                 "5": 0.0625,
  #                 "6": 0.0625,
  #                 "7": 0.0625,
  #                 "8": 0.0625,
  #                 "9": 0.0625,
  #                 "10": 0.0625,
  #                 "11": 0.0625,
  #                 "12": 0.0625,
  #                 "13": 0.0625,
  #                 "14": 0.0625,
  #                 "15": 0.0625,
  #                 "16": 0.0625,
  #             }
  #         },
  #         "incidence": 0.75,
  #     },
  # ),
  
  # ETHNICITY IN 6 CATEGORIES
  ethnicity = patients.with_these_clinical_events(
    codelists.ethnicity,
    returning="category",
    find_last_match_in_period=True,
    include_date_of_match=False,
    return_expectations={
      "category": {"ratios": {"1": 0.2, "2": 0.2, "3": 0.2, "4": 0.2, "5": 0.2}},
      "incidence": 0.75,
    },
  ),
  
  # ethnicity variable that takes data from SUS
  ethnicity_6_sus = patients.with_ethnicity_from_sus(
    returning="group_6",  
    use_most_frequent_code=True,
    return_expectations={
      "category": {"ratios": {"1": 0.2, "2": 0.2, "3": 0.2, "4": 0.2, "5": 0.2}},
      "incidence": 0.8,
    },
  ),
  
  ################################################
  ###### PRACTICE AND PATIENT ADDRESS VARIABLES ##
  ################################################
  # practice pseudo id
  practice_id=patients.registered_practice_as_of(
    "index_date - 1 day",
    returning="pseudo_id",
    return_expectations={
      "int": {"distribution": "normal", "mean": 1000, "stddev": 100},
      "incidence": 1,
    },
  ),
  
  # msoa
  msoa=patients.address_as_of(
    "index_date - 1 day",
    returning="msoa",
    return_expectations={
      "rate": "universal",
      "category": {"ratios": {"E02000001": 0.0625, "E02000002": 0.0625, "E02000003": 0.0625, "E02000004": 0.0625,
        "E02000005": 0.0625, "E02000007": 0.0625, "E02000008": 0.0625, "E02000009": 0.0625, 
        "E02000010": 0.0625, "E02000011": 0.0625, "E02000012": 0.0625, "E02000013": 0.0625, 
        "E02000014": 0.0625, "E02000015": 0.0625, "E02000016": 0.0625, "E02000017": 0.0625}},
    },
  ),    
  
  # stp is an NHS administration region based on geography
  stp=patients.registered_practice_as_of(
    "index_date - 1 day",
    returning="stp_code",
    return_expectations={
      "rate": "universal",
      "category": {
        "ratios": {
          "STP1": 0.1,
          "STP2": 0.1,
          "STP3": 0.1,
          "STP4": 0.1,
          "STP5": 0.1,
          "STP6": 0.1,
          "STP7": 0.1,
          "STP8": 0.1,
          "STP9": 0.1,
          "STP10": 0.1,
        }
      },
    },
  ),
  # NHS administrative region
  region=patients.registered_practice_as_of(
    "index_date - 1 day",
    returning="nuts1_region_name",
    return_expectations={
      "rate": "universal",
      "category": {
        "ratios": {
          "North East": 0.1,
          "North West": 0.1,
          "Yorkshire and The Humber": 0.2,
          "East Midlands": 0.1,
          "West Midlands": 0.1,
          "East": 0.1,
          "London": 0.1,
          "South East": 0.1,
          "South West": 0.1
          #"" : 0.01
        },
      },
    },
  ),
  
  ## IMD - quintile
  
  imd=patients.address_as_of(
    "index_date - 1 day",
    returning="index_of_multiple_deprivation",
    round_to_nearest=100,
    return_expectations={
      "category": {"ratios": {c: 1/320 for c in range(100, 32100, 100)}}
    }
  ),
  
  #rurality
  rural_urban=patients.address_as_of(
    "index_date - 1 day",
    returning="rural_urban_classification",
    return_expectations={
      "rate": "universal",
      "category": {"ratios": {1: 0.125, 2: 0.125, 3: 0.125, 4: 0.125, 5: 0.125, 6: 0.125, 7: 0.125, 8: 0.125}},
    },
  ),

  # health or social care worker  
  hscworker = patients.with_healthcare_worker_flag_on_covid_vaccine_record(returning="binary_flag"),
  
  care_home_type=patients.care_home_status_as_of(
      "index_date - 1 day",
      categorised_as={
          "Carehome": """
            IsPotentialCareHome
            AND LocationDoesNotRequireNursing='Y'
            AND LocationRequiresNursing='N'
          """,
          "Nursinghome": """
            IsPotentialCareHome
            AND LocationDoesNotRequireNursing='N'
            AND LocationRequiresNursing='Y'
          """,
          "Mixed": "IsPotentialCareHome",
          "": "DEFAULT",  # use empty string
      },
      return_expectations={
          "category": {"ratios": {"Carehome": 0.05, "Nursinghome": 0.05, "Mixed": 0.05, "": 0.85, }, },
          "incidence": 1,
      },
  ),
  
  # simple care home flag
  care_home_tpp=patients.satisfying(
      """care_home_type""",
      return_expectations={"incidence": 0.01},
  ),
  
  # Patients in long-stay nursing and residential care
  care_home_code=patients.with_these_clinical_events(
      codelists.carehome,
      on_or_before="index_date - 1 day",
      returning="binary_flag",
      return_expectations={"incidence": 0.01},
  ),
  

  ################################################
  ############ pre-vaccine events ################
  ################################################

  # positive covid test
  positive_test_0_date=patients.with_test_result_in_sgss(
      pathogen="SARS-CoV-2",
      test_result="positive",
      returning="date",
      date_format="YYYY-MM-DD",
      on_or_before="index_date - 1 day",
      find_last_match_in_period=True,
      restrict_to_earliest_specimen_date=False,
  ),
  
  **covid_test_date_X(
      name = "positive_test",
      index_date = "index_date",
      n = 6,
      test_result="positive",
  ),
  
  
  # emergency attendance
  **emergency_attendance_date_X(
    name = "emergency",
    n = 6,
    index_date = "index_date",
  ),
    
  # unplanned hospital admission
  admitted_unplanned_0_date=patients.admitted_to_hospital(
    returning="date_admitted",
    on_or_before="index_date - 1 day",
    with_admission_method=["21", "22", "23", "24", "25", "2A", "2B", "2C", "2D", "28"],
    with_patient_classification = ["1"],
    date_format="YYYY-MM-DD",
    find_first_match_in_period=True,
  ),
  
  **admitted_date_X(
    name = "admitted_unplanned",
    n = 6,
    index_name = "admitted_unplanned",
    index_date = "index_date",
    returning="date_admitted",
    with_admission_method=["21", "22", "23", "24", "25", "2A", "2B", "2C", "2D", "28"],
    with_patient_classification = ["1"],
  ),
  
  discharged_unplanned_0_date=patients.admitted_to_hospital(
    returning="date_discharged",
    on_or_before="index_date - 1 day",
    with_admission_method=["21", "22", "23", "24", "25", "2A", "2B", "2C", "2D", "28"],
    with_patient_classification = ["1"],
    date_format="YYYY-MM-DD",
    find_first_match_in_period=True,
  ), 
  
  **admitted_date_X(
    name = "discharged_unplanned",
    n = 6,
    index_name = "admitted_unplanned",
    index_date = "index_date",
    returning="date_discharged",
    with_admission_method=["21", "22", "23", "24", "25", "2A", "2B", "2C", "2D", "28"],
    with_patient_classification = ["1"],
  ),
  
  
    # planned hospital admission
  admitted_planned_0_date=patients.admitted_to_hospital(
    returning="date_admitted",
    on_or_before="index_date - 1 day",
    with_admission_method=["11", "12", "13", "81"],
    #with_patient_classification = ["1"],
    date_format="YYYY-MM-DD",
    find_first_match_in_period=True,
  ),
  
  **admitted_date_X(
    name = "admitted_planned",
    n = 6,
    index_name = "admitted_planned",
    index_date = "index_date",
    returning="date_admitted",
    with_admission_method=["11", "12", "13", "81"],
    #with_patient_classification = ["1"],
  ),
  
  discharged_planned_0_date=patients.admitted_to_hospital(
    returning="date_discharged",
    on_or_before="index_date - 1 day",
    with_admission_method=["11", "12", "13", "81"],
    #with_patient_classification = ["1"],
    date_format="YYYY-MM-DD",
    find_first_match_in_period=True,
  ), 
  
  **admitted_date_X(
    name = "discharged_planned",
    n = 6,
    index_name = "admitted_planned",
    index_date = "index_date",
    returning="date_discharged",
    with_admission_method=["11", "12", "13", "81"],
    #with_patient_classification = ["1"],
  ),
  
  
  # Positive cae identification prior to vaccination
  primary_care_covid_case_0_date=patients.with_these_clinical_events(
    combine_codelists(
      codelists.covid_primary_care_code,
      codelists.covid_primary_care_positive_test,
      codelists.covid_primary_care_sequalae,
    ),
    returning="date",
    date_format="YYYY-MM-DD",
    on_or_before="index_date - 1 day",
    find_first_match_in_period=True,
  ),

  # Positive covid admission prior to vaccination
  covidadmitted_0_date=patients.admitted_to_hospital(
    returning="date_admitted",
    with_these_diagnoses=codelists.covid_icd10,
    on_or_before="index_date - 1 day",
    date_format="YYYY-MM-DD",
    find_first_match_in_period=True,
  ),

  covid_test_0_date=patients.with_test_result_in_sgss(
    pathogen="SARS-CoV-2",
    test_result="any",
    on_or_before="index_date - 1 day",
    returning="date", # need "count" here but not yet available
    date_format="YYYY-MM-DD",
    find_first_match_in_period=True,
    restrict_to_earliest_specimen_date=False,
  ),

  prior_covid_test_frequency=patients.with_test_result_in_sgss(
    pathogen="SARS-CoV-2",
    test_result="any",
    between=["index_date - 182 days", "index_date - 1 day"],
    returning="number_of_matches_in_period", # need "count" here but not yet available
    date_format="YYYY-MM-DD",
    find_first_match_in_period=True,
    restrict_to_earliest_specimen_date=False,
  ),


  ################################################
  ############ events during study period ########
  ################################################


  # SGSS TEST
covid_test_date=patients.with_test_result_in_sgss(
  pathogen="SARS-CoV-2",
  test_result="any",
  on_or_after="index_date",
  find_first_match_in_period=True,
  restrict_to_earliest_specimen_date=False,
  returning="date",
  date_format="YYYY-MM-DD",
),

  # ANY EMERGENCY ATTENDANCE
  covidemergency_date=patients.attended_emergency_care(
    returning="date_arrived",
    on_or_after="index_date",
    with_these_diagnoses = codelists.covid_emergency,
    date_format="YYYY-MM-DD",
    find_first_match_in_period=True,
  ),

  # COVID-RELATED UNPLANNED HOSPITAL ADMISSION
  covidadmitted_date=patients.admitted_to_hospital(
    returning="date_admitted",
    with_these_diagnoses=codelists.covid_icd10,
    with_admission_method=["21", "22", "23", "24", "25", "2A", "2B", "2C", "2D", "28"],
    on_or_after="index_date",
    date_format="YYYY-MM-DD",
    find_first_match_in_period=True,
  ),

  # COVID-RELATED UNPLANNED HOSPITAL ADMISSION DAYS IN CRITICAL CARE
  covidadmitted_ccdays=patients.admitted_to_hospital(
    returning="days_in_critical_care",
    with_these_diagnoses=codelists.covid_icd10,
    with_admission_method=["21", "22", "23", "24", "25", "2A", "2B", "2C", "2D", "28"],
    on_or_after="index_date",
    date_format="YYYY-MM-DD",
    find_first_match_in_period=True,
    return_expectations={
      "category": {"ratios": {"0": 0.75, "1": 0.20,  "2": 0.05}},
      "incidence": 0.05,
    },
  ),

  # COVID-RELATED DEATH
  coviddeath_date=patients.with_these_codes_on_death_certificate(
    codelists.covid_icd10,
    returning="date_of_death",
    date_format="YYYY-MM-DD",
  ),
  
  # ALL-CAUSE DEATH
  death_date=patients.died_from_any_cause(
    returning="date_of_death",
    date_format="YYYY-MM-DD",
  ),


  ############################################################
  ######### CLINICAL CO-MORBIDITIES ##########################
  ############################################################
  # From PRIMIS


  asthma = patients.satisfying(
    """
      astadm OR
      (ast AND astrxm1 AND astrxm2 AND astrxm3)
      """,
    # Asthma Admission codes
    astadm=patients.with_these_clinical_events(
      codelists.astadm,
      returning="binary_flag",
      on_or_before="index_date - 1 day",
    ),
    # Asthma Diagnosis code
    ast = patients.with_these_clinical_events(
      codelists.ast,
      returning="binary_flag",
      on_or_before="index_date - 1 day,
    ),
    # Asthma systemic steroid prescription code in month 1
    astrxm1=patients.with_these_medications(
      codelists.astrx,
      returning="binary_flag",
      between=["index_date - 30 days", "index_date - 1 day"],
    ),
    # Asthma systemic steroid prescription code in month 2
    astrxm2=patients.with_these_medications(
      codelists.astrx,
      returning="binary_flag",
      between=["index_date - 60 days", "index_date - 31 days"],
    ),
    # Asthma systemic steroid prescription code in month 3
    astrxm3=patients.with_these_medications(
      codelists.astrx,
      returning="binary_flag",
      between= ["index_date - 90", "index_date - 61 days"],
    ),

  ),

  # Chronic Neurological Disease including Significant Learning Disorder
  chronic_neuro_disease=patients.with_these_clinical_events(
    codelists.cns_cov,
    returning="binary_flag",
    on_or_before="index_date - 1 day",
  ),

  # Chronic Respiratory Disease
  chronic_resp_disease = patients.satisfying(
    "asthma OR resp_cov",
    resp_cov=patients.with_these_clinical_events(
      codelists.resp_cov,
      returning="binary_flag",
      on_or_before="index_date - 1 day",
    ),
  ),

  sev_obesity = patients.satisfying(
    """
      sev_obesity_date > bmi_date OR
      bmi_value1 >= 40
      """,

    bmi_stage_date=patients.with_these_clinical_events(
      codelists.bmi_stage,
      returning="date",
      find_last_match_in_period=True,
      on_or_before="index_date - 1 day",
      date_format="YYYY-MM-DD",
    ),

    sev_obesity_date=patients.with_these_clinical_events(
      codelists.sev_obesity,
      returning="date",
      find_last_match_in_period=True,
      ignore_missing_values=True,
      between= ["bmi_stage_date", "index_date - 1 day"],
      date_format="YYYY-MM-DD",
    ),

    bmi_date=patients.with_these_clinical_events(
      codelists.bmi,
      returning="date",
      ignore_missing_values=True,
      find_last_match_in_period=True,
      on_or_before="index_date - 1 day",
      date_format="YYYY-MM-DD",
    ),

    bmi_value1=patients.with_these_clinical_events(
      codelists.bmi,
      returning="numeric_value",
      ignore_missing_values=True,
      find_last_match_in_period=True,
      on_or_before="index_date - 1 day",
    ),

  ),

  diabetes = patients.satisfying(
    "dmres_date < diab_date",
    diab_date=patients.with_these_clinical_events(
      codelists.diab,
      returning="date",
      find_last_match_in_period=True,
      on_or_before="index_date - 1 day",
      date_format="YYYY-MM-DD",
    ),

    dmres_date=patients.with_these_clinical_events(
      codelists.dmres,
      returning="date",
      find_last_match_in_period=True,
      on_or_before="index_date - 1 day",
      date_format="YYYY-MM-DD",
    ),
  ),

  sev_mental=patients.satisfying(
    "smhres_date < sev_mental_date",

    # Severe Mental Illness codes
    sev_mental_date=patients.with_these_clinical_events(
      codelists.sev_mental,
      returning="date",
      find_last_match_in_period=True,
      on_or_before="index_date - 1 day",
      date_format="YYYY-MM-DD",
    ),
    # Remission codes relating to Severe Mental Illness
    smhres_date=patients.with_these_clinical_events(
      codelists.smhres,
      returning="date",
      find_last_match_in_period=True,
      on_or_before="index_date - 1 day",
      date_format="YYYY-MM-DD",
    ),
  ),


  # Chronic heart disease codes
  chronic_heart_disease=patients.with_these_clinical_events(
    codelists.chd_cov,
    returning="binary_flag",
    on_or_before="index_date - 1 day",
  ),

  chronic_kidney_disease=patients.satisfying(
    """
      ckd OR
      (ckd15_date AND ckd35_date >= ckd15_date)
      """,

    # Chronic kidney disease codes - all stages
    ckd15_date=patients.with_these_clinical_events(
      codelists.ckd15,
      returning="date",
      find_last_match_in_period=True,
      on_or_before="index_date - 1 day",
      date_format="YYYY-MM-DD",
    ),

    # Chronic kidney disease codes-stages 3 - 5
    ckd35_date=patients.with_these_clinical_events(
      codelists.ckd35,
      returning="date",
      find_last_match_in_period=True,
      on_or_before="index_date - 1 day",
      date_format="YYYY-MM-DD",
    ),

    # Chronic kidney disease diagnostic codes
    ckd=patients.with_these_clinical_events(
      codelists.ckd_cov,
      returning="binary_flag",
      on_or_before="index_date - 1 day",
    ),
  ),


  # Chronic Liver disease codes
  chronic_liver_disease=patients.with_these_clinical_events(
    codelists.cld,
    returning="binary_flag",
    on_or_before="index_date - 1 day",
  ),


  immunosuppressed=patients.satisfying(
    "immrx OR immdx",

    # Immunosuppression diagnosis codes
    immdx=patients.with_these_clinical_events(
      codelists.immdx_cov,
      returning="binary_flag",
      on_or_before="index_date - 1 day",
    ),
    # Immunosuppression medication codes
    immrx=patients.with_these_medications(
      codelists.immrx,
      returning="binary_flag",
      between=["index_date - 182 days", "index_date - 1 day"]
    ),
  ),

  # Asplenia or Dysfunction of the Spleen codes
  asplenia=patients.with_these_clinical_events(
    codelists.spln_cov,
    returning="binary_flag",
    on_or_before="index_date - 1 day",
  ),

  # Wider Learning Disability
  learndis=patients.with_these_clinical_events(
    codelists.learndis,
    returning="binary_flag",
    on_or_before="index_date - 1 day",
  ),


  # to represent household contact of shielding individual
  # hhld_imdef_dat=patients.with_these_clinical_events(
  #   codelists.hhld_imdef,
  #   returning="date",
  #   find_last_match_in_period=True,
  #   on_or_before="index_date - 1 day",
  #   date_format="YYYY-MM-DD",
  # ),
  #
  # #####################################
  # # primis employment codelists
  # #####################################
  #
  # # Carer codes
  # carer_date=patients.with_these_clinical_events(
  #   codelists.carer,
  #   returning="date",
  #   find_last_match_in_period=True,
  #   on_or_before="index_date - 1 day",
  #   date_format="YYYY-MM-DD",
  # ),
  # # No longer a carer codes
  # notcarer_date=patients.with_these_clinical_events(
  #   codelists.notcarer,
  #   returning="date",
  #   find_last_match_in_period=True,
  #   on_or_before="index_date - 1 day",
  #   date_format="YYYY-MM-DD",
  # ),
  # # Employed by Care Home codes
  # carehome_date=patients.with_these_clinical_events(
  #   codelists.carehomeemployee,
  #   returning="date",
  #   find_last_match_in_period=True,
  #   on_or_before="index_date - 1 day",
  #   date_format="YYYY-MM-DD",
  # ),
  # # Employed by nursing home codes
  # nursehome_date=patients.with_these_clinical_events(
  #   codelists.nursehomeemployee,
  #   returning="date",
  #   find_last_match_in_period=True,
  #   on_or_before="index_date - 1 day",
  #   date_format="YYYY-MM-DD",
  # ),
  # # Employed by domiciliary care provider codes
  # domcare_date=patients.with_these_clinical_events(
  #   codelists.domcareemployee,
  #   returning="date",
  #   find_last_match_in_period=True,
  #   on_or_before="index_date - 1 day",
  #   date_format="YYYY-MM-DD",
  # ),

  cev_ever = patients.with_these_clinical_events(
    codelists.shield,
    returning="binary_flag",
    on_or_before = "index_date - 1 day",
    find_last_match_in_period = True,
  ),

  cev = patients.satisfying(
    """severely_clinically_vulnerable AND NOT less_vulnerable""",

    ### SHIELDED GROUP - first flag all patients with "high risk" codes
    severely_clinically_vulnerable=patients.with_these_clinical_events(
      codelists.shield,
      returning="binary_flag",
      on_or_before = "index_date - 1 day",
      find_last_match_in_period = True,
    ),

    # find date at which the high risk code was added
    date_severely_clinically_vulnerable=patients.date_of(
      "severely_clinically_vulnerable",
      date_format="YYYY-MM-DD",
    ),

    ### NOT SHIELDED GROUP (medium and low risk) - only flag if later than 'shielded'
    less_vulnerable=patients.with_these_clinical_events(
      codelists.nonshield,
      between=["date_severely_clinically_vulnerable + 1 day", "index_date - 1 day",],
    ),

  ),

 )
