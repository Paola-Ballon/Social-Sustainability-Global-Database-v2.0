* ============================================== *
* Merging sources and ensamling of the SSGD v2.0
* Consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* ============================================== *

* ----------- *
* Indications *
* ----------- *

* 1. Press Ctrl + D to run this Stata do file

* directory macros
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data"
global final_data "${ssgd_v2_userpath}\SSGD v2.0\final_data"

cd "$proc_data"

* ---------------------------------------------------------------------------- *
*	 				ENSAMNLING THE SSGD V2.0 ON WIDE FORMAT					   *
* ---------------------------------------------------------------------------- *

* --------------- *
* Merging process *
* --------------- *

use "ssgd_gmd.dta", clear
merge 1:1 countrycode group using "ssgd_afrobarometer.dta", nogenerate update
merge 1:1 countrycode group using "ssgd_arabbarometer.dta", nogenerate update
merge 1:1 countrycode group using "ssgd_arabbarometer_extra.dta", nogenerate update
merge 1:1 countrycode group using "ssgd_asianbarometer.dta", nogenerate update
merge 1:1 countrycode group using "ssgd_latinobarometro.dta", nogenerate update
merge 1:1 countrycode group using "ssgd_afrobarometer_subnational.dta", nogenerate update
merge 1:1 countrycode group using "ssgd_arabbarometer_subnational.dta", nogenerate update
merge 1:1 countrycode group using "ssgd_arabbarometer_extra_subnational.dta", nogenerate update
merge 1:1 countrycode group using "ssgd_asianbarometer_subnational.dta", nogenerate update
merge 1:1 countrycode group using "ssgd_latinobarometro_subnational.dta", nogenerate update
forvalues t = 1/11{
	merge 1:1 countrycode group using "ssgd_wvs_part`t'.dta", nogenerate update
}
forvalues t = 1/2{
	merge 1:1 countrycode group using "ssgd_evs_part`t'.dta", nogenerate update
}
merge 1:1 countrycode group using "ssgd_findex.dta", nogenerate update
merge 1:1 countrycode group using "ssgd_acled.dta", nogenerate update
merge 1:1 countrycode group using "ssgd_emdat.dta", nogenerate update
merge 1:1 countrycode group using "ssgd_wjp.dta", nogenerate update
merge 1:1 countrycode group using "ssgd_wgi.dta", nogenerate update
merge 1:1 countrycode group using "ssgd_wdi.dta", nogenerate update
merge 1:1 countrycode group using "ssgd_civicus.dta", nogenerate update
forvalues t = 1/6{
	merge 1:1 countrycode group using "external`t'.dta", nogenerate update
}

* format corrections
format countrycode %5s
drop GMD_period_w2

* attaching countrynames and region
drop Region countryname
preserve
import excel using "${ssgd_v2_userpath}\SSGD v2.0\other\list_countries.xlsx", firstrow sheet("countries_codes") clear
rename Country countryname
rename Code countrycode
rename Region region
save "countries_codes.dta", replace
restore

merge m:1 countrycode using "countries_codes.dta", nogenerate
erase "countries_codes.dta"

order countryname countrycode region group

* --------- *
* Labelling *
* --------- *

* labels for variables

