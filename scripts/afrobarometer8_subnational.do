* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* last update: March 26th, 2024
* original data source: https://www.afrobarometer.org/data/data-sets/

/*
Issues:
	- Respondents have 18+ years
	- No data on disability [subgroup]
	- No data on ethnic group for Tunisia [subgroup]
	- No data on remittances [variable]
	- No data on voluntary association or community group [variable]
	- Some mixed urban/rural categories are omitted (recode) [SOLVED]
	- Coding errors: [SOLVED]
		* gen var = (temp1<=c) creates dummy variables but often this requires dealing with missing values
	- There must be a clear definition for race/religion categories, but keep in mind that: [SOLVED]
		* a high number of categories may result in a small sample size for the major ethnic/religion group and a large sample size for the minor ethnic/religion group (since minor ethnic groups and minor religion contains every other race or religion outside the major category)
		* a low number of categories may result in too few observations within the minor ethnic/religion group for some countries (as a extreme example, considered a country where everyone belongs to the major religion group)
*/

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\afrobarometer8"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

* -------------------- *
* Data standardization *
* -------------------- *

cd "$raw_data"

import spss using "afrobarometer_release-dataset_merge-34ctry_r8_en_2023-03-01.sav", case(lower) clear

* Correction on labels for regions of Tanzania
label define labels7 740 "Dodoma" 741 "Arusha" 742 "Kilimanjaro" 743 "Tanga" 744 "Morogoro" 745 "Pwani" 746 "Dar es Salaam" 747 "Lindi" 748 "Mtwara" 749 "Ruvuma" 750 "Iringa" 751 "Mbeya" 752 "Singida" 753 "Tabora" 754 "Rukwa" 755 "Kigoma" 756 "Shinyanga" 757 "Kagera" 758 "Mwanza" 759 "Mara" 760 "Manyara" 761 "Unguja Kaskazini" 762 "Unguja Kusini" 763 "Mjini Magharibi" 764 "Pemba Kaskazini" 765 "Pemba Kusini" 766 "Geita" 767 "Katavi" 768 "Njombe" 769 "Simiyu" 770 "Songwe", modify

decode region, g(t1)
drop region
rename t1 region

* Angola (2)
replace region = "Bie" if country==2 & region=="Bié"
replace region = "Kuanza Norte" if country==2 & region=="Cuanza Norte"
replace region = "Malanje" if country==2 & region=="Malange"

* Benin (3)
replace region = "Alibori" if country==3 & region=="ALIBORI"
replace region = "Atakora" if country==3 & region=="ATACORA"
replace region = "Atlantique" if country==3 & region=="ATLANTIQUE"
replace region = "Borgou" if country==3 & region=="BORGOU"
replace region = "Collines" if country==3 & region=="COLLINES"
replace region = "Couffo" if country==3 & region=="COUFFO"
replace region = "Donga" if country==3 & region=="DONGA"
replace region = "Littoral" if country==3 & region=="LITTORAL"
replace region = "Mono" if country==3 & region=="MONO"
replace region = "Oueme" if country==3 & region=="OUEME"
replace region = "Plateau" if country==3 & region=="PLATEAU"
replace region = "Zou" if country==3 & region=="ZOU"

* Botswana (4)
replace region = "Central" if country==4 & (region=="Central Bobonong" | region=="Central Boteti" | region=="Central Mahalapye" | region=="Central Serowe/Palapye" | region=="Central Tutume" | region=="Sowa" | region=="Selibe Phikwe")
replace region = "Kgaladi" if country==4 & (region=="Kgalagadi North" | region=="Kgalagadi South")
replace region = "Kweneng" if country==4 & (region=="Kweneng East" | region=="Kweneng West")
replace region = "Ngamiland" if country==4 & (region=="Ngamiland East" | region=="Ngamiland West")
replace region = "South-East" if country==4 & (region=="Gaborone" | region=="South East" | region=="Lobatse")
replace region = "Southern" if country==4 & (region=="Jwaneng" | region=="Ngwaketse" | region=="Ngwaketse West" | region=="Barolong") 
replace region = "North East" if country==4 & region=="Francistown"

