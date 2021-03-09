version 15
clear all
set linesize 80
macro drop _all
set matsize 2000

*******************************************************************************
*                            APPENDIX TABLES                                  *
*******************************************************************************
global controls0 democrat female exp_6to10 exp_more10
global controls1 defense legal_rep inst

// Table A1
gen day = doy(hearing_date)
gen muslim_pre = 0
replace muslim_pre = day*muslim_ctry

preserve
keep if abs(hearing_date - td(11sep2001)) <= 180
reg a_relief muslim_pre muslim_post911 post911 muslim_ctry $controls1 mtemp i.judge_id i.city_id i.month , vce(cluster nat_name2)
restore

// Table A2
bysort judge_id: egen tot_arelief2 = total(a_relief)
gen lom_arelief = (tot_arelief2 - a_relief)/(_N - 1)

reg lom_arelief muslim_ctry i.city_id if !missing(democrat) & !missing(female) & !missing(exp_6to10) & !missing(legal_rep) & !missing(inst) & !missing(defense)

// Table A3
preserve
keep if abs(hearing_date - td(11sep2001)) <= 180
quietly reg a_relief muslim_ctry post911 muslim_post911  $controls1 mtemp i.judge_id i.city_id i.month , vce(cluster nat_name2)
restore

// Table A4
preserve
keep if abs(hearing_date - td(11sep2001)) <= 180

// no controls - interaction
quietly logit a_relief muslim_ctry post911 if !missing(mtemp) & !missing(judge_id), vce(cluster nat_name2)
quietly margins, dydx(*) post

// no controls + interaction
quietly logit a_relief muslim_ctry post911 muslim_post911 if !missing(mtemp) & !missing(judge_id), vce(cluster nat_name2)
quietly margins, dydx(*) post

// all controls + city, judge fe
quietly logit a_relief muslim_ctry post911 muslim_post911 $controls1 mtemp i.judge_id i.city_id, vce(cluster nat_name2)
quietly margins, dydx(*) post

// all controls + city, judge fe
quietly logit a_relief muslim_ctry post911 muslim_post911 $controls1 mtemp i.judge_id i.city_id i.month, vce(cluster nat_name2)
quietly margins, dydx(*) post

// all controls + fe
quietly logit a_relief muslim_ctry post911 muslim_post911  $controls1 mtemp i.judge_id i.city_id i.month , vce(cluster nat_name2)
quietly margins, dydx(*) post

restore

// Table A5
preserve
keep if abs(hearing_date - td(11sep2001)) <= 180

// no controls - interaction
quietly probit a_relief muslim_ctry post911 if !missing(mtemp) & !missing(judge_id), vce(cluster nat_name2)
quietly margins, dydx(*) post

// no controls + interaction
quietly probit a_relief muslim_ctry post911 muslim_post911 if !missing(mtemp) & !missing(judge_id), vce(cluster nat_name2)
quietly margins, dydx(*) post

// all controls + city, judge fe
quietly probit a_relief muslim_ctry post911 muslim_post911 $controls1 mtemp i.judge_id i.city_id, vce(cluster nat_name2)
quietly margins, dydx(*) post

// all controls + fe
quietly probit a_relief muslim_ctry post911 muslim_post911 $controls1 mtemp i.judge_id i.city_id i.month, vce(cluster nat_name2)
quietly margins, dydx(*) post

restore

// Table A6
preserve
keep if abs(hearing_date - td(11sep2000)) <= 180

// no controls - interaction
quietly reg a_relief muslim_ctry plac911 if !missing(mtemp) & !missing(judge_id), vce(cluster nat_name2)
// no controls + interaction
quietly reg a_relief muslim_ctry plac911 muslim_plac911 if !missing(mtemp) & !missing(judge_id), vce(cluster nat_name2)
// individual controls
quietly reg a_relief muslim_ctry plac911 muslim_plac911 $controls1 mtemp i.judge_id i.city_id, vce(cluster nat_name2)
// all controls + fe
quietly reg a_relief muslim_ctry plac911 muslim_plac911 $controls1 mtemp i.judge_id i.city_id i.month , vce(cluster nat_name2)

// no controls - interaction
quietly reg a_relief terror_ctry plac911 if !missing(mtemp) & !missing(judge_id), vce(cluster nat_name2)
// no controls + interaction
quietly reg a_relief terror_ctry plac911 terror_plac911 if !missing(mtemp) & !missing(judge_id), vce(cluster nat_name2)
// individual controls
quietly reg a_relief terror_ctry plac911 terror_plac911 $controls1 mtemp i.judge_id i.city_id, vce(cluster nat_name2)
// all controls + fe
quietly reg a_relief terror_ctry plac911 terror_plac911 $controls1 mtemp i.judge_id i.city_id i.month, vce(cluster nat_name2)

restore

// Table A7
preserve
keep if abs(hearing_date - td(11mar2003)) <= 180

// no controls - interaction
quietly reg a_relief muslim_ctry plac311 if !missing(mtemp) & !missing(judge_id), vce(cluster nat_name2)
// no controls + interaction
quietly reg a_relief muslim_ctry plac311 muslim_plac311 if !missing(mtemp) & !missing(judge_id), vce(cluster nat_name2)
// individual controls
quietly reg a_relief muslim_ctry plac311 muslim_plac311  $controls1 mtemp i.judge_id i.city_id, vce(cluster nat_name2)
// all controls + fe
quietly reg a_relief muslim_ctry plac311 muslim_plac311  $controls1 mtemp i.judge_id i.city_id i.month, vce(cluster nat_name2)

restore

// Table A8
preserve
keep if abs(hearing_date - td(11sep2001)) <= 180

// no controls - interaction
quietly reg a_relief2 muslim_ctry post911 if !missing(mtemp) & !missing(judge_id), vce(cluster nat_name2)
// no controls + interaction
quietly reg a_relief2 muslim_ctry post911 muslim_post911 if !missing(mtemp) & !missing(judge_id), vce(cluster nat_name2)
// all controls + city, judge fe
quietly reg a_relief2 muslim_ctry post911 muslim_post911  $controls1 mtemp i.judge_id i.city_id, vce(cluster nat_name2)
// all controls + fe
quietly reg a_relief2 muslim_ctry post911 muslim_post911  $controls1 mtemp i.judge_id i.city_id i.month, vce(cluster nat_name2)

restore

// Table A9
preserve
keep if abs(hearing_date - td(11sep2001)) <= 180

// no controls - interaction
quietly reg a_relief muslim_ctry_75 post911 if !missing(mtemp) & !missing(judge_id), vce(cluster nat_name2)
// no controls + interaction
quietly reg a_relief muslim_ctry_75 post911 muslim75_post911 if !missing(mtemp) & !missing(judge_id), vce(cluster nat_name2)
// all controls + city, judge fe
quietly reg a_relief muslim_ctry_75 post911 muslim75_post911 $controls1 mtemp i.judge_id i.city_id, vce(cluster nat_name2)
// all controls + city, judge, month fe
quietly reg a_relief muslim_ctry_75 post911 muslim75_post911 $controls1 mtemp i.judge_id i.city_id i.month, vce(cluster nat_name2)

restore
