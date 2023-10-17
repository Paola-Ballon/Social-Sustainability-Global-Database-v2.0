* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chávez
* contact: oalburquequechav@worldbank.org
* last update: July 7th, 2023
* original data source: Datalibweb

/*
Issues:
	- The following countries require special request to access data: SLV NIC HND GTM DOM
	- The following countries have problems with their data: LCA
		* Cannot open the data file
	- We don't have data on religion nor ethnicity, so we cannot compute estimates for subgroups based on these variables
*/

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\gmd\lac"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data"

cd "$raw_data"

* country macro
*global countries "ARG BOL BRA CHL CRI ECU HTI MEX PAN PER PRY URY SLV NIC HND GTM DOM LCA COL"
global countries "ARG BOL BRA CHL CRI ECU HTI MEX PAN PER PRY URY COL"
* periods macro (for each country)
local periods_ARG = "2014 2018 2019 2020 2021"
local periods_BOL = "2015 2018 2019 2020 2021"
local periods_BRA = "2015 2018 2019 2020 2021"
local periods_CHL = "2015 2017 2020"
local periods_CRI = "2015 2018 2019 2020 2021"
local periods_ECU = "2015 2018 2019 2020 2021"
local periods_HTI = "2012"
local periods_MEX = "2014 2018 2020"
local periods_PAN = "2015 2018 2021"
local periods_PER = "2015 2018 2019 2020 2021"
local periods_PRY = "2015 2018 2019 2020 2021"
local periods_URY = "2015 2018 2019 2020 2021"
local periods_SLV = "2019 2021"
local periods_NIC = "2014"
local periods_HDN = "2015 2019"
local periods_GTM = "2014"
local periods_DOM = "2015 2019 2020 2021"
local periods_LCA = "2016"
local periods_COL = "2015 2018 2019 2020 2021"

