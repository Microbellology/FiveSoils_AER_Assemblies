#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_enrichm

##ANNOATE##

##Navigate to working directory
cd /safs-data02/dennislab/Public/belle/5soils/final_bins/

##Create annotation directories
mkdir enrichm/
#mkdir enrichm/annotate_ko/
#mkdir enrichm/annotate_ko_hmm/
mkdir enrichm/annotate_pfam/
mkdir enrichm/annotate_cazy/
mkdir enrichm/annotate_tigrfam/
mkdir enrichm/annotate_ec/

##Annotate all bins in the final bins directory
#enrichm annotate --force --output enrichm/annotate_ko/ --genome_directory dRep/dereplicated_genomes/ --ko --suffix .fa --threads 10
#enrichm annotate --force --output enrichm/annotate_ko_hmm/ --genome_directory dRep/dereplicated_genomes/ --ko_hmm --suffix .fa --threads 10
enrichm annotate --force --output enrichm/annotate_pfam/ --genome_directory dRep/dereplicated_genomes/ --pfam --suffix .fa --threads 10
enrichm annotate --force --output enrichm/annotate_cazy/ --genome_directory dRep/dereplicated_genomes/ --cazy --suffix .fa --threads 10
enrichm annotate --force --output enrichm/annotate_tigrfam/ --genome_directory dRep/dereplicated_genomes/ --tigrfam --suffix .fa --threads 10
enrichm annotate --force --output enrichm/annotate_ec/ --genome_directory dRep/dereplicated_genomes/ --ec --suffix .fa --threads 10

##CLASSIFY##

#create classify directory
mkdir enrichm/classify_ko/

#use custome modules and annotation matrix to classify kegg modules in genomes
enrichm classify --log classify.log --output enrichm/classify_ko/ --force --genome_and_annotation_matrix enrichm/annotate_ko/ko_frequency_table.tsv --custom_modules /safs-data02/dennislab/Public/tools/enrichm/enrichm_modules/PGPT_modules_221121.tsv
