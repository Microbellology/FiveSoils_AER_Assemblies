#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#load required modules
load_checkm

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir checkm_all_bins

#run program
checkm taxonomy_wf domain Bacteria -f checkm_all_bins/all_bins.tsv --tab_table -x fa --threads 10 all_polished_bins/ checkm_all_bins/
