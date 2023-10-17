* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* last update: July 7th, 2023

/*
Issues:
	- Data availability is limited to the national level
*/

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\civicus"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

cd "$raw_data"

import excel using "CIVICUS_data_2018_2022.xlsx", firstrow sheet("Data") clear

drop Rating2021-Rating2019
rename Rating2018 pl_civspa_w1
rename Rating2022 pl_civspa_w2
rename Country country

* attaching countrycodes
preserve
import excel using "${ssgd_v2_userpath}\SSGD v2.0\other\list_countries.xlsx", firstrow sheet("countries_codes") clear
rename Country country
rename Code countrycode
drop Region
save "temp.dta", replace
restore

* corrections
replace country = "Antigua and Barbuda" if country=="Antigua y Barbuda"
replace country = "Azerbaijan" if country=="Azjerbaijan"
replace country = "The Bahamas" if country=="Bahamas"
replace country = "Bosnia and Herzegovina" if country=="Bosnia & Herzegovina"
replace country = "Cote D Ivoire" if country=="Cote d'Ivoire"
replace country = "Congo, Dem. Rep." if country=="Democratic Republic of Congo"
replace country = "Hong Kong SAR" if country=="Hong Kong"
replace country = "Kyrgyz Republic" if country=="Kyrgyzstan"
replace country = "Lao" if country=="Laos"
replace country = "Luxemburg" if country=="Luxembourg"
replace country = "Korea" if country=="North Korea"
replace country = "Congo, Rep." if country=="Republic of the Congo"
replace country = "Slovak Republic" if country=="Slovakia"
replace country = "St. Kitts and Nevis" if country=="St Kitts and Nevis"
replace country = "St. Vincent and the Grenadines" if country=="St Vincent and the Grenadines"
replace country = "Syrian Arab Republic" if country=="Syria"
replace country = "Taiwan ROC" if country=="Taiwan"
replace country = "Timor Leste" if country=="Timor-Leste"

merge m:1 country using "temp.dta"
keep if _merge==3
drop _merge

gen sou_pl_civspa_w1 = "CIVICUS"
gen sou_pl_civspa_w2 = "CIVICUS"
gen per_pl_civspa_w1 = "2018"
gen per_pl_civspa_w2 = "2022"

gen group = "nat"
rename country countryname

order countryname countrycode group 

save "$proc_data\ssgd_civicus.dta", replace
erase "temp.dta"
