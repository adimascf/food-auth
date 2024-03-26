#! /usr/bin/bash

sample=$1
sample_20=$(echo $sample | awk -v FS="_" -v OFS="_" '{print $1"-d20",$2}' -)
sample_40=$(echo $sample | awk -v FS="_" -v OFS="_" '{print $1"-d40",$2}' -)
sample_60=$(echo $sample | awk -v FS="_" -v OFS="_" '{print $1"-d60",$2}' -)

echo $sample_20
zcat "data/processed/fastqs/"$sample"_L001_R1_001.fastq.gz" | head -n 80000 | gzip > "data/downsampled-fastqs/"$sample_20"_L001_R1_001.fastq.gz"
zcat "data/processed/fastqs/"$sample"_L001_R2_001.fastq.gz" | head -n 80000 | gzip > "data/downsampled-fastqs/"$sample_20"_L001_R2_001.fastq.gz"

echo $sample_40
zcat "data/processed/fastqs/"$sample"_L001_R1_001.fastq.gz" | head -n 160000 | gzip > "data/downsampled-fastqs/"$sample_40"_L001_R1_001.fastq.gz"
zcat "data/processed/fastqs/"$sample"_L001_R2_001.fastq.gz" | head -n 160000 | gzip > "data/downsampled-fastqs/"$sample_40"_L001_R2_001.fastq.gz"

echo $sample_60
zcat "data/processed/fastqs/"$sample"_L001_R1_001.fastq.gz" | head -n 240000 | gzip > "data/downsampled-fastqs/"$sample_60"_L001_R1_001.fastq.gz"
zcat "data/processed/fastqs/"$sample"_L001_R2_001.fastq.gz" | head -n 240000 | gzip > "data/downsampled-fastqs/"$sample_60"_L001_R2_001.fastq.gz"
