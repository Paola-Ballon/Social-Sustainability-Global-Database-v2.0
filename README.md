# Social Sustainability Global Database (SSGD) v2.0 Replication

This repository contains all scripts and guidelines necessary for the complete replication of the Social Sustainability Global Database (SSGD) v2.0. The scripts, written in R and Stata, are designed for ease of use to ensure that anyone with access to the World Bank Group's intranet can replicate the database.

## Repository Contents

- R and Stata script files
- Replication guidelines document

## Software Requirements

To replicate the SSGD v2.0, users must have the following software:

- Stata 16 MP (or higher, MP version strongly recommended)
- Latest version of R

It's recommended to use RStudio as the development environment for R scripts. Additionally, users must install the `datalibweb` and `wbopendata` packages in Stata before running any script.

## Replication Process

The replication process is divided into five blocks:

1. **User Profile**: This step involves setting up the user environment and ensuring all necessary files and directories are in place. It requires the user to organize the 'raw_data' folder and prepare it for the subsequent data download and processing steps.
2. **Data Download**: Here, users are required to manually download data from various external sources as specified in the guide. This involves navigating to different databases, downloading the necessary files, and placing them into the appropriate subfolders within the 'raw_data' folder. Specific naming conventions and download parameters are detailed in the guide.
3. **Generation of Indicators**: This phase involves running scripts that process the downloaded data to generate specific indicators relevant to the Social Sustainability Global Database. It requires the execution of R and Stata scripts provided in the repository.
4. **Data Processing**: In this step, users execute scripts that perform further data processing tasks. These tasks may include cleaning, transforming, or manipulating the data to fit the requirements of the Social Sustainability Global Database.
5. **Data Merge**: This final step involves merging all processed data into a single dataset, ensuring consistency and readiness for analysis. Users will need to run the provided scripts that automatically handle the merging process.

For a detailed explanation of each block, please refer to the "SSGD v2.0 replication guidelines.docx" file in this repository.

## Data Sources

Data for the SSGD v2.0 is sourced from various databases. Users will need to manually download specific data files from certain sources and copy them to the "raw_data" folder. The necessary databases and files are listed in Table A1 of the replication guidelines document.

**Note**: Three databases - CIVICUS, EIU, and EQOSOGI - are included by default in the SSGD v2.0 repository as they are sourced from reports rather than directly downloadable data sets. See Table A2 in the guidelines for more information.

## Getting Started

1. Clone this repository to your local machine.
2. Ensure you meet all software requirements and have installed the necessary R and Stata packages.
3. Follow the detailed instructions in the "SSGD v2.0 replication guidelines.docx" for setting up your user profile, downloading data, and running the scripts.
4. Refer to the guidelines document for troubleshooting and additional details.

## Support

For questions or assistance, please open an issue in this repository or contact Paola Ballon (pballon@worldbank.org) and/or Omar Alburqueque (oalburquequechav@worldbank.org).

## Contributing

We welcome contributions to improve the replication process. If you have suggestions, please open an issue or submit a pull request.

