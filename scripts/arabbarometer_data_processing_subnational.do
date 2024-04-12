* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chávez
* contact: oalburquequechav@worldbank.org
* last update: July 7th, 2023

* directory macros
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data"

cd "$proc_data"

* w1
use "arabbarometer5_subnational.dta", clear
rename adm1_name group
drop if period=="2019" // outside of wave 1 range

foreach x in sc_frespe sc_attdem si_intuse sc_volass sc_congov sc_conjus sc_conpol sc_frejoi si_menbet re_savmon ex_disability2{
	rename `x' `x'_w1
	gen sou_`x'_w1 = source
	replace sou_`x'_w1 = "" if `x'_w1==.
	gen per_`x'_w1 = period
	replace per_`x'_w1 = "" if `x'_w1==.
}

drop source period

save "temp1.dta", replace

* w2
use "arabbarometer7_subnational.dta", clear
rename adm1_name group

foreach x in sc_frespe sc_attdem si_intuse sc_volass sc_congov sc_conjus sc_conpol sc_frejoi si_menbet re_savmon ex_disability2{
	rename `x' `x'_w2
	gen sou_`x'_w2 = source
	replace sou_`x'_w2 = "" if `x'_w2==.
	gen per_`x'_w2 = period
	replace per_`x'_w2 = "" if `x'_w2==.
}

drop source period

merge 1:1 countrycode group using "temp1.dta", nogenerate
order countryname countrycode group *_w1 *_w2
drop if countrycode=="MAR" | countrycode=="SDN" | countrycode=="TUN"
save "ssgd_arabbarometer_subnational.dta", replace
erase "temp1.dta"

* --------------- *
* Separated cases *
* --------------- *

* This occurs because Morocco, Sudan, and Tunisia are also present in the Afrobarometer and data is richer in there. We only use the Arab barometer for this country to gather information on three indicators

* w1
use "arabbarometer5_subnational.dta", clear
rename adm1_name group
keep if countrycode=="MAR" | countrycode=="SDN" | countrycode=="TUN"
keep countryname countrycode period source group si_menbet re_savmon ex_disability2

foreach x in si_menbet re_savmon ex_disability2{
	rename `x' `x'_w1
	gen sou_`x'_w1 = source
	replace sou_`x'_w1 = "" if `x'_w1==.
	gen per_`x'_w1 = period
	replace per_`x'_w1 = "" if `x'_w1==.
}

drop source period

save "temp1.dta", replace

* w2
use "arabbarometer7_subnational.dta", clear
rename adm1_name group
keep if countrycode=="MAR" | countrycode=="SDN" | countrycode=="TUN"
keep countryname countrycode period source group si_menbet* re_savmon* ex_disability2

foreach x in si_menbet re_savmon ex_disability2{
	rename `x' `x'_w2
	gen sou_`x'_w2 = source
	replace sou_`x'_w2 = "" if `x'_w2==.
	gen per_`x'_w2 = period
	replace per_`x'_w2 = "" if `x'_w2==.
}

drop source period

merge 1:1 countrycode group using "temp1.dta", nogenerate
order countryname countrycode group *_w1 *_w2
save "ssgd_arabbarometer_extra_subnational.dta", replace
erase "temp1.dta"
