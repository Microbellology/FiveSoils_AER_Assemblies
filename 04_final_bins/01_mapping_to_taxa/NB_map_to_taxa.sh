# This is a running notebook, this is not a script, but it does contain details of all the scripts used
# It is in cronological order of exactly what scripts were run and how
# I wrap scripts in quote marks to make them stand out more '<script>' (in atom they appear green)
# I start titles with $ to make them stand out more (in atom they appear red)
# notes start with #
# subtitles look like this ## subtile ##
# dates (dd.mm.yy) given are the dates jobs where submitted, not always when they ran/finished

$ Aim
# To map my raw reads to the taxa that are in Henry's list but are missing from my list of bins.

$ Aproach

# didn't work, often ran into disk space errors, also couldn't get it to work
# we used mem initially because it is more robust, however, we later realised that
# we don't want to use something that in robust

# changed to using bwa aln as you can adjust how stringent it is when matching reads
# to the reference file.

# initially I tried 90% match (-n 0.1) however, this seemed too stringent
# later changed to a 80% match

# the code used in all cases is below, with the J variable changing as needed:

'#!/usr/bin/env bash
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
#j=f__Microbacteriaceae
#j=f__Rhizobiaceae
j=f__Rhodanobacteraceae
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

'

# initially the last forloop was within the first forloop however, this kept giving the
# following error:

Traceback (most recent call last):
 File "/safs-data02/dennislab/Public/scripts/fastq_filter_pairs_by_id.py", line 124, in <module>
   main(args.forward_reads_file, args.reverse_reads_file, args.id_list_file, args.output_prefix, args.exclude)
 File "/safs-data02/dennislab/Public/scripts/fastq_filter_pairs_by_id.py", line 63, in main
   if not header_1.startswith('@'):
TypeError: startswith first arg must be bytes or a tuple of bytes, not str

# often when the last forloop was run in a screen it would run smoothly, without the error
#so it was then moved out of the original forloop, to see if that would solve the issue.
# it has not

# the issie kind of just resolved itself, this issue stopped occuring - I didn't change anything

# once we had the reads I ran SPAdes.

## binning methods ##

# we first were using Metabat2 as that is the binner we originally used for all the other assemblies
# however, metabat2 reqires contigs of 1500bp or more. We then switched to maxbin
# maxbin can process contigs that are 50bp or more.

# This approached still failed and we were unable to pull out any extra bins from what we had
# As of the 1st of April we have stopped pursuing this. 
