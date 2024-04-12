* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* last update: March 26th, 2024
* original data source: https://www.afrobarometer.org/data/data-sets/

/*
Issues:
	- This file only considers partition based on subnational division
*/

clear all
set more off

* directory macros

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\afrobarometer7"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

* -------------------- *
* Data standardization *
* -------------------- *

cd "$raw_data"

import spss using "r7_merged_data_34ctry.release.sav", case(lower) clear

* ------------------------------------ *
* Administrative divisions corrections *
* ------------------------------------ *

decode region, g(t1)
drop region
rename t1 region

* Benin (1)
replace region = "Atakora" if country==1 & region=="Atacora"

* Botswana (2)
replace region = "Central" if country==2 & (region=="Central Bobonong" | region=="Central Boteti/Orapa" | region=="Central Mahalapye" | region=="Central Serowe" | region=="Central Tutume/Sowa Town" | region=="Selibe Phikwe")
replace region = "Kgaladi" if country==2 & (region=="Kgalagadi North" | region=="Kgalagadi South")
replace region = "Kweneng" if country==2 & (region=="Kweneng East" | region=="Kweneng West")
replace region = "Ngamiland" if country==2 & (region=="Ngamiland East" | region=="Ngamiland West")
replace region = "South-East" if country==2 & (region=="Gaborone" | region=="South East" | region=="Lobatse")
replace region = "Southern" if country==2 & (region=="Jwaneng" | region=="Ngwaketse" | region=="Ngwaketse West" | region=="Barolong") 
replace region = "North East" if country==2 & region=="Francistown"

* Burkina Faso (3)
replace region = "Centre-est" if country==3 & region=="Centre Est"
replace region = "Centre-nord" if country==3 & region=="Centre Nord"
replace region = "Centre-ouest" if country==3 & region=="Centre Ouest"
replace region = "Centre-sud" if country==3 & region=="Centre Sud"
replace region = "Hauts-bassins" if country==3 & region=="Hauts Bassins"
replace region = "Sud-ouest" if country==3 & region=="Sud Ouest"

