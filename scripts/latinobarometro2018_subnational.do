* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* last update: March 26th, 2024
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

recode reg (604000=604014) // Lima correction

* ------------------------------------ *
* Administrative divisions corrections *
* ------------------------------------ *

decode reg, g(t1)
drop reg
rename t1 region

decode ciudad, g(t1)
drop ciudad
rename t1 ciudad

replace region = ciudad if idenpa==170 // Colombia: city instead of region
replace region = ciudad if idenpa==600 // Paraguay: city instead of region
replace region = ciudad if idenpa==862 // Venezuela: city instead of region

replace region = substr(region, 5, .)

replace region = substr(region, 1, strpos(region, "-") - 1) if idenpa==600 // Extracting region in Paraguay
replace region = substr(region, 1, strpos(region, "-") - 1) if idenpa==862 // Extracting region in Venezuela

* Argentina (32)
replace region = "Buenos Aires D.f." if idenpa==32 & region=="Capital Federal"
replace region = "Mendoza" if idenpa==32 & region=="Cuyo/Mendoza"
replace region = "Chaco" if idenpa==32 & region=="Noreste/Chaco"
replace region = "Corrientes" if idenpa==32 & region=="Noreste/Corrientes"
replace region = "Entre Rios" if idenpa==32 & region=="Noreste/Entre Ríos"
replace region = "Salta" if idenpa==32 & region=="Noroeste/Salta"
replace region = "Tucuman" if idenpa==32 & region=="Noroeste/Tucumán"
replace region = "Buenos Aires" if idenpa==32 & region=="Pampeana/Buenos Aires"
replace region = "Cordoba" if idenpa==32 & region=="Pampeana/Córdoba"
replace region = "La Pampa" if idenpa==32 & region=="Pampeana/La Pampa"
replace region = "Santa Fe" if idenpa==32 & region=="Pampeana/Santa Fé"
replace region = "Neuquen" if idenpa==32 & region=="Patagónica/Neuquén"
replace region = "Rio Negro" if idenpa==32 & region=="Patagónica/Río Negro"

set obs 25000
local i = 0
foreach x in Catamarca Chubut Formosa Jujuy Misiones La_Rioja San_Juan San_Luis Santa_Cruz Santiago_Del_Estero Tierra_Del_Fuego{
	local i = `i' + 1
	local j = `i' + 20204
	replace idenpa = 32 if _n==`j'
	replace region = "`x'" if idenpa==32 & _n==`j'
}
replace region = "La Rioja" if idenpa==32 & region=="La_Rioja"
replace region = "San Juan" if idenpa==32 & region=="San_Juan"
replace region = "San Luis" if idenpa==32 & region=="San_Luis"
replace region = "Santa Cruz" if idenpa==32 & region=="Santa_Cruz"
replace region = "Santiago Del Estero" if idenpa==32 & region=="Santiago_Del_Estero"
replace region = "Tierra Del Fuego" if idenpa==32 & region=="Tierra_Del_Fuego"

* Bolivia (68)
replace region = "Potosi" if idenpa==68 & region=="Potosí"

