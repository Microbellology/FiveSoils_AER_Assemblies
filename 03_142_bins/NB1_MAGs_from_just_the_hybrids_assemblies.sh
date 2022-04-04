#This is a running notebook, this is not a script, but it does contain details of all the scripts used
#It is in cronological order of exactly what scripts were run and how
#I wrap scripts in quote marks to make them stand out more '<script>' (in atom they appear green)
#I start titles with $ to make them stand ot more (in atom they appear red)
#comments start with #
#subtitles look like this ## subtile ##
#dates (dd.mm.yy) given are the dates jobs where submitted, not always when they ran/finished

#$the_original_50_MAGs


#the original 50 MAGs were missing Rhizobiales and a few other taxa that we would expect to see in
#the core microbiome. So here I run dRep without the in built qc functions to see if
#that means we will see these taxa. Rhizobiales are known to be difficult to assemble

$Without_dReps_inbuilt_checkM_QC_function

## dRep ##
'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

load_drep

#move to working directory
cd /safs-data01/uqbclar8/
mkdir dRep

#dereplicate genomes
dRep dereplicate dRep/ -g all/*.fa --ignoreGenomeQuality

#the --ignoreGenomeQuality flag stops dRep from using checkM (usually not recommended)
#without this flag drep will choose the best version of identical genomes based on checkm
#completeness, contamination, and heterogeneity. You should manually curate this
#final list, chosing representative genomes based on the following criteria:
#1. isolate genomes are always prefered if checkm scores are similar
#2. single sample assemblies are prefered over co-assemblies
'
sbatch -c 10 --mem=100GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=drep 2_dRep.sh
Submitted batch job 11632715

## gtdbtk ##
'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#load required modules
load_gtdbtk

#set up working directory in scratch
cd /safs-data01/uqbclar8/without_qc/
mkdir 02_gtdbtk

#run program
gtdbtk classify_wf --genome_dir 01_dRep/dereplicated_genomes/ --out_dir 02_gtdbtk/ -x fa  --cpus 1
#mem start at 300 and work up from there'

sbatch -c 1 --mem=300GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=gtdbtk_qc 3c_gtdbtk_all.sh
Submitted batch job 11740490

#Error ##
#ERROR: Controlled exit resulting from an unrecoverable error or warning.

#================================================================================
#EXCEPTION: ProdigalException
#  MESSAGE: An exception was caught while running Prodigal: Prodigal returned a non-zero exit code.

 #googled it and the only info I could find was on giving a batch file rather than genome dir
 #didn't make sense so hopefully more memory works

#reran with more memory
sbatch -c 1 --mem=500GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=gtdbtk_qc 3c_gtdbtk_all.sh
Submitted batch job 11743197


## checkM ##
'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#set up some easy automation
#SOIL=Li

#load required modules
load_checkm

#set up working directory in scratch
cd /safs-data01/uqbclar8/
#mkdir ${SOIL}/
mkdir checkm_all/new

#go to input file location
#cd /safs-data02/dennislab/Public/belle/5soils/${SOIL}/03_spades_assembly/03_bins/

#copy your program input files to the scratch directory
#cp -r polished_assembly/ /safs-data01/uqbclar8/${SOIL}/

#go to the scratch directory
#cd /safs-data01/uqbclar8/${SOIL}/
#mkdir output

#run program
checkm taxonomy_wf domain Bacteria -f checkm_all/new/new_bins.tsv --tab_table -x fa --threads 10 dRep/dereplicated_genomes/ checkm_all/new/
'
sbatch -c 10 --mem=100GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=checkm 4_checkM.sh
Submitted batch job 11672714

#output was later moved to /safs-data01/uqbclar8/without_qc/03_checkM

$testing_Musa_mapping
#here I test to see if the initial cleaning of the reads that we did was correct

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

module load bwa
load_samtools_1.9

#move to working dir
cd /safs-data01/uqbclar8/reads/

#set I
i=In10a_SD7438_S40_R1.fastq.gz

bwa mem -t 24 /home/safs-data02/dennislab/db/genomes/musa_spp/Musa_spp.fa ${i} ${i%R1.fastq.gz}R2.fastq.gz > cleaned_reads/${i%_R1.fastq.gz}.sam
#move to mapping file locations
cd cleaned_reads/
#convert to bam and remove sam files to save space
samtools view -bS ${i%_R1.fastq.gz}.sam > ${i%_R1.fastq.gz}.bam
#rm ${i%R1.001.fastq.gz}.sam
#sorting by read name (keeping paired reads together) remove bam to save space
samtools sort -n -m 240G -@ 24 ${i%_R1.fastq.gz}.bam -o ${i%_R1.fastq.gz}_sorted.bam
#rm ${i}
#extract unmapped reads and remove sorted bam
samtools view -b -f 4 ${i%_R1.fastq.gz}_sorted.bam > ${i%_R1.fastq.gz}_unmapped.bam
#rm ${i%.bam}_sorted.bam
#sort again by read names and remove unmapped bam to save space
samtools sort -n -m 240G -@ 24 ${i%_R1.fastq.gz}_unmapped.bam -o ${i%_R1.fastq.gz}_unmapped_sorted.bam
#rm ${i%.bam}_unmapped.bam
#extract unmapped sorted read into forard and reverse paired read fq files and once again, remove to save space
samtools fastq -@ 24 ${i%_R1.fastq.gz}_unmapped_sorted.bam -1 ${i%_R1.fastq.gz}_cleaned_test_R1.fq.gz -2 ${i%_R1.fastq.gz}_cleaned_test_R2.fq.gz -0 /dev/null -s /dev/null -n
#rm ${i%.bam}_unmapped_sorted.bam'

sbatch -c 24 --mem=240GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=mapping mapping_test.sh
Submitted batch job 11783531
