* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chávez
* contact: oalburquequechav@worldbank.org
* last update: July 7th, 2023
* original data source: Datalibweb

/*
Issues:
	- We don't have data on religion nor ethnicity, so we cannot compute estimates for subgroups based on these variables
	- For some periods in ALB MKD NLD SRB SVN TUR we don't have data on urban
	- For UKR we don't have data on age, so we rely on the agecat variable but keep in mind the following assumptions:
		* we construct a censored age variable based on the agecat variable, we took the mean value of every age interval included in agecat
	- For some periods in AUT, BEL, BGR, CHE, CYP, CZE, DNK, ESP, EST, FIN, FRA, GBR, GRC, HRV, HUN, IRL, ISL, ITA, LTU, LUX, LVA, NLD, NOR, POL, PRT, ROU, SVK, SVN, and SWE we don't have data on lstatus, empstat, school, electricity, computer, cellphone
		* This fact makes impossible to obtain indicators related to labor markets such as employed, unemploy, laborforce, workingage, unemp_rate, part, self, priagecurr, penrollrate, secagecurr, senrollrate, and morethan
	- For some periods in AUT, BEL, BGR, CHE, CYP, CZE, DEU, DNK, ESP, EST, FIN, FRA, GBR, GRC, HRV, HUN, IRL, ISL, ITA, KAZ, KGZ, XKX, LTU, LUX, LVA, MDA, NLD, NOR, POL, PRT, ROU, SRB, SVK, SVN, SWE and TUR we don't have data on contract, tv
	- For some periods in DEU, KAZ, KGZ, XKX, MDA and TUR we don't have data on imp_wat_rec, imp_san_rec
	- For some periods in ALB, AUT, BEL, BGR, CHE, CYP, CZE, DEU, DNK, ESP, EST, FIN, FRA, GBR, GRC, HRV, HUN, IRL, ISL, ITA, KAZ, KGZ, XKX, LTU, LUX, LVA, MDA, NLD, NOR, POL, PRT, ROU, SRB, SVK, SVN, SWE and TUR we don't have data on internet, healthins, socialsec, radio, washmach, sewmach, mcycle, fridge, car, ownland
*/

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\gmd\eca"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data"

cd "$raw_data"

* country macro
global countries "ALB ARM AUT AZE BEL BGR BIH BLR CHE CYP CZE DEU DNK ESP EST FIN FRA GBR GEO GRC HRV HUN IRL ISL ITA KAZ KGZ XKX LTU LUX LVA MDA MKD MNE NLD NOR POL PRT ROU RUS SRB SVK SVN SWE TJK TUR UKR"
* periods macro (for each country)
local periods_ALB = "2014 2017 2018 2020"
local periods_ARM = "2014 2018 2019 2020 2021"
local periods_AUT = "2015 2018 2019 2020 2021"
local periods_AZE = "2005"
local periods_BEL = "2015 2018 2019 2020 2021"
local periods_BGR = "2015 2018 2019 2020 2021"
local periods_BIH = "2011"
local periods_BLR = "2015 2018 2019 2020"
local periods_CHE = "2015 2018 2019"
local periods_CYP = "2015 2018 2019 2020 2021"
local periods_CZE = "2015 2018 2019 2020 2021"
local periods_DEU = "2012"
local periods_DNK = "2015 2018 2019 2020 2021"
local periods_ESP = "2015 2018 2019 2020 2021"
local periods_EST = "2015 2018 2019 2020 2021"
local periods_FIN = "2015 2018 2019 2020 2021"
local periods_FRA = "2015 2018 2019 2020 2021"
local periods_GBR = "2015 2018"
local periods_GEO = "2015 2018 2019 2020 2021"
local periods_GRC = "2015 2018 2019 2020 2021"
local periods_HRV = "2015 2018 2019 2020 2021"
local periods_HUN = "2015 2018 2019 2020 2021"
local periods_IRL = "2015 2018 2019 2020 2021"
local periods_ISL = "2015 2018"
local periods_ITA = "2015 2018 2019 2020 2021"
local periods_KAZ = "2015 2018"
local periods_KGZ = "2015 2018 2019 2020"
local periods_XKX = "2014 2017"
local periods_LTU = "2015 2018 2019 2020 2021"
local periods_LUX = "2015 2018 2019 2020 2021"
local periods_LVA = "2015 2018 2019 2020 2021"
local periods_MDA = "2015 2018 2019 2021"
local periods_MKD = "2015 2018 2019 2020"
local periods_MNE = "2014 2017 2018 2019"
local periods_NLD = "2015 2018 2019 2020 2021"
local periods_NOR = "2015 2018 2019 2020"
local periods_POL = "2015 2018 2019 2020"
local periods_PRT = "2015 2018 2019 2020 2021"
local periods_ROU = "2015 2018 2019 2020 2021"
local periods_RUS = "2015 2018 2019 2020"
local periods_SRB = "2015 2018 2019 2020 2021"
local periods_SVK = "2015 2018 2019 2020"
local periods_SVN = "2015 2018 2019 2020 2021"
local periods_SWE = "2015 2018 2019 2020 2021"
local periods_TJK = "2015"
local periods_TUR = "2015 2018 2019"
local periods_UKR = "2015 2018 2019 2020"

