* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chávez
* contact: oalburquequechav@worldbank.org
* last update: July 7th, 2023
* original data source: Datalibweb

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data"

cd "$raw_data"

* -------------------------- *
* LAC region data processing *
* -------------------------- *

* country macro
global countries "AFG BGD BTN IND MDV NPL PAK LKA"
* periods macro (for each country)
local periods_AFG = "2011" 
local periods_BGD = "2016" 
local periods_BTN = "2017" 
local periods_IND = "2011" 
local periods_MDV = "2016 2019" 
local periods_NPL = "2010" 
local periods_PAK = "2015 2018" 
local periods_LKA = "2016 2019"
* survey macros (for each country and period)
local survey_AFG = "NRVA" 
local survey_BGD = "HIES"
local survey_BTN = "BLSS"
local survey_IND = "NSS-SCH1"
local survey_MDV = "HIES"
local survey_NPL = "LSS-III"
local survey_PAK = "PSLM"
local survey_LKA = "HIES"
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

foreach x in $countries{
	foreach y of local periods_`x'{
		di "local va_`x'_`y' = "
	}
}

* version A
local va_AFG_2011 = "05"
local va_BGD_2016 = "05"
local va_BTN_2017 = "03"
local va_IND_2011 = "06"
local va_MDV_2016 = "02"
local va_MDV_2019 = "02"
local va_NPL_2010 = "06"
local va_PAK_2015 = "05"
local va_PAK_2018 = "01"
local va_LKA_2016 = "04"
local va_LKA_2019 = "01"

foreach x in $countries{
	foreach y of local periods_`x'{
		dlw, coun(`x') y(`y') t(GMD) mod(ALL) verm(`vm_`x'_`y'') vera(`va_`x'_`y'') sur(`survey_`x'_`y'') clear
		di "country `x' and period `y' data processing succeeded"
		save "$raw_data\gmd\sar\GMD_`x'_`y'.dta", replace
	}
}