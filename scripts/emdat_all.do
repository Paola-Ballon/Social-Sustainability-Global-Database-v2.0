* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* last update: December 10, 2023
* original data source: https://public.emdat.be/data

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\emdat"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

cd "$raw_data"

import excel using "emdat_public_2023_06_18_query_uid-g0uFg8.xlsx", firstrow case(lower) clear

* preliminaries
drop if _n<=5
drop if _n==1
rename emdatcreduclouvainbrusse year
rename k countryname
rename l countrycode
rename am affected // this is the number of affected population (includes deaths, injured, homeless and other affected individuals)

* we just keep the relevant variables
keep countryname countrycode year affected
order countryname countrycode year affected
destring year affected, replace // convert year and affected population into numeric

* collapse the data at the country and year level
collapse (sum) affected, by(countryname countrycode year)
encode countryname, g(country)
tsset country year
tsfill, full // we fill the gaps for countries that do not appear in a particular year
drop countryname
decode country, g(countryname)
drop country

* we attach information on countrycode because the filling procedure do not account for this information
preserve
collapse (firstnm) countrycode, by(countryname)
save "temp1.dta"
restore
drop countrycode
merge m:1 countryname using "temp1.dta", nogenerate
order countryname countrycode year affected
erase "temp1.dta"

* rename variables/creating subgroups
rename affected re_totaff_nat
foreach x in _fem _male _rural _urban _15_24 _24plus _nwithoutd _pwd _relmin _relmaj _ethmin _ethmaj _15_29 _30_59 _60plus{
	gen re_totaff`x' = .
}

* we scale the variable to be an index between 0 and 1
qui: sum re_totaff_nat
replace re_totaff_nat = (re_totaff_nat - r(min))/(r(max) - r(min))

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

* --------- *
* Labelling *
* --------- *

* variables
local t_re_totaff = "Share of population affected by climate change (Index 0-1, low to high)"
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
foreach x in re_totaff{
	foreach y in _nat _fem _male _rural _urban _15_24 _24plus _nwithoutd _pwd _relmin _relmaj _ethmin _ethmaj _15_29 _30_59 _60plus{
		label var `x'`y' "`t_`x'', `t`y''"
	}
}
recode re_totaff_nat (.=0)

* final data arrangement
forvalues t = 2018/2022{
	preserve
	keep if year==`t'
	rename year period
	tostring period, replace
	gen source = "EMDAT"
	order countryname countrycode period source
	save "$proc_data\emdat`t'.dta", replace
	restore
}

erase "countries_codes.dta"
