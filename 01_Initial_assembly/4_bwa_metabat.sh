#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_metabat
load_samtools_1.9
module load bwa

cd /safs-data02/dennislab/Public/Belle/5soils/Pg/
mkdir 03_bam
# filter out anything less than 1500
cd /safs-data02/dennislab/Public/Belle/5soils/Pg/02_opera_output
load_seqtk
seqtk seq -L 1500 contigs.fasta > contigs.min1500.fasta
bwa index contigs.min1500.fasta
cd /safs-data02/dennislab/Public/Belle/5soils/Pg/01_reads/
## merge lane data and move Pg files to Pg folder on server
for i in `ls *_R1.fastq.gz`; do
  bwa mem -t "24" /safs-data02/dennislab/Public/Belle/5soils/Pg/02_opera_output/contigs.min1500.fasta ${i} ${i%R1.fastq.gz}R2.fastq.gz | samtools view -b -o /safs-data02/dennislab/Public/Belle/5soils/Pg/03_bam/${i%R1.fastq.gz}mapped.bam
  samtools sort /safs-data02/dennislab/Public/Belle/5soils/Pg/03_bam/${i%R1.fastq.gz}mapped.bam -o /safs-data02/dennislab/Public/Belle/5soils/Pg/03_bam/${i%R1.fastq.gz}sorted.bam
  rm /safs-data02/dennislab/Public/Belle/5soils/Pg/03_bam/${i%R1.fastq.gz}mapped.bam
done
jgi_summarize_bam_contig_depths --outputDepth /safs-data02/dennislab/Public/Belle/5soils/Pg/03_bam/Pg_contigs_depth.txt --pairedContigs /safs-data02/dennislab/Public/Belle/5soils/Pg/03_bam/Pg_contigs_paired.txt --minContigLength 1500 --minContigDepth 1 /safs-data02/dennislab/Public/Belle/5soils/Pg/03_bam/*sorted.bam
metabat2 --inFile /safs-data02/dennislab/Public/Belle/5soils/Pg/02_opera_output/contigs.min1500.fasta --outFile /safs-data02/dennislab/Public/Belle/5soils/Pg/04_bins/bin --abdFile /safs-data02/dennislab/Public/Belle/5soils/Pg/03_bam/Pg_contigs_depth.txt --minContig=1500
