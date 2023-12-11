# --------------------------------------------------- #
# Automatic download for the SSGD v2.0 input datasets
# Consultant: Omar Alburqueque Chavez
# contact: oalburquequechav@worldbank.org
# --------------------------------------------------- #

# ----------- #
# Indications #
# ----------- #

# 1. Press ctrl + alt + Enter to run this R script

SSGD_v2.0_folder <- paste0(ssgd_v2_userpath,"SSGD v2.0/") # change the path

# Creating a "raw_data" folder
setwd(SSGD_v2.0_folder)
folder <- "raw_data"
if (file.exists(folder)){
  cat("The folder already exists")
} else{
  dir.create(folder)
}

# Creating a "proc_data" folder
folder_proc <- "proc_data"
if (file.exists(folder_proc)){
  cat("The folder already exists")
} else{
  dir.create(folder_proc)
}

# Creating a "final_data" folder
folder_final <- "final_data"
if (file.exists(folder_final)){
  cat("The folder already exists")
} else{
  dir.create(folder_final)
}

# switch to raw_data folder
raw_data_folder <- paste0(SSGD_v2.0_folder,folder,"/")
setwd(raw_data_folder)

# GMD (at least we create a folder, data downloading must be performed manually)
folder_gmd <- "gmd"
if (file.exists(folder_gmd)){
  cat("The folder already exists")
} else{
  dir.create(folder_gmd)
}

# GMD subfolders
setwd(paste0(raw_data_folder,folder_gmd,"/"))
# lac
folder_gmd_lac <- "lac"
if (file.exists(folder_gmd_lac)){
  cat("The folder already exists")
} else{
  dir.create(folder_gmd_lac)
}
# eca
folder_gmd_eca <- "eca"
if (file.exists(folder_gmd_eca)){
  cat("The folder already exists")
} else{
  dir.create(folder_gmd_eca)
}
# eap
folder_gmd_eap <- "eap"
if (file.exists(folder_gmd_eap)){
  cat("The folder already exists")
} else{
  dir.create(folder_gmd_eap)
}
# mena
folder_gmd_mena <- "mena"
if (file.exists(folder_gmd_mena)){
  cat("The folder already exists")
} else{
  dir.create(folder_gmd_mena)
}
# sar
folder_gmd_sar <- "sar"
if (file.exists(folder_gmd_sar)){
  cat("The folder already exists")
} else{
  dir.create(folder_gmd_sar)
}
# ssa
folder_gmd_ssa <- "ssa"
if (file.exists(folder_gmd_ssa)){
  cat("The folder already exists")
} else{
  dir.create(folder_gmd_ssa)
}
setwd(raw_data_folder)

# ACLED (at least we create a folder, data downloading must be performed manually)
folder_acled <- "acled"
if (file.exists(folder_acled)){
  cat("The folder already exists")
} else{
  dir.create(folder_acled)
}

# WVS (at least we create a folder, data downloading must be performed manually)
folder_wvs <- "wvs6_7"
if (file.exists(folder_wvs)){
  cat("The folder already exists")
} else{
  dir.create(folder_wvs)
}

# EVS
folder_evs <- "evs"
if (file.exists(folder_wvs)){
  cat("The folder already exists")
} else{
  dir.create(folder_evs)
}

# Afrobarometer 7th wave (AF7)
folder_AF7 <- "afrobarometer7"
if (file.exists(folder_AF7)){
  cat("The folder already exists")
} else{
  dir.create(folder_AF7)
}

url_AF7 <- "https://www.afrobarometer.org/wp-content/uploads/2022/02/r7_merged_data_34ctry.release.sav"
destfile_AF7 <- paste0(raw_data_folder,folder_AF7,"/",
                       "r7_merged_data_34ctry.release.sav")
download.file(url = url_AF7, destfile = destfile_AF7, mode = "wb")

# Afrobarometer 8th wave (AF8)
folder_AF8 <- "afrobarometer8"
if (file.exists(folder_AF8)){
  cat("The folder already exists")
} else{
  dir.create(folder_AF8)
}

url_AF8 <- "https://www.afrobarometer.org/wp-content/uploads/2023/03/afrobarometer_release-dataset_merge-34ctry_r8_en_2023-03-01.sav"
destfile_AF8 <- paste0(raw_data_folder,folder_AF8,"/",
                       "afrobarometer_release-dataset_merge-34ctry_r8_en_2023-03-01.sav")
download.file(url_AF8, destfile_AF8, mode = "wb")

