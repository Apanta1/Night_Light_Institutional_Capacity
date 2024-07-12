clear
set more off
capture {
cd "/Users/apanta1/Desktop/Summer Research 2024/Night_Light_Institutional_Capacity/Stata"
log close
}

log using MainDataSet.log, replace

// Load data
import delimited "/Users/apanta1/Desktop/Summer Research 2024/Night_Light_Institutional_Capacity/Stata/Local_Gov_Dataset_of_Nepal.csv", clear

// removing empty rows
drop if missing(unit_name)

//droping municipality without data
drop if lisa_20_21 == "N/A"
drop if lisa_21_22 == "N/A"

// replace lisa_total_100_20_21 =lisa_total_100_21_22 if lisa_total_100_20_21 == "N/A", 

// changing scores to numbers
destring lisa_20_21, replace
destring lisa_21_22, replace


egen baseline_nl = rowmean(sum_2014 sum_2015 sum_2016 sum_2017)

gen log_baseline_nl = log(baseline_nl)

generate rel_chgnl  = (log(sum_2021) - log(sum_2017))

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

egen lisa_avg = rowmean(lisa_20_21 lisa_21_22)


//initial regression

regress rel_chgnl  log_baseline_nl, r
outreg2 using v3_intial_regression.doc, replace dec(3)

regress rel_chgnl  log_baseline_nl lisa_avg, r
outreg2 using v3_intial_regression.doc, append dec(3)

regress rel_chgnl  log_baseline_nl lisa_avg high_school_percent, r
outreg2 using v3_intial_regression.doc, append dec(3)

regress rel_chgnl  log_baseline_nl lisa_avg high_school_percent, r
outreg2 using v3_intial_regression.doc, append dec(3)

regress rel_chgnl  log_baseline_nl lisa_avg high_school_percent ageatelection, r
outreg2 using v3_intial_regression.doc, append dec(3)

regress rel_chgnl  log_baseline_nl lisa_avg high_school_percent ageatelection gov_coalitiion, r
outreg2 using v3_intial_regression.doc, append dec(3)

regress rel_chgnl  log_baseline_nl lisa_avg high_school_percent ageatelection gov_coalitiion female, r
outreg2 using v3_intial_regression.doc, append dec(3)

regress rel_chgnl  log_baseline_nl lisa_avg high_school_percent ageatelection gov_coalitiion female ln_popn, r
outreg2 using v3_intial_regression.doc, append dec(3)

// lisa average calculations

egen gov_magm_avg = rowmean(gov_magm_20_21 gov_magm_21_22)
egen org_admin_avg = rowmean(org_admin_20_21 org_admin_21_22)
egen budg_magm_avg = rowmean(budg_magm_20_21 budg_magm_21_22)
egen fiscal_magm_avg = rowmean(fiscal_magm_20_21 fiscal_magm_21_22)
egen service_dev_avg = rowmean(service_dev_20_21 service_dev_21_22)
egen jud_exe_avg = rowmean(jud_exe_20_21 jud_exe_21_22)
egen phy_infra_avg = rowmean(phy_infra_20_21 phy_infra_21_22)
egen soc_inc_avg = rowmean(soc_inc_20_21 soc_inc_21_22)
egen env_protec_avg = rowmean(env_protec_20_21 env_protec_21_22)
egen cop_cor_avg = rowmean(cop_cor_20_21 cop_cor_21_22)


//regressions in LISA breakdown

regress rel_chgnl  log_baseline_nl, r
outreg2 using v3_lisa_regression.doc, replace dec(3)

regress rel_chgnl  log_baseline_nl gov_magm_avg, r
outreg2 using v3_lisa_regression.doc, append dec(3)

regress rel_chgnl  log_baseline_nl gov_magm_avg org_admin_avg, r
outreg2 using v3_lisa_regression.doc, append dec(3)

regress rel_chgnl  log_baseline_nl gov_magm_avg org_admin_avg budg_magm_avg, r
outreg2 using v3_lisa_regression.doc, append dec(3)

regress rel_chgnl  log_baseline_nl gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg, r
outreg2 using v3_lisa_regression.doc, append dec(3)

regress rel_chgnl  log_baseline_nl gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg, r
outreg2 using v3_lisa_regression.doc, append dec(3)

regress rel_chgnl  log_baseline_nl gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg, r
outreg2 using v3_lisa_regression.doc, append dec(3)

regress rel_chgnl  log_baseline_nl gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg, r
outreg2 using v3_lisa_regression.doc, append dec(3)

regress rel_chgnl  log_baseline_nl gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg, r
outreg2 using v3_lisa_regression.doc, append dec(3)

regress rel_chgnl  log_baseline_nl gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg, r
outreg2 using v3_lisa_regression.doc, append dec(3)

regress rel_chgnl  log_baseline_nl gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg cop_cor_avg, r
outreg2 using v3_lisa_regression.doc, append dec(3)

