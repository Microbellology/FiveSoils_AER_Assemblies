#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

# load required modules
module load bwa
load_samtools_1.9

# go to working directory
cd /safs-data01/uqbclar8/01_missing_taxa_mapping/

# assign variable
j=nitrospiria

# make output directory
mkdir 02_mapping/${j}

# Index the contig file
bwa index 01_reference_fasta_files/1_nitrospiria/${j}_species_rep_genomes.fasta

# Map reads to contig file
bwa mem -t 2 01_reference_fasta_files/1_nitrospiria/nitrospiria_species_rep_genomes.fasta all_reads_R1.fq.gz all_reads_R2.fq.gz -o 02_mapping/${j}_cleaned_mapped.sam

# go to mapping directory
cd 02_mapping/


# convert to bam file
samtools sort -O bam -@ 2 -T ${j} ${j}_cleaned_mapped.sam > ${j}_sorted.bam
