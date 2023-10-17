* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* last update: July 7th, 2023
* original data source: https://databank.worldbank.org/source/world-development-indicators#

/*
Issues:
	- Data availability is limited to the national level
	- Scaling some indices to the [0,1] interval requires defining a time period
*/

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\wdi"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

cd "$raw_data"

import excel using "P_Data_Extract_From_World_Development_Indicators.xlsx", firstrow case(lower) clear

save "temp_wdi.dta", replace

* -------------- *
* Homicide Index *
* -------------- *

use "temp_wdi.dta", clear
keep if seriescode=="VC.IHR.PSRC.P5" // keep homicide rates
keep country* yr* // keep years within selected period

* Scaling index
egen t1_min = rowmin(yr*)
egen t1_max = rowmax(yr*)
qui: sum t1_min
local v_min = r(min) // we define the minimum value of overall selected period
qui: sum t1_max
local v_max = r(max) // we define the maximum value of overall selected period
drop t1_min t1_max
forvalues t = 2015/2021{
	replace yr`t' = (yr`t' - `v_min')/(`v_max' - `v_min') // we scale every rate to the [0,1] interval
}

* Reshape
reshape long yr, i(countrycode) j(year) // reshape to long format
rename yr sc_hom_nat

bys countrycode: egen x1 = max(year) if sc_hom_nat!=. & (year>=2015 & year<=2018)
bys countrycode: egen x2 = max(year) if sc_hom_nat!=. & (year>=2019 & year<=2021)
egen x3 = rowtotal(x1 x2), m

keep if year==x3
gen x4 = ""
replace x4 = "_w1" if x3>=2015 & x3<=2018
replace x4 = "_w2" if x3>=2019 & x3<=2021

drop x1 x2 x3
reshape wide sc_hom_nat year, i(countrycode) j(x4) string

* generating source and period
rename year_w1 per_sc_hom_w1
rename year_w2 per_sc_hom_w2
tostring per_sc_hom_w1 per_sc_hom_w2, replace
rename sc_hom_nat_w1 sc_hom_w1
rename sc_hom_nat_w2 sc_hom_w2
gen sou_sc_hom_w1 = "WDI"
gen sou_sc_hom_w2 = "WDI"

* generating groups
expand 16
bys countrycode: gen x1 = _n
gen group = ""
replace group = "15_24" if x1==1
replace group = "15_29" if x1==2
replace group = "24plus" if x1==3
replace group = "30_59" if x1==4
replace group = "60plus" if x1==5
replace group = "ethmaj" if x1==6
replace group = "ethmin" if x1==7
replace group = "fem" if x1==8
replace group = "male" if x1==9
replace group = "nat" if x1==10
replace group = "nwithoutd" if x1==11
replace group = "pwd" if x1==12
replace group = "relmaj" if x1==13
replace group = "relmin" if x1==14
replace group = "rural" if x1==15
replace group = "urban" if x1==16
drop x1

replace sc_hom_w1 = . if group!="nat"
replace sc_hom_w2 = . if group!="nat"

order countryname countrycode group sc_hom_w1 sc_hom_w2 sou_sc_hom_w1 per_sc_hom_w1 sou_sc_hom_w2 per_sc_hom_w2

save "temp1.dta", replace

* --------------------------------- *
* Percentage of women in parliament *
* --------------------------------- *

use "temp_wdi.dta", clear
keep if seriescode=="SG.GEN.PARL.ZS"
keep country* yr* // keep years within selected period

forvalues t = 2015/2021{
	replace yr`t' = yr`t'/100 // express percentage in decimals
}

* Reshape
reshape long yr, i(countrycode) j(year) // reshape to long format
rename yr si_prosea_nat

bys countrycode: egen x1 = max(year) if si_prosea_nat!=. & (year>=2015 & year<=2018)
bys countrycode: egen x2 = max(year) if si_prosea_nat!=. & (year>=2019 & year<=2021)
egen x3 = rowtotal(x1 x2), m

keep if year==x3
gen x4 = ""
replace x4 = "_w1" if x3>=2015 & x3<=2018
replace x4 = "_w2" if x3>=2019 & x3<=2021

drop x1 x2 x3
reshape wide si_prosea_nat year, i(countrycode) j(x4) string

