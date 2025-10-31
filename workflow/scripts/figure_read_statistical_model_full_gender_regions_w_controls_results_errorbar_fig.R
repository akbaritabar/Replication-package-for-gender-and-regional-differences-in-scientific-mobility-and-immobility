## File name to use in search: figure_read_statistical_model_full_gender_regions_w_controls_results_errorbar_fig.R ##

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
library(nnet)
# to obtain model's confidence intervals in tidy format
library(broom)

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

# read the statistical model results already saved as RDA
load(file = args$input[[1]])

print("Model objects loaded from: ")
print(args$input[[1]])

print("Objects in session (ls()): ")
print(ls())

# these are the model objects:
    # m0, m1, m2, m3, mprobit1

# ============================
#### Table 7 with model's tidy coefficients, confidence intervals etc ####
# ============================

# create an if statement to define which covariate list to use in results

if (args$region2use == 'continent') {
fig_width = 16 
fig_height = 15

# Adopted code from Ignacio Carrasco's script for our other co-authored project
tidy_r1 <- function(reg) {
  reg %>% tidy(conf.int = TRUE) %>% 
    mutate(term = case_when(
             term == "(Intercept)" ~ "Ref. category",
             term == "ctrl_obs_2catTalents" ~ "Talents",                                 
             term == "genderMale" ~ "Male",
             term == "genderUnknown" ~ "Unknown",
             term == "region2useAmericas" ~ "Americas",          
             term == "region2useAsia" ~ "Asia",             
             term == "region2useBRA" ~ "Brazil",
             term == "region2useCHN" ~ "China",
             term == "region2useEurope" ~ "Europe",            
             term == "region2useOceania" ~ "Oceania",           
             term == "region2useUSA" ~ "USA",
             term == "region2useZAF" ~ "South Africa",
             term == "acadmic_age" ~ "Academic age",
             term == "ctrl_obs_2catTalents:genderMale" ~ "Tal. x M.",
             term == "ctrl_obs_2catTalents:genderUnknown" ~ "Tal. x Unk.",
             term == "ctrl_obs_2catTalents:region2useAmericas" ~ "Tal. x Americas",              
             term == "ctrl_obs_2catTalents:region2useAsia" ~ "Tal. x Asia",                  
             term == "ctrl_obs_2catTalents:region2useBRA" ~ "Tal. x Brazil",
             term == "ctrl_obs_2catTalents:region2useCHN" ~ "Tal. x China",
             term == "ctrl_obs_2catTalents:region2useEurope" ~ "Tal. x Europe",                
             term == "ctrl_obs_2catTalents:region2useOceania" ~ "Tal. x Oceania",               
             term == "ctrl_obs_2catTalents:region2useUSA" ~ "Tal. x USA",
             term == "ctrl_obs_2catTalents:region2useZAF" ~ "Tal. x SouthAfrica",
             term == "genderMale:region2useAmericas" ~ "M. x Americas",
             term == "genderUnknown:region2useAmericas" ~ "Unk. x Americas",                               
             term == "genderMale:region2useAsia" ~ "M. x Asia",   
             term == "genderUnknown:region2useAsia" ~ "Unk. x Asia",
             term == "genderMale:region2useBRA" ~ "M. x Brazil",    
             term == "genderUnknown:region2useBRA" ~ "Unk. x Brazil", 
             term == "genderMale:region2useCHN" ~ "M. x China",    
             term == "genderUnknown:region2useCHN" ~ "Unk. x China", 
             term == "genderMale:region2useEurope" ~ "M. x Europe", 
             term == "genderUnknown:region2useEurope" ~ "Unk. x Europe",                                 
             term == "genderMale:region2useOceania" ~ "M. x Oceania",
             term == "genderUnknown:region2useOceania" ~ "Unk. x Oceania",                                
             term == "genderMale:region2useUSA" ~ "M. x USA",    
             term == "genderUnknown:region2useUSA" ~ "Unk. x USA", 
             term == "genderMale:region2useZAF" ~ "M. x SouthAfrica",    
             term == "genderUnknown:region2useZAF" ~ "Unk. x SouthAfrica", 
             term == "ctrl_obs_2catTalents:genderMale:region2useAmericas" ~ "Tal. x M. x Americas",   
             term == "ctrl_obs_2catTalents:genderUnknown:region2useAmericas" ~ "Tal. x Unk. x Americas",
             term == "ctrl_obs_2catTalents:genderMale:region2useAsia" ~ "Tal. x M. x Asia",       
             term == "ctrl_obs_2catTalents:genderUnknown:region2useAsia" ~ "Tal. x Unk. x Asia",    
             term == "ctrl_obs_2catTalents:genderMale:region2useBRA" ~ "Tal. x M. x Brazil",        
             term == "ctrl_obs_2catTalents:genderUnknown:region2useBRA" ~ "Tal. x Unk. x Brazil",     
             term == "ctrl_obs_2catTalents:genderMale:region2useCHN" ~ "Tal. x M. x China",        
             term == "ctrl_obs_2catTalents:genderUnknown:region2useCHN" ~ "Tal. x Unk. x China",     
             term == "ctrl_obs_2catTalents:genderMale:region2useEurope" ~ "Tal. x M. x Europe",     
             term == "ctrl_obs_2catTalents:genderUnknown:region2useEurope" ~ "Tal. x Unk. x Europe",  
             term == "ctrl_obs_2catTalents:genderMale:region2useOceania" ~ "Tal. x M. x Oceania",    
             term == "ctrl_obs_2catTalents:genderUnknown:region2useOceania" ~ "Tal. x Unk. x Oceania", 
             term == "ctrl_obs_2catTalents:genderMale:region2useUSA" ~ "Tal. x M. x USA",        
             term == "ctrl_obs_2catTalents:genderUnknown:region2useUSA" ~ "Tal. x Unk. x USA",     
             term == "ctrl_obs_2catTalents:genderMale:region2useZAF" ~ "Tal. x M. x SouthAfrica",        
             term == "ctrl_obs_2catTalents:genderUnknown:region2useZAF" ~ "Tal. x Unk. x SouthAfrica",
             TRUE ~ term),
           significant = if_else(p.value <= 0.05, false = "No", "Yes"))  
}

} else if (args$region2use == 'UNsubregion') {

fig_width = 16 
fig_height = 20

# Adopted code from Ignacio Carrasco's script for our other co-authored project
tidy_r1 <- function(reg) {
  reg %>% tidy(conf.int = TRUE) %>% 
    mutate(term = case_when(
             term == "(Intercept)" ~ "Ref. category",
             term == "ctrl_obs_2catTalents" ~ "Talents",
             term == "genderMale" ~ "Male",
             term == "genderUnknown" ~ "Unk.",
             term == "region2useAustralia and New Zealand" ~ "Australia NZ", 
             term == "region2useBRA" ~ "Brazil",
             term == "region2useCentral Asia" ~ "Central Asia",
             term == "region2useCHN" ~ "China",
             term == "region2useEastern Asia" ~ "Eastern Asia", 
             term == "region2useEastern Europe" ~ "Eastern Europe", 
             term == "region2useLatin America and the Caribbean" ~ "Latin America Car.", 
             term == "region2useMelanesia" ~ "Melanesia",
             term == "region2useNorthern Africa" ~ "Northern Africa", 
             term == "region2useNorthern America" ~ "Northern America", 
             term == "region2useNorthern Europe" ~ "Northern Europe", 
             term == "region2useSouth-eastern Asia" ~ "South-eastern Asia", 
             term == "region2useSouthern Asia" ~ "Southern Asia", 
             term == "region2useSouthern Europe" ~ "Southern Europe", 
             term == "region2useUSA" ~ "USA",
             term == "region2useWestern Asia" ~ "Western Asia", 
             term == "region2useWestern Europe" ~ "Western Europe", 
             term == "region2useZAF" ~ "South Africa",
             term == "acadmic_age" ~ "Academic age", 
             term == "ctrl_obs_2catTalents:genderMale" ~ "Tal. x M.", 
             term == "ctrl_obs_2catTalents:genderUnknown" ~ "Tal. x Unk.", 
             term == "ctrl_obs_2catTalents:region2useAustralia and New Zealand" ~ "Tal. x Australia NZ", 
             term == "ctrl_obs_2catTalents:region2useBRA" ~ "Tal. x Brazil",
             term == "ctrl_obs_2catTalents:region2useCentral Asia" ~ "Tal. x Central Asia",
             term == "ctrl_obs_2catTalents:region2useCHN" ~ "Tal. x China",
             term == "ctrl_obs_2catTalents:region2useEastern Asia" ~ "Tal. x Eastern Asia", 
             term == "ctrl_obs_2catTalents:region2useEastern Europe" ~ "Tal. x Eastern Europe", 
             term == "ctrl_obs_2catTalents:region2useLatin America and the Caribbean" ~ "Tal. x Latin America Car.", 
             term == "ctrl_obs_2catTalents:region2useMelanesia" ~ "Tal. x Melanesia",
             term == "ctrl_obs_2catTalents:region2useNorthern Africa" ~ "Tal. x Northern Africa", 
             term == "ctrl_obs_2catTalents:region2useNorthern America" ~ "Tal. x Northern America", 
             term == "ctrl_obs_2catTalents:region2useNorthern Europe" ~ "Tal. x Northern Europe", 
             term == "ctrl_obs_2catTalents:region2useSouth-eastern Asia" ~ "Tal. x South-eastern Asia", 
             term == "ctrl_obs_2catTalents:region2useSouthern Asia" ~ "Tal. x Southern Asia", 
             term == "ctrl_obs_2catTalents:region2useSouthern Europe" ~ "Tal. x Southern Europe", 
             term == "ctrl_obs_2catTalents:region2useUSA" ~ "Tal. x USA",
             term == "ctrl_obs_2catTalents:region2useWestern Asia" ~ "Tal. x Western Asia", 
             term == "ctrl_obs_2catTalents:region2useWestern Europe" ~ "Tal. x Western Europe", 
             term == "ctrl_obs_2catTalents:region2useZAF" ~ "Tal. x South Africa",
             term == "genderMale:region2useAustralia and New Zealand" ~ "M. x Australia NZ", 
             term == "genderUnknown:region2useAustralia and New Zealand" ~ "Unk. x Australia NZ", 
             term == "genderMale:region2useBRA" ~ "M. x Brazil",
             term == "genderUnknown:region2useBRA" ~ "Unk. x Brazil",
             term == "genderMale:region2useCentral Asia" ~ "M. x Central Asia",
             term == "genderUnknown:region2useCentral Asia" ~ "Unk. x Central Asia",
             term == "genderMale:region2useCHN" ~ "M. x China",
             term == "genderUnknown:region2useCHN" ~ "Unk. x China",
             term == "genderMale:region2useEastern Asia" ~ "M. x Eastern Asia", 
             term == "genderUnknown:region2useEastern Asia" ~ "Unk. x Eastern Asia", 
             term == "genderMale:region2useEastern Europe" ~ "M. x Eastern Europe", 
             term == "genderUnknown:region2useEastern Europe" ~ "Unk. x Eastern Europe", 
             term == "genderMale:region2useLatin America and the Caribbean" ~ "M. x Latin America Car.", 
             term == "genderUnknown:region2useLatin America and the Caribbean" ~ "Unk. x Latin America Car.", 
             term == "genderMale:region2useMelanesia" ~ "M. x Melanesia",
             term == "genderUnknown:region2useMelanesia" ~ "Unk. x Melanesia",
             term == "genderMale:region2useNorthern Africa" ~ "M. x Northern Africa", 
             term == "genderUnknown:region2useNorthern Africa" ~ "Unk. x Northern Africa", 
             term == "genderMale:region2useNorthern America" ~ "M. x Northern America", 
             term == "genderUnknown:region2useNorthern America" ~ "Unk. x Northern America", 
             term == "genderMale:region2useNorthern Europe" ~ "M. x Northern Europe", 
             term == "genderUnknown:region2useNorthern Europe" ~ "Unk. x Northern Europe", 
             term == "genderMale:region2useSouth-eastern Asia" ~ "M. x South-eastern Asia", 
             term == "genderUnknown:region2useSouth-eastern Asia" ~ "Unk. x South-eastern Asia", 
             term == "genderMale:region2useSouthern Asia" ~ "M. x Southern Asia", 
             term == "genderUnknown:region2useSouthern Asia" ~ "Unk. x Southern Asia", 
             term == "genderMale:region2useSouthern Europe" ~ "M. x Southern Europe", 
             term == "genderUnknown:region2useSouthern Europe" ~ "Unk. x Southern Europe", 
             term == "genderMale:region2useUSA" ~ "M. x USA",
             term == "genderUnknown:region2useUSA" ~ "Unk. x USA",
             term == "genderMale:region2useWestern Asia" ~ "M. x Western Asia", 
             term == "genderUnknown:region2useWestern Asia" ~ "Unk. x Western Asia", 
             term == "genderMale:region2useWestern Europe" ~ "M. x Western Europe", 
             term == "genderUnknown:region2useWestern Europe" ~ "Unk. x Western Europe", 
             term == "genderMale:region2useZAF" ~ "M. x South Africa",
             term == "genderUnknown:region2useZAF" ~ "Unk. x South Africa",
             term == "ctrl_obs_2catTalents:genderMale:region2useAustralia and New Zealand" ~ "Tal. x M. x Australia NZ", 
             term == "ctrl_obs_2catTalents:genderUnknown:region2useAustralia and New Zealand" ~ "Tal. x Unk. x Australia NZ", 
             term == "ctrl_obs_2catTalents:genderMale:region2useBRA" ~ "Tal. x M. x Brazil",
             term == "ctrl_obs_2catTalents:genderUnknown:region2useBRA" ~ "Tal. x Unk. x Brazil",
             term == "ctrl_obs_2catTalents:genderMale:region2useCentral Asia" ~ "Tal. x M. x Central Asia",
             term == "ctrl_obs_2catTalents:genderUnknown:region2useCentral Asia" ~ "Tal. x Unk. x Central Asia",
             term == "ctrl_obs_2catTalents:genderMale:region2useCHN" ~ "Tal. x M. x China",
             term == "ctrl_obs_2catTalents:genderUnknown:region2useCHN" ~ "Tal. x Unk. x China",
             term == "ctrl_obs_2catTalents:genderMale:region2useEastern Asia" ~ "Tal. x M. x Eastern Asia", 
             term == "ctrl_obs_2catTalents:genderUnknown:region2useEastern Asia" ~ "Tal. x Unk. x Eastern Asia", 
             term == "ctrl_obs_2catTalents:genderMale:region2useEastern Europe" ~ "Tal. x M. x Eastern Europe", 
             term == "ctrl_obs_2catTalents:genderUnknown:region2useEastern Europe" ~ "Tal. x Unk. x Eastern Europe", 
             term == "ctrl_obs_2catTalents:genderMale:region2useLatin America and the Caribbean" ~ "Tal. x M. x Latin America Car.", 
             term == "ctrl_obs_2catTalents:genderUnknown:region2useLatin America and the Caribbean" ~ "Tal. x Unk. x Latin America Car.", 
             term == "ctrl_obs_2catTalents:genderMale:region2useMelanesia" ~ "Tal. x M. x Melanesia",
             term == "ctrl_obs_2catTalents:genderUnknown:region2useMelanesia" ~ "Tal. x Unk. x Melanesia",
             term == "ctrl_obs_2catTalents:genderMale:region2useNorthern Africa" ~ "Tal. x M. x Northern Africa", 
             term == "ctrl_obs_2catTalents:genderUnknown:region2useNorthern Africa" ~ "Tal. x Unk. x Northern Africa", 
             term == "ctrl_obs_2catTalents:genderMale:region2useNorthern America" ~ "Tal. x M. x Northern America", 
             term == "ctrl_obs_2catTalents:genderUnknown:region2useNorthern America" ~ "Tal. x Unk. x Northern America", 
             term == "ctrl_obs_2catTalents:genderMale:region2useNorthern Europe" ~ "Tal. x M. x Northern Europe", 
             term == "ctrl_obs_2catTalents:genderUnknown:region2useNorthern Europe" ~ "Tal. x Unk. x Northern Europe", 
             term == "ctrl_obs_2catTalents:genderMale:region2useSouth-eastern Asia" ~ "Tal. x M. x South-eastern Asia", 
             term == "ctrl_obs_2catTalents:genderUnknown:region2useSouth-eastern Asia" ~ "Tal. x Unk. x South-eastern Asia", 
             term == "ctrl_obs_2catTalents:genderMale:region2useSouthern Asia" ~ "Tal. x M. x Southern Asia", 
             term == "ctrl_obs_2catTalents:genderUnknown:region2useSouthern Asia" ~ "Tal. x Unk. x Southern Asia", 
             term == "ctrl_obs_2catTalents:genderMale:region2useSouthern Europe" ~ "Tal. x M. x Southern Europe", 
             term == "ctrl_obs_2catTalents:genderUnknown:region2useSouthern Europe" ~ "Tal. x Unk. x Southern Europe", 
             term == "ctrl_obs_2catTalents:genderMale:region2useUSA" ~ "Tal. x M. x USA",
             term == "ctrl_obs_2catTalents:genderUnknown:region2useUSA" ~ "Tal. x Unk. x USA",
             term == "ctrl_obs_2catTalents:genderMale:region2useWestern Asia" ~ "Tal. x M. x Western Asia", 
             term == "ctrl_obs_2catTalents:genderUnknown:region2useWestern Asia" ~ "Tal. x Unk. x Western Asia", 
             term == "ctrl_obs_2catTalents:genderMale:region2useWestern Europe" ~ "Tal. x M. x Western Europe", 
             term == "ctrl_obs_2catTalents:genderUnknown:region2useWestern Europe" ~ "Tal. x Unk. x Western Europe", 
             term == "ctrl_obs_2catTalents:genderMale:region2useZAF" ~ "Tal. x M. x South Africa",
             term == "ctrl_obs_2catTalents:genderUnknown:region2useZAF" ~ "Tal. x Unk. x South Africa",
             TRUE ~ term),
           significant = if_else(p.value <= 0.05, false = "No", "Yes"))  
}
} else if (args$region2use == 'WBregion') {

fig_width = 16 
fig_height = 18

# Adopted code from Ignacio Carrasco's script for our other co-authored project
tidy_r1 <- function(reg) {
  reg %>% tidy(conf.int = TRUE) %>% 
    mutate(term = case_when(
             term == "(Intercept)" ~ "Ref. category", 
             term == "ctrl_obs_2catTalents" ~ "Talents", 
             term == "genderMale" ~ "Male", 
             term == "genderUnknown" ~ "Unknown", 
             term == "region2useBRA" ~ "Brazil",
             term == "region2useCHN" ~ "China",
             term == "region2useEast Asia & Pacific" ~ "East Asia Pacific", 
             term == "region2useEurope & Central Asia" ~ "Europe Central Asia", 
             term == "region2useLatin America & Caribbean" ~ "Latin America Caribbean", 
             term == "region2useMiddle East & North Africa" ~ "Middle East North Africa", 
             term == "region2useNorth America" ~ "North America", 
             term == "region2useSouth Asia" ~ "South Asia", 
             term == "region2useUSA" ~ "USA",
             term == "region2useZAF" ~ "South Africa",
             term == "acadmic_age" ~ "Academic age", 
             term == "ctrl_obs_2catTalents:genderMale" ~ "Tal. x M.", 
             term == "ctrl_obs_2catTalents:genderUnknown" ~ "Tal. x Unk.", 
             term == "ctrl_obs_2catTalents:region2useBRA" ~ "Tal. x Brazil",
             term == "ctrl_obs_2catTalents:region2useCHN" ~ "Tal. x China",
             term == "ctrl_obs_2catTalents:region2useEast Asia & Pacific" ~ "Tal. x EastAsiaPa", 
             term == "ctrl_obs_2catTalents:region2useEurope & Central Asia" ~ "Tal. x EuropeCenAs", 
             term == "ctrl_obs_2catTalents:region2useLatin America & Caribbean" ~ "Tal. x LatinAmeriCar", 
             term == "ctrl_obs_2catTalents:region2useMiddle East & North Africa" ~ "Tal. x MENA", 
             term == "ctrl_obs_2catTalents:region2useNorth America" ~ "Tal. x NorthAmer", 
             term == "ctrl_obs_2catTalents:region2useSouth Asia" ~ "Tal. x SouthAsi", 
             term == "ctrl_obs_2catTalents:region2useUSA" ~ "Tal. x USA", 
             term == "ctrl_obs_2catTalents:region2useZAF" ~ "Tal. x SouthAfrica",         
             term == "genderMale:region2useBRA" ~ "M. x Brazil",
             term == "genderUnknown:region2useBRA" ~ "Unk. x Brazil",
             term == "genderMale:region2useCHN" ~ "M. x China",
             term == "genderUnknown:region2useCHN" ~ "Unk. x China",
             term == "genderMale:region2useEast Asia & Pacific" ~ "M. x EastAsiaPa", 
             term == "genderUnknown:region2useEast Asia & Pacific" ~ "Unk. x EastAsiaPa", 
             term == "genderMale:region2useEurope & Central Asia" ~ "M. x EuropeCenAs", 
             term == "genderUnknown:region2useEurope & Central Asia" ~ "Unk. x EuropeCenAs", 
             term == "genderMale:region2useLatin America & Caribbean" ~ "M. x LatinAmeriCar", 
             term == "genderUnknown:region2useLatin America & Caribbean" ~ "Unk. x LatinAmeriCar", 
             term == "genderMale:region2useMiddle East & North Africa" ~ "M. x MENA", 
             term == "genderUnknown:region2useMiddle East & North Africa" ~ "Unk. x MENA", 
             term == "genderMale:region2useNorth America" ~ "M. x NorthAmer", 
             term == "genderUnknown:region2useNorth America" ~ "Unk. x NorthAmer", 
             term == "genderMale:region2useSouth Asia" ~ "M. x SouthAsi", 
             term == "genderUnknown:region2useSouth Asia" ~ "Unk. x SouthAsi", 
             term == "genderMale:region2useUSA" ~ "M. x USA", 
             term == "genderUnknown:region2useUSA" ~ "Unk. x USA", 
             term == "genderMale:region2useZAF" ~ "M. x SouthAfrica", 
             term == "genderUnknown:region2useZAF" ~ "Unk. x SouthAfrica", 
             term == "ctrl_obs_2catTalents:genderMale:region2useBRA" ~ "Tal. x M. x Brazil", 
             term == "ctrl_obs_2catTalents:genderUnknown:region2useBRA" ~ "Tal. x Unk. x Brazil", 
             term == "ctrl_obs_2catTalents:genderMale:region2useCHN" ~ "Tal. x M. x China", 
             term == "ctrl_obs_2catTalents:genderUnknown:region2useCHN" ~ "Tal. x Unk. x China", 
             term == "ctrl_obs_2catTalents:genderMale:region2useEast Asia & Pacific" ~ "Tal. x M. x EastAsiaPa", 
             term == "ctrl_obs_2catTalents:genderUnknown:region2useEast Asia & Pacific" ~ "Tal. x Unk. x EastAsiaPa", 
             term == "ctrl_obs_2catTalents:genderMale:region2useEurope & Central Asia" ~ "Tal. x M. x EuropeCenAs", 
             term == "ctrl_obs_2catTalents:genderUnknown:region2useEurope & Central Asia" ~ "Tal. x Unk. x EuropeCenAs", 
             term == "ctrl_obs_2catTalents:genderMale:region2useLatin America & Caribbean" ~ "Tal. x M. x LatinAmeriCar", 
             term == "ctrl_obs_2catTalents:genderUnknown:region2useLatin America & Caribbean" ~ "Tal. x Unk. x LatinAmeriCar", 
             term == "ctrl_obs_2catTalents:genderMale:region2useMiddle East & North Africa" ~ "Tal. x M. x MENA", 
             term == "ctrl_obs_2catTalents:genderUnknown:region2useMiddle East & North Africa" ~ "Tal. x Unk. x MENA", 
             term == "ctrl_obs_2catTalents:genderMale:region2useNorth America" ~ "Tal. x M. x NorthAmer", 
             term == "ctrl_obs_2catTalents:genderUnknown:region2useNorth America" ~ "Tal. x Unk. x NorthAmer", 
             term == "ctrl_obs_2catTalents:genderMale:region2useSouth Asia" ~ "Tal. x M. x SouthAsi", 
             term == "ctrl_obs_2catTalents:genderUnknown:region2useSouth Asia" ~ "Tal. x Unk. x SouthAsi",
             term == "ctrl_obs_2catTalents:genderMale:region2useUSA" ~ "Tal. x M. x USA", 
             term == "ctrl_obs_2catTalents:genderUnknown:region2useUSA" ~ "Tal. x Unk. x USA", 
             term == "ctrl_obs_2catTalents:genderMale:region2useZAF" ~ "Tal. x M. x SouthAfrica", 
             term == "ctrl_obs_2catTalents:genderUnknown:region2useZAF" ~ "Tal. x Unk. x SouthAfrica",
             TRUE ~ term),
           significant = if_else(p.value <= 0.05, false = "No", "Yes"))  
}
}