* Burkina Faso (5)
replace region = "Boucle Du Mouhoun" if country==5 & region=="BOUCLE DU MOUHOUN"
replace region = "Cascades" if country==5 & region=="CASCADES"
replace region = "Centre" if country==5 & region=="CENTRE"
replace region = "Centre-est" if country==5 & region=="CENTRE EST"
replace region = "Centre-nord" if country==5 & region=="CENTRE NORD"
replace region = "Centre-ouest" if country==5 & region=="CENTRE OUEST"
replace region = "Centre-sud" if country==5 & region=="CENTRE SUD"
replace region = "Est" if country==5 & region=="EST"
replace region = "Hauts-bassins" if country==5 & region=="HAUTS BASSINS"
replace region = "Nord" if country==5 & region=="NORD"
replace region = "Plateau Central" if country==5 & region=="PLATEAU CENTRAL"
replace region = "Sahel" if country==5 & region=="SAHEL"
replace region = "Sud-ouest" if country==5 & region=="SUD OUEST"

* Cabo Verde (6)
set obs 49000
label define labels0 6 "Cape Verde", modify
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
	local row = 48084 + `t'
	replace country = 6 if _n==`row'
	replace region = "`c_`t''" if country==6 & _n==`row'
}
replace region = "Santiago" if country==6 & (region=="Santiago – Interior" | region=="Santiago – Praia")
replace region = "Santo Antao" if country==6 & region=="Santo Antão"
replace region = "Sao Vicente" if country==6 & region=="São Vicente"

* Cameroon (7)
replace region = "Extrême - Nord" if country==7 & region=="Extreme- Nord"
replace region = "Nord - Ouest" if country==7 & region=="Nord Ouest"
replace region = "Sud - Ouest" if country==7 & region=="Sud Ouest"
replace region = "Centre" if country==7 & region=="Mfoundi"
replace region = "Littoral" if country==7 & region=="Wouri"

* Côte d'Ivoire (8)
replace region = "Lagunes" if country==8 & (region=="Agneby-Tiassa" | region=="Grands-Ponts" | region=="La Me")
replace region = "District autonome de Abidjan" if country==8 & (region=="Autonome D'abidjan")
replace region = "District autonome de Yamoussoukro" if country==8 & (region=="Yamoussoukro")
replace region = "Woroba" if country==8 & (region=="Bafing" |  region=="Bere" | region=="Worodougou")
replace region = "Savanes" if country==8 & (region=="Bagoue" | region=="Poro" | region=="Tchologo" )
replace region = "Lacs" if country==8 & (region=="Belier" | region=="Iffou" | region=="Moronou" | region=="N'zi")
replace region = "Zanzan" if country==8 & (region=="Bounkani" | region=="Gontougo")
replace region = "Montagnes" if country==8 & (region=="Cavally" | region=="Guemon" | region=="Tonkpi")
replace region = "Denguele" if country==8 & (region=="Folon" | region=="Kabadougou")
replace region = "Vallee Du Bandama" if country==8 & (region=="Gbeke" | region=="Hambol")
replace region = "Bas Sassandra" if country==8 & (region=="Gbôkle" | region=="Nawa" | region=="San-Pedro")
replace region = "Gôh-Djiboua" if country==8 & (region=="Gôh" | region=="Lôh-Djiboua")
replace region = "Sassandra-Marahoue" if country==8 & (region=="Haut-Sassandra" | region=="Marahoue")
replace region = "Comoe" if country==8 & (region=="Indenie-Djuablin" | region=="Sud-Comoe")

* Eswatini (9)
label define labels0 9 "Swaziland", modify

* Ethiopia (10)
replace region = "Addis Ababa" if country==10 & region=="Addis Ababa City Administration"
replace region = "Beneshangul Gumu" if country==10 & region=="Benishangul-Gumuz"
replace region = "Dire Dawa" if country==10 & region=="Dire Dawa City Adminnistration"
replace region = "Hareri" if country==10 & region=="Harari"
replace region = "SNNPR" if country==10 & region=="Souther Nations, Nationalities & Peoples (SNNP)"

* Gabon (11)
replace region = "Estuaire" if country==11 & region=="ESTUAIRE"
replace region = "Haut-Ogooue" if country==11 & region=="HAUT-OGOOUÉ"
replace region = "Moyen-Ogooue" if country==11 & region=="MOYEN-OGOOUÉ"
replace region = "Ngounie" if country==11 & region=="NGOUNIÉ"
replace region = "Nyanga" if country==11 & region=="NYANGA"
replace region = "Ogooue-Ivindo" if country==11 & region=="OGOOUÉ-IVINDO"
replace region = "Ogooue-lolo" if country==11 & region=="OGOOUÉ-LOLO"
replace region = "Ogooue-Maritime" if country==11 & region=="OGOOUÉ-MARITIME"
replace region = "Woleu-Ntem" if country==11 & region=="WOLEU-NTEM"

* Gambia (12)
label define labels0 12 "The Gambia", modify
replace region = "Kanifing Municipal Council" if country==12 & (region=="Banjul" | region=="Kanifing")
replace region = "Central River" if country==12 & (region=="Janjanbureh" | region=="Kuntaur")
replace region = "Lower River" if country==12 & region=="Mansakonko"
replace region = "North Bank" if country==12 & region=="Kerewan"
replace region = "Upper River" if country==12 & region=="Basse"
replace region = "West Coast" if country==12 & region=="Brikama"

* Ghana (13)
replace region = "Brong Ahafo" if country==13 & (region=="AHAFO" | region=="BONO EAST" | region=="BONO")
replace region = "Ashanti" if country==13 & region=="ASHANTI"
replace region = "Central" if country==13 & region=="CENTRAL"
replace region = "Eastern" if country==13 & region=="EASTERN"
replace region = "Greater Accra" if country==13 & region=="GREATER ACCRA"
replace region = "Northern" if country==13 & (region=="NORTH EAST" | region=="NORTHERN" | region=="SAVANNAH")
replace region = "Upper East" if country==13 & region=="UPPER EAST"
replace region = "Upper West" if country==13 & region=="UPPER WEST"
replace region = "Volta" if country==13 & (region=="VOLTA" | region=="OTI")
replace region = "Western" if country==13 & (region=="WESTERN" | region=="WESTERN NORTH")

* Guinea (14)
replace region = "Boke" if country==14 & region=="BOKÉ"
replace region = "Conakry" if country==14 & region=="CONAKRY"
replace region = "Faranah" if country==14 & region=="FARANAH"
replace region = "Kankan" if country==14 & region=="KANKAN"
replace region = "Kindia" if country==14 & region=="KINDIA"
replace region = "Mamou" if country==14 & region=="MAMOU"
replace region = "Nzerekore" if country==14 & region=="N'ZÉRÉKORÉ"
replace region = "Labe" if country==14 & region=="LABÉ"

* Kenya (15)
local Coast_list "MOMBASA KWALE KILIFI LAMU"
local NE_list "GARISSA WAJIR MANDERA"
local Eastern_list "MARSABIT ISIOLO MERU THARAKA-NITHI EMBU KITUI MACHAKOS MAKUENI"
local Central_list "NYANDARUA NYERI KIRINYAGA MURANG'A KIAMBU"
local RV_list "TURKANA SAMBURU ELGEYO-MARAKWET NANDI BARINGO LAIKIPIA NAKURU NAROK KAJIADO KERICHO BOMET"
local Western_list "KAKAMEGA VIHIGA BUNGOMA BUSIA"
local Nyanza_list "SIAYA KISUMU MIGORI KISII NYAMIRA"
local Nairobi_list "NAIROBI"
foreach z in Coast NE Eastern Central RV Western Nyanza Nairobi{
	foreach x of local `z'_list{
		replace region = "`z'" if country==15 & region=="`x'"
	}
	if ("`z'"=="NE"){
		replace region = "North Eastern" if country==15 & region=="NE"
	}
	if ("`z'"=="RV"){
		replace region = "Rift Valley" if country==15 & region=="RV"
	}
}
replace region = "Coast" if country==15 & region=="TANA RIVER"
replace region = "Coast" if country==15 & region=="TAITA TAVETA"
replace region = "Rift Valley" if country==15 & region=="WEST POKOT"
replace region = "Rift Valley" if country==15 & region=="UASIN GISHU"
replace region = "Rift Valley" if country==15 & region=="TRANS NZOIA"
replace region = "Nyanza" if country==15 & region=="HOMA BAY"

