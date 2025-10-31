## File name to use in search: read_data_run_statistical_model_full_gender_regions_w_controls_model_results.R ##

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
# prevent R from using scientific notation.
options(scipen = 999)
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
p <- add_argument(p, "--ext2use", help="Which file extension should be used (affects statistics reported in model results)?", default=NA, type="character", nargs = Inf)
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

# read the statistical model results already saved as RDA
load(file = args$input[[1]])

print("Model objects loaded from: ")
print(args$input[[1]])

print("Objects in session (ls()): ")
print(ls())

# these are the model objects:
    # m0, m1, m2, m3, mprobit1

# ============================
#### Table 3 with model results ####
# ============================

# create an if statement to define which covariate list to use in results

if (args$region2use == 'continent') {
   covarList2use = c(
    "Ref. category", 
    "Talents",
    "Male", 
    "Unknown", 
    "Americas", 
    "Asia", 
    "Brazil",
    "China",
    "Europe", 
    "Oceania", 
    "USA",
    "South Africa",
    "Academic age",
    "Tal. x M.", 
    "Tal. x Unk.", 
    "Tal. x Americas", 
    "Tal. x Asia", 
    "Tal. x Brazil",
    "Tal. x China",
    "Tal. x Europe", 
    "Tal. x Oceania", 
    "Tal. x USA",
    "Tal. x South Africa",
    "M. x Americas", 
    "Unk. x Americas", 
    "M. x Asia", 
    "Unk. x Asia", 
    "M. x Brazil",
    "Unk. x Brazil",
    "M. x China",
    "Unk. x China",
    "M. x Europe", 
    "Unk. x Europe", 
    "M. x Oceania", 
    "Unk. x Oceania", 
    "M. x USA",
    "Unk. x USA",
    "M. x SouthAfrica", 
    "Unk. x SouthAfrica", 
    "Tal. x M. x Americas", 
    "Tal. x Unk. x Americas", 
    "Tal. x M. x Asia", 
    "Tal. x Unk. x Asia", 
    "Tal. x M. x Brazil", 
    "Tal. x Unk. x Brazil", 
    "Tal. x M. x China", 
    "Tal. x Unk. x China", 
    "Tal. x M. x Europe", 
    "Tal. x Unk. x Europe", 
    "Tal. x M. x Oceania", 
    "Tal. x Unk. x Oceania",
    "Tal. x M. x USA",
    "Tal. x Unk. x USA",
    "Tal. x M. x SouthAfrica", 
    "Tal. x Unk. x SouthAfrica"
    )
} else if (args$region2use == 'UNsubregion') {
   covarList2use = c(
    "Ref. category",
    "Talents",
    "Male",
    "Unknown",
    "Australia NZ", 
    "Brazil",
    "Central Asia",
    "China",
    "Eastern Asia", 
    "Eastern Europe", 
    "Latin America Car.", 
    "Melanesia",
    "Northern Africa", 
    "Northern America", 
    "Northern Europe", 
    "South-eastern Asia", 
    "Southern Asia", 
    "Southern Europe", 
    "USA",
    "Western Asia", 
    "Western Europe", 
    "South Africa",
    "Academic age", 
    "Tal. x M.", 
    "Tal. x Unk.", 
    "Tal. x Australia NZ", 
    "Tal. x Brazil",
    "Tal. x Central Asia",
    "Tal. x China",
    "Tal. x Eastern Asia", 
    "Tal. x Eastern Europe", 
    "Tal. x Latin America Car.", 
    "Tal. x Melanesia",
    "Tal. x Northern Africa", 
    "Tal. x Northern America", 
    "Tal. x Northern Europe", 
    "Tal. x South-eastern Asia", 
    "Tal. x Southern Asia", 
    "Tal. x Southern Europe", 
    "Tal. x USA",
    "Tal. x Western Asia", 
    "Tal. x Western Europe", 
    "Tal. x South Africa",
    "M. x Australia NZ", 
    "Unk. x Australia NZ", 
    "M. x Brazil",
    "Unk. x Brazil",
    "M. x Central Asia",
    "Unk. x Central Asia",
    "M. x China",
    "Unk. x China",
    "M. x Eastern Asia", 
    "Unk. x Eastern Asia", 
    "M. x Eastern Europe", 
    "Unk. x Eastern Europe", 
    "M. x Latin America Car.", 
    "Unk. x Latin America Car.", 
    "M. x Melanesia",
    "Unk. x Melanesia",
    "M. x Northern Africa", 
    "Unk. x Northern Africa", 
    "M. x Northern America", 
    "Unk. x Northern America", 
    "M. x Northern Europe", 
    "Unk. x Northern Europe", 
    "M. x South-eastern Asia", 
    "Unk. x South-eastern Asia", 
    "M. x Southern Asia", 
    "Unk. x Southern Asia", 
    "M. x Southern Europe", 
    "Unk. x Southern Europe", 
    "M. x USA",
    "Unk. x USA",
    "M. x Western Asia", 
    "Unk. x Western Asia", 
    "M. x Western Europe", 
    "Unk. x Western Europe", 
    "M. x South Africa",
    "Unk. x South Africa",
    "Tal. x M. x Australia NZ", 
    "Tal. x Unk. x Australia NZ", 
    "Tal. x M. x Brazil",
    "Tal. x Unk. x Brazil",
    "Tal. x M. x Central Asia",
    "Tal. x Unk. x Central Asia",
    "Tal. x M. x China",
    "Tal. x Unk. x China",
    "Tal. x M. x Eastern Asia", 
    "Tal. x Unk. x Eastern Asia", 
    "Tal. x M. x Eastern Europe", 
    "Tal. x Unk. x Eastern Europe", 
    "Tal. x M. x Latin America Car.", 
    "Tal. x Unk. x Latin America Car.", 
    "Tal. x M. x Melanesia",
    "Tal. x Unk. x Melanesia",
    "Tal. x M. x Northern Africa", 
    "Tal. x Unk. x Northern Africa", 
    "Tal. x M. x Northern America", 
    "Tal. x Unk. x Northern America", 
    "Tal. x M. x Northern Europe", 
    "Tal. x Unk. x Northern Europe", 
    "Tal. x M. x South-eastern Asia", 
    "Tal. x Unk. x South-eastern Asia", 
    "Tal. x M. x Southern Asia", 
    "Tal. x Unk. x Southern Asia", 
    "Tal. x M. x Southern Europe", 
    "Tal. x Unk. x Southern Europe", 
    "Tal. x M. x USA",
    "Tal. x Unk. x USA",
    "Tal. x M. x Western Asia", 
    "Tal. x Unk. x Western Asia", 
    "Tal. x M. x Western Europe", 
    "Tal. x Unk. x Western Europe", 
    "Tal. x M. x South Africa",
    "Tal. x Unk. x South Africa"
    )
} else if (args$region2use == 'WBregion') {
   covarList2use = c(
    "Ref. category", 
    "Talents", 
    "Male", 
    "Unknown", 
    "Brazil",
    "China",
    "East Asia Pacific", 
    "Europe Central Asia", 
    "Latin America Caribbean", 
    "Middle East North Africa", 
    "North America", 
    "South Asia", 
    "USA",
    "South Africa",
    "Academic age", 
    "Tal. x M.", 
    "Tal. x Unk.", 
    "Tal. x Brazil",
    "Tal. x China",
    "Tal. x EastAsiaPa", 
    "Tal. x EuropeCenAs", 
    "Tal. x LatinAmeriCar", 
    "Tal. x MENA", 
    "Tal. x NorthAmer", 
    "Tal. x SouthAsi", 
    "Tal. x USA", 
    "Tal. x SouthAfrica",         
    "M. x Brazil",
    "Unk. x Brazil",
    "M. x China",
    "Unk. x China",
    "M. x EastAsiaPa", 
    "Unk. x EastAsiaPa", 
    "M. x EuropeCenAs", 
    "Unk. x EuropeCenAs", 
    "M. x LatinAmeriCar", 
    "Unk. x LatinAmeriCar", 
    "M. x MENA", 
    "Unk. x MENA", 
    "M. x NorthAmer", 
    "Unk. x NorthAmer", 
    "M. x SouthAsi", 
    "Unk. x SouthAsi", 
    "M. x USA", 
    "Unk. x USA", 
    "M. x SouthAfrica", 
    "Unk. x SouthAfrica", 
    "Tal. x M. x Brazil", 
    "Tal. x Unk. x Brazil", 
    "Tal. x M. x China", 
    "Tal. x Unk. x China", 
    "Tal. x M. x EastAsiaPa", 
    "Tal. x Unk. x EastAsiaPa", 
    "Tal. x M. x EuropeCenAs", 
    "Tal. x Unk. x EuropeCenAs", 
    "Tal. x M. x LatinAmeriCar", 
    "Tal. x Unk. x LatinAmeriCar", 
    "Tal. x M. x MENA", 
    "Tal. x Unk. x MENA", 
    "Tal. x M. x NorthAmer", 
    "Tal. x Unk. x NorthAmer", 
    "Tal. x M. x SouthAsi", 
    "Tal. x Unk. x SouthAsi",
    "Tal. x M. x USA", 
    "Tal. x Unk. x USA", 
    "Tal. x M. x SouthAfrica", 
    "Tal. x Unk. x SouthAfrica"
    )
}

