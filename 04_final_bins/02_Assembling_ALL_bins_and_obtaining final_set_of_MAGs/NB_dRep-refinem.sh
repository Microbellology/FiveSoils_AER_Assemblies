# This is a running notebook, this is not a script, but it does contain details of all the scripts/code used
# It is in cronological order of exactly what scripts were run and how
# I wrap scripts in quote marks to make them stand out more '<script>' (in atom they appear green)
# I start titles with $ to make them stand out more (in atom they appear red)
# notes start with #
# subtitles look like this ## subtile ##
# dates (dd.mm.yy) given are the dates jobs where submitted, not always when they ran/finished

$ Aim
# Here we are putting all 1401 bins generated from all past assemblies together to
# make a final list of bins. Ideally, bins made from those that were mapped to the missing
# taxa will also be inclubed in the final dRep bins at a later stage

$ Approach
## dRep ##

# To combine all the bins I first made a list of all the polished hybrid bins and subtracted
# these from the list of unpolished bins. The remaining unpolished bin where also put into
# the large list of bins folder. That way all bins that were made from the hybrid assemblies were
# included in the final dRep. All shortreads where lso included
# at this stage no bins that had been mapped ot missing taxa were included
# the inbuilt QC for dRep was not used as this has been found to produce less bins at the end
# we intend to polish bins in an attempt to increase their quality

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

load_drep

#move to working directory
cd /safs-data01/uqbclar8/
#mkdir short_read_included
mkdir dRep_no_qc_ALL_bins

#dereplicate genomes
dRep dereplicate dRep_no_qc_ALL_bins -g all_bins_4assemblies/*.fa --ignoreGenomeQuality
#mem 100, cpu 10
'

# this resulted in 471 bins

## CheckM ##

# checkM was then run to see the over quality of each bin\

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#load required modules
load_checkm

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir checkm_all_bins

#run program
checkm taxonomy_wf domain Bacteria -f checkm_all_bins/all_bins.tsv --tab_table -x fa --threads 10 all_polished_bins/ checkm_all_bins/
'

## GTDBtk ##

# followed by GTDBtk to see the taxonomy

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#load required modules
load_gtdbtk

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir gtdbtk_all_bins

#run program
gtdbtk classify_wf --genome_dir all_polished_bins/ --out_dir gtdbtk_all_bins/ -x fa  --cpus 1
#mem start at 300 and increase from there'

## CoverM ##

# and lastly coverM to see the overall coverage of each MAG to each sample

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#load required modules
load_coverm

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir coverm_all_bins/

#run program
coverm genome -c reads/*fastq.gz -d all_polished_bins/ -x fa -o coverm_all_bins/AER_all_bins_coverage.tsv -m trimmed_mean -t 15
#150mem
'

## Thoughts so far ##

# the bins are not as good a quality as I was expecting.
# of the 471 bins, only 63 of them were >60% complete and less that 10% contaminated
# We also were unable to pull any mags from the reads that mapped to the missing taxa

# Moving forward it would be good to polish the bins that we have to see if we can increase the quality
# of any of them.

$ RefineM

## generating Bamfiles ##

# first we need to generate bam files of the reads that map to the SPAdes opera assebly specifically
# as each assembly was done per soil, we will map each soil R1 and R2 to each of the contig files

'
#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

# This is a script that maps reads back to the assembly

# load required modules
module load bwa
load_samtools_1.9

# asign variables
SOIL=Tu

# go to working directory
cd /safs-data01/uqbclar8/02_assembly/06_refineM/${SOIL}/

# Index the contig file
bwa index spades.contigs.min1500.fasta

# Map reads to contig file
bwa mem -t 2 spades.opera.contigs.min1500.fasta ${SOIL}_cleaned_R1.fq.gz ${SOIL}_cleaned_R2.fq.gz -o ${SOIL}_cleaned_mapped.sam

# convert to bam file
samtools sort -O bam -@ 2 -T ${SOIL} ${SOIL}_cleaned_mapped.sam > ${SOIL}_sorted.bam

# Index
samtools index ${SOIL}_sorted.bam

# clean up
rm  ${SOIL}_cleaned_mapped.sam'

# these worked well and were done for each soil
# it is worth noting that both To and Tu contigs file did not have opera in the name
# but they were collected from the opera output dir on the RDM
# I belive they are the opera output files, they just don't have opera in the name
# as Tu and To were often done first before I figured I needed to name it something else
# To's name was changed to remove to opera as well, to fit the script I was using at the time
# they all are opera outputs, I triple checked

## Scaffold_stats ##

# First use scaffold_stats which generates a file that is required for most other functions

# the contig files for all 5 soils were then concatinated into on contig file to feed into refineM
cat spades.opera.contigs.min1500.fasta >> ../scaffold_stats/spades_opera_assemblies_combined.fasta

# everything except the bins themselves were moved to the scaffold_stats foler

"#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

## First use scaffold_stats which generates a file that is required for most other functions

# load in modules
load_refinem

# go to working directory
cd /safs-data01/uqbclar8/02_assembly/06_refineM/scaffold_stats/
# in this directory, place you sorted bam files and the contig/scaffold file

# make an output directoy
mkdir output

# run refineM
refinem scaffold_stats -c 2 -x fa spades_opera_assemblies_combined.fasta /safs-data01/uqbclar8/02_assembly/02_dRep_no_qc_ALL_bins/ output/ *bam
"
