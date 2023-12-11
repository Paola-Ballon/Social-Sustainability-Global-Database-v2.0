* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chávez
* contact: oalburquequechav@worldbank.org
* last update: July 7th, 2023

* directory macros
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data"

cd "$proc_data"

* SSGDB 2.0 countries
* SSA w1
global ssgd_w1_SSA "AGO BEN BWA BFA CPV TCD CIV SWZ ETH GAB GHA GIN GNB KEN LSO LBR MLI MUS NAM NER NGA RWA STP SEN SYC SLE SSD TZA TGO ZMB"
local w1_AGO = "2018"
local w1_BEN = "2018"
local w1_BWA = "2015"
local w1_BFA = "2018"
local w1_CPV = "2015"
local w1_TCD = "2018"
local w1_CIV = "2018"
local w1_SWZ = "2016"
local w1_ETH = "2015"
local w1_GAB = "2017"
local w1_GHA = "2016"
local w1_GIN = "2018"
local w1_GNB = "2018"
local w1_KEN = "2015"
local w1_LSO = "2017"
local w1_LBR = "2016"
local w1_MLI = "2018"
local w1_MUS = "2017"
local w1_NAM = "2015"
local w1_NER = "2018"
local w1_NGA = "2018"
local w1_RWA = "2016"
local w1_STP = "2017"
local w1_SEN = "2018"
local w1_SYC = "2018"
local w1_SLE = "2018"
local w1_SSD = "2016"
local w1_TZA = "2018"
local w1_TGO = "2018"
local w1_ZMB = "2015"
* SSA w1w2
global ssgd_w1w2_SSA "GMB MWI UGA ZWE"
local w1_GMB = "2015"
local w1_MWI = "2016"
local w1_UGA = "2016"
local w1_ZWE = "2017"
local w2_GMB = "2020"
local w2_MWI = "2019"
local w2_UGA = "2019"
local w2_ZWE = "2019"
* SAR w1
global ssgd_w1_SAR "BGD BTN PAK"
local w1_BGD = "2016"
local w1_BTN = "2017"
local w1_PAK = "2018"
* SAR w1w2
global ssgd_w1w2_SAR "MDV LKA"
local w1_MDV = "2016"
local w1_LKA = "2016"
local w2_MDV = "2019"
local w2_LKA = "2019"
* MENA w1
global ssgd_w1_MENA "DJI TUN PSE"
local w1_DJI = "2017"
local w1_TUN = "2015"
local w1_PSE = "2016"
* MENA w1w2
global ssgd_w1w2_MENA "EGY IRN MLT"
local w1_EGY = "2017"
local w1_IRN = "2018"
local w1_MLT = "2018"
local w2_EGY = "2019"
local w2_IRN = "2019"
local w2_MLT = "2021"
* LAC 
global ssgd_w1w2_LAC "ARG BOL BRA CHL CRI ECU MEX PAN PER PRY URY COL"
local w1_ARG = "2018"
local w1_BOL = "2018"
local w1_BRA = "2018"
local w1_CHL = "2017"
local w1_CRI = "2018"
local w1_ECU = "2018"
local w1_MEX = "2018"
local w1_PAN = "2018"
local w1_PER = "2018"
local w1_PRY = "2018"
local w1_URY = "2018"
local w1_COL = "2018"
local w2_ARG = "2021"
local w2_BOL = "2021"
local w2_BRA = "2021"
local w2_CHL = "2020"
local w2_CRI = "2021"
local w2_ECU = "2021"
local w2_MEX = "2020"
local w2_PAN = "2021"
local w2_PER = "2021"
local w2_PRY = "2021"
local w2_URY = "2021"
local w2_COL = "2021"
* ECA
global ssgd_w1_ECA "GBR ISL KAZ XKX TJK"
local w1_GBR = "2018"
local w1_ISL = "2018"
local w1_KAZ = "2018"
local w1_XKX = "2017"
local w1_TJK = "2015"
global ssgd_w1w2_ECA "ALB ARM AUT BEL BGR BLR CHE CYP CZE DNK ESP EST FIN FRA GEO GRC HRV HUN IRL ITA KGZ LTU LUX LVA MDA MKD MNE NLD NOR POL PRT ROU RUS SRB SVK SVN SWE TUR UKR"
local w1_ALB = "2018"
local w1_ARM = "2018"
local w1_AUT = "2018"
local w1_BEL = "2018"
local w1_BGR = "2018"
local w1_BLR = "2018"
local w1_CHE = "2018"
local w1_CYP = "2018"
local w1_CZE = "2018"
local w1_DNK = "2018"
local w1_ESP = "2018"
local w1_EST = "2018"
local w1_FIN = "2018"
local w1_FRA = "2018"
local w1_GEO = "2018"
local w1_GRC = "2018"
local w1_HRV = "2018"
local w1_HUN = "2018"
local w1_IRL = "2018"
local w1_ITA = "2018"
local w1_KGZ = "2018"
local w1_LTU = "2018"
local w1_LUX = "2018"
local w1_LVA = "2018"
local w1_MDA = "2018"
local w1_MKD = "2018"
local w1_MNE = "2018"
local w1_NLD = "2018"
local w1_NOR = "2018"
local w1_POL = "2018"
local w1_PRT = "2018"
local w1_ROU = "2018"
local w1_RUS = "2018"
local w1_SRB = "2018"
local w1_SVK = "2018"
local w1_SVN = "2018"
local w1_SWE = "2018"
local w1_TUR = "2018"
local w1_UKR = "2018"
local w2_ALB = "2020"
local w2_ARM = "2021"
local w2_AUT = "2021"
local w2_BEL = "2021"
local w2_BGR = "2021"
local w2_BLR = "2020"
local w2_CHE = "2019"
local w2_CYP = "2021"
local w2_CZE = "2021"
local w2_DNK = "2021"
local w2_ESP = "2021"
local w2_EST = "2021"
local w2_FIN = "2021"
local w2_FRA = "2021"
local w2_GEO = "2021"
local w2_GRC = "2021"
local w2_HRV = "2021"
local w2_HUN = "2021"
local w2_IRL = "2021"
local w2_ITA = "2021"
local w2_KGZ = "2020"
local w2_LTU = "2021"
local w2_LUX = "2021"
local w2_LVA = "2021"
local w2_MDA = "2021"
local w2_MKD = "2020"
local w2_MNE = "2019"
local w2_NLD = "2021"
local w2_NOR = "2020"
local w2_POL = "2020"
local w2_PRT = "2021"
local w2_ROU = "2021"
local w2_RUS = "2020"
local w2_SRB = "2021"
local w2_SVK = "2020"
local w2_SVN = "2021"
local w2_SWE = "2021"
local w2_TUR = "2019"
local w2_UKR = "2020"
* EAP
global ssgd_w1_EAP "LAO MNG MMR PHL TON VNM"
local w1_LAO = "2018"
local w1_MNG = "2018"
local w1_MMR = "2017"
local w1_PHL = "2018"
local w1_TON = "2015"
local w1_VNM = "2018"
global ssgd_w2_EAP "MHL VUT"
local w2_MHL = "2019"
local w2_VUT = "2019"
global ssgd_w1w2_EAP "IDN THA"
local w1_IDN = "2018"
local w1_THA = "2018"
local w2_IDN = "2022"
local w2_THA = "2021"

