* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* last update: July 7th, 2023
* original data source: https://www.worldvaluessurvey.org/WVSContents.jsp

/*
Issues:
	- The following countries do not have information on ethnic groups: [subgroup]
		* Argentina, Georgia, Palestine, South Korea, Kuwait, Qatar, Rwanda, Slovenia, Spain, Turkey, Egypt
	- Respondents have 16+ years
	- No data on disability [subgroup]
	- No data on urban/rural domain [subgroup]
	- Missing data problem with active membership in organization [variable]
		* Not every respondent declared information on active membership for all organizations. Therefore, whenever we cannot conclude if some respondent has any affiliation, we treat him like he does not have one
	- lack of homogeneity in defining some variables:
		* Problem if women have more income than husband (3 categories)
		* Jobs scarce: Men should have more right to a job than women (5 categories)
	- We underestimate the share of the population who voted in the last elections by assuming that only those who always vote are the ones who voted in the past elections
	- Northern Ireland is not considered but data is available for wave 7
*/

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\wvs6_7"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

cd "$raw_data"

use "WVS_TimeSeries_4_0.dta", clear

* ------------- *
* Preliminaries *
* ------------- *

* we retain waves 6
keep if S002VS==6

* rename sampling weight variable
rename S017 weight

* -------------------- *
* Generating subgroups *
* -------------------- *

* s1: sex
recode X001 (-5=.) (-2=.) (-1=.) (2=0)
rename X001 sex
label define sex 1 "Male" 0 "Female"
label values sex sex

* s2: age
recode X003 (-5=.) (-3=.) (-2=.) (-1=.)
rename X003 age

* s3: race
recode X051 (-5=.) (-4=.) (-3=.) (-2=.) (-1=.)
rename X051 ethnic_group

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
recode F025 (-5=.) (-2=.) (-1=.)
recode F025 (0=91) // no religion
recode F025 (7=92) // buddhist
recode F025 (6=93) // hindu
recode F025 (4=94) // jewish
recode F025 (5=95) // muslim
recode F025 (1/3=96) (8=96) // christian
recode F025 (9=97) // other
recode F025 (91=1) (92=2) (93=3) (94=4) (95=5) (96=6) (97=7)
rename F025 religion
label define religion 1 "No religion" 2 "Buddhist" 3 "Hindu" 4 "Jewish" 5 "Muslim" 6 "Christian" 7 "Other"
label values religion religion

* s5: region
rename X048WVS region

* s6: domain/urban
recode X050C (-5=.) (-4=.)
gen urban = (X050C==1)
replace urban = . if X050C==.

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
bys S003: egen xt = count(religion)
foreach t of local v_religion{
	bys S003: egen x`t' = count(religion) if religion==`t'
	bys S003: gen sx`t' = x`t'/xt if religion==`t' // computing shares by religion
}
egen tot = rowtotal(sx*), m
bys S003: egen y = max(tot)
gen rel_major = (tot==y) // identifying the highest share with major religion
replace rel_major = . if tot==. | y==.
drop x* sx* tot y
* Count of major religions
gen rel_major_count = .
levelsof S003, local(countries)
foreach x of local countries{
    levelsof religion if rel_major==1 & S003==`x', local(list_mode_rel)
	replace rel_major_count = `:word count `list_mode_rel'' if S003==`x'
}

