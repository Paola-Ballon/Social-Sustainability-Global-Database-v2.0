* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* last update: July 7th, 2023
* original data source: https://www.arabbarometer.org/survey-data/data-downloads/

/*
Issues:
	- Respondents have 17+ years old
	- No data on ethnic group [subgroup]
	- No data on religion for Kuwait [subgroup]
	- The disability subgroup is constructed by using the number of hh member with disability. It is not what we are looking for. [subgroup]
*/

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\arabbarometer5"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

* -------------------- *
* Data standardization *
* -------------------- *

cd "$raw_data"

use "ABV_Release_Data.dta", clear

* -------------------- *
* Generating subgroups *
* -------------------- *

* s1: sex
recode Q1002 (2=0)
rename Q1002 sex
label define sex 1 "Male" 0 "Female"
label values sex sex

* s2: age
recode Q1001 (99999=.)
rename Q1001 age

* s3: race 
gen ethnic_group = .

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
recode Q1012 (4=91) // no religion
recode Q1012 (1=95) // muslim
recode Q1012 (2=96) // christian
recode Q1012 (3=97) // other
recode Q1012 (99=.)
recode Q1012 (91=1) (95=5) (96=6) (97=7)
rename Q1012 religion
label define religion 1 "No religion" 2 "Buddhist" 3 "Hindu" 4 "Jewish" 5 "Muslim" 6 "Christian" 7 "Other"
label values religion religion

* s5: region
recode q1 (99998=.)
rename q1 region

* s6: domain/urban
gen urban = .
replace urban = 0 if q13==2 | q13==3 // rural, camp
replace urban = 1 if q13==1 // urban

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

* s9: disability [NO DATA]
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

* s11: major ethnic group [NO DATA]
gen ethnic_major = .
gen eth_major_count = .

* -------------------- *
* Generating variables *
* -------------------- *

* v1: To what extent do you think that (Freedom to express opinions) ] is guaranteed in your country?
/*
	1	Guaranteed to a great extent
	2	Guaranteed to a medium extent
	3	Guaranteed to a limited extent
	4	Not guaranteed at all
*/
gen free_speak = (Q521_1==1) // Guaranteed to a great extent
replace free_speak = . if Q521_1==98 | Q521_1==99 | Q521_1==.

* v2: During the past three years, did you (Attend a meeting to discuss a subject or sign a petition)
/*
	1	once
	2	more than once
	3	never
	98	don't know
	99	refused
*/
gen attended_demons = (Q502_2>=1 & Q502_2<=2)
replace attended_demons = . if Q502_2==98 | Q502_2==99 | Q502_2==.

* v3: On average, how often do you use the Internet
/*
	1	Throughout the day
	2	At least once daily
	3	Several times a week
	4	Once a week
	5	Less than once a week
	6	I do not use the Internet
*/
gen internet_use = (Q409>=1 & Q409<=5)
replace internet_use = . if Q409==98 | Q409==99 | Q409==.

* v4: Have you volunteered for any local group / organization regardless of your status of membership?
/*
	1	yes
	2	no
	98	don't know
	99	refused
*/
gen voluntary_assoc = (Q501A==1)
replace voluntary_assoc = . if Q501A==98 | Q501A==99 | Q501A==.

* v5: For each one, please tell me how much trust you have in them: Government
/*
	1	A great deal of trust
	2	Quite a lot of trust
	3	Not a lot of trust
	4	No trust at all
*/
gen conf_govern = (Q201A_1==1 | Q201A_1==2) // a great deal or quite a lot of trust
replace conf_govern = . if Q201A_1==98 | Q201A_1==99 | Q201A_1==.

* v6: For each one, please tell me how much trust you have in them: Courts
/*
	1	A great deal of trust
	2	Quite a lot of trust
	3	Not a lot of trust
	4	No trust at all
*/
gen conf_justice = (Q201A_2==1 | Q201A_2==2) // a great deal or quite a lot of trust
replace conf_justice = . if Q201A_2==98 | Q201A_2==99 | Q201A_2==.

* v7: For each one, please tell me how much trust you have in them: Police
/*
	1	A great deal of trust
	2	Quite a lot of trust
	3	Not a lot of trust
	4	No trust at all
	98	Don’t know
	99	Refused to answer
*/
gen conf_police = (Q201A_42>=1 & Q201A_42<=2)
replace conf_police = . if Q201A_42==98 | Q201A_42==99 | Q201A_42==.

* v8: Freedom to join civil associations and organizations
/*
	1	great extent
	2	medium extent
	3	limited extent
	4	not at all
	98	don't know
	99	refused
*/
gen free_join = (Q521_5==1 & Q521_5==2)
replace free_join = . if Q521_5==98 | Q521_5==99 | Q521_5==.

