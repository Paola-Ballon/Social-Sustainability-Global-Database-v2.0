* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* last update: March 26th, 2024
* original data source: https://www.asianbarometer.org/data?page=d10

/*
Issues:
	- No information on disability [subgroup]
	- No information on ethnicity for Japan and Hong Kong [subgroup]
	- No information on active membership in an organization for China [variable]
	- No information on trust in the election comission for China, Indonesia and Singapore [variable]
	- No information on trust in the local government for Singapore [variable]
	- No information on attendance to a demonstration or protest for Vietnam [variable]
	- No information on vote in recent elections for Vietnam [variable]
*/

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\asianbarometer4"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

* -------------------- *
* Data standardization *
* -------------------- *

cd "$raw_data"

use "W4_v15_merged20181211_release.dta", clear

* ------------------------------------ *
* Administrative divisions corrections *
* ------------------------------------ *

decode region, g(t1)
drop region
rename t1 region

* Japan (1)
* Southern Kyushu expansion
expand 2 if country==1 & region=="Southern Kyushu", generate(t1)
replace region = "Kagosima" if country==1 & region=="Southern Kyushu" & t1==1
drop t1
expand 2 if country==1 & region=="Southern Kyushu", g(t1)
replace region = "Miyazaki" if country==1 & region=="Southern Kyushu" & t1==1
drop t1
replace region = "Okinawa" if country==1 & region=="Southern Kyushu"
* Northern Kyushu expansion
expand 2 if country==1 & region=="Northern Kyushu", g(t1)
replace region = "Hukuoka" if country==1 & region=="Northern Kyushu" & t1==1
drop t1
expand 2 if country==1 & region=="Northern Kyushu", g(t1)
replace region = "Kumamoto" if country==1 & region=="Northern Kyushu" & t1==1
drop t1
expand 2 if country==1 & region=="Northern Kyushu", g(t1)
replace region = "Nagasaki" if country==1 & region=="Northern Kyushu" & t1==1
drop t1
expand 2 if country==1 & region=="Northern Kyushu", g(t1)
replace region = "Ooita" if country==1 & region=="Northern Kyushu" & t1==1
drop t1
replace region = "Saga" if country==1 & region=="Northern Kyushu"
* Tokai Tohaku Shikoku Kinki Kanto Hokuriku Chugoku expansion (general)
local Tokai "Aiti Gifu Sizuoka"
local Tohaku "Akita Aomori Hukusima Iwate Miyagi Yamagata"
local Shikoku "Ehime Kagawa Kooti Tokusima"
local Kinki "Hyoogo Kyooto Mie Nara Oosaka Siga Wakayama"
local Kanto "Gunma Ibaraki Kanagawa Saitama Totigi Tookyoo Tiba"
local Hokuriku "Hukui Isikawa Niigata Toyama"
local Chugoku "Hirosima Okayama Simane Tottori Yamaguti"
global elements "Tokai Tohaku Shikoku Kinki Kanto Hokuriku Chugoku"
foreach z in $elements{
	local count_`z' = `: word count ``z'''
	local i = 0
	foreach x of local `z'{
		local i = `i' + 1
		if (`i'!=`count_`z''){
			expand 2 if country==1 & region=="`z'", g(t1)
			replace region = "`x'" if country==1 & region=="`z'" & t1==1
			drop t1
		}
		else{
			replace region = "`x'" if country==1 & region=="`z'"
		}
	}
}
set obs 24715
replace country = 1 if _n==24714
replace region = "Nagano" if country==1 & _n==24714
replace country = 1 if _n==24715
replace region = "Yamanasi" if country==1 & _n==24715
replace region = "Hokkaidoo" if country==1 & region=="Hokkaido"

* Hong Kong (2)
drop if country==2 // Administrative unit not available

* South Korea (3)
* Yeongnam Sudogwon Hoseo Honam Gwangong expansion (general)
local Yeongnam "Kyongsangbuk-do Kyongsangnam-do Pusan Taegu"
local Sudogwon "Inchon Kyonggi-do"
local Hoseo "Chungchongbuk-do Chungchongnam-do Taejon"
local Honam "Chollabuk-do Chollanam-do Kwangju"
local Gwangong "Cheju-do Kang-won-do"
global elements "Yeongnam Sudogwon Hoseo Honam Gwangong"
foreach z in $elements{
	local count_`z' = `: word count ``z'''
	local i = 0
	foreach x of local `z'{
		local i = `i' + 1
		if (`i'!=`count_`z''){
			expand 2 if country==3 & region=="`z'", g(t1)
			replace region = "`x'" if country==3 & region=="`z'" & t1==1
			drop t1
		}
		else{
			replace region = "`x'" if country==3 & region=="`z'"
		}
	}
}

