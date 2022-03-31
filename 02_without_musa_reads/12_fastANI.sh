#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#load required modules
load_fastani

#go to working directory and make output directory
cd /safs-data02/dennislab/Public/belle/5soils/final_bins/
mkdir fastANI

#run fastANI
fastANI --ql 5soils.txt --rl olwen_bins.txt -o fastANI/Belle_vs_Olwens_fastani.out

#15 cores, 150mem
