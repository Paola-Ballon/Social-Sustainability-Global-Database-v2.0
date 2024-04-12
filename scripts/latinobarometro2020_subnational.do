* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* last update: March 26th, 2024
* original data source: https://www.latinobarometro.org/latContents.jsp

/*
Issues:
	- Respondents have 16+ years
	- Urban/rural definition is based on the population size. If this magnitude is equal to or higher than 50000 people, then the region is treated as urban, otherwise is treated as rural. In practice, this population threshold differs between countries. Also, the population size is a categorical (ordinal) variable, so we cannot apply every cutoff we want [subgroup]
		* Argentina does not have any information on urban/rural [subgroup]
*/

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\latinobarometro2020"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

cd "$raw_data"

use "Latinobarometro_2020_Esp_Stata_v1_0.dta", clear

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
replace region = ciudad if idenpa==862 // Venezuela: city instead of region

replace region = substr(region, 5, .)

replace region = substr(region, 1, strpos(region, "-") - 1) if idenpa==862 // Extracting region in Venezuela

* Argentina (32)
replace region = subinstr(region, "Cuyo/", "", .) if idenpa==32
replace region = subinstr(region, "Noreste/", "", .) if idenpa==32
replace region = subinstr(region, "Noroeste/", "", .) if idenpa==32
replace region = subinstr(region, "Pampeana/", "", .) if idenpa==32
replace region = subinstr(region, "Patagónica/", "", .) if idenpa==32
replace region = "Buenos Aires D.f." if idenpa==32 & region=="Capital Federal"
replace region = "Cordoba" if idenpa==32 & region=="Córdoba"
replace region = "Entre Rios" if idenpa==32 & region=="Entre Ríos"
replace region = "Buenos Aires" if idenpa==32 & region=="Metropolitana"
replace region = "Neuquen" if idenpa==32 & region=="Neuquén"
replace region = "Rio Negro" if idenpa==32 & region=="Río Negro"
replace region = "Santa Fe" if idenpa==32 & region=="Santa Fé"
replace region = "Tierra Del Fuego" if idenpa==32 & region=="Tierra de Fuego"
replace region = "Tucuman" if idenpa==32 & region=="Tucumán"
replace region = "Santiago Del Estero" if idenpa==32 & region=="Santiago del Estero"
set obs 20205
replace idenpa = 32 if _n==20205
replace region = "San Juan" if idenpa==32 & _n==20205

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
replace region = "Biobio" if idenpa==152 & (region=="Bío-Bío" | region=="Región de Ñuble")
replace region = "Araucania" if idenpa==152 & region=="La Araucanía"
replace region = "Libertador Gral. Bernardo O'Higgins" if idenpa==152 & region=="Libertador Bernardo O´Higgins"
replace region = "Los Rios" if idenpa==152 & region=="Los Ríos"
replace region = "Magallanes y Antartica chilena" if idenpa==152 & region=="Magallanes y la Antártica Chilena"
replace region = "Metropolitana" if idenpa==152 & region=="Región Metropolitana"
replace region = "Tarapaca" if idenpa==152 & region=="Tarapacá"
replace region = "Valparaiso" if idenpa==152 & region=="Valparaíso"

* Colombia (170)
replace region = "Atlantico" if idenpa==170 & region=="Atlántico"
replace region = "Cundinamarca" if idenpa==170 & region=="Bogotá D.C."
replace region = "Bolivar" if idenpa==170 & region=="Bolívar"
replace region = "Boyaca" if idenpa==170 & region=="Boyacá"
replace region = "Cesar" if idenpa==170 & region=="César"
replace region = "Cordoba" if idenpa==170 & region=="Córdoba"
replace region = "Narino" if idenpa==170 & region=="Nariño"
set obs 26000
local i = 0
foreach x in Arauca Buenaventura Caqueta Casanare Choco Guainia Guajira Guaviare Putumayo Quindio San_Andres_Y_Providencia Sucre Vaupes Vichada{
	local i = `i' + 1
	local j = `i' + 25539
	replace idenpa = 170 if _n==`j'
	replace region = "`x'" if idenpa==170 & _n==`j'
}
replace region = "San Andres Y Providencia" if idenpa==170 & region=="San_Andres_Y_Providencia"
replace region = "Valle Del Cauca" if idenpa==170 & region=="Valle del cauca"
drop if idenpa==. & region==""

* Costa Rica (188)
replace region = "Limon" if idenpa==188 & region=="Limón"
replace region = "San Jose" if idenpa==188 & region=="San José"

