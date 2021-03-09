version 15
clear all
set linesize 80
macro drop _all
set matsize 2000

*******************************************************************************
*                                     TABLES                                  *
*******************************************************************************

global controls0 democrat female exp_6to10 exp_more10
global controls1 defense legal_rep inst

// Table 1
estpost summarize a_relief muslim_ctry ///
sum_terror $controls1 $controls0 exp_0to5, listwise

// Table 2
preserve
keep if abs(hearing_date - td(11sep2001)) <= 180
// no controls - interaction
quietly reg a_relief muslim_ctry post911 if !missing(mtemp) & !missing(judge_id), vce(cluster nat_name2)
// no controls + interaction
quietly reg a_relief muslim_ctry post911 muslim_post911 if !missing(mtemp) & !missing(judge_id), vce(cluster nat_name2)
// all controls + city, judge fe
quietly reg a_relief muslim_ctry post911 muslim_post911  $controls1 mtemp i.judge_id i.city_id, vce(cluster nat_name2)
// all controls + city, judge, month fe
quietly reg a_relief muslim_ctry post911 muslim_post911  $controls1 mtemp i.judge_id i.city_id i.month, vce(cluster nat_name2)
restore

// Table 3
preserve
keep if abs(hearing_date - td(11sep2001)) <= 180
// no controls - interaction
quietly reg a_relief terror_ctry post911 if !missing(mtemp) & !missing(judge_id), vce(cluster nat_name2)
// no controls + interaction
quietly reg a_relief terror_ctry post911 terror_post911 if !missing(mtemp) & !missing(judge_id), vce(cluster nat_name2)
// all controls + city, judge fe
quietly reg a_relief terror_ctry post911 terror_post911 $controls1 mtemp i.judge_id i.city_id, vce(cluster nat_name2)
// all controls + city, judge, month fe
quietly reg a_relief terror_ctry post911 terror_post911  $controls1 mtemp i.judge_id i.city_id i.month, vce(cluster nat_name2)
restore

// Table 4
preserve
keep if abs(hearing_date - td(11mar2004)) <= 180
// no controls - interaction
quietly reg a_relief muslim_ctry post311 if !missing(mtemp) & !missing(judge_id), vce(cluster nat_name2)
// no controls + interaction
quietly reg a_relief muslim_ctry post311 muslim_post311 if !missing(mtemp) & !missing(judge_id), vce(cluster nat_name2)
// individual controls
quietly reg a_relief muslim_ctry post311 muslim_post311  $controls1 mtemp i.judge_id i.city_id, vce(cluster nat_name2)
// individual controls
quietly reg a_relief muslim_ctry post311 muslim_post311  $controls1 mtemp i.judge_id i.city_id i.month, vce(cluster nat_name2)
restore

// Table 5
// Columns 1-4
preserve
keep if abs(hearing_date - td(11sep2001)) <= 90
// all controls + fe
quietly reg a_relief muslim_ctry post911 muslim_post911  $controls1 mtemp i.judge_id i.city_id i.month, vce(cluster nat_name2)
restore

preserve
keep if abs(hearing_date - td(11sep2001)) <= 180
// all controls + fe
quietly reg a_relief muslim_ctry post911 muslim_post911  $controls1 mtemp i.judge_id i.city_id i.month, vce(cluster nat_name2)
restore

preserve
keep if abs(hearing_date - td(11sep2001)) <= 270
// all controls + fe
quietly reg a_relief muslim_ctry post911 muslim_post911  $controls1 mtemp i.judge_id i.city_id i.month, vce(cluster nat_name2)
restore


// Columns 5-8
preserve
keep if abs(hearing_date - td(11sep2001)) <= 90
// all controls + fe
quietly reg a_relief terror_ctry post911 terror_post911  $controls1 mtemp i.judge_id i.city_id i.month, vce(cluster nat_name2)
restore

preserve
keep if abs(hearing_date - td(11sep2001)) <= 180
// all controls + fe
quietly reg a_relief terror_ctry post911 terror_post911  $controls1 mtemp i.judge_id i.city_id i.month, vce(cluster nat_name2)
restore


preserve
keep if abs(hearing_date - td(11sep2001)) <= 365
// all controls + fe
quietly reg a_relief terror_ctry post911 terror_post911  $controls1 mtemp i.judge_id i.city_id i.month, vce(cluster nat_name2)
restore

// Table 6
preserve
keep if abs(hearing_date - td(11sep2001)) <= 90
// individual and judge controls
quietly reg a_relief muslim_ctry##post911##democrat  $controls1 $controls0 mtemp i.city_id i.month , vce(cluster nat_name2)
restore

preserve
keep if abs(hearing_date - td(11sep2001)) <= 180
// individual and judge controls
quietly reg a_relief muslim_ctry##post911##democrat  $controls1 $controls0 mtemp i.city_id i.month , vce(cluster nat_name2)
restore

preserve
keep if abs(hearing_date - td(11sep2001)) <= 270
// individual and judge controls
quietly reg a_relief muslim_ctry##post911##democrat  $controls1 $controls0 mtemp i.city_id i.month , vce(cluster nat_name2)
restore

preserve
keep if abs(hearing_date - td(11sep2001)) <= 365
// individual and judge controls
quietly reg a_relief muslim_ctry##post911##democrat  $controls1 $controls0 mtemp i.city_id i.month , vce(cluster nat_name2)
restore

*******************************************************************************
*                                  FIGURES                                    *
*******************************************************************************
// Figure #1
preserve
collapse a_relief, by(hmonth muslim_ctry)
gen str arab = ""
replace arab = "Non-Muslim Country" if muslim_ctry == 0 & hmonth == 518
replace arab = "Muslim Country" if muslim_ctry == 1 & hmonth == 530
cd "$path/Work/Paper JEBO/figures/"
twoway (scatter a_relief hmonth if muslim_ctry == 1, mlabel(arab) mlabposition(12)) ///
(scatter a_relief hmonth if muslim_ctry == 0, mlabel(arab) mlabposition(6)) ///
(lfit a_relief hmonth if muslim_ctry == 1 & hmonth < 500) ///
(lfit a_relief hmonth if muslim_ctry == 1 & hmonth >= 500) ///
(lfit a_relief hmonth if muslim_ctry == 0 & hmonth < 500) ///
(lfit a_relief hmonth if muslim_ctry == 0 & hmonth >= 500) , ///
legend(off) ///
ytitle("Average monthly proportion of asylum relief") ///
xtitle("") ///
xline(500)
restore

// Figure #2
preserve
collapse a_relief, by(hmonth terror_ctry)
gen str terr = ""
replace terr = "Unassociated Country" if terror_ctry == 0 & hmonth == 512
replace terr = "Associated Country" if terror_ctry == 1 & hmonth == 530
cd "$path/Work/Paper JEBO/figures/"
twoway (scatter a_relief hmonth if terror_ctry == 1, mlabel(terr) mlabposition(12)) ///
(scatter a_relief hmonth if terror_ctry == 0, mlabel(terr) mlabposition(6)) ///
(lfit a_relief hmonth if terror_ctry == 1 & hmonth < 500) ///
(lfit a_relief hmonth if terror_ctry == 1 & hmonth >= 500) ///
(lfit a_relief hmonth if terror_ctry == 0 & hmonth < 500) ///
(lfit a_relief hmonth if terror_ctry == 0 & hmonth >= 500) , ///
legend(off) ///
ytitle("Average monthly proportion of asylum relief") ///
xtitle("") ///
xline(500)
restore
