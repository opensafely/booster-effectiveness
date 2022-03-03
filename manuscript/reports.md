---
title: "Effectiveness of BNT162b2 booster doses in England: a observational study in OpenSAFELY-TPP: Materials"
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





\newpage

<!-- TODO -->

<!-- * full description of booster eligiblity over time -->

<!-- * figure 1 chart with SMD / %-point differences -->

<!-- * check for moderna references and remove if necessary -->

<!-- * check final recruitment day and include in results -->

<!-- * check if rolling average restrictions are ever used (need to output dataset) -->

<!-- * references -->



#### Table 0: Inclusion criteria


```{=html}
<div id="tvqwakgazi" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#tvqwakgazi .gt_table {
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

#tvqwakgazi .gt_heading {
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

#tvqwakgazi .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#tvqwakgazi .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#tvqwakgazi .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#tvqwakgazi .gt_col_headings {
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

#tvqwakgazi .gt_col_heading {
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

#tvqwakgazi .gt_column_spanner_outer {
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

#tvqwakgazi .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#tvqwakgazi .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#tvqwakgazi .gt_column_spanner {
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

#tvqwakgazi .gt_group_heading {
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

#tvqwakgazi .gt_empty_group_heading {
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

#tvqwakgazi .gt_from_md > :first-child {
  margin-top: 0;
}

#tvqwakgazi .gt_from_md > :last-child {
  margin-bottom: 0;
}

#tvqwakgazi .gt_row {
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

#tvqwakgazi .gt_stub {
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

#tvqwakgazi .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#tvqwakgazi .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#tvqwakgazi .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#tvqwakgazi .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#tvqwakgazi .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#tvqwakgazi .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#tvqwakgazi .gt_footnotes {
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

#tvqwakgazi .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#tvqwakgazi .gt_sourcenotes {
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

#tvqwakgazi .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#tvqwakgazi .gt_left {
  text-align: left;
}

#tvqwakgazi .gt_center {
  text-align: center;
}

#tvqwakgazi .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#tvqwakgazi .gt_font_normal {
  font-weight: normal;
}

#tvqwakgazi .gt_font_bold {
  font-weight: bold;
}

#tvqwakgazi .gt_font_italic {
  font-style: italic;
}

#tvqwakgazi .gt_super {
  font-size: 65%;
}

#tvqwakgazi .gt_footnote_marks {
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


#### Table 1: Participant characteristics

Participant characteristics as on the day of recruitment into the treatment or control group.


```{=html}
<div id="xzexmkxuqz" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#xzexmkxuqz .gt_table {
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

#xzexmkxuqz .gt_heading {
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

#xzexmkxuqz .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#xzexmkxuqz .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#xzexmkxuqz .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#xzexmkxuqz .gt_col_headings {
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

#xzexmkxuqz .gt_col_heading {
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

#xzexmkxuqz .gt_column_spanner_outer {
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

#xzexmkxuqz .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#xzexmkxuqz .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#xzexmkxuqz .gt_column_spanner {
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

#xzexmkxuqz .gt_group_heading {
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

#xzexmkxuqz .gt_empty_group_heading {
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

#xzexmkxuqz .gt_from_md > :first-child {
  margin-top: 0;
}

#xzexmkxuqz .gt_from_md > :last-child {
  margin-bottom: 0;
}

#xzexmkxuqz .gt_row {
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

#xzexmkxuqz .gt_stub {
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

#xzexmkxuqz .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#xzexmkxuqz .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#xzexmkxuqz .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#xzexmkxuqz .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#xzexmkxuqz .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#xzexmkxuqz .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#xzexmkxuqz .gt_footnotes {
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

#xzexmkxuqz .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#xzexmkxuqz .gt_sourcenotes {
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

#xzexmkxuqz .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#xzexmkxuqz .gt_left {
  text-align: left;
}

#xzexmkxuqz .gt_center {
  text-align: center;
}

#xzexmkxuqz .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#xzexmkxuqz .gt_font_normal {
  font-weight: normal;
}

#xzexmkxuqz .gt_font_bold {
  font-weight: bold;
}

#xzexmkxuqz .gt_font_italic {
  font-style: italic;
}

#xzexmkxuqz .gt_super {
  font-size: 65%;
}

#xzexmkxuqz .gt_footnote_marks {
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
<div id="yvlilbmcoh" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#yvlilbmcoh .gt_table {
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

#yvlilbmcoh .gt_heading {
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

#yvlilbmcoh .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#yvlilbmcoh .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#yvlilbmcoh .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#yvlilbmcoh .gt_col_headings {
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

#yvlilbmcoh .gt_col_heading {
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

#yvlilbmcoh .gt_column_spanner_outer {
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

#yvlilbmcoh .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#yvlilbmcoh .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#yvlilbmcoh .gt_column_spanner {
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

#yvlilbmcoh .gt_group_heading {
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

#yvlilbmcoh .gt_empty_group_heading {
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

#yvlilbmcoh .gt_from_md > :first-child {
  margin-top: 0;
}

#yvlilbmcoh .gt_from_md > :last-child {
  margin-bottom: 0;
}

#yvlilbmcoh .gt_row {
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

#yvlilbmcoh .gt_stub {
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

#yvlilbmcoh .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#yvlilbmcoh .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#yvlilbmcoh .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#yvlilbmcoh .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#yvlilbmcoh .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#yvlilbmcoh .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#yvlilbmcoh .gt_footnotes {
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

#yvlilbmcoh .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#yvlilbmcoh .gt_sourcenotes {
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

#yvlilbmcoh .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#yvlilbmcoh .gt_left {
  text-align: left;
}

#yvlilbmcoh .gt_center {
  text-align: center;
}

