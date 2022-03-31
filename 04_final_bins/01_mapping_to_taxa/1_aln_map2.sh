#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

### Script to map shotgun reads against specific lineages and extract reads
### Go to /safs-data01/uqbclar8/reads/without_musa_original/trimmed_reads as working directory

# Set working directory
cd /safs-data01/uqbclar8/reads/without_musa_original/trimmed_reads as working directory

# Load needed modules
module load bwa
load_samtools_1.9
load_python37

# Define the lineage to map against
#j=c__Nitrospiria
#j=c__Thermoleophilia
#j=f__Bacillaceae
#j=f__Beijerinckiaceae
j=f__Microbacteriaceae
#j=f__Rhizobiaceae
#j=f__Rhodanobacteraceae
#j=o__Streptomycetales

# Make directories
mkdir mapping_${j}
mkdir samfiles_${j}
mkdir mapped_reads_${j}

# Create a BWA index for the lineage specific fasta file
bwa index ${j}_species_rep_genomes.fasta

# Process reads (map to ref, convert to sam, extract mapped reads, clean up)
for i in `ls *_1.fq.gz`; do
  # Mapping
  bwa aln -n 0.2 ${j}_species_rep_genomes.fasta ${i} > mapping_${j}/${i%_1.fq.gz}_1.sai
  bwa aln -n 0.2 ${j}_species_rep_genomes.fasta ${i%_1.fq.gz}_2.fq.gz > mapping_${j}/${i%_1.fq.gz}_2.sai

  # Covert to samfile
  cd mapping_${j}
  bwa sampe ../${j}_species_rep_genomes.fasta ${i%_1.fq.gz}_1.sai ${i%_1.fq.gz}_2.sai ../${i} ../${i%_1.fq.gz}_2.fq.gz > ../samfiles_${j}/${i%_1.fq.gz}_bwa.sam
  cd ..

  # Extract mapped reads
  cd samfiles_${j}
  awk '$3 !="*" {print $1}' ${i%_1.fq.gz}_bwa.sam > ${i%_1.fq.gz}_mapped_reads_list_temp.tsv
  grep -v -e '@' ${i%_1.fq.gz}_mapped_reads_list_temp.tsv > ${i%_1.fq.gz}_mapped_reads_list.tsv
  cd ../

done

for i in `ls *_1.fq.gz`; do
  #echo ${i}
  cd samfiles_${j}
  #grep -v -e '@' ${i%_1.fq.gz}_mapped_reads_list_temp.tsv > ${i%_1.fq.gz}_mapped_reads_list.tsv
  python /safs-data02/dennislab/Public/scripts/fastq_filter_pairs_by_id.py -1 ../${i} -2 ../${i%_1.fq.gz}_2.fq.gz -o ../mapped_reads_${j}/${i%cleaned_paired_1.fq.gz}_${j} -l ${i%_1.fq.gz}_mapped_reads_list.tsv --include
  cd ../
done



  # Clean up
  #rm mapping_${j}/*.sai
  #rm samfiles_${j}/*.sam
  #rm samfiles_${j}/*_temp.tsv
