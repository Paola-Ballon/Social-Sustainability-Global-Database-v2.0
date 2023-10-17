* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chávez
* contact: oalburquequechav@worldbank.org
* last update: July 7th, 2023

* directory macros
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data"

cd "$proc_data"

* w1: countries in the baseline of WVS (and no crossover with barometers)
use "wvs6.dta", clear
keep if countrycode=="HTI"

reshape long re_savmon_ re_enofoo_ sc_insnei_ sc_racbeh_ sc_actmem_ sc_trupeo_ sc_homnei_ sc_congov_ sc_conpol_ sc_conele_ sc_conjus_ sc_vot_ sc_attdem_ sc_unshom_ sc_viccri_ si_prowom_ si_menjob_ si_menbet_ si_infint_, i(countryname) j(group) string

rename *_ *_w1

foreach x in re_savmon re_enofoo sc_insnei sc_racbeh sc_actmem sc_trupeo sc_homnei sc_congov sc_conpol sc_conele sc_conjus sc_vot sc_attdem sc_unshom sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen sou_`x'_w1 = source
	gen per_`x'_w1 = period
}
drop source period

foreach x in re_savmon re_enofoo sc_insnei sc_racbeh sc_actmem sc_trupeo sc_homnei sc_congov sc_conpol sc_conele sc_conjus sc_vot sc_attdem sc_unshom sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen `x'_w2 = .
}
foreach x in re_savmon re_enofoo sc_insnei sc_racbeh sc_actmem sc_trupeo sc_homnei sc_congov sc_conpol sc_conele sc_conjus sc_vot sc_attdem sc_unshom sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen sou_`x'_w2 = ""
	gen per_`x'_w2 = ""
}
order countryname countrycode group *_w1 *_w2
save "ssgd_wvs_part1.dta", replace

* ---------- *
* Region: AF *
* ---------- *

* w1: countries in the update of WVS (crossover with AF)
use "wvs7.dta", clear

local countries_AF "AGO BEN BFA BWA CIV CMR CPV GAB GHA GIN GMB LBR LSO MDG MLI MOZ MUS MWI NAM NER NGA SDN SEN SLE STP SWZ TGO TZA UGA ZAF ZMB"
gen ind = .
foreach x of local countries_AF{
	replace ind = 1 if countrycode=="`x'"
}
keep if ind==1
drop ind

keep countryname countrycode period source re_savmon_* sc_racbeh_* sc_actmem_* sc_viccri_* si_prowom_* si_menjob_* si_menbet_* si_infint_*

reshape long re_savmon_ sc_racbeh_ sc_actmem_ sc_viccri_ si_prowom_ si_menjob_ si_menbet_ si_infint_, i(countryname) j(group) string

rename *_ *_w1

foreach x in re_savmon sc_racbeh sc_actmem sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen sou_`x'_w1 = source
	gen per_`x'_w1 = period
}
drop source period

foreach x in re_savmon sc_racbeh sc_actmem sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen `x'_w2 = .
}
foreach x in re_savmon sc_racbeh sc_actmem sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen sou_`x'_w2 = ""
	gen per_`x'_w2 = ""
}
order countryname countrycode group *_w1 *_w2
save "ssgd_wvs_part2.dta", replace

* w2: countries in the update of WVS (crossover with AF)
use "wvs7.dta", clear

local countries_AF "ETH KEN MAR TUN ZWE"
gen ind = .
foreach x of local countries_AF{
	replace ind = 1 if countrycode=="`x'"
}
keep if ind==1
drop ind

keep countryname countrycode period source re_savmon_* sc_racbeh_* sc_actmem_* sc_viccri_* si_prowom_* si_menjob_* si_menbet_* si_infint_*

reshape long re_savmon_ sc_racbeh_ sc_actmem_ sc_viccri_ si_prowom_ si_menjob_ si_menbet_ si_infint_, i(countryname) j(group) string

rename *_ *_w2

foreach x in re_savmon sc_racbeh sc_actmem sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen sou_`x'_w2 = source
	gen per_`x'_w2 = period
}
drop source period

foreach x in re_savmon sc_racbeh sc_actmem sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen `x'_w1 = .
}
foreach x in re_savmon sc_racbeh sc_actmem sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen sou_`x'_w1 = ""
	gen per_`x'_w1 = ""
}
order countryname countrycode group *_w1 *_w2
save "ssgd_wvs_part3.dta", replace

* ---------- *
* Region: AB *
* ---------- *

* w1: countries in the update of WVS (crossover with AB)
use "wvs7.dta", clear

local countries_AB "DZA EGY IRQ JOR KWT LBN MRT PSE YEM"

gen ind = .
foreach x of local countries_AB{
	replace ind = 1 if countrycode=="`x'"
}
keep if ind==1
drop ind

keep countryname countrycode period source re_savmon_* sc_racbeh_* sc_actmem_* sc_viccri_* si_prowom_* si_menjob_* si_menbet_* si_infint_*

reshape long re_savmon_ sc_racbeh_ sc_actmem_ sc_viccri_ si_prowom_ si_menjob_ si_menbet_ si_infint_, i(countryname) j(group) string