#yvlilbmcoh .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#yvlilbmcoh .gt_font_normal {
  font-weight: normal;
}

#yvlilbmcoh .gt_font_bold {
  font-weight: bold;
}

#yvlilbmcoh .gt_font_italic {
  font-style: italic;
}

#yvlilbmcoh .gt_super {
  font-size: 65%;
}

#yvlilbmcoh .gt_footnote_marks {
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
\newpage


## Table 3a: Estimated booster effectiveness (5 period)

Main and subgroup analyses

```{=html}
<div id="mjnmdmolsi" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#mjnmdmolsi .gt_table {
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

#mjnmdmolsi .gt_heading {
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

#mjnmdmolsi .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#mjnmdmolsi .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#mjnmdmolsi .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#mjnmdmolsi .gt_col_headings {
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

#mjnmdmolsi .gt_col_heading {
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

#mjnmdmolsi .gt_column_spanner_outer {
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

#mjnmdmolsi .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#mjnmdmolsi .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#mjnmdmolsi .gt_column_spanner {
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

#mjnmdmolsi .gt_group_heading {
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

#mjnmdmolsi .gt_empty_group_heading {
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

#mjnmdmolsi .gt_from_md > :first-child {
  margin-top: 0;
}

#mjnmdmolsi .gt_from_md > :last-child {
  margin-bottom: 0;
}

#mjnmdmolsi .gt_row {
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

#mjnmdmolsi .gt_stub {
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

#mjnmdmolsi .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#mjnmdmolsi .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#mjnmdmolsi .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#mjnmdmolsi .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#mjnmdmolsi .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#mjnmdmolsi .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#mjnmdmolsi .gt_footnotes {
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

#mjnmdmolsi .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#mjnmdmolsi .gt_sourcenotes {
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

#mjnmdmolsi .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#mjnmdmolsi .gt_left {
  text-align: left;
}

#mjnmdmolsi .gt_center {
  text-align: center;
}

#mjnmdmolsi .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#mjnmdmolsi .gt_font_normal {
  font-weight: normal;
}

#mjnmdmolsi .gt_font_bold {
  font-weight: bold;
}

#mjnmdmolsi .gt_font_italic {
  font-style: italic;
}

#mjnmdmolsi .gt_super {
  font-size: 65%;
}

#mjnmdmolsi .gt_footnote_marks {
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
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.79 (0.77-0.82)</td>
<td class="gt_row gt_right">20.6 (18.0-23.1)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.47 (0.45-0.49)</td>
<td class="gt_row gt_right">53.1 (51.4-54.7)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.21 (0.20-0.21)</td>
<td class="gt_row gt_right">79.4 (78.5-80.2)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.23 (0.22-0.25)</td>
<td class="gt_row gt_right">76.9 (75.4-78.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.32 (0.30-0.34)</td>
<td class="gt_row gt_right">67.9 (65.6-70.1)</td></tr>
    <tr><td class="gt_row gt_right">BNT162b2-BNT162b2</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.79 (0.74-0.83)</td>
<td class="gt_row gt_right">21.4 (16.9-25.8)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.48 (0.46-0.51)</td>
<td class="gt_row gt_right">51.5 (48.5-54.4)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.24 (0.23-0.26)</td>
<td class="gt_row gt_right">75.5 (73.8-77.1)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.28 (0.26-0.30)</td>
<td class="gt_row gt_right">72.2 (69.6-74.5)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.35 (0.32-0.39)</td>
<td class="gt_row gt_right">64.6 (61.4-67.6)</td></tr>
    <tr><td class="gt_row gt_right">ChAdOx1-ChAdOx1</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.80 (0.77-0.83)</td>
<td class="gt_row gt_right">20.3 (17.0-23.4)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.46 (0.44-0.48)</td>
<td class="gt_row gt_right">53.9 (51.9-55.9)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.19 (0.18-0.20)</td>
<td class="gt_row gt_right">81.4 (80.4-82.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.20 (0.18-0.21)</td>
<td class="gt_row gt_right">80.4 (78.6-82.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.27 (0.24-0.30)</td>
<td class="gt_row gt_right">73.1 (69.6-76.3)</td></tr>
    <tr><td class="gt_row gt_right">Not Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.79 (0.76-0.82)</td>
<td class="gt_row gt_right">21.0 (18.2-23.7)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.45 (0.44-0.47)</td>
<td class="gt_row gt_right">54.7 (53.0-56.4)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.20 (0.19-0.21)</td>
<td class="gt_row gt_right">80.4 (79.4-81.2)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.23 (0.21-0.24)</td>
<td class="gt_row gt_right">77.3 (75.6-78.8)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.33 (0.30-0.35)</td>
<td class="gt_row gt_right">67.4 (64.7-69.9)</td></tr>
    <tr><td class="gt_row gt_right">Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.82 (0.75-0.90)</td>
<td class="gt_row gt_right">17.8 (10.0-24.9)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.58 (0.53-0.64)</td>
<td class="gt_row gt_right">41.8 (36.1-47.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.27 (0.24-0.30)</td>
<td class="gt_row gt_right">73.3 (70.5-75.9)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.25 (0.22-0.29)</td>
<td class="gt_row gt_right">74.9 (71.3-78.1)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.30 (0.26-0.36)</td>
<td class="gt_row gt_right">69.6 (64.1-74.2)</td></tr>
    <tr><td class="gt_row gt_right">Aged 18-64</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.82 (0.79-0.86)</td>
<td class="gt_row gt_right">17.6 (14.3-20.9)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.45 (0.43-0.47)</td>
<td class="gt_row gt_right">55.1 (53.1-57.1)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.23 (0.22-0.24)</td>
<td class="gt_row gt_right">77.2 (76.1-78.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.27 (0.25-0.29)</td>
<td class="gt_row gt_right">73.2 (71.2-75.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.38 (0.35-0.41)</td>
<td class="gt_row gt_right">61.9 (58.8-64.9)</td></tr>
    <tr><td class="gt_row gt_right">Aged 65 and over</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.76 (0.72-0.81)</td>
<td class="gt_row gt_right">23.7 (19.3-27.8)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.53 (0.50-0.57)</td>
<td class="gt_row gt_right">46.7 (43.4-49.8)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.17 (0.16-0.19)</td>
<td class="gt_row gt_right">82.8 (81.3-84.2)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.20 (0.18-0.22)</td>
<td class="gt_row gt_right">80.1 (77.6-82.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.24 (0.20-0.28)</td>
<td class="gt_row gt_right">76.2 (72.3-79.6)</td></tr>
    <tr class="gt_group_heading_row">
      <td colspan="4" class="gt_group_heading">COVID-19 hospitalisation</td>
    </tr>
    <tr><td class="gt_row gt_right">All</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.31 (0.25-0.39)</td>
<td class="gt_row gt_right">69.1 (61.2-75.4)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.32 (0.27-0.39)</td>
<td class="gt_row gt_right">68.0 (61.5-73.5)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.16 (0.13-0.19)</td>
<td class="gt_row gt_right">84.4 (81.0-87.1)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.10 (0.07-0.14)</td>
<td class="gt_row gt_right">89.9 (86.1-92.7)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.17 (0.12-0.24)</td>
<td class="gt_row gt_right">83.0 (76.3-87.9)</td></tr>
    <tr><td class="gt_row gt_right">BNT162b2-BNT162b2</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.34 (0.24-0.49)</td>
<td class="gt_row gt_right">65.8 (50.8-76.2)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.34 (0.25-0.46)</td>
<td class="gt_row gt_right">65.7 (53.7-74.5)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.20 (0.15-0.26)</td>
<td class="gt_row gt_right">80.2 (73.5-85.2)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.13 (0.08-0.20)</td>
<td class="gt_row gt_right">87.4 (80.2-92.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.15 (0.09-0.24)</td>
<td class="gt_row gt_right">85.3 (76.5-90.8)</td></tr>
    <tr><td class="gt_row gt_right">ChAdOx1-ChAdOx1</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.29 (0.22-0.39)</td>
<td class="gt_row gt_right">70.9 (61.1-78.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.31 (0.24-0.39)</td>
<td class="gt_row gt_right">69.4 (61.1-75.9)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.13 (0.10-0.17)</td>
<td class="gt_row gt_right">86.7 (82.7-89.8)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.08 (0.05-0.13)</td>
<td class="gt_row gt_right">91.5 (86.8-94.6)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.20 (0.12-0.32)</td>
<td class="gt_row gt_right">80.0 (67.6-87.6)</td></tr>
    <tr><td class="gt_row gt_right">Not Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.30 (0.23-0.41)</td>
<td class="gt_row gt_right">69.5 (59.0-77.4)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.28 (0.22-0.36)</td>
<td class="gt_row gt_right">71.9 (63.7-78.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.10 (0.07-0.13)</td>
<td class="gt_row gt_right">90.4 (86.7-93.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.09 (0.05-0.14)</td>
<td class="gt_row gt_right">91.5 (86.1-94.8)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.09 (0.05-0.17)</td>
<td class="gt_row gt_right">90.6 (82.6-94.9)</td></tr>
    <tr><td class="gt_row gt_right">Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.32 (0.22-0.45)</td>
<td class="gt_row gt_right">68.3 (54.9-77.7)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.38 (0.29-0.50)</td>
<td class="gt_row gt_right">62.2 (50.3-71.2)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.24 (0.19-0.31)</td>
<td class="gt_row gt_right">76.2 (69.5-81.4)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.12 (0.08-0.18)</td>
<td class="gt_row gt_right">88.0 (81.8-92.1)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.25 (0.17-0.37)</td>
<td class="gt_row gt_right">75.1 (62.5-83.4)</td></tr>
    <tr><td class="gt_row gt_right">Aged 18-64</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.31 (0.18-0.52)</td>
<td class="gt_row gt_right">69.2 (47.7-81.9)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.32 (0.22-0.47)</td>
<td class="gt_row gt_right">67.8 (53.3-77.8)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.24 (0.17-0.35)</td>
<td class="gt_row gt_right">75.6 (64.7-83.1)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.10 (0.05-0.20)</td>
<td class="gt_row gt_right">90.4 (80.1-95.4)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.54 (0.31-0.95)</td>
<td class="gt_row gt_right">46.2 (5.3-69.4)</td></tr>
    <tr><td class="gt_row gt_right">Aged 65 and over</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.31 (0.24-0.39)</td>
<td class="gt_row gt_right">69.3 (60.6-76.2)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.32 (0.26-0.40)</td>
<td class="gt_row gt_right">68.2 (60.5-74.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.13 (0.11-0.17)</td>
<td class="gt_row gt_right">86.6 (83.2-89.4)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.10 (0.07-0.15)</td>
<td class="gt_row gt_right">89.8 (85.4-92.8)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.10 (0.07-0.16)</td>
<td class="gt_row gt_right">89.5 (83.7-93.3)</td></tr>
    <tr class="gt_group_heading_row">
      <td colspan="4" class="gt_group_heading">COVID-19 death</td>
    </tr>
    <tr><td class="gt_row gt_right">All</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.16 (0.04-0.70)</td>
<td class="gt_row gt_right">84.2 (29.9-96.4)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.19 (0.09-0.38)</td>
<td class="gt_row gt_right">81.3 (61.9-90.9)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.17 (0.11-0.25)</td>
<td class="gt_row gt_right">83.4 (74.6-89.1)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.07 (0.04-0.12)</td>
<td class="gt_row gt_right">93.2 (87.6-96.2)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.04 (0.02-0.11)</td>
<td class="gt_row gt_right">95.8 (89.4-98.3)</td></tr>
    <tr><td class="gt_row gt_right">BNT162b2-BNT162b2</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.00 (0.00-0.00)</td>
<td class="gt_row gt_right">100.0 (100.0-100.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.13 (0.04-0.42)</td>
<td class="gt_row gt_right">87.5 (58.4-96.2)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.14 (0.07-0.30)</td>
<td class="gt_row gt_right">85.9 (70.3-93.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.08 (0.03-0.18)</td>
<td class="gt_row gt_right">92.0 (81.5-96.5)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.06 (0.02-0.16)</td>
<td class="gt_row gt_right">94.4 (84.3-98.0)</td></tr>
    <tr><td class="gt_row gt_right">ChAdOx1-ChAdOx1</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.27 (0.06-1.29)</td>
<td class="gt_row gt_right">73.1 (-28.8-94.4)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.25 (0.10-0.61)</td>
<td class="gt_row gt_right">75.1 (38.6-89.9)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.18 (0.11-0.31)</td>
<td class="gt_row gt_right">81.7 (69.3-89.1)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.06 (0.03-0.14)</td>
<td class="gt_row gt_right">94.0 (85.9-97.4)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.02 (0.00-0.15)</td>
<td class="gt_row gt_right">97.9 (84.6-99.7)</td></tr>
    <tr><td class="gt_row gt_right">Not Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.00 (0.00-0.00)</td>
<td class="gt_row gt_right">100.0 (100.0-100.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.04 (0.01-0.33)</td>
<td class="gt_row gt_right">95.5 (66.8-99.4)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.19 (0.10-0.35)</td>
<td class="gt_row gt_right">80.8 (64.6-89.6)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.00 (0.00-0.00)</td>
<td class="gt_row gt_right">100.0 (100.0-100.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.04 (0.01-0.19)</td>
<td class="gt_row gt_right">95.6 (80.9-99.0)</td></tr>
    <tr><td class="gt_row gt_right">Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.90 (0.13-6.36)</td>
<td class="gt_row gt_right">9.9 (-535.9-87.2)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.31 (0.14-0.68)</td>
<td class="gt_row gt_right">69.2 (31.7-86.1)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.15 (0.08-0.27)</td>
<td class="gt_row gt_right">84.9 (72.8-91.6)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.15 (0.08-0.28)</td>
<td class="gt_row gt_right">85.1 (72.2-92.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.04 (0.01-0.13)</td>
<td class="gt_row gt_right">95.9 (86.9-98.7)</td></tr>
    <tr><td class="gt_row gt_right">Aged 18-64</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.32 (0.03-3.20)</td>
<td class="gt_row gt_right">68.1 (-219.8-96.8)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.23 (0.05-1.07)</td>
<td class="gt_row gt_right">77.2 (-7.2-95.2)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.27 (0.07-0.99)</td>
<td class="gt_row gt_right">73.2 (0.7-92.8)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.28 (0.07-1.10)</td>
<td class="gt_row gt_right">72.4 (-10.1-93.1)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.11 (0.01-0.94)</td>
<td class="gt_row gt_right">89.4 (5.5-98.8)</td></tr>
    <tr><td class="gt_row gt_right">Aged 65 and over</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.11 (0.01-0.84)</td>
<td class="gt_row gt_right">89.4 (15.9-98.7)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.18 (0.08-0.40)</td>
<td class="gt_row gt_right">82.3 (60.3-92.1)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.16 (0.10-0.25)</td>
<td class="gt_row gt_right">84.4 (75.5-90.1)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.05 (0.03-0.11)</td>
<td class="gt_row gt_right">94.6 (89.3-97.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.04 (0.01-0.10)</td>
<td class="gt_row gt_right">96.3 (89.7-98.7)</td></tr>
    <tr class="gt_group_heading_row">
      <td colspan="4" class="gt_group_heading">Non-COVID-19 death</td>
    </tr>
    <tr><td class="gt_row gt_right">All</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.08 (0.07-0.10)</td>
<td class="gt_row gt_right">91.8 (90.3-93.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.26 (0.22-0.30)</td>
<td class="gt_row gt_right">74.4 (70.3-77.9)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.21 (0.19-0.24)</td>
<td class="gt_row gt_right">79.0 (76.4-81.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.16 (0.14-0.19)</td>
<td class="gt_row gt_right">83.7 (81.2-85.8)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.17 (0.15-0.20)</td>
<td class="gt_row gt_right">82.6 (79.7-85.1)</td></tr>
    <tr><td class="gt_row gt_right">BNT162b2-BNT162b2</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.06 (0.05-0.08)</td>
<td class="gt_row gt_right">93.8 (92.1-95.2)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.21 (0.17-0.26)</td>
<td class="gt_row gt_right">79.1 (73.9-83.2)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.20 (0.17-0.24)</td>
<td class="gt_row gt_right">80.1 (76.3-83.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.15 (0.12-0.18)</td>
<td class="gt_row gt_right">85.4 (82.0-88.1)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.16 (0.13-0.19)</td>
<td class="gt_row gt_right">84.2 (80.7-87.1)</td></tr>
    <tr><td class="gt_row gt_right">ChAdOx1-ChAdOx1</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.11 (0.09-0.13)</td>
<td class="gt_row gt_right">89.2 (86.6-91.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.31 (0.25-0.38)</td>
<td class="gt_row gt_right">69.0 (62.2-74.6)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.22 (0.19-0.26)</td>
<td class="gt_row gt_right">78.0 (74.2-81.2)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.18 (0.15-0.22)</td>
<td class="gt_row gt_right">81.8 (77.8-85.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.20 (0.16-0.25)</td>
<td class="gt_row gt_right">79.9 (74.6-84.2)</td></tr>
    <tr><td class="gt_row gt_right">Not Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.09 (0.08-0.12)</td>
<td class="gt_row gt_right">90.5 (88.3-92.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.27 (0.22-0.33)</td>
<td class="gt_row gt_right">72.7 (66.8-77.5)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.20 (0.17-0.23)</td>
<td class="gt_row gt_right">80.4 (76.9-83.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.15 (0.13-0.19)</td>
<td class="gt_row gt_right">84.6 (81.2-87.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.15 (0.12-0.19)</td>
<td class="gt_row gt_right">84.9 (81.1-87.9)</td></tr>
    <tr><td class="gt_row gt_right">Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.07 (0.05-0.09)</td>
<td class="gt_row gt_right">93.2 (91.2-94.7)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.24 (0.19-0.30)</td>
<td class="gt_row gt_right">76.0 (70.0-80.7)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.23 (0.20-0.27)</td>
<td class="gt_row gt_right">76.9 (72.7-80.5)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.18 (0.15-0.22)</td>
<td class="gt_row gt_right">82.2 (78.3-85.5)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.20 (0.16-0.24)</td>
<td class="gt_row gt_right">80.4 (75.8-84.1)</td></tr>
    <tr><td class="gt_row gt_right">Aged 18-64</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.10 (0.06-0.16)</td>
<td class="gt_row gt_right">90.1 (83.7-94.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.35 (0.24-0.50)</td>
<td class="gt_row gt_right">65.1 (50.0-75.7)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.26 (0.19-0.36)</td>
<td class="gt_row gt_right">73.8 (64.1-80.9)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.33 (0.21-0.50)</td>
<td class="gt_row gt_right">67.2 (49.6-78.7)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.22 (0.13-0.39)</td>
<td class="gt_row gt_right">77.6 (60.5-87.3)</td></tr>
    <tr><td class="gt_row gt_right">Aged 65 and over</td>
<td class="gt_row gt_right">1 - 7</td>
<td class="gt_row gt_right">0.08 (0.07-0.09)</td>
<td class="gt_row gt_right">92.0 (90.5-93.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">8 - 14</td>
<td class="gt_row gt_right">0.24 (0.20-0.28)</td>
<td class="gt_row gt_right">75.9 (71.7-79.5)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">15 - 28</td>
<td class="gt_row gt_right">0.20 (0.18-0.23)</td>
<td class="gt_row gt_right">80.0 (77.3-82.4)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 42</td>
<td class="gt_row gt_right">0.15 (0.13-0.17)</td>
<td class="gt_row gt_right">85.1 (82.7-87.2)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">43 - 70</td>
<td class="gt_row gt_right">0.17 (0.15-0.20)</td>
<td class="gt_row gt_right">82.9 (79.9-85.4)</td></tr>
  </tbody>
  
  
</table>
</div>
```