* s11: major ethnic group
gen ethnic_major = .
gen eth_major_count = .
levelsof S003, local(countries)
foreach x of local countries{
	if (`x'!=818 & `x'!=792 & `x'!=724 & `x'!=705 & `x'!=646 & `x'!=634 & `x'!=414 & `x'!=410 & `x'!=275 & `x'!=268 & `x'!=32){ // Recall that some countries do not have information on ethnic groups
		levelsof ethnic_group if S003==`x', local(v_ethnic_group)
		egen xt = count(ethnic_group) if S003==`x'
		foreach t of local v_ethnic_group{
			egen x`t' = count(ethnic_group) if ethnic_group==`t' & S003==`x'
			gen sx`t' = x`t'/xt if ethnic_group==`t' & S003==`x' // computing shares by race
		}
		egen tot = rowtotal(sx*) if S003==`x', m
		egen y = max(tot) if S003==`x'
		replace ethnic_major = (tot==y) if S003==`x' // identifying the highest share with major ethnic group
		replace ethnic_major = . if (tot==. | y==.) & S003==`x'
		drop x* sx* tot y
		* Count of major ethnic group
		levelsof ethnic_group if ethnic_major==1 & S003==`x', local(list_mode_eth)
		replace eth_major_count = `:word count `list_mode_eth'' if S003==`x'
	}
}

* -------------------- *
* Generating variables *
* -------------------- *

* v1: Family savings during past year
/*
	Missing; Unknown	-5
	Not applicable	-3
	No answer	-2
	Don't know	-1
	Save money	1
	Just get by	2
	Spent some savin	3
	Spent savings an	4
*/
recode X044 (-5=.) (-3=.) (-2=.) (-1=.)
gen	save_money = (X044==1)
replace save_money = . if X044==.

* v2: Frequency you/family (last 12 month): Gone without enough food to eat
/*
	Missing; Unknown	-5
	No answer	-2
	Don't know	-1
	Often	1
	Sometimes	2
	Rarely	3
	Never	4
*/
recode H008_01 (-5=.) (-2=.) (-1=.)
gen enough_food = (H008_01>=1 & H008_01<=3)
replace enough_food = . if H008_01==.

* v3: Secure in neighborhood
/*
	Missing; Unknown	-5
	No answer	-2
	Don't know	-1
	Very Secure	1
	Quite secure	2
	Not very secure	3
	Not at all secur	4
*/
recode H001 (-5=.) (-2=.) (-1=.) 
gen insecure_neigh = (H001>=3 & H001<=4)
replace insecure_neigh = . if H001==.

* v4: Frequency in your neighborhood: Racist behavior
/*
	Missing; Unknown	-5
	Not asked	-4
	No answer	-2
	Don't know	-1
	Very Frequently	1
	Quite frequently	2
	Not frequently	3
	Not at all frequ	4
*/
recode H002_04 (-5=.) (-4=.) (-2=.) (-1=.)
gen racist_neigh = (H002_04==1 | H002_04==2)
replace racist_neigh = . if H002_04==.

* v5: Active membership in organizations
/*
	Missing; Unknown	-5
	No answer	-2
	Don't know	-1
	Not a member	0
	Inactive member	1
	Active member	2
*/

*local i = 0
foreach x in A098 A099 A100 A101 A102 A103 A104 A105 A106 A106B A106C{
	*local i = `i' + 1
	recode `x' (-5=.) (-4=.) (-2=.) (-1=.)
	*gen temp`i' = (`x'==2)
	*replace temp`i' = . if `x'==.
}
*egen temp_a = rowtotal(temp*), m
*egen temp_b = rowmiss(temp*)
* observation: Not every respondent declared information on active membership for all organizations. Therefore, whenever we cannot conclude if some respondent has any affiliation, we treat him like he does not have one
gen active_mem = (A098==2 | A099==2 | A100==2 | A101==2 | A102==2 | A103==2 | A104==2 | A105==2 | A106==2 | A106B==2 | A106C==2)
replace active_mem = . if (A098==. & A099==. & A100==. & A101==. & A102==. & A103==. & A104==. & A105==. & A106==. & A106B==. & A106C==.)

* v6: Most people can be trusted
/*
	Not asked	-4
	No answer	-2
	Don't know	-1
	Most	people can	1
	Need	to be very	2
*/
recode A165 (-4=.) (-2=.) (-1=.)
gen trustinpeople = (A165==1)
replace trustinpeople = . if A165==.

* v7: Not like neighbours because of: homosexuals
/*
	Missing	-5
	Not asked	-4
	No answer	-2
	Don't know	-1
	Not mentioned	0
	Mentioned	1
*/
recode A124_09 (-5=.) (-4=.) (-2=.) (-1=.)
gen homosexual_neigh = (A124_09==1)
replace homosexual_neigh = . if A124_09==.

* v8: Confidence: The Government
/*
	Missing; Unknown	-5
	Not asked	-4
	No answer	-2
	Don't know	-1
	A great deal	1
	Quite a lot	2
	Not very much	3
	None at all	4
*/
recode E069_11 (-5=.) (-4=.) (-2=.) (-1=.)
gen conf_govern = (E069_11==1 | E069_11==2)
replace conf_govern = . if E069_11==.

* v9: Confidence: The Police
/*
	Missing; Unknown	-5
	Not asked	-4
	No answer	-2
	Don't know	-1
	A great deal	1
	Quite a lot	2
	Not very much	3
	None at all	4
*/
recode E069_06 (-5=.) (-4=.) (-2=.) (-1=.)
gen conf_police = (E069_06==1 | E069_06==2)
replace conf_police = . if E069_06==.

* v10: Confidence: Elections
/*
	Missing; Unknown	-5
	Not asked	-4
	No answer	-2
	Don't know	-1
	A great deal	1
	Quite a lot	2
	Not very much	3
	None at all	4
*/
recode E069_64 (-5=.) (-4=.) (-2=.) (-1=.)
gen conf_elections = (E069_64==1 | E069_64==2)
replace conf_elections = . if E069_64==.

* v11: Confidence: Justice System/Courts
/*
	Missing; Unknown	-5
	Not asked	-4
	No answer	-2
	Don't know	-1
	A great deal	1
	Quite a lot	2
	Not very much	3
	None at all	4
*/
recode E069_17 (-5=.) (-4=.) (-2=.) (-1=.)
gen conf_justice = (E069_17==1 | E069_17==2)
replace conf_justice = . if E069_17==.

* v12: Problem if women have more income than husband (3 categories)
/*
	Missing; Unknown	-5
	Not asked	-4
	No answer	-2
	Don't know	-1
	Agree	1
	Neither	2
	Disagree	3
*/
recode D066_B (-5=.) (-4=.) (-2=.) (-1=.)
gen probl_women = (D066_B==1)
replace probl_women = . if D066_B==.

* v13: Jobs scarce: Men should have more right to a job than women (3 categories)
/*
	Missing; Unknown	-5
	Not asked in sur	-4
	No answer	-2
	Don't know	-1
	Agree	1
	Disagree	2
	Neither	3
*/
recode C001 (-5=.) (-4=.) (-2=.) (-1=.)
gen menrtojob = (C001==1)
replace menrtojob = . if C001==.

* v14: Men make better political leaders than women do
/*
	Missing; Unknown	-5
	Not asked in sur	-4
	No answer	-2
	Don't know	-1
	Agree strongly	1
	Agree	2
	Disagree	3
	Strongly disagre	4
*/
recode D059 (-5=.) (-4=.) (-2=.) (-1=.)
gen menbetter = (D059==1 | D059==2)
replace menbetter = . if D059==.

* v15: Vote in elections: National level
/*
	Missing; Unknown	-5
	Not asked in sur	-4
	Not applicable	-3
	No answer	-2
	Don't know	-1
	Always	1
	Usually	2
	Never	3
	Not allowed to v	4
*/
* observation: We underestimate the share of the population who voted in the last elections by assuming that only those who always vote are the ones who voted in the past elections
recode E264 (-5=.) (-4=.) (-3=.) (-2=.) (-1=.)
gen vote_nat = (E264==1)
replace vote_nat = . if E264==.

* v16: Political action: attending lawful/peaceful demonstrations
/*
	Missing; Unknown	-5
	Not asked in sur	-4
	No answer	-2
	Don't know	-1
	Have done	1
	Might do	2
	Would never do	3
*/
recode E027 (-5=.) (-4=.) (-2=.) (-1=.)
gen attended_demons = (E027==1)
replace attended_demons = . if E027==.

* v17: Frequency you/family (last 12 month): Felt unsafe from crime in your own home
/*
	Missing; Unknown	-5
	Not asked	-4
	No answer	-2
	Don't know	-1
	Often	1
	Sometimes	2
	Rarely	3
	Never	4
*/
recode H008_02 (-5=.) (-4=.) (-2=.) (-1=.)
gen unsafe_home = (H008_02==1 | H008_02==2)
replace unsafe_home = . if H008_02==.

* v18: Respondent was victim of a crime during the past year
/*
	Missing; Unknown	-5
	Not asked in sur	-4
	No answer	-2
	Don't know	-1
	No	0
	Yes	1
*/
recode H004 (-5=.) (-4=.) (-2=.) (-1=.)
gen victim_crime = (H004==1)
replace victim_crime = . if H004==.

* v19: Information source: Internet (B)
/*
	Missing;Unknown	-5
	Not asked	-4
	No answer	-2
	Don't know	-1
	Daily	1
	Weekly	2
	Monthly	3
	Less than monthl	4
	Never	5
*/
recode E262B (-5=.) (-4=.) (-2=.) (-1=.)
gen inf_internet = (E262B>=1 & E262B<=4)
replace inf_internet = . if E262B==.

* ---------------- *
* Rename variables *
* ---------------- *

rename save_money re_savmon
rename enough_food re_enofoo
rename insecure_neigh sc_insnei
rename racist_neigh sc_racbeh
rename active_mem sc_actmem
rename trustinpeople sc_trupeo
rename homosexual_neigh sc_homnei
rename conf_govern sc_congov
rename conf_police sc_conpol
rename conf_elections sc_conele
rename conf_justice sc_conjus
rename probl_women si_prowom
rename menrtojob si_menjob
rename menbetter si_menbet
rename vote_nat sc_vot
rename attended_demons sc_attdem
rename unsafe_home sc_unshom
rename victim_crime sc_viccri
rename inf_internet si_infint

* ------------------------------------------------------- *
* Generating interactions between subgroups and variables *
* ------------------------------------------------------- *
	
* macros for lists
global vars "re_savmon re_enofoo sc_insnei sc_racbeh sc_actmem sc_trupeo sc_homnei sc_congov sc_conpol sc_conele sc_conjus sc_vot sc_attdem sc_unshom sc_viccri si_prowom si_menjob si_menbet si_infint"
global subgroups "sex urban youth disability rel_major ethnic_major"
foreach z in $subgroups{
	if ("`z'"!="disability" & "`z'"!="urban"){
		levelsof `z', local(val_`z')
		foreach y in $vars{
			foreach t of local val_`z'{
				gen `y'_`z'`t' = `y' if `z'==`t'
			}
		}
	}
	if ("`z'"=="disability" | "`z'"=="urban"){ // recall that we have no data on disability
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
decode S003, g(countryname)

* add survey year
gen period = S020
tostring period, replace

* data source
gen source = "WVS 6"

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

collapse (mean) re_savmon* re_enofoo* sc_insnei* sc_racbeh* sc_actmem* sc_trupeo* sc_homnei* sc_congov* sc_conpol* sc_conele* sc_conjus* sc_vot* sc_attdem* sc_unshom* sc_viccri* si_prowom* si_menjob* si_menbet* si_infint* rel_major_count eth_major_count [aw=weight], by(countryname period source)

* --------- *
* Labelling *
* --------- *

* variables
local t_re_savmon = "Share of population that saves some money"
local t_re_enofoo = "Share of population that has gone without enough food to eat in the past year"
local t_sc_insnei = "Share of population that feels insecure living in their neighborhood / town / village"
local t_sc_racbeh = "Share of population that says racist behavior is very or quite frequent in their neighborhood"
local t_sc_actmem = "Share of population that are active members of organizations"
local t_sc_trupeo = "Share of population that says that most people can be trusted"
local t_sc_homnei = "Share of population that would not like to have homosexuals as neighbors"
local t_sc_congov = "Share of population that says they have confidence in the Government"
local t_sc_conpol = "Share of population that says they have confidence in the Police"
local t_sc_conele = "Share of population that says they have confidence in the elections"
local t_sc_conjus = "Share of population that says they have confidence in the Justice System"
local t_sc_vot = "Share of population that voted in the last national elections"
local t_sc_attdem = "Share of population that has ever attended a demonstration or protest march"
local t_sc_unshom = "Share of population that has often or sometimes felt unsafe from crime in their own homes in the past year"
local t_sc_viccri = "Share of population that was victim of a crime in the past year"
local t_si_prowom = "Share of population that agrees it is a problem if women earn more than their husbands"
local t_si_menjob = "Share of population that agrees that when jobs are scarce , men should have more right to a job than women"
local t_si_menbet = "Share of population that agrees or strongly agrees men make better political leaders than women"
local t_si_infint = "Share of population that uses the Internet as a source of information Information source : Internet"
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
foreach vars in re_savmon* re_enofoo* sc_insnei* sc_racbeh* sc_actmem* sc_trupeo* sc_homnei* sc_congov* sc_conpol* sc_conele* sc_conjus* sc_vot* sc_attdem* sc_unshom* sc_viccri* si_prowom* si_menjob* si_menbet* si_infint*{
	recode `vars' (-1=.)
}

* Attaching country codes
replace countryname = "Kyrgyz Republic" if countryname=="Kyrgyzstan"
replace countryname = "United States of America" if countryname=="United States"
preserve
import excel using "${ssgd_v2_userpath}\SSGD v2.0\other\list_countries.xlsx", firstrow sheet("countries_codes") clear
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

save "$proc_data\wvs6.dta", replace

erase "countries_codes.dta"