####### MODEL RESULTS TABLE ##########

res_tab <- mprobit1 %>% 
    tidy_r1 %>% 
    filter(!is.na(significant))

# export to csv
res_tab %>% 
    # round numbers to 3 digits
    mutate_if(is.numeric, round, 3) %>%
    filter(!is.na(significant)) %>% 
    # rename columns
    select(Mobility = `y.level`, Term = term, Estimate = estimate, `Standard error` = `std.error`, Statistic = statistic, `P-value` = `p.value`, `Lower bound of confidence` =	conf.low, `Upper bound of confidence` = conf.high, `Significance status` = significant) %>% 
    write_csv(file = args$output[[1]])

# to confirm figure and table are exported
print('Detailed table of statistical model results exported in: \n')
print(args$output[[1]])


####### ERROR BAR FIGURE ##########
# This function is adopted from Dr. Jose Ignacio Carrasco's script for our other co-authored project
plot_reg <- function(reg_tidy) { 
  
  reg_tidy %>%  
    # user fct_reorder to sort terms from highest to lowest coefficient
    ggplot(aes(estimate, fct_reorder(term, estimate))) +
    geom_point(aes(color = factor(y.level), shape = factor(significant)), size = 2, show.legend = T, position=position_dodge(width=0.5)) +
    geom_errorbarh(aes(xmin = conf.low, xmax = conf.high, color = factor(y.level)), height=0.2, position=position_dodge(width=0.5)) +
    geom_vline(xintercept = 0, lty = 2) +
    theme_minimal() +
    theme(
        axis.text.x = element_text(size = 6),
        axis.text.y = element_text(size = 6),
        axis.title.x = element_text(size = 6),
        legend.position = "bottom",
        legend.title = element_text(size = 7),
        legend.text = element_text(size = 6),
        plot.title = element_blank()) +
    labs(title = NULL,
         y = NULL,
         x = "Coefficient",
         color = 'Mobility',
         shape = 'Significance') +
    guides(color = guide_legend(nrow = 1, byrow = TRUE),
           shape = guide_legend(nrow = 1, byrow = TRUE))
   
}


# Error bar figure
fig_5 <- res_tab %>%
    plot_reg()

ggsave(plot = fig_5, filename = args$output[[2]], width = fig_width, height = fig_height, units = c("cm"), limitsize = FALSE, dpi = 500)

print('Error bar figure of statistical model results exported in: \n')
print(args$output[[2]])




