#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#load required modules
load_coverm

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir coverm_all_bins/

#run program
coverm genome -c reads/*fastq.gz -d all_polished_bins/ -x fa -o coverm_all_bins/AER_all_bins_coverage.tsv -m trimmed_mean -t 15
#150mem