\newpage

## Table 3b: Estimated booster effectiveness (2 period split at 28 days)


```{=html}
<div id="yyicswqbte" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#yyicswqbte .gt_table {
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

#yyicswqbte .gt_heading {
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

#yyicswqbte .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#yyicswqbte .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#yyicswqbte .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#yyicswqbte .gt_col_headings {
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

#yyicswqbte .gt_col_heading {
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

#yyicswqbte .gt_column_spanner_outer {
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

#yyicswqbte .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#yyicswqbte .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#yyicswqbte .gt_column_spanner {
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

#yyicswqbte .gt_group_heading {
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

#yyicswqbte .gt_empty_group_heading {
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

#yyicswqbte .gt_from_md > :first-child {
  margin-top: 0;
}

#yyicswqbte .gt_from_md > :last-child {
  margin-bottom: 0;
}

#yyicswqbte .gt_row {
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

#yyicswqbte .gt_stub {
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

#yyicswqbte .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#yyicswqbte .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#yyicswqbte .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#yyicswqbte .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#yyicswqbte .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#yyicswqbte .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#yyicswqbte .gt_footnotes {
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

#yyicswqbte .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#yyicswqbte .gt_sourcenotes {
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

#yyicswqbte .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#yyicswqbte .gt_left {
  text-align: left;
}

#yyicswqbte .gt_center {
  text-align: center;
}

#yyicswqbte .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#yyicswqbte .gt_font_normal {
  font-weight: normal;
}

#yyicswqbte .gt_font_bold {
  font-weight: bold;
}

#yyicswqbte .gt_font_italic {
  font-style: italic;
}

#yyicswqbte .gt_super {
  font-size: 65%;
}

#yyicswqbte .gt_footnote_marks {
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
    <tr><td class="gt_row gt_right">BNT162b2-BNT162b2</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.48 (0.47-0.50)</td>
<td class="gt_row gt_right">51.5 (49.8-53.2)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.31 (0.30-0.33)</td>
<td class="gt_row gt_right">68.6 (66.6-70.5)</td></tr>
    <tr><td class="gt_row gt_right">ChAdOx1-ChAdOx1</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.47 (0.46-0.48)</td>
<td class="gt_row gt_right">53.1 (51.9-54.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.22 (0.20-0.23)</td>
<td class="gt_row gt_right">78.3 (76.7-79.8)</td></tr>
    <tr><td class="gt_row gt_right">Not Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.47 (0.46-0.48)</td>
<td class="gt_row gt_right">53.3 (52.2-54.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.27 (0.25-0.28)</td>
<td class="gt_row gt_right">73.5 (72.1-74.8)</td></tr>
    <tr><td class="gt_row gt_right">Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.53 (0.50-0.55)</td>
<td class="gt_row gt_right">47.5 (44.5-50.2)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.27 (0.24-0.30)</td>
<td class="gt_row gt_right">72.9 (69.9-75.6)</td></tr>
    <tr><td class="gt_row gt_right">Aged 18-64</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.48 (0.46-0.49)</td>
<td class="gt_row gt_right">52.5 (51.3-53.6)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.31 (0.30-0.33)</td>
<td class="gt_row gt_right">68.7 (67.0-70.3)</td></tr>
    <tr><td class="gt_row gt_right">Aged 65 and over</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.50 (0.48-0.52)</td>
<td class="gt_row gt_right">50.0 (48.1-51.8)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.21 (0.19-0.23)</td>
<td class="gt_row gt_right">78.7 (76.6-80.6)</td></tr>
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
    <tr><td class="gt_row gt_right">BNT162b2-BNT162b2</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.28 (0.23-0.33)</td>
<td class="gt_row gt_right">72.3 (66.8-76.9)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.14 (0.10-0.19)</td>
<td class="gt_row gt_right">86.4 (81.2-90.2)</td></tr>
    <tr><td class="gt_row gt_right">ChAdOx1-ChAdOx1</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.23 (0.20-0.27)</td>
<td class="gt_row gt_right">77.2 (73.4-80.4)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.13 (0.09-0.18)</td>
<td class="gt_row gt_right">87.4 (82.5-90.9)</td></tr>
    <tr><td class="gt_row gt_right">Not Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.22 (0.18-0.26)</td>
<td class="gt_row gt_right">78.4 (74.5-81.7)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.09 (0.06-0.13)</td>
<td class="gt_row gt_right">91.1 (87.0-93.9)</td></tr>
    <tr><td class="gt_row gt_right">Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.30 (0.25-0.35)</td>
<td class="gt_row gt_right">70.2 (64.9-74.6)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.17 (0.13-0.23)</td>
<td class="gt_row gt_right">82.5 (76.6-87.0)</td></tr>
    <tr><td class="gt_row gt_right">Aged 18-64</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.29 (0.23-0.36)</td>
<td class="gt_row gt_right">71.5 (63.9-77.5)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.28 (0.18-0.44)</td>
<td class="gt_row gt_right">71.8 (56.0-82.0)</td></tr>
    <tr><td class="gt_row gt_right">Aged 65 and over</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.24 (0.21-0.27)</td>
<td class="gt_row gt_right">76.4 (73.1-79.4)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.10 (0.08-0.14)</td>
<td class="gt_row gt_right">89.7 (86.4-92.2)</td></tr>
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
    <tr><td class="gt_row gt_right">BNT162b2-BNT162b2</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.00 (0.00-0.00)</td>
<td class="gt_row gt_right">99.9 (99.9-100.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.07 (0.04-0.13)</td>
<td class="gt_row gt_right">93.1 (86.7-96.4)</td></tr>
    <tr><td class="gt_row gt_right">ChAdOx1-ChAdOx1</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.20 (0.13-0.31)</td>
<td class="gt_row gt_right">79.8 (68.8-86.9)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.05 (0.02-0.11)</td>
<td class="gt_row gt_right">94.9 (88.8-97.6)</td></tr>
    <tr><td class="gt_row gt_right">Not Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.00 (0.00-0.00)</td>
<td class="gt_row gt_right">100.0 (100.0-100.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.00 (0.00-0.00)</td>
<td class="gt_row gt_right">100.0 (100.0-100.0)</td></tr>
    <tr><td class="gt_row gt_right">Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.21 (0.13-0.34)</td>
<td class="gt_row gt_right">78.8 (66.5-86.6)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.11 (0.06-0.19)</td>
<td class="gt_row gt_right">88.8 (80.6-93.5)</td></tr>
    <tr><td class="gt_row gt_right">Aged 18-64</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.26 (0.10-0.65)</td>
<td class="gt_row gt_right">74.0 (34.9-89.6)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.21 (0.07-0.68)</td>
<td class="gt_row gt_right">79.0 (32.4-93.5)</td></tr>
    <tr><td class="gt_row gt_right">Aged 65 and over</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.16 (0.11-0.23)</td>
<td class="gt_row gt_right">84.1 (76.7-89.2)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.05 (0.03-0.08)</td>
<td class="gt_row gt_right">95.2 (91.6-97.3)</td></tr>
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
    <tr><td class="gt_row gt_right">BNT162b2-BNT162b2</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.15 (0.14-0.17)</td>
<td class="gt_row gt_right">84.6 (82.6-86.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.15 (0.13-0.18)</td>
<td class="gt_row gt_right">84.8 (82.4-86.9)</td></tr>
    <tr><td class="gt_row gt_right">ChAdOx1-ChAdOx1</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.20 (0.18-0.23)</td>
<td class="gt_row gt_right">79.7 (77.3-81.7)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.19 (0.16-0.22)</td>
<td class="gt_row gt_right">81.0 (78.0-83.7)</td></tr>
    <tr><td class="gt_row gt_right">Not Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.18 (0.16-0.20)</td>
<td class="gt_row gt_right">82.1 (80.1-84.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.15 (0.13-0.18)</td>
<td class="gt_row gt_right">84.7 (82.3-86.8)</td></tr>
    <tr><td class="gt_row gt_right">Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.18 (0.16-0.20)</td>
<td class="gt_row gt_right">81.9 (79.7-84.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.19 (0.16-0.22)</td>
<td class="gt_row gt_right">81.4 (78.5-83.9)</td></tr>
    <tr><td class="gt_row gt_right">Aged 18-64</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.24 (0.20-0.30)</td>
<td class="gt_row gt_right">75.8 (70.0-80.5)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.28 (0.20-0.40)</td>
<td class="gt_row gt_right">71.5 (59.8-79.8)</td></tr>
    <tr><td class="gt_row gt_right">Aged 65 and over</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.17 (0.15-0.18)</td>
<td class="gt_row gt_right">83.3 (81.8-84.7)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.16 (0.14-0.18)</td>
<td class="gt_row gt_right">84.1 (82.3-85.8)</td></tr>
  </tbody>
  
  
</table>
</div>
```