# Arab barometer 5th wave (AB5)
folder_AB5 <- "arabbarometer5"
if (file.exists(folder_AB5)){
  cat("The folder already exists")
} else{
  dir.create(folder_AB5)
}

url_AB5 <- "https://www.arabbarometer.org/wp-content/uploads/Arab-Barometer-Wave-V-EN.dta_-3.zip"
destfile_AB5 <- paste0(raw_data_folder,folder_AB5,"/",
                       "Arab-Barometer-Wave-V-EN.dta_-3.zip")
download.file(url_AB5, destfile_AB5, mode = "wb")
folder_AB5 <- paste0(raw_data_folder,folder_AB5,"/")
setwd(folder_AB5)
unzip(destfile_AB5)
setwd(raw_data_folder)

# Arab barometer 6th wave (AB6)
# Part 1
folder_AB6 <- "arabbarometer6"
if (file.exists(folder_AB6)){
  cat("The folder already exists")
} else{
  dir.create(folder_AB6)
}

url_AB6 <- "https://www.arabbarometer.org/wp-content/uploads/ENG-Arab-Barometer-Wave-VI-Part-1_DEC.zip"
destfile_AB6 <- paste0(raw_data_folder,folder_AB6,"/",
                       "ENG-Arab-Barometer-Wave-VI-Part-1_DEC.zip")
download.file(url_AB6, destfile_AB6, mode = "wb")
folder_AB6 <- paste0(raw_data_folder,folder_AB6,"/")
setwd(folder_AB6)
unzip(destfile_AB6)
file.copy(from = paste0(folder_AB6,
                        "Arab Barometer Wave VI Part 1_DEC/",
                        "Arab_Barometer_Wave_6_Part_1_ENG_RELEASE.dta"),
          to = folder_AB6)
setwd(raw_data_folder)

# Part 2
folder_AB6 <- "arabbarometer6"

url_AB6 <- "https://www.arabbarometer.org/wp-content/uploads/ENG-Arab-Barometer-Wave-VI-Part-2-1.zip"
destfile_AB6 <- paste0(raw_data_folder,folder_AB6,"/",
                       "ENG-Arab-Barometer-Wave-VI-Part-2-1.zip")
download.file(url_AB6, destfile_AB6, mode = "wb")
folder_AB6 <- paste0(raw_data_folder,folder_AB6,"/")
setwd(folder_AB6)
unzip(destfile_AB6)
file.copy(from = paste0(folder_AB6,
                        "Arab Barometer Wave VI Part 2/",
                        "Arab_Barometer_Wave_6_Part_2_ENG_RELEASE.dta"),
          to = folder_AB6)
setwd(raw_data_folder)

# Part 3
folder_AB6 <- "arabbarometer6"

url_AB6 <- "https://www.arabbarometer.org/wp-content/uploads/ENG-Arab-Barometer-Wave-VI-Part-3_DEC.zip"
destfile_AB6 <- paste0(raw_data_folder,folder_AB6,"/",
                       "ENG-Arab-Barometer-Wave-VI-Part-3_DEC.zip")
download.file(url_AB6, destfile_AB6, mode = "wb")
folder_AB6 <- paste0(raw_data_folder,folder_AB6,"/")
setwd(folder_AB6)
unzip(destfile_AB6)
file.copy(from = paste0(folder_AB6,
                        "Arab Barometer Wave VI Part 3_DEC/",
                        "Arab_Barometer_Wave_6_Part_3_ENG_RELEASE.dta"),
          to = folder_AB6)
setwd(raw_data_folder)

# Arab barometer 7th wave (AB7)
folder_AB7 <- "arabbarometer7"
if (file.exists(folder_AB7)){
  cat("The folder already exists")
} else{
  dir.create(folder_AB7)
}

url_AB7 <- "https://www.arabbarometer.org/wp-content/uploads/AB7_English_Version6.zip"
destfile_AB7 <- paste0(raw_data_folder,folder_AB7,"/",
                       "AB7_English_Version6.zip")
download.file(url_AB7, destfile_AB7, mode = "wb")
folder_AB7 <- paste0(raw_data_folder,folder_AB7,"/")
setwd(folder_AB7)
unzip(destfile_AB7)
setwd(raw_data_folder)

# Asianbarometer 4 (ASB4)

folder_ASB4 <- "asianbarometer4"
if (file.exists(folder_ASB4)){
  cat("The folder already exists")
} else{
  dir.create(folder_ASB4)
}

# Asianbarometer 5 (ASB5)

