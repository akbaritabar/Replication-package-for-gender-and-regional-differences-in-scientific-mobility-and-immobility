## File name to use in search: "prepare_complement_data.R" ##

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

# R to use English console messages
Sys.setenv(LANG = "en")

# if not installed, use "install.packages('add-package-name-here')" 

# prepare the original talents data from Scopus joined with mobility information, complement it with world bank regions and continent codes etc, and primary gender assignment, export to be used in statistical models

library(tidyverse)
library(countrycode)
library(nanoparquet)

# ============================
#### For command line arguments ####
# ============================

library(argparser)

# Create a parser
p <- arg_parser("")

# Add command line arguments, "nargs = Inf" enables multiple arguments to be passed
p <- add_argument(p, "--input", help="Path to input file(s)", default=NA, type="character", nargs = Inf)
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
talents <- read_parquet(args$input[[1]])

# convert to tidyverse tibble format
talents <- tibble(talents)

# limit to only 2 groups with the best performance based on Robin's suggestion above

talents <- talents %>% 
  filter(ctrl_obs_cat %in% c('top1_oxq1', 'top5-top10_oxq1'))

# modify the data
# take the distinct authors in talents/others group with mutually exclusive membership
dis_talents <- talents %>% distinct(author_id, .keep_all = T)
# # convert to factor to have "non_mobile" as base category of models
dis_talents$mobility_status2 <- relevel(factor(dis_talents$mobility_status), ref = "non_mobile")

# replace NA with 0 in average length of migration
dis_talents <- dis_talents %>%
  mutate(
    avg_len_IN_cr = if_else(is.na(avg_len_IN), 0, avg_len_IN),
    avg_len_INT_cr = if_else(is.na(avg_len_INT), 0, avg_len_INT),
    # add continent name, world bank regions, and UN subregions and fill NAs
    continent = countrycode(sourcevar = country, origin = 'country.name', destination = 'continent'),
    WB_region = countrycode(sourcevar = country, origin = 'country.name', destination = 'region'),
    un_subregion = countrycode(sourcevar = country, origin = "country.name", destination = "un.regionsub.name"),
    continent = if_else(country == "Kosovo", "Europe", continent),
    un_subregion = if_else(country == "Taiwan", "Eastern Asia", un_subregion),
    un_subregion = if_else(country == "Kosovo", "Eastern Europe", un_subregion),
    WB_region = if_else(country == "Reunion", "Sub-Saharan Africa", WB_region),
    WB_region = if_else(country == "Svalbard and Jan Mayen", "Europe & Central Asia", WB_region),
    # add new continent, un_subregion, and WB_region variables by excluding selected countries and assigning them to their own category
    continent_new = case_when(country == "United States" ~ 'USA',
                            country == "China" ~ 'CHN',
                            country == "South Africa" ~ 'ZAF',
                            country == "Brazil" ~ 'BRA',
                            TRUE ~ continent),
   un_subregion_new = case_when(country == "United States" ~ 'USA',
                            country == "China" ~ 'CHN',
                            country == "South Africa" ~ 'ZAF',
                            country == "Brazil" ~ 'BRA',
                            TRUE ~ un_subregion),                            
   WB_region_new = case_when(country == "United States" ~ 'USA',
                            country == "China" ~ 'CHN',
                            country == "South Africa" ~ 'ZAF',
                            country == "Brazil" ~ 'BRA',
                            TRUE ~ WB_region)
  )


# exclude "Polynesia" (only 6 authors) and Melanesia (only 24 authors) from the "un_subregion" variable as they have too few observations and cause models not to work
dis_talents <- dis_talents %>% 
  mutate(un_subregion = if_else(un_subregion == "Polynesia", "Australia and New Zealand", un_subregion),
         un_subregion = if_else(un_subregion == "Melanesia", "Australia and New Zealand", un_subregion)
)

# ============================
#### Recode variables ####
# ============================

# # convert "NA" gender to "unknown" to use in our analysis
dis_talents[is.na(dis_talents$first_gender), "first_gender"] <- "unknown"
dis_talents[is.na(dis_talents$second_gender), "second_gender"] <- "unknown"
dis_talents[is.na(dis_talents$third_gender), "third_gender"] <- "unknown"
dis_talents[(dis_talents$third_gender == 'u'), "third_gender"] <- "unknown"


dis_talents <- dis_talents %>% 
  mutate(first_gender = case_when(first_gender == 'male' ~ 'Male',
                            first_gender == 'female' ~ 'Female',
                            first_gender == 'unknown' ~ 'Unknown'),
        second_gender = case_when(second_gender == 'm' ~ 'Male',
                            second_gender == 'f' ~ 'Female',
                            second_gender == 'unknown' ~ 'Unknown'),                            
        third_gender = case_when(third_gender == 'm' ~ 'Male',
                            third_gender == 'f' ~ 'Female',
                            third_gender == 'unknown' ~ 'Unknown'),        
        ctrl_obs_2cat = case_when(ctrl_obs_2cat == 'Potential talents' ~ 'Talents',
                            ctrl_obs_2cat == 'Control group' ~ 'Others'),
        mobility_status2 = case_when(mobility_status2 == 'non_mobile' ~ 'Non mobile',
                            mobility_status2 == 'mobile_both' ~ 'Both',
                            mobility_status2 == 'mobile_internal' ~ 'Internal',
                            mobility_status2 == 'mobile_international' ~ 'International')  
                      )


# ============================
#### 20241105 EXPORT ANONYMIZED REPLICATION MATERIALS FOR JOURNAL SUBMISSION ####
# ============================

replication_data <- dis_talents %>% 
  mutate(fake_author_ID = row_number()) %>% 
  # TAKE ALL NEEDED COLUMNS
  select(fake_author_ID, ctrl_obs_cat, ctrl_obs_2cat, acadmic_age, first_gender, second_gender, third_gender, mobility_status2, continent,WB_region,un_subregion,continent_new,un_subregion_new,WB_region_new) 

print(summary(replication_data$fake_author_ID))

# write to final replication data as csv
write_csv(x = replication_data, file = args$output[[1]])

print('Replication data exported in: ')
print(args$output[[1]])
