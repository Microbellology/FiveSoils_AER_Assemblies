#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
#before you do the hybrid assembly make sure you sort you long read and short read samples into the same folder
## opera hybrid assembly ##
load_opera_ms
cd /safs-data02/dennislab/PubPgc/Belle/5soils/Pg/
OPERA-MS.pl --long-read-mapper blasr --short-read1 01_reads/Pg_R1.fastq.gz --short-read2 01_reads/Pg_R2.fastq.gz --long-read 01_reads/Pg.pass.fastq --out-dir 02_opera_output/ --num-processors 48

#this file has been rewritten for each soil, look in the relevant soil folder for the script

#load_opera_ms
#OPERA-MS.pl --long-read-mapper blasr --no-polishing --no-strain-clustering --short-read1 <short-read-fwd> --short-read2 <short-read-rvs> --contig-file contigs.fasta --long-read <long-read-file> --out-dir <out-dir/> --num-processors 48
