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
<div id="zszuhojxmr" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#zszuhojxmr .gt_table {
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

#zszuhojxmr .gt_heading {
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

#zszuhojxmr .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#zszuhojxmr .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#zszuhojxmr .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#zszuhojxmr .gt_col_headings {
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

#zszuhojxmr .gt_col_heading {
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

#zszuhojxmr .gt_column_spanner_outer {
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

#zszuhojxmr .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#zszuhojxmr .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#zszuhojxmr .gt_column_spanner {
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

#zszuhojxmr .gt_group_heading {
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

#zszuhojxmr .gt_empty_group_heading {
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

#zszuhojxmr .gt_from_md > :first-child {
  margin-top: 0;
}

#zszuhojxmr .gt_from_md > :last-child {
  margin-bottom: 0;
}

#zszuhojxmr .gt_row {
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

#zszuhojxmr .gt_stub {
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

#zszuhojxmr .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#zszuhojxmr .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#zszuhojxmr .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#zszuhojxmr .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#zszuhojxmr .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#zszuhojxmr .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#zszuhojxmr .gt_footnotes {
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

#zszuhojxmr .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#zszuhojxmr .gt_sourcenotes {
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

#zszuhojxmr .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#zszuhojxmr .gt_left {
  text-align: left;
}

#zszuhojxmr .gt_center {
  text-align: center;
}

#zszuhojxmr .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#zszuhojxmr .gt_font_normal {
  font-weight: normal;
}

#zszuhojxmr .gt_font_bold {
  font-weight: bold;
}

#zszuhojxmr .gt_font_italic {
  font-style: italic;
}

#zszuhojxmr .gt_super {
  font-size: 65%;
}

#zszuhojxmr .gt_footnote_marks {
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

