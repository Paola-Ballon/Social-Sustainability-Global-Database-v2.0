clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\external\esg"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

* ------------ *
* ESG database *
* ------------ *

cd "$raw_data"

global esg_indicators "ag.lnd.frls.ha; ag.lnd.frst.zs; eg.egy.prim.pp.kd; en.atm.co2e.pc; en.clc.cddy.xd; en.clc.hddy.xd; er.h2o.fwst.zs; ic.lgl.cred.xq; va.est; sd.esr.perf.xq; it.net.user.zs; sl.tlf.cact.fm.zs; se.enr.prsc.fm.zs; sp.uwt.tfrt; rq.est; ip.pat.resd; gb.xpd.rsdv.gd.zs; ip.jrn.artc.sc; sm.pop.netm; pv.est"

wbopendata, language(en - English) country() topics() indicator($esg_indicators) clear

drop if regionname=="Aggregates"
drop if regionname==""

keep indicatorname indicatorcode countryname countrycode yr2015-yr2022

rename indicatorname seriesname
rename indicatorcode seriescode

order seriesname seriescode countryname countrycode yr*

export excel using "P_Data_Extract_From_Environment_Social_and_Governance_(ESG)_Data.xlsx", sheet("Data") firstrow(variables) replace
