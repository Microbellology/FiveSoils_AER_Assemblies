#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_trimmomatic
ADAPTER_FP=/home/safs-data02/dennislab/sw/trimmomatic/0.36/adapters/NexteraPE-PE.fa
​
cd /safs-data01/uqbclar8/reads/
mkdir trimmed_reads
​
for i in `ls *R1.fastq.gz`; do
  trimmomatic PE -threads 1 ${i} ${i%R1.fastq.gz}R2.fastq.gz trimmed_reads/${i%R1.fastq.gz}paired_1.fq.gz trimmed_reads/${i%R1.fastq.gz}unpaired_1.fq.gz trimmed_reads/${i%R1.fastq.gz}paired_2.fq.gz trimmed_reads/${i%R1.fastq.gz}unpaired_2.fq.gz ILLUMINACLIP:$ADAPTER_FP:2:30:10 TRAILING:10 SLIDINGWINDOW:4:15 MINLEN:75
done
​
cd trimmed_reads/

for i in `ls *unpaired_1.fq.gz`; do
  cat ${i%unpaired_1.fq.gz}unpaired_2.fq.gz ${i} >> ${i%_1.fq.gz}.fq.gz
  rm ${i%unpaired_1.fq.gz}unpaired_2.fq.gz ${i}
done
