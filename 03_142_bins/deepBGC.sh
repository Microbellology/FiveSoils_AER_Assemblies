#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#load module
load_deepbgc

#go to working directory
cd /safs-data02/dennislab/Public/belle/5soils/final_bins/dRep/dereplicated_genomes/

#run software
for i in `ls *.fa`; do
  deepbgc pipeline -o /safs-data02/dennislab/Public/belle/5soils/final_bins/deepBGC/${i}/ ${i}
done