* Lesotho (16)
replace region = "Butha Buthe" if country==16 & region=="Butha-Buthe"
replace region = "Mohale's Hoek" if country==16 & region=="Mohale’s Hoek"
replace region = "Qacha's Nek" if country==16 & region=="Qacha’s Nek"

* Liberia (17)
replace region = "Grand Bassa" if country==17 & region=="Bassa"
replace region = "Grand Cape Mount" if country==17 & region=="Cape Mount"

* Malawi (19)
replace region = "Central Region" if country==19 & region=="Center"
replace region = "Northern Region" if country==19 & region=="North"
replace region = "Southern Region" if country==19 & region=="South"
replace country = 19 if _n==48095
replace region = "Area under National Administration" if country==19 & _n==48095

* Mali (20)
replace region = "Segou" if country==20 & region=="Ségou"
replace country = 20 if _n==48096
replace region = "Kidal" if country==20 & _n==48096

* Mauritius (21)
replace region = "Grand Port" if country==21 & region=="Grand  Port"
replace region = "Plaines Wilhems" if country==21 & region=="Plaine Wilhems"
replace region = "Riviere Du Rempart" if country==21 & region=="Riviere du Rempart"
replace region = "Administrative unit not available" if country==21 & region=="Rodrigues"

* Morocco (22)
* OBSERVATION: Looks like the ADM1 divisions used by the WBG is deprecated. Nowadays, there are 12 regions in Morocco instead of 15.
drop if country==22