* Cabo Verde (4)
set obs 46100
label define labels0 4 "Cape Verde", modify
local c_1 = "Boa Vista"
local c_2 = "Brava"
local c_3 = "Cima"
local c_4 = "Ilheu Branco"
local c_5 = "Ilheu Raso"
local c_6 = "Maio"
local c_7 = "Rombo"
local c_8 = "Sal"
local c_9 = "Santa Luzia"
local c_10 = "Sao Nicolau"
forvalues t = 1/10{
	local row = 45823 + `t'
	replace country = 4 if _n==`row'
	replace region = "`c_`t''" if country==4 & _n==`row'
}
replace region = "Santiago" if country==4 & (region=="Santiago – Interior" | region=="Santiago – Praia")
replace region = "Santo Antao" if country==4 & region=="Santo Antão"
replace region = "Sao Vicente" if country==4 & region=="São Vicente"
drop if country==. & region==""

* Cameroon (5)
replace region = "Extrême - Nord" if country==5 & region=="Extreme-Nord"
replace region = "Nord - Ouest" if country==5 & region=="Nord Ouest"
replace region = "Sud - Ouest" if country==5 & region=="Sud Ouest"
replace region = "Centre" if country==5 & region=="Mfoundi"
replace region = "Littoral" if country==5 & region=="Wouri"

* Côte d'Ivoire (6)
replace region = "Lagunes" if country==6 & (region=="Agneby-Tiassa" | region=="Grands-Ponts" | region=="La Me")
replace region = "District autonome de Abidjan" if country==6 & (region=="Autonome D'abidjan")
replace region = "District autonome de Yamoussoukro" if country==6 & (region=="Autonome Yamoussoukro")
replace region = "Woroba" if country==6 & (region=="Bafing" |  region=="Bere" | region=="Worodougou")
replace region = "Savanes" if country==6 & (region=="Bagoue" | region=="Poro" | region=="Tchologo" )
replace region = "Lacs" if country==6 & (region=="Belier" | region=="Iffou" | region=="Moronou" | region=="N'zi")
replace region = "Zanzan" if country==6 & (region=="Bounkani" | region=="Gontougo")
replace region = "Montagnes" if country==6 & (region=="Cavally" | region=="Guemon" | region=="Tonkpi")
replace region = "Denguele" if country==6 & (region=="Folon" | region=="Kabadougou")
replace region = "Vallee Du Bandama" if country==6 & (region=="Gbeke" | region=="Hambol")
replace region = "Bas Sassandra" if country==6 & (region=="Gbôkle" | region=="Nawa" | region=="San-Pedro")
replace region = "Gôh-Djiboua" if country==6 & (region=="Gôh" | region=="Lôh-Djiboua")
replace region = "Sassandra-Marahoue" if country==6 & (region=="Haut-Sassandra" | region=="Marahoue")
replace region = "Comoe" if country==6 & (region=="Indenie-Djuablin" | region=="Sud-Comoe")

* eSwatini (7)
label define labels0 7 "Swaziland", modify

* Gabon (8)
replace region = "Haut-Ogooue" if country==8 & region=="Haut-Ogooué"
replace region = "Moyen-Ogooue" if country==8 & region=="Moyen-Ogooué"
replace region = "Ngounie" if country==8 & region=="Ngounié"
replace region = "Ogooue-Ivindo" if country==8 & region=="Ogooué-Ivindo"
replace region = "Ogooue-Maritime" if country==8 & region=="Ogooué-Maritime"
replace region = "Ogooue-lolo" if country==8 & region=="Ogooué_Lolo"

* Gambia (9)
label define labels0 9 "The Gambia", modify
replace region = "Kanifing Municipal Council" if country==9 & (region=="Banjul" | region=="Kanifing")
replace region = "Central River" if country==9 & (region=="Central River - North" | region=="Central River - South")

* Ghana (10)
* No changes required

* Guinea (11)
replace region = "Boke" if country==11 & region=="Boké"
replace region = "Labe" if country==11 & region=="Labé"
replace region = "Nzerekore" if country==11 & region=="N'zérékoré"

* Kenya (12)
* No changes required

* Lesotho (13)
replace region = "Butha Buthe" if country==13 & region=="Botha-Bothe"
replace region = "Thaba Tseka" if country==13 & region=="Thaba-Tseka"

* Liberia (14)
replace region = "Rivercess" if country==14 & region=="River Cess"

* Madagascar (15)
replace region = "Amoron I Mania" if country==15 & region=="Amoron'i Mania"

* Malawi (16)
set obs 45834
replace country = 16 if _n==45834
replace region = "Area under National Administration" if country==16 & _n==45834

* Mali (17)
* No changes required

* Mauritius (18)
replace region = "Plaines Wilhems" if country==18 & region=="Plaine Wilhems"
replace region = "Riviere Du Rempart" if country==18 & region=="Riv Du Rempart"
replace region = "Administrative unit not available" if country==18 & region=="Rodrigues"

* Morocco (19)
* OBSERVATION: Looks like the ADM1 divisions used by the WBG is deprecated. Nowadays, there are 12 regions in Morocco instead of 15.
drop if country==19

* Mozambique (20)
set obs 45835
replace region = "Zambezia" if country==20 & region=="Zambézia"
replace region = "Maputo" if country==20 & (region=="Maputo City" | region=="Maputo Province")
replace country = 20 if _n==45835
replace region = "Lago niassa" if country==20 & _n==45835

* Namibia (21)
replace region = "Kavango" if country==21 & (region=="Kavango East" | region=="Kavango West")
replace region = "Caprivi" if country==21 & region=="Zambezi"

* Niger (22)
* No changes required

* Nigeria (23)
replace region = "Abuja" if country==23 & region=="Fct Abuja"
replace region = "Nassarawa" if country==23 & region=="Nasarawa"

* São Tomé and Príncipe (24)
replace region = "Principe" if country==24 & region=="Príncipe"
replace region = "Sao Tome" if country==24 & region=="São Tomé"

* Senegal (25)
replace region = "Kedougou" if country==25 & region=="Kédougou"
replace region = "Saint louis" if country==25 & region=="Saint-Louis"
replace region = "Sedhiou" if country==25 & region=="Sédhiou"

* Sierra Leone (26)
replace region = "Eastern" if country==26 & region=="Eastern Province"
replace region = "Northern" if country==26 & region=="Northern Province"
replace region = "Southern" if country==26 & region=="Southern Province"

* South Africa (27)
replace region = "KwaZulu-Natal" if country==27 & region=="Kwazulu-Natal"

* Sudan (28)
* Darfur expansion
expand 2 if country==28 & region=="Darfur", g(t1)
replace region = "Northern Darfur" if country==28 & region=="Darfur" & t1==1
drop t1
expand 2 if country==28 & region=="Darfur", g(t1)
replace region = "Southern Darfur" if country==28 & region=="Darfur" & t1==1
replace region = "Western Darfur" if country==28 & region=="Darfur"
drop t1
* Middle east expansion
expand 2 if country==28 & region=="Middle East", g(t1)
replace region = "Al Jazeera" if country==28 & region=="Middle East" & t1==1
drop t1
expand 2 if country==28 & region=="Middle East", g(t1)
replace region = "Blue Nile" if country==28 & region=="Middle East" & t1==1
drop t1
expand 2 if country==28 & region=="Middle East", g(t1)
replace region = "Nile" if country==28 & region=="Middle East" & t1==1
drop t1
expand 2 if country==28 & region=="Middle East", g(t1)
replace region = "Sennar" if country==28 & region=="Middle East" & t1==1
drop t1
replace region = "White Nile" if country==28 & region=="Middle East"
* Kordofan expansion
expand 2 if country==28 & region=="Kordofan", g(t1)
replace region = "Southern Kordofan" if country==28 & region=="Kordofan" & t1==1
drop t1
replace region = "Northern Kordofan" if country==28 & region=="Kordofan"
* East expansion
expand 2 if country==28 & region=="East", g(t1)
replace region = "Red Sea" if country==28 & region=="East" & t1==1
drop t1
expand 2 if country==28 & region=="East", g(t1)
replace region = "Kassala" if country==28 & region=="East" & t1==1
drop t1
replace region = "Gadaref" if country==28 & region=="East"
replace region = "Northern" if country==28 & region=="North"

* Tanzania (29)
replace region = "Dar-es-salaam" if country==29 & region=="Dar Es Salaam"

* Togo (30)
replace region = "Maritime" if country==30 & region=="Lome"

* Tunisia (31)
* Center east expansion
expand 2 if country==31 & region=="Center East", g(t1)
replace region = "Mahdia" if country==31 & region=="Center East" & t1==1
drop t1
expand 2 if country==31 & region=="Center East", g(t1)
replace region = "Monastir" if country==31 & region=="Center East" & t1==1
drop t1
expand 2 if country==31 & region=="Center East", g(t1)
replace region = "Sfax" if country==31 & region=="Center East" & t1==1
drop t1
replace region = "Sousse" if country==31 & region=="Center East"
* Center west expansion
expand 2 if country==31 & region=="Center West", g(t1)
replace region = "Kairouan" if country==31 & region=="Center West" & t1==1
drop t1
expand 2 if country==31 & region=="Center West", g(t1)
replace region = "Kasserine" if country==31 & region=="Center West" & t1==1
drop t1
replace region = "Sidi Bouz" if country==31 & region=="Center West"
* North east expansion
expand 2 if country==31 & region=="North East", g(t1)
replace region = "Ariana" if country==31 & region=="North East" & t1==1
drop t1
expand 2 if country==31 & region=="North East", g(t1)
replace region = "Ben Arous" if country==31 & region=="North East" & t1==1
drop t1
expand 2 if country==31 & region=="North East", g(t1)
replace region = "Bizerte" if country==31 & region=="North East" & t1==1
drop t1
expand 2 if country==31 & region=="North East", g(t1)
replace region = "Manouba" if country==31 & region=="North East" & t1==1
drop t1
expand 2 if country==31 & region=="North East", g(t1)
replace region = "Nabeul" if country==31 & region=="North East" & t1==1
drop t1
expand 2 if country==31 & region=="North East", g(t1)
replace region = "Tunis" if country==31 & region=="North East" & t1==1
drop t1
replace region = "Zaghouan" if country==31 & region=="North East"
* North west expansion
expand 2 if country==31 & region=="North West", g(t1)
replace region = "Beja" if country==31 & region=="North West" & t1==1
drop t1
expand 2 if country==31 & region=="North West", g(t1)
replace region = "Jendouba" if country==31 & region=="North West" & t1==1
drop t1
expand 2 if country==31 & region=="North West", g(t1)
replace region = "Le Kef" if country==31 & region=="North West" & t1==1
drop t1
replace region = "Siliana" if country==31 & region=="North West"
* South east expansion
expand 2 if country==31 & region=="South East", g(t1)
replace region = "Gabes" if country==31 & region=="South East" & t1==1
drop t1
expand 2 if country==31 & region=="South East", g(t1)
replace region = "Medenine" if country==31 & region=="South East" & t1==1
drop t1
replace region = "Tataouine" if country==31 & region=="South East"
* South west expansion
expand 2 if country==31 & region=="South West", g(t1)
replace region = "Gafsa" if country==31 & region=="South West" & t1==1
drop t1
expand 2 if country==31 & region=="South West", g(t1)
replace region = "Kebili" if country==31 & region=="South West" & t1==1
drop t1
replace region = "Tozeur" if country==31 & region=="South West"
replace region = "Tunis" if country==31 & region=="Great Tunis"

* Uganda (32)
local Acholi "Amuru Nwoya Gulu Lamwo Kitgum Agago Pader"
local Busoga "Bugiri Buyende Iganga Jinja Kaliro Kamuli Luuka Mayuge Namayingo Namutumba"
local Karamoja "Kotido Kaabong Abim Moroto Napak Amudat Nakapiripirit"
local Lango "Amolatar Alebtong Apac Dokolo Kole Lira Oyam Otuke"
local Eastern "Amuria Budaka Bududa Bukedea Bukwo Bulambuli Busia Butaleja Kaberamaido Kapchorwa Katakwi Kibuku Kumi Kween Manafwa Mbale Ngora Pallisa Serere Sironko Soroti Tororo"
global elements "Acholi Busoga Karamoja Lango Eastern"
foreach z in $elements{
	local count_`z' = `: word count ``z'''
	local i = 0
	foreach x of local `z'{
		local i = `i' + 1
		if (`i'!=`count_`z''){
			expand 2 if country==32 & region=="`z'", g(t1)
			replace region = "`x'" if country==32 & region=="`z'" & t1==1
			drop t1
		}
		else{
			replace region = "`x'" if country==32 & region=="`z'"
		}
	}
}
set obs 64000
global excluded "Adjumani Hoima Kabale Kalangala Kasese Kibaale Kisoro Moyo Ntungamo Ssembabule Kabarole Kampala Kamwenge Kanungu Kayunga Nakasongola Rukungiri Wakiso Yumbe Ibanda Isingiro Kiruhura Koboko Luwero Mbarara Mityana Mubende Nakaseke Buliisa Maracha Arua Rakai Lyantonde Buikwe Nebbi Zombo Kyegegwa Kyenjojo Bukomansimbi Bundibugyo Bushenyi Butambala Kalungu Sheema Masaka Masindi Buhweju Ntoroko Rubirizi Buvuma Gomba Kiboga Kiryandongo Kyankwanzi Mitooma Mpigi Lwengo Mukono"
local i = 0
foreach x in $excluded{
	local i = `i' + 1
	local j = 63036 + `i' 
	replace country = 32 if _n==`j'
	replace region = "`x'" if country==32 & _n==`j'
}

