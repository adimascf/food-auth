configfile: 'config.yaml'

print(type(config))
print(config)

# Scripts
# kraken2_script = "code/kraken2_batch_script.sh"
input_fastq = config["input"]["fastqs_path"]
processed_data = config["output"]["processed_data"]
multiqc_name = config["input"]["project_name"]
output_each_sample = config["input"]["project_name"] + "each_sample.html"
output_genus_comparison = config["input"]["project_name"] + "comparsion.html"

output_each_sample_path = "reports/" + output_each_sample
output_genus_comparison_path = "reports/" + output_genus_comparison
output_rel_abunnd = "reports/" + config["input"]["project_name"] + "_rel_abund.xlsx"

## Main rules definitions ###
rule run_fastp_preprocessing:
    input:
        script = "code/fastp_qc_pe.sh",
        input_path = input_fastq
    params:
        output_path = processed_data,
        title = "batch-3",
        output_report = "reports/",
        filename = multiqc_name
    output:
        # directory(processed_data),
        directory(processed_data + "/fastqs"),
        "reports/" + multiqc_name + ".html"
    # conda:
    #     "envs/preprocessing_fastq.yaml"
    shell:
        """
        eval "$(conda shell.bash hook)" && conda activate /home/adimascf/mambaforge/envs/fastq-qc &&
        {input.script} {input.input_path} {params.output_path} {params.output_report} {params.title} {params.filename}
        """

rule run_kraken2:
    input:
        script = "code/kraken2_batch_script.sh",
        fastq_path = "data/processed/fastqs"
        
    output:
        directory("data/processed/kraken2_results"),

    shell:
        """
        {input.script} {input.fastq_path}
        """

rule aggregate_results:
    input:
        script = "code/aggregate-kraken-result.sh",
        input_path = "data/processed/kraken2_results",
    
    # params:
    #     output_path = "data/processed/aggregated-results/"
    
    output:
        directory("data/processed/aggregated-results/"),
        "data/processed/aggregated-results/agg-report-species.csv",
        "data/processed/aggregated-results/agg-report-genus.csv",
        "data/processed/aggregated-results/agg-report-family.csv",
        "data/processed/aggregated-results/agg-report-ordo.csv",
        "data/processed/aggregated-results/agg-report-class.csv",
	"data/processed/aggregated-results/agg-report-phylum.csv",
        "data/processed/aggregated-results/agg-report-kingdom.csv",
        "data/processed/aggregated-results/agg-report-domain.csv"
    
    shell:
        """
        {input.script} {input.input_path}
        """

rule run_relative_abundance:
    input:
        script = "code/kraken_rel_abund.R",
        input_dir = "data/processed/aggregated-results"
    
    params:
        output_path = output_rel_abunnd

    shell:
        """
        Rscript {input.script} {input.input_dir} {params.output_path}
        """

rule per_sample_report:
    input:
        script = "code/report_per_sample.Rmd",
        report_species = "data/processed/aggregated-results/agg-report-species.csv",
        report_genus = "data/processed/aggregated-results/agg-report-genus.csv",
        report_family = "data/processed/aggregated-results/agg-report-family.csv",
        report_ordo = "data/processed/aggregated-results/agg-report-ordo.csv",
        report_class = "data/processed/aggregated-results/agg-report-class.csv",
	    report_phylum = "data/processed/aggregated-results/agg-report-phylum.csv",
        report_kingdom = "data/processed/aggregated-results/agg-report-kingdom.csv",
        report_domain = "data/processed/aggregated-results/agg-report-domain.csv",

    params:
        output_path = output_each_sample_path
    output:
        output_each_sample_path
    
    shell:
        """
        test -f {input.report_species} && test -f {input.report_genus} && test -f {input.report_family} && test -f {input.report_ordo} &&
        test -f {input.report_class} && test -f {input.report_class} && test -f {input.report_phylum} && test -f {input.report_kingdom} && test -f {input.report_domain} && 
        ls data/processed/kraken2_results/ | cut -d "." -f 1 - > data/processed/sample_names.txt &&
        R -e "library(rmarkdown); render('{input.script}')" &&
        mv code/report_per_sample.html {params.output_path}
        """

rule sample_comparison:
    input:
        script = "code/sample-comparison.Rmd",
        report_genus = "data/processed/aggregated-results/agg-report-genus.csv"
    
    params:
        output_path = "reports/" + output_genus_comparison
    output:
        output_genus_comparison_path
    
    shell:
        """
        test -f {input.report_genus} &&
        R -e "library(rmarkdown); render('{input.script}')" &&
        mv code/sample-comparison.html {params.output_path}
        """

rule running_all:
    input:
        script_relabund = "data/processed/aggregated-results",
        input_relabund = "data/processed/aggregated-results",
        script_per_sample = "code/report_per_sample.Rmd",
        report_species = "data/processed/aggregated-results/agg-report-species.csv",
        report_genus = "data/processed/aggregated-results/agg-report-genus.csv",
        report_family = "data/processed/aggregated-results/agg-report-family.csv",
        report_ordo = "data/processed/aggregated-results/agg-report-ordo.csv",
        report_class = "data/processed/aggregated-results/agg-report-class.csv",
	    report_phylum = "data/processed/aggregated-results/agg-report-phylum.csv",
        report_kingdom = "data/processed/aggregated-results/agg-report-kingdom.csv",
        report_domain = "data/processed/aggregated-results/agg-report-domain.csv",
        script_comparison = "code/sample-comparison.Rmd",
        input_comparison = "data/processed/aggregated-results/agg-report-genus.csv" # genus data
    
    params:
        output_relabund = output_rel_abunnd,
        output_per_sample = output_each_sample_path,
        output_comparison = output_genus_comparison_path


    shell:
        """
        # realtive abundance calculation
        Rscript {input.script_relabund} {input.input_relabund} {params.output_relabund} &&

        # per sample report
        test -f {input.report_species} && test -f {input.report_genus} && test -f {input.report_family} && test -f {input.report_ordo} &&
        test -f {input.report_class} && test -f {input.report_class} && test -f {input.report_phylum} && test -f {input.report_kingdom} && test -f {input.report_domain} && 
        ls data/processed/kraken2_results/ | cut -d "." -f 1 - > data/processed/sample_names.txt &&
        R -e "library(rmarkdown); render('{input.script_per_sample}')" &&
        mv code/report_per_sample.html {params.output_per_sample} &&

        # sample comparison
        test -f {input.input_comparison} &&
        R -e "library(rmarkdown); render('{input.script_comparison}')" &&
        mv code/sample-comparison.html {params.output_comparison}
        """