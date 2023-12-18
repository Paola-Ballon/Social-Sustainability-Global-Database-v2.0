* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* last update: December 10, 2023
* original data source: https://databank.worldbank.org/source/global-financial-inclusion#

/*
Issues:
	- Data availability is limited to the national level, and the 15-24 and 25+, male/female and urban/rural subgroups
*/

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\findex"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

cd "$raw_data"

import excel using "P_Data_Extract_From_Global_Financial_Inclusion.xlsx", firstrow case(lower) clear

drop if seriescode=="fin37.38.t.d" | seriescode=="save.any"

* ------------- *
* Preliminaries *
* ------------- *

global periods "2011 2014 2017 2021"

* Scale every rate to the [0,1] interval
destring yr*, replace
foreach t in $periods{
	replace yr`t' = yr`t'/100
}

* Reshape
reshape long yr, i(seriescode countrycode) j(year) // reshape to long format
order countryname countrycode year yr
drop seriescode

* Rename variable names to process loop functions more easily
replace seriesname = "bank_nat" if seriesname=="Account (% age 15+)"
replace seriesname = "bank_fem" if seriesname=="Account, female (% age 15+)"
replace seriesname = "bank_male" if seriesname=="Account, male (% age 15+)"
replace seriesname = "bank_14_24" if seriesname=="Account, young (% ages 15-24)"
replace seriesname = "bank_24plus" if seriesname=="Account, older (% age 25+)"
replace seriesname = "bank_urban" if seriesname=="Account, urban (% age 15+)"
replace seriesname = "bank_rural" if seriesname=="Account, rural (% age 15+)"

* Correction: country names
drop countryname
preserve
import excel using "${ssgd_v2_userpath}\SSGD v2.0\other\list_countries.xlsx", firstrow sheet("countries_codes") clear
rename Country countryname
rename Code countrycode
save "countries_codes.dta", replace
restore
* merging process
merge m:1 countrycode using "countries_codes.dta"
keep if _merge==3
drop _merge

* ---------------- *
* Data arrangement *
* ---------------- *

foreach t in $periods{
	preserve
	keep if year==`t'
	drop year
	reshape wide yr, i(countryname) j(seriesname) string
	foreach x in _nat _male _fem _14_24 _24plus _urban _rural{
		rename yrbank`x' si_ownban`x'
	}
	rename si_ownban_14_24 si_ownban_15_24 // we assume this is a proxy
	gen period = `t'
	tostring period, replace
	gen source = "FINDEX"
	order countryname countrycode period source si_ownban*
	foreach z in _nwithoutd _pwd _relmin _relmaj _ethmin _ethmaj _15_29 _30_59 _60plus{
		gen si_ownban`z' = .
	}
	
	* --------- *
	* Labelling *
	* --------- *

	* variables
	local t_si_ownban = "Share of population that owns a bank account"
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
	* labels
	foreach x in si_ownban{
		foreach y in _nat _fem _male _rural _urban _15_24 _24plus _nwithoutd _pwd _relmin _relmaj _ethmin _ethmaj _15_29 _30_59 _60plus{
			label var `x'`y' "`t_`x'', `t`y''"
		}
	}
	
	order countryname countrycode period source

	save "$proc_data\findex`t'.dta", replace
	restore
}

erase "countries_codes.dta"

* --------------------------- *

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\findex"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

cd "$raw_data"

import excel using "P_Data_Extract_From_Global_Financial_Inclusion.xlsx", firstrow case(lower) clear

keep if seriescode=="fin37.38.t.d" | seriescode=="save.any"

* ------------- *
* Preliminaries *
* ------------- *

* Scale every rate to the [0,1] interval
destring yr*, replace
foreach t in $periods{
	replace yr`t' = yr`t'/100
}

* Reshape
reshape long yr, i(seriescode countrycode) j(year) // reshape to long format
order countryname countrycode year yr
drop seriescode

* Rename variable names to process loop functions more easily
replace seriesname = "govtrab_nat" if seriesname=="Received government transfer or pension (% age 15+)"
replace seriesname = "savmonb_nat" if seriesname=="Saved any money (% age 15+)"

* Correction: country names
drop countryname
preserve
import excel using "${ssgd_v2_userpath}\SSGD v2.0\other\list_countries.xlsx", firstrow sheet("countries_codes") clear
rename Country countryname
rename Code countrycode
save "countries_codes.dta", replace
restore
* merging process
merge m:1 countrycode using "countries_codes.dta"
keep if _merge==3
drop _merge

* ---------------- *
* Data arrangement *
* ---------------- *

foreach t in $periods{
	preserve
	keep if year==`t'
	drop year
	reshape wide yr, i(countryname) j(seriesname) string
	foreach x in _nat{
		rename yrgovtrab`x' re_govtrab`x'
		rename yrsavmonb`x' re_savmonb`x'
	}
	gen period = `t'
	tostring period, replace
	gen source = "FINDEX"
	order countryname countrycode period source re_govtrab* re_savmonb*
	foreach z in _male _fem _15_24 _24plus _urban _rural _nwithoutd _pwd _relmin _relmaj _ethmin _ethmaj _15_29 _30_59 _60plus{
		gen re_govtrab`z' = .
		gen re_savmonb`z' = .
	}
	
	* --------- *
	* Labelling *
	* --------- *

	* variables
	local t_re_govtrab = "Received government transfer or pension (% age 15+)"
	local t_re_savmonb = "Saved any money (% age 15+)"
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
	* labels
	foreach x in re_govtrab re_savmonb{
		foreach y in _nat _fem _male _rural _urban _15_24 _24plus _nwithoutd _pwd _relmin _relmaj _ethmin _ethmaj _15_29 _30_59 _60plus{
			label var `x'`y' "`t_`x'', `t`y''"
		}
	}
	
	order countryname countrycode period source

	save "$proc_data\findexb`t'.dta", replace
	restore
}

erase "countries_codes.dta"