* Zambia (33)
replace region = "Northern" if country==33 & region=="Muchinga"
replace region = "North-Western" if country==33 & region=="North Western"

* Zimbabwe (34)
* No changes required

* Corrections
drop if country==. & region==""

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

recode withinwt (.=1)

collapse (mean) si_ownban* re_rem* sc_frespe* sc_vot* sc_attdem* si_intuse* re_enofoo* sc_volass* sc_conpol* sc_conjus* sc_conele* sc_congov* sc_frejoi* sc_trupeo* sc_homnei* sc_insnei* sc_unshom* ex_disability1 [aw=withinwt], by(countryname region period source)

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

* macros for lists
global vars "si_ownban re_rem sc_frespe sc_vot sc_attdem si_intuse re_enofoo sc_volass sc_conpol sc_conjus sc_conele sc_congov sc_frejoi sc_trupeo sc_homnei sc_insnei sc_unshom"

* labels
foreach x in $vars{
	label var `x' "`t_`x''"
}
label var ex_disability1 "Percentage of people who experienced discrimination based on disability"

* recoding missing values
foreach vars in si_ownban* re_rem* sc_frespe* sc_vot* sc_attdem* si_intuse* re_enofoo* sc_volass* sc_conpol* sc_conjus* sc_conele* sc_congov* sc_frejoi* sc_trupeo* sc_homnei* sc_insnei* sc_unshom*{
	recode `vars' (-1=.)
}

* Attaching country codes
replace countryname = "Cote D Ivoire" if countryname=="Côte d'Ivoire"
replace countryname = "Sao Tome and Principe" if countryname=="São Tomé and Príncipe"
replace countryname = "Eswatini" if countryname=="Swaziland"
replace countryname = "Gambia" if countryname=="The Gambia"
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

save "$proc_data\afrobarometer7_subnational.dta", replace

erase "countries_codes.dta"
