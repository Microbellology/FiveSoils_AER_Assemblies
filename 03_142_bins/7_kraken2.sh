#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

SOIL=In

#go to working directory and make output directory
cd /safs-data02/dennislab/Public/belle/5soils/${SOIL}/
#mkdir 04_kraken2

#load relevant modules
load_kraken2

#run software
kraken2 -threads 15 --db /safs-data02/dennislab/db/kraken2/nr_2021_07_28/ --paired 01_reads/${SOIL}_cleaned_R1.fq.gz 01_reads/${SOIL}_cleaned_R2.fq.gz --classified-out 04_kraken2/${SOIL}_kraken#.fq --report 04_kraken2/${SOIL}_kraken.report --output 04_kraken2/${SOIL}_results.kraken --report-zero-counts

#200GB mem

#making a krona file

#load krona
load_krona

#go to the kraken2 output directory
cd 04_kraken2/

#this command takes the 2nd and 3rd column of the results.kraken file to make a krona plot
ktImportTaxonomy -q 2 -t 3 ${SOIL}_results.kraken -o ${SOIL}_krona.html
