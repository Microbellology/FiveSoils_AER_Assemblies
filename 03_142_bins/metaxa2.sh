#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#load required modules
load_metaxa2

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir metaxa

cd /safs-data01/uqbclar8/current_MAGs/
#run program
for i in `ls *.fa`; do
  metaxa2 -i ${i} -o ../metaxa/${i%.fa} --cpu 1 -d /safs-data02/dennislab/sw/metaxa2/2.2.3/metaxa2_db/SSU/HMMs/
done
#100mem
