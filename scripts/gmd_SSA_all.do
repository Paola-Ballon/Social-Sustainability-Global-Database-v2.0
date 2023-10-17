* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chávez
* contact: oalburquequechav@worldbank.org
* last update: July 7th, 2023
* original data source: Datalibweb

/*
Issues:
	- We don't have data disability, religion and ethnicity. Therefore, we cannot compute estimates for subgroups based on these variables
	- For SYC in 2018 we don't have data on urban
	- For some years in SYC SSD and ZWE we don't have data on lstatus, empstat, primarycomp, computer, cellphone
	- For some periods in BEN, BFA, TCD, CIV, GIN, GNB, MWI, MLI, NER, SEN, SYC, SSD, TGO, UGA, and ZWE we don't have data on contract, internet, healthins, socialsec, tv, radio, washmach, sewmach, mcycle, fridge, car, and ownland
*/

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\gmd\ssa"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data"

cd "$raw_data"

* country macro
global countries "AGO BEN BWA BFA BDI CPV CMR CAF TCD COM COD COG CIV SWZ ETH GAB GMB GHA GIN GNB KEN LSO LBR MDG MWI MLI MRT MUS MOZ NAM NER NGA RWA STP SEN SYC SLE ZAF SSD SDN TZA TGO UGA ZMB ZWE"
* periods macro (for each country)
local periods_AGO = "2008 2018"
local periods_BEN = "2015 2018"
local periods_BWA = "2015"
local periods_BFA = "2014 2018"
local periods_BDI = "2006 2013"
local periods_CPV = "2015"
local periods_CMR = "2014"
local periods_CAF = "2008"
local periods_TCD = "2011 2018"
local periods_COM = "2013"
local periods_COD = "2012"
local periods_COG = "2011"
local periods_CIV = "2015 2018"
local periods_SWZ = "2016"
local periods_ETH = "2015"
local periods_GAB = "2017"
local periods_GMB = "2015 2020"
local periods_GHA = "2016"
local periods_GIN = "2012 2018"
local periods_GNB = "2010 2018"
local periods_KEN = "2015"
local periods_LSO = "2017"
local periods_LBR = "2016"
local periods_MDG = "2012"
local periods_MWI = "2016 2019"
local periods_MLI = "2009 2018"
local periods_MRT = "2014"
local periods_MUS = "2012 2017"
local periods_MOZ = "2014"
local periods_NAM = "2015"
local periods_NER = "2014 2018"
local periods_NGA = "2018"
local periods_RWA = "2016"
local periods_STP = "2017"
local periods_SEN = "2011 2018"
local periods_SYC = "2013 2018"
local periods_SLE = "2018"
local periods_ZAF = "2014"
local periods_SSD = "2016"
local periods_SDN = "2014"
local periods_TZA = "2018"
local periods_TGO = "2015 2018"
local periods_UGA = "2016 2019"
local periods_ZMB = "2015"
local periods_ZWE = "2017 2019"

foreach x in $countries{
	foreach y of local periods_`x'{
		* loading database
		use "GMD_`x'_`y'.dta", clear
		
		/*
		local var_sel = "urban"
		qui: capture: tab `var_sel'
		if _rc==111{
			gen `var_sel' = .
			di "country `x' and period `y' do have `var_sel'"
		}
		*/
		* corrections
		capture: tab urban, rc
		if _rc==111{
			gen urban = .
		}
	
		* ------------------- *
		* ancillary variables *
		* ------------------- *
		
		* var: sex
		rename male sex
		* var: age groups
		gen ageg1 = (age>=15 & age<=29)
		replace ageg1 = . if age==.
		gen ageg2 = (age>=30 & age<=59)
		replace ageg2 = . if age==.
		gen ageg3 = (age>=60 & age!=.)
		replace ageg3 = . if age==.
		* var: youth (15-24)
		gen youth = (age>=15 & age<=24)
		replace youth = . if age<=14 | age==.
		* var: youth by gender
		gen youthmale = (youth==1) if sex==1
		replace youthmale = . if youth==.
		gen youthfemale = (youth==1) if sex==0
		replace youthfemale = . if youth==.
		qui: capture: tab lstatus, rc
		if _rc==111{
			gen lstatus = .
		}
		* var: employed
		gen employed = (lstatus==1) if age>=15
		replace employed = . if lstatus==.
		* var: unemployed
		gen unemploy = (lstatus==2) if age>=15
		replace	unemploy = . if lstatus==.  
		* var: labor force
		gen laborforce = (employed==1 | unemploy==1) if age>=15
		replace laborforce = . if lstatus==.
		* var: working age population
		gen workingage = (age>=15)
		* var: unemployment rate
		gen unemp_rate = unemploy/laborforce
		* var: labor force participation rate
		gen part = laborforce/workingage
		qui: capture: tab empstat, rc
		if _rc==111{
			gen empstat = .
		}
		* var: self-employed
		gen self = (empstat==4) if employed==1
		replace self = . if empstat==. | employed==.
		qui: capture: tab school, rc
		if _rc==111{
			gen school = .
		}
		* var: school enrollment - primary
		gen	priagecurr = (school==1) if (age>=6 & age<=12)
		replace priagecurr = . if school==.
		gen	priage = (age>=6 & age<=12)
		gen	penrollrate = priagecurr/priage
		* var: school enrollment - secondary
		gen secagecurr = (school==1) if (age>=13 & age<=18)
		replace secagecurr = . if school==.
		gen secage = (age>=13 & age<=18)
		gen senrollrate = secagecurr/secage
		* var: share of households that have more than one person working for pay
		bys hhid: gen x = (employed==1)
		bys hhid: egen w = sum(x)
		bys	hhid: egen size = count(hhid)
		bys hhid: gen morethan = (w>1) if size>1
		replace morethan = . if lstatus==.
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
		capture: tab electricity, rc
		if _rc==111{
			gen si_ele = .
		}
		else{
			rename electricity si_ele
		}
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
		capture: tab primarycomp, rc
		if _rc==111{
			gen si_pricom = .
		}
		else{
			rename primarycomp si_pricom
		}
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
		capture: tab computer, rc
		if _rc==111{
			gen re_com = .
		}
		else{
			rename computer re_com
		}
		* re_cel
		capture: tab cellphone, rc
		if _rc==111{
			gen re_cel = .
		}
		else{
			rename cellphone re_cel
		}
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
		
		* corrections
		if ("`x'"=="SYC" & "`y'"=="2018"){
			*gen urban = .
			replace urban = rbinomial(1, 0.5)
		}
		
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
		* a similar issue arises in the urban population
		capture: table urban if urban==1, rc
		if _rc==2000{
			foreach a in $list_indicators{
				gen `a'_urban1 = -1
			}
		}
		
		if ("`x'"=="SYC" & "`y'"=="2018"){
			foreach a in $list_indicators{
				replace `a'_urban0 = -1
				replace `a'_urban1 = -1
			}
			replace urban = .
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
		
		* corrections regarding the sampling weight
		qui: capture: tab weight_h, rc
		if _rc==111{
			rename weight weight_h
		}
		
		* corrections
		if ("`x'"=="GNB" & "`y'"=="2010"){
			rename code countrycode
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