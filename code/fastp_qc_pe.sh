#!/usr/bin/bash

# eval "$(conda shell.bash hook)"
# conda activate quality_control


ls $1 | grep "_R1_001.fastq.gz" | sed 's/_R1_001.fastq.gz//' > file

mkdir -p $2/fastqs/
mkdir -p $2/json

cat file | parallel --bar -j 2 \
        fastp -i $1/{}_R1_001.fastq.gz -I $1/{}_R2_001.fastq.gz \
                -o $2/fastqs/{}_R1_001.fastq.gz -O $2/fastqs/{}_R2_001.fastq.gz \
                --json $2/json/{}.fastp.json --html $2/json/{}.fastp.html \
                 --adapter_sequence "CTGTCTCTTATACACATCT" --correction --thread  6 --length_required 75

rm file
# rm fastp.html

mkdir -p $3
multiqc --outdir $3 --title $4 $2/json --interactive --force -n $5

# move the empty fastq files
mkdir -p $2/empty-fastqs
find $2/fastqs/ -type f -size 0 -exec mv {} $2/empty-fastqs \;

# create fake-metada
cd $2/fastqs/
ls *_R1_001.fastq.gz | awk -v OFS="\t" -v FS="_" 'BEGIN {print "sample-id", "gene"} {print $1, "12S-16S"}' > metadata.tsv
cd -
mv  $2/fastqs/metadata.tsv $2
