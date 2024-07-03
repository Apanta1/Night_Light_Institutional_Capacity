clear
set more off
capture {
cd "/Users/apanta1/Desktop/Summer Research 2024"
log close
}

log using MainDataSet.log, replace

// Load data
import delimited "/Users/apanta1/Desktop/Summer Research 2024/Local_Gov_Dataset_of_Nepal.csv", clear

// removing empty rows
drop if missing(unit_name)

//droping municipality without data
drop if lisa_total_100_21_22 == "N/A"
replace lisa_total_100_20_21 = lisa_total_100_21_22 if lisa_total_100_20_21 == "N/A"


// replace lisa_total_100_20_21 =lisa_total_100_21_22 if lisa_total_100_20_21 == "N/A", 

// changing scores to numbers
destring lisa_total_100_20_21, replace


destring lisa_total_100_21_22, replace


egen baseline_nl = rowmean(sum_2014 sum_2015 sum_2016 sum_2017)

gen log_baseline_nl = log(baseline_nl)

generate chgnl = (log(sum_2021 - sum_2017))

generate chgnl_2 = (log(sum_2021) - log(sum_2017))

egen lisa_avg = rowmean(lisa_total_100_20_21 lisa_total_100_21_22)

gen ln_popn = log(popn_2021)

gen high_school_percent= (popn_highschool_and_equivalent/popn_2021) * 100

gen urban_num = 0
replace urban_num = 1 if unit_type != "Gaunpalika"

gen gov_coalitiion = 0
replace gov_coalitiion = 1 if politicalaffiliation == "CPN-MC" | politicalaffiliation == "CPN-UML" | politicalaffiliation == "FSFN" | politicalaffiliation == "NSP"

gen female = 0
replace female = 1 if sex =="Female"

gen over_65 = 0
replace over_65 = 1 if ageatelection > 65

gen ln_area = log(area_kmsq)

gen ln_educ = log(popn_highschool_and_equivalent)

// regressions

ssc install estout

* Run regression
// regress log_change_nl log_baseline_nl popn_2021 high_school_percent lisa_avg urban_num over_65

regress chgnl lisa_avg, r
eststo model1

regress chgnl lisa_avg log_baseline_nl ln_educ, r
eststo model2

regress chgnl lisa_avg log_baseline_nl ln_educ ln_popn, r

regress chgnl lisa_avg log_baseline_nl high_school_percent, r

regress chgnl_2 lisa_avg, r
eststo model1

regress chgnl_2 lisa_avg log_baseline_nl ln_educ, r
eststo model2

regress chgnl_2 lisa_avg log_baseline_nl ln_educ ln_popn, r

regress chgnl_2 lisa_avg log_baseline_nl high_school_percent, r


regress chgnl lisa_avg log_baseline_nl ln_popn ln_area ln_educ, r

regress chgnl lisa_avg log_baseline_nl ln_popn ln_area , r
eststo model3


regress chgnl lisa_avg log_baseline_nl ln_popn high_school_percent , r
eststo model4

regress chgnl lisa_avg log_baseline_nl ln_popn high_school_percent urban_num, r
eststo model5

regress chgnl lisa_avg log_baseline_nl ln_popn high_school_percent urban_num ageatelection, r
eststo model6

regress chgnl lisa_avg log_baseline_nl ln_popn high_school_percent urban_num ageatelection female, r
eststo model7

regress chgnl lisa_avg log_baseline_nl ln_popn high_school_percent urban_num ageatelection female gov_coalitiion, r
eststo model8

esttab model1 model2 model3 model4 model5 model6 model7 model8 using regression_table.txt, replace ///
b(3) se(3) t(3) star(* 0.10 ** 0.05 *** 0.01) ///
title("Regression Results") ///
keep(lisa_avg log_baseline_nl ln_popn urban_num gov_coalitiion ageatelection female high_school_percent _cons) ///
order(lisa_avg log_baseline_nl ln_popn high_school_percent urban_num gov_coalitiion ageatelection female  _cons) ///
stats(N r2, labels(Observations "R-squared")) ///

// use vif here to check multicollinearity

// //graphs

graph bar (mean) sum_2021 (mean) sum_2017 (mean) sum_2016 (mean) sum_2015 (mean) sum_2014 (mean) sum_2013 (mean) sum_2012


graph box chgnl, over(province)

summarize chgnl

graph box lisa_avg, over(province)

twoway (scatter chgnl lisa_avg) (lfit chgnl lisa_avg)

graph box high_school_percent, over(province)

twoway (scatter chgnl high_school_percent) (lfit chgnl high_school_percent)

graph box chgnl, over(female)

graph box ageatelection, over(province)

twoway (scatter chgnl ageatelection) (lfit chgnl ageatelection) 

scatter chgnl ageatelection if gov_coalitiion == 0, mcolor(red) || scatter chgnl ageatelection if gov_coalitiion == 1, mcolor(green)


