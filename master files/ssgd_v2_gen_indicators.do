* ======================================= *
* Generating indicators for the SSGD v2.0
* Consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* ======================================= *

* ----------- *
* Indications *
* ----------- *

* 1. Press Ctrl + D to run this Stata do file

* Macros
global scripts "${ssgd_v2_userpath}\SSGD v2.0\scripts\"

* GMD
do "$scripts\gmd_all_MENA.do"
do "$scripts\gmd_all_ECA.do"
do "$scripts\gmd_all_LAC.do"
do "$scripts\gmd_all_SAR.do"
do "$scripts\gmd_all_SSA.do"
do "$scripts\gmd_all_EAP.do"

* AF
do "$scripts\afrobarometer7.do"
do "$scripts\afrobarometer8.do"

* AB
do "$scripts\arabbarometer5.do"
do "$scripts\arabbarometer6_p1.do"
do "$scripts\arabbarometer6_p2.do"
do "$scripts\arabbarometer6_p3.do"
do "$scripts\arabbarometer7.do"

* ASB
do "$scripts\asianbarometer4.do"
do "$scripts\asianbarometer5.do"

* LB
do "$scripts\latinobarometro2017.do"
do "$scripts\latinobarometro2018.do"
do "$scripts\latinobarometro2020.do"

* ACLED
do "$scripts\acled_all.do"

* CIVICUS
do "$scripts\civicus_all.do"

* EMDAT
do "$scripts\emdat_all.do"

* FINDEX
do "$scripts\findex_all.do"

* WDI
do "$scripts\wdi_all.do"

* WGI
do "$scripts\wgi_all.do"

* WJP
do "$scripts\wjp_all.do"

* WVS
do "$scripts\wvs6.do"
do "$scripts\wvs7.do"

* EVS
do "$scripts\evs_all.do"

* External
do "$scripts\external_all.do"
