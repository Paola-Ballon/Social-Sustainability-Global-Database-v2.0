* Social Sustainability Global Database
* consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* last update: March 6th, 2023
* original data source: https://databank.worldbank.org/source/worldwide-governance-indicators#

/*
Issues:
	- 
*/

* ------------- *
* External: WDI *
* ------------- *

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\external\wdi"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

cd "$raw_data"

import excel using "P_Data_Extract_From_World_Development_Indicators.xlsx", firstrow clear

gen variable = ""
replace variable = "ex_ferrat" if seriescode=="SP.DYN.TFRT.IN"
replace variable = "ex_gdpppc" if seriescode=="NY.GDP.PCAP.PP.KD"
replace variable = "ex_mulpov" if seriescode=="SI.POV.MDIM"
replace variable = "ex_humcap" if seriescode=="HD.HCI.OVRL"
replace variable = "ex_humcap_f" if seriescode=="HD.HCI.OVRL.FE"
replace variable = "ex_humcap_m" if seriescode=="HD.HCI.OVRL.MA"
replace variable = "ex_povnat" if seriescode=="SI.POV.NAHC"
replace variable = "ex_gini" if seriescode=="SI.POV.GINI"
replace variable = "ex_urbpop" if seriescode=="SP.URB.TOTL.IN.ZS"
replace variable = "ex_shapro" if seriescode=="SI.SPR.PC40.ZG"
replace variable = "temp_shaprotot" if seriescode=="SI.SPR.PCAP.ZG"
replace variable = "temp_birth" if seriescode=="SP.REG.BRTH.ZS"
replace variable = "temp_enrollment" if seriescode=="SE.PRE.ENRR"
replace variable = "temp_mortality" if seriescode=="SH.DYN.MORT"
replace variable = "ex_growthgdppc" if seriescode=="NY.GDP.PCAP.KD.ZG"

drop seriesname seriescode

levelsof variable, local(vars)
foreach x of local vars{
	preserve
	keep if variable=="`x'"
	reshape long yr, i(countrycode) j(year) // reshape to long format
	rename yr `x'
	drop variable
	save "temp_`x'.dta", replace
	restore
}

global rvars "ex_gdpppc ex_mulpov ex_humcap ex_humcap_f ex_humcap_m ex_povnat ex_gini ex_urbpop ex_shapro temp_shaprotot temp_birth temp_enrollment temp_mortality ex_growthgdppc"
use "temp_ex_ferrat.dta", clear
foreach x in $rvars{
	merge 1:1 countrycode year using "temp_`x'.dta", nogenerate
	erase "temp_`x'.dta"
}
erase "temp_ex_ferrat.dta"

* Generating remaining variables
gen ex_loggdp = log(ex_gdpppc)
gen ex_gaphci = ex_humcap_m - ex_humcap_f
drop ex_humcap_*
gen ex_shapp = ex_shapro - temp_shaprotot
drop temp_shaprotot
replace temp_mortality = temp_mortality/10
gen temp_survival = 100 - temp_mortality
drop temp_mortality
gen ex_avega2 = ((100-temp_birth) + (100-temp_enrollment) + (100-temp_survival))/3
drop temp_*

* --------- *
* Labelling *
* --------- *

* variables
label var ex_ferrat "Fertility rate, total (births per woman)"
label var ex_gdpppc "GDP per capita, PPP (constant 2017 international $)"
label var ex_mulpov "Multidimensional poverty headcount ratio (% of total population)"
label var ex_humcap "Human capital index (HCI) (scale 0-1)"
label var ex_povnat "Poverty headcount ratio at national poverty lines (% of population)"
label var ex_gini "Gini index (World Bank estimate)"
label var ex_urbpop "Urban population (% of total population)"
label var ex_shapro "Shared prosperity"
label var ex_loggdp "Log of GDP per capita, PPP (constant 2017 international $)"
label var ex_gaphci "Inequality of opportunities, using HCI"
label var ex_shapp "Shared prosperity premium"
label var ex_avega2 "Inequality of opportunities"
label var ex_growthgdppc "GDP per capita growth (annual %)"

* corrections
drop if countrycode=="CHI"

