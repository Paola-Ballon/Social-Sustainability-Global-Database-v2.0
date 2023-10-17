* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chávez
* contact: oalburquequechav@worldbank.org
* last update: July 7th, 2023
* original data source: Datalibweb

/*
Issues:
	- 
*/

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data"

cd "$raw_data"

* -------------------------- *
* EAP region data processing *
* -------------------------- *

* country macro
global countries "FJI IDN KIR LAO MHL FSM MNG MMR NRU PNG PHL WSM SLB THA TLS TON TUV VUT VNM"
* periods macro (for each country)
local periods_FJI = "2013"
local periods_IDN = "2014 2018 2020 2021 2022"
local periods_KIR = "2006"
local periods_LAO = "2018"
local periods_MHL = "2019"
local periods_FSM = "2013"
local periods_MNG = "2014 2018"
local periods_MMR = "2017"
local periods_NRU = "2012"
local periods_PNG = "2009"
local periods_PHL = "2015 2018"
local periods_WSM = "2013"
local periods_SLB = "2012"
local periods_THA = "2015 2018 2019 2020 2021"
local periods_TLS = "2014"
local periods_TON = "2015"
local periods_TUV = "2010"
local periods_VUT = "2010 2019"
local periods_VNM = "2014 2018"
* survey macros (for each country and period)
local survey_FJI = "HIES"
local survey_IDN = "SUSENAS"
local survey_KIR = "HIES"
local survey_LAO = "LECS"
local survey_MHL = "HIES"
local survey_FSM = "HIES"
local survey_MNG = "HSES"
local survey_MMR = "MLCS"
local survey_NRU = "HIES"
local survey_PNG = "HIES"
local survey_PHL = "FIES"
local survey_WSM = "HIES"
local survey_SLB = "HIES"
local survey_THA = "SES"
local survey_TLS = "TLSLS"
local survey_TON = "HIES"
local survey_TUV = "HIES"
local survey_VUT = "HIES"
local survey_VNM = "VHLSS"

foreach x in $countries{
	foreach y of local periods_`x'{
		local survey_`x'_`y' = "`survey_`x''"
	}
}
* version M
foreach x in $countries{
	foreach y of local periods_`x'{
		local vm_`x'_`y' = "01"
	}
}
local vm_PHL_2015 = "02"
local vm_PHL_2018 = "02"
local vm_SLB_2012 = "02"
local vm_VNM_2018 = "03"

/*
foreach x in $countries{
	foreach y of local periods_`x'{
		di "local va_`x'_`y' = "
	}
}
*/

* version A
local va_FJI_2013 = "06"
local va_IDN_2014 = "03"
local va_IDN_2018 = "01"
local va_IDN_2020 = "01"
local va_IDN_2021 = "01"
local va_IDN_2022 = "01"
local va_KIR_2006 = "03"
local va_LAO_2018 = "01"
local va_MHL_2019 = "01"
local va_FSM_2013 = "04"
local va_MNG_2014 = "03"
local va_MNG_2018 = "01"
local va_MMR_2017 = "01"
local va_NRU_2012 = "01"
local va_PNG_2009 = "05"
local va_PHL_2015 = "01"
local va_PHL_2018 = "01"
local va_WSM_2013 = "01"
local va_SLB_2012 = "03"
local va_THA_2015 = "01"
local va_THA_2018 = "01"
local va_THA_2019 = "01"
local va_THA_2020 = "01"
local va_THA_2021 = "01"
local va_TLS_2014 = "02"
local va_TON_2015 = "02"
local va_TUV_2010 = "03"
local va_VUT_2010 = "03"
local va_VUT_2019 = "01"
local va_VNM_2014 = "04"
local va_VNM_2018 = "01"

* corrections
local survey_VUT_2019 = "NSDP"
foreach x in $countries{
	foreach y of local periods_`x'{
		dlw, coun(`x') y(`y') t(GMD) mod(ALL) verm(`vm_`x'_`y'') vera(`va_`x'_`y'') sur(`survey_`x'_`y'') clear
		di "country `x' and period `y' data processing succeeded"
		save "$raw_data\gmd\eap\GMD_`x'_`y'.dta", replace
	}
}