* Mozambique (23)
replace region = "Maputo" if country==23 & (region=="Maputo City" | region=="Maputo Province")
replace region = "Zambezia" if country==23 & region=="Zambézia"
replace region = "Lago niassa" if country==23 & region=="Niassa"

* Namibia (24)
replace region = "Karas" if country==24 & region=="!Karas"
replace region = "Kavango" if country==24 & (region=="Kavango East" | region=="Kavango West")
replace region = "Caprivi" if country==24 & region=="Zambezi"

* Niger (25)
replace region = "Agadez" if country==25 & region=="AGADEZ"
replace region = "Diffa" if country==25 & region=="DIFFA"
replace region = "Dosso" if country==25 & region=="DOSSO"
replace region = "Maradi" if country==25 & region=="MARADI"
replace region = "Niamey" if country==25 & region=="NIAMEY"
replace region = "Tahoua" if country==25 & region=="TAHOUA"
replace region = "Tillaberi" if country==25 & region=="TILLABERI"
replace region = "Zinder" if country==25 & region=="ZINDER"

* Nigeria (26)
replace region = "Abia" if country==26 & region=="ABIA"
replace region = "Adamawa" if country==26 & region=="ADAMAWA"
replace region = "Akwa Ibom" if country==26 & region=="AKWA IBOM"
replace region = "Anambra" if country==26 & region=="ANAMBRA"
replace region = "Bauchi" if country==26 & region=="BAUCHI"
replace region = "Bayelsa" if country==26 & region=="BAYELSA"
replace region = "Benue" if country==26 & region=="BENUE"
replace region = "Borno" if country==26 & region=="BORNO"
replace region = "Cross River" if country==26 & region=="CROSS RIVER"
replace region = "Delta" if country==26 & region=="DELTA"
replace region = "Ebonyi" if country==26 & region=="EBONYI"
replace region = "Edo" if country==26 & region=="EDO"
replace region = "Ekiti" if country==26 & region=="EKITI"
replace region = "Enugu" if country==26 & region=="ENUGU"
replace region = "Abuja" if country==26 & region=="FCT ABUJA"
replace region = "Gombe" if country==26 & region=="GOMBE"
replace region = "Imo" if country==26 & region=="IMO"
replace region = "Jigawa" if country==26 & region=="JIGAWA"
replace region = "Kaduna" if country==26 & region=="KADUNA"
replace region = "Kano" if country==26 & region=="KANO"
replace region = "Katsina" if country==26 & region=="KATSINA"
replace region = "Kebbi" if country==26 & region=="KEBBI"
replace region = "Kogi" if country==26 & region=="KOGI"
replace region = "Kwara" if country==26 & region=="KWARA"
replace region = "Lagos" if country==26 & region=="LAGOS"
replace region = "Nassarawa" if country==26 & region=="NASARAWA"
replace region = "Niger" if country==26 & region=="NIGER"
replace region = "Ogun" if country==26 & region=="OGUN"
replace region = "Ondo" if country==26 & region=="ONDO"
replace region = "Osun" if country==26 & region=="OSUN"
replace region = "Oyo" if country==26 & region=="OYO"
replace region = "Plateau" if country==26 & region=="PLATEAU"
replace region = "Rivers" if country==26 & region=="RIVERS"
replace region = "Sokoto" if country==26 & region=="SOKOTO"
replace region = "Taraba" if country==26 & region=="TARABA"
replace region = "Yobe" if country==26 & region=="YOBE"
replace region = "Zamfara" if country==26 & region=="ZAMFARA"

