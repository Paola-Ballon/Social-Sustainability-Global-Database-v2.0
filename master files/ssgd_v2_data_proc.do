* ======================================= *
* Processing indicators for the SSGD v2.0
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
do "$scripts\gmd_data_processing.do"

* AF
do "$scripts\afrobarometer_data_processing.do"

* AB
do "$scripts\arabbarometer_data_processing.do"

* ASB
do "$scripts\asianbarometer_data_processing.do"

* LB
do "$scripts\latinobarometro_data_processing.do"

* ACLED
do "$scripts\acled_data_processing.do"

* CIVICUS
do "$scripts\civicus_data_processing.do"

* EMDAT
do "$scripts\emdat_data_processing.do"

* FINDEX
do "$scripts\findex_data_processing.do"

* WDI
do "$scripts\wdi_data_processing.do"

* WGI
do "$scripts\wgi_data_processing.do"

* WJP
do "$scripts\wjp_data_processing.do"

* WVS
do "$scripts\wvs_data_processing.do"

* EVS
do "$scripts\evs_data_processing.do"

* External
do "$scripts\external_data_processing.do"