folder_ASB5 <- "asianbarometer5"
if (file.exists(folder_ASB5)){
  cat("The folder already exists")
} else{
  dir.create(folder_ASB5)
}

# Latinobarometro 2017 (LB17)

folder_LB17 <- "latinobarometro2017"
if (file.exists(folder_LB17)){
  cat("The folder already exists")
} else{
  dir.create(folder_LB17)
}

# Latinobarometro 2018 (LB18)

folder_LB18 <- "latinobarometro2018"
if (file.exists(folder_LB18)){
  cat("The folder already exists")
} else{
  dir.create(folder_LB18)
}

# Latinobarometro 2020 (LB20)

folder_LB20 <- "latinobarometro2020"
if (file.exists(folder_LB20)){
  cat("The folder already exists")
} else{
  dir.create(folder_LB20)
}

# EMDAT
folder_emdat <- "emdat"
if (file.exists(folder_emdat)){
  cat("The folder already exists")
} else{
  dir.create(folder_emdat)
}

# FINDEX
folder_findex <- "findex"
if (file.exists(folder_findex)){
  cat("The folder already exists")
} else{
  dir.create(folder_findex)
}

# WDI
folder_wdi <- "wdi"
if (file.exists(folder_wdi)){
  cat("The folder already exists")
} else{
  dir.create(folder_wdi)
}

# WGI
folder_wgi <- "wgi"
if (file.exists(folder_wgi)){
  cat("The folder already exists")
} else{
  dir.create(folder_wgi)
}

# WJP (WJP)
folder_wjp <- "wjp"
if (file.exists(folder_wjp)){
  cat("The folder already exists")
} else{
  dir.create(folder_wjp)
}

url_WJP <- "https://worldjusticeproject.org/rule-of-law-index/downloads/FINAL_2022_wjp_rule_of_law_index_HISTORICAL_DATA_FILE.xlsx"
destfile_WJP <- paste0(raw_data_folder,folder_wjp,"/",
                       "FINAL_2022_wjp_rule_of_law_index_HISTORICAL_DATA_FILE.xlsx")
download.file(url_WJP, destfile_WJP, mode = "wb")

# -------------- #
# External block #
# -------------- #

# External (ex)
folder_ex <- "external"
if (file.exists(folder_ex)){
  cat("The folder already exists")
} else{
  dir.create(folder_ex)
}

# switch to external folder
external_folder <- paste0(SSGD_v2.0_folder,folder,"/external/")
setwd(external_folder)

# External: WDI
folder_ex_wdi <- "wdi"
if (file.exists(folder_ex_wdi)){
  cat("The folder already exists")
} else{
  dir.create(folder_ex_wdi)
}

# External: UNDP
folder_ex_undp <- "undp"
if (file.exists(folder_ex_undp)){
  cat("The folder already exists")
} else{
  dir.create(folder_ex_undp)
}

url_ex_undp <- "https://hdr.undp.org/sites/default/files/2021-22_HDR/HDR21-22_Composite_indices_complete_time_series.csv"
destfile_ex_undp <- paste0(external_folder,folder_ex_undp,"/",
                       "HDR21-22_Composite_indices_complete_time_series.csv")
download.file(url_ex_undp, destfile_ex_undp, mode = "wb")

# External: WBL
folder_ex_wbl <- "wbl"
if (file.exists(folder_ex_wbl)){
  cat("The folder already exists")
} else{
  dir.create(folder_ex_wbl)
}

url_ex_wbl <- "https://wbl.worldbank.org/content/dam/sites/wbl/documents/2023/WBL-1971-2023-Dataset.xlsx"
destfile_ex_wbl <- paste0(external_folder,folder_ex_wbl,"/",
                           "WBL-1971-2023-Dataset.xlsx")
download.file(url_ex_wbl, destfile_ex_wbl, mode = "wb")

# External: EIU
folder_ex_eiu <- "eiu"
if (file.exists(folder_ex_eiu)){
  cat("The folder already exists")
} else{
  dir.create(folder_ex_eiu)
}

# External: ESG
folder_ex_esg <- "esg"
if (file.exists(folder_ex_esg)){
  cat("The folder already exists")
} else{
  dir.create(folder_ex_esg)
}

# External: EQOSOGI
folder_ex_eqosogi <- "eqosogi"
if (file.exists(folder_ex_eqosogi)){
  cat("The folder already exists")
} else{
  dir.create(folder_ex_eqosogi)
}

cat('Now you can proceed and run the ssgd_v2_data_download_p2.do Stata file')