foreach x in ex_ferrat ex_gdpppc ex_mulpov ex_humcap ex_povnat ex_gini ex_urbpop ex_shapro ex_loggdp ex_gaphci ex_shapp ex_avega2 ex_growthgdppc{
	egen per_`x'_w1 = max(year) if `x'!=. & year>=2015 & year<=2018
	egen per_`x'_w2 = max(year) if `x'!=. & year>=2019 & year<=2022
	gen sou_`x'_w1 = "WDI" if `x'!=. & year>=2015 & year<=2018
	gen sou_`x'_w2 = "WDI" if `x'!=. & year>=2019 & year<=2022
	gen `x'_w1 = `x' if year==per_`x'_w1
	gen `x'_w2 = `x' if year==per_`x'_w2
	drop `x'
}
tostring per_*, replace force
foreach x in ex_ferrat ex_gdpppc ex_mulpov ex_humcap ex_povnat ex_gini ex_urbpop ex_shapro ex_loggdp ex_gaphci ex_shapp ex_avega2 ex_growthgdppc{
	forvalues t = 1/2{
		replace per_`x'_w`t' = "" if per_`x'_w`t'=="."
	}
}

collapse (firstnm) ex_* per_* sou_*, by(countrycode countryname)

gen group = "nat"

order countryname countrycode group 

save "$proc_data\external1.dta", replace

* -------------- *
* External: UNDP *
* -------------- *

/*
Issues:
	- 
*/

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\external\undp"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

cd "$raw_data"

import delimited using "HDR21-22_Composite_indices_complete_time_series.csv", case(lower) delimiters(",") clear

drop if _n>=196

* retain variables
rename iso3 countrycode
rename country countryname
keep countryname countrycode hdi_2015-hdi_2021

rename hdi_* ex_hdi_*

rename ex_hdi_2018 ex_hdi_w1
rename ex_hdi_2021 ex_hdi_w2

keep countryname countrycode ex_hdi_w1 ex_hdi_w2
gen per_ex_hdi_w1 = "2018" if ex_hdi_w1!=.
gen per_ex_hdi_w2 = "2021" if ex_hdi_w2!=.
gen sou_ex_hdi_w1 = "UNDP" if ex_hdi_w1!=.
gen sou_ex_hdi_w2 = "UNDP" if ex_hdi_w2!=.

gen group = "nat"

save "$proc_data\external2.dta", replace

* ------------- *
* External: WBL *
* ------------- *

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\external\wbl"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

cd "$raw_data"

import excel using "WBL-1971-2023-Dataset.xlsx", firstrow sheet("WBL Panel 2023") clear

drop if ReportYear<=2014
drop if ReportYear==2023
drop Region IncomeGroup Economy*
rename ReportYear year
rename ISOCode countrycode 
rename WBLINDEX ex_wbl_index_
rename MOBILITY ex_mobility_
rename WORKPLACE ex_workplace_
rename PAY ex_pay_
rename MARRIAGE ex_marriage_
rename PARENTHOOD ex_parenthood_
rename ENTREPRENEURSHIP ex_entrepreneurship_
rename ASSETS ex_assets_
rename PENSION ex_pension_

keep countrycode year ex_*