label var countryname "Country name"
label var countrycode "Country ISO code"
label var region "Region"
label var group "Group"
local t_sex = "% of male ppl"
local t_ageg1 = "% of ppl with 15-29 years"
local t_ageg2 = "% of ppl with 30-59 years"
local t_ageg3 = "% of ppl with 60+ years"
local t_youth = "% of ppl with 15-24 years"
local t_urban = "% of ppl living in urban areas"
local t_si_labfor = "labor force participation rate"
local t_si_unerat = "unemployment rate"
local t_si_uneratb = "unemployment, total (% of total labor force) (modeled ILO estimate)"
local t_si_uneratc = "unemployment, total (% of total labor force) (national estimate)"
local t_si_sel = "% of people that work and are self-employed"
local t_si_con = "% of people that work and have a contract"
local t_si_wat = "% of hhs that have access to water"
local t_si_watb = "people using at least basic drinking water services (% of population)"
local t_si_watc = "people using safely managed drinking water services (% of population)"
local t_si_san = "% of hhs that have access to sanitation"
local t_si_sanb = "people using at least basic sanitation services (% of population)"
local t_si_sanc = "people using safely managed sanitation services (% of population)"
local t_si_ele = "% of hhs that have access to electricity"
local t_si_eleb = "access to electricity (% of population)"
local t_si_int = "% of hhs that have access to internet"
local t_si_prienr = "% of people that are attending primary school"
local t_si_pricom = "% of people that completed primary education"
local t_si_seccoma = "educational attainment, at least completed lower secondary, population 25+, total (%) (cummulative)"
local t_si_seccomb = "educational attainment, at least completed post-secondary, population 25+, total (%) (cummulative)"
local t_si_seccomc = "educational attainment, at least completed upper secondary, population 25+, total (%) (cummulative)"
local t_si_secenr = "% of people that are attending secondary school"
local t_si_secenrb = "school enrollment, secondary (% net)"
local t_si_hea = "% of people with health insurance"
local t_si_socsec = "% of people that have social security"
local t_si_femsec = "% of women with 25 years or older that finished secondary school"
local t_re_com = "% of hhs that own a computer"
local t_re_cel = "% of hhs that own a cellphone"
local t_re_tel = "% of hhs that have a TV"
local t_re_rad = "% of hhs that have a radio"
local t_re_was = "% of hhs that have a washing machine"
local t_re_sew = "% of hhs that have a sewing machine"
local t_re_mot = "% of hhs that have a motorcycle"
local t_re_fri = "% of hhs that have a fridge"
local t_re_car = "% of hhs that have a car"
local t_re_ownlan = "% of hhs that own their land"
local t_re_assets = "average % of assets in the household"
local t_re_mortha = "% of hhs that have more than one person working for pay"
local t_re_rem = "% of ppl that receives remittances"
local t_sc_frespe = "% of ppl that agrees they are free to express what they think"
local t_sc_vot = "% of ppl that voted in the last national elections"
local t_sc_attdem = "% of ppl that has ever attended a demonstration or protest march"
local t_si_intuse = "% of ppl that uses the Internet"
local t_re_enofoo = "% of ppl that has gone without enough food to eat in the past year"
local t_re_enofoob = "prevalence of moderate or severe food insecurity in the population (%)"
local t_re_enofooc = "prevalence of severe food insecurity in the population (%)"
local t_sc_volass = "% of ppl that participates in voluntary associations , organizations or community groups"
local t_sc_conpol = "% of ppl that says they have confidence in the Police"
local t_sc_conjus = "% of ppl that says they have confidence in the Justice System"
local t_sc_conele = "% of ppl that says they have confidence in the elections"
local t_sc_congov = "% of ppl that says they have confidence in the Government"
local t_sc_frejoi = "% of ppl that agrees they are free to join any organization they like without fear"
local t_sc_trupeo = "% of ppl that says that most people can be trusted"
local t_sc_homnei = "% of ppl that would not like to have homosexuals as neighbors"
local t_sc_insnei = "% of ppl that feels insecure living in their area"
local t_sc_unshom = "% of ppl that has often or sometimes felt unsafe from crime in their own homes in the past year"
local t_si_menbet = "% of ppl that agrees or strongly agrees men make better political leaders than women"
local t_re_savmon = "% of ppl that saves some money"
local t_re_savmonb = "saved any money (% age 15+)"
local t_sc_actmem = "% of ppl that are active members of organizations"
local t_sc_solpro = "% of ppl that got together with others to try to resolve local problems"
local t_si_chiear = "% of women that are the chief earner in their hhs"
local t_re_govtra = "% of ppl that receive government transfers (individual is beneficiary of a state aid program)"
local t_re_govtrab = "received government transfer or pension (% age 15+)"
local t_sc_viccri = "% of ppl that was victim of a crime in the past year"
local t_sc_racbeh = "% of ppl that says racist behavior is very or quite frequent in their neighborhood"
local t_si_prowom = "% of ppl that agrees it is a problem if women earn more than their husbands"
local t_si_menjob = "% of ppl that agrees that when jobs are scarce, men should have more right to a job than women"
local t_si_infint = "% of ppl that uses the internet as a source of information"
local t_si_ownban = "% of ppl that owns a bank account"
local t_sc_fata = "fatalities due to violence"
local t_sc_numeve = "number of violent events"
local t_re_totaff = "% of ppl affected by climate change index (0-100, low to high)"
local t_pl_riggua = "life and security are effectively guaranteed index (0-100, low to high)"
local t_pl_powlim = "government powers are limited by the judiciary index (0-100, low to high)"
local t_pl_nodis = "equal treatment and absence of discrimination index (0-100, low to high)"
local t_pl_govreg = "government regulations are applied and enforced without improper influence index (0-100, low to high)"
local t_pl_accjus = "people can access and afford civil justice index (0-100, low to high)"
local t_pl_rullaw = "rule of law index (0-100, low to high)"
local t_pl_goveff = "government effectiveness index (0-100, low to high)"
local t_pl_concor = "control of corruption index (0-100, low to high)"
local t_si_beawif = "% of women who believe a husband is justified in beating his wife"
local t_sc_hom = "intentional homicides (per 100000 people)"
local t_si_prosea = "% of women in the parliament"
local t_pl_civspa = "civic space score (0-100, low to high)"
local t_ex_disability1 = "% of people who experienced discrimination based on disability"
local t_ex_disability2 = "% of people who have at least one household member living with a disability"

global vars "sex ageg1 ageg2 ageg3 youth urban si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha re_rem sc_frespe sc_frejoi sc_vot sc_attdem si_intuse re_enofoo sc_volass sc_conpol sc_conele sc_congov sc_conjus sc_trupeo sc_homnei sc_insnei sc_unshom si_menbet re_savmon sc_actmem sc_solpro si_chiear re_govtra sc_viccri sc_racbeh si_prowom si_menjob si_infint si_ownban sc_fata sc_numeve re_totaff pl_riggua pl_powlim pl_nodis pl_govreg pl_accjus pl_rullaw pl_goveff pl_concor si_beawif sc_hom si_prosea pl_civspa ex_disability1 ex_disability2 si_uneratb si_uneratc si_watb si_watc si_sanb si_sanc si_eleb si_seccoma si_seccomb si_seccomc si_secenrb re_govtrab re_savmonb re_enofoob re_enofooc"

foreach x in $vars{
	forvalues t = 1/2{
		* indicator
		label var `x'_w`t' "`t_`x'', wave `t'"
		* source
		label var sou_`x'_w`t' "Source: `t_`x'', wave `t'"
		* period
		label var per_`x'_w`t' "Period: `t_`x'', wave `t'"
	}
}

