* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* last update: March 26th, 2024
* original data source: https://www.arabbarometer.org/survey-data/data-downloads/

/*
Issues:
	- Respondents have 18+ years
	- No data on ethnic group for Mauritania [subgroup]
	- No data on religion for Mauritania [subgroup]
	- No data on urban/rural for Kuwait [subgroup]
	- No data on disability [subgroup]
	- No data on attendance to a demonstration for Kuwait [variable]
	- No data on voluntary association [variable]
	- No data on trust in the government for Algeria, Egypt and Kuwait [variable]
	- No data on trust in the courts for Egypt and Kuwait [variable]
	- No data on trust in the police for all countries except Morocco (but excluding population living in camp) [variable]
	- No data on freedom to join an organization [variable]
*/

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\arabbarometer7"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

* -------------------- *
* Data standardization *
* -------------------- *

cd "$raw_data"

use "AB7_ENG_Release_Version6.dta", clear

label define Q1 120001 "Adrar" 120002 "Assaba" 120003 "Brakna" 120004 "Dajlet Nuadibú" 120005 "Gorgol" 120006 "Guidimaka" 120007 "Hodh el Charqui" 120008 "Hodh el Gharbi" 120009 "Inchiri" 120010 "Nouakchott-Nord" 120011 "Nouakchott-Ouest" 120012 "Nouakchott-Sud" 120013 "Tagant" 120014 "Tiris Zemmour" 120015 "Trarza", modify
label define Q1 80011 "Amman" 80012 "Al Balqa" 80013 "Azurqa" 80014 "Madaba" 80021 "Irbid" 80022 "Al Mafraq" 80023 "Jerash" 80024 "Ajioun" 80031 "Karak" 80032 "Tafila" 80033 "Ma'an" 80034 "Aqaba", modify

* ------------------------------------ *
* Administrative divisions corrections *
* ------------------------------------ *

rename Q1 region
decode region, g(t1)
drop region
rename t1 region

* ancillary country variable
clonevar country = COUNTRY

* Algeria (1)
replace region = "Ain-Temouchent" if country==1 & region=="Ain Temouchent"
replace region = "Alger" if country==1 & region=="Algiers"
replace region = "Bordj Bou Arrer" if country==1 & region=="Bba"
replace region = "El-Tarf" if country==1 & region=="El Tarf"
replace region = "Oum El Bouaghi" if country==1 & region=="Oeb"
replace region = "Souk-Ahras" if country==1 & region=="Souk Ahras"
replace region = subinstr(region, " ", "_", .) if country==1
set obs 26500
local i = 0
foreach x in Adrar Ain-Defla Bechar El_Bayadh Ghardaia Illizi Naama Tamanrasset Tindouf{
	local i = `i' + 1
	local j = 26154 + `i'
	replace country = 1 if _n==`j'
	replace region = "`x'" if country==1 & _n==`j'
}
replace region = subinstr(region, "_", " ", .) if country==1
drop if country==. & region==""

