#! /usr/bin/bash

set -e
set -u
set -o pipefail

rm -f data/processed/kraken2_results/run_complete.txt
rm -f data/processed/kraken2_results/.snakemake_timestamp

input_dir=$1
output_dir="data/processed/aggregated-results/"

mkdir -p $output_dir

./code/Kraken2-output-manipulation-1.0/kraken-multiple-taxa.py -d $input_dir -r S -c 2 -o $output_dir/agg-report-species
./code/Kraken2-output-manipulation-1.0/kraken-multiple-taxa.py -d $input_dir -r G -c 2 -o $output_dir/agg-report-genus
./code/Kraken2-output-manipulation-1.0/kraken-multiple-taxa.py -d $input_dir -r F -c 2 -o $output_dir/agg-report-family
./code/Kraken2-output-manipulation-1.0/kraken-multiple-taxa.py -d $input_dir -r O -c 2 -o $output_dir/agg-report-ordo
./code/Kraken2-output-manipulation-1.0/kraken-multiple-taxa.py -d $input_dir -r C -c 2 -o $output_dir/agg-report-class
./code/Kraken2-output-manipulation-1.0/kraken-multiple-taxa.py -d $input_dir -r P -c 2 -o $output_dir/agg-report-phylum
./code/Kraken2-output-manipulation-1.0/kraken-multiple-taxa.py -d $input_dir -r K -c 2 -o $output_dir/agg-report-kingdom
./code/Kraken2-output-manipulation-1.0/kraken-multiple-taxa.py -d $input_dir -r D -c 2 -o $output_dir/agg-report-domain

sed -e "s/\[//g;s/\]//g;s/'//g;s|\t|,|g" $output_dir/agg-report-species > $output_dir/agg-report-species.csv
sed -e "s/\[//g;s/\]//g;s/'//g;s|\t|,|g" $output_dir/agg-report-genus > $output_dir/agg-report-genus.csv
sed -e "s/\[//g;s/\]//g;s/'//g;s|\t|,|g" $output_dir/agg-report-family > $output_dir/agg-report-family.csv
sed -e "s/\[//g;s/\]//g;s/'//g;s|\t|,|g" $output_dir/agg-report-ordo > $output_dir/agg-report-ordo.csv
sed -e "s/\[//g;s/\]//g;s/'//g;s|\t|,|g" $output_dir/agg-report-class > $output_dir/agg-report-class.csv
sed -e "s/\[//g;s/\]//g;s/'//g;s|\t|,|g" $output_dir/agg-report-phylum > $output_dir/agg-report-phylum.csv
sed -e "s/\[//g;s/\]//g;s/'//g;s|\t|,|g" $output_dir/agg-report-kingdom > $output_dir/agg-report-kingdom.csv
sed -e "s/\[//g;s/\]//g;s/'//g;s|\t|,|g" $output_dir/agg-report-domain > $output_dir/agg-report-domain.csv

rm $output_dir/agg-report-species $output_dir/agg-report-genus $output_dir/agg-report-family $output_dir/agg-report-ordo $output_dir/agg-report-class $output_dir/agg-report-phylum $output_dir/agg-report-kingdom $output_dir/agg-report-domain

