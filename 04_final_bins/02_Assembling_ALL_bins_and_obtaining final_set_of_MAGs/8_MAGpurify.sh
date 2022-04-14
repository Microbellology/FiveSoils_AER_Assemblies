#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

### Magpurify 2.1.2 ###

### Anna-Belle Clarke 11.04.2022

# Here is a script that will run all the functions in MAGpurify in order
# comment out any section that you do not wish to run
# more info here: https://github.com/snayfach/MAGpurify

# load in module
load_magpurify

# go to working directory
cd /safs-data01/uqbclar8/02_assembly/07_MAG_polishing/03_MAGpurify

# make output directory (although, magpurify can also make these itself)
mkdir 01_phylo-markers
mkdir 02_clade-markers
mkdir 03_conspecific
mkdir 04_tetra-freq
mkdir 05_gc-content
mkdir 06_coverage
mkdir 07_known-contam
mkdir 08_clean-bin

### Phylo markers ###
# find taxonomic discordant contigs using a database of phylogenetic marker genes

#run program
magpurify phylo-markers /safs-data01/uqbclar8/02_assembly/02_dRep_no_qc_ALL_bins/Li_bin.15_spades_polished.fa 01_phylomarkers/ # 2cpu, 100mem

### Clade markers ###

#run program
magpurify clade-markers /safs-data01/uqbclar8/02_assembly/02_dRep_no_qc_ALL_bins/Li_bin.15_spades_polished.fa 02_clade-markers # 2cpu, 100mem

### conspecific ###

#run program

### coverage ###