Note that we excluded care home residents and health care workers in our analysis, so members of JCVI group 1 are not included and JCVI group 2 includes only those aged 80 and over. The original priority group list has 9 groups, with a 10th group implicitly defined as "everybody else". Here we explicitly define this group, and split into two (10a and 10b) because of the earlier booster eligiblity in the 40-49 group from 15 November 2021 onwards. (https://www.gov.uk/government/news/jcvi-issues-advice-on-covid-19-booster-vaccines-for-those-aged-40-to-49-and-second-doses-for-16-to-17-year-olds)


# Variables and codelists


```{=html}
<div id="zyqmzniezc" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#zyqmzniezc .gt_table {
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

#zyqmzniezc .gt_heading {
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

#zyqmzniezc .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#zyqmzniezc .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#zyqmzniezc .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#zyqmzniezc .gt_col_headings {
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

#zyqmzniezc .gt_col_heading {
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

#zyqmzniezc .gt_column_spanner_outer {
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

#zyqmzniezc .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#zyqmzniezc .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#zyqmzniezc .gt_column_spanner {
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

#zyqmzniezc .gt_group_heading {
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

#zyqmzniezc .gt_empty_group_heading {
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

#zyqmzniezc .gt_from_md > :first-child {
  margin-top: 0;
}

#zyqmzniezc .gt_from_md > :last-child {
  margin-bottom: 0;
}

#zyqmzniezc .gt_row {
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

#zyqmzniezc .gt_stub {
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

#zyqmzniezc .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#zyqmzniezc .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#zyqmzniezc .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#zyqmzniezc .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#zyqmzniezc .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#zyqmzniezc .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#zyqmzniezc .gt_footnotes {
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

#zyqmzniezc .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#zyqmzniezc .gt_sourcenotes {
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

#zyqmzniezc .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#zyqmzniezc .gt_left {
  text-align: left;
}

#zyqmzniezc .gt_center {
  text-align: center;
}

#zyqmzniezc .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#zyqmzniezc .gt_font_normal {
  font-weight: normal;
}

#zyqmzniezc .gt_font_bold {
  font-weight: bold;
}

#zyqmzniezc .gt_font_italic {
  font-style: italic;
}

#zyqmzniezc .gt_super {
  font-size: 65%;
}

#zyqmzniezc .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 65%;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Variable</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Data source</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Notes</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Values </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Codelist identifier</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr class="gt_group_heading_row">
      <td colspan="5" class="gt_group_heading">Demographics</td>
    </tr>
    <tr><td class="gt_row gt_left">Sex</td>
<td class="gt_row gt_left">Primary care record</td>
<td class="gt_row gt_left"></td>
<td class="gt_row gt_left">Male; Female</td>
<td class="gt_row gt_left"></td></tr>
    <tr><td class="gt_row gt_left">Age</td>
<td class="gt_row gt_left">Primary care record</td>
<td class="gt_row gt_left"></td>
<td class="gt_row gt_left">&gt;=18</td>
<td class="gt_row gt_left"></td></tr>
    <tr><td class="gt_row gt_left">Ethnicity</td>
<td class="gt_row gt_left">Primary care record; SUS-APCS</td>
<td class="gt_row gt_left">Taken from primary care record where known, and supplemented by SUS-APCS data where unknown</td>
<td class="gt_row gt_left">Black; Mixed; South Asian; White; Other</td>
<td class="gt_row gt_left">opensafely/ethnicity/2020-04-27/</td></tr>
    <tr><td class="gt_row gt_left">NHS region</td>
<td class="gt_row gt_left">Primary care record</td>
<td class="gt_row gt_left"></td>
<td class="gt_row gt_left">East; London; Midlands; North East and Yorkshire; North West; South East; South West</td>
<td class="gt_row gt_left"></td></tr>
    <tr><td class="gt_row gt_left">English Index of Multiple Deprivation</td>
<td class="gt_row gt_left">Primary care record</td>
<td class="gt_row gt_left">Derived from Middle Layer Super Output Area (MSOA) of patient's address and using 2019 MSOA rankings</td>
<td class="gt_row gt_left">(grouped into 5 categories by IMD rank)</td>
<td class="gt_row gt_left"></td></tr>
    <tr><td class="gt_row gt_left">Care home residency</td>
<td class="gt_row gt_left">Primary care record; Care and Quality Commission care home address data</td>
<td class="gt_row gt_left">Patients were considered to be care-home residents if they met any one of three criteria used to identify care homes. These criteria are based on either patient address, household age and size, or coded clinical events. See https://wellcomeopenresearch.org/articles/6-90/v1 for more details on how these flags are derived.</td>
<td class="gt_row gt_left">0/1</td>
<td class="gt_row gt_left">primis-covid19-vacc-uptake/longres/v1
primis-covid19-vacc-uptake/carehome/v1
primis-covid19-vacc-uptake/nursehome/v1
primis-covid19-vacc-uptake/domcare/v1</td></tr>
    <tr><td class="gt_row gt_left">Health and social care worker status</td>
<td class="gt_row gt_left">NIMS</td>
<td class="gt_row gt_left">Vaccinees were asked if they were a health care worker or carer at the time of vaccination.</td>
<td class="gt_row gt_left">0/1</td>
<td class="gt_row gt_left"></td></tr>
    <tr><td class="gt_row gt_left"></td>
<td class="gt_row gt_left"></td>
<td class="gt_row gt_left"></td>
<td class="gt_row gt_left">0/1</td>
<td class="gt_row gt_left"></td></tr>
    <tr class="gt_group_heading_row">
      <td colspan="5" class="gt_group_heading">Clinical</td>
    </tr>
    <tr><td class="gt_row gt_left">Severe obesity</td>
<td class="gt_row gt_left">Primary care record</td>
<td class="gt_row gt_left">BMI &gt;= 40, based on most recent weight measurement, or clinically coded severe obesity</td>
<td class="gt_row gt_left">0/1</td>
<td class="gt_row gt_left">primis-covid19-vacc-uptake/sev_obesity/v1.2
primis-covid19-vacc-uptake/bmi_stage/v1.2
primis-covid19-vacc-uptake/bmi/v1</td></tr>
    <tr><td class="gt_row gt_left">Asthma</td>
<td class="gt_row gt_left">Primary care record</td>
<td class="gt_row gt_left">Based on PRIMIS specification</td>
<td class="gt_row gt_left">0/1</td>
<td class="gt_row gt_left">primis-covid19-vacc-uptake/ast/v1
primis-covid19-vacc-uptake/astadm/v1
primis-covid19-vacc-uptake/astrx/v1</td></tr>
    <tr><td class="gt_row gt_left">Chronic respiratory disease</td>
<td class="gt_row gt_left">Primary care record</td>
<td class="gt_row gt_left">Based on PRIMIS specification</td>
<td class="gt_row gt_left">0/1</td>
<td class="gt_row gt_left">primis-covid19-vacc-uptake/resp_cov/v1</td></tr>
    <tr><td class="gt_row gt_left">Chronic heart disease</td>
<td class="gt_row gt_left">Primary care record</td>
<td class="gt_row gt_left">Based on PRIMIS specification</td>
<td class="gt_row gt_left">0/1</td>
<td class="gt_row gt_left">primis-covid19-vacc-uptake/chd_cov/v1.2.1</td></tr>
    <tr><td class="gt_row gt_left">Chronic kidney disease</td>
<td class="gt_row gt_left">Primary care record</td>
<td class="gt_row gt_left">Based on PRIMIS specification</td>
<td class="gt_row gt_left">0/1</td>
<td class="gt_row gt_left">primis-covid19-vacc-uptake/ckd_cov/v1.2.1
primis-covid19-vacc-uptake/ckd15/v1
primis-covid19-vacc-uptake/ckd35/v1</td></tr>
    <tr><td class="gt_row gt_left">Chronic liver disease</td>
<td class="gt_row gt_left">Primary care record</td>
<td class="gt_row gt_left">Based on PRIMIS specification</td>
<td class="gt_row gt_left">0/1</td>
<td class="gt_row gt_left">primis-covid19-vacc-uptake/cld/v1</td></tr>
    <tr><td class="gt_row gt_left">Diabetes</td>
<td class="gt_row gt_left">Primary care record</td>
<td class="gt_row gt_left">Based on PRIMIS specification</td>
<td class="gt_row gt_left">0/1</td>
<td class="gt_row gt_left">primis-covid19-vacc-uptake/dmres/v1
primis-covid19-vacc-uptake/diab/v1</td></tr>
    <tr><td class="gt_row gt_left">Chronic neurological disease</td>
<td class="gt_row gt_left">Primary care record</td>
<td class="gt_row gt_left">Based on PRIMIS specification</td>
<td class="gt_row gt_left">0/1</td>
<td class="gt_row gt_left">primis-covid19-vacc-uptake/cns_cov/v1</td></tr>
    <tr><td class="gt_row gt_left">Immunosuppressed</td>
<td class="gt_row gt_left">Primary care record</td>
<td class="gt_row gt_left">Based on PRIMIS specification</td>
<td class="gt_row gt_left">0/1</td>
<td class="gt_row gt_left">primis-covid19-vacc-uptake/immdx_cov/v1
primis-covid19-vacc-uptake/immdx/v1</td></tr>
    <tr><td class="gt_row gt_left">Asplenia</td>
<td class="gt_row gt_left">Primary care record</td>
<td class="gt_row gt_left">Based on PRIMIS specification</td>
<td class="gt_row gt_left">0/1</td>
<td class="gt_row gt_left">primis-covid19-vacc-uptake/spln_cov/v1/</td></tr>
    <tr><td class="gt_row gt_left">Severe mental illness</td>
<td class="gt_row gt_left">Primary care record</td>
<td class="gt_row gt_left">Based on PRIMIS specification</td>
<td class="gt_row gt_left">0/1</td>
<td class="gt_row gt_left">primis-covid19-vacc-uptake/sev_mental/v1
primis-covid19-vacc-uptake/smhres/v1</td></tr>
    <tr><td class="gt_row gt_left">Learning disabilities</td>
<td class="gt_row gt_left">Primary care record</td>
<td class="gt_row gt_left">Based on PRIMIS specification</td>
<td class="gt_row gt_left">0/1</td>
<td class="gt_row gt_left">primis-covid19-vacc-uptake/learndis/v1</td></tr>
    <tr><td class="gt_row gt_left">End-of-life care</td>
<td class="gt_row gt_left">Primary care record</td>
<td class="gt_row gt_left">Based on codes indicating participation in end-of-life or palliative care pathways, or Midalozam prescriptions </td>
<td class="gt_row gt_left">0/1</td>
<td class="gt_row gt_left">nhsd-primary-care-domain-refsets/palcare_cod/5fce98cf
opensafely/midazolam-end-of-life/4c1b3c89</td></tr>
    <tr><td class="gt_row gt_left">Housebound</td>
<td class="gt_row gt_left">Primary care record</td>
<td class="gt_row gt_left"></td>
<td class="gt_row gt_left">0/1</td>
<td class="gt_row gt_left">opensafely/housebound/5bc77310
primis-covid19-vacc-uptake/carehome/v1
opensafely/no-longer-housebound/29a88ca6</td></tr>
    <tr><td class="gt_row gt_left">Clinically extremely vulnerable</td>
<td class="gt_row gt_left">Primary care record</td>
<td class="gt_row gt_left">Based on PRIMIS specification</td>
<td class="gt_row gt_left">0/1</td>
<td class="gt_row gt_left">primis-covid19-vacc-uptake/shield/v1
primis-covid19-vacc-uptake/nonshield/v1</td></tr>
    <tr><td class="gt_row gt_left">Clinically at-risk</td>
<td class="gt_row gt_left">Primary care record</td>
<td class="gt_row gt_left">immunosuppressed; asplenia; chronic heart disease; chronic kidney disease; chronic liver diease; diabetes; chronic respiratory disease; asthma; chronic neurological disease; learning disabilities; severe mental illness</td>
<td class="gt_row gt_left">0/1</td>
<td class="gt_row gt_left"></td></tr>
    <tr><td class="gt_row gt_left">Comorbidity count</td>
<td class="gt_row gt_left">Primary care record</td>
<td class="gt_row gt_left">Count of: severe obesity; chronic heart disease; chronic kidney disease; chronic liver diease; diabetes; chronic respiratory disease OR asthma; chronic neurological disease</td>
<td class="gt_row gt_left">&gt;=0</td>
<td class="gt_row gt_left"></td></tr>
    <tr><td class="gt_row gt_left">In-hospital status, planned</td>
<td class="gt_row gt_left">SUS-APCS</td>
<td class="gt_row gt_left">With admission method in ["11", "12", "13", "81"]</td>
<td class="gt_row gt_left">Date</td>
<td class="gt_row gt_left"></td></tr>
    <tr><td class="gt_row gt_left">In-hospital status, unplanned</td>
<td class="gt_row gt_left">SUS-APCS</td>
<td class="gt_row gt_left">With admission method in ["21", "22", "23", "24", "25", "2A", "2B", "2C", "2D", "28"]</td>
<td class="gt_row gt_left">Date</td>
<td class="gt_row gt_left"></td></tr>
    <tr class="gt_group_heading_row">
      <td colspan="5" class="gt_group_heading">Vaccination</td>
    </tr>
    <tr><td class="gt_row gt_left">Vaccination status</td>
<td class="gt_row gt_left">NIMS / Primary care record</td>
<td class="gt_row gt_left">Vaccination details are recorded in the National Immunisation Management Service (NIMS) and transmitted to the patient's GP record within days. Vaccination status can be identified from by the vaccine product name. Vaccine cardinality (i.e., first dose, second etc) is identified by vaccine dates, rather than explicit clinical coding.</td>
<td class="gt_row gt_left">Date + BNT162b2; ChAdOx1-S; mRNA-1273</td>
<td class="gt_row gt_left"></td></tr>
    <tr class="gt_group_heading_row">
      <td colspan="5" class="gt_group_heading">COVID-19 events</td>
    </tr>
    <tr><td class="gt_row gt_left">Probable COVID-19</td>
<td class="gt_row gt_left">Primary care record</td>
<td class="gt_row gt_left">Exact dates of COVID-19 infection / disease in priamry care records are unreliable. This variable is only used to determine historical infection prior to the study start date. Important due to low availability of testing early in the pandemic</td>
<td class="gt_row gt_left"></td>
<td class="gt_row gt_left">opensafely/covid-identification-in-primary-care-probable-covid-positive-test/2020-07-16/
opensafely/covid-identification-in-primary-care-probable-covid-clinical-code/2020-07-16/
opensafely/covid-identification-in-primary-care-probable-covid-sequelae/2020-07-16/</td></tr>
    <tr><td class="gt_row gt_left">SARS-CoV-2 positive test</td>
<td class="gt_row gt_left">SGSS</td>
<td class="gt_row gt_left">Any positive SARS-CoV-2 test, whether PCR or LFT. Swab date is used as the event date, not the date that the result was recorded.</td>
<td class="gt_row gt_left">Date</td>
<td class="gt_row gt_left"></td></tr>
    <tr><td class="gt_row gt_left">COVID-19 Hospital admissions</td>
<td class="gt_row gt_left">SUS-APCS</td>
<td class="gt_row gt_left">Any (completed) hospital episode with COVID-19 ICD10  codes mentioned anywhere in the diagnosis field (not just the primary diagnosis), and with admission method in ["21", "22", "23", "24", "25", "2A", "2B", "2C", "2D", "28"]</td>
<td class="gt_row gt_left">Date</td>
<td class="gt_row gt_left">opensafely/covid-identification/2020-06-03/</td></tr>
    <tr><td class="gt_row gt_left">COVID-19 death</td>
<td class="gt_row gt_left">Death register (ONS)</td>
<td class="gt_row gt_left">Deaths with COVID-19 ICD10 diagnosis codes mentioned anywhere on the death certificate (not just underlying cause)</td>
<td class="gt_row gt_left">Date</td>
<td class="gt_row gt_left">opensafely/covid-identification/2020-06-03/</td></tr>
    <tr class="gt_group_heading_row">
      <td colspan="5" class="gt_group_heading">NA</td>
    </tr>
    <tr><td class="gt_row gt_left">Death</td>
<td class="gt_row gt_left">Death register (ONS)</td>
<td class="gt_row gt_left">Any death</td>
<td class="gt_row gt_left">Date</td>
<td class="gt_row gt_left"></td></tr>
  </tbody>
  
  
</table>
</div>
```


Codelists can be found at `https://codelists.opensafely.org/codelist/<ID>`, substituting `<ID>` for the codelist identifier in the table above.

### Table S1: Inclusion criteria


```{=html}
<div id="vmjoleehjm" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#vmjoleehjm .gt_table {
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

#vmjoleehjm .gt_heading {
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

#vmjoleehjm .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#vmjoleehjm .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#vmjoleehjm .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#vmjoleehjm .gt_col_headings {
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

#vmjoleehjm .gt_col_heading {
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

#vmjoleehjm .gt_column_spanner_outer {
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

#vmjoleehjm .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#vmjoleehjm .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#vmjoleehjm .gt_column_spanner {
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

#vmjoleehjm .gt_group_heading {
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

#vmjoleehjm .gt_empty_group_heading {
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

#vmjoleehjm .gt_from_md > :first-child {
  margin-top: 0;
}

#vmjoleehjm .gt_from_md > :last-child {
  margin-bottom: 0;
}

#vmjoleehjm .gt_row {
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

#vmjoleehjm .gt_stub {
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

#vmjoleehjm .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#vmjoleehjm .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#vmjoleehjm .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#vmjoleehjm .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#vmjoleehjm .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#vmjoleehjm .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#vmjoleehjm .gt_footnotes {
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

#vmjoleehjm .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#vmjoleehjm .gt_sourcenotes {
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

#vmjoleehjm .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#vmjoleehjm .gt_left {
  text-align: left;
}

#vmjoleehjm .gt_center {
  text-align: center;
}

#vmjoleehjm .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#vmjoleehjm .gt_font_normal {
  font-weight: normal;
}

#vmjoleehjm .gt_font_bold {
  font-weight: bold;
}

#vmjoleehjm .gt_font_italic {
  font-style: italic;
}

#vmjoleehjm .gt_super {
  font-size: 65%;
}

#vmjoleehjm .gt_footnote_marks {
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
<td class="gt_row gt_right">5,763,280</td>
<td class="gt_row gt_right">-</td>
<td class="gt_row gt_right">100.0&percnt;</td></tr>
    <tr><td class="gt_row gt_left">-</td>
<td class="gt_row gt_left" style="white-space: pre-wrap;">with homologous primary vaccination
course of BNT162b2 or ChAdOx1-S</td>
<td class="gt_row gt_right">5,746,539</td>
<td class="gt_row gt_right">16,741</td>
<td class="gt_row gt_right">99.7&percnt;</td></tr>
    <tr><td class="gt_row gt_left">-</td>
<td class="gt_row gt_left" style="white-space: pre-wrap;">and not a HSC worker</td>
<td class="gt_row gt_right">5,373,976</td>
<td class="gt_row gt_right">372,563</td>
<td class="gt_row gt_right">93.2&percnt;</td></tr>
    <tr><td class="gt_row gt_left">-</td>
<td class="gt_row gt_left" style="white-space: pre-wrap;">and not a care/nursing home resident,
end-of-life or housebound</td>
<td class="gt_row gt_right">5,129,996</td>
<td class="gt_row gt_right">243,980</td>
<td class="gt_row gt_right">89.0&percnt;</td></tr>
    <tr><td class="gt_row gt_left">Eligible (people)</td>
<td class="gt_row gt_left" style="white-space: pre-wrap;">with no missing demographic information</td>
<td class="gt_row gt_right">4,764,097</td>
<td class="gt_row gt_right">365,899</td>
<td class="gt_row gt_right">82.7&percnt;</td></tr>
    <tr><td class="gt_row gt_left">-</td>
<td class="gt_row gt_left" style="white-space: pre-wrap;">and no evidence of SARS-CoV-2 infection
within 90 days of boosting</td>
<td class="gt_row gt_right">4,666,769</td>
<td class="gt_row gt_right">97,328</td>
<td class="gt_row gt_right">81.0&percnt;</td></tr>
    <tr><td class="gt_row gt_left">-</td>
<td class="gt_row gt_left" style="white-space: pre-wrap;">and not in hospital when boosted</td>
<td class="gt_row gt_right">4,264,383</td>
<td class="gt_row gt_right">402,386</td>
<td class="gt_row gt_right">74.0&percnt;</td></tr>
    <tr><td class="gt_row gt_left">Eligible (context)</td>
<td class="gt_row gt_left" style="white-space: pre-wrap;">and not boosted at an unusual time given
region, priority group, and second dose
date</td>
<td class="gt_row gt_right">3,998,664</td>
<td class="gt_row gt_right">265,719</td>
<td class="gt_row gt_right">69.4&percnt;</td></tr>
    <tr><td class="gt_row gt_left">Matched</td>
<td class="gt_row gt_left" style="white-space: pre-wrap;">and successfully matched to an unboosted
control</td>
<td class="gt_row gt_right">3,426,960</td>
<td class="gt_row gt_right">571,704</td>
<td class="gt_row gt_right">59.5&percnt;</td></tr>
    <tr><td class="gt_row gt_left">-</td>
<td class="gt_row gt_left" style="white-space: pre-wrap;">and also selected as a control in an
earlier trial</td>
<td class="gt_row gt_right">1,390,767</td>
<td class="gt_row gt_right">2,036,193</td>
<td class="gt_row gt_right">24.1&percnt;</td></tr>
  </tbody>
  
  
</table>
</div>
```

\newpage



### Figure S1: Standardised Mean Differences between Boosted and Unboosted groups


<img src="C:/Users/whulme/Documents/repos/booster-effectiveness/manuscript/figures/plot_smd-1.png" width="90%"  />


### Figure S2: Kaplan-Meier cumulative incidence curves

<img src="C:/Users/whulme/Documents/repos/booster-effectiveness/manuscript/figures/plot_km-1.png" width="90%"  />

\newpage

## Figure S3: Estimated booster effectiveness, all models


<img src="C:/Users/whulme/Documents/repos/booster-effectiveness/manuscript/figures/plot_effects-1.png" width="90%"  />


\newpage
