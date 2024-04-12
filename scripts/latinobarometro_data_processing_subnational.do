* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chávez
* contact: oalburquequechav@worldbank.org
* last update: April 8th, 2024

* directory macros
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data"

cd "$proc_data"

* w1
use "latinobarometro2018_subnational.dta", clear
rename adm1_name group
drop Region

foreach x in si_chiear re_govtra re_savmon re_enofoo sc_trupeo sc_congov sc_conpol sc_conele sc_conjus sc_insnei sc_viccri sc_frespe{
	rename `x' `x'_w1
	gen sou_`x'_w1 = source
	replace sou_`x'_w1 = "" if `x'_w1==.
	gen per_`x'_w1 = period
	replace per_`x'_w1 = "" if `x'_w1==.
}

drop source period

save "temp1.dta", replace

* w2
use "latinobarometro2020_subnational.dta", clear

rename adm1_name group
drop Region

foreach x in si_chiear re_govtra re_savmon re_enofoo sc_trupeo sc_congov sc_conpol sc_conele sc_conjus sc_insnei sc_viccri sc_frespe{
	rename `x' `x'_w2
	gen sou_`x'_w2 = source
	replace sou_`x'_w2 = "" if `x'_w2==.
	gen per_`x'_w2 = period
	replace per_`x'_w2 = "" if `x'_w2==.
}

drop source period

merge 1:1 countrycode group using "temp1.dta", nogenerate
order countryname countrycode group *_w1 *_w2
save "ssgd_latinobarometro_subnational.dta", replace
erase "temp1.dta"
