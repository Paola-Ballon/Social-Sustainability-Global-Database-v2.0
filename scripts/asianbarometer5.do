* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* last update: July 7th, 2023
* original data source: https://www.asianbarometer.org/data?page=d10

/*
Issues:
	- No information on ethnic groups for India [subgroup]
	- No data on disability [subgroup]
	- In Vietnam, most people decline to answer which religion they profess [variable]
	- No information on attending a demonstration or protest for Australia and Vietnam [variable]
	- Use of internet has a very rigid definition, it could be redefined [variable]
	- No information on resolve local problems for Australia [variable]
	- No sampling weight information for Indonesia
*/

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\asianbarometer5"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

* -------------------- *
* Data standardization *
* -------------------- *

cd "$raw_data"

use "ABS Wave 5 Philippines_Core_merged_20201223_release.dta", clear
save "phi_asianbarometer5.dta", replace
use "ABS_V_Mongolia_merged_core_20201217_release.dta", clear
save "mon_asianbarometer5.dta", replace
use "W5_Australia_merged_core_20210803_release.dta", clear
save "aus_asianbarometer5.dta", replace
use "W5_India_merged_core_20220905_released.dta", clear
save "indi_asianbarometer5.dta", replace
use "W5_Indonesia_merged_core_20220905_released.dta", clear
save "indo_asianbarometer5.dta", replace
use "W5_Japan_merged_core_20220905_released.dta", clear
save "jap_asianbarometer5.dta", replace
use "W5_Korea_merged_core_20210823_released.dta", clear
save "kor_asianbarometer5.dta", replace
use "W5_Malaysia_coreQmerged_20210819_release.dta", clear
save "mal_asianbarometer5.dta", replace
use "W5_Myanmar_CoreQ_20220905_released.dta", clear
save "mya_asianbarometer5.dta", replace
use "W5_Taiwan_coreQrelease_20190805.dta", clear
save "tai_asianbarometer5.dta", replace
use "W5_Thailand_merged_core_20210805_release.dta", clear
save "tha_asianbarometer5.dta", replace
use "W5_Vietnam_merged_core_20201215_release.dta", clear
save "vie_asianbarometer5.dta", replace

* ------------------- *
* loop over countries *
* ------------------- *

global countries "phi mon aus indi indo jap kor mal mya tai tha vie"

foreach x in $countries{
    
	* use database
	qui: use "`x'_asianbarometer5.dta", clear

	capture: qui: tab Country, rc
	if _rc==111{
		rename country Country
	}
	di "country `x'"
	d Country
}

