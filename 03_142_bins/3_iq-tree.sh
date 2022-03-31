#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#load software
load_iqtree_v2

#Go to working directory
cd /safs-data02/dennislab/Public/belle/5soils/final_bins/iqtree/

#run
iqtree2 -s ../gtdbtk/gtdbtk.bac120.msa.fasta --prefix all_mag_tree -T 15 --mem 150GB
