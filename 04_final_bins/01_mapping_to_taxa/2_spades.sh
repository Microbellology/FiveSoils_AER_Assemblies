#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

### Script to run Spades on reads
### in this case the reads have been mapped to representatives from specific taxonomic groups
### this code could be used on any F and R reads pair

### Anna-Belle Clarke
### 14.03.2022

# Load spades
module load spades/3.13.0

# go to working directory - in this case I use the scratch drive
cd /safs-data01/uqbclar8/

# set which taxonomic group you will be assembling
#j=c__Nitrospiria
j=c__Thermoleophilia
#j=f__Bacillaceae
#j=f__Beijerinckiaceae
#j=f__Microbacteriaceae
#j=f__Rhizobiaceae
#j=f__Rhodanobacteraceae
#j=o__Streptomycetales


# make output directories
mkdir spades_${j}_80

# Run program
metaspades.py -1 mapped_reads_${j}_80/${j#*c__}_R1.fastq.gz -2 mapped_reads_${j}_80/${j#*c__}_R2.fastq.gz  -o spades_${j}_80 -t 2 -m 100
