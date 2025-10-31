## File name to use in search: read_data_run_statistical_model_gender.R ##

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
p <- add_argument(p, "--gender", help="Gender assignment to use", default=NA, type="character", nargs = Inf)
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
#### Which gender assignment to use? ####
# ============================

if (args$gender == 'first') {
   talents$gender <- talents$first_gender
} else if (args$gender == 'second') {
   talents$gender <- talents$second_gender
} else if (args$gender == 'third') {
   talents$gender <- talents$third_gender
}


# ============================
#### Set factor levels for reference category ####
# ============================

# convert to factor to have "female" and "others group" as base category of models
talents$gender <- relevel(factor(talents$gender), ref = "Female")
talents$ctrl_obs_2cat <- relevel(factor(talents$ctrl_obs_2cat), ref = "Others")
# convert to factor to have "non_mobile" as base category of models
talents$mobility_status2 <- relevel(factor(talents$mobility_status2), ref = "Non mobile")

# descriptive table of talents vs. others groups
TABLE_2 <- talents %>% 
  group_by(ctrl_obs_2cat, gender) %>% 
  summarize(count = n_distinct(fake_author_ID)) %>%
  group_by(ctrl_obs_2cat) %>%
  mutate(etotal = sum(count), "In percent" = round(((count / etotal) * 100), digits=2)) %>%
  rename(Group = ctrl_obs_2cat, Gender = gender, "Count of unique authors" = count) %>%
  select(everything(), -etotal)

print(TABLE_2)
write_csv(x = TABLE_2, file = args$output[[1]])
print('Summary table exported')

# ============================
#### Multinomial probit regression models ####
# ============================

### Probit version of models ###
# (does not assume IAA, could be computationally expensive)
# multinomial probit, gender model
mprobit1 <- multinom(mobility_status2 ~ ctrl_obs_2cat * gender, data = talents, probit = TRUE)


# ============================
#### Export data for figures 2 and 3 ####
# ============================

# predicted probabilities
# write predicted probabilities to CSV to visualize in Python
m1_res = tibble(ggpredict(mprobit1, terms = c("ctrl_obs_2cat", "gender")))

print(head(m1_res))

write_csv(x = m1_res, file = args$output[[2]])

# m2_res = tibble(ggpredict(mprobit2, terms = c("ctrl_obs_2cat", "continent")))

# print(head(m2_res))

# write_csv(x = m2_res, file = args$output[[3]])


# ============================
#### Table 3 with model results ####
# ============================

stargazer(mprobit1, type = "html", out = args$output[[3]])

# to have results in log
print('Stat model results: \n')
print(screenreg(mprobit1))

# ============================
#### Table 4 with model results ####
# ============================

# stargazer(mprobit2, type = "html", out = args$output[[5]])




