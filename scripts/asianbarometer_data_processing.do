* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chávez
* contact: oalburquequechav@worldbank.org
* last update: July 7th, 2023

* directory macros
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data"

cd "$proc_data"

* w1
* we first treat observations that correspond to the updated data
use "asianbarometer5.dta", clear
keep if countrycode=="AUS" | countrycode=="MNG" | countrycode=="PHL" | countrycode=="TWN" | countrycode=="THA" | countrycode=="VNM"
drop Region

* reshape
reshape long sc_frespe_ sc_frejoi_ sc_vot_ sc_attdem_ si_intuse_ sc_conpol_ sc_congov_ sc_conele_ sc_conjus_ sc_trupeo_ re_savmon_ sc_insnei_ sc_actmem_ sc_solpro_, i(countryname) j(group) string

rename *_ *_w1
drop rel_major_count eth_major_count

foreach x in sc_frespe sc_frejoi sc_vot sc_attdem si_intuse sc_conpol sc_congov sc_conele sc_conjus sc_trupeo re_savmon sc_insnei sc_actmem sc_solpro{
	gen sou_`x'_w1 = source
	gen per_`x'_w1 = period
}
drop source period

save "temp1.dta", replace

* now we deal with observations that correspond to the baseline data
use "asianbarometer4.dta", clear
keep if countrycode=="KHM" | countrycode=="CHN" | countrycode=="HKG" | countrycode=="IDN" | countrycode=="JPN" | countrycode=="KOR" | countrycode=="MMR" |countrycode=="SGP"

* reshape
reshape long sc_frespe_ sc_frejoi_ sc_vot_ sc_attdem_ si_intuse_ sc_conpol_ sc_congov_ sc_conele_ sc_conjus_ sc_trupeo_ re_savmon_ sc_insnei_ sc_actmem_ sc_solpro_, i(countryname) j(group) string

rename *_ *_w1
foreach x in sc_frespe sc_frejoi sc_vot sc_attdem si_intuse sc_conpol sc_congov sc_conele sc_conjus sc_trupeo re_savmon sc_insnei sc_actmem sc_solpro{
	gen sou_`x'_w1 = source
	gen per_`x'_w1 = period
}
drop source period

append using "temp1.dta"
erase "temp1.dta"
save "temp1.dta"

* w2
use "asianbarometer5.dta", clear
keep if countrycode=="IND" | countrycode=="IDN" | countrycode=="JPN" | countrycode=="KOR" | countrycode=="MYS" | countrycode=="MMR"

* reshape
reshape long sc_frespe_ sc_frejoi_ sc_vot_ sc_attdem_ si_intuse_ sc_conpol_ sc_congov_ sc_conele_ sc_conjus_ sc_trupeo_ re_savmon_ sc_insnei_ sc_actmem_ sc_solpro_, i(countryname) j(group) string

rename *_ *_w2

foreach x in sc_frespe sc_frejoi sc_vot sc_attdem si_intuse sc_conpol sc_congov sc_conele sc_conjus sc_trupeo re_savmon sc_insnei sc_actmem sc_solpro{
	gen sou_`x'_w2 = source
	gen per_`x'_w2 = period
}
drop source period

merge 1:1 countrycode group using "temp1.dta", nogenerate
order countryname countrycode group *_w1 *_w2
save "ssgd_asianbarometer.dta", replace
erase "temp1.dta"