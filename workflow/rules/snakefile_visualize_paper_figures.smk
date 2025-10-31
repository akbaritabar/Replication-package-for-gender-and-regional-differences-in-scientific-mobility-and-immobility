## File name to use in search: snakefile_visualize_paper_figures.smk ##

# Rules in this file are using the R and Python scripts to use data and statistical model results and visualize figures for paper

# using config file to take R's executable path, plus adding "log_all" to collect both R's console and print messages
log_all = "2>&1"

rule r_plot_distribution_of_sample:
    input:
        rules.r_prepare_anonymized_replication_data.output
    output:
        FIG_STUDY_SAMPLE
    log:
        FIG_STUDY_SAMPLE_LOG
    shell:
        "({r2use} workflow/scripts/figure_description_of_study_sample.R --input {input} --gender {wildcards.gen2use} --output {output}) > {log} {log_all}"


rule py_plot_predicted_probability_gender:
    input:
        STAT_MODEL_GENDER
    output:
        FIG_PREDICTED_PROBABILITY_GENDER
    log:
        FIG_PREDICTED_PROBABILITY_GENDER_LOG
    shell:
        "(python workflow/scripts/figure_predicted_probability_gender.py --input {input} --output {output}) 2> {log}"

rule py_plot_predicted_probability_regions:
    input:
        STAT_MODEL_REGIONS
    output:
        FIG_PREDICTED_PROBABILITY_REGIONS
    log:
        FIG_PREDICTED_PROBABILITY_REGIONS_LOG
    shell:
        "(python workflow/scripts/figure_predicted_probability_regions.py --input {input} --output {output}) 2> {log}"

rule py_plot_predicted_probability_full_model_w_controls:
    input:
        STAT_MODEL_FULL_CTRLS
    output:
        FIG_PREDICTED_PROBABILITY_FULL_CTRLS
    log:
        FIG_PREDICTED_PROBABILITY_FULL_CTRLS_LOG
    shell:
        "(python workflow/scripts/figure_predicted_probability_full_model_w_controls.py --input {input} --output {output}) 2> {log}"

rule r_plot_error_bar_full_model_w_controls:
    input:
        STAT_MODEL_FULL_CTRLS_RDA_OBJECT
    output:
        TAB_CONFIDENCE_ETC_FULL_CTRLS,
        FIG_ERROR_BARS_FULL_CTRLS
    log:
        FIG_ERROR_BARS_FULL_CTRLS_LOG
    shell:
        "({r2use} workflow/scripts/figure_read_statistical_model_full_gender_regions_w_controls_results_errorbar_fig.R --input {input} --gender {wildcards.gen2use} --region2use {wildcards.georegion} --output {output}) > {log} {log_all}"


