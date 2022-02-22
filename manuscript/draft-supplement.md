---
title: "Effectiveness of COVID-19 Booster doses in England: a sequential trials study in OpenSAFELY: Supplementary materials"
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
header-includes:
- \usepackage{float} 
- \floatplacement{figure}{H}
bibliography: references.bib
---





\newpage


# Matching details

Booster eligibility was dependent on vaccine priority group, largely determined by clinical vulnerability and age. Booster doses were initially available 6 months after administration of the second dose, later reduced to 3 months following concerns over the surge in cases and the emergence of the seemingly more transmissible Omicron variant. Determining vaccine eligibility for a given person on a given day is therefore complex. To avoid these complexities, we determined trial eligibility for each person on each day of recruitment by ensuring that there were sufficiently many people with similar characteristics who were being vaccinated on that day. Specifically, a rolling weekly average was calculated within strata defined by region, priority group, and week of second vaccine dose. If fewer than 50 people had been vaccinated within each strata on each day, then that strata was not eligible for recruitment on that day.

The Joint Committee on Vaccine and Immunisation (JCVI) priority groups were defined as follows:



```{=html}
<div id="psgkapgreb" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#psgkapgreb .gt_table {
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

#psgkapgreb .gt_heading {
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

#psgkapgreb .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#psgkapgreb .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#psgkapgreb .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#psgkapgreb .gt_col_headings {
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

#psgkapgreb .gt_col_heading {
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

#psgkapgreb .gt_column_spanner_outer {
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

#psgkapgreb .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#psgkapgreb .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#psgkapgreb .gt_column_spanner {
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

#psgkapgreb .gt_group_heading {
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

#psgkapgreb .gt_empty_group_heading {
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

#psgkapgreb .gt_from_md > :first-child {
  margin-top: 0;
}

#psgkapgreb .gt_from_md > :last-child {
  margin-bottom: 0;
}

#psgkapgreb .gt_row {
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

#psgkapgreb .gt_stub {
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

#psgkapgreb .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#psgkapgreb .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#psgkapgreb .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#psgkapgreb .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#psgkapgreb .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#psgkapgreb .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#psgkapgreb .gt_footnotes {
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

#psgkapgreb .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#psgkapgreb .gt_sourcenotes {
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

#psgkapgreb .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#psgkapgreb .gt_left {
  text-align: left;
}

#psgkapgreb .gt_center {
  text-align: center;
}

#psgkapgreb .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#psgkapgreb .gt_font_normal {
  font-weight: normal;
}

#psgkapgreb .gt_font_bold {
  font-weight: bold;
}

#psgkapgreb .gt_font_italic {
  font-style: italic;
}

#psgkapgreb .gt_super {
  font-size: 65%;
}

#psgkapgreb .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 65%;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Priority group</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Description</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>1</p>
</div></td>
<td class="gt_row gt_left"><div class='gt_from_md'><p>Residents in a care home for older adults<br>Staff working in care homes for older adults</p>
</div></td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>2</p>
</div></td>
<td class="gt_row gt_left"><div class='gt_from_md'><p>All those 80 years of age and over<br>Frontline health and social care workers</p>
</div></td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>3</p>
</div></td>
<td class="gt_row gt_left"><div class='gt_from_md'><p>All those 75-79 years of age</p>
</div></td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>4</p>
</div></td>
<td class="gt_row gt_left"><div class='gt_from_md'><p>All those 70-74 years of age<br>Individuals aged 16-69 in a high risk group</p>
</div></td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>5</p>
</div></td>
<td class="gt_row gt_left"><div class='gt_from_md'><p>All those 65-69 years of age</p>
</div></td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>6</p>
</div></td>
<td class="gt_row gt_left"><div class='gt_from_md'><p>Adults aged 16-64 years in an at-risk group</p>
</div></td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>7</p>
</div></td>
<td class="gt_row gt_left"><div class='gt_from_md'><p>All those 60-64 years of age</p>
</div></td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>8</p>
</div></td>
<td class="gt_row gt_left"><div class='gt_from_md'><p>All those 55-59 years of age</p>
</div></td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>9</p>
</div></td>
<td class="gt_row gt_left"><div class='gt_from_md'><p>All those 50-54 years of age</p>
</div></td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>10a</p>
</div></td>
<td class="gt_row gt_left"><div class='gt_from_md'><p>All those 40-49 years of age</p>
</div></td></tr>
    <tr><td class="gt_row gt_left"><div class='gt_from_md'><p>10b</p>
</div></td>
<td class="gt_row gt_left"><div class='gt_from_md'><p>All those 18-39 years of age</p>
</div></td></tr>
  </tbody>
  
  
</table>
</div>
```

See original priority groups here: https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1007737/Greenbook_chapter_14a_30July2021.pdf#page=15
See revised priority groups here: https://www.england.nhs.uk/coronavirus/wp-content/uploads/sites/52/2021/07/C1327-covid-19-vaccination-autumn-winter-phase-3-planning.pdf

