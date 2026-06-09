* Replication: NSS Report No. 595, CMS: E, 2025
*
* Replication of all key findings under the Highlights from the NSS 80th Round
* Comprehensive Modular Survey on Education (April-June 2025), published by MoSPI.
*
* Data
* 1. Go to https://microdata.gov.in/NADA/index.php/catalog/255
* 2. Click Get Microdata, then download Data in CSV
* 3. You will get three files:
*    - CMSE80HH25.csv    - household-level
*    - CMSE80PER25.csv   - individual household members
*    - CMSE80PERST25.csv - erstwhile members
*
* The codebook and variable documentation are available under the Downloads tab.
* Place all three CSVs in the same folder as this file and run it.

log using "cms_e_2025_replication.log", replace

putpdf begin
putpdf paragraph
putpdf text ("Replication: NSS Report No. 595, CMS: E, 2025")


* Setup - Person-Level Data

import delimited "CMSE80PER25.csv", clear

svyset fsu_serial_no [pw=mult], strata(stratum)

label define sec_lbl 1 "Rural" 2 "Urban"
label values sector sec_lbl

label define gen_lbl 1 "Male" 2 "Female" 3 "Transgender"
label values gender gen_lbl

keep if currently_enrolled_school == 1
keep if age >= 3 & age <= 35

recode school_type (4 5 = 4)
label define school_lbl 1 "Government" 2 "Private aided" 3 "Private unaided (rec)" 4 "Others", replace
label values school_type school_lbl

recode enrolment_level (15 = 0) (1/5 = 1) (6/8 = 2) (9/10 13 = 3) (11/12 14 = 4), gen(enrol_group)
label define enrol_grp_lbl 0 "Pre-primary" 1 "Primary" 2 "Middle" 3 "Secondary" 4 "Higher Secondary"
label values enrol_group enrol_grp_lbl


* Key Finding 1 - Distribution of Students by School Type

putpdf paragraph
putpdf text ("Key Finding 1: Distribution of Students by School Type")

svy: tabulate school_type sector, column percent format(%7.1f)

svy: tabulate school_type if sector == 1, percent format(%7.1f)
graph hbar (percent) [pw=mult] if sector == 1, over(school_type) title("Rural: Distribution by School Type") ytitle("") yscale(off) b1title("% of students") blabel(bar, format(%4.1f)) bar(1, color(blue)) bar(2, color(cranberry)) bar(3, color(green)) bar(4, color(gold)) name(rural_chart, replace)

svy: tabulate school_type if sector == 2, percent format(%7.1f)
graph hbar (percent) [pw=mult] if sector == 2, over(school_type) title("Urban: Distribution by School Type") ytitle("") yscale(off) b1title("% of students") blabel(bar, format(%4.1f)) bar(1, color(blue)) bar(2, color(cranberry)) bar(3, color(green)) bar(4, color(gold)) name(urban_chart, replace)

graph combine rural_chart urban_chart, title("Distribution of Students by School Type") ysize(4) xsize(8)
graph export "finding1_school_type.png", replace
putpdf image "finding1_school_type.png", width(6)


* Key Finding 2 - Expenditure on School Education
* Codes 13 and 14 excluded - including them increased discrepancy with report targets

putpdf paragraph
putpdf text ("Key Finding 2: Expenditure on School Education")

replace school_exp_total = 0 if school_expenditure_incurred == 2
replace hostel_fee_expenditure = 0 if missing(hostel_fee_expenditure)
gen total_school_exp = school_exp_total + hostel_fee_expenditure

gen reported_course_fee = (school_exp_course_fee > 0 & !missing(school_exp_course_fee))
gen course_fee_pct = reported_course_fee * 100

svy: mean course_fee_pct if !inlist(enrolment_level, 13, 14), over(enrol_group)
graph hbar (mean) course_fee_pct [pw=mult] if !inlist(enrolment_level, 13, 14), over(enrol_group) title("Course Fee by Enrolment Level") ytitle("") yscale(off) b1title("% of students") blabel(bar, format(%4.1f)) name(fee_level, replace)

