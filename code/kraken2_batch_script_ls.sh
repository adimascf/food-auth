#! /usr/bin/bash

sample_path=$1
oudir=$2

mkdir -p $oudir
mkdir -p seq_class

ls $1 | grep "_R1_001.fastq.gz" | sed 's/_R1_001.fastq.gz//g' | awk -v FS="_" '{print $1}' > file

# cat file | parallel -j 4  kraken2 --db metazoa-added/ \
#       	--paired ../multiple-amplicons/fastqs_tbl_imeri_140923/processed/fastqs/{}*_R1_001.fastq.gz \
#       	../multiple-amplicons/fastqs_tbl_imeri_140923/processed/fastqs/{}*_R2_001.fastq.gz \
#       	--report $oudir/{}.kraken2.txt \
#	--gzip-compressed > $oudir/{}.kraken2.txt

for i in `cat file`;
do
	sample=$i
	kraken2 --db metazoa-added --paired \
	       	../multiple-amplicons/fastqs_tbl_imeri_140923/processed/fastqs/${sample}*_R1_001.fastq.gz \
		../multiple-amplicons/fastqs_tbl_imeri_140923/processed/fastqs/${sample}*_R2_001.fastq.gz \
		--report $oudir/${sample}.kraken2.txt \
		--gzip-compressed --threads 4 > seq_class/${sample}.kraken2.txt;
done


