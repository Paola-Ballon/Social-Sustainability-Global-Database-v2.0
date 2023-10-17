* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* last update: July 7th, 2023
* original data source: https://www.asianbarometer.org/data?page=d10

/*
Issues:
	- No information on disability [subgroup]
	- No information on ethnicity for Japan and Hong Kong [subgroup]
	- No information on active membership in an organization for China [variable]
	- No information on trust in the election comission for China, Indonesia and Singapore [variable]
	- No information on trust in the local government for Singapore [variable]
	- No information on attendance to a demonstration or protest for Vietnam [variable]
	- No information on vote in recent elections for Vietnam [variable]
*/

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\asianbarometer4"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

* -------------------- *
* Data standardization *
* -------------------- *

cd "$raw_data"

use "W4_v15_merged20181211_release.dta", clear

* -------------------- *
* Generating subgroups *
* -------------------- *

* s1: sex
recode se2 (2=0) (-1=.)
rename se2 sex
label define sex 1 "Male" 0 "Female"
label values sex sex

* s2: age
recode se3_2 (-1=.)
rename se3_2 age

* s3: ethnicity 
recode se11a (-1=.) (98/99=.)
rename se11a ethnic_group

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
recode se6 (90=991) // no religion
recode se6 (60/61=992) // buddhist
recode se6 (50=993) // hindu
recode se6 (30=994) // jewish
recode se6 (40=995) (42=995) // muslim
recode se6 (10=996) (20=996) (24=996) (72/74=996) // christian
recode se6 (1=997) (70/71=997) (75/77=997) (80=997) // other
recode se6 (-1=.) (98/99=.)
rename se6 religion
label define religion 1 "No religion" 2 "Buddhist" 3 "Hindu" 4 "Jewish" 5 "Muslim" 6 "Christian" 7 "Other"
label values religion religion

* s5: region
d region

* s6: domain/urban
recode level (-1=.)
gen urban = .
replace urban = 0 if level==1 // rural
replace urban = 1 if level==2 // urban

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

* s11: major ethnic group
levelsof ethnic_group, local(v_ethnic_group)
bys country: egen xt = count(ethnic_group)
foreach t of local v_ethnic_group{
	bys country: egen x`t' = count(ethnic_group) if ethnic_group==`t'
	bys country: gen sx`t' = x`t'/xt if ethnic_group==`t' // computing shares by race
}
egen tot = rowtotal(sx*), m
bys country: egen y = max(tot)
gen ethnic_major = (tot==y) // identifying the highest share with major ethnic group
replace ethnic_major = . if tot==. | y==.
drop x* sx* tot y
* Count of major ethnic group
gen eth_major_count = .
levelsof country, local(countries)
foreach x of local countries{
    levelsof ethnic_group if ethnic_major==1 & country==`x', local(list_mode_eth)
	replace eth_major_count = `:word count `list_mode_eth'' if country==`x'
}

* -------------------- *
* Generating variables *
* -------------------- *

* v1: People are free to speak what they think without fear
/*
	-1	Missing
	1	Strongly agree
	2	Somewhat agree
	3	Somewhat disagree
	4	Strongly disagree
	7	Don't understand the	question
	8	Can't choose
	9	Decline to answer
*/
gen free_speak = (q108>=1 & q108<=2)
replace free_speak = . if q108==7 | q108==8 | q108==9 | q108==-1 | q108==.

* v2: People can join any organization they like without fear
/*
	-1	Missing
	1	Strongly agree
	2	Somewhat agree
	3	Somewhat disagree
	4	Strongly disagree
	7	Don't understand the	question
	8	Can't choose
	9	Decline to answer
*/
gen free_join = (q109>=1 & q109<=2)
replace free_join = . if q109==7 | q109==8 | q109==9 | q109==-1 | q109==.

* v3: Did you vote in the last national election?
/*
	-1	missing
	0	Not applicable/not yet eligible	to	vote
	1	Yes
	2	No
	7	Do not understand the question
	8	Can't choose
	9	Decline to answer
*/
gen vote_nat = (q33==1)
replace vote_nat = . if q33==7 | q33==8 | q33==9 | q33==-1 | q33==.