Note that we excluded care home residents and health care workers in our analysis, so group 1 is not included and group 2 includes only those aged 80 and over. The original priority group list has 9 groups, with a 10th group implicitly defined as "everybody else". Here we explicitly define this group, and split into two (10a and 10b) because of the earlier booster eligiblity in the 40-49 group from 15 November 2021 onwards. (https://www.gov.uk/government/news/jcvi-issues-advice-on-covid-19-booster-vaccines-for-those-aged-40-to-49-and-second-doses-for-16-to-17-year-olds)


### Table S1: Inclusion criteria


```{=html}
<div id="uglrkfofny" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#uglrkfofny .gt_table {
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

#uglrkfofny .gt_heading {
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

#uglrkfofny .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#uglrkfofny .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#uglrkfofny .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#uglrkfofny .gt_col_headings {
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

#uglrkfofny .gt_col_heading {
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

#uglrkfofny .gt_column_spanner_outer {
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

#uglrkfofny .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#uglrkfofny .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#uglrkfofny .gt_column_spanner {
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

#uglrkfofny .gt_group_heading {
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

#uglrkfofny .gt_empty_group_heading {
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

#uglrkfofny .gt_from_md > :first-child {
  margin-top: 0;
}

#uglrkfofny .gt_from_md > :last-child {
  margin-bottom: 0;
}

#uglrkfofny .gt_row {
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

#uglrkfofny .gt_stub {
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

#uglrkfofny .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#uglrkfofny .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#uglrkfofny .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#uglrkfofny .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#uglrkfofny .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#uglrkfofny .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#uglrkfofny .gt_footnotes {
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

#uglrkfofny .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#uglrkfofny .gt_sourcenotes {
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

#uglrkfofny .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#uglrkfofny .gt_left {
  text-align: left;
}

#uglrkfofny .gt_center {
  text-align: center;
}

#uglrkfofny .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#uglrkfofny .gt_font_normal {
  font-weight: normal;
}

#uglrkfofny .gt_font_bold {
  font-weight: bold;
}

#uglrkfofny .gt_font_italic {
  font-style: italic;
}

#uglrkfofny .gt_super {
  font-size: 65%;
}

#uglrkfofny .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 65%;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1"></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1"></th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="3">
        <span class="gt_column_spanner">BNT162b2</span>
      </th>
    </tr>
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">N</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">N excluded</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">% remaining</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td class="gt_row gt_left">Boosted</td>
<td class="gt_row gt_left" style="white-space: pre-wrap;">Aged 18+ and recieved booster dose
between 16 September and 1 December 2021
inclusive</td>
<td class="gt_row gt_right">2,482</td>
<td class="gt_row gt_right">-</td>
<td class="gt_row gt_right">100.0&percnt;</td></tr>
    <tr><td class="gt_row gt_left">-</td>
<td class="gt_row gt_left" style="white-space: pre-wrap;">with no missing demographic information</td>
<td class="gt_row gt_right">2,371</td>
<td class="gt_row gt_right">111</td>
<td class="gt_row gt_right">95.5&percnt;</td></tr>
    <tr><td class="gt_row gt_left">-</td>
<td class="gt_row gt_left" style="white-space: pre-wrap;">with homologous primary vaccination
course of BNT162b2 or ChAdOx1-S</td>
<td class="gt_row gt_right">2,163</td>
<td class="gt_row gt_right">208</td>
<td class="gt_row gt_right">87.1&percnt;</td></tr>
    <tr><td class="gt_row gt_left">-</td>
<td class="gt_row gt_left" style="white-space: pre-wrap;">and not a HSC worker</td>
<td class="gt_row gt_right">2,137</td>
<td class="gt_row gt_right">26</td>
<td class="gt_row gt_right">86.1&percnt;</td></tr>
    <tr><td class="gt_row gt_left">Eligible (people)</td>
<td class="gt_row gt_left" style="white-space: pre-wrap;">and not a care/nursing home resident,
end-of-life or housebound</td>
<td class="gt_row gt_right">2,049</td>
<td class="gt_row gt_right">88</td>
<td class="gt_row gt_right">82.6&percnt;</td></tr>
    <tr><td class="gt_row gt_left">-</td>
<td class="gt_row gt_left" style="white-space: pre-wrap;">and no evidence of SARS-CoV-2 infection
within 90 days of boosting</td>
<td class="gt_row gt_right">1,528</td>
<td class="gt_row gt_right">521</td>
<td class="gt_row gt_right">61.6&percnt;</td></tr>
    <tr><td class="gt_row gt_left">-</td>
<td class="gt_row gt_left" style="white-space: pre-wrap;">and not in hospital when boosted</td>
<td class="gt_row gt_right">1,471</td>
<td class="gt_row gt_right">57</td>
<td class="gt_row gt_right">59.3&percnt;</td></tr>
    <tr><td class="gt_row gt_left">Eligible (context)</td>
<td class="gt_row gt_left" style="white-space: pre-wrap;">and not boosted at an unusual time given
region, priority group, and second dose
date</td>
<td class="gt_row gt_right">1,011</td>
<td class="gt_row gt_right">460</td>
<td class="gt_row gt_right">40.7&percnt;</td></tr>
    <tr><td class="gt_row gt_left">Matched</td>
<td class="gt_row gt_left" style="white-space: pre-wrap;">and successfully matched to an unboosted
control</td>
<td class="gt_row gt_right">701</td>
<td class="gt_row gt_right">310</td>
<td class="gt_row gt_right">28.2&percnt;</td></tr>
    <tr><td class="gt_row gt_left">-</td>
<td class="gt_row gt_left" style="white-space: pre-wrap;">and also selected as a control in an
earlier trial</td>
<td class="gt_row gt_right">67</td>
<td class="gt_row gt_right">634</td>
<td class="gt_row gt_right">2.7&percnt;</td></tr>
  </tbody>
  
  
</table>
</div>
```



\newpage

<img src="C:/Users/whulme/Documents/repos/booster-effectiveness/manuscript/figures/plot_effects-1.png" width="90%"  />


\newpage
