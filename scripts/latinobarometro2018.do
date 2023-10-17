* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* last update: July 7th, 2023
* original data source: https://www.latinobarometro.org/latContents.jsp

/*
Issues:
	- data can be downloaded in .dta extension, but this comes at the cost of dealing with variables named in a problematic way (e.g. education = p2.56). Stata cannot deal with such variables easily, therefore to run this code we must work with .sav extension
	- Urban/rural definition is based on the population size. If this magnitude is equal to or higher than 50000 people, then the region is treated as urban, otherwise is treated as rural. In practice, this population threshold differs between countries. Also, the population size is a categorical (ordinal) variable, so we cannot apply every cutoff we want [subgroup]
		* It is very likely that Chile has entry data errors in the tamciud (city size) variable, this makes impossible to appropiately define a urban/rural variable for this country.
	- No data on disability [subgroup] [SOLVED]
	- Respondents have 16+ years
	- No information on freedom of speech [variable]
	- Coding errors: [SOLVED]
		* Wrong coding in victim of a crime variable (excludes relatives/both)
	- There must be a clear definition for race/religion categories, but keep in mind that:
		* a high number of categories may result in a small sample size for the major ethnic/religion group and a large sample size for the minor ethnic/religion group (since minor ethnic groups and minor religion contains every other race or religion outside the major category)
		* a low number of categories may result in too few observations within the minor ethnic/religion group for some countries (as a extreme example, considered a country where everyone belongs to the major religion group)
*/

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\latinobarometro2018"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

cd "$raw_data"

import spss "Latinobarometro_2018_Esp_Spss_v20190303.sav", case(lower) clear

* -------------------- *
* Generating subgroups *
* -------------------- *

* s1: sex
recode sexo (2=0)
rename sexo sex
label define sex 1 "Male" 0 "Female"
label values sex sex

* s2: age
rename edad age

* s3: ethnicity
rename s6 ethnic_group

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
recode s5 (13/14=991) (97=991) // no religion
recode s5 (9=994) // jewish
recode s5 (1/8=996) (10=996) (12=996) // christian
recode s5 (11=997) (96=997) // other
recode s5 (991=1) (994=4) (996=6) (997=7)
rename s5 religion
label define religion 1 "No religion" 2 "Buddhist" 3 "Hindu" 4 "Jewish" 5 "Muslim" 6 "Christian" 7 "Other"
label values religion religion

* s5: region
rename reg region

* s6: domain/urban [REQUIRES DISCUSSION]
gen urban = (tamciud>=6 & tamciud<=8)

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
bys idenpa: egen xt = count(religion)
foreach t of local v_religion{
	bys idenpa: egen x`t' = count(religion) if religion==`t'
	bys idenpa: gen sx`t' = x`t'/xt if religion==`t' // computing shares by religion
}
egen tot = rowtotal(sx*), m
bys idenpa: egen y = max(tot)
gen rel_major = (tot==y) // identifying the highest share with major religion
replace rel_major = . if tot==. | y==.
drop x* sx* tot y
* Count of major religions
gen rel_major_count = .
levelsof idenpa, local(countries)
foreach x of local countries{
    levelsof religion if rel_major==1 & idenpa==`x', local(list_mode_rel)
	replace rel_major_count = `:word count `list_mode_rel'' if idenpa==`x'
}

* s11: major ethnic group
levelsof ethnic_group, local(v_ethnic_group)
bys idenpa: egen xt = count(ethnic_group)
foreach t of local v_ethnic_group{
	bys idenpa: egen x`t' = count(ethnic_group) if ethnic_group==`t'
	bys idenpa: gen sx`t' = x`t'/xt if ethnic_group==`t' // computing shares by race
}
egen tot = rowtotal(sx*), m
bys idenpa: egen y = max(tot)
gen ethnic_major = (tot==y) // identifying the highest share with major ethnic group
replace ethnic_major = . if tot==. | y==.
drop x* sx* tot y
* Count of major ethnic group
gen eth_major_count = .
levelsof idenpa, local(countries)
foreach x of local countries{
    levelsof ethnic_group if ethnic_major==1 & idenpa==`x', local(list_mode_eth)
	replace eth_major_count = `:word count `list_mode_eth'' if idenpa==`x'
}

* -------------------- *
* Generating variables *
* -------------------- *

* v1: share of women that are chief earner
/*
	Si	1
	No	2
*/
gen chief_earner_women = (s8==1) if sex==0

* v2: beneficiary of a state aid program
/*
	No	sabe/No	respo	0
	Si	1
	No	2
*/
gen govern_transfers = (s25==1)
replace govern_transfers = . if s25==0

* v3: income allows to save
/*
	Les alcanza bien	1
	Les alcanza just	2
	No les alcanza,	3
	No les alcanza,	4
*/
gen save_money = (s4==1)
replace save_money = . if s4==.

* v4: not had enough food
/*
	Nunca	1
	Rara vez	2
	Algunas veces	3
	Seguido	4
*/
gen enough_food = (s2>=2 & s2<=4)
replace enough_food = . if s2==.

* v5: Most people can be trusted
/*
	Se puede confiar	1
	Uno nunca es lo	2
*/
gen trustinpeople = (p11stgbs==1)
replace trustinpeople = . if p11stgbs==.