svy: mean course_fee_pct if !inlist(enrolment_level, 13, 14), over(school_type)
graph hbar (mean) course_fee_pct [pw=mult] if !inlist(enrolment_level, 13, 14), over(school_type) title("Course Fee by School Type") ytitle("") yscale(off) b1title("% of students") blabel(bar, format(%4.1f)) name(fee_school, replace)

graph combine fee_level fee_school, title("Expenditure on School Education") ysize(4) xsize(8)
graph export "finding2_course_fee.png", replace
putpdf image "finding2_course_fee.png", width(6)

svy: mean total_school_exp if !inlist(enrolment_level, 13, 14)
matrix b = e(b)
putpdf paragraph
putpdf text ("Avg expenditure overall: Rs. " + string(b[1,1], "%6.0f"))

svy: mean total_school_exp if !inlist(enrolment_level, 13, 14), over(school_type)
matrix b = e(b)
putpdf paragraph
putpdf text ("Avg expenditure - Government: Rs. " + string(b[1,1], "%6.0f"))
putpdf paragraph
putpdf text ("Avg expenditure - Private aided: Rs. " + string(b[1,2], "%6.0f"))
putpdf paragraph
putpdf text ("Avg expenditure - Private unaided: Rs. " + string(b[1,3], "%6.0f"))
putpdf paragraph
putpdf text ("Avg expenditure - Others: Rs. " + string(b[1,4], "%6.0f"))

svy: mean total_school_exp if !inlist(enrolment_level, 13, 14), over(sector)
matrix b = e(b)
putpdf paragraph
putpdf text ("Avg expenditure - Rural: Rs. " + string(b[1,1], "%6.0f"))
putpdf paragraph
putpdf text ("Avg expenditure - Urban: Rs. " + string(b[1,2], "%6.0f"))

gen non_govt = (school_type != 1)
svy: mean total_school_exp if !inlist(enrolment_level, 13, 14) & sector == 1, over(non_govt)
matrix b = e(b)
putpdf paragraph
putpdf text ("Avg expenditure Rural - Govt: Rs. " + string(b[1,1], "%6.0f"))
putpdf paragraph
putpdf text ("Avg expenditure Rural - Non-govt: Rs. " + string(b[1,2], "%6.0f"))

svy: mean total_school_exp if !inlist(enrolment_level, 13, 14) & sector == 2, over(non_govt)
matrix b = e(b)
putpdf paragraph
putpdf text ("Avg expenditure Urban - Govt: Rs. " + string(b[1,1], "%6.0f"))
putpdf paragraph
putpdf text ("Avg expenditure Urban - Non-govt: Rs. " + string(b[1,2], "%6.0f"))

graph hbar (mean) total_school_exp [pw=mult] if !inlist(enrolment_level, 13, 14), over(school_type) title("Avg Expenditure per Student by School Type") ytitle("") yscale(off) b1title("Expenditure (in Rs.)") blabel(bar, format(%6.0f)) bar(1, color(sand)) bar(2, color(sand)) bar(3, color(sand)) bar(4, color(sand)) name(exp_type, replace)
graph export "finding2_exp_by_school_type.png", replace
putpdf image "finding2_exp_by_school_type.png", width(4)


* Key Finding 3 - Private Coaching
* Codes 13 and 14 included - including them removed discrepancy in secondary and higher secondary entirely

putpdf paragraph
putpdf text ("Key Finding 3: Private Coaching")

replace private_coaching_exp_total = 0 if received_private_coaching == 2
replace private_coaching_exp_total = 0 if private_coaching_expenditure_inc == 2

gen takes_coaching = (received_private_coaching == 1) if inlist(received_private_coaching, 1, 2)
gen coaching_pct = takes_coaching * 100

svy: mean coaching_pct
matrix b = e(b)
putpdf paragraph
putpdf text ("% taking coaching overall: " + string(b[1,1], "%4.1f") + "%")

svy: mean coaching_pct, over(sector)
matrix b = e(b)
putpdf paragraph
putpdf text ("% taking coaching - Rural: " + string(b[1,1], "%4.1f") + "%")
putpdf paragraph
putpdf text ("% taking coaching - Urban: " + string(b[1,2], "%4.1f") + "%")

