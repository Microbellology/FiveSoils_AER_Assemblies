#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
module load bwa
load_samtools_1.9

cd /safs-data02/dennislab/Public/Belle/5soils/In/09_Musa_mapping/
##map f and r reads from each sample to reference genome
#bwa mem -t "24" ref_genome.fasta sample_1_forward_reads.fq.gz sample_1_reverse_reads.fq.gz > ref_genome_sample_1.sam

##convert sam to bam, then remove sam to save space
samtools view -bS In_aln-pe.sam > In_aln-pe.bam
rm In_aln-pe.sam

##sort bam by read name (moves paired reads adjacent to each other), then remove unsorted bam to save space
samtools sort -n -m 8G -@ 24 In_aln-pe.bam -o In_aln-pe_sorted.bam
rm In_aln-pe.bam

##subselect unmapped reads, then remove sorted bam
samtools view -b -f 12 -F 256 In_aln-pe_sorted.bam > rIn_aln-pe_unmapped.bam
rm In_aln-pe_sorted.bam

##sort bam by read name again, then remove unsorted bam
samtools sort -n -m 8G -@ 24 In_aln-pe_unmapped.bam -o In_aln-pe_unmapped_sorted.bam
rm In_aln-pe_unmapped.bam

#Extract unmapped read pairs, then remove bam
samtools fastq -@ 24 In_aln-pe_unmapped_sorted.bam -1 In_cleaned_R1.fq.gz -2 In_cleaned_R2.fq.gz -0 /dev/null -s /dev/null -n
rm ref_genome_sample_1_unmapped_sorted.bam