* Senegal (28)
replace region = strproper(region) if country==28
replace region = "Saint louis" if country==28 & region=="Saint-Louis"

* Sierra Leone (29)
replace region = strproper(region) if country==29
replace region = "Western Area" if country==29 & region=="Western"

* South Africa (30)
* No changes required

* Sudan (31)
* Darfur expansion
expand 2 if country==31 & region=="Darfur", g(t1)
replace region = "Northern Darfur" if country==31 & region=="Darfur" & t1==1
drop t1
expand 2 if country==31 & region=="Darfur", g(t1)
replace region = "Southern Darfur" if country==31 & region=="Darfur" & t1==1
replace region = "Western Darfur" if country==31 & region=="Darfur"
drop t1
* Central expansion
expand 2 if country==31 & region=="Central", g(t1)
replace region = "Al Jazeera" if country==31 & region=="Central" & t1==1
drop t1
expand 2 if country==31 & region=="Central", g(t1)
replace region = "Blue Nile" if country==31 & region=="Central" & t1==1
drop t1
expand 2 if country==31 & region=="Central", g(t1)
replace region = "Nile" if country==31 & region=="Central" & t1==1
drop t1
expand 2 if country==31 & region=="Central", g(t1)
replace region = "Sennar" if country==31 & region=="Central" & t1==1
drop t1
replace region = "White Nile" if country==31 & region=="Central"
* Kordofan expansion
expand 2 if country==31 & region=="Kordofan", g(t1)
replace region = "Southern Kordofan" if country==31 & region=="Kordofan" & t1==1
drop t1
replace region = "Northern Kordofan" if country==31 & region=="Kordofan"
* East expansion
expand 2 if country==31 & region=="East", g(t1)
replace region = "Red Sea" if country==31 & region=="East" & t1==1
drop t1
expand 2 if country==31 & region=="East", g(t1)
replace region = "Kassala" if country==31 & region=="East" & t1==1
drop t1
replace region = "Gadaref" if country==31 & region=="East"

