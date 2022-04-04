#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#load relevant modules
load_enrichm

##CLASSIFY##

#go to scratch drive and make output directory
cd /safs-data01/uqbclar8/
mkdir enrichm_classify

#copy over relevant files
cp /safs-data02/dennislab/Public/belle/5soils/final_bins/enrichm/annotate_ko/ko_frequency_table.tsv /safs-data01/uqbclar8/

#use custome modules and annotation matrix to classify kegg modules in genomes
for i in `cat modules.tsv`; do
  mkdir enrichm_classify/${i%.tsv}/
  enrichm classify --log ${i%.tsv}_classify.log --output enrichm_classify/${i%.tsv}/ --force --genome_and_annotation_matrix ko_frequency_table.tsv --custom_modules /safs-data02/dennislab/Public/tools/enrichm/enrichm_modules/${i}
done
