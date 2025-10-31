## File name to use in search: testing_model_diagnostics_goodnessOfFit.R ##

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

# libraries needed
library(tidyverse)
library(stargazer)
library(texreg)
library(nnet)
library(GGally)
library(ggeffects)

# for model diagnostics and tests
library(lmtest)
library("DescTools")

# R to use English console messages
Sys.setenv(LANG = "en")
# prevent R from using scientific notation.
options(scipen = 99999)


# ============================
#### For command line arguments ####
# ============================

library(argparser)

# Create a parser
p <- arg_parser("")

# Add command line arguments, "nargs = Inf" enables multiple arguments to be passed
p <- add_argument(p, "--input", help="Path to input file(s)", default=NA, type="character", nargs = Inf)
p <- add_argument(p, "--gender", help="Gender assignment to use", default=NA, type="character", nargs = Inf)
p <- add_argument(p, "--region2use", help="Which geographical region should be used?", default=NA, type="character", nargs = Inf)
p <- add_argument(p, "--output", help="ath to save output(s)", default=NA, type="character", nargs = Inf)

# Parse the command line arguments
args <- parse_args(p)

# print a few things
print('Running the script now at time: ')
print(Sys.time())
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
#### Which gender AND region assignment to use? ####
# ============================

if (args$gender == 'first') {
   talents$gender <- talents$first_gender
} else if (args$gender == 'second') {
   talents$gender <- talents$second_gender
} else if (args$gender == 'third') {
   talents$gender <- talents$third_gender
}


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

# convert to factor to have "female" and "others group" as base category of models
talents$gender <- relevel(factor(talents$gender), ref = "Female")
talents$ctrl_obs_2cat <- relevel(factor(talents$ctrl_obs_2cat), ref = "Others")
# convert to factor to have "non_mobile" as base category of models
talents$mobility_status2 <- relevel(factor(talents$mobility_status2), ref = "Non mobile")

# ============================
#### Multinomial probit regression models' diagnostics tests and goodness of fit ####
# ============================

# create an empty list to save results
results_list <- list()

# save command line arguments as part of results list
results_list$command_line_args <- args

# ============================
#### Recommended sensitivity and robustness checks ####
# ============================

# following guidelines from:
# https://bookdown.org/chua/ber642_advanced_regression/multinomial-logistic-regression.html

# only intercept model
m0 <- multinom(mobility_status2 ~ 1, data = talents, probit = TRUE, maxit = 300)

mprobit1 <- multinom(mobility_status2 ~ ctrl_obs_2cat * gender * region2use + acadmic_age, data = talents, probit = TRUE, maxit = 300, model=TRUE)

print(paste(replicate(50, "#"), collapse = ""))
print("Model diagnostics and goodness of fit results for the multinomial probit regression model with controls:")

# Check the Z-score for the model (wald Z)
z <- summary(mprobit1)$coefficients/summary(mprobit1)$standard.errors
print(paste(replicate(50, "#"), collapse = ""))
print("Z-scores for the model coefficients:")
print(z)

results_list$z_scores <- z

# 2-tailed z test
p <- (1 - pnorm(abs(z), 0, 1)) * 2
print(paste(replicate(50, "#"), collapse = ""))
print("P-values for the model coefficients:")
print(p)

results_list$p_values <- p

# only intercept model
# Compare the our test model with the "Only intercept" model
print(paste(replicate(50, "#"), collapse = ""))
print("ANOVA test comparing the null model and the full model with controls:")
print(anova(m0, mprobit1, test = 'Chisq'))

results_list$explained_anova <- anova(m0, mprobit1, test = 'Chisq')

# Analysis of Deviance Table
results_list$explained_perc <- 100 * (1 - deviance(mprobit1) / deviance(m0))
print(paste(replicate(50, "#"), collapse = ""))
print("Percentage of deviance explained by the full model with controls:")
print(results_list$explained_perc)

## alternative method
# test comparing null model and full model, alternatively using lrtest
print(paste(replicate(50, "#"), collapse = ""))
print("Likelihood ratio test comparing the null model and the full model with controls:")
print(lrtest(m0, mprobit1))

results_list$lrtest_chi <- lrtest(m0, mprobit1)


# Check the predicted probability for each mobility
print(paste(replicate(50, "#"), collapse = ""))
print("Fitted values (predicted probabilities) for the full model with controls:")
print(head(mprobit1$fitted.values,30))

# predicted results
print(paste(replicate(50, "#"), collapse = ""))
print("Predicted values for the full model with controls:")
print(head(predict(mprobit1),30))


# Test the goodness of fit
print(paste(replicate(50, "#"), collapse = ""))
print("Chi-squared test for goodness of fit for the full model with controls:")
print(chisq.test(talents$mobility_status2,predict(mprobit1)))

results_list$goodness_fit_chi <- lrtest(m0, mprobit1)


# Calculate the R Square
print(paste(replicate(50, "#"), collapse = ""))
print("Pseudo R-squared values for the full model with controls:")
print(PseudoR2(mprobit1, which = c("CoxSnell","Nagelkerke","McFadden")))

# PseudoR2
results_list$PseudoR2 <- PseudoR2(mprobit1, which = c("CoxSnell","Nagelkerke","McFadden"))


# Use the lmtest package to run Likelihood Ratio Tests

print(paste(replicate(50, "#"), collapse = ""))
print("Likelihood ratio tests for each variable in the full model with controls:")
print(lrtest(mprobit1, "ctrl_obs_2cat"))
results_list$lrtest_ctrl_obs_2cat <- lrtest(mprobit1, "ctrl_obs_2cat")

print(paste(replicate(50, "#"), collapse = ""))
print(lrtest(mprobit1, "gender"))
results_list$lrtest_gender <- lrtest(mprobit1, "gender")

print(paste(replicate(50, "#"), collapse = ""))
print(lrtest(mprobit1, "region2use"))
results_list$lrtest_region2use <- lrtest(mprobit1, "region2use")

print(paste(replicate(50, "#"), collapse = ""))
print(lrtest(mprobit1, "ctrl_obs_2cat:gender"))
results_list$lrtest_ctrl_obs_2cat_gender <- lrtest(mprobit1, "ctrl_obs_2cat:gender")

print(paste(replicate(50, "#"), collapse = ""))
print(lrtest(mprobit1, "ctrl_obs_2cat:region2use"))
results_list$lrtest_ctrl_obs_2cat_region2use <- lrtest(mprobit1, "ctrl_obs_2cat:region2use")

print(paste(replicate(50, "#"), collapse = ""))
# save results list as RData
save(results_list, file = args$output[[1]]) 

print('Model diagnostics and goodness of fit results saved in: ')
print(args$output[[1]]) 