rename *_ *_w1

foreach x in re_savmon sc_racbeh sc_actmem sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen sou_`x'_w1 = source
	gen per_`x'_w1 = period
}
drop source period

foreach x in re_savmon sc_racbeh sc_actmem sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen `x'_w2 = .
}
foreach x in re_savmon sc_racbeh sc_actmem sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen sou_`x'_w2 = ""
	gen per_`x'_w2 = ""
}
order countryname countrycode group *_w1 *_w2
save "ssgd_wvs_part4.dta", replace

* w2: countries in the update of WVS (crossover with AB)
use "wvs7.dta", clear

local countries_AB "LBY"
gen ind = .
foreach x of local countries_AB{
	replace ind = 1 if countrycode=="`x'"
}
keep if ind==1
drop ind

keep countryname countrycode period source re_savmon_* sc_racbeh_* sc_actmem_* sc_viccri_* si_prowom_* si_menjob_* si_menbet_* si_infint_*

reshape long re_savmon_ sc_racbeh_ sc_actmem_ sc_viccri_ si_prowom_ si_menjob_ si_menbet_ si_infint_, i(countryname) j(group) string

rename *_ *_w2

foreach x in re_savmon sc_racbeh sc_actmem sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen sou_`x'_w2 = source
	gen per_`x'_w2 = period
}
drop source period

foreach x in re_savmon sc_racbeh sc_actmem sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen `x'_w1 = .
}
foreach x in re_savmon sc_racbeh sc_actmem sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen sou_`x'_w1 = ""
	gen per_`x'_w1 = ""
}
order countryname countrycode group *_w1 *_w2
save "ssgd_wvs_part5.dta", replace

* ----------- *
* Region: ASB *
* ----------- *

* w1: countries in the update of WVS (crossover with ASB)
use "wvs7.dta", clear

local countries_ASB "AUS CHN HKG IDN IND KHM MYS KOR THA"

gen ind = .
foreach x of local countries_ASB{
	replace ind = 1 if countrycode=="`x'"
}
keep if ind==1
drop ind

keep countryname countrycode period source re_savmon_* sc_racbeh_* sc_actmem_* sc_viccri_* si_prowom_* si_menjob_* si_menbet_* si_infint_*

reshape long re_savmon_ sc_racbeh_ sc_actmem_ sc_viccri_ si_prowom_ si_menjob_ si_menbet_ si_infint_, i(countryname) j(group) string

rename *_ *_w1

foreach x in re_savmon sc_racbeh sc_actmem sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen sou_`x'_w1 = source
	gen per_`x'_w1 = period
}
drop source period

foreach x in re_savmon sc_racbeh sc_actmem sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen `x'_w2 = .
}
foreach x in re_savmon sc_racbeh sc_actmem sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen sou_`x'_w2 = ""
	gen per_`x'_w2 = ""
}
order countryname countrycode group *_w1 *_w2
save "ssgd_wvs_part6.dta", replace

* w2: countries in the update of WVS (crossover with ASB)
use "wvs7.dta", clear

local countries_ASB "JPN MMR MNG PHL SGP TWN VNM"
gen ind = .
foreach x of local countries_ASB{
	replace ind = 1 if countrycode=="`x'"
}
keep if ind==1
drop ind

keep countryname countrycode period source re_savmon_* sc_racbeh_* sc_actmem_* sc_viccri_* si_prowom_* si_menjob_* si_menbet_* si_infint_*

reshape long re_savmon_ sc_racbeh_ sc_actmem_ sc_viccri_ si_prowom_ si_menjob_ si_menbet_ si_infint_, i(countryname) j(group) string

rename *_ *_w2

foreach x in re_savmon sc_racbeh sc_actmem sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen sou_`x'_w2 = source
	gen per_`x'_w2 = period
}
drop source period

foreach x in re_savmon sc_racbeh sc_actmem sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen `x'_w1 = .
}
foreach x in re_savmon sc_racbeh sc_actmem sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen sou_`x'_w1 = ""
	gen per_`x'_w1 = ""
}
order countryname countrycode group *_w1 *_w2
save "ssgd_wvs_part7.dta", replace

* ---------- *
* Region: LB *
* ---------- *

* w1: countries in the update of WVS (crossover with LB)
use "wvs7.dta", clear

local countries_LB "ARG BOL BRA CHL COL CRI DOM ECU GTM HND MEX PAN PER PRY SLV"

gen ind = .
foreach x of local countries_LB{
	replace ind = 1 if countrycode=="`x'"
}
keep if ind==1
drop ind

keep countryname countrycode period source re_savmon_* sc_racbeh_* sc_actmem_* sc_viccri_* si_prowom_* si_menjob_* si_menbet_* si_infint_*

reshape long re_savmon_ sc_racbeh_ sc_actmem_ sc_viccri_ si_prowom_ si_menjob_ si_menbet_ si_infint_, i(countryname) j(group) string

rename *_ *_w1

foreach x in re_savmon sc_racbeh sc_actmem sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen sou_`x'_w1 = source
	gen per_`x'_w1 = period
}
drop source period

