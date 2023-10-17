* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chávez
* contact: oalburquequechav@worldbank.org
* last update: July 7th, 2023

* directory macros
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data"

cd "$proc_data"

* w1
use "arabbarometer5.dta", clear
drop if period=="2019" // outside of wave 1 range

* reshape
reshape long sc_frespe_ sc_attdem_ si_intuse_ sc_volass_ sc_congov_ sc_conjus_ sc_conpol_ sc_frejoi_ si_menbet_ re_savmon_, i(countryname) j(group) string

rename *_ *_w1
rename ex_disability2 ex_disability2_w1

foreach x in sc_frespe sc_attdem si_intuse sc_volass sc_congov sc_conjus sc_conpol sc_frejoi si_menbet re_savmon ex_disability2{
	gen sou_`x'_w1 = source
	gen per_`x'_w1 = period
}
drop source period

save "temp1.dta", replace

* w2
use "arabbarometer7.dta", clear

* reshape
reshape long sc_frespe_ sc_attdem_ si_intuse_ sc_volass_ sc_congov_ sc_conjus_ sc_conpol_ sc_frejoi_ si_menbet_ re_savmon_, i(countryname) j(group) string

rename *_ *_w2
rename ex_disability2 ex_disability2_w2

foreach x in sc_frespe sc_attdem si_intuse sc_volass sc_congov sc_conjus sc_conpol sc_frejoi si_menbet re_savmon ex_disability2{
	gen sou_`x'_w2 = source
	gen per_`x'_w2 = period
}
drop source period

merge 1:1 countrycode group using "temp1.dta", nogenerate
order countryname countrycode group *_w1 *_w2
drop if countrycode=="MAR" | countrycode=="SDN" | countrycode=="TUN"
save "ssgd_arabbarometer.dta", replace
erase "temp1.dta"

* --------------- *
* Separated cases *
* --------------- *

* This occurs because Morocco, Sudan, and Tunisia are also present in the Afrobarometer and data is richer in there. We only use the Arab barometer for this country for gather information on three indicators

* w1
use "arabbarometer5.dta", clear
keep if countrycode=="MAR" | countrycode=="SDN" | countrycode=="TUN"
drop if period=="2019" // outside of wave 1 range
keep countryname countrycode period source si_menbet_* re_savmon_* ex_disability2

* reshape
reshape long si_menbet_ re_savmon_, i(countryname) j(group) string

rename *_ *_w1
rename ex_disability2 ex_disability2_w1

foreach x in si_menbet re_savmon ex_disability2{
	gen sou_`x'_w1 = source
	gen per_`x'_w1 = period
}
drop source period

save "temp1.dta", replace

* w2
use "arabbarometer7.dta", clear
keep if countrycode=="MAR" | countrycode=="SDN" | countrycode=="TUN"
keep countryname countrycode period source si_menbet_* re_savmon_* ex_disability2

* reshape
reshape long si_menbet_ re_savmon_, i(countryname) j(group) string

rename *_ *_w2
rename ex_disability2 ex_disability2_w2

foreach x in si_menbet re_savmon ex_disability2{
	gen sou_`x'_w2 = source
	gen per_`x'_w2 = period
}
drop source period

merge 1:1 countrycode group using "temp1.dta", nogenerate
order countryname countrycode group *_w1 *_w2
save "ssgd_arabbarometer_extra.dta", replace
erase "temp1.dta"
