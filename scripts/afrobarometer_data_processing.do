* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chávez
* contact: oalburquequechav@worldbank.org
* last update: July 7th, 2023

* directory macros
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data"

cd "$proc_data"

* w1
use "afrobarometer7.dta", clear
* we drop si_ownban information since FINDEX provides an accurate estimation for such indicator
drop si_ownban_*

* reshape
reshape long re_rem_ sc_frespe_ sc_vot_ sc_attdem_ si_intuse_ re_enofoo_ sc_volass_ sc_conpol_ sc_conjus_ sc_conele_ sc_congov_ sc_frejoi_ sc_trupeo_ sc_homnei_ sc_insnei_ sc_unshom_, i(countryname) j(group) string

rename *_ *_w1
rename ex_disability1 ex_disability1_w1

foreach x in re_rem sc_frespe sc_vot sc_attdem si_intuse re_enofoo sc_volass sc_conpol sc_conjus sc_conele sc_congov sc_frejoi sc_trupeo sc_homnei sc_insnei sc_unshom ex_disability1{
	gen sou_`x'_w1 = source
	gen per_`x'_w1 = period
}
drop source period

save "temp1.dta", replace

* w2
use "afrobarometer8.dta", clear
* we drop si_ownban information since FINDEX provides an accurate estimation for such indicator
drop si_ownban_*

* reshape
reshape long re_rem_ sc_frespe_ sc_vot_ sc_attdem_ si_intuse_ re_enofoo_ sc_volass_ sc_conpol_ sc_conjus_ sc_conele_ sc_congov_ sc_frejoi_ sc_trupeo_ sc_homnei_ sc_insnei_ sc_unshom_, i(countryname) j(group) string

rename *_ *_w2
rename ex_disability1 ex_disability1_w2

foreach x in re_rem sc_frespe sc_vot sc_attdem si_intuse re_enofoo sc_volass sc_conpol sc_conjus sc_conele sc_congov sc_frejoi sc_trupeo sc_homnei sc_insnei sc_unshom ex_disability1{
	gen sou_`x'_w2 = source
	gen per_`x'_w2 = period
}
drop source period

merge 1:1 countrycode group using "temp1.dta", nogenerate
order countryname countrycode group *_w1 *_w2
save "ssgd_afrobarometer.dta", replace
erase "temp1.dta"