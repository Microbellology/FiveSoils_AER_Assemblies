#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

load_drep

#move to working directory
cd /safs-data02/dennislab/Public/belle/5soils/final_bins/
mkdir dRep

#dereplicate genomes
dRep dereplicate dRep/ -g all/*.fa

#drep will choose the best version of identical genomes based on checkm
#completeness, contamination, and heterogeneity. You should manually curate this
#final list, chosing representative genomes based on the following criteria:
#1. isolate genomes are always prefered if checkm scores are similar
#2. single sample assemblies are prefered over co-assemblies

#move the final set of dereplicated bins to a final bins genome_directory
#mv drep/dereplicated_genomes/ mags/
