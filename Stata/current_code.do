clear
set more off
capture {
cd "/Users/apanta1/Desktop/Summer Research 2024/Night_Light_Institutional_Capacity/Stata"
log close
}

log using MainDataSet.log, replace

// Load data
import delimited "/Users/apanta1/Desktop/Summer Research 2024/Night_Light_Institutional_Capacity/Stata/Cop_break.csv", clear

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

gen ln_baseline_nl_km = log(baseline_nl/area_kmsq)

generate rel_chgnl  = (log(sum_2021) - log(sum_2017))

gen ln_popn = log(popn_2021)

gen high_school_percent= (((popn_highschool+popn_graduate+popn_post_graduate)/popn_2021) * 100)

gen urban_num = 0
replace urban_num = 1 if unit_type != "Gaunpalika"

gen gov_coalitiion = 0
replace gov_coalitiion = 1 if politicalaffiliation == "CPN-MC" | politicalaffiliation == "CPN-UML" | politicalaffiliation == "FSFN" | politicalaffiliation == "NSP"

gen female = 0
replace female = 1 if sex =="Female"

egen lisa_avg = rowmean(lisa_20_21 lisa_21_22)


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

// cooperation and coordination subcateogories averages

egen a_avg = rowmean(a1 a2)
egen b_avg = rowmean(b1 b2)
egen c_avg = rowmean(c1 c2)
egen d_avg = rowmean(d1 d2)
egen e_avg = rowmean(e1 e2)
egen f_avg = rowmean(f1 f2)

gen fed = a_avg + d_avg
gen local = b_avg + c_avg
gen ddc = f_avg

// regressions

regress rel_chgnl  ln_baseline_nl_km, r
outreg2 using v3_intial_regression.doc, replace dec(3)

regress rel_chgnl  ln_baseline_nl_km lisa_avg, r
outreg2 using v3_intial_regression.doc, append dec(3)


regress rel_chgnl  ln_baseline_nl_km lisa_avg high_school_percent, r
outreg2 using v3_intial_regression.doc, append dec(3)


regress rel_chgnl  ln_baseline_nl_km lisa_avg high_school_percent, r
outreg2 using v3_intial_regression.doc, append dec(3)


regress rel_chgnl  ln_baseline_nl_km lisa_avg high_school_percent ageatelection, r
outreg2 using v3_intial_regression.doc, append dec(3)


regress rel_chgnl  ln_baseline_nl_km lisa_avg high_school_percent ageatelection gov_coalitiion, r
outreg2 using v3_intial_regression.doc, append dec(3)


regress rel_chgnl  ln_baseline_nl_km lisa_avg high_school_percent ageatelection gov_coalitiion female, r
outreg2 using v3_intial_regression.doc, append dec(3)


regress rel_chgnl  ln_baseline_nl_km lisa_avg high_school_percent ageatelection gov_coalitiion female ln_popn, r
outreg2 using v3_intial_regression.doc, append dec(3)


regress rel_chgnl  ln_baseline_nl_km lisa_avg high_school_percent ageatelection gov_coalitiion female ln_popn urban_num, r
outreg2 using v3_intial_regression.doc, append dec(3)





// regression in cop cor grouping

regress rel_chgnl ln_baseline_nl_km, r
outreg2 using v3_lisa_regression.doc, replace dec(3)


regress rel_chgnl  ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg fed local ddc, r
outreg2 using v3_lisa_regression.doc, append dec(3)


regress rel_chgnl  ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg fed local ddc high_school_percent, r
outreg2 using v3_lisa_regression.doc, append dec(3)


regress rel_chgnl  ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg fed local ddc high_school_percent ageatelection, r
outreg2 using v3_lisa_regression.doc, append dec(3)


regress rel_chgnl  ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg fed local ddc high_school_percent ageatelection female, r
outreg2 using v3_lisa_regression.doc, append dec(3)


regress rel_chgnl  ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg fed local ddc high_school_percent ageatelection female gov_coalitiion, r
outreg2 using v3_lisa_regression.doc, append dec(3)


regress rel_chgnl  ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg fed local ddc high_school_percent ageatelection female gov_coalitiion , r
outreg2 using v3_lisa_regression.doc, append dec(3)


