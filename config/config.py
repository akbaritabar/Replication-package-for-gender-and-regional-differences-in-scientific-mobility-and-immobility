## File name to use in search: config.py ##

# ===========
## Author details ##
# ===========

# Script's author:      Aliakbar Akbaritabar
# Version:              2024-11-05
# Last Update:          2025-10-31
# Email:                akbaritabar@demogr.mpg.de
# GitHub:               https://github.com/akbaritabar
# Website:              https://www.demogr.mpg.de/en/about_us_6113/staff_directory_1899/aliakbar_akbaritabar_4098/

# Script for replication of analysis and figures from paper "A study of gender and regional differences in scientific mobility and immobility among researchers identified as potentially talented"
# Manuscript authors: Aliakbar Akbaritabar, Robin Haunschild and Lutz Bornmann

# ===========
## Imports ##
# ===========
# shortcut for path join function
from os.path import join as ojn
from os import getcwd

# ===========
## Folders ##
# ===========

# TODO NOTE modify this according to the project folder
PROJECT_DIR = getcwd()

# An if condition to define if scratch drive should be used (during development) or the manuscript's folder (once finalized) to include figures in text
# TODO NOTE modify this according to the intended results/figures folder
SCRATCH_DRIVE = [False, True][1]

if SCRATCH_DRIVE:
    OUTPUTS_DIR = ojn(PROJECT_DIR, 'results')
else:
    # MANUSCRIPT FIGURES DIR
    MANUSCRIPT_DIR = ojn('U:\\', 'nc', 'w', 'mpidr', 'mobility_of_talents', 'outputs')
    OUTPUTS_DIR = ojn(MANUSCRIPT_DIR, 'results')

INPUTS_DIR = ojn(PROJECT_DIR, 'resources')
LOGS_DIR = ojn(PROJECT_DIR, 'logs')
VIS_DIR = ojn(OUTPUTS_DIR, 'figures')
TABS_DIR = ojn(OUTPUTS_DIR, 'tables')

# NOTE this DIR includes RAW Scopus data which is licensed and cannot be shared in replication materials that can include only aggregated data
SCP_RAW_DIR = ojn(INPUTS_DIR, 'licensed_dt')

# ===========
## RAW (licensed) data from Scopus ##
# NOTE These will be excluded from replication materials/repository #
# ===========

TALENTS_ORIGINAL_DATA = ojn(SCP_RAW_DIR, '20230108_talents_joined_with_SCP2020_mobility_for_stat_models.csv')
AUTHORS_1ST_GENDER_ASSIGNMENT = ojn(SCP_RAW_DIR, 'author_gender.csv')
AUTHORS_2ND_GENDER_ASSIGNMENT = ojn(SCP_RAW_DIR, '20250115_scp_rp_2020_authors_table_w_attributes_gender.parquet')
AUTHORS_ADDITIONAL_ATTRS = ojn(SCP_RAW_DIR, '20220906_scp_rp_2020_authors_with_calculated_measures.csv')

# interim talents data, still includes licensed information
INTERIM_TALENTS_DATA = ojn(SCP_RAW_DIR, 'interim_talents_data_w_all_attributes.parquet')

# ===========
## Parameters ##
# ===========

# We use three gender assignments, first (Zhao et al. 2023), second (Theile 2024 from the Scholarly Migration Database team), and third (Lariviere et al. 2013, 2022)
GENDER_ASSIGNMENT = ['first', 'second', 'third']
GEO_REGION_GRANULARITY = ['continent', 'UNsubregion', 'WBregion']
TAB_RES_EXT = ['html', 'doc']

# ============================
#### Config and parameters for statistical analysis (Using R) ####
# ============================

# R to use on hydra11
# r2use = '"C:\\Program Files\\R\\R-4.4.0\\bin\\Rscript.exe" --no-save --no-restore --verbose'
# updated R version
r2use = '"C:\\Program Files\\R\\R-4.5.1\\bin\\Rscript.exe" --no-save --no-restore --verbose'

# ===========
## Processed data ##
# ===========

# talents data prepared for our paper's replication materials/repository
TALENTS_DATA = ojn(OUTPUTS_DIR, 'Akbaritabar_Haunschild_Bornmann_replication_data.csv')

# ===========
## Statistical models AND results tables ##
# ===========

SAMPLE_SUMMARY_TABLE = ojn(TABS_DIR, "sum_tbl_{gen2use}_gender.csv")