* ----------- *
* Region: SSA *
* ----------- *

* SSA w1
foreach x in $ssgd_w1_SSA{
	* w1
	use "gmd_`x'_`w1_`x''.dta", clear
	* reshape long: country and group data
	reshape long si_labfor_ si_unerat_ si_sel_ si_con_ si_wat_ si_san_ si_ele_ si_int_ si_prienr_ si_pricom_ si_secenr_ si_hea_ si_socsec_ si_femsec_ re_com_ re_cel_ re_tel_ re_rad_ re_was_ re_sew_ re_mot_ re_fri_ re_car_ re_ownlan_ re_assets_ re_mortha_, i(countrycode) j(group) string
	rename * *w1
	foreach k in sex ageg1 ageg2 ageg3 youth urban{
		rename `k'w1 `k'_w1
	}
	* data management
	foreach k in countrycode group{
		rename `k'w1 `k'
	}
	rename GMD_periodw1 GMD_period_w1
	drop GMD_sourcew1
	drop GMD_surveyw1
	foreach k in sex ageg1 ageg2 ageg3 youth urban si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha{
		* generate lacking data for wave 2
		gen `k'_w2 = .
	}
	foreach k in sex ageg1 ageg2 ageg3 youth urban si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha{
		* generate source and period information for each indicator in wave 1
		gen sou_`k'_w1 = "GMD" // source
		gen per_`k'_w1 = GMD_period_w1 // period
		* the same for wave 2
		gen sou_`k'_w2 = "" // source
		gen per_`k'_w2 = "" // period
	}
	drop GMD_period_w1
	order countrycode group *_w1 *_w2
	save "ssgd_gmd_`x'.dta", replace
}

* SSA w1w2
foreach x in $ssgd_w1w2_SSA{
	* w1
	use "gmd_`x'_`w1_`x''.dta", clear
	* reshape long: country and group data
	reshape long si_labfor_ si_unerat_ si_sel_ si_con_ si_wat_ si_san_ si_ele_ si_int_ si_prienr_ si_pricom_ si_secenr_ si_hea_ si_socsec_ si_femsec_ re_com_ re_cel_ re_tel_ re_rad_ re_was_ re_sew_ re_mot_ re_fri_ re_car_ re_ownlan_ re_assets_ re_mortha_, i(countrycode) j(group) string
	rename * *w1
	foreach k in sex ageg1 ageg2 ageg3 youth urban{
		rename `k'w1 `k'_w1
	}
	* data management
	foreach k in countrycode group{
		rename `k'w1 `k'
	}
	rename GMD_periodw1 GMD_period_w1
	drop GMD_sourcew1
	drop GMD_surveyw1
	foreach k in sex ageg1 ageg2 ageg3 youth urban si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha{
		* generate source and period information for each indicator in wave 1
		gen sou_`k'_w1 = "GMD" // source
		gen per_`k'_w1 = GMD_period_w1 // period
	}
	drop GMD_period_w1
	save "temp1_`x'.dta", replace
	
	* w2
	use "gmd_`x'_`w2_`x''.dta", clear
	* reshape long: country and group data
	reshape long si_labfor_ si_unerat_ si_sel_ si_con_ si_wat_ si_san_ si_ele_ si_int_ si_prienr_ si_pricom_ si_secenr_ si_hea_ si_socsec_ si_femsec_ re_com_ re_cel_ re_tel_ re_rad_ re_was_ re_sew_ re_mot_ re_fri_ re_car_ re_ownlan_ re_assets_ re_mortha_, i(countrycode) j(group) string
	rename * *w2
	foreach k in sex ageg1 ageg2 ageg3 youth urban{
		rename `k'w2 `k'_w2
	}
	* data management
	foreach k in countrycode group{
		rename `k'w2 `k'
	}
	rename GMD_periodw2 GMD_period_w2
	drop GMD_sourcew2
	drop GMD_surveyw2
	foreach k in sex ageg1 ageg2 ageg3 youth urban si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha{
		* generate source and period information for each indicator in wave 1
		gen sou_`k'_w2 = "GMD" // source
		gen per_`k'_w2 = GMD_period_w2 // period
	}
	merge 1:1 countrycode group using "temp1_`x'.dta", nogenerate
	erase "temp1_`x'.dta"
	order countrycode group *_w1 *_w2
	save "ssgd_gmd_`x'.dta", replace
}

* ----------- *
* Region: SAR *
* ----------- *

* SAR w1
foreach x in $ssgd_w1_SAR{
	* w1
	use "gmd_`x'_`w1_`x''.dta", clear
	* reshape long: country and group data
	reshape long si_labfor_ si_unerat_ si_sel_ si_con_ si_wat_ si_san_ si_ele_ si_int_ si_prienr_ si_pricom_ si_secenr_ si_hea_ si_socsec_ si_femsec_ re_com_ re_cel_ re_tel_ re_rad_ re_was_ re_sew_ re_mot_ re_fri_ re_car_ re_ownlan_ re_assets_ re_mortha_, i(countrycode) j(group) string
	rename * *w1
	foreach k in sex ageg1 ageg2 ageg3 youth urban{
		rename `k'w1 `k'_w1
	}
	* data management
	foreach k in countrycode group{
		rename `k'w1 `k'
	}
	rename GMD_periodw1 GMD_period_w1
	drop GMD_sourcew1
	drop GMD_surveyw1
	foreach k in sex ageg1 ageg2 ageg3 youth urban si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha{
		* generate lacking data for wave 2
		gen `k'_w2 = .
	}
	foreach k in sex ageg1 ageg2 ageg3 youth urban si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha{
		* generate source and period information for each indicator in wave 1
		gen sou_`k'_w1 = "GMD" // source
		gen per_`k'_w1 = GMD_period_w1 // period
		* the same for wave 2
		gen sou_`k'_w2 = "" // source
		gen per_`k'_w2 = "" // period
	}
	drop GMD_period_w1
	order countrycode group *_w1 *_w2
	save "ssgd_gmd_`x'.dta", replace
}

* SAR w1w2
foreach x in $ssgd_w1w2_SAR{
	* w1
	use "gmd_`x'_`w1_`x''.dta", clear
	* reshape long: country and group data
	reshape long si_labfor_ si_unerat_ si_sel_ si_con_ si_wat_ si_san_ si_ele_ si_int_ si_prienr_ si_pricom_ si_secenr_ si_hea_ si_socsec_ si_femsec_ re_com_ re_cel_ re_tel_ re_rad_ re_was_ re_sew_ re_mot_ re_fri_ re_car_ re_ownlan_ re_assets_ re_mortha_, i(countrycode) j(group) string
	rename * *w1
	foreach k in sex ageg1 ageg2 ageg3 youth urban{
		rename `k'w1 `k'_w1
	}
	* data management
	foreach k in countrycode group{
		rename `k'w1 `k'
	}
	rename GMD_periodw1 GMD_period_w1
	drop GMD_sourcew1
	drop GMD_surveyw1
	foreach k in sex ageg1 ageg2 ageg3 youth urban si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha{
		* generate source and period information for each indicator in wave 1
		gen sou_`k'_w1 = "GMD" // source
		gen per_`k'_w1 = GMD_period_w1 // period
	}
	drop GMD_period_w1
	save "temp1_`x'.dta", replace
	
	* w2
	use "gmd_`x'_`w2_`x''.dta", clear
	* reshape long: country and group data
	reshape long si_labfor_ si_unerat_ si_sel_ si_con_ si_wat_ si_san_ si_ele_ si_int_ si_prienr_ si_pricom_ si_secenr_ si_hea_ si_socsec_ si_femsec_ re_com_ re_cel_ re_tel_ re_rad_ re_was_ re_sew_ re_mot_ re_fri_ re_car_ re_ownlan_ re_assets_ re_mortha_, i(countrycode) j(group) string
	rename * *w2
	foreach k in sex ageg1 ageg2 ageg3 youth urban{
		rename `k'w2 `k'_w2
	}
	* data management
	foreach k in countrycode group{
		rename `k'w2 `k'
	}
	rename GMD_periodw2 GMD_period_w2
	drop GMD_sourcew2
	drop GMD_surveyw2
	foreach k in sex ageg1 ageg2 ageg3 youth urban si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha{
		* generate source and period information for each indicator in wave 1
		gen sou_`k'_w2 = "GMD" // source
		gen per_`k'_w2 = GMD_period_w2 // period
	}
	merge 1:1 countrycode group using "temp1_`x'.dta", nogenerate
	erase "temp1_`x'.dta"
	order countrycode group *_w1 *_w2
	save "ssgd_gmd_`x'.dta", replace
}

* ------------ *
* Region: MENA *
* ------------ *

* MENA w1
foreach x in $ssgd_w1_MENA{
	* w1
	use "gmd_`x'_`w1_`x''.dta", clear
	* reshape long: country and group data
	reshape long si_labfor_ si_unerat_ si_sel_ si_con_ si_wat_ si_san_ si_ele_ si_int_ si_prienr_ si_pricom_ si_secenr_ si_hea_ si_socsec_ si_femsec_ re_com_ re_cel_ re_tel_ re_rad_ re_was_ re_sew_ re_mot_ re_fri_ re_car_ re_ownlan_ re_assets_ re_mortha_, i(countrycode) j(group) string
	rename * *w1
	foreach k in sex ageg1 ageg2 ageg3 youth urban{
		rename `k'w1 `k'_w1
	}
	* data management
	foreach k in countrycode group{
		rename `k'w1 `k'
	}
	rename GMD_periodw1 GMD_period_w1
	drop GMD_sourcew1
	drop GMD_surveyw1
	foreach k in sex ageg1 ageg2 ageg3 youth urban si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha{
		* generate lacking data for wave 2
		gen `k'_w2 = .
	}
	foreach k in sex ageg1 ageg2 ageg3 youth urban si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha{
		* generate source and period information for each indicator in wave 1
		gen sou_`k'_w1 = "GMD" // source
		gen per_`k'_w1 = GMD_period_w1 // period
		* the same for wave 2
		gen sou_`k'_w2 = "" // source
		gen per_`k'_w2 = "" // period
	}
	drop GMD_period_w1
	order countrycode group *_w1 *_w2
	save "ssgd_gmd_`x'.dta", replace
}

* MENA w1w2
foreach x in $ssgd_w1w2_MENA{
	* w1
	use "gmd_`x'_`w1_`x''.dta", clear
	* reshape long: country and group data
	reshape long si_labfor_ si_unerat_ si_sel_ si_con_ si_wat_ si_san_ si_ele_ si_int_ si_prienr_ si_pricom_ si_secenr_ si_hea_ si_socsec_ si_femsec_ re_com_ re_cel_ re_tel_ re_rad_ re_was_ re_sew_ re_mot_ re_fri_ re_car_ re_ownlan_ re_assets_ re_mortha_, i(countrycode) j(group) string
	rename * *w1
	foreach k in sex ageg1 ageg2 ageg3 youth urban{
		rename `k'w1 `k'_w1
	}
	* data management
	foreach k in countrycode group{
		rename `k'w1 `k'
	}
	rename GMD_periodw1 GMD_period_w1
	drop GMD_sourcew1
	drop GMD_surveyw1
	foreach k in sex ageg1 ageg2 ageg3 youth urban si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha{
		* generate source and period information for each indicator in wave 1
		gen sou_`k'_w1 = "GMD" // source
		gen per_`k'_w1 = GMD_period_w1 // period
	}
	drop GMD_period_w1
	save "temp1_`x'.dta", replace
	
	* w2
	use "gmd_`x'_`w2_`x''.dta", clear
	* reshape long: country and group data
	reshape long si_labfor_ si_unerat_ si_sel_ si_con_ si_wat_ si_san_ si_ele_ si_int_ si_prienr_ si_pricom_ si_secenr_ si_hea_ si_socsec_ si_femsec_ re_com_ re_cel_ re_tel_ re_rad_ re_was_ re_sew_ re_mot_ re_fri_ re_car_ re_ownlan_ re_assets_ re_mortha_, i(countrycode) j(group) string
	rename * *w2
	foreach k in sex ageg1 ageg2 ageg3 youth urban{
		rename `k'w2 `k'_w2
	}
	* data management
	foreach k in countrycode group{
		rename `k'w2 `k'
	}
	rename GMD_periodw2 GMD_period_w2
	drop GMD_sourcew2
	drop GMD_surveyw2
	foreach k in sex ageg1 ageg2 ageg3 youth urban si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha{
		* generate source and period information for each indicator in wave 1
		gen sou_`k'_w2 = "GMD" // source
		gen per_`k'_w2 = GMD_period_w2 // period
	}
	merge 1:1 countrycode group using "temp1_`x'.dta", nogenerate
	erase "temp1_`x'.dta"
	order countrycode group *_w1 *_w2
	save "ssgd_gmd_`x'.dta", replace
}

* ----------- *
* Region: LAC *
* ----------- *

* LAC w1w2
foreach x in $ssgd_w1w2_LAC{
	* w1
	use "gmd_`x'_`w1_`x''.dta", clear
	* reshape long: country and group data
	reshape long si_labfor_ si_unerat_ si_sel_ si_con_ si_wat_ si_san_ si_ele_ si_int_ si_prienr_ si_pricom_ si_secenr_ si_hea_ si_socsec_ si_femsec_ re_com_ re_cel_ re_tel_ re_rad_ re_was_ re_sew_ re_mot_ re_fri_ re_car_ re_ownlan_ re_assets_ re_mortha_, i(countrycode) j(group) string
	rename * *w1
	foreach k in sex ageg1 ageg2 ageg3 youth urban{
		rename `k'w1 `k'_w1
	}
	* data management
	foreach k in countrycode group{
		rename `k'w1 `k'
	}
	rename GMD_periodw1 GMD_period_w1
	drop GMD_sourcew1
	drop GMD_surveyw1
	foreach k in sex ageg1 ageg2 ageg3 youth urban si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha{
		* generate source and period information for each indicator in wave 1
		gen sou_`k'_w1 = "GMD" // source
		gen per_`k'_w1 = GMD_period_w1 // period
	}
	drop GMD_period_w1
	save "temp1_`x'.dta", replace
	
	* w2
	use "gmd_`x'_`w2_`x''.dta", clear
	* reshape long: country and group data
	reshape long si_labfor_ si_unerat_ si_sel_ si_con_ si_wat_ si_san_ si_ele_ si_int_ si_prienr_ si_pricom_ si_secenr_ si_hea_ si_socsec_ si_femsec_ re_com_ re_cel_ re_tel_ re_rad_ re_was_ re_sew_ re_mot_ re_fri_ re_car_ re_ownlan_ re_assets_ re_mortha_, i(countrycode) j(group) string
	rename * *w2
	foreach k in sex ageg1 ageg2 ageg3 youth urban{
		rename `k'w2 `k'_w2
	}
	* data management
	foreach k in countrycode group{
		rename `k'w2 `k'
	}
	rename GMD_periodw2 GMD_period_w2
	drop GMD_sourcew2
	drop GMD_surveyw2
	foreach k in sex ageg1 ageg2 ageg3 youth urban si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha{
		* generate source and period information for each indicator in wave 1
		gen sou_`k'_w2 = "GMD" // source
		gen per_`k'_w2 = GMD_period_w2 // period
	}
	merge 1:1 countrycode group using "temp1_`x'.dta", nogenerate
	erase "temp1_`x'.dta"
	order countrycode group *_w1 *_w2
	save "ssgd_gmd_`x'.dta", replace
}

* ----------- *
* Region: ECA *
* ----------- *

* ECA w1
foreach x in $ssgd_w1_ECA{
	* w1
	use "gmd_`x'_`w1_`x''.dta", clear
	* reshape long: country and group data
	reshape long si_labfor_ si_unerat_ si_sel_ si_con_ si_wat_ si_san_ si_ele_ si_int_ si_prienr_ si_pricom_ si_secenr_ si_hea_ si_socsec_ si_femsec_ re_com_ re_cel_ re_tel_ re_rad_ re_was_ re_sew_ re_mot_ re_fri_ re_car_ re_ownlan_ re_assets_ re_mortha_, i(countrycode) j(group) string
	rename * *w1
	foreach k in sex ageg1 ageg2 ageg3 youth urban{
		rename `k'w1 `k'_w1
	}
	* data management
	foreach k in countrycode group{
		rename `k'w1 `k'
	}
	rename GMD_periodw1 GMD_period_w1
	drop GMD_sourcew1
	drop GMD_surveyw1
	foreach k in sex ageg1 ageg2 ageg3 youth urban si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha{
		* generate lacking data for wave 2
		gen `k'_w2 = .
	}
	foreach k in sex ageg1 ageg2 ageg3 youth urban si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha{
		* generate source and period information for each indicator in wave 1
		gen sou_`k'_w1 = "GMD" // source
		gen per_`k'_w1 = GMD_period_w1 // period
		* the same for wave 2
		gen sou_`k'_w2 = "" // source
		gen per_`k'_w2 = "" // period
	}
	drop GMD_period_w1
	order countrycode group *_w1 *_w2
	save "ssgd_gmd_`x'.dta", replace
}

* ECA w1w2
foreach x in $ssgd_w1w2_ECA{
	* w1
	use "gmd_`x'_`w1_`x''.dta", clear
	* reshape long: country and group data
	reshape long si_labfor_ si_unerat_ si_sel_ si_con_ si_wat_ si_san_ si_ele_ si_int_ si_prienr_ si_pricom_ si_secenr_ si_hea_ si_socsec_ si_femsec_ re_com_ re_cel_ re_tel_ re_rad_ re_was_ re_sew_ re_mot_ re_fri_ re_car_ re_ownlan_ re_assets_ re_mortha_, i(countrycode) j(group) string
	rename * *w1
	foreach k in sex ageg1 ageg2 ageg3 youth urban{
		rename `k'w1 `k'_w1
	}
	* data management
	foreach k in countrycode group{
		rename `k'w1 `k'
	}
	rename GMD_periodw1 GMD_period_w1
	drop GMD_sourcew1
	drop GMD_surveyw1
	foreach k in sex ageg1 ageg2 ageg3 youth urban si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha{
		* generate source and period information for each indicator in wave 1
		gen sou_`k'_w1 = "GMD" // source
		gen per_`k'_w1 = GMD_period_w1 // period
	}
	drop GMD_period_w1
	save "temp1_`x'.dta", replace
	
	* w2
	use "gmd_`x'_`w2_`x''.dta", clear
	* reshape long: country and group data
	reshape long si_labfor_ si_unerat_ si_sel_ si_con_ si_wat_ si_san_ si_ele_ si_int_ si_prienr_ si_pricom_ si_secenr_ si_hea_ si_socsec_ si_femsec_ re_com_ re_cel_ re_tel_ re_rad_ re_was_ re_sew_ re_mot_ re_fri_ re_car_ re_ownlan_ re_assets_ re_mortha_, i(countrycode) j(group) string
	rename * *w2
	foreach k in sex ageg1 ageg2 ageg3 youth urban{
		rename `k'w2 `k'_w2
	}
	* data management
	foreach k in countrycode group{
		rename `k'w2 `k'
	}
	rename GMD_periodw2 GMD_period_w2
	drop GMD_sourcew2
	drop GMD_surveyw2
	foreach k in sex ageg1 ageg2 ageg3 youth urban si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha{
		* generate source and period information for each indicator in wave 1
		gen sou_`k'_w2 = "GMD" // source
		gen per_`k'_w2 = GMD_period_w2 // period
	}
	merge 1:1 countrycode group using "temp1_`x'.dta", nogenerate
	erase "temp1_`x'.dta"
	order countrycode group *_w1 *_w2
	save "ssgd_gmd_`x'.dta", replace
}

* ----------- *
* Region: EAP *
* ----------- *

* EAP w1
foreach x in $ssgd_w1_EAP{
	* w1
	use "gmd_`x'_`w1_`x''.dta", clear
	if ("`x'"=="TON"){
		mi unset, asis
	}
	* reshape long: country and group data
	reshape long si_labfor_ si_unerat_ si_sel_ si_con_ si_wat_ si_san_ si_ele_ si_int_ si_prienr_ si_pricom_ si_secenr_ si_hea_ si_socsec_ si_femsec_ re_com_ re_cel_ re_tel_ re_rad_ re_was_ re_sew_ re_mot_ re_fri_ re_car_ re_ownlan_ re_assets_ re_mortha_, i(countrycode) j(group) string
	rename * *w1
	foreach k in sex ageg1 ageg2 ageg3 youth urban{
		rename `k'w1 `k'_w1
	}
	* data management
	foreach k in countrycode group{
		rename `k'w1 `k'
	}
	rename GMD_periodw1 GMD_period_w1
	drop GMD_sourcew1
	drop GMD_surveyw1
	foreach k in sex ageg1 ageg2 ageg3 youth urban si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha{
		* generate lacking data for wave 2
		gen `k'_w2 = .
	}
	foreach k in sex ageg1 ageg2 ageg3 youth urban si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha{
		* generate source and period information for each indicator in wave 1
		gen sou_`k'_w1 = "GMD" // source
		gen per_`k'_w1 = GMD_period_w1 // period
		* the same for wave 2
		gen sou_`k'_w2 = "" // source
		gen per_`k'_w2 = "" // period
	}
	drop GMD_period_w1
	order countrycode group *_w1 *_w2
	save "ssgd_gmd_`x'.dta", replace
}

* EAP w2
foreach x in $ssgd_w2_EAP{
	* w1
	use "gmd_`x'_`w2_`x''.dta", clear
	* reshape long: country and group data
	reshape long si_labfor_ si_unerat_ si_sel_ si_con_ si_wat_ si_san_ si_ele_ si_int_ si_prienr_ si_pricom_ si_secenr_ si_hea_ si_socsec_ si_femsec_ re_com_ re_cel_ re_tel_ re_rad_ re_was_ re_sew_ re_mot_ re_fri_ re_car_ re_ownlan_ re_assets_ re_mortha_, i(countrycode) j(group) string
	rename * *w2
	foreach k in sex ageg1 ageg2 ageg3 youth urban{
		rename `k'w2 `k'_w2
	}
	* data management
	foreach k in countrycode group{
		rename `k'w2 `k'
	}
	rename GMD_periodw2 GMD_period_w2
	drop GMD_sourcew2
	drop GMD_surveyw2
	foreach k in sex ageg1 ageg2 ageg3 youth urban si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha{
		* generate lacking data for wave 1
		gen `k'_w1 = .
	}
	foreach k in sex ageg1 ageg2 ageg3 youth urban si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha{
		* generate source and period information for each indicator in wave 1
		gen sou_`k'_w2 = "GMD" // source
		gen per_`k'_w2 = GMD_period_w2 // period
		* the same for wave 2
		gen sou_`k'_w1 = "" // source
		gen per_`k'_w1 = "" // period
	}
	drop GMD_period_w2
	order countrycode group *_w1 *_w2
	save "ssgd_gmd_`x'.dta", replace
}

* EAP w1w2
foreach x in $ssgd_w1w2_EAP{
	* w1
	use "gmd_`x'_`w1_`x''.dta", clear
	* reshape long: country and group data
	reshape long si_labfor_ si_unerat_ si_sel_ si_con_ si_wat_ si_san_ si_ele_ si_int_ si_prienr_ si_pricom_ si_secenr_ si_hea_ si_socsec_ si_femsec_ re_com_ re_cel_ re_tel_ re_rad_ re_was_ re_sew_ re_mot_ re_fri_ re_car_ re_ownlan_ re_assets_ re_mortha_, i(countrycode) j(group) string
	rename * *w1
	foreach k in sex ageg1 ageg2 ageg3 youth urban{
		rename `k'w1 `k'_w1
	}
	* data management
	foreach k in countrycode group{
		rename `k'w1 `k'
	}
	rename GMD_periodw1 GMD_period_w1
	drop GMD_sourcew1
	drop GMD_surveyw1
	foreach k in sex ageg1 ageg2 ageg3 youth urban si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha{
		* generate source and period information for each indicator in wave 1
		gen sou_`k'_w1 = "GMD" // source
		gen per_`k'_w1 = GMD_period_w1 // period
	}
	drop GMD_period_w1
	save "temp1_`x'.dta", replace
	
	* w2
	use "gmd_`x'_`w2_`x''.dta", clear
	* reshape long: country and group data
	reshape long si_labfor_ si_unerat_ si_sel_ si_con_ si_wat_ si_san_ si_ele_ si_int_ si_prienr_ si_pricom_ si_secenr_ si_hea_ si_socsec_ si_femsec_ re_com_ re_cel_ re_tel_ re_rad_ re_was_ re_sew_ re_mot_ re_fri_ re_car_ re_ownlan_ re_assets_ re_mortha_, i(countrycode) j(group) string
	rename * *w2
	foreach k in sex ageg1 ageg2 ageg3 youth urban{
		rename `k'w2 `k'_w2
	}
	* data management
	foreach k in countrycode group{
		rename `k'w2 `k'
	}
	rename GMD_periodw2 GMD_period_w2
	drop GMD_sourcew2
	drop GMD_surveyw2
	foreach k in sex ageg1 ageg2 ageg3 youth urban si_labfor si_unerat si_sel si_con si_wat si_san si_ele si_int si_prienr si_pricom si_secenr si_hea si_socsec si_femsec re_com re_cel re_tel re_rad re_was re_sew re_mot re_fri re_car re_ownlan re_assets re_mortha{
		* generate source and period information for each indicator in wave 1
		gen sou_`k'_w2 = "GMD" // source
		gen per_`k'_w2 = GMD_period_w2 // period
	}
	merge 1:1 countrycode group using "temp1_`x'.dta", nogenerate
	erase "temp1_`x'.dta"
	order countrycode group *_w1 *_w2
	save "ssgd_gmd_`x'.dta", replace
}

local i = 0
foreach x in $ssgd_w1_SSA $ssgd_w1w2_SSA $ssgd_w1_SAR $ssgd_w1w2_SAR $ssgd_w1_MENA $ssgd_w1w2_MENA $ssgd_w1w2_LAC $ssgd_w1_ECA $ssgd_w1w2_ECA $ssgd_w1_EAP $ssgd_w2_EAP $ssgd_w1w2_EAP{
	local i = `i' + 1
	if (`i'==1){
		use "ssgd_gmd_`x'.dta", clear
	}
	else{
		append using "ssgd_gmd_`x'.dta"
	}
	erase "ssgd_gmd_`x'.dta"
}

* corrections
foreach x in sex ageg1 ageg2 ageg3 youth urban{
	forvalues t = 1/2{
		replace `x'_w`t' = . if group!="nat"
	}
}

*rename *_ *
save "ssgd_gmd.dta", replace
