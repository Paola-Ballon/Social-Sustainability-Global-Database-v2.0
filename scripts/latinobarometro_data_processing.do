* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chávez
* contact: oalburquequechav@worldbank.org
* last update: July 7th, 2023

* directory macros
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data"

cd "$proc_data"

* w1
use "latinobarometro2018.dta", clear

* reshape
reshape long si_chiear_ re_govtra_ re_savmon_ re_enofoo_ sc_trupeo_ sc_congov_ sc_conpol_ sc_conele_ sc_conjus_ sc_insnei_ sc_viccri_ sc_frespe_, i(countryname) j(group) string

rename *_ *_w1

foreach x in si_chiear re_govtra re_savmon re_enofoo sc_trupeo sc_congov sc_conpol sc_conele sc_conjus sc_insnei sc_viccri sc_frespe{
	gen sou_`x'_w1 = source
	gen per_`x'_w1 = period
}
drop source period

save "temp1.dta", replace

* w2
use "latinobarometro2020.dta", clear

* reshape
reshape long si_chiear_ re_govtra_ re_savmon_ re_enofoo_ sc_trupeo_ sc_congov_ sc_conpol_ sc_conele_ sc_conjus_ sc_insnei_ sc_viccri_ sc_frespe_, i(countryname) j(group) string

rename *_ *_w2

foreach x in si_chiear re_govtra re_savmon re_enofoo sc_trupeo sc_congov sc_conpol sc_conele sc_conjus sc_insnei sc_viccri sc_frespe{
	gen sou_`x'_w2 = source
	gen per_`x'_w2 = period
}
drop source period

merge 1:1 countrycode group using "temp1.dta", nogenerate
order countryname countrycode group *_w1 *_w2
save "ssgd_latinobarometro.dta", replace
erase "temp1.dta"