regress rel_chgnl  log_baseline_nl gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg cop_cor_avg high_school_percent, r
outreg2 using v3_lisa_regression.doc, append dec(3)

// revised regression

regress rel_chgnl  log_baseline_nl, r
outreg2 using v3_revised_regression.doc, replace dec(3)

regress rel_chgnl  log_baseline_nl phy_infra_avg, r
outreg2 using v3_revised_regression.doc, append dec(3)

regress rel_chgnl  log_baseline_nl phy_infra_avg cop_cor_avg, r
outreg2 using v3_revised_regression.doc, append dec(3)

regress rel_chgnl  log_baseline_nl phy_infra_avg cop_cor_avg high_school_percent, r
outreg2 using v3_revised_regression.doc, append dec(3)

regress rel_chgnl  log_baseline_nl phy_infra_avg cop_cor_avg high_school_percent ageatelection, r
outreg2 using v3_revised_regression.doc, append dec(3)

regress rel_chgnl  log_baseline_nl phy_infra_avg cop_cor_avg high_school_percent ageatelection female, r
outreg2 using v3_revised_regression.doc, append dec(3)

regress rel_chgnl  log_baseline_nl phy_infra_avg cop_cor_avg high_school_percent ageatelection female, r
outreg2 using v3_revised_regression.doc, append dec(3)

regress rel_chgnl  log_baseline_nl phy_infra_avg cop_cor_avg high_school_percent ageatelection female gov_coalitiion, r
outreg2 using v3_revised_regression.doc, append dec(3)

regress rel_chgnl  log_baseline_nl phy_infra_avg cop_cor_avg high_school_percent ageatelection female gov_coalitiion ln_popn, r
outreg2 using v3_revised_regression.doc, append dec(3)




//
// regress rel_chgnl  lisa_avg log_baseline_nl ln_educ ln_popn, r
//
// regress rel_chgnl  lisa_avg log_baseline_nl high_school_percent, r
//
// regress rel_chgnl _2 lisa_avg, r
// eststo model1
//
// regress rel_chgnl _2 lisa_avg log_baseline_nl ln_educ, r
// eststo model2
//
// regress rel_chgnl _2 lisa_avg log_baseline_nl ln_educ ln_popn, r
//
// regress rel_chgnl _2 lisa_avg log_baseline_nl high_school_percent, r
//
//
// regress rel_chgnl  lisa_avg log_baseline_nl ln_popn ln_area ln_educ, r
//
// regress rel_chgnl  lisa_avg log_baseline_nl ln_popn ln_area , r
// eststo model3
//
//
// regress rel_chgnl  lisa_avg log_baseline_nl ln_popn high_school_percent , r
// eststo model4
//
// regress rel_chgnl  lisa_avg log_baseline_nl ln_popn high_school_percent urban_num, r
// eststo model5
//
// regress rel_chgnl  lisa_avg log_baseline_nl ln_popn high_school_percent urban_num ageatelection, r
// eststo model6
//
// regress rel_chgnl  lisa_avg log_baseline_nl ln_popn high_school_percent urban_num ageatelection female, r
// eststo model7
//
// regress rel_chgnl  lisa_avg log_baseline_nl ln_popn high_school_percent urban_num ageatelection female gov_coalitiion, r
// eststo model8
//
// esttab model1 model2 model3 model4 model5 model6 model7 model8 using regression_table.txt, replace ///
// b(3) se(3) t(3) star(* 0.10 ** 0.05 *** 0.01) ///
// title("Regression Results") ///
// keep(lisa_avg log_baseline_nl ln_popn urban_num gov_coalitiion ageatelection female high_school_percent _cons) ///
// order(lisa_avg log_baseline_nl ln_popn high_school_percent urban_num gov_coalitiion ageatelection female  _cons) ///
// stats(N r2, labels(Observations "R-squared")) ///
//
// // use vif here to check multicollinearity
//
// // //graphs
//
// graph bar (mean) sum_2021 (mean) sum_2017 (mean) sum_2016 (mean) sum_2015 (mean) sum_2014 (mean) sum_2013 (mean) sum_2012
//
//
// graph box rel_chgnl , over(province)
//
// summarize rel_chgnl 
//
// graph box lisa_avg, over(province)
//
// twoway (scatter rel_chgnl  lisa_avg) (lfit rel_chgnl  lisa_avg)
//
// graph box high_school_percent, over(province)
//
// twoway (scatter rel_chgnl  high_school_percent) (lfit rel_chgnl  high_school_percent)
//
// graph box rel_chgnl , over(female)
//
// graph box ageatelection, over(province)
//
// twoway (scatter rel_chgnl  ageatelection) (lfit rel_chgnl  ageatelection) 
//
// scatter rel_chgnl  ageatelection if gov_coalitiion == 0, mcolor(red) || scatter rel_chgnl  ageatelection if gov_coalitiion == 1, mcolor(green)




