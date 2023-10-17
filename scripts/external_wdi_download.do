clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\external\wdi"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

* ------------ *
* WDI database *
* ------------ *

cd "$raw_data"

global wdi_indicators "ny.gdp.pcap.kd.zg; sp.dyn.tfrt.in; ny.gdp.pcap.pp.kd; si.pov.mdim; hd.hci.ovrl; hd.hci.ovrl.fe; hd.hci.ovrl.ma; si.pov.nahc; si.pov.gini; sp.urb.totl.in.zs; si.spr.pc40.zg; si.spr.pcap.zg; sp.reg.brth.zs; se.pre.enrr; sh.dyn.mort"

wbopendata, language(en - English) country() topics() indicator($wdi_indicators) clear

drop if regionname=="Aggregates"
drop if regionname==""

keep indicatorname indicatorcode countryname countrycode yr2015-yr2022

rename indicatorname seriesname
rename indicatorcode seriescode

order seriesname seriescode countryname countrycode yr*

export excel using "P_Data_Extract_From_World_Development_Indicators.xlsx", sheet("Data") firstrow(variables) replace