regress rel_chgnl ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg fed local ddc high_school_percent ageatelection female gov_coalitiion ln_popn, r


regress rel_chgnl ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg fed local ddc high_school_percent ageatelection female gov_coalitiion ln_popn, r
outreg2 using v3_lisa_regression.doc, append dec(3)


regress rel_chgnl ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg fed local ddc high_school_percent ageatelection female gov_coalitiion ln_popn urban_num, r
outreg2 using v3_lisa_regression.doc, append dec(3)

////////////////

regress rel_chgnl ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg cop_cor_avg high_school_percent ageatelection female gov_coalitiion ln_popn urban_num, r
outreg2 using v3_lisa_regression.doc, append dec(3)

///////////////

regress rel_chgnl ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg fed ddc high_school_percent ageatelection female gov_coalitiion ln_popn urban_num, r
////////////////


//regressions in cop cor breakdown


regress rel_chgnl ln_baseline_nl_km, r
outreg2 using v3_lisa_regression.doc, replace dec(3)


regress rel_chgnl  ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg a_avg b_avg c_avg d_avg e_avg f_avg, r
outreg2 using v3_lisa_regression.doc, append dec(3)


regress rel_chgnl  ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg a_avg b_avg c_avg d_avg e_avg f_avg high_school_percent, r
outreg2 using v3_lisa_regression.doc, append dec(3)


regress rel_chgnl  ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg a_avg b_avg c_avg d_avg e_avg f_avg high_school_percent ageatelection, r
outreg2 using v3_lisa_regression.doc, append dec(3)


regress rel_chgnl  ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg a_avg b_avg c_avg d_avg e_avg f_avg high_school_percent ageatelection female, r
outreg2 using v3_lisa_regression.doc, append dec(3)


regress rel_chgnl  ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg a_avg b_avg c_avg d_avg e_avg f_avg high_school_percent ageatelection female gov_coalitiion, r
outreg2 using v3_lisa_regression.doc, append dec(3)


regress rel_chgnl  ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg a_avg b_avg c_avg d_avg e_avg f_avg high_school_percent ageatelection female gov_coalitiion , r
outreg2 using v3_lisa_regression.doc, append dec(3)


regress rel_chgnl ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg a_avg b_avg c_avg d_avg e_avg f_avg high_school_percent ageatelection female gov_coalitiion ln_popn, r


regress rel_chgnl ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg a_avg b_avg c_avg d_avg e_avg f_avg high_school_percent ageatelection female gov_coalitiion ln_popn, r
outreg2 using v3_lisa_regression.doc, append dec(3)


regress rel_chgnl ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg a_avg b_avg c_avg d_avg e_avg f_avg high_school_percent ageatelection female gov_coalitiion ln_popn urban_num, r
outreg2 using v3_lisa_regression.doc, append dec(3)

regress rel_chgnl ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg cop_cor_avg high_school_percent ageatelection female gov_coalitiion ln_popn urban_num, r
outreg2 using v3_lisa_regression.doc, append dec(3)

//////////////

////////////////////////////

regress rel_chgnl ln_baseline_nl_km, r
outreg2 using v3_lisa_regression.doc, replace dec(3)


regress rel_chgnl  ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg cop_cor_avg, r
outreg2 using v3_lisa_regression.doc, append dec(3)


regress rel_chgnl  ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg cop_cor_avg high_school_percent, r
outreg2 using v3_lisa_regression.doc, append dec(3)


regress rel_chgnl  ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg cop_cor_avg high_school_percent ageatelection, r
outreg2 using v3_lisa_regression.doc, append dec(3)


regress rel_chgnl  ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg cop_cor_avg high_school_percent ageatelection female, r
outreg2 using v3_lisa_regression.doc, append dec(3)


regress rel_chgnl  ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg cop_cor_avg high_school_percent ageatelection female gov_coalitiion, r
outreg2 using v3_lisa_regression.doc, append dec(3)


regress rel_chgnl  ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg cop_cor_avg high_school_percent ageatelection female gov_coalitiion , r
outreg2 using v3_lisa_regression.doc, append dec(3)


