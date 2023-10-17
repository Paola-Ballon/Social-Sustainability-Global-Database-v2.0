* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* last update: July 7th, 2023
* original data source: https://www.afrobarometer.org/data/data-sets/

/*
Issues:
	- Respondents have 18+ years
	- No data on ethnic group for Sudan and Tunisia [subgroup]
	- No data on disability [subgroup]
	- There is a difference between not being dependent on receiving remittances and not receiving it at all [variable]
	- No data on most people can be trusted [variable]
*/

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\afrobarometer7"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

* -------------------- *
* Data standardization *
* -------------------- *

cd "$raw_data"

import spss using "r7_merged_data_34ctry.release.sav", case(lower) clear

* -------------------- *
* Generating subgroups *
* -------------------- *

* s1: sex
recode q101 (2=0) (-1=.)
rename q101 sex
label define sex 1 "Male" 0 "Female"
label values sex sex

* s2: age
recode q1 (998/999=.)
rename q1 age

* s3: ethnicity 
recode q84 (-1=.) (9996/9999=.)
rename q84 ethnic_group

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
recode q98 (0=91) (28/29=1) // no religion
recode q98 (26=93) // hindu
recode q98 (34=94) // jewish
recode q98 (18/24=95) (181=95) (500=95) (620=95) (740=95) (931=95) (1100=95) // muslim
recode q98 (1/17=96) (30/33=96) // christian
foreach t in 100 220 260 460 540 541 700 742 743 744 745 821 822 823 824 860 1220 1620 1621 1622 1660 1661 1662 1700 1701 1702{
	recode q98 (`t'=96) // christian
}
recode q98 (25=97) (27=97) (101=97) (660=97) (9995=97) // other
recode q98 (-1=.) (9998/9999=.)
recode q98 (91=1) (93=3) (94=4) (95=5) (96=6) (97=7)
rename q98 religion
label define religion 1 "No religion" 2 "Buddhist" 3 "Hindu" 4 "Jewish" 5 "Muslim" 6 "Christian" 7 "Other"
label values religion religion

* s5: region
d region

* s6: domain/urban
gen urban = .
replace urban = 0 if urbrur==2 // rural
replace urban = 1 if urbrur==1 | urbrur==3 | urbrur==460 // urban, semi-urban, peri-urban

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

* v1: Own bank account
/*
	Missing	-1
	No, don’t own	0
	Yes, someone els	1
	Yes, do own	2
	Refused	8
	Don’t know	9
*/
gen own_bank_account = (q89e==2) // only option "yes, do own"
replace own_bank_account = . if q89e==8 | q89e==9 | q89e==-1 | q89e==.

* v2: How dependent on receiving remittances
/*
	-1	Missing
	0	Not at all /	Does	not	receive	remittances
	1	A little bit
	2	Somewhat
	3	A lot
	8	Refused
	9	Don’t know
*/
gen remittances = (q9>=1 & q9<=3) // a little bit, somewhat, a lot
replace remittances=. if q9==8 | q9==9 | q9==-1 | q9==.

* v3: Freedom to say what you think
/*
	Not at all free	1
	Not very free	2
	Somewhat free	3
	Completely free	4
	Refused	8
	Don’t know	9
*/
gen free_speak = (q14==4) // completely free = freedom of speech
replace free_speak = . if q14==8 | q14==9 | q14==-1 | q94==.

* v4: Voting in the most recent national election
/*
	-1	Missing
	0	You were not registered to vote
	1	You voted in the elections
	2	You decided not to vote
	3	You could not find the polling station
	4	You were prevented from voting
	5	You did not have time to vote
	6	You did not vote because your name not	in	the	register
	7	Did not vote for some other reason
	8	You were too young to vote
	9	Don’t Know / Can’t remember
	98	Refused
*/
gen vote_nat = (q22==1)
replace vote_nat = . if q22==98 | q22==9 | q22==-1 | q22==.

* v5: Attend a demostration or protest march
/*
	Missing	-1
	No, would never	0
	No, but would do	1
	Yes, once or twi	2
	Yes, several tim	3
	Yes, often	4
	Refused	8
	Don't know	9
*/
gen attended_demons = (q26e>=2 & q26e<=4) // yes, once or twice, several times, often
replace attended_demons=. if q26e==8 | q26e==9 | q26e==-1 | q26e==.

* v6: How often use the internet
/*
	Missing	-1
	Never	0
	Less than once a	1
	A few times a mo	2
	A few times a we	3
	Everyday	4
	Refused	8
	Don't know	9
*/
gen internet_use = (q91b>=1 & q91b<=4) // less than once a month, a few times a month (a week), everyday
replace internet_use = . if q91b==8 | q91b==9 | q91b==-1 | q91b==.

* v7: How often gone without food
/*
	Never	0
	Just once or twi	1
	Several times	2
	Many times	3
	Always	4
	Refused	8
	Don't know	9
*/
gen enough_food = (q8a>=1 & q8a<=4) // just once or twice, several times, many times, always
replace enough_food=. if q8a==8 | q8a==9 | q8a==-1 | q8a==.

* v8: Member of voluntary association or community group
/*
	-1	Missing
	0	Not a Member
	1	Inactive Member
	2	Active Member
	3	Official Leader
	8	Refused
	9	Don't know
*/
gen voluntary_assoc = (q20b>=2 & q20b<=3) // active member, official leader
replace voluntary_assoc=. if q20b==8 | q20b==9 | q20b==-1 | q20b==.

* v9: Trust police
/*
	Not at all	0
	Just a little	1
	Somewhat	2
	A lot	3
	Refused	8
	Don’t know/Haven	9
*/
gen conf_police = (q43g==2 | q43g==3) // somewhat, a lot
replace conf_police=. if q43g==8 | q43g==9 | q43g==-1 | q43g==.

* v10: Trust courts of law
/*
	Not at all	0
	Just a little	1
	Somewhat	2
	A lot	3
	Refused	8
	Don’t know/Haven	9
*/
gen conf_justice = (q43i==2 | q43i==3) // somewhat, a lot
replace conf_justice=. if q43i==8 | q43i==9 | q43i==-1 | q43i==.

* v11: Trust national electoral commission
/*
	Not at all	0
	Just a little	1
	Somewhat	2
	A lot	3
	Refused	8
	Don’t know/Haven	9
*/
gen conf_elections = (q43c==2 | q43c==3) // somewhat, a lot
replace conf_elections=. if q43c==8 | q43c==9 | q43c==-1 | q43c==.

* v12: Trust your elected local government council
/*
	Not at all	0
	Just a little	1
	Somewhat	2
	A lot	3
	Refused	8
	Don’t know/Haven	9
*/
gen conf_govern = (q43d==2 | q43d==3) // somewhat, a lot
replace conf_govern=. if q43d==8 | q43d==9 | q43d==-1 | q43d==.

* v13: Government bans organizations vs. join any
	/*
	Missing	-1
	Agree very stron	1
	Agree with 1	2
	Agree with 2	3
	Agree very stron	4
	Agree with neith	5
	Refused	8
	Don't know	9
*/
gen free_join = (q15==3 | q15==4) // agree with 2, strongly agree with 2
replace free_join = . if q15==-1 | q15==8 | q15==9 | q15==.

* v14: most people can be trusted [NO DATA]
gen trust_people = -1

* v15: dislike homosexual neighbors
/*
	-1	Missing
	1	Strongly dislike
	2	Somewhat dislike
	3	Would not care
	4	Somewhat like
	5	Strongly like
	8	Refused
	9	Don’t know
*/
gen dislike_hom = (q87c==1 | q87c==2) // dislike homosexual neighbors
replace dislike_hom = . if q87c==8 | q87c==9 | q87c==-1 | q87c==.

* v16: Felt unsafe in neighbourhood
/*
	Never	0
	Just once or twi	1
	Several times	2
	Many times	3
	Always	4
	Refused	8
	Don't know	9
*/
gen feel_unsafe = (q10a>=1 & q10a<=4) // just once or twice, several times, many times, always
replace feel_unsafe = . if q10a==8 | q10a==9 | q10a==-1 | q10a==.

* v17: Feared crime in your own home
/*
	Never	0
	Just once or twi	1
	Several times	2
	Many times	3
	Always	4
	Refused	8
	Don't know	9
*/
gen feared_crime = (q10b>=1 & q10b<=4) // just once or twice, several times, many times, always
replace feared_crime = . if q10b==8 | q10b==9 | q10b==-1 | q10b==.

* extra 1: People who experienced discrimination based on disability
/*
-1	Missing
0	Never
1	Once or twice
2	Several times
3	Many times
7	Not applicable	(no	disability)
8	Refused
9	Don't know
*/
gen ex_disability1 = (q86d>=1 & q86d<=3)
replace ex_disability1 = . if q86d==-1 | q86d==8 | q86d==9 | q86d==.

* ---------------- *
* Rename variables *
* ---------------- *

rename own_bank_account si_ownban
rename remittances re_rem
rename free_speak sc_frespe
rename vote_nat sc_vot
rename attended_demons sc_attdem
rename internet_use si_intuse
rename enough_food re_enofoo
rename voluntary_assoc sc_volass
rename conf_police sc_conpol
rename conf_justice sc_conjus
rename conf_elections sc_conele
rename conf_govern sc_congov
rename free_join sc_frejoi
rename trust_people sc_trupeo
rename dislike_hom sc_homnei
rename feel_unsafe sc_insnei
rename feared_crime sc_unshom

* ------------------------------------------------------- *
* Generating interactions between subgroups and variables *
* ------------------------------------------------------- *
	
* macros for lists
global vars "si_ownban re_rem sc_frespe sc_vot sc_attdem si_intuse re_enofoo sc_volass sc_conpol sc_conjus sc_conele sc_congov sc_frejoi sc_trupeo sc_homnei sc_insnei sc_unshom"
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
gen t1 = dofc(dateintr)
format t1 %td
gen t2 = year(t1)
bys country: egen t3 = max(t2)
gen period = t3
tostring period, replace
drop t1 t2 t3

* data source
gen source = "Afrobarometer 7"

* ----------------- *
* Collapse the data *
* ----------------- *

collapse (mean) si_ownban* re_rem* sc_frespe* sc_vot* sc_attdem* si_intuse* re_enofoo* sc_volass* sc_conpol* sc_conjus* sc_conele* sc_congov* sc_frejoi* sc_trupeo* sc_homnei* sc_insnei* sc_unshom* ex_disability1 [aw=withinwt], by(countryname period source)

* --------- *
* Labelling *
* --------- *

* variables
local t_si_ownban = "Share of population that owns a bank account"
local t_re_rem = "Share of population that receives remittances"
local t_sc_frespe = "Share of population that agrees they are free to express what they think"
local t_sc_vot = "Share of population that voted in the last national elections"
local t_sc_attdem = "Share of population that has ever attended a demonstration or protest march"
local t_si_intuse = "Share of population that uses the Internet"
local t_re_enofoo = "Share of population that has gone without enough food to eat in the past year"
local t_sc_volass = "Share of population that participates in voluntary associations , organizations or community groups"
local t_sc_conpol = "Share of population that says they have confidence in the Police"
local t_sc_conjus = "Share of population that says they have confidence in the Justice System"
local t_sc_conele = "Share of population that says they have confidence in the elections"
local t_sc_congov = "Share of population that says they have confidence in the Government"
local t_sc_frejoi = "Share of population that agrees they are free to join any organization they like without fear"
local t_sc_trupeo = "Share of population that says that most people can be trusted"
local t_sc_homnei = "Share of population that would not like to have homosexuals as neighbors"
local t_sc_insnei = "Share of population that feels insecure living in their neighborhood / town / village"
local t_sc_unshom = "Share of population that has often or sometimes felt unsafe from crime in their own homes in the past year"
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
label var ex_disability1 "Percentage of people who experienced discrimination based on disability"

* recoding missing values
foreach vars in si_ownban* re_rem* sc_frespe* sc_vot* sc_attdem* si_intuse* re_enofoo* sc_volass* sc_conpol* sc_conjus* sc_conele* sc_congov* sc_frejoi* sc_trupeo* sc_homnei* sc_insnei* sc_unshom*{
	recode `vars' (-1=.)
}

* Attaching country codes
replace countryname = "Cape Verde" if countryname=="Cabo Verde"
replace countryname = "Cote D Ivoire" if countryname=="Côte d'Ivoire"
replace countryname = "Sao Tome and Principe" if countryname=="São Tomé and Príncipe"
replace countryname = "Eswatini" if countryname=="eSwatini"
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

save "$proc_data\afrobarometer7.dta", replace

erase "countries_codes.dta"

