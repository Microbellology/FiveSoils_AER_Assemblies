#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

SOIL=In

#load required modules
load_metabat
load_samtools_1.9
module load bwa

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir ${SOIL}/

#move to input file location
cd /safs-data02/dennislab/Public/belle/5soils/${SOIL}/

#copy your program input files to the scratch directory
cp 03_spades_assembly/00_spades_contigs/spades.contigs.min300.fasta /safs-data01/uqbclar8/${SOIL}/

cd /safs-data02/dennislab/Public/belle/5soils/0_raw_data/without_musa_reads/
for i in `awk '{print $1}' ${SOIL}.tsv`; do
  cp ${i}* /safs-data01/uqbclar8/${SOIL}/
done

#move to the scratch directory
cd /safs-data01/uqbclar8/${SOIL}/
mkdir 01_bins
mkdir bam_files

#index contigs file
bwa index spades.contigs.min300.fasta

#map reads to contiq files and then sort by read name (puts f and r pairs next to each other)
for i in `ls *_R1.fq.gz`; do
  bwa mem -t "24" spades.contigs.min300.fasta ${i} ${i%R1.fq.gz}R2.fq.gz | samtools view -b -o ${i%_cleaned_R1.fq.gz}mapped.bam
  samtools sort ${i%_cleaned_R1.fq.gz}mapped.bam -o ${i%_cleaned_R1.fq.gz}sorted.bam
  rm ${i%_cleaned_R1.fq.gz}mapped.bam
done
###
#calculate contig depth
jgi_summarize_bam_contig_depths --outputDepth ${SOIL}_contigs_depth.txt --pairedContigs ${SOIL}_contigs_paired.txt --minContigLength 1500 --minContigDepth 1 *sorted.bam

#binning
metabat2 --inFile spades.contigs.min300.fasta --outFile 01_bins/bin --abdFile ${SOIL}_contigs_depth.txt --minContig=1500

#copy required files to safs server and RDM
mv *sorted.bam bam_files/
#copy imediate use files to safs
cp -r 01_bins/ /safs-data02/dennislab/Public/belle/5soils/${SOIL}/04_shortread_assembly/
mv bam_files/ 01_bins/
#copy all files to RDM
cp -r 01_bins/ /rdm/Q0775-uqbclar8/belle/01_core/01_5soils_AER/04_assembly_without_musa/${SOIL}/04_shortread_assembly

#remove items from scratch drive
#cd ../
#rm -r ${SOIL}
