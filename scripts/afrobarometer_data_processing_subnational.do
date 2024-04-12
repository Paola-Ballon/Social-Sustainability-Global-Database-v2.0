* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chávez
* contact: oalburquequechav@worldbank.org
* last update: April 8th, 2024

* directory macros
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data"

cd "$proc_data"

* w1
use "afrobarometer7_subnational.dta", clear

* we drop si_ownban information since FINDEX provides an accurate estimation for such indicator
drop si_ownban* Region
rename adm1_name group
order countryname group countrycode period source

foreach x in re_rem sc_frespe sc_vot sc_attdem si_intuse re_enofoo sc_volass sc_conpol sc_conjus sc_conele sc_congov sc_frejoi sc_trupeo sc_homnei sc_insnei sc_unshom ex_disability1{
	rename `x' `x'_w1
}

foreach x in re_rem sc_frespe sc_vot sc_attdem si_intuse re_enofoo sc_volass sc_conpol sc_conjus sc_conele sc_congov sc_frejoi sc_trupeo sc_homnei sc_insnei sc_unshom ex_disability1{
	gen sou_`x'_w1 = source
	replace sou_`x'_w1 = "" if `x'_w1==.
	gen per_`x'_w1 = period
	replace per_`x'_w1 = "" if `x'_w1==.
}
drop source period

save "temp1.dta", replace

* w2
use "afrobarometer8_subnational.dta", clear

* we drop si_ownban information since FINDEX provides an accurate estimation for such indicator
drop si_ownban* Region
rename adm1_name group
order countryname group countrycode period source

foreach x in re_rem sc_frespe sc_vot sc_attdem si_intuse re_enofoo sc_volass sc_conpol sc_conjus sc_conele sc_congov sc_frejoi sc_trupeo sc_homnei sc_insnei sc_unshom ex_disability1{
	rename `x' `x'_w2
}

foreach x in re_rem sc_frespe sc_vot sc_attdem si_intuse re_enofoo sc_volass sc_conpol sc_conjus sc_conele sc_congov sc_frejoi sc_trupeo sc_homnei sc_insnei sc_unshom ex_disability1{
	gen sou_`x'_w2 = source
	replace sou_`x'_w2 = "" if `x'_w2==.
	gen per_`x'_w2 = period
	replace per_`x'_w2 = "" if `x'_w2==.
}
drop source period

merge 1:1 countrycode group using "temp1.dta", nogenerate
order countryname countrycode group *_w1 *_w2
save "ssgd_afrobarometer_subnational.dta", replace
erase "temp1.dta"