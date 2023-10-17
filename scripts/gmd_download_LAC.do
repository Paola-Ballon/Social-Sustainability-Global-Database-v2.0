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
*/

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data"

cd "$raw_data"

* -------------------------- *
* LAC region data processing *
* -------------------------- *

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
* survey macros (for each country and period)
local survey_ARG = "EPHC-S2"
local survey_BOL = "EH"
local survey_BRA = "PNADC-E1"
local survey_CHL = "CASEN"
local survey_CRI = "ENAHO"
local survey_ECU = "ENEMDU"
local survey_HTI = "ECVMAS"
local survey_MEX = "ENIGH"
local survey_PAN = "EH"
local survey_PER = "ENAHO"
local survey_PRY = "EPH"
local survey_URY = "ECH"
local survey_SLV = "EHPM"
local survey_NIC = "EMNV"
local survey_HDN = "EPHPM"
local survey_GTM = "ENCOVI"
local survey_DOM = "ENFT"
local survey_LCA = "SLC-HBS"
local survey_COL = "GEIH"
foreach x in $countries{
	foreach y of local periods_`x'{
		local survey_`x'_`y' = "`survey_`x''"
	}
}
* version M
local vm_ARG_2014 = "01"
local vm_ARG_2019 = "01"
local vm_ARG_2020 = "01"
local vm_ARG_2021 = "01"
local vm_BOL_2015 = "01"
local vm_BOL_2019 = "01"
local vm_BOL_2020 = "01"
local vm_BOL_2021 = "01"
local vm_BRA_2015 = "01"
local vm_BRA_2019 = "01"
local vm_BRA_2020 = "01"
local vm_BRA_2021 = "01"
local vm_CHL_2015 = "01"
local vm_CHL_2017 = "01"
local vm_CHL_2020 = "01"
local vm_CRI_2015 = "01"
local vm_CRI_2019 = "01"
local vm_CRI_2020 = "01"
local vm_CRI_2021 = "01"
local vm_ECU_2015 = "01"
local vm_ECU_2019 = "01"
local vm_ECU_2020 = "01"
local vm_ECU_2021 = "01"
local vm_HTI_2012 = "02"
local vm_MEX_2014 = "01"
local vm_MEX_2018 = "01"
local vm_MEX_2020 = "01"
local vm_PAN_2015 = "01"
local vm_PAN_2018 = "01"
local vm_PAN_2021 = "01"
local vm_PER_2015 = "01"
local vm_PER_2019 = "01"
local vm_PER_2020 = "01"
local vm_PER_2021 = "01"
local vm_PRY_2015 = "01"
local vm_PRY_2019 = "01"
local vm_PRY_2020 = "01"
local vm_PRY_2021 = "01"
local vm_URY_2015 = "01"
local vm_URY_2019 = "01"
local vm_URY_2020 = "01"
local vm_URY_2021 = "01"
local vm_COL_2015 = "01"
local vm_COL_2019 = "01"
local vm_COL_2020 = "01"
local vm_COL_2021 = "01"

* version A
local va_ARG_2014 = "04"
local va_ARG_2018 = "07"
local va_ARG_2019 = "02"
local va_ARG_2020 = "02"
local va_ARG_2021 = "01"
local va_BOL_2015 = "03"
local va_BOL_2018 = "04"
local va_BOL_2019 = "02"
local va_BOL_2020 = "02"
local va_BOL_2021 = "01"
local va_BRA_2015 = "02"
local va_BRA_2018 = "03"
local va_BRA_2019 = "02"
local va_BRA_2020 = "01"
local va_BRA_2021 = "01"
local va_CHL_2015 = "02"
local va_CHL_2017 = "04"
local va_CHL_2020 = "01"
local va_CRI_2015 = "03"
local va_CRI_2018 = "04"
local va_CRI_2019 = "02"
local va_CRI_2020 = "02"
local va_CRI_2021 = "01"
local va_ECU_2015 = "03"
local va_ECU_2018 = "04"
local va_ECU_2019 = "02"
local va_ECU_2020 = "02"
local va_ECU_2021 = "01"
local va_HTI_2012 = "04"
local va_MEX_2014 = "02"
local va_MEX_2018 = "03"
local va_MEX_2020 = "01"
local va_PAN_2015 = "01"
local va_PAN_2018 = "01"
local va_PAN_2021 = "01"
local va_PER_2015 = "04"
local va_PER_2018 = "04"
local va_PER_2019 = "02"
local va_PER_2020 = "01"
local va_PER_2021 = "01"
local va_PRY_2015 = "03"
local va_PRY_2018 = "06"
local va_PRY_2019 = "02"
local va_PRY_2020 = "01"
local va_PRY_2021 = "01"
local va_URY_2015 = "04"
local va_URY_2018 = "04"
local va_URY_2019 = "02"
local va_URY_2020 = "02"
local va_URY_2021 = "01"
local va_COL_2015 = "04"
local va_COL_2018 = "04"
local va_COL_2019 = "02"
local va_COL_2020 = "02"
local va_COL_2021 = "01"

* corrections
* Brazil
local survey_BRA_2020 = "PNADC-E5"
local survey_BRA_2021 = "PNADC-E5"
* Mexico
local survey_MEX_2018 = "ENIGHNS"
local survey_MEX_2020 = "ENIGHNS"
* Uruguay
local survey_URY_2021 = "ECH-S2"
* Dominican Republic
local survey_DOM_2019 = "ECNFT-Q3"
local survey_DOM_2020 = "ECNFT-Q3"
local survey_DOM_2021 = "ECNFT-Q3"

foreach x in $countries{
	foreach y of local periods_`x'{
		dlw, coun(`x') y(`y') t(GMD) mod(ALL) verm(`vm_`x'_`y'') vera(`va_`x'_`y'') sur(`survey_`x'_`y'') clear
		di "country `x' and period `y' data processing succeeded"
		save "$raw_data\gmd\lac\GMD_`x'_`y'.dta", replace
	}
}