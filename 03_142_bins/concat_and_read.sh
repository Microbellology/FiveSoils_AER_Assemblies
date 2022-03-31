#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#go to relevant directory
cd /safs-data02/dennislab/Public/belle/5soils/0_raw_data/without_musa_reads

#from a list of R1 lane 3 reads, run through each, putting the two lanes together
#then, before gzip count the number of reads for R1 and R2
#gzip after count
for i in `ls *L003_cleaned_R1.fq.gz`; do
  zcat ${i} >> concatinated/${i%L003_cleaned_R1.fq.gz}cleaned_R1.fq
  zcat ${i%L003_cleaned_R1.fq.gz}L004_cleaned_R1.fq.gz >> concatinated/${i%L003_cleaned_R1.fq.gz}cleaned_R1.fq
  j=`grep -c "@" concatinated/${i%L003_cleaned_R1.fq.gz}cleaned_R1.fq`
  echo ${i%L003_cleaned_R1.fq.gz}cleaned_R1.fq ${j} >> concatinated/total_reads.tsv
  gzip concatinated/${i%L003_cleaned_R1.fq.gz}cleaned_R1.fq
  zcat ${i%L003_cleaned_R1.fq.gz}L003_cleaned_R2.fq.gz >> concatinated/${i%L003_cleaned_R1.fq.gz}cleaned_R2.fq
  zcat ${i%L003_cleaned_R1.fq.gz}L004_cleaned_R2.fq.gz >> concatinated/${i%L003_cleaned_R1.fq.gz}cleaned_R2.fq
  k=`grep -c "@" concatinated/${i%L003_cleaned_R1.fq.gz}cleaned_R2.fq`
  echo ${i%L003_cleaned_R1.fq.gz}cleaned_R2.fq ${k} >> concatinated/total_reads.tsv
  gzip concatinated/${i%L003_cleaned_R1.fq.gz}cleaned_R2.fq
done

## Alternatively, you can concantinate th ereasd first and then count the reads

##concatinate the lanes from each sample into 1 forward and 1 reverse

# first do all the forward reads
for i in `ls *L003_cleaned_paired_1.fq.gz`; do
  zcat ${i} >> concatinated/${i%L003_cleaned_paired_1.fq.gz}cleaned_paired_1.fq.gz
  zcat ${i%L003_cleaned_paired_1.fq.gz}L004_cleaned_paired_1.fq.gz >> concatinated/${i%L003_cleaned_paired_1.fq.gz}cleaned_paired_1.fq.gz
done

# then do all the reverse reads
for i in `ls *L003_cleaned_paired_2.fq.gz`; do
  zcat ${i} >> concatinated/${i%L003_cleaned_paired_2.fq.gz}cleaned_paired_2.fq.gz
  zcat ${i%L003_cleaned_paired_2.fq.gz}L004_cleaned_paired_2.fq.gz >> concatinated/${i%L003_cleaned_paired_2.fq.gz}cleaned_paired_2.fq.gz
done

cd concatinated/
# now count the reads

for i in `la *fq.gz`; do
  zcat ${i} | grep -c "@" 
