* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* last update: July 7th, 2023
* original data source: https://worldjusticeproject.org/rule-of-law-index/global#

/*
Issues:
	- Data availability is limited to the national level
*/

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\wjp"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

cd "$raw_data"

* correction country name
preserve
import excel using "${ssgd_v2_userpath}\SSGD v2.0\other\list_countries.xlsx", firstrow sheet("countries_codes") clear
rename Country countryname
rename Code countrycode
save "countries_codes.dta", replace
restore

** Labelling
* variables
local t_pl_riggua = "Life and security are effectively guaranteed - Index (0-1, from low to high)"
local t_pl_powlim = "Government powers are limited by the judiciary Index (0-1, from low to high)"
local t_pl_nodis = "Equal treatment and absence of discrimination - Index (0-1, from low to high)"
local t_pl_govreg = "Government regulations are applied and enforced without improper influence - Index (0-1, from low to high)"
local t_pl_accjus = "People can access and afford civil justice - Index (0-1, from low to high)"
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

* -------------------------------------------------------- *
* Loop for years: 2014, 2015, 2016, 2019, 2020, 2021, 2022 *
* -------------------------------------------------------- *

foreach t in 2014 2015 2016 2019 2020 2021 2022{
	* import database
	import excel using "FINAL_2022_wjp_rule_of_law_index_HISTORICAL_DATA_FILE.xlsx", firstrow sheet("WJP ROL Index `t' Scores") case(lower) clear
	* preliminaries (for some years)
	if `t'==2019{
		drop dx dy dz ea eb ec ed ee
	}
	if `t'==2022{
		drop if _n==57 | country=="Income Group*"
	}
	* delete empty rows
	drop if country==""
	* local varlist of all vars
	if (`t'==2016 | `t'==2019 | `t'==2020 | `t'==2021 | `t'==2022){
		rename stvincentandthegrenadines stvincentgred // some countries require to reduction in their name
	}
	describe, varlist
	local varlist `r(varlist)'
	foreach x of local varlist{
		rename `x' country_`x'
	}
	* reshape dataset
	reshape long country_, i(country_country) j(country) string
	* saving labels for countrycode
	preserve
	keep if country_country=="Country Code"
	drop country_country
	rename country_ countrycode
	save "temp.dta", replace
	restore
	* changing variable names
	rename country_country item
	rename country_ rate
	* retaining rows with information at the country level
	drop if country=="country"
	drop if item=="Region" | item=="Country Code"
	* converting rates into numeric variable
	destring rate, replace
	* attaching countrycode
	merge m:1 country using "temp.dta", nogenerate
	erase "temp.dta"
	* selecting indicators: 4.2 / 1.2 / 4.1 / 6.2 / 7.1
	gen code_item = substr(item, 1, 3)
	keep if code_item=="4.2" | code_item=="1.2" | code_item=="4.1" | code_item=="6.2" | code_item=="7.1"
	* rename code_item
	replace code_item = "pl_riggua" if code_item=="4.2"
	replace code_item = "pl_powlim" if code_item=="1.2"
	replace code_item = "pl_nodis" if code_item=="4.1"
	replace code_item = "pl_govreg" if code_item=="6.2"
	replace code_item = "pl_accjus" if code_item=="7.1"
	drop item
	format countrycode %~5s
	* generating a temporary dataset per each variable of interest in WJP
	foreach x in pl_riggua pl_powlim pl_nodis pl_govreg pl_accjus{
		preserve
		keep if code_item=="`x'"
		drop code_item
		* we only know national rates
		rename rate `x'_nat
		* subgroups variables generation (recall the data is only available at the national level)
		gen `x'_fem = .
		gen `x'_male = .
		gen `x'_rural = .
		gen `x'_urban = .
		gen `x'_15_24 = .
		gen `x'_24plus = .
		gen `x'_nwithoutd = .
		gen `x'_pwd = .
		gen `x'_relmin = .
		gen `x'_relmaj = .
		gen `x'_ethmin = .
		gen `x'_ethmaj = .
		gen `x'_15_29 = .
		gen `x'_30_59 = .
		gen `x'_60plus = .
		save "temp_`x'.dta", replace
		restore
	}
	* merging temporary datasets
	use "temp_pl_riggua.dta", clear
	foreach x in pl_powlim pl_nodis pl_govreg pl_accjus{
		merge 1:1 country using "temp_`x'.dta", nogenerate
	}
	* labels
	foreach k in pl_riggua pl_powlim pl_nodis pl_govreg pl_accjus{
		foreach y in _nat _fem _male _rural _urban _15_24 _24plus _nwithoutd _pwd _relmin _relmaj _ethmin _ethmaj _15_29 _30_59 _60plus{
			label var `k'`y' "`t_`k'', `t`y''"
		}
	}
	* generate source and period variables
	gen source = "WJP"
	gen period = `t'
	tostring period, replace
	drop country
	merge 1:1 countrycode using "countries_codes.dta"
	keep if _merge==3
	drop _merge
	order countryname countrycode period source pl_riggua* pl_powlim* pl_nodis* pl_govreg* pl_accjus*
	save "$proc_data\wjp`t'.dta", replace
}

