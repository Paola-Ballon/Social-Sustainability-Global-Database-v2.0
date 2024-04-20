* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* last update: July 7th, 2023
* original data source: https://databank.worldbank.org/source/worldwide-governance-indicators#

/*
Issues:
	- Data availability is limited to the national level
*/

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\wgi"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

cd "$raw_data"

import excel using "P_Data_Extract_From_Worldwide_Governance_Indicators.xlsx", firstrow case(lower) clear

* -------------------------- *
* Period for data extraction *
* -------------------------- *

keep seriesname seriescode countryname countrycode yr*
reshape long yr, i(seriescode countrycode) j(year) // reshape to long format
order countryname countrycode year yr
* rename variable names to process loop functions more easily
replace seriescode = "cc" if seriescode=="CC.EST"
replace seriescode = "ge" if seriescode=="GE.EST"
replace seriescode = "rl" if seriescode=="RL.EST"
save "temp1.dta", replace // ancillary data file

* ---------------- *
* Data arrangement *
* ---------------- *

** Labelling
* variables
local t_pl_rullaw = "Rule of Law"
local t_pl_goveff = "Government effectiveness"
local t_pl_concor = "Control of corruption"
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

* rename macros
local name_rl = "pl_rullaw"
local name_ge = "pl_goveff"
local name_cc = "pl_concor"
global vars "rl ge cc"
foreach x in $vars{
	use "temp1.dta", clear
	keep if seriescode=="`x'"
	rename yr `name_`x''_nat
	* subgroups variables generation (recall the data is only available at the national level)
	gen `name_`x''_fem = .
	gen `name_`x''_male = .
	gen `name_`x''_rural = .
	gen `name_`x''_urban = .
	gen `name_`x''_15_24 = .
	gen `name_`x''_24plus = .
	gen `name_`x''_nwithoutd = .
	gen `name_`x''_pwd = .
	gen `name_`x''_relmin = .
	gen `name_`x''_relmaj = .
	gen `name_`x''_ethmin = .
	gen `name_`x''_ethmaj = .
	gen `name_`x''_15_29 = .
	gen `name_`x''_30_59 = .
	gen `name_`x''_60plus = .
	* labels
	foreach k in `name_`x''{
		foreach y in _nat _fem _male _rural _urban _15_24 _24plus _nwithoutd _pwd _relmin _relmaj _ethmin _ethmaj _15_29 _30_59 _60plus{
			label var `k'`y' "`t_`k'', `t`y''"
		}
	}
	
	* saving (one database per variable and year)
	keep countryname countrycode year `name_`x''_*
	forvalues t = 2015/2021{
		preserve
		keep if year==`t'
		save "`x'_`t'.dta", replace
		restore
	}
}
erase "temp1.dta" // delete ancillary database

* correction country name
preserve
import excel using "${ssgd_v2_userpath}\SSGD v2.0\other\list_countries.xlsx", firstrow sheet("countries_codes") clear
rename Country countryname
rename Code countrycode
save "countries_codes.dta", replace
restore

* generating one WGI database per period/year
forvalues t = 2015/2021{
	use "rl_`t'.dta", clear
	merge 1:1 countrycode using "ge_`t'.dta", nogenerate
	merge 1:1 countrycode using "cc_`t'.dta", nogenerate
	rename year period // period variable
	tostring period, replace
	gen source = "WGI" // source variable
	drop countryname
	merge 1:1 countrycode using "countries_codes.dta"
	keep if _merge==3 // we drop a country with iso code "JEY" which is Jersey, but can be safely ignored
	drop _merge
	order countryname countrycode source period
	* saving
	save "$proc_data\wgi`t'.dta", replace
}

* delete per variable-year databases
foreach x in $vars{
	forvalues t = 2015/2021{
		erase "`x'_`t'.dta"
	}
}