foreach x in $countries{
    
	* use database
	qui: use "`x'_asianbarometer5.dta", clear

	* -------------------- *
	* Generating subgroups *
	* -------------------- *
	
	* s1: sex
	capture: tab Se2, rc // for some countries, variable names are written differently
	if _rc==111{
		rename SE2 Se2
	}
	recode Se2 (-1=.) (3=.)
	recode Se2 (2=0)
	rename Se2 sex
	label define sex 1 "Male" 0 "Female"
	label values sex sex
	
	* s2: age
	capture: tab Se3_1, rc // for some countries, variable names are written differently
	if _rc==111{
		capture: rename SE3_1 Se3_1, rc
		if _rc==111{
			rename SE3A Se3_1
		}
	}
	recode Se3_1 (-1=.) (999=.)
	rename Se3_1 age
	
	* s3: ethnic group
	capture: tab Se11a, rc // for some countries, variable names are written differently
	if _rc==111{
		capture: rename SE11a Se11a, rc
		if _rc==111{
			capture: rename SE11A Se11a, rc
			if _rc==111{
				rename Se11_1 Se11a
			}
		}
	}
	* recoding of missing values needs to be performed at the country level
	recode Se11a (-1=.)
	if "`x'"=="phi"{
		recode Se11a (98=.)
	}
	if "`x'"=="kor"{
		recode Se11a (9=.)
	}
	if "`x'"=="tai"{
		recode Se11a (8/9=.)
	}
	rename Se11a ethnic_group
	
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
	capture: tab Se6, rc // for some countries, variable names are written differently
	if _rc==111{
		rename SE6 Se6
	}
	* recoding needs to be done at the country level due to country-specific answers in the religion variable
	if "`x'"=="phi"{
		recode Se6 (40=995) // muslim
		recode Se6 (10/20=996) (72=996) // christian
		recode Se6 (70=997) (73/75=997) // other
		recode Se6 (99=.)
		recode Se6 (995=5) (996=6) (997=7)
	}
	if "`x'"=="mon"{
		recode Se6 (90=991) // no religion
		recode Se6 (60=992) // buddhist
		recode Se6 (40=995) // muslim
		recode Se6 (10/20=996) // christian
		recode Se6 (80=997) // other
		recode Se6 (991=1) (992=2) (995=5) (996=6) (997=7)
	}
	if "`x'"=="aus"{
		recode Se6 (7200/9990=91) // no religion
		recode Se6 (60=92) // buddhist
		recode Se6 (50=93) // hindu
		recode Se6 (5011=94) // jewish
		recode Se6 (40=95) // muslim
		recode Se6 (10/26=96) (81/2904=96) // christian
		recode Se6 (70/76=97) (6011/6999=97) // other
		recode Se6 (-1=.) (9999=.)
		recode Se6 (91=1) (92=2) (93=3) (94=4) (95=5) (96=6) (97=7)
	}
	if "`x'"=="indi"{
		recode Se6 (9990=91) // no religion
		recode Se6 (60=92) // buddhist
		recode Se6 (50=93) // hindu
		recode Se6 (40=95) // muslim
		recode Se6 (2000=96) // christian
		recode Se6 (66/80=97) // other
		recode Se6 (91=1) (92=2) (93=3) (95=5) (96=6) (97=7)
	}
	if "`x'"=="indo"{
		recode Se6 (5=92) // buddhist
		recode Se6 (4=93) // hindu
		recode Se6 (1=95) // muslim
		recode Se6 (2/3=96) // christian
		recode Se6 (6/7=97) // other
		recode Se6 (92=2) (93=3) (95=5) (96=6) (97=7)
	}
	if "`x'"=="jap"{
		recode Se6 (9990=91) // no religion
		recode Se6 (60=92) // buddhist
		recode Se6 (30=94) // jewish
		recode Se6 (40=95) // muslim
		recode Se6 (10/20=96) // christian
		recode Se6 (75/80=97) // other
		recode Se6 (-1=.)
		recode Se6 (91=1) (92=2) (94=4) (95=5) (96=6) (97=7)
	}
	if "`x'"=="kor"{
		recode Se6 (9990=91) // no religion
		recode Se6 (60=92) // buddhist
		recode Se6 (10/20=96) // christian
		recode Se6 (80=97) // other
		recode Se6 (91=1) (92=2) (96=6) (97=7)
	}
	if "`x'"=="mal"{
		recode Se6 (60=92) // buddhist
		recode Se6 (50=93) // hindu
		recode Se6 (40/41=95) // muslim
		recode Se6 (10/20=96) // christian
		recode Se6 (70/77=97) // other
		recode Se6 (0=.) (99=.)
		recode Se6 (92=2) (93=3) (95=5) (96=6) (97=7)
	}
	if "`x'"=="mya"{
		recode Se6 (60=92) // buddhist
		recode Se6 (50=93) // hindu
		recode Se6 (40/42=95) // muslim
		recode Se6 (10/20=96) // christian
		recode Se6 (80=97) // other
		recode Se6 (92=2) (93=3) (95=5) (96=6) (97=7)
	}
	if "`x'"=="tai"{
		recode Se6 (90=991) // no religion
		recode Se6 (60/61=992) // buddhist
		recode Se6 (30=994) // jewish
		recode Se6 (14/79=996) // christian
		recode Se6 (1=997) (76/80=997) // other
		recode Se6 (98/99=.)
		recode Se6 (991=1) (992=2) (994=4) (996=6) (997=7)
	}
	if "`x'"=="tha"{
		recode Se6 (60=92) // buddhist
		recode Se6 (40/42=95) // muslim
		recode Se6 (10/20=96) // christian
		recode Se6 (99=.)
		recode Se6 (92=2) (95=5) (96=6)
	}
	if "`x'"=="vie"{
		recode Se6 (60=92) // buddhist
		recode Se6 (40=95) // muslim
		recode Se6 (10/20=96) // christian
		recode Se6 (201/202=97) // other
		recode Se6 (9999=.)
		recode Se6 (92=2) (95=5) (96=6) (97=7)
	}
	rename Se6 religion
	label define religion 1 "No religion" 2 "Buddhist" 3 "Hindu" 4 "Jewish" 5 "Muslim" 6 "Christian" 7 "Other"
	label values religion religion
	
	* s5: region
	rename Region region
	qui: describe region
	
	* s6: domain/urban // 3 countries have semi-urban or peri-urban categories
	gen urban = .
	replace urban = 1 if Level==2
	replace urban = 0 if Level==1
	
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
	gen disability = .
	
	* s10: major religion
	levelsof religion, local(v_religion)
	egen xt = count(religion)
	foreach t of local v_religion{
		egen x`t' = count(religion) if religion==`t'
		gen sx`t' = x`t'/xt if religion==`t' // computing shares by religion
	}
	egen tot = rowtotal(sx*), m
	egen y = max(tot)
	gen rel_major = (tot==y) // identifying the highest share with major religion
	replace rel_major = . if tot==. | y==.
	drop x* sx* tot y
	* Count of major religions
	levelsof religion if rel_major==1, local(list_mode_rel)
	gen rel_major_count = `:word count `list_mode_rel''
	
	* s11: major ethnic group
	if ("`x'"=="indi"){ // recall that Sudan and Tunisia have not asked information on ethnic groups
		gen ethnic_major = .
		gen eth_major_count = .
	}
	if ("`x'"!="indi"){
		levelsof ethnic_group, local(v_ethnic)
		egen xt = count(ethnic_group)
		foreach t of local v_ethnic{
			egen x`t' = count(ethnic_group) if ethnic_group==`t'
			gen sx`t' = x`t'/xt if ethnic_group==`t' // computing shares by race
		}
		egen tot = rowtotal(sx*), m
		egen y = max(tot)
		gen ethnic_major = (tot==y) // identifying the highest share with major ethnic group
		replace ethnic_major = . if tot==. | y==.
		drop x* sx* tot y
		* Count of major ethnic group
		levelsof ethnic_group if ethnic_major==1, local(list_mode_eth)
		gen eth_major_count = `:word count `list_mode_eth''
	}
	
	* -------------------- *
	* Generating variables *
	* -------------------- *
	
	* v1: People are free to speak what they think without fear
	/*
		Strongly agree	1
		Somewhat agree	2
		Somewhat disagre	3
		Strongly disagre	4
		Don't understand	7
		Can't choose	8
		Decline to answe	9
	*/
	capture: tab Q108, rc // for australia this question is named differently
	if _rc==111{
		capture: rename V_108 Q108, rc
		if _rc==111{
			rename q108 Q108
		}
	}
	capture: tab Q115, rc // the rest of countries uses this question
	if _rc==111{
		capture: rename V_115 Q115, rc
		if _rc==111{
			rename q115 Q115
		}
	}
	if "`x'"=="aus"{
		gen free_speak = (Q108>=1 & Q108<=2) // strongly agree, somewhat agree
		replace free_speak=. if Q108==7 | Q108==8 | Q108==9 | Q108==-1
	}
	if "`x'"!="aus"{
		gen free_speak = (Q115>=1 & Q115<=2) // strongly agree, somewhat agree
		replace free_speak = . if Q115==7 | Q115==8 | Q115==9 | Q115==-1
	}
	
	* v2: People can join any organization they like without fear
	/*
		Strongly agree	1
		Somewhat agree	2
		Somewhat disagre	3
		Strongly disagre	4
		Don't understand	7
		Can't choose	8
		Decline to answe	9
	*/
	capture: tab Q109, rc // for australia this question is named differently
	if _rc==111{
		capture: rename V_109 Q109, rc
		if _rc==111{
			rename q109 Q109
		}
	}
	capture: tab Q116, rc // the rest of countries uses this question
	if _rc==111{
		capture: rename V_116 Q116, rc
		if _rc==111{
			rename q116 Q116
		}
	}
	if "`x'"=="aus"{
		gen free_join = (Q109==1 | Q109==2) // strongly agree, somewhat agree
		replace free_join = . if Q109==7 | Q109==8 | Q109==9 | Q109==-1
	}
	if "`x'"!="aus"{
		gen free_join = (Q116==1 | Q116==2) // strongly agree, somewhat agree
		replace free_join = . if Q116==7 | Q116==8 | Q116==9 | Q116==-1
	}
	
	* v3: Did you vote in the last national election?
	/*
		-1	missing
		0	Not applicable
		1	Yes
		2	No
		3	Not yet eligible to vote
		7	Do not understand the question
		8	Can't choose
		9	Decline to answer
	*/
	capture: tab Q33, rc
	if _rc==111{
		capture: rename V_33 Q33, rc
		if _rc==111{
			rename q33 Q33
		}
	}
	gen vote_nat = (Q33==1) // yes
	replace vote_nat = . if Q33==0 | Q33==7 | Q33==8 | Q33==9 | Q33==-1
	
	* v4: Attended a demonstration or protest march
	/*
		-1	Missing
		0	Not applicable
		1	I have done this more than three times
		2	I have done this two or three times
		3	I have done this once
		4	I have not done this, but I might do it	if	something important happens	in	the	future
		5	I have not done this and I would not do	it	regardless of the situation
		7	Do not understand the question
		8	Can't choose
		9	Decline to answer
	*/
	capture: tab Q79, rc // not valid for Australia
	if _rc==111{
		capture: rename V_79 Q79, rc
		if _rc==111{
			rename q79 Q79
		}
	}
	if "`x'"=="aus"{
		gen attended_demons = .
	}
	if "`x'"!="aus"{
		gen attended_demons = (Q79==1 | Q79==2 | Q79==3) // at least one time
		replace attended_demons = .  if Q79==0 | Q79==7 | Q79==8 | Q79==9 | Q79==-1 
	}
	
	* v5: How often do you use the internet, either through computer, tablet or smartphone
	/*
		-1	Missing
		1	Connected all the time
		2	Several hours a day
		3	Half to one hour a day
		4	Less than half hour a day
		5	At least once a week
		6	At least once a month
		7	A few times a year
		8	Hardly ever
		9	Never
		97	Do not understand the question
		98	Can't choose
		99	Decline to answer
	*/
	capture: tab Q49, rc
	if _rc==111{
		capture: rename V_49 Q49, rc
		if _rc==111{
			rename q49 Q49
		}
	}
	gen internet_use = (Q49>=1 & Q49<=8) // every option but "never"
	replace internet_use = . if Q49==97 | Q49==98 | Q49==-1 | Q49==99

	* v6: Trust in the police
	/*
		-1	Missing
		1	Trust fully
		2	Trust a lot
		3	Trust somewhat
		4	Distrust somewhat
		5	Distrust a lot
		6	Distrust fully
		97	Do not understand	the	question
		98	Can't choose
		99	Decline to answer
	*/
	capture: tab Q14, rc
	if _rc==111{
		capture: rename V_14 Q14, rc
		if _rc==111{
			rename q14 Q14
		}
	}
	gen conf_police = (Q14>=1 & Q14<=3) // trust fully, trust a lot, trust somewhat
	replace conf_police = . if Q14==97 | Q14==98 | Q14==99 | Q14==-1

	* v7: Trust in the local government
	/*
		-1	Missing
		1	Trust fully
		2	Trust a lot
		3	Trust somewhat
		4	Distrust somewhat
		5	Distrust a lot
		6	Distrust fully
		97	Do not understand	the	question
		98	Can't choose
		99	Decline to answer
	*/
	capture: tab Q15, rc
	if _rc==111{
		capture: rename V_15 Q15, rc
		if _rc==111{
			rename q15 Q15
		}
	}
	gen conf_govern = (Q15>=1 & Q15<=3) // trust fully, trust a lot, trust somewhat
	replace conf_govern = . if Q15==97 | Q15==98 | Q15==99 | Q15==-1

	* v8: Trust in the election commission
	/*
		-1	Missing
		1	Trust fully
		2	Trust a lot
		3	Trust somewhat
		4	Distrust somewhat
		5	Distrust a lot
		6	Distrust fully
		97	Do not understand	the	question
		98	Can't choose
		99	Decline to answer
	*/
	capture: tab Q16, rc
	if _rc==111{
		capture: rename V_16 Q16, rc
		if _rc==111{
			rename q16 Q16
		}
	}
	capture: tab Q18, rc
	if _rc==111{
		capture: rename V_18A Q18, rc
		if _rc==111{
			rename q18 Q18
		}
	}
	if "`x'"=="aus"{
		gen conf_elections = (Q18>=1 & Q18<=3)
		replace conf_elections = . if Q18==97 | Q18==98 | Q18==99 | Q18==-1
	}
	if "`x'"!="aus"{
		gen conf_elections = (Q16>=1 & Q16<=3)
		replace conf_elections = . if Q16==97 | Q16==98 | Q16==99 | Q16==-1
	}
	
	* v9: Confidence in the courts
	/*
		-1	Missing
		1	Trust fully
		2	Trust a lot
		3	Trust somewhat
		4	Distrust somewhat
		5	Distrust a lot
		6	Distrust fully
		97	Do not understand	the	question
		98	Can't choose
		99	Decline to answer
	*/
	capture: tab Q8, rc
	if _rc==111{
		capture: rename V_8 Q8, rc
		if _rc==111{
			rename q8 Q8
		}
	}
	gen conf_justice = (Q8>=1 & Q8<=3)
	replace conf_justice = . if Q8==97 | Q8==98 | Q8==99 | Q8==-1

	* v10: Would you say that "Most people can be trusted" or "that you must be very car
	/*
		-1	Missing
		1	Most people can be trusted
		2	You must be very careful in dealing	with	people
		7	Do not understand the question
		8	Can't choose
		9	Decline to answer
	*/
	capture: tab Q22, rc
	if _rc==111{
		capture: rename V_22 Q22, rc
		if _rc==111{
			rename q22 Q22
		}
	}
	capture: tab Q23, rc
	if _rc==111{
		capture: rename V_23 Q23, rc
		if _rc==111{
			rename q23 Q23
		}
	}
	if "`x'"=="aus"{
		gen trustinpeople = (Q23==1)
		replace trustinpeople = . if Q23==7 | Q23==8 | Q23==9 | Q23==-1
	}
	if "`x'"!="aus"{
		gen trustinpeople = (Q22==1)
		replace trustinpeople = . if Q22==7 | Q22==8 | Q22==9 | Q22==-1
	}
	
	* v11: Does the total income of your household allow you to satisactorily cover your needs
	/*
		-1	Missing
		0	Not applicable
		1	Our income covers the needs well, we can save a lot
		2	Our income covers the needs well, we can save
		3	Our income covers the needs all right, without much difficulties
		4	Our income does not cover the needs, there are difficulties
		5	Our income does not cover the needs, there are great difficulties
		7	Do not understand the question
		8	Can't choose
		9	Decline to answer
	*/
	capture: tab Se14a, rc
	if _rc==111{
		capture: rename SE14a Se14a, rc
		if _rc==111{
			rename SE14A Se14a
		}
	}
	gen save_money = (Se14a==1 | Se14a==2)
	replace save_money =. if Se14a==7 | Se14a==8 | Se14a==9 | Se14a==-1 | Se14a==0

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
	capture: tab Q43, rc
	if _rc==111{
		capture: rename V_43 Q43, rc
		if _rc==111{
			rename q43 Q43
		}
	}
	capture: tab Q45, rc
	if _rc==111{
		capture: rename V_45 Q45, rc
		if _rc==111{
			rename q45 Q45
		}
	}
	if "`x'"=="aus"{
		gen insecure_neigh = (Q43>=3 & Q43<=4)
		replace insecure_neigh = . if Q43==7 | Q43==8 | Q43==9 | Q43==-1
	}
	if "`x'"!="aus"{
		gen insecure_neigh = (Q45>=3 & Q45<=4)
		replace insecure_neigh = . if Q45==7 | Q45==8 | Q45==9 | Q45==-1
	}

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
		12	Parent-Teacher associations or PTA
		13	Producer cooperatives
		14	Consumer cooperatives
		15	Alumni associations
		16	Candidate support organizations
		17	Other occupational organizations
		18	Other volunteer organizations
		19	Student Associations
		20	Hometwon/clan/peer-group/mutual assistance	associations
		90	Not a member of any organization or group
		97	Do not understand the question
		98	Can't choose
		99	Decline to answer
	*/
	capture: tab Q18, rc
	if _rc==111{
		capture: rename V_18A Q18, rc
		if _rc==111{
			rename q18 Q18
		}
	}
	capture: tab Q20, rc
	if _rc==111{
		capture: rename V_20A Q20, rc
		if _rc==111{
			rename q20 Q20
		}
	}
	if "`x'"=="aus"{
		gen active_mem = (Q20!=90)
		replace active_mem = . if Q20==-1 | Q20==0 | Q20==97 | Q20==98 | Q20==99
	}
	if "`x'"!="aus"{
		gen active_mem = (Q18!=90)
		replace active_mem = . if Q18==-1 | Q18==0 | Q18==97 | Q18==98 | Q18==99
	}

	* v14: Got together with others face-to-face to try to resolve local problems
	/*
		-1	Missing
		0	Not applicable
		1	I have done this more than three times
		2	I have done this two or three times
		3	I have done this once
		4	I have not done this, but I might do it	if	something important happens	in	the	future
		5	I have not done this and I would not do	it	regardless of the situation
		7	Do not understand the question
		8	Can't choose
		9	Decline to answer
	*/
	capture: tab Q78, rc
	if _rc==111{
		capture: rename V_78 Q78, rc
		if _rc==111{
			rename q78 Q78
		}
	}
	if "`x'"=="aus"{
		gen solve_problems = .
	}
	if "`x'"!="aus"{
		gen solve_problems = (Q78>=1 & Q78<=3) // at least one time
		replace solve_problems = . if Q78==7 | Q78==8 | Q78==9 | Q78==-1 | Q78==0
	}
	
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
		if ("`x'"!="indi"){
			if "`z'"!="disability"{
				levelsof `z', local(val_`z')
				foreach y in $vars{
					foreach t of local val_`z'{
						gen `y'_`z'`t' = `y' if `z'==`t'
					}
				}
			}
			if "`z'"=="disability"{ // recall that we have no data on disability
				foreach y in $vars{
					gen `y'_`z'0 = -1
					gen `y'_`z'1 = -1
				}
			}
		}
		if ("`x'"=="indi"){
			if ("`z'"!="disability" & "`z'"!="ethnic_major"){
				levelsof `z', local(val_`z')
				foreach y in $vars{
					foreach t of local val_`z'{
						gen `y'_`z'`t' = `y' if `z'==`t'
					}
				}
			}
			if ("`z'"=="disability" | "`z'"=="ethnic_major"){ // recall that we have no data on disability
				foreach y in $vars{
					gen `y'_`z'0 = -1
					gen `y'_`z'1 = -1
				}
			}
		}
	}
	
	* fixes
	foreach y in $vars{
		capture: quietly: tab `y'_ethnic_major0, rc
		if _rc==111{
			gen `y'_ethnic_major0 = -1
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

	* string countrycode
	capture: tab Country, rc
	if _rc==111{
		rename country Country
	}
	if ("`x'"!="tai"){
		decode Country, g(countryname)
	}
	if ("`x'"=="tai"){
		rename Country countryname
		replace countryname = "Taiwan"
	}
	
	* add survey year
	levelsof Year, local(periods)
	egen xt = count(Year)
	foreach t of local periods{
		egen x`t' = count(Year) if Year==`t'
		gen sx`t' = x`t'/xt if Year==`t' // computing shares by periods (2 at most)
	}
	egen tot = rowtotal(sx*), m
	egen y = max(tot)
	gen t1 = Year if y==tot
	egen period = max(t1)
	tostring period, replace
	drop x* sx* tot y t1
	
	* data source
	gen source = "Asianbarometer 5"
	
	* fixing sampling weight name
	if ("`x'"=="indo" | "`x'"=="mya" | "`x'"=="tai"){
		gen w = 1
	}
	
	* ----------------- *
	* Collapse the data *
	* ----------------- *
	
	collapse (mean) sc_frespe* sc_frejoi* sc_vot* sc_attdem* si_intuse* sc_conpol* sc_congov* sc_conele* sc_conjus* sc_trupeo* re_savmon* sc_insnei* sc_actmem* sc_solpro* rel_major_count eth_major_count [aw=w], by(countryname period source)
	
	* recoding missing values
	foreach vars in sc_frespe* sc_frejoi* sc_vot* sc_attdem* si_intuse* sc_conpol* sc_congov* sc_conele* sc_conjus* sc_trupeo* re_savmon* sc_insnei* sc_actmem* sc_solpro*{
		recode `vars' (-1=.)
	}
	
	* ------ *
	* Saving *
	* ------ *
	
	save "$proc_data\\`x'.dta", replace
}

* --------------- *
* Merging process *
* --------------- *

cd "$proc_data"

use "phi.dta", clear
* macro list for remaining countries
global countries2 "mon aus indi indo jap kor mal mya tai tha vie"
foreach x in $countries2{
    append using "`x'.dta"
}

* Attaching country codes
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

order countryname countrycode period source

save "asianbarometer5.dta", replace

* delete individual databases
foreach x in $countries{
    erase "`x'.dta"
}

erase "countries_codes.dta"