* v4: Attended a demonstration or protest march
/*
	-1 Missing
	1 I have done this more than once
    2 I have done this once
    3 I have never done this.
    7 Do not understand the question
    8 Can't choose
    9 Decline to answer
*/
gen attended_demons = (q76==1 | q76==2)
replace attended_demons = . if q76==7 | q76==8 | q76==9 | q76==-1 | q76==.

* v5: How often do you use the internet, either through computer, tablet or smartphone
/*
	-1	Missing
	0	Not applicable
	1	Several hours a day
	2	About half an hour to	an hour a	day
	3	At least once a day
	4	At least once a week
	5	At least once a month
	6	A few times a year
	7	Hardly ever
	8	Never
	97	Do not understand the	question
	98	Can't choose
	99	Decline to answer
*/
gen internet_use = (q49>=1 & q49<=7)
replace internet_use = . if q49==97 | q49==98 | q49==99 | q49==0 | q49==-1 | q49==.

* v6: Trust in the police
/*
	-1	Mssing
	1	A great deal of trust
	2	Quite a lot of trust
	3	Not very much trust
	4	None at all
	7	Do not understand the	question
	8	Can't choose
	9	Decline to answer
*/
gen conf_police = (q14>=1 & q14<=2)
replace conf_police = . if q14==7 | q14==8 | q14==9 | q14==-1 | q14==.

* v7: Trust in the local government
/*
	-1	Mssing
	1	A great deal of trust
	2	Quite a lot of trust
	3	Not very much trust
	4	None at all
	7	Do not understand the	question
	8	Can't choose
	9	Decline to answer
*/
gen conf_govern = (q15>=1 & q15<=2)
replace conf_govern = . if q15==7 | q15==8 | q15==9 | q15==-1 | q15==.

* v8: Trust in the election commission
/*
	-1	Mssing
	1	A great deal of trust
	2	Quite a lot of trust
	3	Not very much trust
	4	None at all
	7	Do not understand the	question
	8	Can't choose
	9	Decline to answer
*/
gen conf_elections = (q18>=1 & q18<=2)
replace conf_elections = . if q18==7 | q18==8 | q18==9 | q18==-1 | q18==.

* v9: Confidence in the courts
/*
	-1	Mssing
	1	A great deal of trust
	2	Quite a lot of trust
	3	Not very much trust
	4	None at all
	7	Do not understand the	question
	8	Can't choose
	9	Decline to answer
*/
gen conf_justice = (q8==1 | q8==2)
replace conf_justice = . if q8==7 | q8==8 | q8==9 | q8==-1 | q8==.

* v10: Would you say that "Most people can be trusted" or "that you must be very car
/*
	-1	Mising
	1	Most people can be trusted
	2	You must be very careful in dealing	with	people
	7	Do not understand the question
	8	Can't choose
	9	Decline to answer
*/
gen trustinpeople = (q23==1)
replace trustinpeople = . if q23==7 | q23==8 | q23==9 | q23==-1 | q23==.

* v11: Does the total income of your household allow you to satisactorily cover your needs
/*
	-1	Missing
	0	Not applicable
	1	Our income covers the needs well, we can save
	2	Our income covers the needs all right, without	much difficulties
	3	Our income does not cover the needs, there are	difficulties
	7	Do not understand the question
	8	Can't choose
	9	Decline to answer
*/
gen save_money = (se14a==1)
replace save_money = . if se14a==7 | se14a==8 | se14a==9 | se14a==-1 | se14a==0 | se14a==.

* v12: How safe is living in this city/ town/ village: unsafe and very unsafe
/*
	-1	Missing
	1	Very safe
	2	Safe
	3	Unsafe
	4	Very unsafe
	7	Do not undertstand	the	question
	8	Can't choose
	9	Decline to answer
*/
gen insecure_neigh = (q43>=3 & q43<=4)
replace insecure_neigh=. if q43==7 | q43==8 | q43==9 | q43==-1 | q43==.

* v13: Whether the respondent is a member of an organization
/*
	-1	Missing
	0	Not applicable
	1	Political parties
	2	Residential & community associations
	3	Religious groups
	4	Sports/recreational clubs
	5	Culture organizations
	6	Charities
	7	Public interest groups
	8	Labor unions
	9	Farmer unions or agricultural associations
	10	Professional organizations
	11	Business associations
	12	Parent-Teacher associations
	13	Producer cooperatives
	14	Consumer cooperatives
	15	Alumni associations
	16	Candidate support organizations
	17	Other occupational organizations
	18	Other volunteer organizations
	19	Student Associations
	20	Mutual assistance associations
	21	Other
	90	Not a member of any organization or group
	97	Do not understand the question
	98	Can't choose
	99	Decline to answer
*/
gen active_mem = (q20!=90)
replace active_mem = . if q20==0 | q20==-1 | q20==97 | q20==98 | q20==99 | q20==.

