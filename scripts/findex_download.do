clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\findex"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

* --------------- *
* FINDEX database *
* --------------- *

cd "$raw_data"

global findex_indicators "account.t.d; account.t.d.1; account.t.d.2; account.t.d.4; account.t.d.9; account.t.d.10; account.t.d.3"

wbopendata, language(en - English) country() topics() indicator($findex_indicators) clear

drop if regionname=="Aggregates"
drop yr2022

keep indicatorname indicatorcode countryname countrycode yr*

rename indicatorname seriesname
rename indicatorcode seriescode

order seriesname seriescode countryname countrycode yr*

export excel using "P_Data_Extract_From_Global_Financial_Inclusion.xlsx", sheet("Data") firstrow(variables) replace