* ----------------- *
* Period: 2012-2013 *
* ----------------- *

* import database
import excel using "FINAL_2022_wjp_rule_of_law_index_HISTORICAL_DATA_FILE.xlsx", firstrow sheet("WJP ROL Index 2012-2013 Scores") case(lower) clear
* delete empty rows
drop if country==""
describe, varlist
local varlist `r(varlist)'
foreach x of local varlist{
	rename `x' country_`x'
}
* reshape dataset
reshape long country_, i(country_country) j(country) string
* saving labels for countrycode (we use data from 2022 for this purpose)
preserve
import excel using "FINAL_2022_wjp_rule_of_law_index_HISTORICAL_DATA_FILE.xlsx", firstrow sheet("WJP ROL Index 2022 Scores") case(lower) clear
drop if _n==57 | country=="Income Group*"
drop if country==""
rename stvincentandthegrenadines stvincentgred
describe, varlist
local varlist `r(varlist)'
foreach x of local varlist{
	rename `x' country_`x'
}
reshape long country_, i(country_country) j(country) string
keep if country_country=="Country Code"
drop country_country
rename country_ countrycode
save "temp.dta", replace
restore
* changing variable names
rename country_country item
rename country_ rate
* retaining rows with information at the country level
drop if country=="country"
drop if item=="Region" | item=="Country Code"
* converting rates into numeric variable
destring rate, replace

* attaching countrycode
merge m:1 country using "temp.dta"
keep if _merge==3
drop _merge
erase "temp.dta"
* selecting indicators: 4.2 / 1.2 / 4.1 / 6.2 / 7.1
gen code_item = substr(item, 1, 3)
keep if code_item=="4.2" | code_item=="1.2" | code_item=="4.1" | code_item=="6.2" | code_item=="7.1"
* rename code_item
replace code_item = "pl_riggua" if code_item=="4.2"
replace code_item = "pl_powlim" if code_item=="1.2"
replace code_item = "pl_nodis" if code_item=="4.1"
replace code_item = "pl_govreg" if code_item=="6.2"
replace code_item = "pl_accjus" if code_item=="7.1"
drop item
format countrycode %~5s
* generating a temporary dataset per each variable of interest in WJP
foreach x in pl_riggua pl_powlim pl_nodis pl_govreg pl_accjus{
	preserve
	keep if code_item=="`x'"
	drop code_item
	rename rate `x'_nat
	* subgroups variables generation (recall the data is only available at the national level)
	gen `x'_fem = .
	gen `x'_male = .
	gen `x'_rural = .
	gen `x'_urban = .
	gen `x'_15_24 = .
	gen `x'_24plus = .
	gen `x'_nwithoutd = .
	gen `x'_pwd = .
	gen `x'_relmin = .
	gen `x'_relmaj = .
	gen `x'_ethmin = .
	gen `x'_ethmaj = .
	gen `x'_15_29 = .
	gen `x'_30_59 = .
	gen `x'_60plus = .
	save "temp_`x'.dta", replace
	restore
}
* merging temporary datasets
use "temp_pl_riggua.dta", clear
foreach x in pl_powlim pl_nodis pl_govreg pl_accjus{
	merge 1:1 country using "temp_`x'.dta", nogenerate
}
* labels
foreach k in pl_riggua pl_powlim pl_nodis pl_govreg pl_accjus{
	foreach y in _nat _fem _male _rural _urban _15_24 _24plus _nwithoutd _pwd _relmin _relmaj _ethmin _ethmaj _15_29 _30_59 _60plus{
		label var `k'`y' "`t_`k'', `t`y''"
	}
}
* generate source and period variables
gen source = "WJP"
gen period = "2012-2013"