* v14: Got together with others face-to-face to try to resolve local problems
/*
	-1	Missing
	1	I have done this more than once
	2	I have done this once
	3	I have never done this.
	7	Do not understand the question
	8	Can't choose
	9	Decline to answer
*/
gen solve_problems = (q74==1 | q74==2)
replace solve_problems=. if q74==7 | q74==8 | q74==9 | q74==-1 | q74==.

* ---------------- *
* Rename variables *
* ---------------- *

rename free_speak sc_frespe
rename free_join sc_frejoi
rename vote_nat sc_vot
rename attended_demons sc_attdem
rename internet_use si_intuse
rename conf_police sc_conpol
rename conf_govern sc_congov
rename conf_elections sc_conele
rename conf_justice sc_conjus
rename trustinpeople sc_trupeo
rename save_money re_savmon
rename insecure_neigh sc_insnei
rename active_mem sc_actmem
rename solve_problems sc_solpro

* ------------------------------------------------------- *
* Generating interactions between subgroups and variables *
* ------------------------------------------------------- *

* macros for lists
global vars "sc_frespe sc_frejoi sc_vot sc_attdem si_intuse sc_conpol sc_congov sc_conele sc_conjus sc_trupeo re_savmon sc_insnei sc_actmem sc_solpro"
global subgroups "sex urban youth disability rel_major ethnic_major"
foreach z in $subgroups{
	if ("`z'"!="disability"){ // recall that we have no data on disability
		levelsof `z', local(val_`z')
		foreach y in $vars{
			foreach t of local val_`z'{
				gen `y'_`z'`t' = `y' if `z'==`t'
			}
		}
	}
	if ("`z'"=="disability"){
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
bys country: egen t1 = max(year)
gen period = t1
tostring period, replace
drop t1

* data source
gen source = "Asianbarometer 4"

* ----------------- *
* Collapse the data *
* ----------------- *

collapse (mean) sc_frespe* sc_frejoi* sc_vot* sc_attdem* si_intuse* sc_conpol* sc_congov* sc_conele* sc_conjus* sc_trupeo* re_savmon* sc_insnei* sc_actmem* sc_solpro* [aw=w], by(countryname period source)

* --------- *
* Labelling *
* --------- *

* variables
local t_sc_frespe = "Share of population that agrees they are free to express what they think"
local t_sc_frejoi = "Share of population that agrees they are free to join any organization they like without fear"
local t_sc_vot = "Share of population that voted in the last national elections"
local t_sc_attdem = "Share of population that has ever attended a demonstration or protest march"
local t_si_intuse = "Share of population that uses the Internet"
local t_sc_conpol = "Share of population that says they have confidence in the Police"
local t_sc_congov = "Share of population that says they have confidence in the Government"
local t_sc_conele = "Share of population that says they have confidence in the elections"
local t_sc_conjus = "Share of population that says they have confidence in the Justice System"
local t_sc_trupeo = "Share of population that says that most people can be trusted"
local t_re_savmon = "Share of population that saves some money"
local t_sc_insnei = "Share of population that feels insecure living in their neighborhood / town / village"
local t_sc_actmem = "Share of population that are active members of organizations"
local t_sc_solpro = "Share of population that got together with others to try to resolve local problems"
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
foreach vars in sc_frespe* sc_frejoi* sc_vot* sc_attdem* si_intuse* sc_conpol* sc_congov* sc_conele* sc_conjus* sc_trupeo* re_savmon* sc_insnei* sc_actmem* sc_solpro*{
	recode `vars' (-1=.)
}

* Attaching country codes
replace countryname = "Hong Kong SAR" if countryname=="Hong Kong"
replace countryname = "Taiwan ROC" if countryname=="Taiwan"
replace countryname = "South Korea" if countryname=="Korea"
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

save "$proc_data\asianbarometer4.dta", replace

erase "countries_codes.dta"