* generating source and period
rename year_w1 per_si_prosea_w1
rename year_w2 per_si_prosea_w2
tostring per_si_prosea_w1 per_si_prosea_w2, replace
rename si_prosea_nat_w1 si_prosea_w1
rename si_prosea_nat_w2 si_prosea_w2
gen sou_si_prosea_w1 = "WDI"
gen sou_si_prosea_w2 = "WDI"

* generating groups
expand 16
bys countrycode: gen x1 = _n
gen group = ""
replace group = "15_24" if x1==1
replace group = "15_29" if x1==2
replace group = "24plus" if x1==3
replace group = "30_59" if x1==4
replace group = "60plus" if x1==5
replace group = "ethmaj" if x1==6
replace group = "ethmin" if x1==7
replace group = "fem" if x1==8
replace group = "male" if x1==9
replace group = "nat" if x1==10
replace group = "nwithoutd" if x1==11
replace group = "pwd" if x1==12
replace group = "relmaj" if x1==13
replace group = "relmin" if x1==14
replace group = "rural" if x1==15
replace group = "urban" if x1==16
drop x1

replace si_prosea_w1 = . if group!="nat"
replace si_prosea_w2 = . if group!="nat"

order countryname countrycode group si_prosea_w1 si_prosea_w2 sou_si_prosea_w1 per_si_prosea_w1 sou_si_prosea_w2 per_si_prosea_w2

save "temp2.dta", replace

* --------------------------------------------------------------------- *
* Share of women who believe a husband is justified in beating his wife *
* --------------------------------------------------------------------- *

use "temp_wdi.dta", clear
keep if seriescode=="SG.VAW.REAS.ZS"
keep country* yr* // keep years within selected period

forvalues t = 2015/2021{
	replace yr`t' = yr`t'/100 // express percentage in decimals
}

* Reshape
reshape long yr, i(countrycode) j(year) // reshape to long format
rename yr si_beawif_nat

bys countrycode: egen x1 = max(year) if si_beawif_nat!=. & (year>=2015 & year<=2018)
bys countrycode: egen x2 = max(year) if si_beawif_nat!=. & (year>=2019 & year<=2021)
egen x3 = rowtotal(x1 x2), m

keep if year==x3
gen x4 = ""
replace x4 = "_w1" if x3>=2015 & x3<=2018
replace x4 = "_w2" if x3>=2019 & x3<=2021

drop x1 x2 x3
reshape wide si_beawif_nat year, i(countrycode) j(x4) string

* generating source and period
rename year_w1 per_si_beawif_w1
rename year_w2 per_si_beawif_w2
tostring per_si_beawif_w1 per_si_beawif_w2, replace
rename si_beawif_nat_w1 si_beawif_w1
rename si_beawif_nat_w2 si_beawif_w2
gen sou_si_beawif_w1 = "WDI"
gen sou_si_beawif_w2 = "WDI"

* generating groups
expand 16
bys countrycode: gen x1 = _n
gen group = ""
replace group = "15_24" if x1==1
replace group = "15_29" if x1==2
replace group = "24plus" if x1==3
replace group = "30_59" if x1==4
replace group = "60plus" if x1==5
replace group = "ethmaj" if x1==6
replace group = "ethmin" if x1==7
replace group = "fem" if x1==8
replace group = "male" if x1==9
replace group = "nat" if x1==10
replace group = "nwithoutd" if x1==11
replace group = "pwd" if x1==12
replace group = "relmaj" if x1==13
replace group = "relmin" if x1==14
replace group = "rural" if x1==15
replace group = "urban" if x1==16
drop x1

replace si_beawif_w1 = . if group!="nat"
replace si_beawif_w2 = . if group!="nat"

order countryname countrycode group si_beawif_w1 si_beawif_w2 sou_si_beawif_w1 per_si_beawif_w1 sou_si_beawif_w2 per_si_beawif_w2

* ---------- *
* Merge data *
* ---------- *

merge 1:1 countrycode group using "temp1.dta", nogenerate
merge 1:1 countrycode group using "temp2.dta", nogenerate
erase "temp1.dta"
erase "temp2.dta"
order countryname countrycode group *_w1 *_w2

save "$proc_data\ssgd_wdi.dta", replace
