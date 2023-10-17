* =================================================== *
* Social Sustainability Global Database v2.0
* User Profile
* Consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* =================================================== *

* ------------- *
* General setup *
* ------------- *

clear all
set more off
capture log close _all
version 16

* ----------- *
* Indications *
* ----------- *

* 1. In line 24, please declare the path where the "SSGD v2.0" GitHub folder was copied in your computer.
* 2. After that, press Ctrl + D to run this Stata do file

global ssgd_v2_userpath "C:\Users\PC\Desktop"

noi disp as error _newline "Now please run the ssgd_v2_data_download_p1.R file"