foreach x in $countries{
	foreach y of local periods_`x'{
		* loading database
		use "GMD_`x'_`y'.dta", clear
		
		/*
		local var_sel = "urban"
		qui: capture: tab `var_sel'
		if _rc==111{
			gen `var_sel' = .
			di "country `x' and period `y' don't have `var_sel'"
		}
		*/
		
		* ----------- *
		* Corrections *
		* ----------- *
		
		if ("`x'"=="UKR" & "`y'"=="2015"){
			gen length_agecat = length(agecat)
			gen temp1 = substr(agecat,-1,1)
			gen temp2 = substr(agecat,1,1) if length_agecat==13 | length_agecat==14 | (length_agecat==15 & temp1=="s")
			gen temp3 = substr(agecat,1,2) if (length_agecat==15 & temp1=="+") | length_agecat==16
			destring temp2 temp3, replace
			egen temp4 = rowtotal(temp2 temp3), m
			replace temp4 = temp4 + 900
			recode temp4 (901=1) (902=4.5) (903=10) (904=14.5) (905=16.5) (906=19) (907=23) (908=28) (909=33) (910=38) (911=43) (912=48) (913=53) (914=58) (915=63) (916=68) (917=72.5) (918=75)
			replace age = temp4
			drop temp1 temp2 temp3 temp4 length_agecat
		}
		if ("`x'"=="UKR" & "`y'"=="2018"){
			gen length_agecat = length(agecat)
			gen temp1 = substr(agecat,-1,1)
			gen temp2 = substr(agecat,1,1) if length_agecat==13 | length_agecat==14 | (length_agecat==15 & temp1=="s")
			gen temp3 = substr(agecat,1,2) if (length_agecat==15 & temp1=="+") | length_agecat==16
			destring temp2 temp3, replace
			egen temp4 = rowtotal(temp2 temp3), m
			replace temp4 = temp4 + 900
			recode temp4 (901=1) (902=4.5) (903=10) (904=14.5) (905=16.5) (906=19) (907=23) (908=28) (909=33) (910=38) (911=43) (912=48) (913=53) (914=58) (915=63) (916=68) (917=72.5) (918=75)
			replace age = temp4
			drop temp1 temp2 temp3 temp4 length_agecat
		}
		if ("`x'"=="UKR" & "`y'"=="2019"){
			gen temp1 = substr(agecat,1,1)
			destring temp1, replace
			replace temp1 = temp1 + 900
			recode temp1 (901=9.5) (902=23) (903=45.5) (904=57.5) (905=65)
			replace age = temp1
			drop temp1
		}
		if ("`x'"=="UKR" & "`y'"=="2020"){
			gen temp1 = substr(agecat,1,1)
			destring temp1, replace
			replace temp1 = temp1 + 900
			recode temp1 (901=9.5) (902=23) (903=45.5) (904=57.5) (905=65)
			replace age = temp1
			drop temp1
		}
		recode age (-1=.) // some country has -1 as code for missing value
		
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
		* no information on urban
		if ("`x'"=="ALB") | ("`x'"=="MKD" & "`y'"=="2015") | ("`x'"=="NLD") | ("`x'"=="SRB" & "`y'"=="2020") | ("`x'"=="SRB" & "`y'"=="2021") | ("`x'"=="SVN") | ("`x'"=="TUR"){
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
		
		if ("`x'"=="ALB") | ("`x'"=="MKD" & "`y'"=="2015") | ("`x'"=="NLD") | ("`x'"=="SRB" & "`y'"=="2020") | ("`x'"=="SRB" & "`y'"=="2021") | ("`x'"=="SVN") | ("`x'"=="TUR"){
			foreach a in $list_indicators{
				replace `a'_urban0 = -1
				replace `a'_urban1 = -1
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
		
		* corrections regarding the sampling weight
		qui: capture: tab weight_h, rc
		if _rc==111{
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