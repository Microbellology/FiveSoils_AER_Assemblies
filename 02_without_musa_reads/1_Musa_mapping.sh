#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

### Musa_mapping each soils concat reads run as 2 steps###

#!/bin/bash
#
#PBS -S /bin/bash
#PBS -A UQ-SCI-SEES
#PBS -N In_musa
#PBS -l select=1:ncpus=24:mem=200GB
#PBS -l walltime=167:00:00

module load bwa

cd $TMPDIR

mkdir 09_In_musa_mapping

bwa mem -t "24" /QRISdata/Q0775/belle/01_core/01_5soils_AER/02_novaseq/Musa_spp.fa /QRISdata/Q0775/belle/01_core/01_5soils_AER/02_novaseq/In/01_reads/In_R1.fastq /QRISdata/Q0775/belle/01_core/01_5soils_AER/02_novaseq/In/01_reads/In_R2.fastq > 09_In_musa_mapping/In_aln-pe.sam

cp -r 09_In_musa_mapping/ /QRISdata/Q0775/belle/01_core/01_5soils_AER/02_novaseq/In/

#!/bin/bash
#
#PBS -S /bin/bash
#PBS -A UQ-SCI-SEES
#PBS -N In_sam
#PBS -l select=1:ncpus=10:mem=200GB
#PBS -l walltime=167:00:00

module load samtools/1.9

cd $TMPDIR

mkdir sam

##convert sam to bam, then remove sam to save space
samtools view -bS /QRISdata/Q0775/belle/01_core/01_5soils_AER/02_novaseq/In/09_In_musa_mapping/In_aln-pe.sam > sam/In_aln-pe.bam
#rm In_aln-pe.sam

##sort bam by read name (moves paired reads adjacent to each other), then remove unsorted bam to save space
samtools sort -n -m 8G -@ 24 sam/In_aln-pe.bam -o sam/In_aln-pe_sorted.bam
#rm In_aln-pe.bam

##subselect unmapped reads, then remove sorted bam
samtools view -b -f 12 -F 256 sam/In_aln-pe_sorted.bam > sam/In_aln-pe_unmapped.bam
#rm In_aln-pe_sorted.bam

##sort bam by read name again, then remove unsorted bam
samtools sort -n -m 8G -@ 24 sam/In_aln-pe_unmapped.bam -o sam/In_aln-pe_unmapped_sorted.bam
#rm In_aln-pe_unmapped.bam

#Extract unmapped read pairs, then remove bam
samtools fastq -@ 24 sam/In_aln-pe_unmapped_sorted.bam -1 sam/In_cleaned_R1.fq.gz -2 sam/In_cleaned_R2.fq.gz -0 /dev/null -s /dev/null -n
#rm ref_genome_sample_1_unmapped_sorted.bam

cp -r sam/ /QRISdata/Q0775/belle/01_core/01_5soils_AER/02_novaseq/In/09_In_musa_mapping/


## Musa_mapping for each read ###

#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

module load bwa
load_samtools_1.9

#go to directory with raw reads
cd /safs-data02/dennislab/Public/Belle/5soils/0_raw_data/

#make dir for reads without musa
mkdir without_musa_reads

#loop through all read 1's to capture read 1 and 2 pairs
for i in `ls *R1_001.fastq.gz`; do
  #map reads to musa
  bwa mem -t 24 /home/safs-data02/dennislab/db/genomes/musa_spp/Musa_spp.fa ${i} ${i%R1_001.fastq.gz}R2_001.fastq.gz > without_musa_reads/${i%R1.001.fastq.gz}.sam
  #move to mapping file locations
  cd without_musa_reads
  #convert to bam and remove sam files to save space
  samtools view -bS ${i%R1.001.fastq.gz}.sam > ${i%R1.001.fastq.gz}.bam
  rm ${i%R1.001.fastq.gz}.sam
  #sorting by read name (keeping paired reads together) remove bam to save space
  samtools sort -n -m 240G -@ 24 ${i%R1.001.fastq.gz}.bam -o ${i%R1.001.fastq.gz}_sorted.bam
  rm ${i%R1.001.fastq.gz}.bam
  #extract unmapped reads and remove sorted bam
  samtools view -b -f 4 ${i%R1.001.fastq.gz}_sorted.bam > ${i%R1.001.fastq.gz}_unmapped.bam
  rm ${i%.bam}_sorted.bam
  #sort again by read names and remove unmapped bam to save space
  samtools sort -n -m 240G -@ 24 ${i%R1.001.fastq.gz}_unmapped.bam -o ${i%R1.001.fastq.gz}_unmapped_sorted.bam
  rm ${i%R1.001.fastq.gz}_unmapped.bam
  #extract unmapped sorted read into forard and reverse paired read fq files and once again, remove to save space
  samtools fastq -@ 24 ${i%R1.001.fastq.gz}_unmapped_sorted.bam -1 ${i%R1.001.fastq.gz}_cleaned_R1.fq.gz -2 ${i%R1.001.fastq.gz}_cleaned_R2.fq.gz -0 /dev/null -s /dev/null -n
  rm ${i%R1.001.fastq.gz}_unmapped_sorted.bam
  #move back to raw reads dir
  cd ../
done