* labels for controls
local t_ex_ferrat = "fertility rate, total (births per woman)"
local t_ex_gdpppc = "gdp per capita, PPP (constant 2017 international $)"
local t_ex_growthgdppc = "gdp per capita growth (annual %)"
local t_ex_mulpov = "multidimensional poverty headcount ratio (% of total population)"
local t_ex_humcap = "human capital index (HCI) (scale 0-1)"
local t_ex_povnat = "poverty headcount ratio at national poverty lines (% of population)"
local t_ex_gini = "gini index (World Bank estimate)"
local t_ex_urbpop = "urban population (% of total population)"
local t_ex_shapro = "shared prosperity"
local t_ex_loggdp = "log of GDP per capita, PPP (constant 2017 international $)"
local t_ex_gaphci = "inequality of opportunities, using HCI"
local t_ex_shapp = "shared prosperity premium"
local t_ex_avega2 = "inequality of opportunities"
local t_ex_hdi = "human development index"
local t_ex_wbl_index = "women, business and the law (wbl) score"
local t_ex_mobility = "wbl: mobility score"
local t_ex_workplace = "wbl: workplace score"
local t_ex_pay = "wbl: pay score"
local t_ex_marriage = "wbl: marriage score"
local t_ex_parenthood = "wbl: parenthood score"
local t_ex_entrepreneurship = "wbl: entrepreneurship score"
local t_ex_assets = "wbl: assets score"
local t_ex_pension = "wbl: pension score"
local t_ex_demind = "democracy index"
local t_ex_demind_elec = "democracy index: electoral process and pluralism score"
local t_ex_demind_func = "democracy index: functioning of government score"
local t_ex_demind_polpar = "democracy index: political participation score"
local t_ex_demind_polcul = "democracy index: political culture"
local t_ex_demind_civil = "democracy index: civil liberties"
local t_ex_treeloss = "tree cover loss"
local t_ex_forestarea = "forest area (% of land area)"
local t_ex_energyint = "energy intensity level of primary energy (MJ/$2017 PPP GDP)"
local t_ex_co2emissions = "co2 emissions (metric tons per capita)"
local t_ex_coolingdays = "cooling degree days"
local t_ex_heatingdays = "heating degree days"
local t_ex_waterstress = "level of water stress: freshwater withdrawal as a proportion of available freshwater resources"
local t_ex_legalrights = "strength of legal rights index (0=weak to 12=strong)"
local t_ex_econsocrights = "economic and social rights performance score"
local t_ex_voiceest = "voice and accountability estimate"
local t_ex_eqocrimi = "eqosogi: criminalization and sogi score"
local t_ex_eqoinclu = "eqosogi: access to inclusive education score"
local t_ex_eqolabor = "eqosogi: access to the labor market score"
local t_ex_eqopubli = "eqosogi: access to public services and social protection score"
local t_ex_eqocivil = "eqosogi: civil and political inclusion score"
local t_ex_eqoprote = "eqosogi: protection from hate crimes score"
local t_ex_researchexp = "research and development expenditure (% of GDP)"
local t_ex_scientificart = "scientific and technical journal articles"
local t_ex_patentapp = "patent applications, residents"
local t_ex_indinternet = "individuals using the Internet (% of population)"
local t_ex_polstab = "political stability and absence of violence/terrorism: estimate"
local t_ex_regulqua = "regulatory quality index"
local t_ex_schoolgpi = "school enrollment, primary and secondary (gross), gender parity index (GPI)"
local t_ex_ratiofem = "ratio of female to male labor force participation rate (%) (modeled ILO estimate)"
local t_ex_netmigration = "net migration"
local t_ex_unmetcontr = "unmet need for contraception (% of married women ages 15-49)"

global controls "ex_ferrat ex_gdpppc ex_growthgdppc ex_mulpov ex_humcap ex_povnat ex_gini ex_urbpop ex_shapro ex_loggdp ex_gaphci ex_shapp ex_avega2 ex_hdi ex_wbl_index ex_mobility ex_workplace ex_pay ex_marriage ex_parenthood ex_entrepreneurship ex_assets ex_pension ex_demind ex_demind_elec ex_demind_func ex_demind_polpar ex_demind_polcul ex_demind_civil ex_treeloss ex_forestarea ex_energyint ex_co2emissions ex_coolingdays ex_heatingdays ex_waterstress ex_legalrights ex_econsocrights ex_voiceest ex_eqocrimi ex_eqoinclu ex_eqolabor ex_eqopubli ex_eqocivil ex_eqoprote ex_researchexp ex_scientificart ex_patentapp ex_indinternet ex_polstab ex_regulqua ex_schoolgpi ex_ratiofem ex_netmigration ex_unmetcontr"

foreach x in $controls{
	forvalues t = 1/2{
		* control
		label var `x'_w`t' "`t_`x'', wave `t'"
		* source
		label var sou_`x'_w`t' "Source: `t_`x'', wave `t'"
		* period
		label var per_`x'_w`t' "Period: `t_`x'', wave `t'"
	}
}

drop if countryname==""

* corrections
global selvars "youth sex ageg1 ageg2 ageg3 urban"

foreach x in $selvars{
	rename `x'_w1 ex_`x'_w1
	rename `x'_w2 ex_`x'_w2
	rename sou_`x'_w1 sou_ex_`x'_w1
	rename sou_`x'_w2 sou_ex_`x'_w2
	rename per_`x'_w1 per_ex_`x'_w1
	rename per_`x'_w2 per_ex_`x'_w2
}