foreach x in $countries{
	foreach y of local periods_`x'{
		* loading database
		use "GMD_`x'_`y'.dta", clear
		
		* Corrections
		if ("`x'"=="COL" & "`y'"=="2015"){
			replace countrycode = "COL"
		}
		if ("`x'"=="MEX" & "`y'"=="2014"){
			replace countrycode = "MEX"
		}
		
		* ------------------- *
		* ancillary variables *
		* ------------------- *
		
		* var: sex
		rename male sex
		* var: age groups
		gen ageg1 = (age>=15 & age<=29) 				
		gen ageg2 = (age>=30 & age<=59)
		gen ageg3 = (age>=60 & age!=.)
		
		* var: youth (15-24)
		gen youth = (age>=15 & age<=24)
		replace youth = . if age<=14 | age==.
		* var: youth by gender
		gen youthmale = (youth==1) if sex==1
		gen youthfemale = (youth==1) if sex==0
		* var: employed
		gen employed = (lstatus==1) if age>=15
		replace employed = . if lstatus==.
		* var: unemployed
		gen unemploy = (lstatus==2) if age>=15
		replace	unemploy = . if lstatus==.  
		* var: labor force
		gen laborforce = (employed==1 | unemploy==1) if age>=15
		* var: working age population
		gen workingage = (age>=15)
		* var: unemployment rate
		gen unemp_rate = unemploy/laborforce
		* var: labor force participation rate
		gen part = laborforce/workingage
		* var: self-employed
		gen self = (empstat==4) if employed==1
		replace self = . if empstat==. | employed==.
		* var: school enrollment - primary
		gen	priagecurr = (school==1) if (age>=6 & age<=12)
		gen	priage = (age>=6 & age<=12)
		gen	penrollrate = priagecurr/priage
		* var: school enrollment - secondary
		gen secagecurr = (school==1) if (age>=13 & age<=18) 
		gen secage = (age>=13 & age<=18)
		gen senrollrate = secagecurr/secage
		* var: share of households that have more than one person working for pay
		bys hhid: gen x = (employed==1)
		bys hhid: egen w = sum(x)
		bys	hhid: egen size = count(hhid)
		bys hhid: gen morethan = (w>1) if size>1
		* var: female 25+ with secondary education
		gen fem25sec = (educat4>=3 & sex==0 & age>=25)
		replace fem25sec = . if educat4==.
		replace fem25sec = . if sex==1
		
		* ------------------ *
		* List of indicators *
		* ------------------ *
		
		* si_labfor
		rename part si_labfor
		* si_unerat
		rename unemp_rate si_unerat
		* si_sel
		rename self si_sel
		* si_con
		capture: tab contract, rc
		if _rc==111{
			gen si_con = .
		}
		else{
			rename contract si_con
		}
		* si_wat
		capture: tab imp_wat_rec, rc
		if _rc==111{
			gen si_wat = .
		}
		else{
			rename imp_wat_rec si_wat
		}
		* si_san
		capture: tab imp_san_rec, rc
		if _rc==111{
			gen si_san = .
		}
		else{
			rename imp_san_rec si_san
		}
		* si_ele
		rename electricity si_ele
		* si_int
		capture: tab internet, rc
		if _rc==111{
			gen si_int = .
		}
		else{
			* recode internet
			recode internet (2=1) (3=1) (4=0)
			rename internet si_int
		}
		* si_prienr
		rename penrollrate si_prienr
		* si_pricom
		rename primarycomp si_pricom
		* si_secenr
		rename senrollrate si_secenr
		* si_hea
		capture: tab healthins, rc
		if _rc==111{
			gen si_hea = .
		}
		else{
			rename healthins si_hea
		}
		* si_socsec
		capture: tab socialsec
		if _rc==111{
			gen si_socsec = .
		}
		else{
			rename socialsec si_socsec
		}
		* si_femsec
		rename fem25sec si_femsec
		* re_com
		rename computer re_com
		* re_cel
		rename cellphone re_cel
		* re_tel
		capture: tab tv, rc
		if _rc==111{
			gen re_tel = .
		}
		else{
			rename tv re_tel
		}
		* re_rad
		capture: tab radio, rc
		if _rc==111{
			gen re_rad = .
		}
		else{
			rename radio re_rad
		}
		* re_was
		capture: tab washmach, rc
		if _rc==111{
			gen re_was = .
		}
		else{
			rename washmach re_was
		}
		* re_sew
		capture: tab sewmach, rc
		if _rc==111{
			gen re_sew = .
		}
		else{
			rename sewmach re_sew
		}
		* re_mot
		capture: tab mcycle, rc
		if _rc==111{
			gen re_mot = .
		}
		else{
			rename mcycle re_mot
		}
		* re_fri
		capture: tab fridge, rc
		if _rc==111{
			gen re_fri = .
		}
		else{
			rename fridge re_fri
		}
		* re_car
		capture: tab car, rc
		if _rc==111{
			gen re_car = .
		}
		else{
			rename car re_car
		}
		* re_ownlan
		capture: tab ownland, rc
		if _rc==111{
			gen re_ownlan = .
		}
		else{
			rename ownland re_ownlan
		}
		* re_assets
		egen re_assets = rowtotal(re_com re_cel re_rad re_tel re_was re_sew re_car re_fri re_mot), m
		replace re_assets = re_assets/9
		replace re_assets = . if re_com==. | re_cel==. | re_rad==. | re_tel==. | re_was==. | re_sew==. | re_car==. | re_fri==. | re_mot==.
		* re_mortha
		rename morethan re_mortha
		
		* ------------------------------ *
		* Overall estimates and by group *
		* ------------------------------ *
		
		* creating unavailable groups
		gen disability = .
		gen rel_major = .
		gen ethnic_major = .
		
		* list of indicators
		global list_indicators "si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha"
		
		* list of subgroups
		global subgroups "sex urban youth disability rel_major ethnic_major"
		
		* generating indicators for each subgroup
		foreach z in $subgroups{
			* some groups are available...
			if ("`z'"!="disability" & "`z'"!="rel_major" & "`z'"!="ethnic_major"){ // recall that we have no data on disability
				levelsof `z', local(val_`z')
				foreach a in $list_indicators{
					foreach t of local val_`z'{
						gen `a'_`z'`t' = `a' if `z'==`t'
					}
				}
			}
			* ...while others are not
			if ("`z'"=="disability" | "`z'"=="rel_major" | "`z'"=="ethnic_major"){
				foreach a in $list_indicators{
					gen `a'_`z'0 = -1
					gen `a'_`z'1 = -1
				}
			}
		}
		* special case: age groups
		foreach a in $list_indicators{
			gen `a'_ageg1 = `a' if ageg1==1
			gen `a'_ageg2 = `a' if ageg2==1
			gen `a'_ageg3 = `a' if ageg3==1
		}
		
		* sometimes the survey does not include the rural population
		capture: table urban if urban==0, rc
		if _rc==2000{
			foreach a in $list_indicators{
				gen `a'_urban0 = -1
			}
		}
		
		* adding suffixes
		foreach a in $list_indicators{
			rename `a' `a'_nat
			rename `a'_sex0 `a'_fem
			rename `a'_sex1 `a'_male
			rename `a'_urban0 `a'_rural
			rename `a'_urban1 `a'_urban
			rename `a'_youth1 `a'_15_24
			rename `a'_youth0 `a'_24plus
			rename `a'_disability0 `a'_nwithoutd
			rename `a'_disability1 `a'_pwd
			rename `a'_rel_major0 `a'_relmin
			rename `a'_rel_major1 `a'_relmaj
			rename `a'_ethnic_major0 `a'_ethmin
			rename `a'_ethnic_major1 `a'_ethmaj
			rename `a'_ageg1 `a'_15_29
			rename `a'_ageg2 `a'_30_59
			rename `a'_ageg3 `a'_60plus
		}
		
		* ------------------ *
		* Supplementary data *
		* ------------------ *

		* string countryname/countrycode
		*d countrycode

		* add survey year
		gen GMD_period = "`y'"

		* data source
		gen GMD_source = "Global Monitoring Database"
		
		* specific data source
		clonevar GMD_survey = survname
		
		* corrections
		if ("`x'"=="PAN" & "`y'"=="2015"){
			rename weight weight_h
		}
		
		* reduce data size
		keep GMD_* sex ageg1 ageg2 ageg3 youth urban si_labfor* si_unerat* si_sel* si_con* si_wat* si_san* si_ele* si_int* si_prienr* si_pricom* si_secenr* si_hea* si_socsec* si_femsec* re_com* re_cel* re_tel* re_rad* re_was* re_sew* re_mot* re_fri* re_car* re_ownlan* re_assets* re_mortha* weight_h countrycode
		*compress

		* ----------------- *
		* Collapse the data *
		* ----------------- *

		collapse (mean) sex ageg1 ageg2 ageg3 youth urban si_labfor* si_unerat* si_sel* si_con* si_wat* si_san* si_ele* si_int* si_prienr* si_pricom* si_secenr* si_hea* si_socsec* si_femsec* re_com* re_cel* re_tel* re_rad* re_was* re_sew* re_mot* re_fri* re_car* re_ownlan* re_assets* re_mortha* [aw = weight_h], by(countrycode GMD_period GMD_source GMD_survey)
		
		* recoding missing values
		foreach a in si_labfor* si_unerat* si_sel* si_con* si_wat* si_san* si_ele* si_int* si_prienr* si_pricom* si_secenr* si_hea* si_socsec* si_femsec* re_com* re_cel* re_tel* re_rad* re_was* re_sew* re_mot* re_fri* re_car* re_ownlan* re_assets* re_mortha*{
			recode `a' (-1=.)
		}
		
		* saving
		save "$proc_data\gmd_`x'_`y'.dta", replace
	}
}