svy: mean coaching_pct, over(enrol_group)
graph hbar (mean) coaching_pct [pw=mult], over(enrol_group) title("Private Coaching by Enrolment Level") ytitle("") yscale(off) b1title("% of students") blabel(bar, format(%4.1f)) name(coaching_level, replace)
graph export "finding3_coaching_by_level.png", replace
putpdf image "finding3_coaching_by_level.png", width(4)

svy: mean private_coaching_exp_total
matrix b = e(b)
putpdf paragraph
putpdf text ("Avg coaching expenditure overall: Rs. " + string(b[1,1], "%6.0f"))

svy: mean private_coaching_exp_total, over(gender)
matrix b = e(b)
putpdf paragraph
putpdf text ("Avg coaching expenditure - Male: Rs. " + string(b[1,1], "%6.0f"))
putpdf paragraph
putpdf text ("Avg coaching expenditure - Female: Rs. " + string(b[1,2], "%6.0f"))

svy: mean private_coaching_exp_total if sector == 1, over(enrol_group)
graph hbar (mean) private_coaching_exp_total [pw=mult] if sector == 1, over(enrol_group) title("Avg Coaching Expenditure by Level - Rural") ytitle("") yscale(off) b1title("Expenditure (in Rs.)") blabel(bar, format(%6.0f)) bar(1, color(sand)) bar(2, color(sand)) bar(3, color(sand)) bar(4, color(sand)) bar(5, color(sand)) name(coaching_rural, replace)

svy: mean private_coaching_exp_total if sector == 2, over(enrol_group)
graph hbar (mean) private_coaching_exp_total [pw=mult] if sector == 2, over(enrol_group) title("Avg Coaching Expenditure by Level - Urban") ytitle("") yscale(off) b1title("Expenditure (in Rs.)") blabel(bar, format(%6.0f)) bar(1, color(sand)) bar(2, color(sand)) bar(3, color(sand)) bar(4, color(sand)) bar(5, color(sand)) name(coaching_urban, replace)

graph combine coaching_rural coaching_urban, title("Avg Coaching Expenditure by Enrolment Level") ysize(4) xsize(8)
graph export "finding3_coaching_exp_by_level.png", replace
putpdf image "finding3_coaching_exp_by_level.png", width(6)

* Key Finding 4 - Sources of Funding

putpdf paragraph
putpdf text ("Key Finding 4: Sources of Funding")

gen single_source = (funding_source_2 == 99) if !missing(funding_source_1)
gen single_source_pct = single_source * 100
gen funded_by_household = (funding_source_1 == 2) if !missing(funding_source_1)
gen funded_by_household_pct = funded_by_household * 100

svy: mean funded_by_household_pct
matrix b = e(b)
putpdf paragraph
putpdf text ("% funded by other household members (first major source): " + string(b[1,1], "%4.1f") + "%")

svy: mean single_source_pct if gender == 1 & sector == 1
local m_rural = e(b)[1,1]
svy: mean single_source_pct if gender == 1 & sector == 2
local m_urban = e(b)[1,1]
svy: mean single_source_pct if gender == 1
local m_total = e(b)[1,1]

svy: mean single_source_pct if gender == 2 & sector == 1
local f_rural = e(b)[1,1]
svy: mean single_source_pct if gender == 2 & sector == 2
local f_urban = e(b)[1,1]
svy: mean single_source_pct if gender == 2
local f_total = e(b)[1,1]

svy: mean single_source_pct if sector == 1
local p_rural = e(b)[1,1]
svy: mean single_source_pct if sector == 2
local p_urban = e(b)[1,1]
svy: mean single_source_pct
local p_total = e(b)[1,1]

preserve
clear

set obs 3
gen x = .
gen rural = .
gen urban = .
gen total = .

replace x = 1 in 1
replace x = 2 in 2
replace x = 3 in 3

replace rural = `m_rural' in 1
replace urban = `m_urban' in 1
replace total = `m_total' in 1

replace rural = `f_rural' in 2
replace urban = `f_urban' in 2
replace total = `f_total' in 2