drop country
merge 1:1 countrycode using "countries_codes.dta"
keep if _merge==3
drop _merge

order countryname countrycode period source pl_riggua* pl_powlim* pl_nodis* pl_govreg* pl_accjus*
save "$proc_data\wjp2012-2013.dta", replace

* ----------------- *
* Period: 2017-2018 *
* ----------------- *

* import database
import excel using "FINAL_2022_wjp_rule_of_law_index_HISTORICAL_DATA_FILE.xlsx", firstrow sheet("WJP ROL Index 2017-2018 Scores") case(lower) clear
* delete empty rows
drop if country==""
rename stvincentandthegrenadines stvincentgred
describe, varlist
local varlist `r(varlist)'
foreach x of local varlist{
	rename `x' country_`x'
}
* reshape dataset
reshape long country_, i(country_country) j(country) string
* saving labels for countrycode
preserve
keep if country_country=="Country Code"
drop country_country
rename country_ countrycode
save "temp.dta", replace
restore
* changing variable names
rename country_country item
rename country_ rate
* retaining rows with information at the country level
drop if country=="country"
drop if item=="Region" | item=="Country Code"
* converting rates into numeric variable
destring rate, replace
* attaching countrycode
merge m:1 country using "temp.dta", nogenerate
erase "temp.dta"
* selecting indicators: 4.2 / 1.2 / 4.1 / 6.2 / 7.1
gen code_item = substr(item, 1, 3)
keep if code_item=="4.2" | code_item=="1.2" | code_item=="4.1" | code_item=="6.2" | code_item=="7.1"
* rename code_item
replace code_item = "pl_riggua" if code_item=="4.2"
replace code_item = "pl_powlim" if code_item=="1.2"
replace code_item = "pl_nodis" if code_item=="4.1"
replace code_item = "pl_govreg" if code_item=="6.2"
replace code_item = "pl_accjus" if code_item=="7.1"
drop item
format countrycode %~5s
* generating a temporary dataset per each variable of interest in WJP
foreach x in pl_riggua pl_powlim pl_nodis pl_govreg pl_accjus{
	preserve
	keep if code_item=="`x'"
	drop code_item
	rename rate `x'_nat
	* subgroups variables generation (recall the data is only available at the national level)
	gen `x'_fem = .
	gen `x'_male = .
	gen `x'_rural = .
	gen `x'_urban = .
	gen `x'_15_24 = .
	gen `x'_24plus = .
	gen `x'_nwithoutd = .
	gen `x'_pwd = .
	gen `x'_relmin = .
	gen `x'_relmaj = .
	gen `x'_ethmin = .
	gen `x'_ethmaj = .
	gen `x'_15_29 = .
	gen `x'_30_59 = .
	gen `x'_60plus = .
	save "temp_`x'.dta", replace
	restore
}
* merging temporary datasets
use "temp_pl_riggua.dta", clear
foreach x in pl_powlim pl_nodis pl_govreg pl_accjus{
	merge 1:1 country using "temp_`x'.dta", nogenerate
}
* labels
foreach k in pl_riggua pl_powlim pl_nodis pl_govreg pl_accjus{
	foreach y in _nat _fem _male _rural _urban _15_24 _24plus _nwithoutd _pwd _relmin _relmaj _ethmin _ethmaj _15_29 _30_59 _60plus{
		label var `k'`y' "`t_`k'', `t`y''"
	}
}
* generate source and period variables
gen source = "WJP"
gen period = "2017-2018"

drop country
merge 1:1 countrycode using "countries_codes.dta"
keep if _merge==3
drop _merge

order countryname countrycode period source pl_riggua* pl_powlim* pl_nodis* pl_govreg* pl_accjus*
save "$proc_data\wjp2017-2018.dta", replace
