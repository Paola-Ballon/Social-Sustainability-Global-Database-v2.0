* Social Sustainability Global Database v2.0
* consultant: Omar Alburqueque Chavez
* contact: oalburquequechav@worldbank.org
* last update: March 26th, 2024
* original data source: https://www.asianbarometer.org/data?page=d10

/*
Issues:
	- No information on ethnic groups for India [subgroup]
	- No data on disability [subgroup]
	- In Vietnam, most people decline to answer which religion they profess [variable]
	- No information on attending a demonstration or protest for Australia and Vietnam [variable]
	- Use of internet has a very rigid definition, it could be redefined [variable]
	- No information on resolve local problems for Australia [variable]
	- No sampling weight information for Indonesia
*/

clear all
set more off

* directory macros
global raw_data "${ssgd_v2_userpath}\SSGD v2.0\raw_data\asianbarometer5"
global proc_data "${ssgd_v2_userpath}\SSGD v2.0\proc_data" // processed data

* -------------------- *
* Data standardization *
* -------------------- *

cd "$raw_data"

use "20230504_W5_merge_15.dta", clear

* ------------------------------------ *
* Administrative divisions corrections *
* ------------------------------------ *

rename Region region
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
set obs 30750
replace country = 1 if _n==30749
replace region = "Nagano" if country==1 & _n==30749
replace country = 1 if _n==30750
replace region = "Yamanasi" if country==1 & _n==30750
replace region = "Hokkaidoo" if country==1 & region=="Hokkaido"

* Hong Kong (2)
drop if country==2 // Administrative unit not available

* South Korea (3)
replace region = subinstr(region, "/", "_", .) if country==3
* Incheon_Gyeongi Gwangju_Jeonlla Gangwon Daejeon_Chungcheong Daegu_Gyeongbuk Busan_Ulsan_Gyeongnam expansion
local Incheon_Gyeongi "Inchon Kyonggi-do"
local Gwangju_Jeonlla "Chollabuk-do Chollanam-do Kwangju"
local Gangwon "Kang-won-do"
local Daejeon_Chungcheong "Chungchongbuk-do Chungchongnam-do Taejon"
local Daegu_Gyeongbuk "Kyongsangbuk-do Taegu"
local Busan_Ulsan_Gyeongnam "Kyongsangnam-do Pusan"
global elements "Incheon_Gyeongi Gwangju_Jeonlla Gangwon Daejeon_Chungcheong Daegu_Gyeongbuk Busan_Ulsan_Gyeongnam"
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
set obs 30784
replace country = 3 if _n==30784
replace region = "Cheju-do" if country==3 & _n==30784

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
replace region = subinstr(region, " Region", "", .) if country==5
replace region = "Ulaanbaatar" if country==5 & region=="Ulaanbaatar and vicinity"
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
* Sumatera Sulawesi Maluku_Papua Kalimantan Java Bali_Nusa expansion
local Sumatera "Sumatera_Utara Sumatera_Selatan Sumatera_Barat Riau Nangroe_Aceh_Darussalam Lampung Kepulauan-riau Jambi Bengkulu Bangka_Belitung"
local Sulawesi "Sulawesi_Utara Sulawesi_Tenggara Sulawesi_Tengah Sulawesi_Selatan Sulawesi_Barat Gorontalo"
local Maluku_Papua "Papua_Barat Papua Maluku_Utara Maluku"
local Kalimantan "Kalimantan_Timur Kalimantan_Tengah Kalimantan_Selatan Kalimantan_Barat"
local Java "Jawa_Timur Jawa_Tengah Jawa_Barat Dki_Jakarta Daerah_Istimewa_Yogyakarta Banten"
local Bali_Nusa "Nusatenggara_Timur Nusatenggara_Barat Bali"
global elements "Sumatera Sulawesi Maluku_Papua Kalimantan Java Bali_Nusa"
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
replace region = "Central Coast" if country==11 & region=="Central coast"
replace region = "Central Highlands" if country==11 & region=="Central highlands"
replace region = "Mekong River Delta" if country==11 & region=="Mekong river Delta"
replace region = "Red River Delta" if country==11 & region=="Red river Delta"
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

* Malaysia (13)
replace region = "East_Malaysia" if country==13 & region=="Borneo Malaysia"
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
replace region = "Middle_North" if country==14 & region=="Middle North"
* West South North Middle_North Central expansion
local West "Rakhine Chin"
local South "Taninthayi"
local North "Kachin Sagaing Shan_N"
local Middle_North "Ayeyawaddy Mon Yangon Bago_W Kayin Kayar Bago_E Shan_E Shan_S"
local Central "Magway Mandalay"
global elements "West South North Middle_North Central"
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

