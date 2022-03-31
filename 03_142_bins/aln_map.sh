#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#load needed modules
module load bwa
load_samtools_1.9

#creat variables
j=f__Bacillaceae

#Make working directory
mkdir aln_${j}

#index the fasta
#bwa index ${j}_species_rep_genomes.fasta

#map trimmed read (trimmed without Musa) to reference
'for i in `ls *.fq.gz`; do
  bwa aln -n 0.1 ${j}_species_rep_genomes.fasta ${i} > aln_${j}/${i%.fq.gz}.sai
done'

bwa aln -n 0.1 ${j}_species_rep_genomes.fasta all_reads_R1.fq.gz > aln_${j}/all_reads_R1.sai
bwa aln -n 0.1 ${j}_species_rep_genomes.fasta all_reads_R2.fq.gz > aln_${j}/all_reads_R2.sai

cd aln_${j}

#convert to samfile
'for i in `ls *_1.sai`; do
  bwa sampe ../${j}_species_rep_genomes.fasta ${i} ${i%_1.sai}_2.sai ../${i%_1.sai}_1.fq.gz ../${i%_1.sai}_2.fq.gz > ${i%_1.sai}_bwa.sam
done'

bwa sampe ../${j}_species_rep_genomes.fasta all_reads_R1.sai all_reads_R2.sai ../all_reads_R1.fq.gz ../all_reads_R2.fq.gz > all_reads_bwa.sam

#faidx reference file ???
samtools faidx ../${j}_species_rep_genomes.fasta

gzip ../${j}_species_rep_genomes.fasta

#convert SAm to BAM, might further label?
'for i in `ls *.sam`; do
samtools import ../${j}_species_rep_genomes.fasta.fai ${i} ${i%.sam}_temp.bam
done'

samtools import ../${j}_species_rep_genomes.fasta.fai all_reads_bwa.sam all_reads_bwa_temp.bam

rm ../*fai *sam *sai

#sort the bam file
'for i in `ls *temp.bam`; do
samtools sort ${i} -o ${i%_bwa_temp.bam}_bwa_sorted_temp.bam #keep this
done'

samtools sort all_reads_bwa_temp.bam -o all_reads_bwa_sorted_temp.bam #keep this

rm all_reads_bwa_temp.bam

'for i in `ls *_bwa_sorted_temp.bam`; do
samtools view -b -F 4 ${i} > ${i%_bwa_sorted_temp.bam}_mapped_reads.bam
done'

samtools view -b -F 4 all_reads_bwa_sorted_temp.bam > all_reads_mapped_reads.bam

# Sort BAMs
'for i in `ls *_mapped_reads.bam`; do
samtools sort -n ${i} -o ${i%.bam}_sorted.bam
done'

samtools sort -n all_reads_mapped_reads.bam -o all_reads_mapped_reads_sorted.bam

rm all_reads_mapped_reads.bam

# Generate R1 and R2 fastq files contain the mapped reads
'for i in `ls *_mapped_reads_sorted.bam`; do
samtools fastq ${i} -1 ${i%_sorted.bam}_R1.fq -2 ${i%_sorted.bam}_R2.fq -0 /dev/null -s /dev/null -n
done'

samtools fastq all_reads_mapped_reads_sorted.bam -1 all_reads_mapped_reads_R1.fq -2 all_reads_mapped_reads_R2.fq -0 /dev/null -s /dev/null -n

#remove all unnecessary temprary files
rm all_reads_mapped_reads_sorted.bam

#zip all the fq files
gzip *fq

#you should now only be left with the mapped_reads_sorted.bam and mapped reads fq.gz files
