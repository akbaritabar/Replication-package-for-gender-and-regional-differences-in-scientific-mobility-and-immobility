## File name to use in search: snakefile_prepare_complement_data.smk ##

# ===========
## Different tasks/rules using DuckDB and R and RAW Scopus data ##
# ===========

rule duckdb_add_gender_and_other_author_attributes:
    input:
        ancient(TALENTS_ORIGINAL_DATA),
        ancient(AUTHORS_1ST_GENDER_ASSIGNMENT),
        ancient(AUTHORS_2ND_GENDER_ASSIGNMENT),
        ancient(AUTHORS_ADDITIONAL_ATTRS)
    output:
        INTERIM_TALENTS_DATA
    log:
        'logs/INTERIM_TALENTS_DATA.log'
    shell:
        "(python workflow/scripts/with_duckdb_complement_data.py --input {input}  --output {output}) 2> {log}"

# using config file to take R's executable path (r2use), plus adding "log_all" to collect both R's console and print messages
log_all = "2>&1"

rule r_prepare_anonymized_replication_data:
    input:
        rules.duckdb_add_gender_and_other_author_attributes.output
    output:
        TALENTS_DATA
    log:
        'logs/TALENTS_DATA.log'
    shell:
        "({r2use} workflow/scripts/prepare_complement_data.R --input {input} --output {output}) > {log} {log_all}"

