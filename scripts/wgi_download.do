clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\wgi"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

* ------------ *
* WGI database *
* ------------ *

cd "$raw_data"

global wdi_indicators "rl.est; cc.est; ge.est"

wbopendata, language(en - English) country() topics() indicator($wdi_indicators) clear

drop if regionname=="Aggregates"
drop if regionname==""

keep indicatorname indicatorcode countryname countrycode yr2015-yr2021

rename indicatorname seriesname
rename indicatorcode seriescode

order seriesname seriescode countryname countrycode yr*

export excel using "P_Data_Extract_From_Worldwide_Governance_Indicators.xlsx", sheet("Data") firstrow(variables) replace
