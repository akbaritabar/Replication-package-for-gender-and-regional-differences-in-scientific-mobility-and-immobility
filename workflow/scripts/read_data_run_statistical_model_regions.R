## File name to use in search: read_data_run_statistical_model_regions.R ##

# ===========
## Author details ##
# ===========

# Script's author:      Aliakbar Akbaritabar
# Version:              2024-11-05
# Email:                akbaritabar@demogr.mpg.de
# GitHub:               https://github.com/akbaritabar
# Website:              https://www.demogr.mpg.de/en/about_us_6113/staff_directory_1899/aliakbar_akbaritabar_4098/

# Script for replication of analysis and figures from paper "A study of gender and regional differences in scientific mobility and immobility among researchers identified as potentially talented"

# Manuscript authors: Aliakbar Akbaritabar, Robin Haunschild and Lutz Bornmann

# ============================
#### Load libraries ####
# ============================

# if not installed, use "install.packages('add-package-name-here')" 

library(tidyverse)
library(stargazer)
library(texreg)
library(nnet)
library(GGally)
library(ggeffects)

# R to use English console messages
Sys.setenv(LANG = "en")
# ============================
#### For command line arguments ####
# ============================

library(argparser)

# Create a parser
p <- arg_parser("")

# Add command line arguments, "nargs = Inf" enables multiple arguments to be passed
p <- add_argument(p, "--input", help="Path to input file(s)", default=NA, type="character", nargs = Inf)
p <- add_argument(p, "--region2use", help="Which geographical region should be used?", default=NA, type="character", nargs = Inf)
p <- add_argument(p, "--output", help="ath to save output(s)", default=NA, type="character", nargs = Inf)

# Parse the command line arguments
args <- parse_args(p)

# print a few things
print("R working directory: ")
print(getwd())
print(paste(replicate(50, "#"), collapse = ""))
print("Received these arguments from command line: ")
print(args)

# print sessionInfo
print("Current R session Info: ")
print(sessionInfo())

# ============================
#### read replication data ####
# ============================

# read talents data
talents <- read_csv(args$input[[1]])

# ============================
#### Which region variable to use? ####
# ============================

if (args$region2use == 'continent') {
   talents$region2use <- talents$continent_new
   talents$region2use <- relevel(factor(talents$region2use), ref = "Africa")
} else if (args$region2use == 'UNsubregion') {
   talents$region2use <- talents$un_subregion_new
   talents$region2use <- relevel(factor(talents$region2use), ref = "Sub-Saharan Africa")
} else if (args$region2use == 'WBregion') {
   talents$region2use <- talents$WB_region_new
   talents$region2use <- relevel(factor(talents$region2use), ref = "Sub-Saharan Africa")
}

# ============================
#### Set factor levels for reference category ####
# ============================

talents$ctrl_obs_2cat <- relevel(factor(talents$ctrl_obs_2cat), ref = "Others")
# convert to factor to have "non_mobile" as base category of models
talents$mobility_status2 <- relevel(factor(talents$mobility_status2), ref = "Non mobile")


# ============================
#### Multinomial probit regression models ####
# ============================

mprobit2 <- multinom(mobility_status2 ~ ctrl_obs_2cat * region2use + acadmic_age, data = talents, probit = TRUE, maxit = 300)


# ============================
#### Export data for figures 2 and 3 ####
# ============================

m2_res = tibble(ggpredict(mprobit2, terms = c("ctrl_obs_2cat", "region2use")))

print(head(m2_res))

write_csv(x = m2_res, file = args$output[[1]])

# ============================
#### Table 4 with model results ####
# ============================

stargazer(mprobit2, type = "html", out = args$output[[2]])
# to have results in log
print('Stat model results: \n')
print(screenreg(mprobit2))




