* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chávez
* contact: oalburquequechav@worldbank.org
* last update: July 7th, 2023

* directory macros
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data"

cd "$proc_data"

* wave 1 - part 1
use "findex2017.dta", clear

reshape long si_ownban_, i(countryname) j(group) string

rename *_ *_w1

foreach x in si_ownban{
	gen sou_`x'_w1 = source
	gen per_`x'_w1 = period
}
drop source period

save "temp1.dta", replace

* wave 2 - part 1
use "findex2021.dta", clear

* reshape
reshape long si_ownban_, i(countryname) j(group) string

rename *_ *_w2

foreach x in si_ownban{
	gen sou_`x'_w2 = source
	gen per_`x'_w2 = period
}
drop source period

save "temp2.dta", replace

* wave 1 - part 2
use "findexb2017.dta", clear

reshape long re_govtrab_ re_savmonb_, i(countryname) j(group) string

rename *_ *_w1

foreach x in re_govtrab re_savmonb{
	gen sou_`x'_w1 = source
	gen per_`x'_w1 = period
}
drop source period

save "temp3.dta", replace

* wave 2 - part 2
use "findexb2021.dta", clear

* reshape
reshape long re_govtrab_ re_savmonb_, i(countryname) j(group) string

rename *_ *_w2

foreach x in re_govtrab re_savmonb{
	gen sou_`x'_w2 = source
	gen per_`x'_w2 = period
}
drop source period

merge 1:1 countrycode group using "temp1.dta", nogenerate
merge 1:1 countrycode group using "temp2.dta", nogenerate
merge 1:1 countrycode group using "temp3.dta", nogenerate
order countryname countrycode group *_w1 *_w2
save "ssgd_findex.dta", replace
erase "temp1.dta"