foreach x in re_savmon sc_racbeh sc_actmem sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen `x'_w2 = .
}
foreach x in re_savmon sc_racbeh sc_actmem sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen sou_`x'_w2 = ""
	gen per_`x'_w2 = ""
}
order countryname countrycode group *_w1 *_w2
save "ssgd_wvs_part8.dta", replace

* w2: countries in the update of WVS (crossover with LB)
use "wvs7.dta", clear

local countries_LB "NIC URY VEN"
gen ind = .
foreach x of local countries_LB{
	replace ind = 1 if countrycode=="`x'"
}
keep if ind==1
drop ind

keep countryname countrycode period source re_savmon_* sc_racbeh_* sc_actmem_* sc_viccri_* si_prowom_* si_menjob_* si_menbet_* si_infint_*

reshape long re_savmon_ sc_racbeh_ sc_actmem_ sc_viccri_ si_prowom_ si_menjob_ si_menbet_ si_infint_, i(countryname) j(group) string

rename *_ *_w2

foreach x in re_savmon sc_racbeh sc_actmem sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen sou_`x'_w2 = source
	gen per_`x'_w2 = period
}
drop source period

foreach x in re_savmon sc_racbeh sc_actmem sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen `x'_w1 = .
}
foreach x in re_savmon sc_racbeh sc_actmem sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen sou_`x'_w1 = ""
	gen per_`x'_w1 = ""
}
order countryname countrycode group *_w1 *_w2
save "ssgd_wvs_part9.dta", replace

* ------------------- *
* Remaining countries *
* ------------------- *

* w1 no crossover with barometers
* w1: countries in the update of WVS (crossover with LB)
use "wvs7.dta", clear

local countries_w1 "AND BGD GRC KAZ PAK PRI ROU RUS SRB KOR TUR USA"

gen ind = .
foreach x of local countries_w1{
	replace ind = 1 if countrycode=="`x'"
}
keep if ind==1
drop ind

reshape long re_savmon_ re_enofoo_ sc_insnei_ sc_racbeh_ sc_actmem_ sc_trupeo_ sc_homnei_ sc_congov_ sc_conpol_ sc_conele_ sc_conjus_ sc_vot_ sc_attdem_ sc_unshom_ sc_viccri_ si_prowom_ si_menjob_ si_menbet_ si_infint_, i(countryname) j(group) string

rename *_ *_w1

foreach x in re_savmon re_enofoo sc_insnei sc_racbeh sc_actmem sc_trupeo sc_homnei sc_congov sc_conpol sc_conele sc_conjus sc_vot sc_attdem sc_unshom sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen sou_`x'_w1 = source
	gen per_`x'_w1 = period
}
drop source period

foreach x in re_savmon re_enofoo sc_insnei sc_racbeh sc_actmem sc_trupeo sc_homnei sc_congov sc_conpol sc_conele sc_conjus sc_vot sc_attdem sc_unshom sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen `x'_w2 = .
}
foreach x in re_savmon re_enofoo sc_insnei sc_racbeh sc_actmem sc_trupeo sc_homnei sc_congov sc_conpol sc_conele sc_conjus sc_vot sc_attdem sc_unshom sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen sou_`x'_w2 = ""
	gen per_`x'_w2 = ""
}
order countryname countrycode group *_w1 *_w2
save "ssgd_wvs_part10.dta", replace

* w2: countries in the update of WVS (crossover with LB)
use "wvs7.dta", clear

local countries_w2 "ARM CAN CYP CZE IRN KGZ MAC MDV NLD NZL SVK TJK UKR GBR"

gen ind = .
foreach x of local countries_w2{
	replace ind = 1 if countrycode=="`x'"
}
keep if ind==1
drop ind

reshape long re_savmon_ re_enofoo_ sc_insnei_ sc_racbeh_ sc_actmem_ sc_trupeo_ sc_homnei_ sc_congov_ sc_conpol_ sc_conele_ sc_conjus_ sc_vot_ sc_attdem_ sc_unshom_ sc_viccri_ si_prowom_ si_menjob_ si_menbet_ si_infint_, i(countryname) j(group) string

rename *_ *_w2

foreach x in re_savmon re_enofoo sc_insnei sc_racbeh sc_actmem sc_trupeo sc_homnei sc_congov sc_conpol sc_conele sc_conjus sc_vot sc_attdem sc_unshom sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen sou_`x'_w2 = source
	gen per_`x'_w2 = period
}
drop source period

foreach x in re_savmon re_enofoo sc_insnei sc_racbeh sc_actmem sc_trupeo sc_homnei sc_congov sc_conpol sc_conele sc_conjus sc_vot sc_attdem sc_unshom sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen `x'_w1 = .
}
foreach x in re_savmon re_enofoo sc_insnei sc_racbeh sc_actmem sc_trupeo sc_homnei sc_congov sc_conpol sc_conele sc_conjus sc_vot sc_attdem sc_unshom sc_viccri si_prowom si_menjob si_menbet si_infint{
	gen sou_`x'_w1 = ""
	gen per_`x'_w1 = ""
}
order countryname countrycode group *_w1 *_w2
save "ssgd_wvs_part11.dta", replace