* China (4)
* Southwest expansion
expand 2 if country==4 & region=="Southwest", g(t1)
replace region = "Chongqing Shi" if country==4 & region=="Southwest" & t1==1
drop t1
expand 2 if country==4 & region=="Southwest", g(t1)
replace region = "Guizhou Sheng" if country==4 & region=="Southwest" & t1==1
drop t1
expand 2 if country==4 & region=="Southwest", g(t1)
replace region = "Sichuan Sheng" if country==4 & region=="Southwest" & t1==1
drop t1
expand 2 if country==4 & region=="Southwest", g(t1)
replace region = "Xizang Zizhiqu" if country==4 & region=="Southwest" & t1==1
drop t1
replace region = "Yunnan Sheng" if country==4 & region=="Southwest"
* South Central expansion
expand 2 if country==4 & region=="South Central", g(t1)
replace region = "Guangdong Sheng" if country==4 & region=="South Central" & t1==1
drop t1
expand 2 if country==4 & region=="South Central", g(t1)
replace region = "Guangxi Zhuangzu Zizhiqu" if country==4 & region=="South Central" & t1==1
drop t1
expand 2 if country==4 & region=="South Central", g(t1)
replace region = "Hainan Sheng" if country==4 & region=="South Central" & t1==1
drop t1
expand 2 if country==4 & region=="South Central", g(t1)
replace region = "Henan Sheng" if country==4 & region=="South Central" & t1==1
drop t1
expand 2 if country==4 & region=="South Central", g(t1)
replace region = "Hubei Sheng" if country==4 & region=="South Central" & t1==1
drop t1
replace region = "Hunan Sheng" if country==4 & region=="South Central"
* Northwest expansion
expand 2 if country==4 & region=="Northwest", g(t1)
replace region = "Gansu Sheng" if country==4 & region=="Northwest" & t1==1
drop t1
expand 2 if country==4 & region=="Northwest", g(t1)
replace region = "Ningxia Huizu Zizhiqu" if country==4 & region=="Northwest" & t1==1
drop t1
expand 2 if country==4 & region=="Northwest", g(t1)
replace region = "Qinghai Sheng" if country==4 & region=="Northwest" & t1==1
drop t1
expand 2 if country==4 & region=="Northwest", g(t1)
replace region = "Shaanxi Sheng" if country==4 & region=="Northwest" & t1==1
drop t1
replace region = "Xinjiang Uygur Zizhiqu" if country==4 & region=="Northwest"
* Northeast
expand 2 if country==4 & region=="Northeast", g(t1)
replace region = "Heilongjiang Sheng" if country==4 & region=="Northeast" & t1==1
drop t1
expand 2 if country==4 & region=="Northeast", g(t1)
replace region = "Jilin Sheng" if country==4 & region=="Northeast" & t1==1
drop t1
replace region = "Liaoning Sheng" if country==4 & region=="Northeast"
* North expansion
expand 2 if country==4 & region=="North", g(t1)
replace region = "Beijing Shi" if country==4 & region=="North" & t1==1
drop t1
expand 2 if country==4 & region=="North", g(t1)
replace region = "Hebei Sheng" if country==4 & region=="North" & t1==1
drop t1
expand 2 if country==4 & region=="North", g(t1)
replace region = "Nei Mongol Zizhiqu" if country==4 & region=="North" & t1==1
drop t1
expand 2 if country==4 & region=="North", g(t1)
replace region = "Shanxi Sheng" if country==4 & region=="North" & t1==1
drop t1
replace region = "Tianjin Shi" if country==4 & region=="North"
* East expansion
expand 2 if country==4 & region=="East", g(t1)
replace region = "Anhui Sheng" if country==4 & region=="East" & t1==1
drop t1
expand 2 if country==4 & region=="East", g(t1)
replace region = "Fujian Sheng" if country==4 & region=="East" & t1==1
drop t1
expand 2 if country==4 & region=="East", g(t1)
replace region = "Jiangsu Sheng" if country==4 & region=="East" & t1==1
drop t1
expand 2 if country==4 & region=="East", g(t1)
replace region = "Jiangxi Sheng" if country==4 & region=="East" & t1==1
drop t1
expand 2 if country==4 & region=="East", g(t1)
replace region = "Shandong Sheng" if country==4 & region=="East" & t1==1
drop t1
expand 2 if country==4 & region=="East", g(t1)
replace region = "Shanghai Shi" if country==4 & region=="East" & t1==1
drop t1
replace region = "Zhejiang Sheng" if country==4 & region=="East"

