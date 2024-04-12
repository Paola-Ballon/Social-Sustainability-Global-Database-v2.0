* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* last update: April 12, 2024
* original data source: https://acleddata.com/data-export-tool/

* ---------------------------------------------------------------------------- *
*								 FIRST PART 								   *
* ---------------------------------------------------------------------------- *

/*
Issues:
	- Data availability is limited to the national level
	- We require a sound definition of "fatalities due to violence" because some demonstration events may be classified as violent and they reported casualties. Temporarily, we assume that both the number of violent events and the fatalities only considers violent events. For more information see the ACLED codebook: 
	https://acleddata.com/acleddatanew/wp-content/uploads/2021/11/ACLED_Codebook_v1_January-2021.pdf
*/

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\acled"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

cd "$raw_data"

set max_memory . // It is highly recommended that you run this line of code since the database requires a great memory to open it.

insheet using "2018-01-01-2020-12-31.csv", delimiter(";") clear

*import delimited using "2018-01-01-2020-12-31.csv", case(lower) delimiters(",") clear

* We only deal with violent events (See ACLED documentation)
keep if event_type=="Battles" | event_type=="Explossions/Remote violence" | event_type=="Violence against civilians" | (event_type=="Protests" & sub_event_type=="Excessive force against protesters") | event_type=="Riots"

* Each row defines a violent event, we create a unit vector and then collapse it over countries and year
gen x = 1

* We also collapse the number of fatalities
collapse (sum) fatalities x, by(country year)

* Not all countries appear in all years within the 2018-2020 period, we use tsfill to fill any gap
encode country, g(country2)
tsset country2 year // tsset requires the id variable to be numeric
tsfill, full
drop country
decode country2, g(country)
drop country2

