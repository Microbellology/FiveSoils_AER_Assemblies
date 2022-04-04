#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#load required modules
load_coverm

#set up working directory in scratch
#cd /safs-data01/uqbclar8/
#mkdir coverm/

#go to input file location
cd /safs-data02/dennislab/Public/belle/5soils/final_bins/
#copy your program input files to the scratch directory
cp -r dRep/dereplicated_genomes/ /safs-data01/uqbclar8/ #dir with bins only
cp -r reads/ /safs-data01/uqbclar8/ #each samples, merged lanes raw reads

#go to the scratch directory
cd /safs-data01/uqbclar8/

#run program
coverm genome -c reads/*fastq.gz -d dereplicated_genomes/ -x fa -o coverm/AER_coverage.tsv -m trimmed_mean -t 15
#150mem

#copy dir back over
cp -r coverm/ /safs-data02/dennislab/Public/belle/5soils/final_bins/