* Mongolia (5)
* Western: Bayan-O'lgii
expand 2 if country==5 & region=="Western", g(t1)
replace region = "Bayan-O'lgii" if country==5 & region=="Western" & t1==1
drop t1
* Southern: Govisu'mber / O'mnogovi
expand 2 if country==5 & region=="Southern", g(t1)
replace region = "Govisu'mber" if country==5 & region=="Southern" & t1==1
drop t1
expand 2 if country==5 & region=="Southern", g(t1)
replace region = "O'mnogovi" if country==5 & region=="Southern" & t1==1
drop t1
* Northern: Xo'vsgol
expand 2 if country==5 & region=="Northern", g(t1)
replace region = "Xo'vsgol" if country==5 & region=="Northern" & t1==1
drop t1
* Eastern: Su'xbaatar
expand 2 if country==5 & region=="Eastern", g(t1)
replace region = "Su'xbaatar" if country==5 & region=="Eastern" & t1==1
drop t1
* Western Southern Northern Eastern (general)
local Western "Govi-Altai Uvs Xovd Zavxan"
local Southern "Bayanxongor Dornogovi"
local Northern "Arxangai Bulgan Darxan-Uul Orxon Selenge"
local Eastern "Dornod Xentii"
global elements "Western Southern Northern Eastern"
foreach z in $elements{
	local count_`z' = `: word count ``z'''
	local i = 0
	foreach x of local `z'{
		local i = `i' + 1
		if (`i'!=`count_`z''){
			expand 2 if country==5 & region=="`z'", g(t1)
			replace region = "`x'" if country==5 & region=="`z'" & t1==1
			drop t1
		}
		else{
			replace region = "`x'" if country==5 & region=="`z'"
		}
	}
}
replace region = "To'v" if country==5 & region=="Central I"
replace region = "O'vorxangai" if country==5 & region=="Central II"
replace region = "Dundgovi" if country==5 & region=="Central III"

* Philippines (6)
* Visayas expansion
expand 2 if country==6 & region=="Visayas", g(t1)
replace region = "Region VI (Western Visayas)" if country==6 & region=="Visayas" & t1==1
drop t1
expand 2 if country==6 & region=="Visayas", g(t1)
replace region = "Region VII (Central Visayas)" if country==6 & region=="Visayas" & t1==1
drop t1
replace region = "Region VIII (Eastern Visayas)" if country==6 & region=="Visayas"
* Mindanao expansion
expand 2 if country==6 & region=="Mindanao", g(t1)
replace region = "Region XIII (Caraga)" if country==6 & region=="Mindanao" & t1==1
drop t1
expand 2 if country==6 & region=="Mindanao", g(t1)
replace region = "Autonomous region in Muslim Mindanao (ARMM)" if country==6 & region=="Mindanao" & t1==1
drop t1
expand 2 if country==6 & region=="Mindanao", g(t1)
replace region = "Region IX (Zamboanga Peninsula)" if country==6 & region=="Mindanao" & t1==1
drop t1
expand 2 if country==6 & region=="Mindanao", g(t1)
replace region = "Region X (Northern Mindanao)" if country==6 & region=="Mindanao" & t1==1
drop t1
expand 2 if country==6 & region=="Mindanao", g(t1)
replace region = "Region XI (Davao Region)" if country==6 & region=="Mindanao" & t1==1
drop t1
replace region = "Region XII (Soccsksargen)" if country==6 & region=="Mindanao"
* Balance Luzon expansion
expand 2 if country==6 & region=="Balance Luzon", g(t1)
replace region = "Cordillera Administrative region (CAR)" if country==6 & region=="Balance Luzon" & t1==1
drop t1
expand 2 if country==6 & region=="Balance Luzon", g(t1)
replace region = "Region I (Ilocos region)" if country==6 & region=="Balance Luzon" & t1==1
drop t1
expand 2 if country==6 & region=="Balance Luzon", g(t1)
replace region = "Region II (Cagayan Valley)" if country==6 & region=="Balance Luzon" & t1==1
drop t1
expand 2 if country==6 & region=="Balance Luzon", g(t1)
replace region = "Region V (Bicol region)" if country==6 & region=="Balance Luzon" & t1==1
drop t1
expand 2 if country==6 & region=="Balance Luzon", g(t1)
replace region = "Region III (Central Luzon)" if country==6 & region=="Balance Luzon" & t1==1
drop t1
expand 2 if country==6 & region=="Balance Luzon", g(t1)
replace region = "Region IV-A (Calabarzon)" if country==6 & region=="Balance Luzon" & t1==1
drop t1
replace region = "Region IV (Southern Tagalog)" if country==6 & region=="Balance Luzon"
replace region = "National Capital region (NCR)" if country==6 & region=="ncr"

* Taiwan (7)
drop if country==7 // Administrative unit not available

* Thailand (8)
* South Northeast North Central expansion
local South "Chumphon Krabi Nakhon_Si_Thammarat Narathiwat Pattani Phangnga Phatthalung Phuket Ranong Satun Songkhla Surat_Thani Trang Yala"
local Northeast "Buriram Chaiyaphum Kalasin Khon_Kaen Loei Maha_Sarakham Mukdahan Nakhon_Phanom Nakhon_Ratchasima Nong_Khai Roi_Et Sakon_Nakhon Si_Saket Surin Yasothon Amnat_Charoen Nong_Bua_Lamphu Ubon_Ratchathani Udon_Thani"
local North "Chiang_Mai Chiang_Rai Kampaeng_Phet Lampang Lamphun Mae_Hong_Son Nakhon_Sawan Nan Phayao Phetchabun Phichit Phitsanulok Phrae Sukhothai Tak Uthai_Thani Uttaradit"
local Central "Ang_Thong Chachoengsao Chainat Chanthaburi Chonburi Kanchanaburi Lopburi Nakhon_Nayok Nakhon_Pathom Nonthaburi Pathum_Thani Phetchaburi Phra_Nakhon_Si_Ayudhya Prachuap_Khilikhan Ratchaburi Rayong Samut_Prakarn Samut_Sakhon Samut_Songkham Saraburi Singburi Suphanburi Trad Phachinburi Sa_Kaeo"
global elements "South Northeast North Central"
foreach z in $elements{
	local count_`z' = `: word count ``z'''
	local i = 0
	foreach x of local `z'{
		local i = `i' + 1
		if (`i'!=`count_`z''){
			expand 2 if country==8 & region=="`z'", g(t1)
			replace region = "`x'" if country==8 & region=="`z'" & t1==1
			drop t1
		}
		else{
			replace region = "`x'" if country==8 & region=="`z'"
		}
	}
}
replace region = subinstr(region, "_", " ", .) if country==8