* Republica Domincana (214)
replace region = "Elias Pina" if idenpa==214 & region=="Elías Piña"
replace region = "Salcedo" if idenpa==214 & region=="Hermanas Mirabal / Salcedo"
replace region = "Maria Trinidad Sanches" if idenpa==214 & region=="María Trinidad Sánchez"
replace region = "Monsenor Nouel" if idenpa==214 & region=="Monseñor Nouel"
replace region = "Monte Cristi" if idenpa==214 & region=="Montecristi"
replace region = "Peravia" if idenpa==214 & region=="Peravía"
replace region = "Santo Domingo" if idenpa==214 & region=="Provincia Santo Domingo"
replace region = "Samana" if idenpa==214 & region=="Samaná"
replace region = "San Cristobal" if idenpa==214 & region=="San Cristóbal"
replace region = "San Pedro de Macoris" if idenpa==214 & region=="San Pedro de Macorís"
replace region = "Sanchez Ramirez" if idenpa==214 & region=="Sánchez Ramírez"
set obs 26000
local i = 0
foreach x in Dajabon Pedernales Santiago_Rodriguez San_José_de_Ocoa{
	local i = `i' + 1
	local j = `i' + 25553
	replace idenpa = 214 if _n==`j'
	replace region = "`x'" if idenpa==214 & _n==`j'
}
replace region = "Santiago Rodriguez" if idenpa==214 & region=="Santiago_Rodriguez"
replace region = "San José de Ocoa" if idenpa==214 & region=="San_José_de_Ocoa"
drop if idenpa==. & region==""

* Ecuador (218)
replace region = "Bolivar" if idenpa==218 & region=="Bolívar"
replace region = "Los Rios" if idenpa==218 & region=="Los Ríos"
replace region = "Manabi" if idenpa==218 & region=="Manabí"
replace region = "Santo Domingo de los Tsachilas" if idenpa==218 & region=="Santo Domingo de los Sachilas"
set obs 26000
local i = 0
foreach x in Canar Carchi Galapagos Napo Pastaza Zamora_Chinchipe Zona_No_Delimitada{
	local i = `i' + 1
	local j = `i' + 25557
	replace idenpa = 218 if _n==`j'
	replace region = "`x'" if idenpa==218 & _n==`j'
}
replace region = "Zamora Chinchipe" if idenpa==218 & region=="Zamora_Chinchipe"
replace region = "Zona No Delimitada" if idenpa==218 & region=="Zona_No_Delimitada"
drop if idenpa==. & region==""

* El Salvador (222)
drop if idenpa==222 & region=="ocumentado"
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
set obs 25565
replace idenpa = 340 if _n==25564
replace region = "Islas De Bahia" if idenpa==340 & _n==25564
replace idenpa = 340 if _n==25565
replace region = "Name Unknown" if idenpa==340 & _n==25565

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
set obs 25567
replace idenpa = 484 if _n==25566
replace region = "Baja California Sur" if idenpa==484 & _n==25566
replace idenpa = 484 if _n==25567
replace region = "Tabasco" if idenpa==484 & _n==25567

* Nicaragua (558)
replace region = "Esteli" if idenpa==558 & region=="Estelí"
replace region = "Leon" if idenpa==558 & region=="León"
replace region = "Atlantico Norte" if idenpa==558 & region=="R.A.A.N"
replace region = "Atlantico Sur" if idenpa==558 & region=="R.A.A.S"
replace region = "Rio San Juan" if idenpa==558 & region=="Río San Juan"

* Panama (591)
replace region = "Kuna Yala" if idenpa==591 & region=="Comarca Guna Yala"
replace region = "Ngöbe Buglé" if idenpa==591 & region=="Comarca Ngöbe Buglé"
set obs 25568
replace idenpa = 591 if _n==25568
replace region = "Emberá" if idenpa==591 & _n==25568

* Paraguay (600)
replace region = "Alto Parana" if idenpa==600 & region=="Alto Paraná"
replace region = "Central" if idenpa==600 & region=="Asunción"
replace region = "Caaguazu" if idenpa==600 & region=="Caaguazú"
replace region = "Caazapa" if idenpa==600 & region=="Caazapá"
replace region = "Canindeyu" if idenpa==600 & region=="Canindeyú"
replace region = "Concepcion" if idenpa==600 & region=="Concepción"
replace region = "Guaira" if idenpa==600 & region=="Guairá"
replace region = "Itapua" if idenpa==600 & region=="Itapúa"
replace region = "Neembucu" if idenpa==600 & region=="Ñeembucú"
set obs 25570
replace idenpa = 600 if _n==25569
replace region = "Alto Paraguay" if idenpa==600 & _n==25569
replace idenpa = 600 if _n==25570
replace region = "Boqueron" if idenpa==600 & _n==25570

* Peru (604)
replace region = "Ancash" if idenpa==604 & region=="Áncash"
set obs 26000
local i = 0
foreach x in Callao Madre_de_Dios Moquegua Pasco Tumbes Ucayali{
	local i = `i' + 1
	local j = `i' + 25570
	replace idenpa = 604 if _n==`j'
	replace region = "`x'" if idenpa==604 & _n==`j'
}
replace region = "Madre de Dios" if idenpa==604 & region=="Madre_de_Dios"
drop if idenpa==. & region==""

* Uruguay (858)
replace region = "Paysandu" if idenpa==858 & region=="Paysandú"
replace region = "San Jose" if idenpa==858 & region=="San José"
replace region = "Tacuarembo" if idenpa==858 & region=="Tacuarembó"
set obs 25577
replace idenpa = 858 if _n==25577
replace region = "Treinta Y Tres" if idenpa==858 & _n==25577