* We properly label each indicator and also generate subgroups estimates (even if they're full of missing values)
rename x violent_events
rename country countryname
rename fatalities sc_fata_nat
rename violent_events sc_numeve_nat
recode sc_fata_nat (. = 0)
recode sc_numeve_nat (. = 0)
* subgroups
foreach x in sc_fata sc_numeve{
	foreach y in _fem _male _rural _urban _15_24 _24plus _nwithoutd _pwd _relmin _relmaj _ethmin _ethmaj _15_29 _30_59 _60plus{
		gen `x'`y' = .
	}
}

** Labelling
* variables
local t_sc_fata = "Fatalities due to violence"
local t_sc_numeve = "Number of violent events"
* groups
local t_nat = "national"
local t_fem = "female population"
local t_male = "male population"
local t_rural = "rural population"
local t_urban = "urban population"
local t_15_24 = "15-24 years population"
local t_24plus = "24+ years population"
local t_nwithoutd = "population with no disabilities"
local t_pwd = "population with disabilities"
local t_relmin = "minor religious group"
local t_relmaj = "major religious group"
local t_ethmin = "minor ethnic group"
local t_ethmaj = "major ethnic group"
local t_15_29 = "15-29 years population"
local t_30_59 = "30-59 years population"
local t_60plus = "60+ years population"
foreach x in sc_fata sc_numeve{
	foreach y in _nat _fem _male _rural _urban _15_24 _24plus _nwithoutd _pwd _relmin _relmaj _ethmin _ethmaj _15_29 _30_59 _60plus{
		label var `x'`y' "`t_`x'', `t`y''"
	}
}

* Corrections
replace countryname = "The Bahamas" if countryname=="Bahamas"
replace countryname = "Congo, Dem. Rep." if countryname=="Democratic Republic of Congo"
replace countryname = "Timor Leste" if countryname=="East Timor"
replace countryname = "Guinea Bissau" if countryname=="Guinea-Bissau"
replace countryname = "Cote D Ivoire" if countryname=="Ivory Coast"
replace countryname = "Kyrgyz Republic" if countryname=="Kyrgyzstan"
replace countryname = "Lao" if countryname=="Laos"
replace countryname = "Korea" if countryname=="North Korea"
replace countryname = "Congo, Rep." if countryname=="Republic of Congo"
replace countryname = "St. Vincent and the Grenadines" if countryname=="Saint Vincent and the Grenadines"
replace countryname = "Slovak Republic" if countryname=="Slovakia"
replace countryname = "Syrian Arab Republic" if countryname=="Syria"
replace countryname = "Taiwan ROC" if countryname=="Taiwan"
replace countryname = "United States of America" if countryname=="United States"
replace countryname = "Eswatini" if countryname=="eSwatini"
replace countryname = "St. Kitts and Nevis" if countryname=="Saint Kitts and Nevis"
replace countryname = "Luxemburg" if countryname=="Luxembourg"
replace countryname = "Virgin Islands" if countryname=="Virgin Islands, U.S."

* attaching data of countrycodes
preserve
import excel using "${ssgd_v2_userpath}\SSGD v2.0\other\list_countries.xlsx", firstrow sheet("countries_codes") clear
rename Country countryname
rename Code countrycode
save "countries_codes.dta", replace
restore
* merging process
merge m:1 countryname using "countries_codes.dta"
keep if _merge==3
drop _merge

save "acled_temp_p1.dta", replace

erase "countries_codes.dta"

* ---------------------------------------------------------------------------- *
*								 SECOND PART 								   *
* ---------------------------------------------------------------------------- *

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\acled"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

cd "$raw_data"

set max_memory . // It is highly recommended that you run this line of code since the database requires a great memory to open it.

insheet using "2021-01-01-2022-12-31.csv", delimiter(";") clear

*import delimited using "2021-01-01-2022-12-31.xlsx", case(lower) delimiters(",") clear

* We only deal with violent events (See ACLED documentation)
keep if event_type=="Battles" | event_type=="Explossions/Remote violence" | event_type=="Violence against civilians" | (event_type=="Protests" & sub_event_type=="Excessive force against protesters") | event_type=="Riots"

* Each row defines a violent event, we create a unit vector and then collapse it over countries and year
gen x = 1

* We also collapse the number of fatalities
collapse (sum) fatalities x, by(country year)

* Not all countries appear in all years within the 2018-2020 period, we use tsfill to fill any gap
encode country, g(country2)
tsset country2 year // tsset requires the id variable to be numeric
tsfill, full
drop country
decode country2, g(country)
drop country2

* We properly label each indicator and also generate subgroups estimates (even if they're full of missing values)
rename x violent_events
rename country countryname
rename fatalities sc_fata_nat
rename violent_events sc_numeve_nat
recode sc_fata_nat (. = 0)
recode sc_numeve_nat (. = 0)
* subgroups
foreach x in sc_fata sc_numeve{
	foreach y in _fem _male _rural _urban _15_24 _24plus _nwithoutd _pwd _relmin _relmaj _ethmin _ethmaj _15_29 _30_59 _60plus{
		gen `x'`y' = .
	}
}

** Labelling
* variables
local t_sc_fata = "Fatalities due to violence"
local t_sc_numeve = "Number of violent events"
* groups
local t_nat = "national"
local t_fem = "female population"
local t_male = "male population"
local t_rural = "rural population"
local t_urban = "urban population"
local t_15_24 = "15-24 years population"
local t_24plus = "24+ years population"
local t_nwithoutd = "population with no disabilities"
local t_pwd = "population with disabilities"
local t_relmin = "minor religious group"
local t_relmaj = "major religious group"
local t_ethmin = "minor ethnic group"
local t_ethmaj = "major ethnic group"
local t_15_29 = "15-29 years population"
local t_30_59 = "30-59 years population"
local t_60plus = "60+ years population"
foreach x in sc_fata sc_numeve{
	foreach y in _nat _fem _male _rural _urban _15_24 _24plus _nwithoutd _pwd _relmin _relmaj _ethmin _ethmaj _15_29 _30_59 _60plus{
		label var `x'`y' "`t_`x'', `t`y''"
	}
}

* Corrections
replace countryname = "The Bahamas" if countryname=="Bahamas"
replace countryname = "Congo, Dem. Rep." if countryname=="Democratic Republic of Congo"
replace countryname = "Timor Leste" if countryname=="East Timor"
replace countryname = "Guinea Bissau" if countryname=="Guinea-Bissau"
replace countryname = "Cote D Ivoire" if countryname=="Ivory Coast"
replace countryname = "Kyrgyz Republic" if countryname=="Kyrgyzstan"
replace countryname = "Lao" if countryname=="Laos"
replace countryname = "Korea" if countryname=="North Korea"
replace countryname = "Congo, Rep." if countryname=="Republic of Congo"
replace countryname = "St. Vincent and the Grenadines" if countryname=="Saint Vincent and the Grenadines"
replace countryname = "Slovak Republic" if countryname=="Slovakia"
replace countryname = "Syrian Arab Republic" if countryname=="Syria"
replace countryname = "Taiwan ROC" if countryname=="Taiwan"
replace countryname = "United States of America" if countryname=="United States"
replace countryname = "Eswatini" if countryname=="eSwatini"
replace countryname = "St. Kitts and Nevis" if countryname=="Saint Kitts and Nevis"
replace countryname = "Luxemburg" if countryname=="Luxembourg"
replace countryname = "St. Martin" if countryname=="Saint-Martin"

* attaching data on countrycodes
preserve
import excel using "${ssgd_v2_userpath}\SSGD v2.0\other\list_countries.xlsx", firstrow sheet("countries_codes") clear
rename Country countryname
rename Code countrycode
save "countries_codes.dta", replace
restore
* merging process
merge m:1 countryname using "countries_codes.dta"
keep if _merge==3
drop _merge

* attaching data from part 1
append using "acled_temp_p1.dta"

* Not all countries appear in all years within the 2018-2022 period, we use tsfill to fill any gap
encode countryname, g(countryname2)
tsset countryname2 year // tsset requires the id variable to be numeric
tsfill, full
drop countryname
decode countryname2, g(countryname)
drop countryname2 countrycode Region
* attaching countrycode data
merge m:1 countryname using "countries_codes.dta"
keep if _merge==3
drop _merge
recode sc_fata_nat (. = 0)
recode sc_numeve_nat (. = 0)

* Final data arrangement
forvalues t = 2018(1)2022{
	preserve
	keep if year==`t'
	rename year period
	tostring period, replace
	gen source = "ACLED"
	order countryname countrycode period source sc_fata* sc_numeve*
	save "$proc_data\acled`t'.dta", replace
	restore
}

erase "countries_codes.dta"
erase "acled_temp_p1.dta"