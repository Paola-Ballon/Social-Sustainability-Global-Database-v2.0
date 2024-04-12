* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* last update: March 26th, 2024
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

* ------------------------------------ *
* Administrative divisions corrections *
* ------------------------------------ *

rename q1 region
decode region, g(t1)
drop region
rename t1 region

* Algeria (1)
replace region = subinstr(region, " ", "_", .) if country==1
replace region = "Oum_El_Bouaghi" if country==1 & region=="O.E._Bouaghi"
replace region = "Biskra" if country==1 & region=="Biskara"
replace region = "Tizi_Ouzou" if country==1 & region=="Tiz-Ouzou"
replace region = "Alger" if country==1 & region=="Algiers"
replace region = "Saida" if country==1 & region=="Saïda"
replace region = "Sidi_Bel_Abbes" if country==1 & region=="Sidi_B._Abbes"
replace region = "M'Sila" if country==1 & region=="Messilia"
replace region = "Bordj_Bou_Arrer" if country==1 & region=="B.B._Arreridj"
replace region = "Boumerdes" if country==1 & region=="Boumderdes"
replace region = "El-Tarf" if country==1 & region=="Al_Traf"
replace region = "Souk-Ahras" if country==1 & region=="Souk_Ahras"
replace region = "Ain-Temouchent" if country==1 & region=="Timouchent"
set obs 27000
local i = 0
foreach x in Adrar Ain-Defla Bechar El_Bayadh El_Oued Ghardaia Illizi Laghouat Naama Ouargla Tamanrasset Tindouf{
	local i = `i' + 1
	local j = 26780 + `i'
	replace country = 1 if _n==`j'
	replace region = "`x'" if country==1 & _n==`j'
}
drop if country==. & region==""
replace region = subinstr(region, "_", " ", .) if country==1

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

* Iraq (7)
replace region = "Babil" if country==7 & region=="Babylon"
replace region = "Basrah" if country==7 & region=="Basra"
replace region = "Thi-Qar" if country==7 & region=="Dhi War"
replace region = "Kerbala" if country==7 & region=="Karbala"
replace region = "Missan" if country==7 & region=="Maysan"
replace region = "Ninewa" if country==7 & region=="Nineveh"
replace region = "Qadissiya" if country==7 & region=="Qadisiyah"
replace region = "Salah al-Din" if country==7 & region=="Salahaddin"
replace region = "Sulaymaniyah" if country==7 & region=="Sulaymaniya"
replace region = "Wassit" if country==7 & region=="Wasit"
set obs 27402
replace country = 7 if _n==27401
replace region = "Muthanna" if country==7 & _n==27401
replace country = 7 if _n==27402
replace region = "Dahuk" if country==7 & _n==27402

* Jordan (8)
replace region = "Ajloon" if country==8 & region=="Ajioun"
replace region = "Balqa" if country==8 & region=="Al Balqa"
replace region = "Mafraq" if country==8 & region=="Al Mafraq"
replace region = "Zarqa" if country==8 & region=="Azurqa"
replace region = "Jarash" if country==8 & region=="Jerash"
replace region = "Tafiela" if country==8 & region=="Tafila"

* Kuwait (9)
replace region = "Al Ahmadi" if country==9 & region=="Ahmadi"
replace region = "Al Kuwayt" if country==9 & region=="Al Asimah (Capital)"
replace region = "Al Farwaniyah" if country==9 & region=="Farwaniya"
replace region = "Al Jahrah" if country==9 & region=="Jahra"
replace region = "Hawalli" if country==9 & region=="Mubarak Al-Kabeer"

* Lebanon (10)
replace region = "Mount Lebanon" if country==10 & region=="Mt Lebanon"
replace region = "Nabatiye" if country==10 & region=="Nabatieh"
replace region = "North" if country==10 & region=="Akkar"
replace region = "Bekaa" if country==10 & region=="Baalbek"

