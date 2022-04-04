#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
​
###	Map reads to a reference and extract mapped reads
###	Paul Dennis
###	08/02/2022
​
# Map raw reads against the c__Thermoleophilia reference genome using BWA
​
module load bwa
​
cd /safs-data02/dennislab/Public/Collaborators/Clement/Oxipops/SG/0_raw_data/
​
for i in `ls *.fastq.gz`; do
​
bwa aln -n 0.05 c__Thermoleophilia ${i} > /safs-data02/dennislab/Public/Collaborators/Clement/Oxipops/SG/4_bwa_mapping_to_mucor/${i%_001.fastq.gz}.sai
​
done
​
​
# Convert to sam file
​
cd /safs-data02/dennislab/Public/Collaborators/Clement/Oxipops/SG/4_bwa_mapping_to_mucor/
​
for i in `ls *_R1.sai`; do
​
bwa sampe /safs-data02/dennislab/Public/public_dbs/genomes/fungi/Mucor_circinelloides/reference_genome/GCA_001599575.1/GCA_001599575.1_JCM_22480_assembly_v001_genomic.fna ${i} ${i%_R1.sai}_R2.sai /safs-data02/dennislab/Public/Collaborators/Clement/Oxipops/SG/0_raw_data/${i%_R1.sai}_R1_001.fastq.gz /safs-data02/dennislab/Public/Collaborators/Clement/Oxipops/SG/0_raw_data/${i%_R1.sai}_R2_001.fastq.gz > ${i%_R1.sai}_bwa.sam
​
done
​
​
# Process for use with Samtools
​
load_samtools_1.9
​
# Make a Samtools index of reference genome
cd /safs-data02/dennislab/Public/public_dbs/genomes/fungi/Mucor_circinelloides/reference_genome/GCA_001599575.1/
samtools faidx GCA_001599575.1_JCM_22480_assembly_v001_genomic.fna
​
# Convert SAM to BAM
cd /safs-data02/dennislab/Public/Collaborators/Clement/Oxipops/SG/4_bwa_mapping_to_mucor/
for i in `ls *.sam`; do
samtools import /safs-data02/dennislab/Public/public_dbs/genomes/fungi/Mucor_circinelloides/reference_genome/GCA_001599575.1/GCA_001599575.1_JCM_22480_assembly_v001_genomic.fna.fai ${i} ${i%.sam}.temp.bam
done
​
# Sort the BAM
for i in `ls *.temp.bam`; do
samtools sort ${i} -o ${i%.temp.bam}_bwa.sorted.temp.bam
done
​
# Index the BAM
# for i in `ls *_bwa.sorted.temp.bam`; do
# samtools index ${i} ${i%_bwa.sorted.temp.bam}_bwa.sorted.bam
# done
​
# Clean up - temporary and unneccessary large files
# cd /safs-data02/dennislab/Public/Collaborators/Clement/Oxipops/SG/4_bwa_mapping_to_mucor/
# rm *.sai
# rm *.temp.bam
​
​
# Extract sequences that mapped to Mucur circinelloides reference genome using Samtools
​
# Make BAM files containing mapped reads only (-f for unmapped)
for i in `ls *_bwa.sorted.temp.bam`; do
samtools view -b -F 4 ${i} > ${i%_bwa.sorted.temp.bam}_fungal_reads.bam
done
​
# Sort BAMs
for i in `ls *_fungal_reads.bam`; do
samtools sort -n ${i} -o ${i%.bam}_sorted.bam
done
​
# Generate R1 and R2 fastq files contain the mapped reads
cd /safs-data02/dennislab/Public/Collaborators/Clement/Oxipops/SG/4_bwa_mapping_to_mucor
for i in `ls *_fungal_reads_sorted.bam`; do
samtools fastq ${i} -1 ${i%_sorted.bam}_R1.fq -2 ${i%_sorted.bam}_R2.fq -0 /dev/null -s /dev/null -n
done
​
​
​
​
​
​
​
​