* Egypt (5)
replace region = "Ismailia" if country==5 & region=="Ismalilia"
replace region = "Kafr El-Shikh" if country==5 & region=="Kafr El Sheik"
replace region = "Kalyoubia" if country==5 & region=="Kaliobeya"
replace region = "Menia" if country==5 & region=="Minya"
replace region = "Suhag" if country==5 & region=="Sohag"
replace region = "Ismailia" if country==5 & region=="The Lake"
replace region = subinstr(region, " ", "_", .) if country==5
* Western Eastern expansion
local Western "North_Sinai Shrkia South_Sinai"
local Eastern "Behera Gharbia New_Valley"
global elements "Western Eastern"
foreach z in $elements{
	local count_`z' = `: word count ``z'''
	local i = 0
	foreach x of local `z'{
		local i = `i' + 1
		if (`i'!=`count_`z''){
			expand 2 if country==5 & region=="`z'", g(t1)
			replace region = "`x'" if country==5 & region=="`z'" & t1==1
			drop t1
		}
		else{
			replace region = "`x'" if country==5 & region=="`z'"
		}
	}
}
replace region = subinstr(region, "_", " ", .) if country==5
set obs 26683
replace country = 5 if _n==26682
replace region = "Matrouh" if country==5 & _n==26682
replace country = 5 if _n==26683
replace region = "Red Sea" if country==5 & _n==26683
drop if country==. & region==""

* Iraq (7)
replace region = "Babil" if country==7 & region=="Babylon"
replace region = "Basrah" if country==7 & region=="Basra"
replace region = "Thi-Qar" if country==7 & region=="Dhi Qar"
replace region = "Dahuk" if country==7 & region=="Dohuk"
replace region = "Kerbala" if country==7 & region=="Karbala"
replace region = "Missan" if country==7 & region=="Maysan"
replace region = "Muthanna" if country==7 & region=="Muthana"
replace region = "Ninewa" if country==7 & region=="Nineveh"
replace region = "Qadissiya" if country==7 & region=="Qadisiyah"
replace region = "Salah al-Din" if country==7 & region=="Salahaddin"
replace region = "Wassit" if country==7 & region=="Wasit"

* Jordan (8)
replace region = "Ajloon" if country==8 & region=="Ajioun"
replace region = "Balqa" if country==8 & region=="Al Balqa"
replace region = "Mafraq" if country==8 & region=="Al Mafraq"
replace region = "Zarqa" if country==8 & region=="Azurqa"
replace region = "Jarash" if country==8 & region=="Jerash"
replace region = "Tafiela" if country==8 & region=="Tafila"

* Kuwait (9)
replace region = "Al Ahmadi" if country==9 & region=="Ahmadi"
replace region = "Al Kuwayt" if country==9 & region=="Al Asimah"
replace region = "Al Farwaniyah" if country==9 & region=="Farwaniya"
replace region = "Al Jahrah" if country==9 & region=="Jahra"
replace region = "Hawalli" if country==9 & region=="Mubarak Al-Kabeer"

* Lebanon (10)
replace region = strproper(region) if country==10
replace region = "Nabatiye" if country==10 & region=="El Nabatiyeh"
replace region = "North" if country==10 & region=="Akkar"
replace region = "Bekaa" if country==10 & region=="Baalbek-El Hermel"

* Libya (11)
drop if country==11 & region=="Ghat"
replace region = "Al Jufrah" if country==11 & region=="Aljufra"
replace region = "Al Kufrah" if country==11 & region=="Alkufra"
replace region = "Az Zawia (azzawiya)" if country==11 & region=="Azzawya"
replace region = "Banghazi" if country==11 & region=="Benghazi"
replace region = "Darnah" if country==11 & region=="Derna"
replace region = "Ajdabiya (agedabia)" if country==11 & region=="Ejdabia"
replace region = "Sabha" if country==11 & region=="Sebha"
replace region = "Tubruq (tobruk)" if country==11 & region=="Tobruk"
replace region = "Tripoli (tarabulus)" if country==11 & region=="Tripoli"
replace region = "Awbari (ubari)" if country==11 & region=="Ubari"
replace region = "Ash Shati" if country==11 & region=="Wadi Ashshati"
replace region = "Nuqat Al Khams" if country==11 & region=="Zwara"
replace region = "Misurata" if country==11 & region=="Misrata"
replace region = "Surt (sirte)" if country==11 & region=="Sirt"
replace region = subinstr(region, " ", "_", .) if country==11
replace region = "Al_Aziziyah" if country==11 & region=="Aljfara"
replace region = "Al_Fatah" if country==11 & region=="Almarj"
replace region = "Ghadamis" if country==11 & region=="Nalut"
expand 2 if country==11 & region=="Misurata", g(t1)
replace region = "Zeleitin_(zliten)" if country==11 & region=="Misurata" & t1==1
drop t1
expand 2 if country==11 & region=="Surt_(sirte)", g(t1)
replace region = "Sawfajjin_(sofuljeen)" if country==11 & region=="Surt_(sirte)" & t1==1
drop t1
* Almargeb Al_Jabal_Al_Gharbi expansion
local Almargeb "Al_Khoms Tarhunah"
local Al_Jabal_Al_Gharbi "Gharyan Yafran_(yefren)"
global elements "Almargeb Al_Jabal_Al_Gharbi"
foreach z in $elements{
	local count_`z' = `: word count ``z'''
	local i = 0
	foreach x of local `z'{
		local i = `i' + 1
		if (`i'!=`count_`z''){
			expand 2 if country==11 & region=="`z'", g(t1)
			replace region = "`x'" if country==11 & region=="`z'" & t1==1
			drop t1
		}
		else{
			replace region = "`x'" if country==11 & region=="`z'"
		}
	}
}
replace region = subinstr(region, "_", " ", .) if country==11

