#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

## First use scaffold_stats which generates a file that is required for most other functions

# load in modules
load_refinem

# go to working directory
cd /safs-data01/uqbclar8/02_assembly/06_refineM/scaffold_stats/
# in this directory, place you sorted bam files and the contig/scaffold file

# make an output directoy
mkdir output

# run refineM
refinem scaffold_stats -c 2 -x fa spades_opera_assemblies_combined.fasta /safs-data01/uqbclar8/02_assembly/02_dRep_no_qc_ALL_bins/ output/ *bam
