#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#load software
load_ccmetagen

#go to relevant directory
cd /safs-data02/dennislab/Public/belle/5soils/0_raw_data/without_musa_reads/concatinated/

#run kma first
for i in `ls *R1.fq.gz`; do
  kma -ipe ${i} ${i%R1.fq.gz}R2.fq.gz -o /safs-data02/dennislab/Public/belle/5soils/final_bins/ccmetagen/${i%R1.fq.gz}kma -t_db /safs-data02/dennislab/db/ccmetagen/ncbi_nt_kma_jan_2018/ncbi_nt -t 15 -1t1 -mem_mode -and -apm f
  CCMetagen.py -i /safs-data02/dennislab/Public/belle/5soils/final_bins/ccmetagen/${i%R1.fq.gz}kma.res -o /safs-data02/dennislab/Public/belle/5soils/final_bins/ccmetagen/${i%R1.fq.gz}krona
done