* standardize rates (from 0-1 to 0-100)
global selvars "ex_ageg1 ex_ageg2 ex_ageg3 ex_disability1 ex_disability2 ex_gaphci ex_hdi ex_humcap ex_sex ex_youth pl_accjus pl_concor pl_goveff pl_govreg pl_nodis pl_powlim pl_riggua pl_rullaw re_assets re_car re_cel re_com re_enofoo re_fri re_govtra re_mortha re_mot re_ownlan re_rad re_rem re_savmon re_sew re_tel re_totaff re_was sc_actmem sc_attdem sc_conele sc_congov sc_conjus sc_conpol sc_fata sc_frejoi sc_frespe sc_hom sc_homnei sc_insnei sc_racbeh sc_solpro sc_trupeo sc_unshom sc_viccri sc_volass sc_vot si_beawif si_chiear si_con si_ele si_femsec si_hea si_infint si_int si_intuse si_labfor si_menbet si_menjob si_ownban si_pricom si_prienr si_prosea si_prowom si_san si_secenr si_sel si_socsec si_unerat si_wat"

foreach x in $selvars{
	replace `x'_w1 = `x'_w1*100
	replace `x'_w2 = `x'_w2*100
}

* deleted vars
foreach x in si_infint{
	drop `x'_w* sou_`x'_w* per_`x'_w*
}

global vars "ex_sex ex_ageg1 ex_ageg2 ex_ageg3 ex_youth ex_urban si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha re_rem sc_frespe sc_frejoi sc_vot sc_attdem si_intuse re_enofoo sc_volass sc_conpol sc_conele sc_congov sc_conjus sc_trupeo sc_homnei sc_insnei sc_unshom si_menbet re_savmon sc_actmem sc_solpro si_chiear re_govtra sc_viccri sc_racbeh si_prowom si_menjob si_ownban sc_fata sc_numeve re_totaff pl_riggua pl_powlim pl_nodis pl_govreg pl_accjus pl_rullaw pl_goveff pl_concor si_beawif sc_hom si_prosea pl_civspa ex_disability1 ex_disability2"

* corrections
foreach x in $vars $controls{
	forvalues t = 1/2{
		replace sou_`x'_w`t' = "" if `x'_w`t'==.
		replace per_`x'_w`t' = "" if `x'_w`t'==.
	}
}

foreach x in prosea prowom menjob chiear menbet femsec beawif{
	forvalues t = 1/2{
		rename si_`x'_w`t' pl_`x'_w`t'
		rename sou_si_`x'_w`t' sou_pl_`x'_w`t'
		rename per_si_`x'_w`t' per_pl_`x'_w`t'
		
	}
}

* ----------------- *
* Final corrections *
* ----------------- *

* The "voice and accountability estimate" indicator now belongs to the PL pillar/dimension
* The "economic and social rights performance score" indicator now belongs to the PL pillar/dimension
* The "democracy index" and all its components now belongs to the PL pillar/dimension
foreach x in voiceest econsocrights demind demind_elec demind_func demind_polpar demind_polcul demind_civil{
	forvalues t = 1/2{
		rename ex_`x'_w`t' pl_`x'_w`t'
		rename sou_ex_`x'_w`t' sou_pl_`x'_w`t'
		rename per_ex_`x'_w`t' per_pl_`x'_w`t'
	}
}

