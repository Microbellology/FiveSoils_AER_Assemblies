#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

### Anna-Belle Clarke 11.04.2022

# gunc is a program that will identify the origin of the contigs in your bins
# it will also look at things like gc content. for more info go here: https://grp-bork.embl-community.io/gunc/usage.html
# there are 2 main steps in gunc, and a third that combines existing information with checkM output
# here I list code for all 3 steps.

# load in module
load_gunc

# go to working directory
cd /safs-data01/uqbclar8/02_assembly/07_MAG_polishing/01_gunc

### run ###
# below is how to run the gunc run function
# here we use the progenomes db, you can also use gtdb
gunc run -i 02_dRep_no_qc_ALL_bins/Li_bin.15_spades_polished.fa -r /safs-data02/dennislab/db/gunc/progenomes/ #2cpu, 50mem
# this will give you diamond output

### plot ###

# go to the output folder from run
cd /safs-data01/uqbclar8/02_assembly/07_MAG_polishing/01_gunc/01_run

# below is how to run the gunc plot function
gunc plot -d diamond_output/Li_bin.15_spades_polished.diamond.progenomes_2.1.out -o ../02_plot # 2cpu, 50mem
#this will give you a HTML file that is an interactive plot

### CheckM-Merge ###

#first we need to make the checkM files

# I followed the taxonomy_wf but did each step manually
checkm taxon_set domain Bacteria marker_file
#this generates the marker file that can then be used by analyse
checkm analyze checkm analyze marker_file bin/ ../03_MergCheckM/
#when I ran checkM qa I followed the recommended addiotions by the gunc manual: https://grp-bork.embl-community.io/gunc/usage.html
checkm qa marker_file ../03_MergCheckM/ -f qa.tsv -o 2 --tab_table
#this ensures the output of the checkM file is suitable to then fee into gunc

# once you have generated the qa.tsv file with checkM you can then run the gunc checkM_merg function
gunc merge_checkm -g ../GUNC.progenomes_2.1.maxCSS_level.tsv -c qa.tsv
#this gives you the output of gunc run and checkM in one file