* Venezuela (862)
replace region = "Anzoategui" if idenpa==862 & region=="Anzoátegui"
replace region = "Falcon" if idenpa==862 & region=="Falcón"
replace region = "Guarico" if idenpa==862 & region=="Guárico"
replace region = "Merida" if idenpa==862 & region=="Mérida"
replace region = "Tachira" if idenpa==862 & region=="Táchira"
replace region = "Bolivar" if idenpa==862 & region=="Bolívar"
set obs 26000
local i = 0
foreach x in Amazonas Delta_Amacuro Dependencias_Federales Nueva_Esparta{
	local i = `i' + 1
	local j = `i' + 25577
	replace idenpa = 862 if _n==`j'
	replace region = "`x'" if idenpa==862 & _n==`j'
}
replace region = "Delta Amacuro" if idenpa==862 & region=="Delta_Amacuro"
replace region = "Dependencias Federales" if idenpa==862 & region=="Dependencias_Federales"
replace region = "Nueva Esparta" if idenpa==862 & region=="Nueva_Esparta"
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
gen chief_earner_women = (s14==1) if sex==0

* v2: beneficiary of a state aid program
/*
	¿Esta Ud recibiendo ayuda del estado este mes?
		No	sabe	/	No	con	-5
		Sí	1
		No	2
	¿Ha recibido ayuda del estado en meses anteriores durante este año?
		No	sabe	/	No	con	-5
		Sí	1
		No	2
*/
recode s23_a s23_b (-5=.)
gen govern_transfers = (s23_a==1 | s23_b==1)
replace govern_transfers = . if s23_a==2 & s23_b==.
replace govern_transfers = . if s23_a==. & s23_b==2
replace govern_transfers = . if s23_a==. & s23_b==.

* v3: income allows to save
/*
	Les alcanza bien	1
	Les alcanza just	2
	No les alcanza,	3
	No les alcanza,	4
*/
recode s4 (-2=.) (-1=.)
gen save_money = (s4==1)
replace save_money = . if s4==.

* v4: not had enough food
/*
	Nunca	1
	Rara vez	2
	Algunas veces	3
	Seguido	4
*/
recode s2 (-2=.) (-1=.)
gen enough_food = (s2>=2 & s2<=4)
replace enough_food = . if s2==.

* v5: Most people can be trusted
/*
	Se puede confiar	1
	Uno nunca es lo	2
*/
recode p9stgbs (-2=.)
gen trustinpeople = (p9stgbs==1)
replace trustinpeople = . if p9stgbs==.

* v6: Has confidence in the government
/*
	Mucha	1
	Algo	2
	Poca	3
	Ninguna	4
*/
recode p13st_e (-2=.) (-1=.)
gen conf_govern = (p13st_e>=1 & p13st_e<=2) // too much confidence, some confidence
replace conf_govern = . if p13st_e==.

* v7: Has confidence in the police
/*
	Mucha	1
	Algo	2
	Poca	3
	Ninguna	4
*/
rename P13STGBS_B p13stgbs_b
recode p13stgbs_b (-2=.) (-1=.)
gen conf_police = (p13stgbs_b>=1 & p13stgbs_b<=2) // too much confidence, some confidence
replace conf_police = . if p13stgbs_b==.

* v8: Has confidence in the electoral institution
/*
	Mucha	1
	Algo	2
	Poca	3
	Ninguna	4
*/
recode p13st_h (-2=.) (-1=.)
gen conf_elections = (p13st_h>=1 & p13st_h<=2) // too much confidence, some confidence
replace conf_elections = . if p13st_h==.

* v9: Has confidence in the judiciary
/*
	Mucha	1
	Algo	2
	Poca	3
	Ninguna	4
*/
recode p13st_f (-2=.) (-1=.)
gen conf_justice = (p13st_f>=1 & p13st_f<=2) // too much confidence, some confidence
replace conf_justice = . if p13st_f==.

* v10: How often do you care that you may become the victim of a crime with violence (feels concerned at least occasionally)
/*
	Todo o casi todo	1
	Algunas veces	2
	Ocasionalmente	3
	Nunca	4
*/
recode p65st (-2=.) (-1=.)
gen insecure_neigh = (p65st>=1 & p65st<=3) // everytime, sometimes, occasionally
replace insecure_neigh = . if p65st==.

* v11: Share of population that was victim of a crime in neighborhood 
/*
	Ud.	1
	Algún	pariente	2
	Ambos	3
	No	4
*/
recode p64st (-2=.) (-1=.)
gen victim_crime = (p64st==1 | p64st==3)
replace victim_crime = . if p64st==.

* v12: freedom of speech
/*
	No contesta	-2
	Completamente ga	1
	Algo garantizada	2
	Poco garantizada	3
	Para nada garant	4
*/
recode p47st_h (-2=.) (-1=.)
gen free_speak = (p47st_h==1)
replace free_speak = . if p47st_h==.

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
gen source = "Latinobarometro 2020"

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

save "$proc_data\latinobarometro2020_subnational.dta", replace

erase "countries_codes.dta"