if (args$ext2use == 'html') {
    # report all possible statistics in HTML file for replication materials
    stat2report <- c("vcstp*")
} else if (args$ext2use == 'doc') {
    # report only most important statistics in doc file which goes into paper and has smaller space and refer to replication materials for HTML file and all statistics
    stat2report <- c("vcp*")
}

# Version with covariate labels
# with customized covariate labels, to use at the end for publication ready version!
stargazer(list(m0, m1, m2, m3, mprobit1), type = "html", out = args$output[[1]], single.row = FALSE, intercept.bottom=FALSE, object.names=FALSE, model.numbers=FALSE, dep.var.caption="", 
    column.labels=c(
        "NULL <br>Ref: NonMobile",
        "Talents/Oth. <br>Ref: NonMobile, Oth.",
        "Gender <br>Ref: NonMobile, Oth., Female",
        "Region <br>Ref: NonMobile, Oth., Africa",
        "Full Model <br>Ref: NonMobile, Oth., Female, Africa"
        ), covariate.labels=covarList2use, column.separate=c(3, 3, 3, 3, 3), report=stat2report, keep.stat=c("n", "aic", "bic", "ll"))

# to have results in log
print('Stat model results: \n')
print(screenreg(list(m0, m1, m2, m3, mprobit1)))





