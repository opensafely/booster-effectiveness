---
title: "Effectiveness of BNT162b2 booster doses in England: a observational study in OpenSAFELY-TPP"
output:
  html_document:
    keep_md: yes
    self_contained: yes
  word_document: default
  bookdown::html_document2:
    number_sections: no
    toc: no
  pdf_document:
    toc: no
bibliography: references.bib
csl: vancouver.csl
link-citations: yes
zotero: yes
header-includes:
- \usepackage{float} 
- \floatplacement{figure}{H}
- \usepackage{caption}
- \captionsetup[figure]{labelformat=empty}
- \captionsetup[table]{labelformat=empty}
---





William J Hulme^1^, Elizabeth J Williamson^2^, Amelia Green^1^, Elsie Horne^3,4^, Helen Curtis^1^, Linda Nab^1^, Milan Wiedemann^1^, Ruth Keogh^2^, Edward Parker^2^, Venexia Walker^3,4^, Jonathan AC Sterne^3,4^, Miguel A Hernán^6,7^, Ben Goldacre^1^ + OpenSAFELY collaborative.

<!-- Krishnan Bhaskaran^2^, Helen I McDonald^2^, Christopher T Rentsch^2^, Anna Schultze^2^, John Tazare^2^, Helen J Curtis^1^, Alex J Walker^1^, Laurie Tomlinson^2^, Tom Palmer^3,4^,  Brian MacKenna^1^, Caroline E Morton^1^, Amir Mehrkar^1^, Louis Fisher^1^, Seb Bacon^1^, Dave Evans^1^, Peter Inglesby^1^, George Hickman^1^, Simon Davy^1^, Tom Ward ^1^, Richard Croker^1^, Rosalind M Eggo^2^, Angel YS Wong^2^, Rohini Mathur^2^, Kevin Wing^2^, Harriet Forbes^2^, Daniel Grint^2^, Ian J Douglas^2^, Stephen JW Evans^2^, Liam Smeeth^2^, Chris Bates^5^, Jonathan Cockburn^5^, John Parry^5^, Frank Hester^5^, Sam Harper^5^,  -->

1\. The DataLab, Nuffield Department of Primary Care Health Sciences, University of Oxford, OX26GG, UK

2\. London School of Hygiene and Tropical Medicine, Keppel Street, London, WC1E 7HT, UK

3\. Population Health Sciences, University of Bristol, Oakfield House, Oakfield Grove, Bristol, BS8 2BN, UK

4\. NIHR Bristol, Biomedical Research Centre, Bristol, UK

5\. TPP, TPP House, 129 Low Lane, Horsforth, Leeds, LS18 5PX

6\. CAUSALab, Harvard T.H. Chan School of Public Health, Boston, MA 02115

7\. Departments of Epidemiology and Biostatistics, Harvard T.H. Chan School of Public Health, Boston, MA 02115

\newpage

## Abstract

<!-- ### Standard -->

*Background*

The UK COVID-19 vaccination programme delivered the first "booster" doses in mid September 2021, initially in groups at high risk of severe disease and then across the adult population. The BNT162b2 mRNA Pfizer-BioNTech and the Moderna mRNA-1273 vaccines were used. 

*Methods*

With the approval of NHS England we used the OpenSAFELY-TPP database, covering 40% of GP practices in England and linked to national coronavirus surveillance, hospital episodes, and death registry data, to estimate the effectiveness of BNT162b2 boosting in adults eligible for boosting between 16 September 2021 and 01 December 2021. Each booster recipient was matched with an unboosted control on factors relating to booster priority status and prior immunisation. Primary outcomes were documented SARS-CoV-2 infection, COVID-19 hospital admission, and COVID-19 death up to 10 weeks after recruitment. Hazard ratios were estimated using Cox models adjusting for additional covariates that were not used as matching factors. Follow-up spanned a period in which the Delta variant was predominant.

*Results*

We matched 3,426,960 BNT162b2 booster recipients to unboosted controls. During days 15-28 after the booster, the estimated hazard ratio (95% CI) comparing a BNT162b2 booster dose to two doses only was 79.4% (78.5-80.2) for documented SARS-CoV-2 infection, 84.4% (81.0-87.1) for COVID-19 hospital admission, and 83.4% (74.6-89.1) for COVID-19 death.

*Conclusion*

We estimated high protection of BNT162b2 boosting against infection, COVID-19 hospitalisation, and COVID-19 death, though with some evidence of waning over time.

**Keywords** COVID-19; Booster vaccine effectiveness; Target trial; EHR data

<!-- *Objectives* To estimate the effectiveness of the BNT162b2 and mRNA-1273 mRNA-1273 booster COVID-19 vaccines against infection and COVID-19 disease. -->

<!-- *Design* Matched sequential trial design, emulating a series of parallel two-arm RCTs. -->

<!-- *Setting* Linked primary care, hospital, and COVID-19 surveillance records available within the OpenSAFELY-TPP research platform. -->

<!---# *Participants* 4,764,097 people with a complete primary COVID-19 vaccine course, registered with a GP practice using the TPP SystmOne clinical information system in England. --->

<!-- *Interventions* A booster vaccination with either BNT162b2 or mRNA-1273 administered as part of the national COVID-19 booster vaccine roll-out. -->

<!-- *Main outcome measures* Recorded SARS-CoV-2 infection, COVID-19-related accident and emergency attendance, unplanned COVID-19-related hospital admission, and COVID-19-related death. -->

<!-- *Results* -->

<!-- *Conclusions* -->

\newpage

<!-- TODO -->

<!-- * check for moderna references and remove if necessary -->

<!-- * check final recruitment day and include in results -->

<!-- * check if rolling average restrictions are ever used (need to output dataset) -->

<!-- * references -->

# Introduction

