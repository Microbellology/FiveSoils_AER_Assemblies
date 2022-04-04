#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#set up some easy automation
#SOIL=Li

#load required modules
load_checkm

#set up working directory in scratch
cd /safs-data01/uqbclar8/
#mkdir ${SOIL}/
mkdir checkm

#go to input file location
#cd /safs-data02/dennislab/Public/belle/5soils/${SOIL}/03_spades_assembly/03_bins/

#copy your program input files to the scratch directory
#cp -r polished_assembly/ /safs-data01/uqbclar8/${SOIL}/

#go to the scratch directory
#cd /safs-data01/uqbclar8/${SOIL}/
#mkdir output

#run program
checkm taxonomy_wf domain Bacteria -f checkm/final_bins.tsv --tab_table -x fa --threads 10 dereplicated_genomes/ checkm/

#copy over relevant files
cp checkm/final_bins.tsv /safs-data02/dennislab/Public/belle/5soils/final_bins/

#clear scratch
#cd ..
#rm -r ${SOIL}/