* Australia (15)
replace region = subinstr(region, " ", "_", .) if country==15
* Western_Region Southern_Region Northern_Region Eastern_Region expansion
local Western_Region "Western_Australia"
local Southern_Region "South_Australia"
local Northern_Region "Northern_Territory"
local Eastern_Region "Coral_Sea_Islands_Territory New_South_Wales Other_Territories Queensland Australian_Capital_Territory Tasmania Victoria"
global elements "Western_Region Southern_Region Northern_Region Eastern_Region"
foreach z in $elements{
	local count_`z' = `: word count ``z'''
	local i = 0
	foreach x of local `z'{
		local i = `i' + 1
		if (`i'!=`count_`z''){
			expand 2 if country==15 & region=="`z'", g(t1)
			replace region = "`x'" if country==15 & region=="`z'" & t1==1
			drop t1
		}
		else{
			replace region = "`x'" if country==15 & region=="`z'"
		}
	}
}
replace region = subinstr(region, "_", " ", .) if country==15

* India (18)
replace region = "Orissa" if country==18 & region=="Odisha"
replace region = "Andhra Pradesh" if country==18 & region=="Telangana"
set obs 120000
local i = 0
foreach x in Andaman_and_Nicobar Goa Himachal_Pradesh Lakshadweep Manipur Meghalaya Mizoram Nagaland Sikkim Tripura Arunachal_Pradesh Chandigarh Dadra_and_Nagar_Haveli Daman_and_Diu Puducherry Uttarakhand{
	local i = `i' + 1
	local j = 113572 + `i'
	replace country = 18 if _n==`j'
	replace region = "`x'" if country==18 & _n==`j'
}
replace region = "Andaman and Nicobar" if country==18 & region=="Andaman_and_Nicobar"
replace region = "Himachal Pradesh" if country==18 & region=="Himachal_Pradesh"
replace region = "Arunachal Pradesh" if country==18 & region=="Arunachal_Pradesh"
replace region = "Dadra and Nagar Haveli" if country==18 & region=="Dadra_and_Nagar_Haveli"
replace region = "Daman and Diu" if country==18 & region=="Daman_and_Diu"
drop if country==. & region==""

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
gen free_speak = (q115>=1 & q115<=2)
replace free_speak = . if q115==7 | q115==8 | q115==9 | q115==-1 | q115==.

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
gen free_join = (q116>=1 & q116<=2)
replace free_join = . if q116==7 | q116==8 | q116==9 | q116==-1 | q116==.

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
recode q33 (3=0) // not yet elegible to vote
gen vote_nat = (q33==1)
replace vote_nat = . if q33==0 | q33==7 | q33==8 | q33==9 | q33==-1 | q33==.

* v4: Attended a demonstration or protest march
/*
	-1	Missing
	0	Not applicable
	1	I have done this more than three times
	2	I have done this two or three times
	3	I have done this once
	4	I have not done this, but I might do it	if	something important happens	in	the	future
	5	I have not done this and I would not do	it	regardless of the situation
	7	Do not understand the question
	8	Can't choose
	9	Decline to answer
*/
gen attended_demons = (q79==1 | q79==2 | q79==3)
replace attended_demons = . if q79==0 | q79==7 | q79==8 | q79==9 | q79==-1 | q79==.

* v5: How often do you use the internet, either through computer, tablet or smartphone
/*
	-1	Missing
	1	Connected all the time
	2	Several hours a day
	3	Half to one hour a day
	4	Less than half hour a day
	5	At least once a week
	6	At least once a month
	7	A few times a year
	8	Hardly ever
	9	Never
	97	Do not understand the question
	98	Can't choose
	99  Decline to answer
*/
gen internet_use = (q49>=1 & q49<=8)
replace internet_use = . if q49==97 | q49==98 | q49==99 | q49==0 | q49==-1 | q49==.

* v6: Trust in the police
/*
	-1	Missing
	1	Trust fully
	2	Trust a lot
	3	Trust somewhat
	4	Distrust somewhat
	5	Distrust a lot
	6	Distrust fully
	97	Do not understand	the	question
	98	Can't choose
	99	Decline to answer
*/
gen conf_police = (q14>=1 & q14<=3)
replace conf_police = . if q14==97 | q14==98 | q14==99 | q14==-1 | q14==.

* v7: Trust in the local government
/*
	-1	Missing
	1	Trust fully
	2	Trust a lot
	3	Trust somewhat
	4	Distrust somewhat
	5	Distrust a lot
	6	Distrust fully
	97	Do not understand	the	question
	98	Can't choose
	99	Decline to answer
*/
gen conf_govern = (q15>=1 & q15<=3)
replace conf_govern = . if q15==97 | q15==98 | q15==99 | q15==-1 | q15==.

* v8: Trust in the election commission
/*
	-1	Missing
	1	Trust fully
	2	Trust a lot
	3	Trust somewhat
	4	Distrust somewhat
	5	Distrust a lot
	6	Distrust fully
	97	Do not understand	the	question
	98	Can't choose
	99	Decline to answer
*/
gen conf_elections = (q16>=1 & q16<=3)
replace conf_elections = . if q16==97 | q16==98 | q16==99 | q16==-1 | q16==.

* v9: Confidence in the courts
/*
	-1	Missing
	1	Trust fully
	2	Trust a lot
	3	Trust somewhat
	4	Distrust somewhat
	5	Distrust a lot
	6	Distrust fully
	97	Do not understand	the	question
	98	Can't choose
	99	Decline to answer
*/
gen conf_justice = (q8>=1 & q8<=3)
replace conf_justice = . if q8==97 | q8==98 | q8==99 | q8==-1 | q8==.

* v10: Would you say that "Most people can be trusted" or "that you must be very car
/*
	-1	Mising
	1	Most people can be trusted
	2	You must be very careful in dealing	with	people
	3   It depends
	7	Do not understand the question
	8	Can't choose
	9	Decline to answer
*/
gen trustinpeople = (q22==1)
replace trustinpeople = . if q22==7 | q22==8 | q22==9 | q22==-1 | q22==.

* v11: Does the total income of your household allow you to satisactorily cover your needs
/*
	-1	Missing
	0	Not applicable
	1	Our income covers the needs well, we can save a lot
	2	Our income covers the needs well, we can save
	3	Our income covers the needs all right, without much difficulties
	4	Our income does not cover the needs, there are difficulties
	5	Our income does not cover the needs, there are great difficulties
	7	Do not understand the question
	8	Can't choose
	9	Decline to answer
*/
gen save_money = (SE14A==1 | SE14A==2)
replace save_money = . if SE14A==7 | SE14A==8 | SE14A==9 | SE14A==-1 | SE14A==0 | SE14A==.

* v12: How safe is living in this city/ town/ village: unsafe or very unsafe
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
gen insecure_neigh = (q45>=3 & q45<=4)
replace insecure_neigh=. if q45==7 | q45==8 | q45==9 | q45==-1 | q45==.

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
	12	Parent-Teacher associations or PTA
	13	Producer cooperatives
	14	Consumer cooperatives
	15	Alumni associations
	16	Candidate support organizations
	17	Other occupational organizations
	18	Other volunteer organizations
	19	Student Associations
	20	Hometwon/clan/peer-group/mutual assistance	associations/tribal	community
	90	Not a member of any organization or group
	97	Do not understand the question
	98	Can't choose
	99	Decline to answer

*/
gen active_mem = (q18!=90)
replace active_mem = . if q18==0 | q18==-1 | q18==97 | q18==98 | q18==99 | q18==.

* v14: Got together with others face-to-face to try to resolve local problems
/*
	-1	Missing
	1	I have done this more than once
	2	I have done this once
	3	I have never done this.
	7	Do not understand the question
	8	Can't choose
	9	Decline to answer
	
	
	-1	Missing
	0	Not applicable
	1	I have done this more than three times
	2	I have done this two or three times
	3	I have done this once
	4	I have not done this, but I might do it	if	something important happens	in	the	future
	5	I have not done this and I would not do	it	regardless of the situation
	7	Do not understand the question
	8	Can't choose
	9	Decline to answer

*/
gen solve_problems = (q78==1 | q78==2 | q78==3)
replace solve_problems=. if q78==0 | q78==7 | q78==8 | q78==9 | q78==-1 | q78==.

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
bys country: egen t1 = max(Year)
gen period = t1
tostring period, replace
drop t1

* data source
gen source = "Asianbarometer 5"

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

save "$proc_data\asianbarometer5_subnational.dta", replace

erase "countries_codes.dta"
