# Effectiveness of COVID-19 Vaccine booster doses

This study estimates effectiveness of booster doses 

## Repository navigation

-   The [protocol is in the OpenSAFELY Google drive](https://docs.google.com/document/d/1Lu_ZEhCxKpMaPs4U_WsLR-Swb3mD7y8sP-49xibt-N8/edit#) (restricted access only).

-   If you are interested in how we defined our codelists, look in the [`codelists/`](./codelists/) directory.

-   Analysis scripts are in the [`analysis/`](./analysis) directory.

    -   The instructions used to extract data from the OpensAFELY-TPP database is specified in the [study definition](./analysis/study_definition.py); this is written in Python, but non-programmers should be able to understand what is going on there
    -   The [`lib/`](./lib) directory contains preliminary (pre data extract) scripts, useful functions, and dummy data.
    -   The remaining folders mostly contain the R scripts that process, describe, and analyse the extracted database data.

-   Non-disclosive model outputs, including tables, figures, etc, are in the [`released_outputs/`](./released_outputs) directory.

-   The [`project.yaml`](./project.yaml) defines run-order and dependencies for all the analysis scripts. **This file should *not* be edited directly**. To make changes to the yaml, edit and run the [`create-project.R`](./create-project.R) script instead.

## R scripts

-   [`design.R`](analysis/R/design.R) defines some common design elements used throughout the study, such as follow-up dates, model outcomes, and covariates.
-   [`dummydata.R`](analysis/R/dummydata.R) contains the script used to generate dummy data. This is used instead of the usual dummy data specified in the study definition, because it is then possible to impose some more useful structure in the data, such as ensuring nobody has a first dose of both the Pfizer and Astra-Zeneca vaccines. If the study definition is updated, this script must also be updated to ensure variable names and types match.
-   [`data_process.R`](analysis/R/data_process.R) imports the extracted database data (or dummy data), standardises some variables and derives some new ones.
-   [`data_process_long.R`](analysis/R/data_process_long.R) imports the processed data and creates one-row-per-patient-per-event datasets for the time-varying covariates.
-   [`data_selection.R`](./analysis/R/data_selection.R) filters out participants who should not be included in the main analysis, and creates a small table used for the inclusion/exclusion flowchart.
-   [`data_properties.R`](./analysis/R/data_properties.R) tabulates and summarises the variables in the processed data for inspection / sense-checking.
-   [`model_seqtrialcox.R`](./analysis/R/model_seqtrialcox.R) runs the sequential trial analysis. This script takes two arguments:
    -   `treatment`, either `pfizer` or `moderna`, indicating the brand of the booster vaccine
    -   `outcome`, for example `postest` for positive SARS-CoV-2 test or `covidadmitted` COVID-19 hospitalisation
         included.
-   [`report_seqtrialcox.R`](./analysis/R/report_seqtrialcox.R) outputs summary information, effect estimates, and marginalised cumulative incidence estimates for the Cox models from `model_seqtrialcox.R`. This script uses the `treatment` and `outcome` arguments to pick up the correct models from this script.

## Manuscript

Not yet drafted.

# About the OpenSAFELY framework

The OpenSAFELY framework is a secure analytics platform for electronic health records research in the NHS.

Instead of requesting access for slices of patient data and transporting them elsewhere for analysis, the framework supports developing analytics against dummy data, and then running against the real data *within the same infrastructure that the data is stored*. Read more at [OpenSAFELY.org](https://opensafely.org).

Developers and epidemiologists interested in the framework should review [the OpenSAFELY documentation](https://docs.opensafely.org)
