* ======================================= *
* Using the SSGD v2.0 demo file
* Consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* ======================================= *

* ----------- *
* Indications *
* ----------- *

* 1. Press Ctrl + D to run this Stata do file

* directory macros
global final_data "D:\Omar\World Bank\SSG database\final_data"

cd "$final_data"

* loading the SSGD v2.0
use "ssgd_v_2_0.dta", clear

* ---------------------- *
* Selected country: Peru *
* ---------------------- *

global main ""

* We also attach information on other similar countries (from the Andean region), i.e. Bolivia and Ecuador
keep if (countrycode=="PER" | countrycode=="BOL" | countrycode=="ECU") & group=="nat"
drop ex_* per_ex_* sou_ex_*

foreach x in $main{
	forvalues t = 1/2{
		rename `x'w`t' value_w`t'_`x'
		rename per_`x'w`t' period_w`t'_`x'
		rename sou_`x'w`t' source_w`t'_`x'
	}
}

reshape long value_w1_ value_w2_ period_w1_ period_w2_ source_w1_ source_w2_, i(countrycode) j(variable) string

save "temp.dta", replace

foreach k in BOL ECU PER{
	use "temp.dta", clear
	keep if countrycode=="`k'"
	drop countrycode countryname region group
	foreach x in value_w1_ value_w2_ period_w1_ period_w2_ source_w1_ source_w2_{
		rename `x' `x'`k'
	}
	save "temp_`k'.dta", replace 
}

use "temp_BOL.dta", clear
merge 1:1 variable using "temp_ECU.dta", nogenerate
merge 1:1 variable using "temp_PER.dta", nogenerate
foreach k in BOL ECU PER{
	erase "temp_`k'.dta"
}
erase "temp.dta"
save "temp.dta", replace

use "temp.dta", clear
* correcting variable
replace variable = substr(variable, 1, length(variable) - 1)

* creating data for dimension and area
gen dimord = .
gen dimension = substr(variable,1,2)
replace dimord = 1 if dimension=="si"
replace dimord = 2 if dimension=="re"
replace dimord = 3 if dimension=="sc"
replace dimord = 4 if dimension=="pl"
replace dimension = "Process Legitimacy" if dimension=="pl"
replace dimension = "Social Cohesion" if dimension=="sc"
replace dimension = "Resilience" if dimension=="re"
replace dimension = "Social Inclusion" if dimension=="si"
gen area = ""
replace area = "Access to Markets" if inlist(variable, "si_labfor", "si_unerat", "si_sel", "si_con", "si_ownban")
replace area = "Access to Services" if inlist(variable, "si_wat", "si_san", "si_ele", "si_int", "si_intuse")
replace area = "Human Capital Services" if dimension=="Social Inclusion" & area==""
replace area = "Resilience" if dimension=="Resilience"
replace area = "Social Cohesion" if dimension=="Social Cohesion"
replace area = "Voice and Agency" if inlist(variable, "pl_prosea", "pl_prowom", "pl_menjob", "pl_chiear", "pl_menbet", "pl_femsec", "pl_beawif")
replace area = "Social Accountability" if dimension=="Process Legitimacy" & area==""
gen indord = .
* si
replace indord = 1 if variable=="si_labfor"
replace indord = 2 if variable=="si_unerat"
replace indord = 3 if variable=="si_sel"
replace indord = 4 if variable=="si_con"
replace indord = 5 if variable=="si_ownban"
replace indord = 6 if variable=="si_wat"
replace indord = 7 if variable=="si_san"
replace indord = 8 if variable=="si_ele"
replace indord = 9 if variable=="si_int"
replace indord = 10 if variable=="si_intuse"
replace indord = 11 if variable=="si_prienr"
replace indord = 12 if variable=="si_pricom"
replace indord = 13 if variable=="si_secenr"
replace indord = 14 if variable=="si_hea"
replace indord = 15 if variable=="si_socsec"
* re
replace indord = 1 if variable=="re_com"
replace indord = 2 if variable=="re_cel"
replace indord = 3 if variable=="re_tel"
replace indord = 4 if variable=="re_rad"
replace indord = 5 if variable=="re_was"
replace indord = 6 if variable=="re_sew"
replace indord = 7 if variable=="re_mot"
replace indord = 8 if variable=="re_fri"
replace indord = 9 if variable=="re_car"
replace indord = 10 if variable=="re_ownlan"
replace indord = 11 if variable=="re_assets"
replace indord = 12 if variable=="re_govtra"
replace indord = 13 if variable=="re_rem"
replace indord = 14 if variable=="re_savmon"
replace indord = 15 if variable=="re_enofoo"
replace indord = 16 if variable=="re_mortha"
replace indord = 17 if variable=="re_totaff"
* sc
replace indord = 1 if variable=="sc_trupeo"
replace indord = 2 if variable=="sc_homnei"
replace indord = 3 if variable=="sc_congov"
replace indord = 4 if variable=="sc_conpol"
replace indord = 5 if variable=="sc_conele"
replace indord = 6 if variable=="sc_conjus"
replace indord = 7 if variable=="sc_insnei"
replace indord = 8 if variable=="sc_unshom"
replace indord = 9 if variable=="sc_viccri"
replace indord = 10 if variable=="sc_racbeh"
replace indord = 11 if variable=="sc_vot"
replace indord = 12 if variable=="sc_attdem"
replace indord = 13 if variable=="sc_frespe"
replace indord = 14 if variable=="sc_frejoi"
replace indord = 15 if variable=="sc_solpro"
replace indord = 16 if variable=="sc_actmem"
replace indord = 17 if variable=="sc_volass"
replace indord = 18 if variable=="sc_fata"
replace indord = 19 if variable=="sc_numeve"
replace indord = 20 if variable=="sc_hom"
* pl
replace indord = 1 if variable=="pl_prosea"
replace indord = 2 if variable=="pl_prowom"
replace indord = 3 if variable=="pl_menjob"
replace indord = 4 if variable=="pl_chiear"
replace indord = 5 if variable=="pl_menbet"
replace indord = 6 if variable=="pl_femsec"
replace indord = 7 if variable=="pl_beawif"
replace indord = 8 if variable=="pl_rullaw"
replace indord = 9 if variable=="pl_goveff"
replace indord = 10 if variable=="pl_concor"
replace indord = 11 if variable=="pl_riggua"
replace indord = 12 if variable=="pl_powlim"
replace indord = 13 if variable=="pl_nodis"
replace indord = 14 if variable=="pl_govreg"
replace indord = 15 if variable=="pl_accjus"
replace indord = 16 if variable=="pl_civspa"

sort dimord indord
drop dimord indord
rename variable indicator

order dimension area indicator value_w1_BOL value_w2_BOL value_w1_ECU value_w2_ECU value_w1_PER value_w2_PER period_w1_BOL period_w2_BOL period_w1_ECU period_w2_ECU period_w1_PER period_w2_PER source_w1_BOL source_w2_BOL source_w1_ECU source_w2_ECU source_w1_PER source_w2_PER
br




/*
rename value_ value
rename source_ source
rename period_ period
save "ssgd_long_all.dta", replace

* matrix for values
mkmat $main_si $main_re $main_sc $main_pl, matrix(X1)
matrix define X1 = X1'
svmat X1

* matrix for periods
mkmat $main_si_per $main_re_per $main_sc_per $main_pl_per, matrix(X2)
matrix define X2 = X2'
svmat X2

* matrix for source
mkmat $main_si_sou $main_re_sou $main_sc_sou $main_pl_sou, matrix(X3)
matrix define X3 = X3'
svmat X3

br