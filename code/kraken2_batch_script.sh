#! /usr/bin/bash

set -e
set -u
set -o pipefail


sample_path=$1

mkdir -p data/processed/kraken2_results
mkdir -p data/processed/seq_class

ls $1 | grep "_R1_001.fastq.gz" | sed 's/_R1_001.fastq.gz//g' | awk -v FS="_" '{print $1}' > file

# cat file | parallel -j 4  kraken2 --db metazoa-added/ \
#       	--paired ../multiple-amplicons/fastqs_tbl_imeri_140923/processed/fastqs/{}*_R1_001.fastq.gz \
#       	../multiple-amplicons/fastqs_tbl_imeri_140923/processed/fastqs/{}*_R2_001.fastq.gz \
#       	--report data/processed/kraken2_results/{}.kraken2.txt \
#	--gzip-compressed > data/processed/kraken2_results/{}.kraken2.txt

for i in `cat file`;
do
	sample=$i
	kraken2 --db database/ --paired \
	       	$1/${sample}*_R1_001.fastq.gz \
		$1/${sample}*_R2_001.fastq.gz \
		--report data/processed/kraken2_results/${sample}.kraken2.txt \
		--gzip-compressed --threads 4 \
	       	--minimum-hit-groups 4 --confidence 0.1 --report-zero-counts > data/processed/seq_class/${sample}.kraken2.txt;
done

touch data/processed/kraken2_results/run_complete.txt


