### This file is a collection of scripts that will assist with looking at the basic stats of your genomes
### It can also be used to look at contigs and raw reads

### Anna-Belle Clarke
### 16.3.22


#Biosquid

load_biosquid
for i in `ls *.fasta`; do
   echo ${i} >> summary.tsv
   seqstat ${i} >> summary.tsv
done
