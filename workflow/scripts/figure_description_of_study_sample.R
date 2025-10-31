## File name to use in search: figure_description_of_study_sample.R ##

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
library(RColorBrewer)

# prevent R from using scientific notation.
options(scipen = 999)
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

# ============================
#### Figure 1 ####
# ============================


fig1_description <- talents %>%
  group_by(ctrl_obs_2cat, gender, mobility_status2) %>%
  summarize(count = n_distinct(fake_author_ID)) %>%
  group_by(ctrl_obs_2cat, gender) %>%
  mutate(etotal = sum(count), Proportion = (count / etotal) * 100) %>%
  ggplot(aes(x = ctrl_obs_2cat, y = Proportion, group = mobility_status2, linetype = mobility_status2, color = mobility_status2)) +
  geom_line() +
  geom_point(size = 4, show.legend = FALSE) +
  facet_wrap(~gender) + 
  theme_classic() +
  labs(x = "", y = "Proportion in % per combination of gender, mobility, talents/others groups", color = "Mobility status", linetype = "Mobility status") +
  theme(
    legend.position = "bottom",
    axis.text.x = element_text(size = 8),
    axis.text.y = element_text(size = 8),
    axis.title.x = element_text(size = 9),
    axis.title.y = element_text(size = 9),
    strip.text = element_text(size = 8, face='bold')
)

ggsave(plot = fig1_description, filename = args$output[[1]], width = 16, height = 14, units = c("cm"), limitsize = FALSE, dpi = 500)


print('Figure with description of sample exported in: ')
print(args$output[[1]])

# ============================
#### Testing independence of categorical variables ####
# ============================

print(paste(replicate(50, "#"), collapse = ""))
print("#### Testing independence of categorical variables ####")
# Create a contingency table of the two categorical variables
ctrl_obs_2cat_vs_gender <- table(talents$ctrl_obs_2cat, talents$gender)

# Perform the Chi-squared test
print(chisq.test(ctrl_obs_2cat_vs_gender))

ctrl_obs_2cat_vs_mobility <- table(talents$ctrl_obs_2cat, talents$mobility_status2)

# Perform the Chi-squared test
print(chisq.test(ctrl_obs_2cat_vs_mobility))

gender_vs_mobility <- table(talents$gender, talents$mobility_status2)

# Perform the Chi-squared test
print(chisq.test(gender_vs_mobility))

print(paste(replicate(50, "#"), collapse = ""))


# ============================
#### Adding comparison of groups and wilcox or kruksal test in log to report in manuscript ####
# ============================

tal_summ <- talents %>%
  group_by(ctrl_obs_2cat, gender, mobility_status2) %>%
  summarize(count = n_distinct(fake_author_ID)) %>%
  group_by(ctrl_obs_2cat, gender) %>%
  mutate(etotal = sum(count), Proportion = (count / etotal) * 100)

print(paste(replicate(50, "#"), collapse = ""))

print('A summary table is created for groups and proportion of researchers per groups as:')

print(tal_summ)

print(paste(replicate(50, "#"), collapse = ""))

print("Now some tests for group differences to report in paper: ")

print(wilcox.test(count ~ ctrl_obs_2cat, data=tal_summ))

print(paste(replicate(50, "#"), collapse = ""))

print(kruskal.test(count ~ ctrl_obs_2cat, data = tal_summ))

print(paste(replicate(50, "#"), collapse = ""))

print(kruskal.test(count ~ gender, data = tal_summ))

print(paste(replicate(50, "#"), collapse = ""))

print(kruskal.test(count ~ mobility_status2, data = tal_summ))

print(paste(replicate(50, "#"), collapse = ""))

print("Here I will repeat these test by filtering group per group!")

print(paste(replicate(50, "#"), collapse = ""))

females_ctrl_obs = tal_summ %>%
   filter(gender == 'Female' & mobility_status2 == 'Non mobile')

print(females_ctrl_obs)

print(wilcox.test(count ~ ctrl_obs_2cat, data=females_ctrl_obs))

print(paste(replicate(50, "#"), collapse = ""))

males_ctrl_obs = tal_summ %>%
   filter(gender == 'Male' & mobility_status2 == 'Non mobile')

print(males_ctrl_obs)

print(wilcox.test(count ~ ctrl_obs_2cat, data=males_ctrl_obs))

print(paste(replicate(50, "#"), collapse = ""))

unkn_ctrl_obs = tal_summ %>%
   filter(gender == 'Unknown' & mobility_status2 == 'Non mobile')

print(unkn_ctrl_obs)

print(wilcox.test(count ~ ctrl_obs_2cat, data=unkn_ctrl_obs))

print(paste(replicate(50, "#"), collapse = ""))