\newpage


## Table 3c: Estimated booster effectiveness (2 period split at 42 days)


```{=html}
<div id="dnddvsomep" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#dnddvsomep .gt_table {
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

#dnddvsomep .gt_heading {
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

#dnddvsomep .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#dnddvsomep .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#dnddvsomep .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#dnddvsomep .gt_col_headings {
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

#dnddvsomep .gt_col_heading {
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

#dnddvsomep .gt_column_spanner_outer {
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

#dnddvsomep .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#dnddvsomep .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#dnddvsomep .gt_column_spanner {
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

#dnddvsomep .gt_group_heading {
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

#dnddvsomep .gt_empty_group_heading {
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

#dnddvsomep .gt_from_md > :first-child {
  margin-top: 0;
}

#dnddvsomep .gt_from_md > :last-child {
  margin-bottom: 0;
}

#dnddvsomep .gt_row {
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

#dnddvsomep .gt_stub {
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

#dnddvsomep .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#dnddvsomep .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#dnddvsomep .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#dnddvsomep .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#dnddvsomep .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#dnddvsomep .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#dnddvsomep .gt_footnotes {
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

#dnddvsomep .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#dnddvsomep .gt_sourcenotes {
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

#dnddvsomep .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#dnddvsomep .gt_left {
  text-align: left;
}

#dnddvsomep .gt_center {
  text-align: center;
}

#dnddvsomep .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#dnddvsomep .gt_font_normal {
  font-weight: normal;
}

#dnddvsomep .gt_font_bold {
  font-weight: bold;
}

#dnddvsomep .gt_font_italic {
  font-style: italic;
}

#dnddvsomep .gt_super {
  font-size: 65%;
}

#dnddvsomep .gt_footnote_marks {
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
    <tr><td class="gt_row gt_right">BNT162b2-BNT162b2</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.48 (0.47-0.50)</td>
<td class="gt_row gt_right">51.5 (49.8-53.2)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.31 (0.30-0.33)</td>
<td class="gt_row gt_right">68.6 (66.6-70.5)</td></tr>
    <tr><td class="gt_row gt_right">ChAdOx1-ChAdOx1</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.47 (0.46-0.48)</td>
<td class="gt_row gt_right">53.1 (51.9-54.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.22 (0.20-0.23)</td>
<td class="gt_row gt_right">78.3 (76.7-79.8)</td></tr>
    <tr><td class="gt_row gt_right">Not Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.47 (0.46-0.48)</td>
<td class="gt_row gt_right">53.3 (52.2-54.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.27 (0.25-0.28)</td>
<td class="gt_row gt_right">73.5 (72.1-74.8)</td></tr>
    <tr><td class="gt_row gt_right">Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.53 (0.50-0.55)</td>
<td class="gt_row gt_right">47.5 (44.5-50.2)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.27 (0.24-0.30)</td>
<td class="gt_row gt_right">72.9 (69.9-75.6)</td></tr>
    <tr><td class="gt_row gt_right">Aged 18-64</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.48 (0.46-0.49)</td>
<td class="gt_row gt_right">52.5 (51.3-53.6)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.31 (0.30-0.33)</td>
<td class="gt_row gt_right">68.7 (67.0-70.3)</td></tr>
    <tr><td class="gt_row gt_right">Aged 65 and over</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.50 (0.48-0.52)</td>
<td class="gt_row gt_right">50.0 (48.1-51.8)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.21 (0.19-0.23)</td>
<td class="gt_row gt_right">78.7 (76.6-80.6)</td></tr>
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
    <tr><td class="gt_row gt_right">BNT162b2-BNT162b2</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.28 (0.23-0.33)</td>
<td class="gt_row gt_right">72.3 (66.8-76.9)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.14 (0.10-0.19)</td>
<td class="gt_row gt_right">86.4 (81.2-90.2)</td></tr>
    <tr><td class="gt_row gt_right">ChAdOx1-ChAdOx1</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.23 (0.20-0.27)</td>
<td class="gt_row gt_right">77.2 (73.4-80.4)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.13 (0.09-0.18)</td>
<td class="gt_row gt_right">87.4 (82.5-90.9)</td></tr>
    <tr><td class="gt_row gt_right">Not Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.22 (0.18-0.26)</td>
<td class="gt_row gt_right">78.4 (74.5-81.7)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.09 (0.06-0.13)</td>
<td class="gt_row gt_right">91.1 (87.0-93.9)</td></tr>
    <tr><td class="gt_row gt_right">Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.30 (0.25-0.35)</td>
<td class="gt_row gt_right">70.2 (64.9-74.6)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.17 (0.13-0.23)</td>
<td class="gt_row gt_right">82.5 (76.6-87.0)</td></tr>
    <tr><td class="gt_row gt_right">Aged 18-64</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.29 (0.23-0.36)</td>
<td class="gt_row gt_right">71.5 (63.9-77.5)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.28 (0.18-0.44)</td>
<td class="gt_row gt_right">71.8 (56.0-82.0)</td></tr>
    <tr><td class="gt_row gt_right">Aged 65 and over</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.24 (0.21-0.27)</td>
<td class="gt_row gt_right">76.4 (73.1-79.4)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.10 (0.08-0.14)</td>
<td class="gt_row gt_right">89.7 (86.4-92.2)</td></tr>
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
    <tr><td class="gt_row gt_right">BNT162b2-BNT162b2</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.00 (0.00-0.00)</td>
<td class="gt_row gt_right">99.9 (99.9-100.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.07 (0.04-0.13)</td>
<td class="gt_row gt_right">93.1 (86.7-96.4)</td></tr>
    <tr><td class="gt_row gt_right">ChAdOx1-ChAdOx1</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.20 (0.13-0.31)</td>
<td class="gt_row gt_right">79.8 (68.8-86.9)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.05 (0.02-0.11)</td>
<td class="gt_row gt_right">94.9 (88.8-97.6)</td></tr>
    <tr><td class="gt_row gt_right">Not Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.00 (0.00-0.00)</td>
<td class="gt_row gt_right">100.0 (100.0-100.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.00 (0.00-0.00)</td>
<td class="gt_row gt_right">100.0 (100.0-100.0)</td></tr>
    <tr><td class="gt_row gt_right">Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.21 (0.13-0.34)</td>
<td class="gt_row gt_right">78.8 (66.5-86.6)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.11 (0.06-0.19)</td>
<td class="gt_row gt_right">88.8 (80.6-93.5)</td></tr>
    <tr><td class="gt_row gt_right">Aged 18-64</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.26 (0.10-0.65)</td>
<td class="gt_row gt_right">74.0 (34.9-89.6)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.21 (0.07-0.68)</td>
<td class="gt_row gt_right">79.0 (32.4-93.5)</td></tr>
    <tr><td class="gt_row gt_right">Aged 65 and over</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.16 (0.11-0.23)</td>
<td class="gt_row gt_right">84.1 (76.7-89.2)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.05 (0.03-0.08)</td>
<td class="gt_row gt_right">95.2 (91.6-97.3)</td></tr>
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
    <tr><td class="gt_row gt_right">BNT162b2-BNT162b2</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.15 (0.14-0.17)</td>
<td class="gt_row gt_right">84.6 (82.6-86.3)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.15 (0.13-0.18)</td>
<td class="gt_row gt_right">84.8 (82.4-86.9)</td></tr>
    <tr><td class="gt_row gt_right">ChAdOx1-ChAdOx1</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.20 (0.18-0.23)</td>
<td class="gt_row gt_right">79.7 (77.3-81.7)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.19 (0.16-0.22)</td>
<td class="gt_row gt_right">81.0 (78.0-83.7)</td></tr>
    <tr><td class="gt_row gt_right">Not Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.18 (0.16-0.20)</td>
<td class="gt_row gt_right">82.1 (80.1-84.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.15 (0.13-0.18)</td>
<td class="gt_row gt_right">84.7 (82.3-86.8)</td></tr>
    <tr><td class="gt_row gt_right">Clinically Extremely Vulnerable</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.18 (0.16-0.20)</td>
<td class="gt_row gt_right">81.9 (79.7-84.0)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.19 (0.16-0.22)</td>
<td class="gt_row gt_right">81.4 (78.5-83.9)</td></tr>
    <tr><td class="gt_row gt_right">Aged 18-64</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.24 (0.20-0.30)</td>
<td class="gt_row gt_right">75.8 (70.0-80.5)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.28 (0.20-0.40)</td>
<td class="gt_row gt_right">71.5 (59.8-79.8)</td></tr>
    <tr><td class="gt_row gt_right">Aged 65 and over</td>
<td class="gt_row gt_right">1 - 28</td>
<td class="gt_row gt_right">0.17 (0.15-0.18)</td>
<td class="gt_row gt_right">83.3 (81.8-84.7)</td></tr>
    <tr><td class="gt_row gt_right"></td>
<td class="gt_row gt_right">29 - 70</td>
<td class="gt_row gt_right">0.16 (0.14-0.18)</td>
<td class="gt_row gt_right">84.1 (82.3-85.8)</td></tr>
  </tbody>
  
  
</table>
</div>
```

