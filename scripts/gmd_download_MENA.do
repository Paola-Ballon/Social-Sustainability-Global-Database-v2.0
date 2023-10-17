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

* --------------------------- *
* MENA region data processing *
* --------------------------- *

* country macro
global countries "DJI EGY IRN IRQ JOR LBN MLT MAR TUN YEM PSE"
* periods macro (for each country)
local periods_DJI = "2012 2017"
local periods_EGY = "2015 2017 2019"
local periods_IRN = "2015 2018 2019"
local periods_IRQ = "2012"
local periods_JOR = "2010"
local periods_LBN = "2011"
local periods_MLT = "2018 2019 2020 2021"
local periods_MAR = "2013"
local periods_TUN = "2015"
local periods_YEM = "2014"
local periods_PSE = "2016"
* survey macros (for each country and period)
local survey_DJI = "EDAM"
local survey_EGY = "HIECS"
local survey_IRN = "HEIS"
local survey_IRQ = "IHSES"
local survey_JOR = "HEIS"
local survey_LBN = "HBS"
local survey_MLT = "EU-SILC"
local survey_MAR = "ENCDM"
local survey_TUN = "NSHBCSL"
local survey_YEM = "HBS"
local survey_PSE = "PECS"
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
local vm_IRN_2015 = "02"

foreach x in $countries{
	foreach y of local periods_`x'{
		di "local va_`x'_`y' = "
	}
}

* version A
local va_DJI_2012 = "03"
local va_DJI_2017 = "04"
local va_EGY_2015 = "05"
local va_EGY_2017 = "03"
local va_EGY_2019 = "01"
local va_IRN_2015 = "01"
local va_IRN_2018 = "01"
local va_IRN_2019 = "01"
local va_IRQ_2012 = "04"
local va_JOR_2010 = "04"
local va_LBN_2011 = "03"
local va_MLT_2018 = "01"
local va_MLT_2019 = "01"
local va_MLT_2020 = "01"
local va_MLT_2021 = "01"
local va_MAR_2013 = "04"
local va_TUN_2015 = "04"
local va_YEM_2014 = "06"
local va_PSE_2016 = "04"

foreach x in $countries{
	foreach y of local periods_`x'{
		dlw, coun(`x') y(`y') t(GMD) mod(ALL) verm(`vm_`x'_`y'') vera(`va_`x'_`y'') sur(`survey_`x'_`y'') clear
		di "country `x' and period `y' data processing succeeded"
		save "$raw_data\gmd\mena\GMD_`x'_`y'.dta", replace
	}
}