foreach x in ex_wbl_index ex_mobility ex_workplace ex_pay ex_marriage ex_parenthood ex_entrepreneurship ex_assets ex_pension{
	gen `x'_w1 = `x'_ if year==2018
	gen `x'_w2 = `x'_ if year==2022
	drop `x'_
}

collapse (firstnm) ex_*, by(countrycode)

foreach x in ex_wbl_index ex_mobility ex_workplace ex_pay ex_marriage ex_parenthood ex_entrepreneurship ex_assets ex_pension{
	gen per_`x'_w1 = "2018"
	gen per_`x'_w2 = "2022"
	gen sou_`x'_w1 = "WBL"
	gen sou_`x'_w2 = "WBL"
}

gen group = "nat"

order countrycode group

save "$proc_data\external3.dta", replace

* ------------- *
* External: EIU *
* ------------- *

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\external\eiu"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

cd "$raw_data"

import excel using "democracy_index_series_2015_2022.xlsx", firstrow sheet("Sheet1") clear

* attaching countrycodes
preserve
import excel using "${ssgd_v2_userpath}\SSGD v2.0\other\list_countries.xlsx", firstrow sheet("countries_codes") clear
rename Country country
rename Code countrycode
drop Region
save "temp.dta", replace
restore

* corrections
replace country = "Bosnia and Herzegovina" if country=="Bosnia and Hercegovina"
replace country = "Cape Verde" if country=="Cabo Verde"
replace country = "Congo, Rep." if country=="Congo (Brazzaville)"
replace country = "Cote D Ivoire" if country=="Cote d'Ivoire"
replace country = "Cote D Ivoire" if country=="Côte d'Ivoire"
replace country = "Cote D Ivoire" if country=="Côte d’Ivoire"
replace country = "Congo, Dem. Rep." if country=="DRC"
replace country = "Congo, Dem. Rep." if country=="Democratic Republic of Congo"
replace country = "El Salvador" if country=="EL Salvador"
replace country = "Guinea Bissau" if country=="Guinea-Bissau"
replace country = "Hong Kong SAR" if country=="Hong Kong"
replace country = "Lao" if country=="Laos"
replace country = "Luxemburg" if country=="Luxembourg"
replace country = "North Macedonia" if country=="Macedonia"
replace country = "Korea" if country=="North Korea"
replace country = "Slovak Republic" if country=="Slovakia"
replace country = "Eswatini" if country=="Swaziland"
replace country = "Syrian Arab Republic" if country=="Syria"
replace country = "Taiwan ROC" if country=="Taiwan"
replace country = "Timor Leste" if country=="Timor-Leste"
replace country = "Eswatini" if country=="eSwatini"

merge m:1 country using "temp.dta"
keep if _merge==3
drop _merge

rename Overallscore ex_demind_
rename Electoralprocessandpluralism ex_demind_elec_
rename Functioningofgovernment ex_demind_func_
rename Politicalparticipation ex_demind_polpar_
rename Politicalculture ex_demind_polcul_
rename Civilliberties ex_demind_civil_

foreach x in ex_demind ex_demind_elec ex_demind_func ex_demind_polpar ex_demind_polcul ex_demind_civil{
	gen `x'_w1 = `x'_ if year==2018
	gen `x'_w2 = `x'_ if year==2022
	drop `x'_
}

collapse (firstnm) ex_*, by(country countrycode)

foreach x in ex_demind ex_demind_elec ex_demind_func ex_demind_polpar ex_demind_polcul ex_demind_civil{
	gen per_`x'_w1 = "2018"
	gen per_`x'_w2 = "2022"
	gen sou_`x'_w1 = "EIU"
	gen sou_`x'_w2 = "EIU"
}

gen group = "nat"

rename country countryname
order countryname countrycode group

save "$proc_data\external4.dta", replace

* ------------- *
* External: ESG *
* ------------- *

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\external\esg"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

cd "$raw_data"

import excel using "P_Data_Extract_From_Environment_Social_and_Governance_(ESG)_Data.xlsx", firstrow clear

gen variable = ""
replace variable = "ex_treeloss" if seriescode=="AG.LND.FRLS.HA"
replace variable = "ex_forestarea" if seriescode=="AG.LND.FRST.ZS"
replace variable = "ex_energyint" if seriescode=="EG.EGY.PRIM.PP.KD"
replace variable = "ex_co2emissions" if seriescode=="EN.ATM.CO2E.PC"
replace variable = "ex_coolingdays" if seriescode=="EN.CLC.CDDY.XD"
replace variable = "ex_heatingdays" if seriescode=="EN.CLC.HDDY.XD"
replace variable = "ex_waterstress" if seriescode=="ER.H2O.FWST.ZS"
replace variable = "ex_researchexp" if seriescode=="GB.XPD.RSDV.GD.ZS"
replace variable = "ex_legalrights" if seriescode=="IC.LGL.CRED.XQ"
replace variable = "ex_scientificart" if seriescode=="IP.JRN.ARTC.SC"
replace variable = "ex_patentapp" if seriescode=="IP.PAT.RESD"
replace variable = "ex_indinternet" if seriescode=="IT.NET.USER.ZS"
replace variable = "ex_polstab" if seriescode=="PV.EST"
replace variable = "ex_governeff" if seriescode=="RQ.EST"
replace variable = "ex_econsocrights" if seriescode=="SD.ESR.PERF.XQ"
replace variable = "ex_schoolgpi" if seriescode=="SE.ENR.PRSC.FM.ZS"
replace variable = "ex_ratiofem" if seriescode=="SL.TLF.CACT.FM.ZS"
replace variable = "ex_netmigration" if seriescode=="SM.POP.NETM"
replace variable = "ex_unmetcontr" if seriescode=="SP.UWT.TFRT"
replace variable = "ex_voiceest" if seriescode=="VA.EST"

drop seriesname seriescode

levelsof variable, local(vars)
foreach x of local vars{
	preserve
	keep if variable=="`x'"
	reshape long yr, i(countrycode) j(year) // reshape to long format
	rename yr `x'
	drop variable
	save "temp_`x'.dta", replace
	restore
}