\newpage

#### Figure 1: Booster vaccination uptake, treatment group eligibility and matching success

Cumulative booster vaccination over the duration of the study period, by matching eligibility and matching success. Separately by primary vaccination course.

<img src="C:/Users/whulme/Documents/repos/booster-effectiveness/manuscript/figures/vaxdate-1.png" width="60%" height="50%"  />  

\newpage

#### Figure 2a: Estimated booster effectiveness (5 period)

For each outcome based on the fully adjusted model, the period-specific hazard ratios for boosting with BNT162b2 versus not boosting is shown, stratified by primary course. 

<img src="C:/Users/whulme/Documents/repos/booster-effectiveness/manuscript/figures/plot_effects-1.png" width="90%"  />

\newpage


#### Figure 2b: Estimated booster effectiveness (2 period splite at 28 days)

For each outcome based on the fully adjusted model, the period-specific hazard ratios for boosting with BNT162b2 versus not boosting is shown, stratified by primary course.

<img src="C:/Users/whulme/Documents/repos/booster-effectiveness/manuscript/figures/plot_effects28-1.png" width="90%"  />


\newpage 


#### Figure 2c: Estimated booster effectiveness (2 period split at 42 days)

For each outcome based on the fully adjusted model, the period-specific hazard ratios for boosting with BNT162b2 versus not boosting is shown, stratified by primary course.

<img src="C:/Users/whulme/Documents/repos/booster-effectiveness/manuscript/figures/plot_effects42-1.png" width="90%"  />

\newpage


## Figure 3: Kaplan-Meier incidence curves

<img src="C:/Users/whulme/Documents/repos/booster-effectiveness/manuscript/figures/plot_km-1.png" width="90%"  />
