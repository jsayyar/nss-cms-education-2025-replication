# Replication: NSS Report No. 595 - CMS: Education, 2025

Replication of all key findings (Highlights, pp. v-viii) from the NSS 80th Round 
Comprehensive Modular Survey on Education (April-June 2025), published by MoSPI.

## Source Report

NSS Report No. 595: Comprehensive Modular Survey: Education, 2025.
Available at: https://www.mospi.gov.in/publications-reports
Accessed: 09 June 2026. Pages v-viii.

## Data

Unit-level microdata is available from:
https://microdata.gov.in/NADA/index.php/catalog/255

Click Get Microdata, then download Data in CSV. You will get three files:
- CMSE80HH25.csv    - household-level
- CMSE80PER25.csv   - individual household members
- CMSE80PERST25.csv - erstwhile members

The data is not included in this repository due to data use restrictions.
The codebook and variable documentation are available under the Downloads tab.

## How to Run

Place all three CSVs in the same folder as the .do file and run:
Highlights_Key_Findings.do

This will produce:
- cms_e_2025_replication.log
- cms_e_2025_report.pdf
- finding1_school_type.png through finding5_erstwhile_exp.png

## Results

Pre-run outputs are included in this repository for reference:
- cms_e_2025_report.pdf - compiled results with charts
- cms_e_2025_replication.log - full Stata output

## Replication Notes

All key findings are successfully replicated. Minor deviations in expenditure 
figures were observed.

Two methodological notes from the replication process:
- Key Finding 2 (Expenditure): Diploma/certificate enrolment codes 13 and 14 
  are excluded. Including them increased discrepancy with report targets.
- Key Finding 3 (Private Coaching): Codes 13 and 14 are included. Including 
  them removed the discrepancy in secondary and higher secondary figures entirely.
- Key Finding 5 (Erstwhile Members): Household percentage figures replicate 
  exactly. Expenditure figures show a ~10% gap for rural and overall; urban 
  replicates closely. The gap is likely due to an undisclosed internal 
  aggregation method used by NSS for this subgroup.
