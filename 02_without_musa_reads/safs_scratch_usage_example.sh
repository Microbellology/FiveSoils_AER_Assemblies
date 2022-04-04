#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
#load your program(s)
load_opera_ms

#move to input file location
cd /safs-data02/dennislab/Public/Belle/5soils/In/

#copy your program input files to the scratch directory
cp 01_reads/*.gz /safs-data01/uqbclar8/
cp 01_reads/In_long_read.fastq /safs-data01/uqbclar8/
cp 02_spades/contigs.fasta /safs-data01/uqbclar8/
#move to the scratch directory
cd /safs-data01/uqbclar8/
mkdir 03_opera

#run your commands
OPERA-MS.pl --long-read-mapper blasr --no-polishing --no-strain-clustering --short-read1 In_cleaned_R1.fq.gz --short-read2 In_cleaned_R2.fq.gz --contig-file contigs.fasta --long-read In_long_read.fastq --out-dir 03_opera/ --num-processors 48

#removing contigs less than 1500bp

#load
load_seqtk
#mv into 03_opera
cd 03_opera
#removing contigs less than 1500bp
seqtk seq -L 1500 contigs.fasta > contigs.min1500.fasta

#copy required result files to safs-data02
cp contigs.min1500.fasta /safs-data02/dennislab/Public/Belle/5soils/In/03_opera_output/

#move back to scratch
cd ../
#clean out scratch directory
rm -r `ls`
