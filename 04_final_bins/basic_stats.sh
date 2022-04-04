### This file is a collection of scripts that will assist with looking at the basic stats of your genomes
### It can also be used to look at contigs (assemblys) and raw reads

### Anna-Belle Clarke
### 16.3.22


## Biosquid ##

# load module
load_biosquid

# Single files
seqstat file_name

# or to write to a file
seqstat file_name >> seqstat.tsv

# multiple files
load_biosquid
for i in `ls *.fasta`; do
   echo ${i} >> summary.tsv
   seqstat ${i} >> summary.tsv
done

## BBmap ##