global rvars "ex_forestarea ex_energyint ex_co2emissions ex_coolingdays ex_heatingdays ex_waterstress ex_researchexp ex_legalrights ex_scientificart ex_patentapp ex_indinternet ex_polstab ex_governeff ex_econsocrights ex_schoolgpi ex_ratiofem ex_netmigration ex_unmetcontr ex_voiceest"
use "temp_ex_treeloss.dta", clear
foreach x in $rvars{
	merge 1:1 countrycode year using "temp_`x'.dta", nogenerate
	erase "temp_`x'.dta"
}
erase "temp_ex_treeloss.dta"

foreach x in ex_treeloss ex_forestarea ex_energyint ex_co2emissions ex_coolingdays ex_heatingdays ex_waterstress ex_researchexp ex_legalrights ex_scientificart ex_patentapp ex_indinternet ex_polstab ex_governeff ex_econsocrights ex_schoolgpi ex_ratiofem ex_netmigration ex_unmetcontr ex_voiceest{
	egen per_`x'_w1 = max(year) if `x'!=. & year>=2015 & year<=2018
	egen per_`x'_w2 = max(year) if `x'!=. & year>=2019 & year<=2021
	gen `x'_w1 = `x' if year==per_`x'_w1
	gen `x'_w2 = `x' if year==per_`x'_w2
	gen sou_`x'_w1 = "ESG" if year==per_`x'_w1
	gen sou_`x'_w2 = "ESG" if year==per_`x'_w2
	drop `x'
}

collapse (firstnm) ex_* per_* sou_*, by(countryname countrycode)
tostring per_*, replace

foreach x in ex_treeloss ex_forestarea ex_energyint ex_co2emissions ex_coolingdays ex_heatingdays ex_waterstress ex_researchexp ex_legalrights ex_scientificart ex_patentapp ex_indinternet ex_polstab ex_governeff ex_econsocrights ex_schoolgpi ex_ratiofem ex_netmigration ex_unmetcontr ex_voiceest{
	forvalues t = 1/2{
		replace per_`x'_w`t' = "" if per_`x'_w`t'=="."
	}
}

gen group = "nat"

order countryname countrycode group

save "$proc_data\external5.dta", replace

* ----------------- *
* External: EQOSOGI *
* ----------------- *

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\external\eqosogi"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

cd "$raw_data"

import excel using "EQOSOGI Dataset 2021.xlsx", firstrow sheet("EQOSOGI2021") clear

drop if _n>=17

keep Country CountryCode CriminalizationandSOGIScore AccesstoInclusiveEducationSc AccesstotheLaborMarketScore AccesstoPublicServicesandSo CivilandPoliticalInclusionSc ProtectionfromHateCrimesScor

rename Country countryname
rename CountryCode countrycode
rename CriminalizationandSOGIScore ex_eqocrimi_w2
rename AccesstoInclusiveEducationSc ex_eqoinclu_w2
rename AccesstotheLaborMarketScore ex_eqolabor_w2
rename AccesstoPublicServicesandSo ex_eqopubli_w2
rename CivilandPoliticalInclusionSc ex_eqocivil_w2
rename ProtectionfromHateCrimesScor ex_eqoprote_w2

foreach x in eqocrimi eqoinclu eqolabor eqopubli eqocivil eqoprote{
	gen ex_`x'_w1 = .
	gen per_ex_`x'_w1 = ""
	gen per_ex_`x'_w2 = "2021"
	gen sou_ex_`x'_w1 = ""
	gen sou_ex_`x'_w2 = "EQOSOGI"
}

gen group = "nat"

order countryname countrycode group 

save "$proc_data\external6.dta", replace
