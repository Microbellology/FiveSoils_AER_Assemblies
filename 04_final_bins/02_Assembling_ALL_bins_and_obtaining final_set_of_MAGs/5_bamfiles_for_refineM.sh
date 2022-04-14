#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

# This is a script that maps reads back to the assembly

# load required modules
module load bwa
load_samtools_1.9

# asign variables
SOIL=To

# go to working directory
cd /safs-data01/uqbclar8/07_MAG_polishing/02_refineM/${SOIL}/

# Index the contig file
bwa index spades.contigs.min1500.fasta

# Map reads to contig file
bwa mem -t 2 spades.opera.contigs.min1500.fasta ${SOIL}_cleaned_R1.fq.gz ${SOIL}_cleaned_R2.fq.gz -o ${SOIL}_cleaned_mapped.sam

# convert to bam file
samtools sort -O bam -@ 2 -T ${SOIL} ${SOIL}_cleaned_mapped.sam > ${SOIL}_sorted.bam

# Index
samtools index ${SOIL}_sorted.bam

# clean up
rm  ${SOIL}_cleaned_mapped.sam