* v6: Has confidence in the government
/*
	Mucha	1
	Algo	2
	Poca	3
	Ninguna	4
*/
gen conf_govern = (_v10>=1 & _v10<=2) // too much confidence, some confidence
replace conf_govern = . if _v10==.

* v7: Has confidence in the police
/*
	Mucha	1
	Algo	2
	Poca	3
	Ninguna	4
*/
gen conf_police = (_v7>=1 & _v7<=2) // too much confidence, some confidence
replace conf_police = . if _v7==.

* v8: Has confidence in the electoral institution
/*
	Mucha	1
	Algo	2
	Poca	3
	Ninguna	4
*/
gen conf_elections = (_v13>=1 & _v13<=2) // too much confidence, some confidence
replace conf_elections = . if _v13==.

* v9: Has confidence in the judiciary
/*
	Mucha	1
	Algo	2
	Poca	3
	Ninguna	4
*/
gen conf_justice = (_v11>=1 & _v11<=2) // too much confidence, some confidence
replace conf_justice = . if _v11==.

* v10: How often do you care that you may become the victim of a crime with violence (feels concerned at least occasionally)
/*
Todo o casi todo	1
Algunas veces	2
Ocasionalmente	3
Nunca	4
*/
gen insecure_neigh = (p70st>=1 & p70st<=3) // everytime, sometimes, occasionally
replace insecure_neigh = . if p70st==.

* v11: Share of population that was victim of a crime in neighborhood 
/*
	Ud.	1
	Algún	pariente	2
	Ambos	3
	No	4
*/
gen victim_crime = (_v255==1 | _v255==3)
replace victim_crime = . if _v255==.

* v12: freedom of speech
/*
	No contesta	-2
	Completamente ga	1
	Algo garantizada	2
	Poco garantizada	3
	Para nada garant	4
*/
gen free_speak = -1

* ---------------- *
* Rename variables *
* ---------------- *

rename chief_earner_women si_chiear
rename govern_transfers re_govtra
rename save_money re_savmon
rename enough_food re_enofoo
rename trustinpeople sc_trupeo
rename conf_govern sc_congov
rename conf_police sc_conpol
rename conf_elections sc_conele
rename conf_justice sc_conjus
rename insecure_neigh sc_insnei
rename victim_crime sc_viccri
rename free_speak sc_frespe

* ------------------------------------------------------- *
* Generating interactions between subgroups and variables *
* ------------------------------------------------------- *
	
* macros for lists
global vars "si_chiear re_govtra re_savmon re_enofoo sc_trupeo sc_congov sc_conpol sc_conele sc_conjus sc_insnei sc_viccri sc_frespe"
global subgroups "sex urban youth disability rel_major ethnic_major"
foreach z in $subgroups{
	if "`z'"!="disability"{ // recall that we have no data on disability
		levelsof `z', local(val_`z')
		foreach y in $vars{
			foreach t of local val_`z'{
				gen `y'_`z'`t' = `y' if `z'==`t'
			}
		}
	}
	if "`z'"=="disability"{
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
decode idenpa, g(countryname)

* add survey year
bys idenpa: egen period = max(numinves)
tostring period, replace

* data source
gen source = "Latinobarometro 2018"

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

collapse (mean) si_chiear* re_govtra* re_savmon* re_enofoo* sc_trupeo* sc_congov* sc_conpol* sc_conele* sc_conjus* sc_insnei* sc_viccri* sc_frespe* rel_major_count eth_major_count [aw=wt], by(countryname period source)

* --------- *
* Labelling *
* --------- *

* variables
local t_si_chiear = "Share of women that are the chief earner in their households"
local t_re_govtra = "Share of population that receive government transfers (that is, individual is beneficiary of a state aid program)"
local t_re_savmon = "Share of population that saves some money"
local t_re_enofoo = "Share of population that has gone without enough food to eat in the past year"
local t_sc_trupeo = "Share of population that says that most people can be trusted"
local t_sc_congov = "Share of population that says they have confidence in the Government"
local t_sc_conpol = "Share of population that says they have confidence in the Police"
local t_sc_conele = "Share of population that says they have confidence in the elections"
local t_sc_conjus = "Share of population that says they have confidence in the Justice System"
local t_sc_insnei = "Share of population that feels insecure living in their neighborhood / town / village"
local t_sc_viccri = "Share of population that was victim of a crime in the past year"
local t_sc_frespe = "Share of population that agrees they are free to express what they think"
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
foreach vars in si_chiear* re_govtra* re_savmon* re_enofoo* sc_trupeo* sc_congov* sc_conpol* sc_conele* sc_conjus* sc_insnei* sc_viccri* sc_frespe*{
	recode `vars' (-1=.)
}

* Attaching country codes
replace countryname = subinstr(countryname, " ", "", .)
replace countryname = "Costa Rica" if countryname=="CostaRica"
replace countryname = "El Salvador" if countryname=="ElSalvador"
replace countryname = "Brazil" if countryname=="Brasil"
replace countryname = "Mexico" if countryname=="México"
replace countryname = "Panama" if countryname=="Panamá"
replace countryname = "Peru" if countryname=="Perú"
replace countryname = "Dominican Republic" if countryname=="Rep.Dominicana"
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

save "$proc_data\latinobarometro2018.dta", replace

erase "countries_codes.dta"