STAT_MODEL_GENDER = ojn(OUTPUTS_DIR, "md_prd1_{gen2use}_gender.csv")

STAT_MODEL_GENDER_LOG = ojn(LOGS_DIR, "st1_{gen2use}_gen.log")

COEF_TABLE_MODEL_GENDER = ojn(TABS_DIR, "TABLE_3_{gen2use}_gender.html")

STAT_MODEL_REGIONS = ojn(OUTPUTS_DIR, "md_prd2_{georegion}_region.csv")

STAT_MODEL_REGIONS_LOG = ojn(LOGS_DIR, "st2_{georegion}_reg.log")

COEF_TABLE_MODEL_REGIONS = ojn(TABS_DIR, 'TABLE_4_{georegion}_region.html')

# Full statistical model with both gender and regions

STAT_MODEL_FULL = ojn(OUTPUTS_DIR, "md_prd3_{gen2use}_{georegion}_full.csv")

STAT_MODEL_FULL_LOG = ojn(LOGS_DIR, "st3_{gen2use}_{georegion}_full.log")

COEF_TABLE_MODEL_FULL = ojn(TABS_DIR, 'TABLE_5_{gen2use}_{georegion}_full.html')

# Full statistical model with both gender and regions PLUS control variables

# Save model object as RDA to prevent re-running it while plotting/exporting tables
STAT_MODEL_FULL_CTRLS_RDA_OBJECT = ojn(OUTPUTS_DIR, "mdl_obj_{gen2use}_{georegion}_full_ctrls.RData")
STAT_MODEL_FULL_CTRLS_RDA_OBJECT_LOG = ojn(LOGS_DIR, "mdl_obj_{gen2use}_{georegion}_full_ctrls.log")

STAT_MODEL_FULL_CTRLS = ojn(OUTPUTS_DIR, "md_prd4_{gen2use}_{georegion}_f_ctrls.csv")

COEF_TABLE_MODEL_FULL_CTRLS = ojn(TABS_DIR, 'TABLE_6_{gen2use}_{georegion}_f_ctrls.{fileextension}')

COEF_TABLE_MODEL_FULL_CTRLS_LOG = ojn(LOGS_DIR, "st4_{gen2use}_{georegion}_{fileextension}_f_ctrls.log")

# Save a list object as RDA with full model's diagnostics and goodness of fit results
DIAGNOS_GOODNESS_OF_FIT_STAT_MODEL_FULL_CTRLS_RDA_OBJECT = ojn(OUTPUTS_DIR, "diagn_obj_{gen2use}_{georegion}_full_ctrls.RData")

DIAGNOS_GOODNESS_OF_FIT_STAT_MODEL_FULL_CTRLS_RDA_OBJECT_LOG = ojn(LOGS_DIR, "diagn_obj_{gen2use}_{georegion}_full_ctrls.log")

# ===========
## Visualization figures ##
# ===========

FIG_STUDY_SAMPLE = ojn(VIS_DIR, "Figure_1_{gen2use}_gender.png")
FIG_STUDY_SAMPLE_LOG = ojn(LOGS_DIR, "F1_{gen2use}_gen.log")

FIG_PREDICTED_PROBABILITY_GENDER = ojn(VIS_DIR, 'Figure_2_{gen2use}_gender.png')
FIG_PREDICTED_PROBABILITY_GENDER_LOG = ojn(LOGS_DIR, 'F2_{gen2use}_gen.log')

FIG_PREDICTED_PROBABILITY_REGIONS = ojn(VIS_DIR, 'Figure_3_{georegion}_rgn.png')
FIG_PREDICTED_PROBABILITY_REGIONS_LOG = ojn(LOGS_DIR, 'F3_{georegion}_rgn.log')

FIG_PREDICTED_PROBABILITY_FULL_CTRLS = ojn(VIS_DIR, 'Figure_4_{gen2use}_{georegion}.png')
FIG_PREDICTED_PROBABILITY_FULL_CTRLS_LOG = ojn(LOGS_DIR, 'F4_{gen2use}_{georegion}.log')

FIG_ERROR_BARS_FULL_CTRLS = ojn(VIS_DIR, 'Figure_5_{gen2use}_{georegion}.png')
TAB_CONFIDENCE_ETC_FULL_CTRLS = ojn(TABS_DIR, 'TABLE_7_{gen2use}_{georegion}.csv')
FIG_ERROR_BARS_FULL_CTRLS_LOG = ojn(LOGS_DIR, 'F5_{gen2use}_{georegion}.log')

