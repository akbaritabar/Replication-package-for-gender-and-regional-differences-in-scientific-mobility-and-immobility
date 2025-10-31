## File name to use in search: snakefile_statistical_analysis.smk ##

# Rules in this file are using the R scripts for statistical modelling and analysis

# using config file to take R's executable path (r2use), plus adding "log_all" to collect both R's console and print messages
log_all = "2>&1"

rule r_run_statistical_model_gender:
    input:
        rules.r_prepare_anonymized_replication_data.output
    output:
        SAMPLE_SUMMARY_TABLE,
        STAT_MODEL_GENDER,
        COEF_TABLE_MODEL_GENDER,
    log:
        STAT_MODEL_GENDER_LOG
    shell:
        "({r2use} workflow/scripts/read_data_run_statistical_model_gender.R --input {input} --gender {wildcards.gen2use} --output {output}) > {log} {log_all}"


rule r_run_statistical_model_regions:
    input:
        rules.r_prepare_anonymized_replication_data.output
    output:
        STAT_MODEL_REGIONS,
        COEF_TABLE_MODEL_REGIONS
    log:
        STAT_MODEL_REGIONS_LOG
    shell:
        "({r2use} workflow/scripts/read_data_run_statistical_model_regions.R --input {input} --region2use {wildcards.georegion} --output {output}) > {log} {log_all}"

rule r_run_statistical_FULL_model_gender_regions:
    input:
        rules.r_prepare_anonymized_replication_data.output
    output:
        STAT_MODEL_FULL,
        COEF_TABLE_MODEL_FULL
    log:
        STAT_MODEL_FULL_LOG
    shell:
        "({r2use} workflow/scripts/read_data_run_statistical_model_full_gender_regions.R --input {input} --gender {wildcards.gen2use} --region2use {wildcards.georegion} --output {output}) > {log} {log_all}"

rule r_run_statistical_FULL_model_gender_regions_with_controls_save_RDA:
    input:
        rules.r_prepare_anonymized_replication_data.output
    output:
        STAT_MODEL_FULL_CTRLS,
        STAT_MODEL_FULL_CTRLS_RDA_OBJECT
    log:
        STAT_MODEL_FULL_CTRLS_RDA_OBJECT_LOG
    shell:
        "({r2use} workflow/scripts/read_data_run_statistical_model_full_gender_regions_w_controls_model_object.R --input {input} --gender {wildcards.gen2use} --region2use {wildcards.georegion} --output {output}) > {log} {log_all}"


rule r_use_statistical_FULL_model_gender_regions_with_controls_export_results:
    input:
        STAT_MODEL_FULL_CTRLS_RDA_OBJECT
    output:
        COEF_TABLE_MODEL_FULL_CTRLS
    log:
        COEF_TABLE_MODEL_FULL_CTRLS_LOG
    shell:
        "({r2use} workflow/scripts/read_data_run_statistical_model_full_gender_regions_w_controls_model_results.R --input {input} --gender {wildcards.gen2use} --region2use {wildcards.georegion} --ext2use {wildcards.fileextension} --output {output}) > {log} {log_all}"


# for statistical models diagnostics and goodness of fit testing
rule r_run_statistical_FULL_model_diagnostics_goodnessOfFit:
    input:
        rules.r_prepare_anonymized_replication_data.output
    output:
        DIAGNOS_GOODNESS_OF_FIT_STAT_MODEL_FULL_CTRLS_RDA_OBJECT
    log:
        DIAGNOS_GOODNESS_OF_FIT_STAT_MODEL_FULL_CTRLS_RDA_OBJECT_LOG
    shell:
        "({r2use} workflow/scripts/testing_model_diagnostics_goodnessOfFit.R --input {input} --gender {wildcards.gen2use} --region2use {wildcards.georegion} --output {output}) > {log} {log_all}"