* Libya (11)
* We'll drop observations from the Ghat district since it does not match with any of the ADM1 units in the WBG dataset (10 obs)
drop if country==11 & region=="Ghat"
replace region = "Al Kufrah" if country==11 & region=="Al Kufra"
replace region = "Az Zawia (azzawiya)" if country==11 & region=="Al Zawia"
replace region = "Banghazi" if country==11 & region=="Benghazi"
replace region = "Darnah" if country==11 & region=="Derna"
replace region = "Misurata" if country==11 & region=="Misrata"
replace region = "Sabha" if country==11 & region=="Sebha"
replace region = "Surt (sirte)" if country==11 & region=="Sirt"
replace region = "Tubruq (tobruk)" if country==11 & region=="Tobruq"
replace region = "Tripoli (tarabulus)" if country==11 & region=="Tripoli"
replace region = "Awbari (ubari)" if country==11 & region=="Ubari"
replace region = "Ash Shati" if country==11 & region=="Wadi Alshati"
replace region = subinstr(region, " ", "_", .) if country==11
* Al_Jabal_AL_Gharbi Al_Murqub expansion
local Al_Jabal_AL_Gharbi "Yafran_(yefren) Gharyan"
local Al_Murqub "Tarhunah Al_Khoms"
global elements "Al_Jabal_AL_Gharbi Al_Murqub"
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
expand 2 if country==11 & region=="Misurata", g(t1)
replace region = "Zeleitin_(zliten)" if country==11 & region=="Misurata" & t1==1
drop t1
expand 2 if country==11 & region=="Surt_(sirte)", g(t1)
replace region = "Sawfajjin_(sofuljeen)" if country==11 & region=="Surt_(sirte)" & t1==1
drop t1
replace region = "Ghadamis" if country==11 & region=="Nalut"
replace region = "Al_Fatah" if country==11 & region=="Almarj"
replace region = "Al_Aziziyah" if country==11 & region=="Jafara"
replace region = "Ajdabiya_(agedabia)" if country==11 & region=="Al_Wahat"
replace region = subinstr(region, "_", " ", .) if country==11
set obs 27983
replace country = 11 if _n==27983
replace region = "Al Jufrah" if country==11 & _n==27983

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
replace region = "Southern Darfur" if country==19 & region=="Central Darfur"
replace region = "Southern Darfur" if country==19 & region=="East Darfur"
replace region = "Gadaref" if country==19 & region=="Gedaref"
replace region = "Nile" if country==19 & region=="Nile River"
replace region = "Northern" if country==19 & region=="North"
replace region = "Northern Darfur" if country==19 & region=="North Darfur"
replace region = "Northern Kordofan" if country==19 & region=="North Kordofan"
replace region = "Southern Darfur" if country==19 & region=="South Darfur"
replace region = "Southern Kordofan" if country==19 & region=="South Kordofan"
replace region = "Nile" if country==19 & region=="The Island"
replace region = "Western Darfur" if country==19 & region=="West Darfur"
replace region = "Southern Kordofan" if country==19 & region=="West Kordofan"
set obs 27984
replace country = 19 if _n==27984
replace region = "Al Jazeera" if country==19 & _n==27984

* Tunisia (21)
replace region = "Le Kef" if country==21 & region=="Kef"
replace region = "Sidi Bouz" if country==21 & region=="Sidi Bouzid"
replace region = "Tataouine" if country==21 & region=="Tatouine"

* Yemen (22)
replace region = "Aden" if country==22 & region=="'Adan"
replace region = "Al Dhale'e" if country==22 & region=="Ad Dali"
replace region = "Al Maharah" if country==22 & region=="Al Mahrah"
replace region = "Lahj" if country==22 & region=="Lahij"
replace region = "Marib" if country==22 & region=="Ma'rib"
replace region = "Sa'ada" if country==22 & region=="Sa'dah"
replace region = "Taizz" if country==22 & region=="Ta'izz"

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
gen free_join = (Q521_5==1 | Q521_5==2)
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

recode wt (.=1)

collapse (mean) sc_frespe* sc_attdem* si_intuse* sc_volass* sc_congov* sc_conjus* sc_conpol* sc_frejoi* si_menbet* re_savmon* ex_disability2 [aw=wt], by(countryname region period source)

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

save "$proc_data\arabbarometer5_subnational.dta", replace

erase "countries_codes.dta"