* Indonesia (9)
replace region = subinstr(region, " ", "_", .) if country==9
* Western_New_Guinea Sumatra Sulawesi Maluk_Islands Lesser_Sunda_Islands Kalimantan Java expansion
local Western_New_Guinea "Papua_Barat Papua"
local Sumatra "Sumatera_Utara Sumatera_Selatan Sumatera_Barat Riau Nangroe_Aceh_Darussalam Lampung Kepulauan-riau Jambi Bengkulu Bangka_Belitung"
local Sulawesi "Sulawesi_Utara Sulawesi_Tenggara Sulawesi_Tengah Sulawesi_Selatan Sulawesi_Barat Gorontalo"
local Maluk_Islands "Maluku_Utara Maluku"
local Lesser_Sunda_Islands "Nusatenggara_Timur Nusatenggara_Barat Bali"
local Kalimantan "Kalimantan_Timur Kalimantan_Tengah Kalimantan_Selatan Kalimantan_Barat"
local Java "Jawa_Timur Jawa_Tengah Jawa_Barat Dki_Jakarta Daerah_Istimewa_Yogyakarta Banten"
global elements "Western_New_Guinea Sumatra Sulawesi Maluk_Islands Lesser_Sunda_Islands Kalimantan Java"
foreach z in $elements{
	local count_`z' = `: word count ``z'''
	local i = 0
	foreach x of local `z'{
		local i = `i' + 1
		if (`i'!=`count_`z''){
			expand 2 if country==9 & region=="`z'", g(t1)
			replace region = "`x'" if country==9 & region=="`z'" & t1==1
			drop t1
		}
		else{
			replace region = "`x'" if country==9 & region=="`z'"
		}
	}
}
replace region = subinstr(region, "_", " ", .) if country==9

* Singapore (10)
* Territories are not fully covered in the WBG ADM1 boundaries dataset
drop if country==10

* Vietnam (11)
replace region = subinstr(region, " ", "_", .) if country==11
* Southeast Red_River_Delta Northern_and_mountains Mekong_River_Delta Central_Highlands Central_Coast expansion
local Southeast "Tay_Ninh Ho_Chi_Minh_City Dong_Nai Binh_Phuoc Binh_Duong Ba_Ria-Vung_Tau"
local Red_River_Delta "Vinh_Phuc Thai_Binh Ninh_Binh Nam_Dinh Hung_Yen Hai_Phong_City Hai_Duong Ha_Tay Ha_Noi_City Ha_Nam Bac_Ninh"
local Northern_and_mountains "Yen_Bai Tuyen_Quang Thai_Nguyen Son_La Quang_Ninh Phu_Tho Lao_Cai Lang_Son Lai_Chau Hoa_Binh Ha_Giang Dien_Bien Cao_Bang Bac_Kan Bac_Giang"
local Mekong_River_Delta "Vinh_Long Tra_Vinh Tien_Giang Soc_Trang Long_An Kien_Giang Hau_Giang Dong_Thap Can_Tho_city Ca_Mau Ben_Tre Bac_Lieu An_Giang"
local Central_Highlands "Lam_Dong Kon_Tum Gia_Lai Dak_Nong Dak_Lak"
local Central_Coast "Thua_Thien_-_Hue Thanh_Hoa Quang_Tri Quang_Ngai Quang_Nam Quang_Binh Phu_Yen Ninh_Thuan Nghe_An Khanh_Hoa Ha_Tinh Da_Nang_City Binh_Thuan Binh_Dinh"
global elements "Southeast Red_River_Delta Northern_and_mountains Mekong_River_Delta Central_Highlands Central_Coast"
foreach z in $elements{
	local count_`z' = `: word count ``z'''
	local i = 0
	foreach x of local `z'{
		local i = `i' + 1
		if (`i'!=`count_`z''){
			expand 2 if country==11 & region=="`z'", g(t1)
			replace region = "`x'" if country==11 & region=="`z'" & t1==1
			drop t1
		}
		else{
			replace region = "`x'" if country==11 & region=="`z'"
		}
	}
}
replace region = subinstr(region, "_", " ", .) if country==11