* Brazil (76)
* Sul expansion
expand 2 if idenpa==76 & region=="Sul", g(t1)
replace region = "Rio Grande Do Sul" if idenpa==76 & region=="Sul" & t1==1
drop t1
expand 2 if idenpa==76 & region=="Sul", g(t1)
replace region = "Santa Catarina" if idenpa==76 & region=="Sul" & t1==1
drop t1
replace region = "Parana" if idenpa==76 & region=="Sul"
* Sudeste expansion
expand 2 if idenpa==76 & region=="Sudeste", g(t1)
replace region = "Espirito Santo" if idenpa==76 & region=="Sudeste" & t1==1
drop t1
expand 2 if idenpa==76 & region=="Sudeste", g(t1)
replace region = "Minas Gerais" if idenpa==76 & region=="Sudeste" & t1==1
drop t1
expand 2 if idenpa==76 & region=="Sudeste", g(t1)
replace region = "Rio De Janeiro" if idenpa==76 & region=="Sudeste" & t1==1
drop t1
replace region = "Sao Paulo" if idenpa==76 & region=="Sudeste"
* Nordeste expansion, special case
expand 2 if idenpa==76 & region=="Nordeste", g(t1)
replace region = "Rio Grande Do Norte" if idenpa==76 & region=="Nordeste" & t1==1
drop t1
* Centro-Oeste expansion
expand 2 if idenpa==76 & region=="Centro-Oeste", g(t1)
replace region = "Distrito Federal" if idenpa==76 & region=="Centro-Oeste" & t1==1
drop t1
expand 2 if idenpa==76 & region=="Centro-Oeste", g(t1)
replace region = "Goias" if idenpa==76 & region=="Centro-Oeste" & t1==1
drop t1
expand 2 if idenpa==76 & region=="Centro-Oeste", g(t1)
replace region = "Mato Grosso" if idenpa==76 & region=="Centro-Oeste" & t1==1
drop t1
replace region = "Mato Grosso Do Sul" if idenpa==76 & region=="Centro-Oeste"
* Norte and Nordeste expansion (general)
local Norte "Acre Amapa Amazonas Para Rondonia Roraima Tocantins"
local Nordeste "Alagoas Bahia Ceara Maranhao Paraiba Pernambuco Piaui Sergipe"
global elements "Norte Nordeste"
foreach z in $elements{
	local count_`z' = `: word count ``z'''
	local i = 0
	foreach x of local `z'{
		local i = `i' + 1
		if (`i'!=`count_`z''){
			expand 2 if idenpa==76 & region=="`z'", g(t1)
			replace region = "`x'" if idenpa==76 & region=="`z'" & t1==1
			drop t1
		}
		else{
			replace region = "`x'" if idenpa==76 & region=="`z'"
		}
	}
}

* Chile (152)
replace region = subinstr(region, "XV Región: ", "", .) if idenpa==152
replace region = subinstr(region, "XIV Región: ", "", .) if idenpa==152
replace region = subinstr(region, "XII Región: ", "", .) if idenpa==152
replace region = subinstr(region, "XI Región: ", "", .) if idenpa==152
replace region = subinstr(region, "VIII Región: ", "", .) if idenpa==152
replace region = subinstr(region, "VII Región: ", "", .) if idenpa==152
replace region = subinstr(region, "VI Región: ", "", .) if idenpa==152
replace region = subinstr(region, "IV Región: ", "", .) if idenpa==152
replace region = subinstr(region, "V Región: ", "", .) if idenpa==152
replace region = subinstr(region, "IX Región: ", "", .) if idenpa==152
replace region = subinstr(region, "III Región: ", "", .) if idenpa==152
replace region = subinstr(region, "II Región: ", "", .) if idenpa==152
replace region = subinstr(region, "I Región: ", "", .) if idenpa==152
replace region = subinstr(region, "X Región: ", "", .) if idenpa==152
replace region = "Arica y Painacota" if idenpa==152 & region=="Arica y Parinacota"
replace region = "Aisen del Gral. Carlos Ibañez del Campo" if idenpa==152 & region=="Aysén del General Carlos Ibáñez del Campo"
replace region = "Biobio" if idenpa==152 & region=="Bío-Bío"
replace region = "Araucania" if idenpa==152 & region=="La Araucanía"
replace region = "Libertador Gral. Bernardo O'Higgins" if idenpa==152 & region=="Libertador Bernardo O´Higgins"
replace region = "Los Rios" if idenpa==152 & region=="Los Ríos"
replace region = "Magallanes y Antartica chilena" if idenpa==152 & region=="Magallanes y la Antártica Chilena"
replace region = "Metropolitana" if idenpa==152 & region=="Región Metropolitana"
replace region = "Tarapaca" if idenpa==152 & region=="Tarapacá"
replace region = "Valparaiso" if idenpa==152 & region=="Valparaíso"

* Colombia (170)
replace region = "Atlantico" if idenpa==170 & region=="Atlántico"
replace region = "Bolivar" if idenpa==170 & region=="Bolívar"
replace region = "Boyaca" if idenpa==170 & region=="Boyacá"
replace region = "Cesar" if idenpa==170 & region=="César"
replace region = "Cordoba" if idenpa==170 & region=="Córdoba"
replace region = "Narino" if idenpa==170 & region=="Nariño"
replace region = "Valle Del Cauca" if idenpa==170 & region=="Valle del cauca"
replace region = "Cundinamarca" if idenpa==170 & region=="Bogotá D.C."
set obs 31000
local i = 0
foreach x in Arauca Buenaventura Caqueta Casanare Choco Guainia Guajira Guaviare Putumayo Quindio San_Andres_Y_Providencia Sucre Vaupes Vichada{
	local i = `i' + 1
	local j = `i' + 30334
	replace idenpa = 170 if _n==`j'
	replace region = "`x'" if idenpa==170 & _n==`j'
}
replace region = "San Andres Y Providencia" if idenpa==170 & region=="San_Andres_Y_Providencia"

* Costa Rica (188)
replace region = "Limon" if idenpa==188 & region=="Limón"
replace region = "San Jose" if idenpa==188 & region=="San José"

* Republica Domincana (214)
replace region = "Dajabon" if idenpa==214 & region=="Dajabón"
replace region = "Salcedo" if idenpa==214 & region=="Hermanas Mirabal / Salcedo"
replace region = "Maria Trinidad Sanches" if idenpa==214 & region=="María Trinidad Sánchez"
replace region = "Monsenor Nouel" if idenpa==214 & region=="Monseñor Nouel"
replace region = "Monte Cristi" if idenpa==214 & region=="Montecristi"
replace region = "Peravia" if idenpa==214 & region=="Peravía"
replace region = "Santo Domingo" if idenpa==214 & region=="Provincia Santo Domingo"
replace region = "Samana" if idenpa==214 & region=="Samaná"
replace region = "San Cristobal" if idenpa==214 & region=="San Cristóbal"
replace region = "San Pedro de Macoris" if idenpa==214 & region=="San Pedro de Macorís"
replace region = "Santiago Rodriguez" if idenpa==214 & region=="Santiago Rodríguez"
replace region = "Sanchez Ramirez" if idenpa==214 & region=="Sánchez Ramírez"
replace idenpa = 214 if _n==30349
replace region = "Independencia" if idenpa==214 & _n==30349
replace idenpa = 214 if _n==30350
replace region = "Elias Pina" if idenpa==214 & _n==30350

* Ecuador (218)
replace region = "Bolivar" if idenpa==218 & region=="Bolívar"
replace region = "Los Rios" if idenpa==218 & region=="Los Ríos"
replace region = "Manabi" if idenpa==218 & region=="Manabí"
replace region = "Santo Domingo de los Tsachilas" if idenpa==218 & region=="Santo Domingo de los Sachilas"
local i = 0
foreach x in Canar Carchi Galapagos Napo Pastaza Zamora_Chinchipe Zona_No_Delimitada{
	local i = `i' + 1
	local j = `i' + 30350
	replace idenpa = 218 if _n==`j'
	replace region = "`x'" if idenpa==218 & _n==`j'
}
replace region = "Zamora Chinchipe" if idenpa==218 & region=="Zamora_Chinchipe"
replace region = "Zona No Delimitada" if idenpa==218 & region=="Zona_No_Delimitada"

* El Salvador (222)
replace region = subinstr(region, "Central/", "", .) if idenpa==222
replace region = subinstr(region, "Occidental/", "", .) if idenpa==222
replace region = subinstr(region, "Oriental/", "", .) if idenpa==222
replace region = "Ahuachapan" if idenpa==222 & region=="Ahuachapán"
replace region = "Cabanas" if idenpa==222 & region=="Cabañas"
replace region = "Cuscatlan" if idenpa==222 & region=="Cuscatlán"
replace region = "La Union" if idenpa==222 & region=="La Unión"
replace region = "Morazan" if idenpa==222 & region=="Morazán"
replace region = "Usulutan" if idenpa==222 & region=="Usulután"

* Guatemala (320)
replace region = subinstr(region, "Central/", "", .) if idenpa==320
replace region = subinstr(region, "Metropolitana/", "", .) if idenpa==320
replace region = subinstr(region, "Noroccidental/", "", .) if idenpa==320
replace region = subinstr(region, "Nororiental/", "", .) if idenpa==320
replace region = subinstr(region, "Norte/", "", .) if idenpa==320
replace region = subinstr(region, "Suroccidental/", "", .) if idenpa==320
replace region = subinstr(region, "Suroriental/", "", .) if idenpa==320
replace region = "Sacatepéquez" if idenpa==320 & region=="Sacatepequez"
replace region = "Sololá" if idenpa==320 & region=="Solola"
replace region = "Totonicapán" if idenpa==320 & region=="Totonicapan"

* Honduras (340)
replace region = "Atlantida" if idenpa==340 & region=="Atlántida"
replace region = "Colon" if idenpa==340 & region=="Colón"
replace region = "Copan" if idenpa==340 & region=="Copán"
replace region = "Cortes" if idenpa==340 & region=="Cortés"
replace region = "Paraiso" if idenpa==340 & region=="El Paraíso"
replace region = "Francisco Morazan" if idenpa==340 & region=="Francisco Morazán"
replace region = "Intibuca" if idenpa==340 & region=="Intibucá"
replace region = "Santa Barbara" if idenpa==340 & region=="Santa Bárbara"
replace idenpa = 340 if _n==30358
replace region = "Islas De Bahia" if idenpa==340 & _n==30358
replace idenpa = 340 if _n==30359
replace region = "Name Unknown" if idenpa==340 & _n==30359

* Mexico (484)
replace region = subinstr(region, "Centro/", "", .) if idenpa==484
replace region = subinstr(region, "Norte/", "", .) if idenpa==484
replace region = subinstr(region, "Occidente/", "", .) if idenpa==484
replace region = subinstr(region, "Sur/", "", .) if idenpa==484
replace region = "Distrito Federal" if idenpa==484 & region=="DF"
replace region = "Michoacan" if idenpa==484 & region=="Michoacán"
replace region = "Mexico" if idenpa==484 & region=="México"
replace region = "Nuevo Leon" if idenpa==484 & region=="Nuevo León"
replace region = "Queretaro" if idenpa==484 & region=="Querétaro"
replace region = "San Luis Potosi" if idenpa==484 & region=="San Luis Potosí"
replace region = "Yucatan" if idenpa==484 & region=="Yucatán"

* Nicaragua (558)
replace region = "Esteli" if idenpa==558 & region=="Estelí"
replace region = "Leon" if idenpa==558 & region=="León"
replace region = "Atlantico Norte" if idenpa==558 & region=="R.A.A.N"
replace region = "Atlantico Sur" if idenpa==558 & region=="R.A.A.S"
replace region = "Rio San Juan" if idenpa==558 & region=="Río San Juan"

* Panama (591)
replace region = "Ngöbe Buglé" if idenpa==591 & region=="Comarca Ngöbe Buglé"
replace idenpa = 591 if _n==30360
replace region = "Emberá" if idenpa==591 & _n==30360
replace idenpa = 591 if _n==30361
replace region = "Kuna Yala" if idenpa==591 & _n==30361

* Paraguay (600)
replace region = "Alto Parana" if idenpa==600 & region=="Alto Paraná"
replace region = "Central" if idenpa==600 & region=="Asunción"
replace region = "Caaguazu" if idenpa==600 & region=="Caaguazú"
replace region = "Caazapa" if idenpa==600 & region=="Caazapá"
replace region = "Cordillera" if idenpa==600 & region=="Cordillera"
replace region = "Itapua" if idenpa==600 & region=="Itapúa"
replace region = "Paraguari" if idenpa==600 & region=="Paraguarí"

local i = 0
foreach x in Alto_Paraguay Boqueron Canindeyu Concepcion Guaira Misiones Neembucu Presidente_Hayes{
	local i = `i' + 1
	local j = `i' + 30361
	replace idenpa = 600 if _n==`j'
	replace region = "`x'" if idenpa==600 & _n==`j'
}
replace region = "Alto Paraguay" if idenpa==600 & region=="Alto_Paraguay"
replace region = "Presidente Hayes" if idenpa==600 & region=="Presidente_Hayes"

* Peru (604)
replace region = "Ancash" if idenpa==604 & region=="Áncash"
local i = 0
foreach x in Callao Madre_de_Dios Moquegua Pasco Tumbes Ucayali{
	local i = `i' + 1
	local j = `i' + 30369
	replace idenpa = 604 if _n==`j'
	replace region = "`x'" if idenpa==604 & _n==`j'
}
replace region = "Madre de Dios" if idenpa==604 & region=="Madre_de_Dios"

* Uruguay (858)
replace region = "Paysandu" if idenpa==858 & region=="Paysandú"
replace region = "San Jose" if idenpa==858 & region=="San José"
replace region = "Tacuarembo" if idenpa==858 & region=="Tacuarembó"
replace region = "Treinta Y Tres" if idenpa==858 & region=="Treinta y Tres"

* Venezuela (862)
replace region = "Anzoategui" if idenpa==862 & region=="Anzoátegui"
replace region = "Falcon" if idenpa==862 & region=="Falcón"
replace region = "Guarico" if idenpa==862 & region=="Guárico"
replace region = "Merida" if idenpa==862 & region=="Mérida"
replace region = "Tachira" if idenpa==862 & region=="Táchira"
local i = 0
foreach x in Delta_Amacuro Dependencias_Federales{
	local i = `i' + 1
	local j = `i' + 30375
	replace idenpa = 862 if _n==`j'
	replace region = "`x'" if idenpa==862 & _n==`j'
}
replace region = "Delta Amacuro" if idenpa==862 & region=="Delta_Amacuro"
replace region = "Dependencias Federales" if idenpa==862 & region=="Dependencias_Federales"

* Corrections
drop if idenpa==. & region==""

* -------------------- *
* Generating subgroups *
* -------------------- *

* s1: sex
recode sexo (2=0)
rename sexo sex
label define sex 1 "Male" 0 "Female"
label values sex sex

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

* ----------------- *
* Collapse the data *
* ----------------- *

recode wt (.=1)

collapse (mean) si_chiear* re_govtra* re_savmon* re_enofoo* sc_trupeo* sc_congov* sc_conpol* sc_conele* sc_conjus* sc_insnei* sc_viccri* sc_frespe* [aw=wt], by(countryname region period source)

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

* macros for lists
global vars "si_chiear re_govtra re_savmon re_enofoo sc_trupeo sc_congov sc_conpol sc_conele sc_conjus sc_insnei sc_viccri sc_frespe"

* labels
foreach x in $vars{
	lab var `x' "`t_`x''"
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
merge m:1 countryname using "countries_codes.dta"
keep if _merge==3
drop _merge

order countryname countrycode region period source
rename region adm1_name

* ------ *
* Saving *
* ------ *

save "$proc_data\latinobarometro2018_subnational.dta", replace

erase "countries_codes.dta"