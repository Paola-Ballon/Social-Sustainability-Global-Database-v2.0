* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* last update: December 10, 2023
* original data source: https://search.gesis.org/research_data/ZA7500

/*
Issues:
	- 
*/

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\evs"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

cd "$raw_data"

use "ZA7500_v5-0-0.dta", clear

* ------------- *
* Preliminaries *
* ------------- *

* rename sampling weight variable
rename gweight weight

* -------------------- *
* Generating subgroups *
* -------------------- *

* s1: sex
recode v225 (-2=.) (-1=.) (2=0)
rename v225 sex
label define sex 1 "Male" 0 "Female"
label values sex sex

* s2: age
recode age (-2=.) (-1=.)

* s3: race [not available]

* s4: religion
/*
Classification based on IPUMS international:
1 = No religion
2 = Buddhist
3 = Hindu
4 = Jewish
5 = Muslim
6 = Christian
7 = Other
*/
gen t1 = .
replace t1 = 1 if v51==2 // no religion
replace t1 = 2 if v51==1 & v52==7 // buddhist
replace t1 = 3 if v51==1 & v52==6 // hindu
replace t1 = 4 if v51==1 & v52==4 // jewish
replace t1 = 5 if v51==1 & v52==5 // muslim
replace t1 = 6 if v51==1 & (v52==1 | v52==2 | v52==3 | v52==8) // christian
replace t1 = 7 if v51==-1 | (v51==1 & v52==9) // other
rename t1 religion
label define religion 1 "No religion" 2 "Buddhist" 3 "Hindu" 4 "Jewish" 5 "Muslim" 6 "Christian" 7 "Other"
label values religion religion

* s5: region
rename v275c_N2 region

* s6: domain/urban [not available]
* s7: age groups
gen ageg1 = (age>=15 & age<=29) // group 1: 15 to 29 years old
replace ageg1 = . if age==.
gen ageg2 = (age>=30 & age<=59) // group 2: 30 to 59 years old
replace ageg2 = . if age==.
gen ageg3 = (age>=60) // group 3: 60+ years old
replace ageg3 = . if age==.

* s8: youth group
gen youth = (age>=15 & age<=24)
replace youth = . if age==.

* s9: disability [not available]
gen disability = -1

* s10: major religion
levelsof religion, local(v_religion)
bys country: egen xt = count(religion)
foreach t of local v_religion{
	bys country: egen x`t' = count(religion) if religion==`t'
	bys country: gen sx`t' = x`t'/xt if religion==`t' // computing shares by religion
}
egen tot = rowtotal(sx*), m
bys country: egen y = max(tot)
gen rel_major = (tot==y) // identifying the highest share with major religion
replace rel_major = . if tot==. | y==.
drop x* sx* tot y
* Count of major religions
gen rel_major_count = .
levelsof country, local(countries)
foreach x of local countries{
    levelsof religion if rel_major==1 & country==`x', local(list_mode_rel)
	replace rel_major_count = `:word count `list_mode_rel'' if country==`x'
}
* fixes
replace rel_major = 0 if religion==1 & country==428 // Latvia

* s11: major ethnic group
gen ethnic_major = .
gen eth_major_count = .

* -------------------- *
* Generating variables *
* -------------------- *

* Confidence in government
/*
-10	multiple answers Mail
-9	no follow-up
-8	follow-up non response
-5	other missing
-4	item not included
-3	not applicable
-2	no answer
-1	dont know
1	a great deal
2	quite a lot
3	not very much
4	none at all
*/
gen conf_govern = (v131==1 | v131==2)
replace conf_govern = . if v131==. | v131==-1 | v131==-2

* feels insecure living in neighborhood [not available]

* Attended to lawful demonstrations or might do
gen attended_demons = (v100==1 | v100==2)
replace attended_demons = . if v100==. | v100==-2 | v100==-1

* ---------------- *
* Rename variables *
* ---------------- *

rename conf_govern sc_congov
rename attended_demons sc_attdem