* Mauritania (12)
replace region = "Dakhlet-Nouadhibou" if country==12 & region=="Dajlet Nuadibú"
replace region = "Guidimakha" if country==12 & region=="Guidimaka"
replace region = "Hodh Ech Chargi" if country==12 & region=="Hodh el Charqui"
replace region = "Hodh El Gharbi" if country==12 & region=="Hodh el Gharbi"
replace region = "Nouakchott" if country==12 & region=="Nouakchott-Nord"
replace region = "Nouakchott" if country==12 & region=="Nouakchott-Ouest"
replace region = "Nouakchott" if country==12 & region=="Nouakchott-Sud"
replace region = "Tiris-Zemmour" if country==12 & region=="Tiris Zemmour"

* Morocco (13)
* OBSERVATION: Looks like the ADM1 divisions used by the WBG is deprecated. Nowadays, there are 12 regions in Morocco instead of 15.
drop if country==13

* Palestine (15)
replace region = "Al Khalil (Hebron)" if country==15 & region=="Hebron"
replace region = "Jabalya" if country==15 & region=="Jabalia"
replace region = "Ariha (Jericho)" if country==15 & region=="Jerico"
replace region = "Al Quds (Jerusalem)" if country==15 & region=="Jerusalem"
replace region = "Nablus" if country==15 & region=="Nabulus"
replace region = "Qalqiliya" if country==15 & region=="Qalqilya"
replace region = "Tulkarm" if country==15 & region=="Tulkarem"

* Sudan (19)
replace region = "Gadaref" if country==19 & region=="Al Gedarif"
replace region = "Al Jazeera" if country==19 & region=="Al Gezira"
replace region = "Southern Darfur" if country==19 & region=="Central Darfu"
replace region = "Southern Darfur" if country==19 & region=="East Darfur"
replace region = "Northern Darfur" if country==19 & region=="North Darfur"
replace region = "Northern Kordofan" if country==19 & region=="North Kordofan"
replace region = "Nile" if country==19 & region=="River Nile"
replace region = "Sennar" if country==19 & region=="Sinnar"
replace region = "Southern Darfur" if country==19 & region=="South Darfur"
replace region = "Southern Kordofan" if country==19 & region=="South Kordofan"
replace region = "Western Darfur" if country==19 & region=="West Darfur"
replace region = "Southern Kordofan" if country==19 & region=="West Kordofan"

* Tunisia (21)
replace region = "Le Kef" if country==21 & region=="Kef"
replace region = "Sidi Bouz" if country==21 & region=="Sidi Bouzid"
replace region = "Tataouine" if country==21 & region=="Tatouine"

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
	1	Once
	2	More than once
	3	Never participated
	98	Don’t know
	99	Refused to answer
*/
gen attended_demons = (Q532A>=1 & Q532A<=2)
replace attended_demons = . if Q532A==98 | Q532A==99 | Q532A==.

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

* v4: Have you volunteered for any local group / organization regardless of your status of membership? [NO DATA]
gen voluntary_assoc = -1

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
gen t1 = (Q201A_42A_MOR>=1 & Q201A_42A_MOR<=2)
replace t1 = . if Q201A_42A_MOR==98 | Q201A_42A_MOR==99 | Q201A_42A_MOR==.
gen t2 = (Q201A_42B_MOR>=1 & Q201A_42B_MOR<=2)
replace t2 = . if Q201A_42B_MOR==98 | Q201A_42B_MOR==99 | Q201A_42B_MOR==.
egen conf_police = rowtotal(t1 t2), m
drop t1 t2

* v8: Freedom to join civil associations and organizations
gen free_join = -1

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
gen ex_disability2 = .

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

* ------------------ *
* Supplementary data *
* ------------------ *

drop COUNTRY
rename country COUNTRY
* string countryname
decode COUNTRY, g(countryname)

* add survey year
gen t1 = substr(DATE,1,4)
destring t1, replace 
bys COUNTRY: egen t2 = max(t1)
gen period = t2
tostring period, replace
drop t1 t2

* data source
gen source = "Arab barometer 7"

* ----------------- *
* Collapse the data *
* ----------------- *

recode WT (.=1)

collapse (mean) sc_frespe* sc_attdem* si_intuse* sc_volass* sc_congov* sc_conjus* sc_conpol* sc_frejoi* si_menbet* re_savmon* ex_disability2 [aw=WT], by(countryname region period source)

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

* macros for lists
global vars "sc_frespe sc_attdem si_intuse sc_volass sc_congov sc_conjus sc_conpol sc_frejoi si_menbet re_savmon"

* labels
foreach x in $vars{
	label var `x' "`t_`x''"
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
merge m:1 countryname using "countries_codes.dta"
keep if _merge==3
drop _merge

order countryname countrycode region period source
rename region adm1_name

* ------ * 
* Saving *
* ------ *

save "$proc_data\arabbarometer7_subnational.dta", replace

erase "countries_codes.dta"