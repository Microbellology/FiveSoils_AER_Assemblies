#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#set up some easy automation
SOIL=In

#load required modules
load_prokka

#set up working directory
cd /safs-data02/dennislab/Public/belle/5soils/${SOIL}/02_megahit_assembly/
mkdir 05_prokka/

#Run script
prokka --outdir 05_prokka/ --force --prefix ${SOIL}_megahit_prokka --cpus 10 01_opera/metahit.contigs.min1500.fasta
