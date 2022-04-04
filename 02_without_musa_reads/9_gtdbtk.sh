#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#shortcuts
SOIL=In

#load required modules
load_gtdbtk

#set up working directory in scratch
cd /safs-data01/uqbclar8/${SOIL}
mkdir 03_gtdbtk

#run program
gtdbtk classify_wf --genome_dir 01_bins/ --out_dir 03_gtdbtk/ -x fa  --cpus 1
#mem start at 300 and increase from there

#copy results over
#cp -r gtdbtk/ /safs-data02/dennislab/Public/belle/5soils/final_bins/


sbatch -c 1 --mem=300GB --partition=safs --nodelist==safs-2-0 --priority=999999999 --time=365-0:00:00 --no-kill --job-name=gtdbtk 7_gtdbtk.sh
Submitted batch job 11287427
