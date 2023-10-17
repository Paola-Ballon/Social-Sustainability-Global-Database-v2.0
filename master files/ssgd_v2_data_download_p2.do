* =================================================== *
* Automatic download for the SSGD v2.0 input datasets
* Consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* =================================================== *

* ----------- *
* Indications *
* ----------- *

* 1. Press Ctrl + D to run this Stata do file

* Macros
global scripts "${ssgd_v2_userpath}\SSGD v2.0\scripts\"

* GMD databases
do "$scripts\gmd_download_EAP.do"
do "$scripts\gmd_download_ECA.do"
do "$scripts\gmd_download_LAC.do"
do "$scripts\gmd_download_MENA.do"
do "$scripts\gmd_download_SAR.do"
do "$scripts\gmd_download_SSA.do"

* WGI
do "$scripts\wgi_download.do"

* WDI
do "$scripts\wdi_download.do"

* FINDEX
do "$scripts\findex_download.do"

* External: ESG
do "$scripts\external_esg_download.do"

* External: WDI
do "$scripts\external_wdi_download.do"

noi disp as error _newline "Now please run the ssgd_v2_gen_indicators.do file"
