#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
#load your program(s)
load_opera_ms

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir Tu/

#move to input file location
cd /safs-data02/dennislab/Public/belle/5soils/Tu/

#copy your program input files to the scratch directory
cp 01_reads/*.gz /safs-data01/uqbclar8/Tu/
#cp 01_reads/Tu_long_read.fastq.gz /safs-data01/uqbclar8/Tu/
cp 02_spades/contigs.fasta /safs-data01/uqbclar8/Tu/
#move to the scratch directory
cd /safs-data01/uqbclar8/Tu/
mkdir 03_opera

#unzip the longread file
gunzip Tu_long_read.fastq.gz

#run your commands
OPERA-MS.pl --long-read-mapper blasr --no-polishing --no-strain-clustering --short-read1 Tu_cleaned_R1.fq.gz --short-read2 Tu_cleaned_R2.fq.gz --contig-file contigs.fasta --long-read Tu_long_read.fastq --out-dir 03_opera/ --num-processors 24

#removing contigs less than 1500bp

#load
load_seqtk
#mv into 03_opera
cd 03_opera/
#removing contigs less than 1500bp
seqtk seq -L 1500 contigs.fasta > spades.contigs.min1500.fasta

#copy required result files to safs-data02
cp spades_contigs.min1500.fasta /safs-data02/dennislab/Public/belle/5soils/Tu/03_opera/

#move back to scratch
cd ../../
#clean out scratch directory
rm -r Tu/
