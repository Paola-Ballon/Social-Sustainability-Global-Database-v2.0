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

save "ssgd_v_2_0.dta", replace