replace rural = `p_rural' in 3
replace urban = `p_urban' in 3
replace total = `p_total' in 3

graph bar rural urban total, over(x, relabel(1 "Male" 2 "Female" 3 "Person")) title("% with Single Source of Funding") ytitle("% of students") ylabel(80(4)96, angle(0)) blabel(bar, format(%4.1f)) bar(1, color(blue)) bar(2, color(orange)) bar(3, color(gray)) legend(order(1 "Rural" 2 "Urban" 3 "Rural+Urban"))
graph export "finding4_sources_funding.png", replace
restore

putpdf image "finding4_sources_funding.png", width(5)

* Key Finding 5 - Erstwhile Members Currently Attending School Education

putpdf paragraph
putpdf text ("Key Finding 5: Erstwhile Members Currently Attending School Education")

import delimited "CMSE80HH25.csv", clear

svyset fsu_serial_no [pw=mult], strata(stratum)

label define sec_lbl 1 "Rural" 2 "Urban"
label values sector sec_lbl

gen has_erstwhile = (any_member_attending_school == 1) if !missing(any_member_attending_school)
gen has_erstwhile_pct = has_erstwhile * 100

svy: mean has_erstwhile_pct
matrix b = e(b)
putpdf paragraph
putpdf text ("% households with erstwhile member attending school: " + string(b[1,1], "%4.1f") + "%")

svy: mean has_erstwhile_pct, over(sector)
matrix b = e(b)
putpdf paragraph
putpdf text ("% households - Rural: " + string(b[1,1], "%4.1f") + "%")
putpdf paragraph
putpdf text ("% households - Urban: " + string(b[1,2], "%4.1f") + "%")

import delimited "CMSE80PERST25.csv", clear

svyset fsu_serial_no [pw=mult], strata(stratum)

label define sec_lbl 1 "Rural" 2 "Urban"
label values sector sec_lbl

replace total_education_expenditure = 0 if any_expenditure_incurred == 2

collapse (sum) total_education_expenditure (first) mult sector stratum, by(fsu_serial_no second_stage_stratum_no sample_hhld_no)

svyset fsu_serial_no [pw=mult], strata(stratum)

label define sec_lbl 1 "Rural" 2 "Urban", replace
label values sector sec_lbl

svy: mean total_education_expenditure
matrix b = e(b)
putpdf paragraph
putpdf text ("Avg expenditure on erstwhile member per household overall: Rs. " + string(b[1,1], "%6.0f"))

local total = e(b)[1,1]

svy: mean total_education_expenditure if sector == 1
matrix b = e(b)
putpdf paragraph
putpdf text ("Avg expenditure - Rural: Rs. " + string(b[1,1], "%6.0f"))
local rural = e(b)[1,1]

svy: mean total_education_expenditure if sector == 2
matrix b = e(b)
putpdf paragraph
putpdf text ("Avg expenditure - Urban: Rs. " + string(b[1,1], "%6.0f"))
local urban = e(b)[1,1]

preserve
clear
set obs 3
gen sector_order = .
gen sector_lbl = ""
gen exp = .

replace sector_order = 1 in 1
replace sector_order = 2 in 2
replace sector_order = 3 in 3

replace sector_lbl = "Rural"       in 1
replace sector_lbl = "Urban"       in 2
replace sector_lbl = "Rural+Urban" in 3

replace exp = `rural' in 1
replace exp = `urban' in 2
replace exp = `total' in 3

graph bar exp, over(sector_order, relabel(1 "Rural" 2 "Urban" 3 "Rural+Urban")) title("Avg Expenditure on Erstwhile Member per Household") ytitle("Expenditure (in Rs.)") blabel(bar, format(%6.0f)) bar(1, color(blue)) bar(2, color(blue)) bar(3, color(blue)) name(erstwhile_exp, replace)
graph export "finding5_erstwhile_exp.png", replace
restore

putpdf image "finding5_erstwhile_exp.png", width(4)

putpdf save "cms_e_2025_report.pdf", replace

log close