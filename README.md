# Effectiveness of COVID-19 Vaccine booster doses

This study estimates effectiveness of booster doses versus those with two doses only. 

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

-   [`design.R`](analysis/design.R) defines some common design elements used throughout the study, such as follow-up dates, model outcomes, and covariates.
-   [`dummydata.R`](analysis/dummydata.R) contains the script used to generate dummy data. This is used instead of the usual dummy data specified in the study definition, because it is then possible to impose some more useful structure in the data, such as ensuring nobody has a first dose of both the Pfizer and Astra-Zeneca vaccines. If the study definition is updated, this script must also be updated to ensure variable names and types match.
-   [`data_process.R`](analysis/data_process.R) imports the extracted database data (or dummy data), standardises some variables and derives some new ones.
-   [`data_process_long.R`](analysis/data_process_long.R) imports the processed data and creates one-row-per-patient-per-event datasets for the time-varying covariates.
-   [`data_selection.R`](./analysis/data_selection.R) filters out participants who should not be included in the main analysis, and creates a small table used for the inclusion/exclusion flowchart.
-   [`vax_date.R`](./analysis/vax_date.R) plots vaccination counts by JCVI group and region.
-   [`match_seqtrialcox.R`](./analysis/match_seqtrialcox.R) runs the matching algorithm to pair boosted people with unboosted people. It outputs a matched dataset (with unmatched boosts dropped) and other matching diagnostics. The script takes one argument:
    -   `treatment`, either _pfizer_ or _moderna_, indicating the brand of the booster vaccine of interest.
-   [`merge_seqtrialcox.R`](./analysis/merge_seqtrialcox.R) merges in additional covariate information for each trial arm as at the recruitment date, and summarises Table 1 type cohort characteristics, stratified by treatment arm. The script also uses the `treatment` argument to pick up the matching data from the previous script.
-   [`combine_match`](./analysis/combine_match.R) collects summary information about the matching routine and puts them into one plot or table.
-   [`model_seqtrialcox.R`](./analysis/model_seqtrialcox.R) reports the event counts within each covariate level and runs the sequential trial analysis. The script takes three arguments:
    -  `treatment`, as before
    -   `outcome` to choose the outcome of interest, for example _postest_ or _covidadmitted_
    -   `subgroup` to choose which subgroup to run the analysis within. Choose _none_ for no subgroups (i.e., the main analysis). Choose _<variable>-<level>_ to select a specific category of a specific variable. 
-   [`report_seqtrialcox.R`](./analysis/report_seqtrialcox.R) outputs summary information, anadjusted Kaplan-Meier estimates, effect estimates, incidence rates, and marginalised cumulative incidence estimates for the Cox models from `model_seqtrialcox.R`. The script uses the `treatment`, `outcome`, and `subgroup` arguments to pick up the correct models from the modelling script.
-   [`combine_model`](./analysis/combine_model.R) collects effect estimates and incidence rates for each treatment and outcome combination, and puts them in one plot or table. Takes an argument `subgroup_variable` (e.g., _none_, _vax12_type_, etc) to combine levels from a given subgroup analysis.
-   [`maunscript_objects`](./analysis/manuscript_objects.R) collects files that are needed for the study manuscript and puts them in a single folder to make releasing files easier. There is also a small amount of processing. 


## Manuscript

Pre-print available on MedRxiv soon.

# About the OpenSAFELY framework

The OpenSAFELY framework is a secure analytics platform for electronic health records research in the NHS.

Instead of requesting access for slices of patient data and transporting them elsewhere for analysis, the framework supports developing analytics against dummy data, and then running against the real data *within the same infrastructure that the data is stored*. Read more at [OpenSAFELY.org](https://opensafely.org).

Developers and epidemiologists interested in the framework should review [the OpenSAFELY documentation](https://docs.opensafely.org)
