* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chávez
* contact: oalburquequechav@worldbank.org
* last update: July 7th, 2023

* directory macros
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data"

cd "$proc_data"

use "wjp2017-2018.dta", clear
drop Region

reshape long pl_riggua_ pl_powlim_ pl_nodis_ pl_govreg_ pl_accjus_, i(countryname) j(group) string

rename *_ *_w1

foreach x in pl_riggua pl_powlim pl_nodis pl_govreg pl_accjus{
	gen sou_`x'_w1 = source
	gen per_`x'_w1 = period
}
drop source period

save "temp1.dta", replace

* w2
use "wjp2022.dta", clear
drop Region

* reshape
reshape long pl_riggua_ pl_powlim_ pl_nodis_ pl_govreg_ pl_accjus_, i(countryname) j(group) string

rename *_ *_w2

foreach x in pl_riggua pl_powlim pl_nodis pl_govreg pl_accjus{
	gen sou_`x'_w2 = source
	gen per_`x'_w2 = period
}
drop source period

merge 1:1 countrycode group using "temp1.dta", nogenerate
order countryname countrycode group *_w1 *_w2
save "ssgd_wjp.dta", replace
erase "temp1.dta"