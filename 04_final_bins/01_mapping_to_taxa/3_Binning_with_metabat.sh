#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

# Script to bin for each taxonomic group, based on the reads mapped to them

### Anna-Belle Clarke
### 14.03.2022

# load required mocules
load_metabat
load_samtools_1.9
module load bwa

# set which taxonomic group you will be assembling
#j=c__Nitrospiria
j=c__Thermoleophilia
#j=f__Bacillaceae
#j=f__Beijerinckiaceae
#j=f__Microbacteriaceae
#j=f__Rhizobiaceae
#j=f__Rhodanobacteraceae
#j=o__Streptomycetales

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir ${j}_binning/
mkdir ${j}_binning/01_bins
mkdir ${j}_binning/bam_files

# copy contig files over to be indexed
cp spades_${j}_90/contigs.fasta ${j}_binning/${j}_contigs.fasta

# copy reads across
cp mapped_reads_${j}/* ${j}_binning/

# go into working directory
cd ${j}_binning/

# index contigs file
bwa index ${j}_contigs.fasta

#map reads to contiq files and then sort by read name (puts f and r pairs next to each other)
for i in `ls *_R1.fastq.gz`; do
  bwa mem -t "2" ${j}_contigs.fasta ${i} ${i%R1.fastq.gz}R2.fastq.gz | samtools view -b -o ${i%R1.fastq.gz}mapped.bam
  samtools sort ${i%R1.fastq.gz}mapped.bam -o ${i%R1.fastq.gz}sorted.bam
  rm ${i%R1.fastq.gz}mapped.bam
done
###
#calculate contig depth
#jgi_summarize_bam_contig_depths --outputDepth ${j}_contigs_depth.txt --pairedContigs ${j}_contigs_paired.txt --minContigLength 1500 --minContigDepth 1 *sorted.bam
jgi_summarize_bam_contig_depths --outputDepth ${j}_contigs_depth.txt --pairedContigs ${j}_contigs_paired.txt --minContigLength 100 --minContigDepth 1 *sorted.bam

#binning
#metabat2 --inFile ${j}_contigs.fasta --outFile 01_bins/bin --abdFile ${j}_contigs_depth.txt --minContig=1500
metabat2 --inFile ${j}_contigs.fasta --outFile 01_bins/bin --abdFile ${j}_contigs_depth.txt --minContig=100
