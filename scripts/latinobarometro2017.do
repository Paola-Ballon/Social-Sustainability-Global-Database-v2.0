* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* last update: July 7th, 2023
* original data source: https://www.latinobarometro.org/latContents.jsp

/*
Issues:
	- Respondents have 16+ years
	- We assume race is a proxy for ethnicity [subgroup]
	- Urban/rural definition is based on the population size. If this magnitude is equal to or higher than 50000 people, then the region is treated as urban, otherwise is treated as rural. In practice, this population threshold differs between countries. Also, the population size is a categorical (ordinal) variable, so we cannot apply every cutoff we want [subgroup]
	- No information on disability [subgroup]
	- No information on freedom of speech [variable]
*/

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\latinobarometro2017"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

cd "$raw_data"

use "Latinobarometro2017Esp_v20180117.dta", clear

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
recode S10 (-2=.) (-1=.)
rename S10 ethnic_group

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
recode S9 (13/14=991) (97=991) // no religion
recode S9 (9=994) // jewish
recode S9 (1/8=996) (10=996) (12=996) // christian
recode S9 (11=997) (96=997) // other
recode S9 (-2=.) (-1=.)
rename S9 religion
label define religion 1 "No religion" 2 "Buddhist" 3 "Hindu" 4 "Jewish" 5 "Muslim" 6 "Christian" 7 "Other"
label values religion religion

* s5: region
recode reg (-5=.)
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
	-4	No	preguntada
	-3	No	aplicable
	-2	No	responde
	-1	No	sabe
	1	Si
	2	No
*/
gen chief_earner_women = (S12==1) if sex==0
replace chief_earner_women = . if S12==-4 | S12==-3 | S12==-2 | S12==-1 | S12==.

* v2: beneficiary of a state aid program
/*
	-1	No	sabe/No	responde
	1	Si
	2	No
*/
gen govern_transfers = (S2==1)
replace govern_transfers = . if S2==-1 | S2==.

* v3: income allows to save
/*
	-2	No responde
	-1	No sabe
	1	Les alcanza bien, pueden ahorrar
	2	Les alcanza justo, sin grandes dificultades
	3	No les alcanza, tienen dificultades
	4	No les alcanza, tienen grandes dificultades
*/
gen save_money = (S5==1)
replace save_money = . if S5==-2 | S5==-1 | S5==.

* v4: not had enough food
/*
	-2	No responde
	-1	No sabe
	1	Nunca
	2	Rara vez
	3	Algunas veces
	4	Seguido
*/
gen enough_food = (S3>=2 & S3<=4)
replace enough_food = . if S3==-2 | S3==-1 | S3==.

* v5: Most people can be trusted
/*
	-4	No preguntada
	-3	No aplicable
	-1	No sabe, no responde
	1	Se puede confiar en la mayoría de las personas
	2	Uno nunca es los suficientemente cuidadoso en el	trato	con	l
*/
gen trustinpeople = (P13STGBS==1)
replace trustinpeople = . if P13STGBS==-4 | P13STGBS==-3 | P13STGBS==-1 | P13STGBS==.

* v6: Has confidence in the government
/*
	-4	No preguntada
	-3	No aplicable
	-2	No responde
	-1	No sabe
	1	Mucha
	2	Algo
	3	Poca
	4	Ninguna
*/
gen conf_govern = (P14ST_E>=1 & P14ST_E<=2) // too much confidence, some confidence
replace conf_govern = . if P14ST_E==-4 | P14ST_E==-3 | P14ST_E==-2 | P14ST_E==-1 | P14ST_E==.

* v7: Has confidence in the police
/*
	-4	No preguntada
	-3	No aplicable
	-2	No responde
	-1	No sabe
	1	Mucha
	2	Algo
	3	Poca
	4	Ninguna
*/
gen conf_police = (P14STGBS_B>=1 & P14STGBS_B<=2) // too much confidence, some confidence
replace conf_police = . if P14STGBS_B==-4 | P14STGBS_B==-3 | P14STGBS_B==-2 | P14STGBS_B==-1 | P14STGBS_B==.

* v8: Has confidence in the electoral institution
/*
	-4	No preguntada
	-3	No aplicable
	-2	No responde
	-1	No sabe
	1	Mucha
	2	Algo
	3	Poca
	4	Ninguna
*/
gen conf_elections = (P14ST_H>=1 & P14ST_H<=2) // too much confidence, some confidence
replace conf_elections = . if P14ST_H==-4 | P14ST_H==-3 | P14ST_H==-2 | P14ST_H==-1 | P14ST_H==.

* v9: Has confidence in the judiciary
/*
	-4	No preguntada
	-3	No aplicable
	-2	No responde
	-1	No sabe
	1	Mucha
	2	Algo
	3	Poca
	4	Ninguna
*/
gen conf_justice = (P14ST_F>=1 & P14ST_F<=2) // too much confidence, some confidence
replace conf_justice = . if P14ST_F==-4 | P14ST_F==-3 | P14ST_F==-2 | P14ST_F==-1 | P14ST_F==.

* v10: How often do you care that you may become the victim of a crime with violence (feels concerned at least occasionally)
/*
	-1	No sabe/No responde
	1	Todo o casi todo el	tiempo
	2	Algunas veces
	3	Ocasionalmente
	4	Nunca
*/
gen insecure_neigh = (P66ST>=1 & P66ST<=3) // everytime, sometimes, occasionally
replace insecure_neigh = . if P66ST==-1 | P66ST==.

* v11: Share of population that was victim of a crime in neighborhood 
/*
	-2	No responde
	-1	No sabe
	1	Usted
	2	Pariente
	3	Ambos
	4	No
*/
gen victim_crime = (P65ST_B==1 | P65ST_B==3)
replace victim_crime = . if P65ST_B==-2 | P65ST_B==-1 | P65ST_B==.

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
gen source = "Latinobarometro 2017"

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
replace countryname = "Brazil" if countryname=="Brasil"
replace countryname = "Mexico" if countryname=="México"
replace countryname = "Panama" if countryname=="Panamá"
replace countryname = "Peru" if countryname=="Perú"
replace countryname = "Dominican Republic" if countryname=="Rep. Dominicana"
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

save "$proc_data\latinobarometro2017.dta", replace

erase "countries_codes.dta"