* Tanzania (32)
replace region = "Dar-es-salaam" if country==32 & region=="Dar es Salaam"
replace region = "Kaskazini Pemba" if country==32 & region=="Pemba Kaskazini"
replace region = "Kaskazini Unguja" if country==32 & region=="Unguja Kaskazini"
replace region = "Kusini Pemba" if country==32 & region=="Pemba Kusini"
replace region = "Kusini Unguja" if country==32 & region=="Unguja Kusini"
replace region = "Mbeya" if country==32 & region=="Songwe"

* Togo (33)
replace region = strproper(region) if country==33
replace region = "Maritime" if country==33 & region=="Lome"

* Tunisia (34)
* Center east expansion
expand 2 if country==34 & region=="Center East", g(t1)
replace region = "Mahdia" if country==34 & region=="Center East" & t1==1
drop t1
expand 2 if country==34 & region=="Center East", g(t1)
replace region = "Monastir" if country==34 & region=="Center East" & t1==1
drop t1
expand 2 if country==34 & region=="Center East", g(t1)
replace region = "Sfax" if country==34 & region=="Center East" & t1==1
drop t1
replace region = "Sousse" if country==34 & region=="Center East"
* Center west expansion
expand 2 if country==34 & region=="Center West", g(t1)
replace region = "Kairouan" if country==34 & region=="Center West" & t1==1
drop t1
expand 2 if country==34 & region=="Center West", g(t1)
replace region = "Kasserine" if country==34 & region=="Center West" & t1==1
drop t1
replace region = "Sidi Bouz" if country==34 & region=="Center West"
* North east expansion
expand 2 if country==34 & region=="North East", g(t1)
replace region = "Ariana" if country==34 & region=="North East" & t1==1
drop t1
expand 2 if country==34 & region=="North East", g(t1)
replace region = "Ben Arous" if country==34 & region=="North East" & t1==1
drop t1
expand 2 if country==34 & region=="North East", g(t1)
replace region = "Bizerte" if country==34 & region=="North East" & t1==1
drop t1
expand 2 if country==34 & region=="North East", g(t1)
replace region = "Manouba" if country==34 & region=="North East" & t1==1
drop t1
expand 2 if country==34 & region=="North East", g(t1)
replace region = "Nabeul" if country==34 & region=="North East" & t1==1
drop t1
expand 2 if country==34 & region=="North East", g(t1)
replace region = "Tunis" if country==34 & region=="North East" & t1==1
drop t1
replace region = "Zaghouan" if country==34 & region=="North East"
* North west expansion
expand 2 if country==34 & region=="North West", g(t1)
replace region = "Beja" if country==34 & region=="North West" & t1==1
drop t1
expand 2 if country==34 & region=="North West", g(t1)
replace region = "Jendouba" if country==34 & region=="North West" & t1==1
drop t1
expand 2 if country==34 & region=="North West", g(t1)
replace region = "Le Kef" if country==34 & region=="North West" & t1==1
drop t1
replace region = "Siliana" if country==34 & region=="North West"
* South east expansion
expand 2 if country==34 & region=="South East", g(t1)
replace region = "Gabes" if country==34 & region=="South East" & t1==1
drop t1
expand 2 if country==34 & region=="South East", g(t1)
replace region = "Medenine" if country==34 & region=="South East" & t1==1
drop t1
replace region = "Tataouine" if country==34 & region=="South East"
* South west expansion
expand 2 if country==34 & region=="South West", g(t1)
replace region = "Gafsa" if country==34 & region=="South West" & t1==1
drop t1
expand 2 if country==34 & region=="South West", g(t1)
replace region = "Kebili" if country==34 & region=="South West" & t1==1
drop t1
replace region = "Tozeur" if country==34 & region=="South West"
replace region = "Tunis" if country==34 & region=="Great Tunis"