* ------------------------------------------------------- *
* Generating interactions between subgroups and variables *
* ------------------------------------------------------- *
	
* macros for lists
global vars "sc_congov sc_attdem"
global subgroups "sex youth urban disability rel_major ethnic_major"
foreach z in $subgroups{
	if ("`z'"!="disability" & "`z'"!="urban" & "`z'"!="ethnic_major"){
		levelsof `z', local(val_`z')
		foreach y in $vars{
			foreach t of local val_`z'{
				gen `y'_`z'`t' = `y' if `z'==`t'
			}
		}
	}
	if ("`z'"=="disability" | "`z'"=="urban" | "`z'"=="ethnic_major"){ // recall that we have no data on disability
		foreach y in $vars{
			gen `y'_`z'0 = -1
			gen `y'_`z'1 = -1
		}
	}
}

/*
* fixes
foreach y in $vars{
	capture: quietly: tab `y'_ethnic_major0, rc
	if _rc==111{
		gen `y'_ethnic_major0 = -1
	}
}
*/

foreach var in $vars{
	gen `var'_ageg1 = `var' if ageg1==1
	gen `var'_ageg2 = `var' if ageg2==1
	gen `var'_ageg3 = `var' if ageg3==1
}

* --------------- *
* changing suffix *
* --------------- *

foreach y in $vars{
	rename `y' `y'_nat
	rename `y'_sex0 `y'_fem
	rename `y'_sex1 `y'_male
	rename `y'_urban0 `y'_rural
	rename `y'_urban1 `y'_urban
	rename `y'_youth1 `y'_15_24
	rename `y'_youth0 `y'_24plus
	rename `y'_disability0 `y'_nwithoutd
	rename `y'_disability1 `y'_pwd
	rename `y'_rel_major0 `y'_relmin
	rename `y'_rel_major1 `y'_relmaj
	rename `y'_ethnic_major0 `y'_ethmin
	rename `y'_ethnic_major1 `y'_ethmaj
	rename `y'_ageg1 `y'_15_29
	rename `y'_ageg2 `y'_30_59
	rename `y'_ageg3 `y'_60plus
}

* ------------------ *
* Supplementary data *
* ------------------ *

* string countryname
decode country, g(countryname)

* add survey year
gen period = year
tostring period, replace

* data source
gen source = "EVS 2017"

/*
* fixing sampling weight name
capture: quietly: tab withinwt, rc
if _rc==111{
	rename withinwt_ea withinwt
}
*/

* ----------------- *
* Collapse the data *
* ----------------- *

collapse (mean) sc_congov* sc_attdem* rel_major_count eth_major_count [aw=weight], by(countryname period source)

* --------- *
* Labelling *
* --------- *

* variables
local t_sc_congov = "Share of population that says they have confidence in the Government"
local t_sc_attdem = "Share of population that has ever attended a demonstration or protest march"
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
foreach x in $vars{
	foreach y in _nat _fem _male _rural _urban _15_24 _24plus _nwithoutd _pwd _relmin _relmaj _ethmin _ethmaj _15_29 _30_59 _60plus{
		label var `x'`y' "`t_`x'', `t`y''"
	}
}

* recoding missing values
foreach vars in sc_congov* sc_attdem*{
	recode `vars' (-1=.)
}

* Attaching country codes
replace countryname = "Czech Republic" if countryname=="Czechia"
replace countryname = "United Kingdom" if countryname=="Great Britain"
replace countryname = "Slovak Republic" if countryname=="Slovakia"
preserve
import excel using "D:\Omar\World Bank\SSG database\list_countries.xlsx", firstrow sheet("countries_codes") clear
rename Country countryname
rename Code countrycode
save "countries_codes.dta", replace
restore
* merging process
merge 1:1 countryname using "countries_codes.dta"
keep if _merge==3
drop _merge rel_major_count eth_major_count

order countryname countrycode period source

* ------ *
* Saving *
* ------ *

save "$proc_data\evs.dta", replace

erase "countries_codes.dta"