The national COVID-19 vaccination programme in England began a new phase in September 2021 with administration of the first booster COVID-19 vaccine doses in those who had already received their primary vaccination course (a completed first and second dose) (ref <https://www.england.nhs.uk/2021/09/nhs-begins-covid-19-booster-vaccination-campaign/>). Initially offered to those at highest risk of severe disease, eligibility was progressively extended and by 15 December 2021 every adult in England was eligible (<https://www.england.nhs.uk/2021/12/nhs-booster-bookings-open-to-every-eligible-adult/>). Booster doses were initially available no earlier than six months after dose two, but this was reduced to three months on 8 December 2021, following concerns over the surge in cases and the emergence of the Omicron variant (ref: <https://www.england.nhs.uk/2021/12/people-40-and-over-to-get-their-lifesaving-booster-jab-three-months-on-from-second-dose/>). Vaccine prioritisation schedules were guided by recommendations from the Joint Committee for Vaccine and Immunisation (JCVI) expert working group.


<!-- 13 december 30-39 become eligible (https://www.england.nhs.uk/2021/12/nhs-to-roll-out-life-saving-booster-jab-to-people-aged-30-plus/) -->

<!-- 15 december everyone eligible https://www.england.nhs.uk/2021/12/nhs-booster-bookings-open-to-every-eligible-adult/ -->

<!-- In most cases, BNT162b2 and half-dose mRNA-1273 vaccines were used for boosting, and administered regardless of the first and second dose brand. BNT162b2 was used from 16 September 2021, and mRNA-1273 from 29 October 2021 onwards. This provides an opportunity to investigate booster effectiveness of two different brands administered in overlapping periods and community contexts, as well as in subgroups defined by prior immunological and other clinical factors.-->




We set out to emulate a target trial estimating the effectiveness of booster vaccination with BNT162b2 against COVID-19 outcomes in adults who had already received two COVID-19 vaccine doses. We used the OpenSAFELY-TPP linked primary care database covering around 40% of English residents. Recruitment covers an era where the Delta variant is dominant, with follow-up curtailed shortly after the emergence of Omicron. 

# Methods


## Study design

We used observational data to emulate a target trial of the effectiveness of booster vaccination @dagan2021 @barda2021, by comparing people who had received a BNT162b2 booster dose with matched people who had not. 


## Data source

The OpenSAFELY-TPP database (<https://opensafely.org>) covers 24 million people registered at English General Practices that use TPP SystmOne electronic health record software. It includes pseudonymized data such as coded diagnoses, medications and physiological parameters. No free text data are included. This primary care data is linked (via NHS numbers) with A&E attendance and in-patient hospital spell records via NHS Digital's Hospital Episode Statistics (HES), national coronavirus testing records via the Second Generation Surveillance System (SGSS), and national death registry records from the Office for National Statistics (ONS). Vaccination status is available in the GP record directly via the National Immunisation Management System (NIMS). 

## Eligiblity criteria

We recruited adults who were eligible for booster vaccination between 16 September and 01 December 2021 inclusive. Eligibility on each day was as follows: adults (18 years and over) who were registered at a GP practice using TPP's SystmOne clinical information system; received either two doses of BNT162b2 doses or two doses of ChAdOx1-S (mixed dosing and Moderna mRNA-1273 doses were not considered due to small numbers); not a health or social care worker, not a resident in a care or nursing home, and not medically housebound or receiving end-of-life care (due to distinct clustering of vaccine uptake and infection risk in these groups that could not be reasonably measured and controlled for); no evidence of SARS-CoV-2 infection or COVID-19 disease within the previous 90 days; not undergoing an unplanned hospital admission; information on sex, ethnicity, deprivation, and NHS region was complete.

Additionally, if the rolling weekly average count of BNT162b2 booster doses within strata defined by region, JCVI group, and the week of second dose was below 50 then recruitment did not occur for that strata on that day. This helped to ensure that recruitment was restricted to those who were boosted in line with national prioritisation schedules and that the matched controls were both eligible and able to receive a booster dose at the time of potential recruitment.

The supplementary materials provide further details of the matching process.


## Matching and treatment groups

On each day of recruitment, each eligible person receiving a booster dose on that day was recruited to the treatment group and matched with an unboosted control person who had received only two doses. Pairs were matched on the following characteristics: primary course vaccine brand (2× BNT162b2 or 2× ChAdOx1-S); date of the second vaccine dose, within 7 days; NHS region (East of England, Midlands, London, North East and Yorkshire, North West, South East, South West); any evidence of prior SARS-CoV-2 infection (positive SARS-CoV-2 test, "probable" infection documented in primary care, or COVID-19 hospitalisation); clinical risk groups used for prioritisation (clinically extremely vulnerable, clinically at-risk, neither); age, within 3 years, and by age groups used for prioritisation. The matching and exclusion criteria jointly ensure that treatment groups are also matched within JCVI priority group.


People selected as controls were not eligible to be included again as a control in a subsequent trial, but were eligible for selection into the treatment group of a subsequent trial. Any unmatched boosted people were dropped.

<!-- We excluded matched pairs from days in which fewer than 10% of eligible treated people were successfully. -->

## Outcomes

The following three outcomes were considered: documented SARS-CoV-2 infection; COVID-19 hospital admission; COVID-19 death; and non-COVID-19 death as a negative control outcome. SARS-CoV-2 infections were identified using SGSS testing records and based on swab date. Both polymerase chain reaction (PCR) and lateral flow tests are included, without differentiation between symptomatic and asymptomatic infection. COVID-19 hospital admissions were identified using HES in-patient hospital records with U07.1 or U07.2 reason for admission ICD-10 codes. COVID-19 deaths with the same COVID-19 ICD-10 codes mentioned anywhere on the death certificate (i.e., as an underlying or contributing cause of death) were included. 

<!--# COVID-19 related A&E attendance and critical/intensive care admission we also considered but there were doubts over data the reliability of event ascertainment in these cases. -->
<!--# COVID-19 A&E attendances were identified using HES emergency care records with U07.1 ("COVID-19, virus identified") or U07.2 ("COVID-19, virus not identified") ICD-10 diagnosis codes @emergenc. -->


## Follow-up

Each matched pair was followed from the day of recruitment (i.e., time zero) until the earliest of death, GP practice de-registration, booster receipt by the control, 10 weeks, or 15 December 2021.

## Additional variables

The following additional variables were included as covariates in the Cox models (see below) or else to describe the treatment groups: sex (male or female); English Index of Multiple Deprivation (IMD, grouped by quintile); ethnicity (Black, Mixed, South Asian, White, Other, as per the UK census); morbidity count (diabetes, BMI > 40kg/m^2^, chronic heart disease, chronic kidney disease, chronic liver disease, chronic respiratory disease or severe asthma, chronic neurological disease); learning disabilities; severe mental illness; the number of SARS-CoV-2 tests in the 6 months prior to the study start date; elective in-hospital episode at the time of recruitment. 

The supplementary materials provide further details of the codelists and data sources used for all variables in the study. 


## Statistical Analysis

For each outcome, we estimated unadjusted cumulative incidence curves using the Kaplan-Meier estimator separately in the boosted and unboosted groups.

We use Cox models, stratified by recruitment day, NHS region, and brand of second vaccine dose, to estimate hazard ratios comparing boosted with unboosted people. We estimated effectveness over all follow-up time (1-70 days), and separately in days 1-7, 8-14, 15-28, 29-42, 43-70. Models were adjusted for additional variables not used as matching factors, as described below. A robust variance estimator was used to account for participant clustering. 

<!-- [The primary estimand is the average treatment effect in the recruited population. To estimate this, expected cumulative incidence rates are estimated for each participant assuming treatment was received by everyone in both treatment groups at time zero. These curves are then averaged over all participants to give the marginal cumulative incidence. This is repeated assuming nobody is treated in either group, and their difference taken. Calculating standard errors for these quantities is challenging, whether approached analytically (due to complex variance components) or computationally (via bootstrapping, due to the large sample sizes involved) and are therefore not reported. ] -->

We also estimated booster effectiveness in the following subgroups: primary vaccine course (both BNT162b2 or both ChAdOx1-S); age (18-64 or 65 and over); clinically extremely vulnerable. Analyses were conducted separately in each subgroup.

Booster effectiveness is defined as one minus the hazard ratio, expressed as a percentage. 


## Missing data

After exclusions for missing values on demographic variables, there were no missing values in remaining variables as they were each defined by the presence or absence of clinical codes or events in the patient record. This was therefore a complete-case analysis. 

## Software, code, and reproducibility

Data management and analyses were conducted in Python version 3.8.10 and R version 4.0.2. All code is available at <https://github.com/opensafely/booster-effectiveness>, and is shared openly for review and re-use under MIT open license. Codelists are available at <https://www.opencodelists.org/>. No person-level data is shared. Any reported figures based on counts below 6 are redacted or rounded for disclosure control.

This study followed the STROBE-RECORD reporting guidelines.

## Patient and public involvement

We have developed a publicly available website <https://opensafely.org/> through which we invite any patient or member of the public to contact us regarding this study or the broader OpenSAFELY project.




# Results

## Study population and matching

5,763,280 BNT162b2 booster recipients were identified between 16 September 2021 and 01 December 2021 in adults registered at a TPP practice, with 3,998,664 (69.4%) eligible for inclusion into the treatment group. Of these, 3,426,960 (85.7%) were successfully matched with unboosted controls (Table S1).

<!-- For mRNA-1273, this was  () and  person-years of follow-up (Table 2).  -->

Participant characteristics at trial recruitment between treatment groups (Table 1) were typically well-balanced though with some exceptions. For instance, unboosted controls had higher levels of deprivation, higher rates of learning disabilities and severe mental illness, and lower SARS-CoV-2 testing frequency, though the standardised mean difference was consistently below 0.1 (Supplementary Figure S1).


\newpage

#### Figure 1: Booster vaccination uptake, treatment group eligibility and matching success

Cumulative booster vaccination over the duration of the study period, by matching eligibility and matching success. 

<img src="C:/Users/whulme/Documents/repos/booster-effectiveness/manuscript/figures/vaxdate-1.png" width="60%" height="50%"  />  

#### Table 1: Participant characteristics

Participant characteristics as on the day of recruitment into the treatment or control group.


```{=html}
<div id="fwmhjdexoy" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#fwmhjdexoy .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#fwmhjdexoy .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#fwmhjdexoy .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#fwmhjdexoy .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#fwmhjdexoy .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#fwmhjdexoy .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#fwmhjdexoy .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#fwmhjdexoy .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#fwmhjdexoy .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#fwmhjdexoy .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#fwmhjdexoy .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#fwmhjdexoy .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#fwmhjdexoy .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#fwmhjdexoy .gt_from_md > :first-child {
  margin-top: 0;
}

#fwmhjdexoy .gt_from_md > :last-child {
  margin-bottom: 0;
}

#fwmhjdexoy .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#fwmhjdexoy .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#fwmhjdexoy .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#fwmhjdexoy .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#fwmhjdexoy .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#fwmhjdexoy .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#fwmhjdexoy .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#fwmhjdexoy .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#fwmhjdexoy .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#fwmhjdexoy .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#fwmhjdexoy .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#fwmhjdexoy .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#fwmhjdexoy .gt_left {
  text-align: left;
}

#fwmhjdexoy .gt_center {
  text-align: center;
}

#fwmhjdexoy .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#fwmhjdexoy .gt_font_normal {
  font-weight: normal;
}

#fwmhjdexoy .gt_font_bold {
  font-weight: bold;
}

#fwmhjdexoy .gt_font_italic {
  font-style: italic;
}

#fwmhjdexoy .gt_super {
  font-size: 65%;
}

#fwmhjdexoy .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 65%;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;">Characteristic</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;">Boosted, ineligible</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;">Boosted, eligible, unmatched</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;">Boosted, eligible, matched</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;">Control</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>Total N</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">765,433</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">571,704</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">3,426,960</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">3,426,960</td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>Primary vaccine course</p>
</div></td>
<td class="gt_row gt_left"></td>
<td class="gt_row gt_left"></td>
<td class="gt_row gt_left"></td>
<td class="gt_row gt_left"></td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>   BNT162b2-BNT162b2</p>
</div></td>
<td class="gt_row gt_left">446,883 (58%)</td>
<td class="gt_row gt_left">345,700 (60%)</td>
<td class="gt_row gt_left">1,476,131 (43%)</td>
<td class="gt_row gt_left">1,476,131 (43%)</td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>   ChAdOx1-ChAdOx1</p>
</div></td>
<td class="gt_row gt_left">318,550 (42%)</td>
<td class="gt_row gt_left">226,004 (40%)</td>
<td class="gt_row gt_left">1,950,829 (57%)</td>
<td class="gt_row gt_left">1,950,829 (57%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>Age</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;"></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;"></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;"></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;"></td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>   18-39</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">58,497 (7.6%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">1,174 (0.2%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">184,832 (5.4%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">199,354 (5.8%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>   40-49</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">62,987 (8.2%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">3,521 (0.6%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">221,668 (6.5%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">242,618 (7.1%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>   50-59</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">110,447 (14%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">24,398 (4.3%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">628,035 (18%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">632,212 (18%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>   60-69</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">133,034 (17%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">80,393 (14%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">939,494 (27%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">932,775 (27%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>   70-79</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">175,086 (23%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">307,114 (54%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">1,039,938 (30%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">1,011,653 (30%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>   80-89</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">195,805 (26%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">132,942 (23%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">364,261 (11%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">351,385 (10%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>   90+</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">29,577 (3.9%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">22,162 (3.9%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">48,732 (1.4%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">56,963 (1.7%)</td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>Sex</p>
</div></td>
<td class="gt_row gt_left"></td>
<td class="gt_row gt_left"></td>
<td class="gt_row gt_left"></td>
<td class="gt_row gt_left"></td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>   Female</p>
</div></td>
<td class="gt_row gt_left">431,160 (56%)</td>
<td class="gt_row gt_left">320,042 (56%)</td>
<td class="gt_row gt_left">1,860,622 (54%)</td>
<td class="gt_row gt_left">1,865,153 (54%)</td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>   Male</p>
</div></td>
<td class="gt_row gt_left">334,273 (44%)</td>
<td class="gt_row gt_left">251,662 (44%)</td>
<td class="gt_row gt_left">1,566,338 (46%)</td>
<td class="gt_row gt_left">1,561,807 (46%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>Ethnicity</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;"></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;"></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;"></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;"></td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>   White</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">697,216 (91%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">549,859 (96%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">3,218,953 (94%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">3,195,436 (93%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>   Black</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">10,010 (1.3%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">3,769 (0.7%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">31,058 (0.9%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">37,879 (1.1%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>   South Asian</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">42,951 (5.6%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">12,941 (2.3%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">126,998 (3.7%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">145,055 (4.2%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>   Mixed</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">5,018 (0.7%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">1,742 (0.3%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">18,073 (0.5%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">19,164 (0.6%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>   Other</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">10,238 (1.3%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">3,393 (0.6%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">31,878 (0.9%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">29,426 (0.9%)</td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>IMD</p>
</div></td>
<td class="gt_row gt_left"></td>
<td class="gt_row gt_left"></td>
<td class="gt_row gt_left"></td>
<td class="gt_row gt_left"></td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>   1 most deprived</p>
</div></td>
<td class="gt_row gt_left">122,596 (16%)</td>
<td class="gt_row gt_left">71,605 (13%)</td>
<td class="gt_row gt_left">469,397 (14%)</td>
<td class="gt_row gt_left">558,365 (16%)</td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>   2</p>
</div></td>
<td class="gt_row gt_left">146,615 (19%)</td>
<td class="gt_row gt_left">97,825 (17%)</td>
<td class="gt_row gt_left">586,546 (17%)</td>
<td class="gt_row gt_left">641,493 (19%)</td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>   3</p>
</div></td>
<td class="gt_row gt_left">169,530 (22%)</td>
<td class="gt_row gt_left">137,070 (24%)</td>
<td class="gt_row gt_left">763,813 (22%)</td>
<td class="gt_row gt_left">775,775 (23%)</td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>   4</p>
</div></td>
<td class="gt_row gt_left">168,784 (22%)</td>
<td class="gt_row gt_left">137,490 (24%)</td>
<td class="gt_row gt_left">799,431 (23%)</td>
<td class="gt_row gt_left">750,914 (22%)</td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>   5 least deprived</p>
</div></td>
<td class="gt_row gt_left">157,908 (21%)</td>
<td class="gt_row gt_left">127,714 (22%)</td>
<td class="gt_row gt_left">807,773 (24%)</td>
<td class="gt_row gt_left">700,413 (20%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>Region</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;"></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;"></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;"></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;"></td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>   North East and Yorkshire</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">186,077 (24%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">82,274 (14%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">616,628 (18%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">616,628 (18%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>   Midlands</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">117,643 (15%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">136,134 (24%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">774,777 (23%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">774,777 (23%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>   North West</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">111,821 (15%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">42,956 (7.5%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">285,853 (8.3%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">285,853 (8.3%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>   East of England</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">110,699 (14%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">131,819 (23%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">825,941 (24%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">825,941 (24%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>   London</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">84,553 (11%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">10,213 (1.8%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">109,498 (3.2%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">109,498 (3.2%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>   South East</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">45,434 (5.9%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">56,128 (9.8%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">261,876 (7.6%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">261,876 (7.6%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>   South West</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">109,206 (14%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">112,180 (20%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">552,387 (16%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">552,387 (16%)</td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>Clinically extremely vulnerable</p>
</div></td>
<td class="gt_row gt_left">166,588 (22%)</td>
<td class="gt_row gt_left">83,765 (15%)</td>
<td class="gt_row gt_left">470,981 (14%)</td>
<td class="gt_row gt_left">470,981 (14%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>Body Mass Index &gt; 40 kg/m^2</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">37,479 (4.9%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">16,207 (2.8%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">156,646 (4.6%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">164,724 (4.8%)</td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>Chronic heart disease</p>
</div></td>
<td class="gt_row gt_left">224,769 (29%)</td>
<td class="gt_row gt_left">152,670 (27%)</td>
<td class="gt_row gt_left">665,488 (19%)</td>
<td class="gt_row gt_left">659,164 (19%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>Chronic kidney disease</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">109,820 (14%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">89,342 (16%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">316,348 (9.2%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">315,120 (9.2%)</td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>Diabetes</p>
</div></td>
<td class="gt_row gt_left">139,416 (18%)</td>
<td class="gt_row gt_left">96,961 (17%)</td>
<td class="gt_row gt_left">532,340 (16%)</td>
<td class="gt_row gt_left">562,011 (16%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>Chronic liver disease</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">28,129 (3.7%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">15,117 (2.6%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">115,145 (3.4%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">121,472 (3.5%)</td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>Chronic respiratory disease</p>
</div></td>
<td class="gt_row gt_left">75,031 (9.8%)</td>
<td class="gt_row gt_left">51,726 (9.0%)</td>
<td class="gt_row gt_left">249,441 (7.3%)</td>
<td class="gt_row gt_left">252,359 (7.4%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>Asthma</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">6,883 (0.9%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">3,010 (0.5%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">25,437 (0.7%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">24,184 (0.7%)</td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>Chronic neurological disease</p>
</div></td>
<td class="gt_row gt_left">82,351 (11%)</td>
<td class="gt_row gt_left">57,137 (10.0%)</td>
<td class="gt_row gt_left">274,335 (8.0%)</td>
<td class="gt_row gt_left">292,425 (8.5%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>Immunosuppressed</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">40,896 (5.3%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">20,199 (3.5%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">154,260 (4.5%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">121,969 (3.6%)</td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>Asplenia or poor spleen function</p>
</div></td>
<td class="gt_row gt_left">8,788 (1.1%)</td>
<td class="gt_row gt_left">4,823 (0.8%)</td>
<td class="gt_row gt_left">40,134 (1.2%)</td>
<td class="gt_row gt_left">36,303 (1.1%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>Learning disabilities</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">3,019 (0.4%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">1,061 (0.2%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">21,039 (0.6%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">26,533 (0.8%)</td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>Serious mental illness</p>
</div></td>
<td class="gt_row gt_left">6,865 (0.9%)</td>
<td class="gt_row gt_left">3,820 (0.7%)</td>
<td class="gt_row gt_left">31,996 (0.9%)</td>
<td class="gt_row gt_left">42,422 (1.2%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>Number of SARS-CoV-2 tests</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;"></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;"></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;"></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;"></td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>   0</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">425,657 (56%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">412,696 (72%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">2,092,836 (61%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">2,217,161 (65%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>   1</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">124,172 (16%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">68,069 (12%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">486,362 (14%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">467,274 (14%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>   2</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">56,554 (7.4%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">26,571 (4.6%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">206,142 (6.0%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">193,982 (5.7%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>   3+</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">159,050 (21%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">64,368 (11%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">641,620 (19%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">548,543 (16%)</td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>Prior documented SARS-CoV-2 infection</p>
</div></td>
<td class="gt_row gt_left">122,122 (16%)</td>
<td class="gt_row gt_left">15,974 (2.8%)</td>
<td class="gt_row gt_left">202,432 (5.9%)</td>
<td class="gt_row gt_left">202,432 (5.9%)</td></tr>
    <tr><td class="gt_row gt_left" style="background-color: #F5F5F5;"><div class='gt_from_md'><p>In hospital (planned admission)</p>
</div></td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">3,700 (0.5%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">7,479 (1.3%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">46,478 (1.4%)</td>
<td class="gt_row gt_left" style="background-color: #F5F5F5;">46,421 (1.4%)</td></tr>
  </tbody>
  
  
</table>
</div>
```

\newpage

#### Table 2: Follow-up and outcomes

Total follow-up and incidence rates for each outcome, by treatment group. The cumulative incidence of each outcome is provided in Supplementary Figure S2.


```{=html}
<div id="xvsfzcfrhj" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#xvsfzcfrhj .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#xvsfzcfrhj .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#xvsfzcfrhj .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#xvsfzcfrhj .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#xvsfzcfrhj .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#xvsfzcfrhj .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#xvsfzcfrhj .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#xvsfzcfrhj .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#xvsfzcfrhj .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#xvsfzcfrhj .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#xvsfzcfrhj .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#xvsfzcfrhj .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#xvsfzcfrhj .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#xvsfzcfrhj .gt_from_md > :first-child {
  margin-top: 0;
}

#xvsfzcfrhj .gt_from_md > :last-child {
  margin-bottom: 0;
}

#xvsfzcfrhj .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#xvsfzcfrhj .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#xvsfzcfrhj .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#xvsfzcfrhj .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#xvsfzcfrhj .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#xvsfzcfrhj .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#xvsfzcfrhj .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#xvsfzcfrhj .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#xvsfzcfrhj .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#xvsfzcfrhj .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#xvsfzcfrhj .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#xvsfzcfrhj .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#xvsfzcfrhj .gt_left {
  text-align: left;
}

#xvsfzcfrhj .gt_center {
  text-align: center;
}

#xvsfzcfrhj .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#xvsfzcfrhj .gt_font_normal {
  font-weight: normal;
}

#xvsfzcfrhj .gt_font_bold {
  font-weight: bold;
}

#xvsfzcfrhj .gt_font_italic {
  font-style: italic;
}

#xvsfzcfrhj .gt_super {
  font-size: 65%;
}

#xvsfzcfrhj .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 65%;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="2" colspan="1">Outcome</th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">Boosted</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">Unboosted</span>
      </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="2" colspan="1">Incidence rate ratio (95% CI)</th>
    </tr>
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">Events / person-years</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">Incidence rate</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">Events / person-years</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">Incidence rate</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr class="gt_group_heading_row">
      <td colspan="6" class="gt_group_heading">3,998,664 eligible, 3,426,960 matched (85.7%).</td>
    </tr>
    <tr><td class="gt_row gt_right">Positive SARS-CoV-2 test</td>
<td class="gt_row gt_right">17,089 /198,731</td>
<td class="gt_row gt_right">0.086</td>
<td class="gt_row gt_right">32,795 /171,492</td>
<td class="gt_row gt_right">0.191</td>
<td class="gt_row gt_right">0.45 (0.44-0.46)</td></tr>
    <tr><td class="gt_row gt_right">COVID-19 hospitalisation</td>
<td class="gt_row gt_right">454 /199,457</td>
<td class="gt_row gt_right">0.002</td>
<td class="gt_row gt_right">1,929 /173,359</td>
<td class="gt_row gt_right">0.011</td>
<td class="gt_row gt_right">0.20 (0.18-0.23)</td></tr>
    <tr><td class="gt_row gt_right">COVID-19 death</td>
<td class="gt_row gt_right">54 /199,477</td>
<td class="gt_row gt_right">&lt;0.001</td>
<td class="gt_row gt_right">400 /173,489</td>
<td class="gt_row gt_right">0.002</td>
<td class="gt_row gt_right">0.12 (0.09-0.16)</td></tr>
  </tbody>
  
  
</table>
</div>
```

## Estimated booster effectiveness

### Main analysis

Participants in the emulated trial experienced 49,884 documented infections, 2,383 COVID-19 hospital admissions, and 454 COVID-19 deaths across 372,967 person-years of follow-up (Table 2).


The estimated effectiveness (95% CI) comparing a BNT162b2 booster dose to two doses only over all follow-up time was 58.8% (58.0-59.5) for documented infection, 79.5% (77.3-81.5) for COVID-19 hospital admission, and 89.3% (85.7-92.0) for COVID-19 death. Effectiveness before and after 28 days since boosting is also estimated (Figure 2, Table 3), as well as for narrower periods (Supplementary Table S3).


<!-- In the first 28 days of follow-up the estimated effectiveness (95% CI) comparing a BNT162b2 booster dose to two doses only, was 52.5% (51.5-53.5) for documented infection, 75.4% (72.4-78.1) for COVID-19 hospital admission, and 82.9% (75.7-88.0) for COVID-19 death (Figure 2). -->

<!-- For days 28-70, estimated effectiveness (95% CI) comparing a BNT162b2 booster dose to two doses only, was 73.5% (72.2-74.7) for documented infection, 87.1% (83.7-89.7) for COVID-19 hospital admission, and 94.1% (90.2-96.4) for COVID-19 death (Figure 2), suggesting a potential waning of booster effectiveness with time. -->



### Subgroup analyses

The estimated effectiveness (95% CI) for 2× BNT162b2 and 2× ChAdOx1-S primary course recipients respectively were 57.7% (56.4-59.0) and 59.4% (58.4-60.4) for documented infection, 77.5% (73.7-80.8) and 80.8% (78.0-83.3) for COVID-19 hospital admission, and 91.0% (85.7-94.3) and 87.8% (82.3-91.7) for COVID-19 death (Figure 2). 


Period-specific estimates are also provided.

\newpage

#### Figure 2: Estimated booster effectiveness

For each outcome based on the fully adjusted model, the hazard ratios for boosting with BNT162b2 versus not boosting is shown, stratified by primary course and time since boosting. Models with less extensive confounder adjustment are provided in supplementary materials (Figure S3).

<img src="C:/Users/whulme/Documents/repos/booster-effectiveness/manuscript/figures/plot_effects-1.png" width="90%"  />

\newpage


## Table 3: Estimated booster effectiveness

Main and subgroup analyses

```{=html}
<div id="lsbevpwzst" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#lsbevpwzst .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#lsbevpwzst .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#lsbevpwzst .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#lsbevpwzst .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#lsbevpwzst .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#lsbevpwzst .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#lsbevpwzst .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#lsbevpwzst .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#lsbevpwzst .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#lsbevpwzst .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#lsbevpwzst .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#lsbevpwzst .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#lsbevpwzst .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#lsbevpwzst .gt_from_md > :first-child {
  margin-top: 0;
}

#lsbevpwzst .gt_from_md > :last-child {
  margin-bottom: 0;
}

#lsbevpwzst .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#lsbevpwzst .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#lsbevpwzst .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#lsbevpwzst .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#lsbevpwzst .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#lsbevpwzst .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#lsbevpwzst .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#lsbevpwzst .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#lsbevpwzst .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#lsbevpwzst .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#lsbevpwzst .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#lsbevpwzst .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#lsbevpwzst .gt_left {
  text-align: left;
}

#lsbevpwzst .gt_center {
  text-align: center;
}

#lsbevpwzst .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#lsbevpwzst .gt_font_normal {
  font-weight: normal;
}

#lsbevpwzst .gt_font_bold {
  font-weight: bold;
}

#lsbevpwzst .gt_font_italic {
  font-style: italic;
}

#lsbevpwzst .gt_super {
  font-size: 65%;
}

#lsbevpwzst .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 65%;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1"></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">Days since booster</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">HR (95% CI)</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">VE (95% CI)</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr class="gt_group_heading_row">
      <td colspan="4" class="gt_group_heading">Positive SARS-CoV-2 test</td>
    </tr>
    <tr><td class="gt_row gt_right">All</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.47 (0.46-0.48)</td>
<td class="gt_row gt_right">52.5 (51.5-53.5)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.27 (0.25-0.28)</td>
<td class="gt_row gt_right">73.5 (72.2-74.7)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.41 (0.40-0.42)</td>
<td class="gt_row gt_right">58.8 (58.0-59.5)</td></tr>
    <tr><td class="gt_row gt_right">BNT162b2-BNT162b2</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.48 (0.47-0.50)</td>
<td class="gt_row gt_right">51.5 (49.8-53.2)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.31 (0.30-0.33)</td>
<td class="gt_row gt_right">68.6 (66.6-70.5)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.42 (0.41-0.44)</td>
<td class="gt_row gt_right">57.7 (56.4-59.0)</td></tr>
    <tr><td class="gt_row gt_right">ChAdOx1-ChAdOx1</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.47 (0.46-0.48)</td>
<td class="gt_row gt_right">53.1 (51.9-54.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.22 (0.20-0.23)</td>
<td class="gt_row gt_right">78.3 (76.7-79.8)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.41 (0.40-0.42)</td>
<td class="gt_row gt_right">59.4 (58.4-60.4)</td></tr>
    <tr><td class="gt_row gt_right">Not Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.47 (0.46-0.48)</td>
<td class="gt_row gt_right">53.3 (52.2-54.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.27 (0.25-0.28)</td>
<td class="gt_row gt_right">73.5 (72.1-74.8)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.41 (0.40-0.42)</td>
<td class="gt_row gt_right">59.2 (58.4-60.1)</td></tr>
    <tr><td class="gt_row gt_right">Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.53 (0.50-0.55)</td>
<td class="gt_row gt_right">47.5 (44.5-50.2)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.27 (0.24-0.30)</td>
<td class="gt_row gt_right">72.9 (69.9-75.6)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.44 (0.42-0.46)</td>
<td class="gt_row gt_right">55.9 (53.7-58.0)</td></tr>
    <tr><td class="gt_row gt_right">Aged 18-64</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.48 (0.46-0.49)</td>
<td class="gt_row gt_right">52.5 (51.3-53.6)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.31 (0.30-0.33)</td>
<td class="gt_row gt_right">68.7 (67.0-70.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.43 (0.42-0.44)</td>
<td class="gt_row gt_right">57.4 (56.5-58.4)</td></tr>
    <tr><td class="gt_row gt_right">Aged 65 and over</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.50 (0.48-0.52)</td>
<td class="gt_row gt_right">50.0 (48.1-51.8)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.21 (0.19-0.23)</td>
<td class="gt_row gt_right">78.7 (76.6-80.6)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.42 (0.40-0.43)</td>
<td class="gt_row gt_right">58.2 (56.7-59.6)</td></tr>
    <tr class="gt_group_heading_row">
      <td colspan="4" class="gt_group_heading">COVID-19 hospitalisation</td>
    </tr>
    <tr><td class="gt_row gt_right">All</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.25 (0.22-0.28)</td>
<td class="gt_row gt_right">75.4 (72.4-78.1)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.13 (0.10-0.16)</td>
<td class="gt_row gt_right">87.1 (83.7-89.7)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.20 (0.18-0.23)</td>
<td class="gt_row gt_right">79.5 (77.3-81.5)</td></tr>
    <tr><td class="gt_row gt_right">BNT162b2-BNT162b2</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.28 (0.23-0.33)</td>
<td class="gt_row gt_right">72.3 (66.8-76.9)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.14 (0.10-0.19)</td>
<td class="gt_row gt_right">86.4 (81.2-90.2)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.22 (0.19-0.26)</td>
<td class="gt_row gt_right">77.5 (73.7-80.8)</td></tr>
    <tr><td class="gt_row gt_right">ChAdOx1-ChAdOx1</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.23 (0.20-0.27)</td>
<td class="gt_row gt_right">77.2 (73.4-80.4)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.13 (0.09-0.18)</td>
<td class="gt_row gt_right">87.4 (82.5-90.9)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.19 (0.17-0.22)</td>
<td class="gt_row gt_right">80.8 (78.0-83.3)</td></tr>
    <tr><td class="gt_row gt_right">Not Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.22 (0.18-0.26)</td>
<td class="gt_row gt_right">78.4 (74.5-81.7)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.09 (0.06-0.13)</td>
<td class="gt_row gt_right">91.1 (87.0-93.9)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.17 (0.14-0.20)</td>
<td class="gt_row gt_right">83.1 (80.4-85.5)</td></tr>
    <tr><td class="gt_row gt_right">Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.30 (0.25-0.35)</td>
<td class="gt_row gt_right">70.2 (64.9-74.6)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.17 (0.13-0.23)</td>
<td class="gt_row gt_right">82.5 (76.6-87.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.25 (0.22-0.29)</td>
<td class="gt_row gt_right">74.6 (70.7-78.0)</td></tr>
    <tr><td class="gt_row gt_right">Aged 18-64</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.29 (0.23-0.36)</td>
<td class="gt_row gt_right">71.5 (63.9-77.5)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.28 (0.18-0.44)</td>
<td class="gt_row gt_right">71.8 (56.0-82.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.27 (0.22-0.33)</td>
<td class="gt_row gt_right">72.9 (66.7-78.0)</td></tr>
    <tr><td class="gt_row gt_right">Aged 65 and over</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.24 (0.21-0.27)</td>
<td class="gt_row gt_right">76.4 (73.1-79.4)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.10 (0.08-0.14)</td>
<td class="gt_row gt_right">89.7 (86.4-92.2)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.19 (0.17-0.21)</td>
<td class="gt_row gt_right">81.3 (78.9-83.4)</td></tr>
    <tr class="gt_group_heading_row">
      <td colspan="4" class="gt_group_heading">COVID-19 death</td>
    </tr>
    <tr><td class="gt_row gt_right">All</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.17 (0.12-0.24)</td>
<td class="gt_row gt_right">82.9 (75.7-88.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.06 (0.04-0.10)</td>
<td class="gt_row gt_right">94.1 (90.2-96.4)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.11 (0.08-0.14)</td>
<td class="gt_row gt_right">89.3 (85.7-92.0)</td></tr>
    <tr><td class="gt_row gt_right">BNT162b2-BNT162b2</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.00 (0.00-0.00)</td>
<td class="gt_row gt_right">99.9 (99.9-100.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.07 (0.04-0.13)</td>
<td class="gt_row gt_right">93.1 (86.7-96.4)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.09 (0.06-0.14)</td>
<td class="gt_row gt_right">91.0 (85.7-94.3)</td></tr>
    <tr><td class="gt_row gt_right">ChAdOx1-ChAdOx1</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.20 (0.13-0.31)</td>
<td class="gt_row gt_right">79.8 (68.8-86.9)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.05 (0.02-0.11)</td>
<td class="gt_row gt_right">94.9 (88.8-97.6)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.12 (0.08-0.18)</td>
<td class="gt_row gt_right">87.8 (82.3-91.7)</td></tr>
    <tr><td class="gt_row gt_right">Not Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.00 (0.00-0.00)</td>
<td class="gt_row gt_right">100.0 (100.0-100.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.00 (0.00-0.00)</td>
<td class="gt_row gt_right">100.0 (100.0-100.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.07 (0.04-0.11)</td>
<td class="gt_row gt_right">93.4 (88.8-96.1)</td></tr>
    <tr><td class="gt_row gt_right">Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.21 (0.13-0.34)</td>
<td class="gt_row gt_right">78.8 (66.5-86.6)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.11 (0.06-0.19)</td>
<td class="gt_row gt_right">88.8 (80.6-93.5)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.14 (0.10-0.20)</td>
<td class="gt_row gt_right">85.7 (79.7-89.9)</td></tr>
    <tr><td class="gt_row gt_right">Aged 18-64</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.26 (0.10-0.65)</td>
<td class="gt_row gt_right">74.0 (34.9-89.6)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.21 (0.07-0.68)</td>
<td class="gt_row gt_right">79.0 (32.4-93.5)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.23 (0.11-0.46)</td>
<td class="gt_row gt_right">76.9 (53.5-88.5)</td></tr>
    <tr><td class="gt_row gt_right">Aged 65 and over</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.16 (0.11-0.23)</td>
<td class="gt_row gt_right">84.1 (76.7-89.2)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.05 (0.03-0.08)</td>
<td class="gt_row gt_right">95.2 (91.6-97.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.09 (0.07-0.13)</td>
<td class="gt_row gt_right">90.6 (87.1-93.2)</td></tr>
    <tr class="gt_group_heading_row">
      <td colspan="4" class="gt_group_heading">Non-COVID-19 death</td>
    </tr>
    <tr><td class="gt_row gt_right">All</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.18 (0.16-0.19)</td>
<td class="gt_row gt_right">82.2 (80.8-83.6)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.17 (0.15-0.19)</td>
<td class="gt_row gt_right">83.2 (81.4-84.8)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.17 (0.16-0.18)</td>
<td class="gt_row gt_right">83.5 (82.4-84.5)</td></tr>
    <tr><td class="gt_row gt_right">BNT162b2-BNT162b2</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.15 (0.14-0.17)</td>
<td class="gt_row gt_right">84.6 (82.6-86.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.15 (0.13-0.18)</td>
<td class="gt_row gt_right">84.8 (82.4-86.9)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.14 (0.13-0.16)</td>
<td class="gt_row gt_right">85.7 (84.3-87.0)</td></tr>
    <tr><td class="gt_row gt_right">ChAdOx1-ChAdOx1</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.20 (0.18-0.23)</td>
<td class="gt_row gt_right">79.7 (77.3-81.7)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.19 (0.16-0.22)</td>
<td class="gt_row gt_right">81.0 (78.0-83.7)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.19 (0.18-0.21)</td>
<td class="gt_row gt_right">80.8 (79.1-82.4)</td></tr>
    <tr><td class="gt_row gt_right">Not Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.18 (0.16-0.20)</td>
<td class="gt_row gt_right">82.1 (80.1-84.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.15 (0.13-0.18)</td>
<td class="gt_row gt_right">84.7 (82.3-86.8)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.16 (0.15-0.18)</td>
<td class="gt_row gt_right">83.7 (82.3-85.1)</td></tr>
    <tr><td class="gt_row gt_right">Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.18 (0.16-0.20)</td>
<td class="gt_row gt_right">81.9 (79.7-84.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.19 (0.16-0.22)</td>
<td class="gt_row gt_right">81.4 (78.5-83.9)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.17 (0.16-0.19)</td>
<td class="gt_row gt_right">83.0 (81.3-84.4)</td></tr>
    <tr><td class="gt_row gt_right">Aged 18-64</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.24 (0.20-0.30)</td>
<td class="gt_row gt_right">75.8 (70.0-80.5)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.28 (0.20-0.40)</td>
<td class="gt_row gt_right">71.5 (59.8-79.8)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.24 (0.20-0.29)</td>
<td class="gt_row gt_right">76.2 (71.4-80.1)</td></tr>
    <tr><td class="gt_row gt_right">Aged 65 and over</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.17 (0.15-0.18)</td>
<td class="gt_row gt_right">83.3 (81.8-84.7)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.16 (0.14-0.18)</td>
<td class="gt_row gt_right">84.1 (82.3-85.8)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">1 - 70</td>
<td class="gt_row gt_right">0.16 (0.15-0.17)</td>
<td class="gt_row gt_right">84.4 (83.3-85.4)</td></tr>
  </tbody>
  
  
</table>
</div>
```

\newpage



# Discussion

This observational study investigated the effectiveness of a BNT162b2 booster dose in 3,426,960 adults, and their matched controls, in England in the Delta era. We found high protection against all studied outcomes. Protection was similar between 2× BNT162b2 primary course recipients and 2× ChAdOx1-S recipients. There were apparent waning effects around 6 weeks after boosting, which is unlikely to be explained by increased transmissibility of the Omicron variant given Omicron was not yet dominant in the UK by the end of the follow-up window @COVID19OmicronDaily, though changing testing behaviours over time between boosted and unboosted people may influence estimates. 

We have considered effectiveness in a population where Delta was the predominant circulating variant @COVID19OmicronDaily. Re-running the analysis against a backdrop of the now globally-dominant Omicron variant will be undertaken where valid concurrent comparisons between boosted and unboosted people can be made. Further, mRNA-1273 boosting begun later than for BNT162b2 so we did not evaluate effectiveness of this vaccine due to insufficient follow-up. An analysis of mRNA-1273 boosting and comparative effectiveness between mRNA-1273 and BNT162b2 is planned. 

### Strengths and Limitations

We used routinely-collected health records with comprehensive coverage of primary care, hospital admissions, COVID-19 testing and vaccination, and death registrations. This provides substantial power to estimate effectiveness of booster doses against severe but rare outcomes such as hospitalisation and death, including period-specific effects to investigate waning protection.

We carefully matched booster recipients with unboosted controls using characteristics known at baseline to strengthen exchangeability between treatment groups and reduce dependence on modelling assumptions in the estimates of effectiveness. However, despite reasonable balance of important baseline characteristics and additional adjustment for a range of potential confounders, the possibility of unmeasured confounding remains. In particular, the apparent protective effect immediately after boosting is biologically implausible, and will be explained in part by the occurrence of COVID-19 symptoms at baseline that were not recorded in the health record, and so could not be identified and excluded.

The matching approach robust but inefficient; a minority of boosted individuals are not retained after matching, and those who are retained are censored when their matched control is boosted, reducing the follow-up duration and therefore statistical power. Millions of eligible participants may be required to obtain precise estimates, particularly when event rates are low, and so extending the approach to smaller subgroups may not be feasible. For instance, due to small numbers, we did not study booster effectiveness in those who had received the mRNA-1273 vaccine as their primary course or those who had received a heterologous primary course, despite many thousands of such recipients in England.

Documented SARS-CoV-2 infection data likely underestimates the true incidence of infection. The mass availability of lateral flow tests in the UK during the study period, whose results are not routinely recorded in COVID-19 surveillance data, means many infections, including symptomatic infections, may be undocumented, despite encouragement to seek a confirmatory PCR test. Potential differences in testing behaviour between boosted and unboosted people also contributes to the unreliability of testing data as a means to assess effectiveness. SARS-CoV-2 testing was not widely available early in the pandemic so evidence of prior infection is likely to be under-ascertained. We may not have all records of negative tests so counts of number of tests are also incomplete. Hospital admission records are only completed after discharge, so some very long hospital stays commencing within the follow-up period may not have been included.

We excluded a number of groups, such as health care workers and care home residents, where testing, vaccination, and infection risk characteristics were unusual or had substantial within-group heterogeneity that could not be adequately accounted for. The generalisability of our results to these excluded groups is unclear. 

### Findings in context

<!-- [ cov-boost trial] -->

A phase III trial assessing BNT162b2 booster efficacy in two-dose BNT162b2 recipients without prior infection reported a relative efficacy of 95.6% (95% CI 89.3-98.6) against Delta infection @PfizerBioNTechAnnounce2021.

Recent studies in the UK have provided observational evidence for increased protection from the booster vaccine against symptomatic COVID-19 infection in comparison to second dose recipients using a test negative design. Andrews et al. reported estimates of relative vaccine effectiveness against syptomatic disease in the 14 days after a BNT162b2 booster dose in those aged over 50 years of 87.4% (95%CI 84.9-89.4) where the primary course was ChAdOx1-S and 84.4% (95%CI 82.8-85.8) for BNT162b2 @andrews2021. Sheikh et al. reported comparable estimates of relative vaccine effectiveness for S gene positive symptomatic infection (83% (95%CI 81-84) 6-49 years, 88% (95%CI 86-89) ≥50 years) in the 14 days after a BNT162b2 or mRNA-1273 booster dose, but lower estimates for S gene negative symptomatic infection (56% (95%CI 51-60) 6-49 years, 57% (95%CI 52-62) ≥50 years).

<!-- @https://www.research.ed.ac.uk/en/publications/severity-of-omicron-variant-of-concern-and-vaccine-effectiveness- -->

Elsewhere, a study in Israeli health registry data @barda2021 found strong protection against admission (1 – risk ratio (95%CI) = 93% (88-97)), severe disease (92% (82-97)), and death (81% (59-97)), with similar results in specific demographic and clinical subgroups.  but did not consider differences @barda2021 

<!-- @1050236/technical-briefing-34-14-january-2022.pdf -->

### Conclusion

This study of over 8 million people in England found high protection for BNT162b2 boosting against COVID-19 hospitalisation and death during an 13 week period in which the Delta variant was dominant.

\newpage

## Acknowledgements

We are very grateful for all the support received from the TPP Technical Operations team throughout this work, and for generous assistance from the information governance and database teams at NHS England / NHSX.

## Conflicts of Interest

All authors have completed the ICMJE uniform disclosure form and declare the following: BG has received research funding from Health Data Research UK (HDRUK), the Laura and John Arnold Foundation, the Wellcome Trust, the NIHR Oxford Biomedical Research Centre, the NHS National Institute for Health Research School of Primary Care Research, the Mohn-Westlake Foundation, the Good Thinking Foundation, the Health Foundation, and the World Health Organisation; he also receives personal income from speaking and writing for lay audiences on the misuse of science. IJD holds shares in GlaxoSmithKline (GSK).

## Funding

This work was supported by the Medical Research Council MR/V015737/1 and the Longitudinal Health and wellbeing strand of the National Core Studies programme. The OpenSAFELY platform is funded by the Wellcome Trust. TPP provided technical expertise and infrastructure within their data centre pro bono in the context of a national emergency. BGs work on clinical informatics is supported by the NIHR Oxford Biomedical Research Centre and the NIHR Applied Research Collaboration Oxford and Thames Valley. BG's work on better use of data in healthcare more broadly is currently funded in part by: NIHR Oxford Biomedical Research Centre, NIHR Applied Research Collaboration Oxford and Thames Valley, the Mohn-Westlake Foundation, NHS England, and the Health Foundation; all DataLab staff are supported by BG's grants on this work. LS reports grants from Wellcome, MRC, NIHR, UKRI, British Council, GSK, British Heart Foundation, and Diabetes UK outside this work. KB holds a Wellcome Senior Research Fellowship (220283/Z/20/Z). HIM is funded by the NIHR Health Protection Research Unit in Immunisation, a partnership between Public Health England and London School of Hygiene & Tropical Medicine. AYSW holds a fellowship from the British Heart Foundation. EJW holds grants from MRC. RM holds a Sir Henry Wellcome Fellowship funded by the Wellcome Trust (201375/Z/16/Z). HF holds a UKRI fellowship. IJD holds grants from NIHR and GSK.

Funders had no role in the study design, collection, analysis, and interpretation of data; in the writing of the report and in the decision to submit the article for publication.

The views expressed are those of the authors and not necessarily those of the NIHR, NHS England, Public Health England or the Department of Health and Social Care.

For the purpose of Open Access, the author has applied a CC BY public copyright licence to any Author Accepted Manuscript (AAM) version arising from this submission.

## Information governance and ethical approval

NHS England is the data controller; TPP is the data processor; and the key researchers on OpenSAFELY are acting with the approval of NHS England. This implementation of OpenSAFELY is hosted within the TPP environment which is accredited to the ISO 27001 information security standard and is NHS IG Toolkit compliant @betad @datasec ; Patient data has been pseudonymised for analysis and linkage using industry standard cryptographic hashing techniques; all pseudonymised datasets transmitted for linkage onto OpenSAFELY are encrypted; access to the platform is via a virtual private network (VPN) connection, restricted to a small group of researchers; the researchers hold contracts with NHS England and only access the platform to initiate database queries and statistical models; all database activity is logged; only aggregate statistical outputs leave the platform environment following best practice for anonymisation of results such as statistical disclosure control for low cell counts @isb1523 . The OpenSAFELY research platform adheres to the obligations of the UK General Data Protection Regulation (GDPR) and the Data Protection Act 2018. In March 2020, the Secretary of State for Health and Social Care used powers under the UK Health Service (Control of Patient Information) Regulations 2002 (COPI) to require organisations to process confidential patient information for the purposes of protecting public health, providing healthcare services to the public and monitoring and managing the COVID-19 outbreak and incidents of exposure; this sets aside the requirement for patient consent @coronavi2020 . Taken together, these provide the legal bases to link patient datasets on the OpenSAFELY platform. General Practices, from which the primary care data are obtained, are required to share relevant health information to support the public health response to the pandemic, and have been informed of the OpenSAFELY analytics platform.

This study was approved by the Health Research Authority (REC reference 20/LO/0651) and by the LSHTM Ethics Board (reference 21863).

BG is guarantor.

\newpage

## References
