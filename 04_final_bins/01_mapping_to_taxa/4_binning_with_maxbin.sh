#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

# Script to bin for each taxonomic group, based on the reads mapped to them

### Anna-Belle Clarke
### 29.03.2022

# load required mocules
load_maxbin
load_biosquid

# set which taxonomic group you will be assembling
#j=c__Nitrospiria
j=c__Thermoleophilia
#j=f__Bacillaceae
#j=f__Beijerinckiaceae
#j=f__Microbacteriaceae
#j=f__Rhizobiaceae
#j=f__Rhodanobacteraceae
#j=o__Streptomycetales

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir ${j}_binning/
mkdir ${j}_binning/01_bins

# copy contig file over
cp spades_${j}_80/contigs.fasta ${j}_binning/${j}_contigs.fasta

# copy reads across
cp mapped_reads_${j}_80/SD*gz ${j}_binning/

# go into working directory
cd ${j}_binning/

#make list of reads
for i in `ls SD*gz`; do
  echo ${i} >> read_list.txt
done

#generate contig stats just incase min_contig_length needs to be altered later
seqstat ${j}_contigs.fasta >> contig_stat.txt

#binning
run_MaxBin.pl  -thread 2 -min_contig_length 50 -contig ${j}_contigs.fasta -reads_list read_list.txt -out 01_bins/ >> log.txt