* WBL related indicators are now included within the SI pillar/dimension
* The "strength of legal rights index (0=weak to 12=strong)" indicator now belongs to the SI pillar/dimension
foreach x in wbl_index mobility workplace pay marriage parenthood entrepreneurship assets pension legalrights{
	forvalues t = 1/2{
		rename ex_`x'_w`t' si_`x'_w`t'
		rename sou_ex_`x'_w`t' sou_si_`x'_w`t'
		rename per_ex_`x'_w`t' per_si_`x'_w`t'
	}
}

* Also, we remove the "% of ppl affected by climate change index (0-100, low to high)" indicator from the SSGD v2.0 database
drop re_totaff* per_re_totaff* sou_re_totaff* ex_scientificart* per_ex_scientificart* sou_ex_scientificart*

* We also remove indicators (version b) that initially come from FINDEX and WDI since they do not match the original definitions
foreach x in re_govtra re_savmon si_unerat si_wat si_san si_ele si_seccom si_secenr re_enofoo{
	drop `x'b_w1 `x'b_w2 per_`x'b_w1 per_`x'b_w2 sou_`x'b_w1 sou_`x'b_w2
}
foreach x in si_unerat si_wat si_san si_seccom re_enofoo{
	drop `x'c_w1 `x'c_w2 per_`x'c_w1 per_`x'c_w2 sou_`x'c_w1 sou_`x'c_w2
}
drop si_seccoma_w1 sou_si_seccoma_w1 per_si_seccoma_w1 si_seccoma_w2 sou_si_seccoma_w2 per_si_seccoma_w2
* Drop urban rate variable from GMD, now it comes from WDI
drop ex_urban_w1 ex_urban_w2 sou_ex_urban_w1 sou_ex_urban_w2 per_ex_urban_w1 per_ex_urban_w2

* No data on categories related to disability
drop if group=="pwd" | group=="nwithoutd"

* External indicators only provide data at the national level
replace ex_disability1_w1 = . if group!="nat"
replace ex_disability1_w2 = . if group!="nat"
replace ex_disability2_w1 = . if group!="nat"
replace ex_disability2_w2 = . if group!="nat"

save "$final_data\ssgd_v2_wide.dta", replace

* ---------------------------------------------------------------------------- *
*	 				ENSAMNLING THE SSGD V2.0 ON LONG FORMAT					   *
* ---------------------------------------------------------------------------- *

* First reshape
* generate identificator
gen id = _n
mi unset, asis

global vars "si_labfor_ si_unerat_ si_sel_ si_con_ si_ownban_ si_wat_ si_san_ si_ele_ si_int_ si_intuse_ si_prienr_ si_pricom_ si_secenr_ si_hea_ si_socsec_ si_legalrights_ re_com_ re_cel_ re_tel_ re_rad_ re_was_ re_sew_ re_mot_ re_fri_ re_car_ re_ownlan_ re_assets_ re_govtra_ re_rem_ re_savmon_ re_enofoo_ re_mortha_ sc_trupeo_ sc_homnei_ sc_congov_ sc_conpol_ sc_conele_ sc_conjus_ sc_insnei_ sc_unshom_ sc_viccri_ sc_racbeh_ sc_vot_ sc_attdem_ sc_frespe_ sc_frejoi_ sc_solpro_ sc_actmem_ sc_volass_ sc_fata_ sc_numeve_ sc_hom_ pl_prosea_ pl_prowom_ pl_menjob_ pl_chiear_ pl_menbet_ pl_femsec_ pl_beawif_ pl_rullaw_ pl_goveff_ pl_concor_ pl_riggua_ pl_powlim_ pl_nodis_ pl_govreg_ pl_accjus_ pl_civspa_ si_wbl_index_ si_mobility_ si_workplace_ si_pay_ si_marriage_ si_parenthood_ si_entrepreneurship_ si_assets_ si_pension_ pl_voiceest_ pl_econsocrights_ pl_demind_ pl_demind_elec_ pl_demind_func_ pl_demind_polpar_ pl_demind_polcul_ pl_demind_civil_"
global per_vars "per_si_labfor_ per_si_unerat_ per_si_sel_ per_si_con_ per_si_ownban_ per_si_wat_ per_si_san_ per_si_ele_ per_si_int_ per_si_intuse_ per_si_prienr_ per_si_pricom_ per_si_secenr_ per_si_hea_ per_si_socsec_ per_si_legalrights_ per_re_com_ per_re_cel_ per_re_tel_ per_re_rad_ per_re_was_ per_re_sew_ per_re_mot_ per_re_fri_ per_re_car_ per_re_ownlan_ per_re_assets_ per_re_govtra_ per_re_rem_ per_re_savmon_ per_re_enofoo_ per_re_mortha_ per_sc_trupeo_ per_sc_homnei_ per_sc_congov_ per_sc_conpol_ per_sc_conele_ per_sc_conjus_ per_sc_insnei_ per_sc_unshom_ per_sc_viccri_ per_sc_racbeh_ per_sc_vot_ per_sc_attdem_ per_sc_frespe_ per_sc_frejoi_ per_sc_solpro_ per_sc_actmem_ per_sc_volass_ per_sc_fata_ per_sc_numeve_ per_sc_hom_ per_pl_prosea_ per_pl_prowom_ per_pl_menjob_ per_pl_chiear_ per_pl_menbet_ per_pl_femsec_ per_pl_beawif_ per_pl_rullaw_ per_pl_goveff_ per_pl_concor_ per_pl_riggua_ per_pl_powlim_ per_pl_nodis_ per_pl_govreg_ per_pl_accjus_ per_pl_civspa_ per_si_wbl_index_ per_si_mobility_ per_si_workplace_ per_si_pay_ per_si_marriage_ per_si_parenthood_ per_si_entrepreneurship_ per_si_assets_ per_si_pension_ per_pl_voiceest_ per_pl_econsocrights_ per_pl_demind_ per_pl_demind_elec_ per_pl_demind_func_ per_pl_demind_polpar_ per_pl_demind_polcul_ per_pl_demind_civil_"
global sou_vars "sou_si_labfor_ sou_si_unerat_ sou_si_sel_ sou_si_con_ sou_si_ownban_ sou_si_wat_ sou_si_san_ sou_si_ele_ sou_si_int_ sou_si_intuse_ sou_si_prienr_ sou_si_pricom_ sou_si_secenr_ sou_si_hea_ sou_si_socsec_ sou_si_legalrights_ sou_re_com_ sou_re_cel_ sou_re_tel_ sou_re_rad_ sou_re_was_ sou_re_sew_ sou_re_mot_ sou_re_fri_ sou_re_car_ sou_re_ownlan_ sou_re_assets_ sou_re_govtra_ sou_re_rem_ sou_re_savmon_ sou_re_enofoo_ sou_re_mortha_ sou_sc_trupeo_ sou_sc_homnei_ sou_sc_congov_ sou_sc_conpol_ sou_sc_conele_ sou_sc_conjus_ sou_sc_insnei_ sou_sc_unshom_ sou_sc_viccri_ sou_sc_racbeh_ sou_sc_vot_ sou_sc_attdem_ sou_sc_frespe_ sou_sc_frejoi_ sou_sc_solpro_ sou_sc_actmem_ sou_sc_volass_ sou_sc_fata_ sou_sc_numeve_ sou_sc_hom_ sou_pl_prosea_ sou_pl_prowom_ sou_pl_menjob_ sou_pl_chiear_ sou_pl_menbet_ sou_pl_femsec_ sou_pl_beawif_ sou_pl_rullaw_ sou_pl_goveff_ sou_pl_concor_ sou_pl_riggua_ sou_pl_powlim_ sou_pl_nodis_ sou_pl_govreg_ sou_pl_accjus_ sou_pl_civspa_ sou_si_wbl_index_ sou_si_mobility_ sou_si_workplace_ sou_si_pay_ sou_si_marriage_ sou_si_parenthood_ sou_si_entrepreneurship_ sou_si_assets_ sou_si_pension_ sou_pl_voiceest_ sou_pl_econsocrights_ sou_pl_demind_ sou_pl_demind_elec_ sou_pl_demind_func_ sou_pl_demind_polpar_ sou_pl_demind_polcul_ sou_pl_demind_civil_"
global external "ex_sex_ ex_ageg1_ ex_ageg2_ ex_ageg3_ ex_youth_ ex_disability1_ ex_disability2_ ex_ferrat_ ex_gdpppc_ ex_mulpov_ ex_humcap_ ex_povnat_ ex_gini_ ex_urbpop_ ex_shapro_ ex_loggdp_ ex_gaphci_ ex_shapp_ ex_avega2_ ex_growthgdppc_ ex_hdi_ ex_treeloss_ ex_forestarea_ ex_energyint_ ex_co2emissions_ ex_coolingdays_ ex_heatingdays_ ex_waterstress_ ex_researchexp_ ex_patentapp_ ex_indinternet_ ex_polstab_ ex_regulqua_ ex_schoolgpi_ ex_ratiofem_ ex_netmigration_ ex_unmetcontr_ ex_eqocrimi_ ex_eqoinclu_ ex_eqolabor_ ex_eqopubli_ ex_eqocivil_ ex_eqoprote_"
global per_external "per_ex_sex_ per_ex_ageg1_ per_ex_ageg2_ per_ex_ageg3_ per_ex_youth_ per_ex_disability1_ per_ex_disability2_ per_ex_ferrat_ per_ex_gdpppc_ per_ex_mulpov_ per_ex_humcap_ per_ex_povnat_ per_ex_gini_ per_ex_urbpop_ per_ex_shapro_ per_ex_loggdp_ per_ex_gaphci_ per_ex_shapp_ per_ex_avega2_ per_ex_growthgdppc_ per_ex_hdi_ per_ex_treeloss_ per_ex_forestarea_ per_ex_energyint_ per_ex_co2emissions_ per_ex_coolingdays_ per_ex_heatingdays_ per_ex_waterstress_ per_ex_researchexp_ per_ex_patentapp_ per_ex_indinternet_ per_ex_polstab_ per_ex_regulqua_ per_ex_schoolgpi_ per_ex_ratiofem_ per_ex_netmigration_ per_ex_unmetcontr_ per_ex_eqocrimi_ per_ex_eqoinclu_ per_ex_eqolabor_ per_ex_eqopubli_ per_ex_eqocivil_ per_ex_eqoprote_"
global sou_external "sou_ex_sex_ sou_ex_ageg1_ sou_ex_ageg2_ sou_ex_ageg3_ sou_ex_youth_ sou_ex_disability1_ sou_ex_disability2_ sou_ex_ferrat_ sou_ex_gdpppc_ sou_ex_mulpov_ sou_ex_humcap_ sou_ex_povnat_ sou_ex_gini_ sou_ex_urbpop_ sou_ex_shapro_ sou_ex_loggdp_ sou_ex_gaphci_ sou_ex_shapp_ sou_ex_avega2_ sou_ex_growthgdppc_ sou_ex_hdi_ sou_ex_treeloss_ sou_ex_forestarea_ sou_ex_energyint_ sou_ex_co2emissions_ sou_ex_coolingdays_ sou_ex_heatingdays_ sou_ex_waterstress_ sou_ex_researchexp_ sou_ex_patentapp_ sou_ex_indinternet_ sou_ex_polstab_ sou_ex_regulqua_ sou_ex_schoolgpi_ sou_ex_ratiofem_ sou_ex_netmigration_ sou_ex_unmetcontr_ sou_ex_eqocrimi_ sou_ex_eqoinclu_ sou_ex_eqolabor_ sou_ex_eqopubli_ sou_ex_eqocivil_ sou_ex_eqoprote_"

reshape long $vars $external $per_vars $sou_vars $per_external $sou_external, i(id) j(wave) string

gen wave2 = .
replace wave2 = 1 if wave=="w1"
replace wave2 = 2 if wave=="w2"
drop wave id
rename wave2 wave

* Second reshape
gen id = _n

foreach x in $vars $external{
	rename `x' value_`x'
	rename per_`x' period_`x'
	rename sou_`x' source_`x'
}
reshape long value_ period_ source_, i(id) j(variable) string
drop id
rename value_ value
rename source_ source
rename period_ period

keep variable countryname countrycode region group wave value source period
keep if value!=.

rename variable x1
gen x2 = substr(x1,1,3)

replace x2 = "External Variables" if x2=="ex_"
replace x2 = "Process Legitimacy" if x2=="pl_"
replace x2 = "Resilience" if x2=="re_"
replace x2 = "Social Cohesion" if x2=="sc_"
replace x2 = "Social Inclusion" if x2=="si_"
rename x2 dimension

gen area = ""
replace area = "Age group (2 levels)" if group=="15_24" | group=="24plus"
replace area = "Age group (3 levels)" if group=="15_29" | group=="30_59" | group=="60plus"
replace area = "Ethnicity" if group=="ethmaj" | group=="ethmin"
replace area = "Gender" if group=="fem" | group=="male"
replace area = "National" if group=="nat"
replace area = "Religion" if group=="relmaj" | group=="relmin"
replace area = "Location" if group=="rural" | group=="urban"
replace area = "Subnational" if area==""

preserve
keep if area=="Subnational"
gen x = 1
collapse (mean) x, by(countrycode group)
drop x
sort countrycode group
bys countrycode: gen t1 = _n
save "temp1.dta", replace
restore

merge m:1 countrycode group using "temp1.dta", nogenerate
erase "temp1.dta"

gen x = "ADM1_"
egen t2 = concat(x countrycode t1)

clonevar group2 = group // temporary variable
replace group2 = t2 if t1!=.

egen variable = concat(x1 group2)
drop t1 t2 x group2

tostring wave, replace

replace group = "Age group 15-24" if group=="15_24"
replace group = "Age group 15-29" if group=="15_29"
replace group = "Ages 24+" if group=="24plus"
replace group = "Age group 30-59" if group=="30_59"
replace group = "Ages 60+" if group=="60plus"
replace group = "Ethnicity, main" if group=="ethmaj"
replace group = "Ethnicity, minorities" if group=="ethmin"
replace group = "Female" if group=="fem"
replace group = "Male" if group=="male"
replace group = "National" if group=="nat"
replace group = "Religion, main" if group=="relmaj"
replace group = "Religion, minorities" if group=="relmin"
replace group = "Rural" if group=="rural"
replace group = "Urban" if group=="urban"
rename group category

replace x1 = substr(x1, 1, length(x1)-1)
rename x1 short

** Attaching metadata for indicators (indicator name, description, range, scale, etc)
preserve
import excel using "${ssgd_v2_userpath}\SSGD v2.0\support files\SSGD indicators metadata.xlsx", firstrow clear
save "temp.dta", replace
restore

merge m:1 short using "temp.dta"
drop if _merge==2
drop _merge
erase "temp.dta"

** Attaching data on income groups and FCS condition
preserve
import excel using "${ssgd_v2_userpath}\SSGD v2.0\support files\WBG classifications income groups and FCS.xlsx", firstrow clear
drop country
save "temp.dta", replace
restore

merge m:1 countrycode using "temp.dta"
drop if _merge==2
drop _merge
erase "temp.dta"

gen incomegroup = ""
forvalues t = 2015(1)2022{
	replace incomegroup = income`t' if period=="`t'"
}
replace incomegroup = income2018 if period=="2017-2018"
replace incomegroup = "Undefined" if incomegroup==""
replace incomegroup = "High income" if incomegroup=="H"
replace incomegroup = "Upper middle income" if incomegroup=="UM"
replace incomegroup = "Lower middle income" if incomegroup=="LM"
replace incomegroup = "Low income" if incomegroup=="L"
drop income2015-income2023

gen fragile = ""
forvalues t = 2015(1)2022{
	replace fragile = fcs`t' if period=="`t'"
}
replace fragile = fcs2018 if period=="2017-2018"
replace fragile = "No" if fragile==""
drop fcs*

save "temporary_data.dta", replace

** Attaching geodata to identify countries ADM0 codes and subnational ADM1 codes

* 1st step: attaching ADM0 and ADM1 codes for entries with subnational data
use "temporary_data.dta", clear
keep if area=="Subnational"

* Corrections in country names and subnational territories' names
replace category = "M'Sila" if category=="M'sila" & countryname=="Algeria"
replace category = "Kgalagadi" if category=="Kgaladi" & countryname=="Botswana"
replace category = "Norte De Santander" if category=="Norte de Santander" & countryname=="Colombia"
replace countryname = "Côte d'Ivoire" if countryname=="Cote D Ivoire"
replace countryname = "Arab Republic of Egypt" if countryname=="Egypt"
replace countryname = "Swaziland" if countryname=="Eswatini"
replace countryname = "The Gambia" if countryname=="Gambia"
replace category = "Gracias A Dios" if category=="Gracias a Dios" & countryname=="Honduras"
replace countryname = "West Bank and Gaza" if countryname=="Palestine"
replace countryname = "São Tomé and Príncipe" if countryname=="Sao Tome and Principe"
replace countryname = "Republic of Korea" if countryname=="South Korea"
replace countryname = "R. B. de Venezuela" if countryname=="Venezuela"
replace countryname = "Republic of Yemen" if countryname=="Yemen"

preserve
import excel using "${ssgd_v2_userpath}\SSGD v2.0\support files\WBG approved ADM1 administrative boundaries.xlsx", firstrow clear
drop if ADM1_NAME=="Administrative unit not available" & ADM0_NAME!="Mauritius"
drop if ADM1_NAME=="Name Unknown" & ADM0_NAME!="Honduras"
keep ADM0_NAME ADM1_NAME ADM0_CODE ADM1_CODE
rename ADM0_NAME countryname
rename ADM1_NAME category
rename ADM1_CODE adm1_code
rename ADM0_CODE adm0_code
save "temp.dta", replace
restore

merge m:1 countryname category using "temp.dta"
drop if _merge==2
drop _merge
erase "temp.dta"

save "t1.dta", replace

* 2nd step: attaching ADM0 codes for entries without subnational data
use "temporary_data.dta", clear
keep if area!="Subnational"

* Corrections in country names
replace countryname = "American Samoa (U.S.)" if countryname=="American Samoa"
replace countryname = "Anguilla (U.K.)" if countryname=="Anguilla"
replace countryname = "Aruba (Neth.)" if countryname=="Aruba"
replace countryname = "Bermuda (U.K.)" if countryname=="Bermuda"
replace countryname = "British Virgin Islands (U.K.)" if countryname=="British Virgin Islands"
replace countryname = "Cayman Islands (U.K.)" if countryname=="Cayman Islands"
replace countryname = "Democratic Republic of Congo" if countryname=="Congo, Dem. Rep."
replace countryname = "Congo" if countryname=="Congo, Rep."
replace countryname = "Côte d'Ivoire" if countryname=="Cote D Ivoire"
replace countryname = "Curaçao (Neth.)" if countryname=="Curacao"
replace countryname = "Arab Republic of Egypt" if countryname=="Egypt"
replace countryname = "Swaziland" if countryname=="Eswatini"
replace countryname = "Faroe Islands (Den.)" if countryname=="Faroe Islands"
*replace countryname = "" if countryname=="French Guiana"
replace countryname = "French Polynesia (Fr.)" if countryname=="French Polynesia"
replace countryname = "The Gambia" if countryname=="Gambia"
replace countryname = "Gibraltar (U.K.)" if countryname=="Gibraltar"
replace countryname = "Greenland (Den.)" if countryname=="Greenland"
*replace countryname = "" if countryname=="Guadeloupe"
replace countryname = "Guam (U.S.)" if countryname=="Guam"
replace countryname = "Guinea-Bissau" if countryname=="Guinea Bissau"
replace countryname = "Hong Kong, SAR" if countryname=="Hong Kong SAR"
replace countryname = "Islamic Republic of Iran" if countryname=="Iran"
replace countryname = "Isle of Man (U.K.)" if countryname=="Isle of Man"
replace countryname = "D. P. R. of Korea" if countryname=="Korea"
replace countryname = "Lao People's Democratic Republic" if countryname=="Lao"
replace countryname = "Luxembourg" if countryname=="Luxemburg"
replace countryname = "Macau, SAR" if countryname=="Macau Sar"
*replace countryname = "" if countryname=="Martinique"
*replace countryname = "" if countryname=="Mayotte"
replace countryname = "Federated States of Micronesia" if countryname=="Micronesia"
replace countryname = "New Caledonia (Fr.)" if countryname=="New Caledonia"
replace countryname = "FYR of Macedonia" if countryname=="North Macedonia"
replace countryname = "Northern Mariana Islands (U.S.)" if countryname=="Northern Mariana Islands"
replace countryname = "West Bank and Gaza" if countryname=="Palestine"
replace countryname = "Puerto Rico (U.S.)" if countryname=="Puerto Rico"
*replace countryname = "" if countryname=="Reunion"
replace countryname = "Russian Federation" if countryname=="Russia"
replace countryname = "São Tomé and Príncipe" if countryname=="Sao Tome and Principe"
replace countryname = "Sint Maarten (Neth.)" if countryname=="Sint Maarten"
replace countryname = "Republic of Korea" if countryname=="South Korea"
replace countryname = "Saint Kitts and Nevis" if countryname=="St. Kitts and Nevis"
replace countryname = "Saint-Martin (Fr.)" if countryname=="St. Martin"
replace countryname = "Saint Vincent and the Grenadines" if countryname=="St. Vincent and the Grenadines"
replace countryname = "Taiwan" if countryname=="Taiwan ROC"
replace countryname = "Timor-Leste" if countryname=="Timor Leste"
replace countryname = "Turks and Caicos Islands (U.K.)" if countryname=="Turks and Caicos Islands"
replace countryname = "R. B. de Venezuela" if countryname=="Venezuela"
replace countryname = "United States Virgin Islands (U.S.)" if countryname=="Virgin Islands"
replace countryname = "Republic of Yemen" if countryname=="Yemen"

preserve
import excel using "${ssgd_v2_userpath}\SSGD v2.0\support files\WBG approved ADM1 administrative boundaries.xlsx", firstrow clear
collapse (mean) OBJECTID, by(ADM0_NAME ADM0_CODE)
drop OBJECTID
rename ADM0_NAME countryname
rename ADM0_CODE adm0_code
save "temp.dta", replace
restore

merge m:1 countryname using "temp.dta"
drop if _merge==2
drop _merge
erase "temp.dta"

gen adm1_code = .

append using "t1.dta"
erase "t1.dta"
erase "temporary_data.dta"

* corrections in period
forvalues t = 2015/2022{
	replace period = "Year `t'" if period=="`t'"
}
replace period = "Years 2017-2018" if period=="2017-2018"

order countryname countrycode adm0_code region incomegroup fragile variable dimension category adm1_code short indicator indicator_type value period source

recode adm1_code (. = -99)

replace wave = "Wave 1 (2015-2018)" if wave=="1"
replace wave = "Wave 2 (2019-2022)" if wave=="2"

save "$final_data\ssgd_v2_long.dta", replace

export excel using "$final_data\ssgd_v2_long.xlsx", firstrow(variables) replace