* Uganda (35)
local Acholi "Amuru Nwoya Gulu Lamwo Kitgum Agago Pader"
local Busoga "Bugiri Buyende Iganga Jinja Kaliro Kamuli Luuka Mayuge Namayingo Namutumba"
local Karamoja "Kotido Kaabong Abim Moroto Napak Amudat Nakapiripirit"
local Lango "Amolatar Alebtong Apac Dokolo Kole Lira Oyam Otuke"
local Eastern "Amuria Budaka Bududa Bukedea Bukwo Bulambuli Busia Butaleja Kaberamaido Kapchorwa Katakwi Kibuku Kumi Kween Manafwa Mbale Ngora Pallisa Serere Sironko Soroti Tororo"
local Tooro "Bundibugyo Kabarole Kamwenge Kasese Kyegegwa Kyenjojo Ntoroko"
local Kigezi "Kabale Kisoro Rukungiri"
local Bunyoro "Buliisa Hoima Kibaale Kiryandongo Masindi"
local Buganda "Buikwe Bukomansimbi Butambala Buvuma Gomba Kalangala Kalungu Kampala Kayunga Kiboga Kyankwanzi Luwero Lwengo Lyantonde Masaka Mityana Mpigi Mubende Mukono Nakaseke Nakasongola Rakai Ssembabule Wakiso"
local Ankole "Buhweju Bushenyi Ibanda Isingiro Kanungu Kiruhura Mbarara Mitooma Ntungamo Rubirizi Sheema"
global elements "Acholi Busoga Karamoja Lango Eastern Tooro Kigezi Bunyoro Buganda Ankole"
foreach z in $elements{
	local count_`z' = `: word count ``z'''
	local i = 0
	foreach x of local `z'{
		local i = `i' + 1
		if (`i'!=`count_`z''){
			expand 2 if country==35 & region=="`z'", g(t1)
			replace region = "`x'" if country==35 & region=="`z'" & t1==1
			drop t1
		}
		else{
			replace region = "`x'" if country==35 & region=="`z'"
		}
	}
}
foreach x in Adjumani Arua Koboko Maracha Moyo Nebbi Yumbe{
	expand 2 if country==35 & region=="West Nile", g(t1)
	replace region = "`x'" if country==35 & region=="West Nile" & t1==1
	drop t1
}
replace region = "Zombo" if country==35 & region=="West Nile"

* Zambia (36)
replace region = "North-Western" if country==36 & region=="North Western"
replace region = "Northern" if country==36 & region=="Muchinga"

* Zimbabwe (37)
replace region = "Mashonaland East" if country==37 & region=="Mashonaland  East"

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
gen own_bank_account = (q92e==2) // only option "yes, do own"
replace own_bank_account = . if q92e==8 | q92e==9 | q92e==-1 | q92e==.

* v2: How dependent on receiving remittances [NO DATA]
gen remittances = -1

* v3: Freedom to say what you think
/*
	Not at all free	1
	Not very free	2
	Somewhat free	3
	Completely free	4
	Refused	8
	Don’t know	9
*/
gen free_speak = (q10a==4) // completely free = freedom of speech
replace free_speak = . if q10a==8 | q10a==9 | q10a==-1 | q92e==.

* v4: Voting in the most recent national election
/*
	Missing   -1
	I did not vote	0
	I	was too young	1
	I	can’t remember	2
	I	voted in the e	3
	Refused	8
	Don't know 9
*/
gen vote_nat = (q13==3)
replace vote_nat = . if q13==98 | q13==9 | q13==-1 | q13==.

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
gen attended_demons = (q11c>=2 & q11c<=4) // yes, once or twice, several times, often
replace attended_demons=. if q11c==8 | q11c==9 | q11c==-1 | q11c==.

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
gen internet_use = (q92i>=1 & q92i<=4) // less than once a month, a few times a month (a week), everyday
replace internet_use = . if q92i==8 | q92i==9 | q92i==-1 | q92i==.

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
gen enough_food = (q7a>=1 & q7a<=4) // just once or twice, several times, many times, always
replace enough_food=. if q7a==8 | q7a==9 | q7a==-1 | q7a==.

* v8: Member of voluntary association or community group [NO DATA]
gen voluntary_assoc = -1

* v9: Trust police
/*
	Not at all	0
	Just a little	1
	Somewhat	2
	A lot	3
	Refused	8
	Don’t know/Haven	9
*/
gen conf_police = (q41g==2 | q41g==3) // somewhat, a lot
replace conf_police=. if q41g==8 | q41g==9 | q41g==-1 | q41g==.

* v10: Trust courts of law
/*
	Not at all	0
	Just a little	1
	Somewhat	2
	A lot	3
	Refused	8
	Don’t know/Haven	9
*/
gen conf_justice = (q41i==2 | q41i==3) // somewhat, a lot
replace conf_justice=. if q41i==8 | q41i==9 | q41i==-1 | q41i==.

* v11: Trust national electoral commission
/*
	Not at all	0
	Just a little	1
	Somewhat	2
	A lot	3
	Refused	8
	Don’t know/Haven	9
*/
gen conf_elections = (q41c==2 | q41c==3) // somewhat, a lot
replace conf_elections=. if q41c==8 | q41c==9 | q41c==-1 | q41c==.

* v12: Trust your elected local government council
/*
	Not at all	0
	Just a little	1
	Somewhat	2
	A lot	3
	Refused	8
	Don’t know/Haven	9
*/
gen conf_govern = (q41d==2 | q41d==3) // somewhat, a lot
replace conf_govern=. if q41d==8 | q41d==9 | q41d==-1 | q41d==.

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
gen free_join = (q19a==3 | q19a==4) // agree with 2, strongly agree with 2
replace free_join = . if q19a==-1 | q19a==8 | q19a==9 | q19a==.

* v14: most people can be trusted
/*
	Must	be very car	0
	Most	people can	1
	Refused	8
	Don’t know	9
*/
gen trust_people = (q83==1) // most people can be trusted
replace trust_people = . if q83==8 | q83==9 | q83==-1 | q83==.

* v15: dislike homosexual neighbors
/*
	Missing	-1
	Strongly  dislik	1
	Somewhat dislike	2
	Would not care	3
	Somewhat  like	4
	Strongly like	5
	Refused	8
	Don’t know	9
*/
gen dislike_hom = (q86c==1 | q86c==2) // dislike homosexual neighbors
replace dislike_hom = . if q86c==8 | q86c==9 | q86c==-1 | q86c==.

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
gen feel_unsafe = (q8a>=1 & q8a<=4) // just once or twice, several times, many times, always
replace feel_unsafe = . if q8a==8 | q8a==9 | q8a==-1 | q8a==.

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
gen feared_crime = (q8b>=1 & q8b<=4) // just once or twice, several times, many times, always
replace feared_crime = . if q8b==8 | q8b==9 | q8b==-1 | q8b==.

* extra 1: People who experienced discrimination based on disability
gen ex_disability1 = .

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
gen source = "Afrobarometer 8"

* ----------------- *
* Collapse the data *
* ----------------- *

recode withinwt_hh (.=1)

collapse (mean) si_ownban* re_rem* sc_frespe* sc_vot* sc_attdem* si_intuse* re_enofoo* sc_volass* sc_conpol* sc_conjus* sc_conele* sc_congov* sc_frejoi* sc_trupeo* sc_homnei* sc_insnei* sc_unshom* ex_disability1 [aw=withinwt_hh], by(countryname region period source)

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

save "$proc_data\afrobarometer8_subnational.dta", replace

erase "countries_codes.dta"