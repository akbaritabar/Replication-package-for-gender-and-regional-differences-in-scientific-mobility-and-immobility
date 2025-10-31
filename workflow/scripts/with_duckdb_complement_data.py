## File name to use in search: with_duckdb_complement_data.py ##

# Python script that use DuckDB and SQL script for data processing/reshaping

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


# for data handling
import duckdb
#### Results log and progress report ####
from tolog import lg

lg(f"These items are in the environment: {dir()}")

# ============================
#### For command line arguments ####
# ============================
import argparse
parser = argparse.ArgumentParser()

# System arguments
# use ", nargs='+'" if more than one input is given, below have to choose args.input[] and list element number to use
parser.add_argument("-i", "--input", help = "Input file to use",
                    type = str, required = True, nargs='+')
parser.add_argument("-o", "--output", help = "Output data path",
                    type = str, required = False, nargs='+')

args = parser.parse_args()

lg(f"Arguments received from command line: \n {args}")

# ============================
#### Run DuckDB SQL script ####
# ============================

query = f"""
-- take talents original data, add first, second, and third gender assignments and other author attributes and write to parquet
copy (
select 
    *
from '{args.input[0]}' tl
left join (
        select 
            author_id,
            gender as first_gender
        from '{args.input[1]}'
    ) gender1
    using(author_id)
left join (
        select 
            author_id,
            prod_cat,
            academic_age_cat,
            fieldOfScience,
            pred_gender as second_gender,
            genderu as third_gender
        from '{args.input[2]}'
    ) gender2
    using(author_id)
left join (
        select 
            author_id,
            pub_over_years,
            pubs_international,
            pubs_multi_region,
            pubs_first_author,
            sum_cites,
            cites_avg,
            pubs_coauthored,
            avg_ncoauthors,
            pubs_fractional
        from '{args.input[3]}'
    ) oth
    using(author_id)
)
to '{args.output[0]}'
WITH (format parquet)
;

"""

# to run
duckdb.sql(query)

# status report in log
lg('DuckDB ran the query and successfully finished!')






