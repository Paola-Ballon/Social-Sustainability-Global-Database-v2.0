* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chávez
* contact: oalburquequechav@worldbank.org
* last update: December 10, 2023

* directory macros
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data"

cd "$proc_data"

use "evs.dta", clear

* Wave 1 block
keep if period=="2017" | period=="2018"

reshape long sc_congov_ sc_attdem_, i(countryname) j(group) string

rename *_ *_w1

foreach x in sc_congov sc_attdem{
	gen sou_`x'_w1 = source
	gen per_`x'_w1 = period
}
drop source period

foreach x in sc_congov sc_attdem{
	gen `x'_w2 = .
}
foreach x in sc_congov sc_attdem{
	gen sou_`x'_w2 = ""
	gen per_`x'_w2 = ""
}
order countryname countrycode group *_w1 *_w2

drop if countryname=="Romania" | countryname=="Russia" | countryname=="Serbia" // dominance WVS > EVS

save "ssgd_evs_part1.dta", replace

use "evs.dta", clear

* Wave 2 block
keep if period!="2017" & period!="2018"

reshape long sc_congov_ sc_attdem_, i(countryname) j(group) string

rename *_ *_w2

foreach x in sc_congov sc_attdem{
	gen sou_`x'_w2 = source
	gen per_`x'_w2 = period
}
drop source period

foreach x in sc_congov sc_attdem{
	gen `x'_w1 = .
}
foreach x in sc_congov sc_attdem{
	gen sou_`x'_w1 = ""
	gen per_`x'_w1 = ""
}
order countryname countrycode group *_w1 *_w2

save "ssgd_evs_part2.dta", replace