* Cambodia (12)
replace region = subinstr(region, " ", "_", .) if country==12
replace region = "Plateua_Highland" if country==12 & region=="Plateua/Highland"
* Tonle_Sap Plateua_Highland Phnom_Penh Coastal Central_Plain expansion
local Tonle_Sap "Battambang Kampong_Chhnang Pursat Siem_Reap"
local Plateua_Highland "Mondul_Kiri Ratanak_Kiri Stung_Treng"
local Phnom_Penh "Phnom_Penh"
local Coastal "Kampot Kep Koh_Kong Preah_Sihanouk"
local Central_Plain "Banteay_Meanchey Kampong_Cham Kampong_Speu Kampong_Thom Kandal Kratie Otdar_Meanchey Pailin Preah_Vihear Prey_Veng Svay_Rieng Takeo"
global elements "Tonle_Sap Plateua_Highland Phnom_Penh Coastal Central_Plain"
foreach z in $elements{
	local count_`z' = `: word count ``z'''
	local i = 0
	foreach x of local `z'{
		local i = `i' + 1
		if (`i'!=`count_`z''){
			expand 2 if country==12 & region=="`z'", g(t1)
			replace region = "`x'" if country==12 & region=="`z'" & t1==1
			drop t1
		}
		else{
			replace region = "`x'" if country==12 & region=="`z'"
		}
	}
}
replace region = subinstr(region, "_", " ", .) if country==12

* Malaysia (13)
replace region = subinstr(region, " ", "_", .) if country==13
* Southern Northern Eastern East_Malaysia Central expansion
local Southern "Johor Melaka Negeri_Sembilan"
local Northern "Kedah Perak Perlis Pulau_Pinang"
local Eastern "Kelantan Pahang Terengganu"
local East_Malaysia "Sabah Sarawak Labuan"
local Central "Kuala_Lumpur Selangor"
global elements "Southern Northern Eastern East_Malaysia Central"
foreach z in $elements{
	local count_`z' = `: word count ``z'''
	local i = 0
	foreach x of local `z'{
		local i = `i' + 1
		if (`i'!=`count_`z''){
			expand 2 if country==13 & region=="`z'", g(t1)
			replace region = "`x'" if country==13 & region=="`z'" & t1==1
			drop t1
		}
		else{
			replace region = "`x'" if country==13 & region=="`z'"
		}
	}
}
replace region = subinstr(region, "_", " ", .) if country==13