regress rel_chgnl ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg cop_cor_avg high_school_percent ageatelection female gov_coalitiion ln_popn, r


regress rel_chgnl ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg cop_cor_avg high_school_percent ageatelection female gov_coalitiion ln_popn, r
outreg2 using v3_lisa_regression.doc, append dec(3)


regress rel_chgnl ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg cop_cor_avg high_school_percent ageatelection female gov_coalitiion ln_popn urban_num, r
outreg2 using v3_lisa_regression.doc, append dec(3)


// cop_cor breakdown regression




gen other_lisa = (gov_magm_avg + org_admin_avg + budg_magm_avg + fiscal_magm_avg + service_dev_avg + jud_exe_avg + phy_infra_avg + soc_inc_avg)


regress rel_chgnl ln_baseline_nl_km, r
outreg2 using v3_revised_regression.doc, replace dec(3)


regress rel_chgnl ln_baseline_nl_km env_protec_avg cop_cor_avg other_lisa, r
outreg2 using v3_revised_regression.doc, append dec(3)


regress rel_chgnl ln_baseline_nl_km env_protec_avg cop_cor_avg other_lisa high_school_percent ageatelection, r
outreg2 using v3_revised_regression.doc, append dec(3)


regress rel_chgnl ln_baseline_nl_km env_protec_avg cop_cor_avg other_lisa high_school_percent ageatelection female, r
outreg2 using v3_revised_regression.doc, append dec(3)


regress rel_chgnl ln_baseline_nl_km env_protec_avg cop_cor_avg other_lisa high_school_percent ageatelection female gov_coalitiion, r
outreg2 using v3_revised_regression.doc, append dec(3)


regress rel_chgnl ln_baseline_nl_km env_protec_avg cop_cor_avg other_lisa high_school_percent ageatelection female gov_coalitiion ln_popn, r
outreg2 using v3_revised_regression.doc, append dec(3)


regress rel_chgnl ln_baseline_nl_km env_protec_avg cop_cor_avg other_lisa high_school_percent ageatelection female gov_coalitiion ln_popn urban_num, r
outreg2 using v3_revised_regression.doc, append dec(3)

// calculating IV

regress rel_chgnl ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg high_school_percent ageatelection female gov_coalitiion ln_popn urban_num, r

regress cop_cor_avg ln_baseline_nl_km gov_magm_avg org_admin_avg budg_magm_avg fiscal_magm_avg service_dev_avg jud_exe_avg phy_infra_avg soc_inc_avg env_protec_avg high_school_percent ageatelection female gov_coalitiion ln_popn urban_num, r

regress cop_cor_avg gov_coalitiion
outreg2 using v3_lisa_regression.doc, append dec(3)

// use vif here to check multicollinearity
//
graphs
//
// graph bar (mean) sum_2021 (mean) sum_2017 (mean) sum_2016 (mean) sum_2015 (mean) sum_2014 (mean) sum_2013 (mean) sum_2012
//
//
graph box rel_chgnl , over(province)

twoway (scatter rel_chgnl  baseline_nl_km) (lfit rel_chgnl  baseline_nl_km)

gen log_km = log(baseline_nl_km + 1)

summarize log_km

twoway (scatter rel_chgnl  log_km) (lfit rel_chgnl  log_km)
//
summarize rel_chgnl 
//
graph box lisa_avg, over(province)
//
twoway (scatter rel_chgnl  lisa_avg) (lfit rel_chgnl  lisa_avg)

twoway (scatter rel_chgnl  cop_cor_avg) (lfit rel_chgnl  cop_cor_avg)

//
graph box high_school_percent, over(province)

//
twoway (scatter rel_chgnl  high_school_percent) (lfit rel_chgnl  high_school_percent)

twoway (scatter rel_chgnl  female) (lfit rel_chgnl  female)
//
graph box rel_chgnl , over(female)
//
// graph box ageatelection, over(province)
//
twoway (scatter rel_chgnl  ageatelection) (lfit rel_chgnl  ageatelection) 
//
scatter rel_chgnl  ageatelection if gov_coalitiion == 0, mcolor(red) || scatter rel_chgnl  ageatelection if gov_coalitiion == 1, mcolor(green)




