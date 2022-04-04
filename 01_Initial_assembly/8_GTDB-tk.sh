#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#load required modules
load_gtdbtk

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir gtdbtk

#run program
gtdbtk classify_wf --genome_dir dereplicated_genomes/ --out_dir gtdbtk/ -x fa  --cpus 20
#mem 1000

#copy results over
cp -r gtdbtk/ /safs-data02/dennislab/Public/belle/5soils/final_bins/