* Myanmar (14)
* West South North Lower East Central expansion
local West "Rakhine Chin"
local South "Taninthayi"
local North "Kachin Sagaing Shan_N"
local Lower "Ayeyawaddy Mon Yangon Bago_W"
local East "Kayin Kayar Bago_E Shan_E Shan_S"
local Central "Magway Mandalay"
global elements "West South North Lower East Central"
foreach z in $elements{
	local count_`z' = `: word count ``z'''
	local i = 0
	foreach x of local `z'{
		local i = `i' + 1
		if (`i'!=`count_`z''){
			expand 2 if country==14 & region=="`z'", g(t1)
			replace region = "`x'" if country==14 & region=="`z'" & t1==1
			drop t1
		}
		else{
			replace region = "`x'" if country==14 & region=="`z'"
		}
	}
}
replace region = "Shan (N)" if country==14 & region=="Shan_N"
replace region = "Bago (W)" if country==14 & region=="Bago_W"
replace region = "Bago (E)" if country==14 & region=="Bago_E"
replace region = "Shan (E)" if country==14 & region=="Shan_E"
replace region = "Shan (S)" if country==14 & region=="Shan_S"

* -------------------- *
* Generating variables *
* -------------------- *

* v1: People are free to speak what they think without fear
/*
	-1	Missing
	1	Strongly agree
	2	Somewhat agree
	3	Somewhat disagree
	4	Strongly disagree
	7	Don't understand the	question
	8	Can't choose
	9	Decline to answer
*/
gen free_speak = (q108>=1 & q108<=2)
replace free_speak = . if q108==7 | q108==8 | q108==9 | q108==-1 | q108==.

* v2: People can join any organization they like without fear
/*
	-1	Missing
	1	Strongly agree
	2	Somewhat agree
	3	Somewhat disagree
	4	Strongly disagree
	7	Don't understand the	question
	8	Can't choose
	9	Decline to answer
*/
gen free_join = (q109>=1 & q109<=2)
replace free_join = . if q109==7 | q109==8 | q109==9 | q109==-1 | q109==.

* v3: Did you vote in the last national election?
/*
	-1	missing
	0	Not applicable/not yet eligible	to	vote
	1	Yes
	2	No
	7	Do not understand the question
	8	Can't choose
	9	Decline to answer
*/
gen vote_nat = (q33==1)
replace vote_nat = . if q33==0 | q33==7 | q33==8 | q33==9 | q33==-1 | q33==.

* v4: Attended a demonstration or protest march
/*
	-1 Missing
	1 I have done this more than once
    2 I have done this once
    3 I have never done this.
    7 Do not understand the question
    8 Can't choose
    9 Decline to answer
*/
gen attended_demons = (q76==1 | q76==2)
replace attended_demons = . if q76==7 | q76==8 | q76==9 | q76==-1 | q76==.

* v5: How often do you use the internet, either through computer, tablet or smartphone
/*
	-1	Missing
	0	Not applicable
	1	Several hours a day
	2	About half an hour to	an hour a	day
	3	At least once a day
	4	At least once a week
	5	At least once a month
	6	A few times a year
	7	Hardly ever
	8	Never
	97	Do not understand the	question
	98	Can't choose
	99	Decline to answer
*/
gen internet_use = (q49>=1 & q49<=7)
replace internet_use = . if q49==97 | q49==98 | q49==99 | q49==0 | q49==-1 | q49==.

* v6: Trust in the police
/*
	-1	Mssing
	1	A great deal of trust
	2	Quite a lot of trust
	3	Not very much trust
	4	None at all
	7	Do not understand the	question
	8	Can't choose
	9	Decline to answer
*/
gen conf_police = (q14>=1 & q14<=2)
replace conf_police = . if q14==7 | q14==8 | q14==9 | q14==-1 | q14==.

* v7: Trust in the local government
/*
	-1	Mssing
	1	A great deal of trust
	2	Quite a lot of trust
	3	Not very much trust
	4	None at all
	7	Do not understand the	question
	8	Can't choose
	9	Decline to answer
*/
gen conf_govern = (q15>=1 & q15<=2)
replace conf_govern = . if q15==7 | q15==8 | q15==9 | q15==-1 | q15==.

* v8: Trust in the election commission
/*
	-1	Mssing
	1	A great deal of trust
	2	Quite a lot of trust
	3	Not very much trust
	4	None at all
	7	Do not understand the	question
	8	Can't choose
	9	Decline to answer
*/
gen conf_elections = (q18>=1 & q18<=2)
replace conf_elections = . if q18==7 | q18==8 | q18==9 | q18==-1 | q18==.

* v9: Confidence in the courts
/*
	-1	Mssing
	1	A great deal of trust
	2	Quite a lot of trust
	3	Not very much trust
	4	None at all
	7	Do not understand the	question
	8	Can't choose
	9	Decline to answer
*/
gen conf_justice = (q8==1 | q8==2)
replace conf_justice = . if q8==7 | q8==8 | q8==9 | q8==-1 | q8==.

* v10: Would you say that "Most people can be trusted" or "that you must be very car
/*
	-1	Mising
	1	Most people can be trusted
	2	You must be very careful in dealing	with	people
	7	Do not understand the question
	8	Can't choose
	9	Decline to answer
*/
gen trustinpeople = (q23==1)
replace trustinpeople = . if q23==7 | q23==8 | q23==9 | q23==-1 | q23==.

* v11: Does the total income of your household allow you to satisactorily cover your needs
/*
	-1	Missing
	0	Not applicable
	1	Our income covers the needs well, we can save
	2	Our income covers the needs all right, without	much difficulties
	3	Our income does not cover the needs, there are	difficulties
	7	Do not understand the question
	8	Can't choose
	9	Decline to answer
*/
gen save_money = (se14a==1)
replace save_money = . if se14a==7 | se14a==8 | se14a==9 | se14a==-1 | se14a==0 | se14a==.

* v12: How safe is living in this city/ town/ village: unsafe and very unsafe
/*
	-1	Missing
	1	Very safe
	2	Safe
	3	Unsafe
	4	Very unsafe
	7	Do not undertstand	the	question
	8	Can't choose
	9	Decline to answer
*/
gen insecure_neigh = (q43>=3 & q43<=4)
replace insecure_neigh=. if q43==7 | q43==8 | q43==9 | q43==-1 | q43==.

* v13: Whether the respondent is a member of an organization
/*
	-1	Missing
	0	Not applicable
	1	Political parties
	2	Residential & community associations
	3	Religious groups
	4	Sports/recreational clubs
	5	Culture organizations
	6	Charities
	7	Public interest groups
	8	Labor unions
	9	Farmer unions or agricultural associations
	10	Professional organizations
	11	Business associations
	12	Parent-Teacher associations
	13	Producer cooperatives
	14	Consumer cooperatives
	15	Alumni associations
	16	Candidate support organizations
	17	Other occupational organizations
	18	Other volunteer organizations
	19	Student Associations
	20	Mutual assistance associations
	21	Other
	90	Not a member of any organization or group
	97	Do not understand the question
	98	Can't choose
	99	Decline to answer
*/
gen active_mem = (q20!=90)
replace active_mem = . if q20==0 | q20==-1 | q20==97 | q20==98 | q20==99 | q20==.

* v14: Got together with others face-to-face to try to resolve local problems
/*
	-1	Missing
	1	I have done this more than once
	2	I have done this once
	3	I have never done this.
	7	Do not understand the question
	8	Can't choose
	9	Decline to answer
*/
gen solve_problems = (q74==1 | q74==2)
replace solve_problems=. if q74==7 | q74==8 | q74==9 | q74==-1 | q74==.

* ---------------- *
* Rename variables *
* ---------------- *

rename free_speak sc_frespe
rename free_join sc_frejoi
rename vote_nat sc_vot
rename attended_demons sc_attdem
rename internet_use si_intuse
rename conf_police sc_conpol
rename conf_govern sc_congov
rename conf_elections sc_conele
rename conf_justice sc_conjus
rename trustinpeople sc_trupeo
rename save_money re_savmon
rename insecure_neigh sc_insnei
rename active_mem sc_actmem
rename solve_problems sc_solpro

* ------------------ *
* Supplementary data *
* ------------------ *

* string countryname
decode country, g(countryname)

* add survey year
bys country: egen t1 = max(year)
gen period = t1
tostring period, replace
drop t1

* data source
gen source = "Asianbarometer 4"

* ----------------- *
* Collapse the data *
* ----------------- *

recode w (.=1)

collapse (mean) sc_frespe* sc_frejoi* sc_vot* sc_attdem* si_intuse* sc_conpol* sc_congov* sc_conele* sc_conjus* sc_trupeo* re_savmon* sc_insnei* sc_actmem* sc_solpro* [aw=w], by(countryname region period source)

* --------- *
* Labelling *
* --------- *

* variables
local t_sc_frespe = "Share of population that agrees they are free to express what they think"
local t_sc_frejoi = "Share of population that agrees they are free to join any organization they like without fear"
local t_sc_vot = "Share of population that voted in the last national elections"
local t_sc_attdem = "Share of population that has ever attended a demonstration or protest march"
local t_si_intuse = "Share of population that uses the Internet"
local t_sc_conpol = "Share of population that says they have confidence in the Police"
local t_sc_congov = "Share of population that says they have confidence in the Government"
local t_sc_conele = "Share of population that says they have confidence in the elections"
local t_sc_conjus = "Share of population that says they have confidence in the Justice System"
local t_sc_trupeo = "Share of population that says that most people can be trusted"
local t_re_savmon = "Share of population that saves some money"
local t_sc_insnei = "Share of population that feels insecure living in their neighborhood / town / village"
local t_sc_actmem = "Share of population that are active members of organizations"
local t_sc_solpro = "Share of population that got together with others to try to resolve local problems"

* macros for lists
global vars "sc_frespe sc_frejoi sc_vot sc_attdem si_intuse sc_conpol sc_congov sc_conele sc_conjus sc_trupeo re_savmon sc_insnei sc_actmem sc_solpro"

* labels
foreach x in $vars{
	label var `x' "`t_`x''"
}

* recoding missing values
foreach vars in sc_frespe* sc_frejoi* sc_vot* sc_attdem* si_intuse* sc_conpol* sc_congov* sc_conele* sc_conjus* sc_trupeo* re_savmon* sc_insnei* sc_actmem* sc_solpro*{
	recode `vars' (-1=.)
}

* Attaching country codes
replace countryname = "Hong Kong SAR" if countryname=="Hong Kong"
replace countryname = "Taiwan ROC" if countryname=="Taiwan"
replace countryname = "South Korea" if countryname=="Korea"
preserve
import excel using "${ssgd_v2_userpath}\SSGD v2.0\other\list_countries.xlsx", firstrow sheet("countries_codes") clear
rename Country countryname
rename Code countrycode
save "countries_codes.dta", replace
restore
* merging process
merge m:1 countryname using "countries_codes.dta"
keep if _merge==3
drop _merge

order countryname countrycode region period source
rename region adm1_name

* ------ * 
* Saving *
* ------ *

save "$proc_data\asianbarometer4_subnational.dta", replace

erase "countries_codes.dta"
