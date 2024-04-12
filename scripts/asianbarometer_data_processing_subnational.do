* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chávez
* contact: oalburquequechav@worldbank.org
* last update: April 8th, 2024

* directory macros
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data"

cd "$proc_data"

* w1
* we first treat observations that correspond to the updated data
use "asianbarometer5_subnational.dta", clear
keep if countrycode=="MNG" | countrycode=="PHL" | countrycode=="VNM"
rename adm1_name group
drop Region

foreach x in sc_frespe sc_frejoi sc_vot sc_attdem si_intuse sc_conpol sc_congov sc_conele sc_conjus sc_trupeo re_savmon sc_insnei sc_actmem sc_solpro{
	rename `x' `x'_w1
	gen sou_`x'_w1 = source
	replace sou_`x'_w1 = "" if `x'_w1==.
	gen per_`x'_w1 = period
	replace per_`x'_w1 = "" if `x'_w1==.
}

drop source period

save "temp1.dta", replace

* now we deal with observations that correspond to the baseline data
use "asianbarometer4_subnational.dta", clear
keep if countrycode=="KHM" | countrycode=="CHN" | countrycode=="HKG" | countrycode=="IDN" | countrycode=="JPN" | countrycode=="KOR" | countrycode=="MMR" |countrycode=="SGP"
rename adm1_name group
drop Region

foreach x in sc_frespe sc_frejoi sc_vot sc_attdem si_intuse sc_conpol sc_congov sc_conele sc_conjus sc_trupeo re_savmon sc_insnei sc_actmem sc_solpro{
	rename `x' `x'_w1
	gen sou_`x'_w1 = source
	replace sou_`x'_w1 = "" if `x'_w1==.
	gen per_`x'_w1 = period
	replace per_`x'_w1 = "" if `x'_w1==.
}

drop source period

append using "temp1.dta"
erase "temp1.dta"
save "temp1.dta"

* w2
use "asianbarometer5_subnational.dta", clear
drop if countrycode=="MNG" | countrycode=="PHL" | countrycode=="VNM"
rename adm1_name group
drop Region

foreach x in sc_frespe sc_frejoi sc_vot sc_attdem si_intuse sc_conpol sc_congov sc_conele sc_conjus sc_trupeo re_savmon sc_insnei sc_actmem sc_solpro{
	rename `x' `x'_w2
	gen sou_`x'_w2 = source
	replace sou_`x'_w2 = "" if `x'_w2==.
	gen per_`x'_w2 = period
	replace per_`x'_w2 = "" if `x'_w2==.
}

drop source period

merge 1:1 countrycode group using "temp1.dta", nogenerate
order countryname countrycode group *_w1 *_w2
save "ssgd_asianbarometer_subnational.dta", replace
erase "temp1.dta"