* v9: For each of the statements listed below, please indicate whether you agree strongly, agree, disagree, or disagree strongly with it: In general, men are better at political leadership than women
/*
	1	Strongly agree
	2	Agree
	3	Disagree
	4	Strongly disagree
*/
gen men_better = (Q601_3>=1 & Q601_3<=2)
replace men_better = . if Q601_3==98 | Q601_3==99 | Q601_3==.

* v10: Which of these statements comes closest to describing your net household income?: Our net household income covers our expenses, and we are able to save
/*
	1 Our net household	income covers our expenses and we are able to save
	2 Our net household	income covers our expenses without notable difficulties
	3 Our net household	income does not cover our expenses; we face some difficulties
	4 Our net household	income does not cover our expenses; we face significant difficulties
*/
gen save_money = (Q1016==1)
replace save_money = . if Q1016==98 | Q1016==99 | Q1016==.

* extra 1: People who have at least one household member living with disabilities
gen ex_disability2 = (Q1018>=1)
replace ex_disability2 = . if Q1018==98 | Q1018==99 | Q1018==.

* ---------------- *
* Rename variables *
* ---------------- *

rename free_speak sc_frespe
rename attended_demons sc_attdem
rename internet_use si_intuse
rename voluntary_assoc sc_volass
rename conf_govern sc_congov
rename conf_justice sc_conjus
rename conf_police sc_conpol
rename free_join sc_frejoi
rename men_better si_menbet
rename save_money re_savmon

* ------------------------------------------------------- *
* Generating interactions between subgroups and variables *
* ------------------------------------------------------- *
	
* macros for lists
global vars "sc_frespe sc_attdem si_intuse sc_volass sc_congov sc_conjus sc_conpol sc_frejoi si_menbet re_savmon"
global subgroups "sex urban youth disability rel_major ethnic_major"
foreach z in $subgroups{
	if ("`z'"!="disability" & "`z'"!="ethnic_major"){ // recall that we have no data on disability
		levelsof `z', local(val_`z')
		foreach y in $vars{
			foreach t of local val_`z'{
				gen `y'_`z'`t' = `y' if `z'==`t'
			}
		}
	}
	if ("`z'"=="disability" | "`z'"=="ethnic_major"){
		foreach y in $vars{
			gen `y'_`z'0 = -1
			gen `y'_`z'1 = -1
		}
	}
}

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
gen t1 = year(date)
bys country: egen t2 = max(t1)
replace t2 = 2018 if country==22 // correction for Yemen (missing date information)
gen period = t2
tostring period, replace
drop t1 t2

* data source
gen source = "Arab barometer 5"

* ----------------- *
* Collapse the data *
* ----------------- *

collapse (mean) sc_frespe* sc_attdem* si_intuse* sc_volass* sc_congov* sc_conjus* sc_conpol* sc_frejoi* si_menbet* re_savmon* ex_disability2 [aw=wt], by(countryname period source)

* --------- *
* Labelling *
* --------- *

* variables
local t_sc_frespe = "Share of population that agrees they are free to express what they think"
local t_sc_attdem = "Share of population that has ever attended a demonstration or protest march"
local t_si_intuse = "Share of population that uses the Internet"
local t_sc_volass = "Share of population that participates in voluntary associations , organizations or community groups"
local t_sc_congov = "Share of population that says they have confidence in the Government"
local t_sc_conjus = "Share of population that says they have confidence in the Justice System"
local t_sc_conpol = "Share of population that says they have confidence in the Police"
local t_sc_frejoi = "Share of population that agrees they are free to join any organization they like without fear"
local t_si_menbet = "Share of population that agrees or strongly agrees men make better political leaders than women"
local t_re_savmon = "Share of population that saves some money"
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
label var ex_disability2 "Percentage of people who have at least one household member living with disabilities"

* recoding missing values
foreach vars in sc_frespe* sc_attdem* si_intuse* sc_volass* sc_congov* sc_conjus* sc_conpol* sc_frejoi* si_menbet* re_savmon*{
	recode `vars' (-1=.)
}

* Attaching country codes
preserve
import excel using "${ssgd_v2_userpath}\SSGD v2.0\other\list_countries.xlsx", firstrow sheet("countries_codes") clear
rename Country countryname
rename Code countrycode
save "countries_codes.dta", replace
restore
* merging process
merge 1:1 countryname using "countries_codes.dta"
keep if _merge==3
drop _merge

order countryname countrycode period source

* ------ * 
* Saving *
* ------ *

save "$proc_data\arabbarometer5.dta", replace

erase "countries_codes.dta"
