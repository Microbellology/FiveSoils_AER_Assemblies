#This is a running notebook, this is not a script, but it does contain details of all the scripts used
#It is in cronological order of exactly what scripts were run and how
#I wrap scripts in quote marks to make them stand out more '<script>' (in atom they appear green)
#I start titles with $ to make them stand ot more (in atom they appear red)
#comments start with #
#subtitles look like this ## subtile ##
#dates (dd.mm.yy) given are the dates jobs where submitted, not alwasy when they ran/finished

$Musa_mapping # 31.08.21
#map reads to musa reads
'#!/bin/bash
#
#PBS -S /bin/bash
#PBS -A UQ-SCI-SEES
#PBS -N Li_musa
#PBS -l select=1:ncpus=24:mem=200GB
#PBS -l walltime=167:00:00

module load bwa

cd $TMPDIR

mkdir 09_Li_musa_mapping

bwa mem -t "24" /QRISdata/Q0775/belle/01_core/01_5soils_AER/02_novaseq/Musa_spp.fa /QRISdata/Q0775/belle/01_core/01_5soils_AER/02_novaseq/Li/01_reads/Li_R1.fastq /QRISdata/Q0775/belle/01_core/01_5soils_AER/02_novaseq/Li/01_reads/Li_R2.fastq > 09_Li_musa_mapping/Li_aln-pe.sam

cp -r 09_Li_musa_mapping/ /QRISdata/Q0775/belle/01_core/01_5soils_AER/02_novaseq/Li/'

#run above script
qsub Li_musa.pbs

#sort reads to extract those that aren't musa reads
'#!/bin/bash
#
#PBS -S /bin/bash
#PBS -A UQ-SCI-SEES
#PBS -N Li_sam
#PBS -l select=1:ncpus=10:mem=200GB
#PBS -l walltime=167:00:00

module load samtools/1.9

cd $TMPDIR

mkdir sam

##convert sam to bam, then remove sam to save space
samtools view -bS /QRISdata/Q0775/belle/01_core/01_5soils_AER/02_novaseq/Li/09_Li_musa_mapping/Li_aln-pe.sam > sam/Li_aln-pe.bam
#rm Li_aln-pe.sam

##sort bam by read name (moves paired reads adjacent to each other), then remove unsorted bam to save space
samtools sort -n -m 8G -@ 24 sam/Li_aln-pe.bam -o sam/Li_aln-pe_sorted.bam
#rm Li_aln-pe.bam

##subselect unmapped reads, then remove sorted bam
samtools view -b -f 12 -F 256 sam/Li_aln-pe_sorted.bam > sam/Li_aln-pe_unmapped.bam
#rm Li_aln-pe_sorted.bam

##sort bam by read name again, then remove unsorted bam
samtools sort -n -m 8G -@ 24 sam/Li_aln-pe_unmapped.bam -o sam/Li_aln-pe_unmapped_sorted.bam
#rm Li_aln-pe_unmapped.bam

#Extract unmapped read pairs, then remove bam
samtools fastq -@ 24 sam/Li_aln-pe_unmapped_sorted.bam -1 sam/Li_cleaned_R1.fq.gz -2 sam/Li_cleaned_R2.fq.gz -0 /dev/null -s /dev/null -n
#rm ref_genome_sample_1_unmapped_sorted.bam

cp -r sam/ /QRISdata/Q0775/belle/01_core/01_5soils_AER/02_novaseq/Li/09_Li_musa_mapping/'

#run above script
qsub Li_sam.pbs

$spades #2.9.21

#run SPADES on clean reads
'#!/bin/bash
#
#PBS -S /bin/bash
#PBS -A UQ-SCI-SEES
#PBS -N Li_spades
#PBS -l select=1:ncpus=24:mem=1975GB
#PBS -l walltime=167:00:00

module load spades/3.15.3

cd $TMPDIR

mkdir 03_Li_spades
metaspades.py -1 /QRISdata/Q0775/belle/01_core/01_5soils_AER/02_novaseq/Li/09_Li_musa_mapping/sam/Li_cleaned_R1.fq.gz -2 /QRISdata/Q0775/belle/01_core/01_5soils_AER/02_novaseq/Li/09_Li_musa_mapping/sam/Li_cleaned_R2.fq.gz -o 03_Li_spades/ -t 24 -m 1975

cp -r 03_Li_spades/ /QRISdata/Q0775/belle/01_core/01_5soils_AER/02_novaseq/Li/'

#run above script
qsub Li_spades.pbs

$Opera_assembly

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
#load your program(s)
load_opera_ms

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir Li/

#move to input file location
cd /safs-data02/dennislab/Public/belle/5soils/Li/

#copy your program input files to the scratch directory
cp 01_reads/*.gz /safs-data01/uqbclar8/Li/
#cp 01_reads/Li_long_read.fastq /safs-data01/uqbclar8/Li/
cp 03_spades_assembly/00_spades_contigs/spades.contigs.min300.fasta /safs-data01/uqbclar8/Li/
#move to the scratch directory
cd /safs-data01/uqbclar8/Li/
mkdir 03_opera

#unzip long read file
gunzip Li_long_read.fastq.gz

#run your commands
OPERA-MS.pl --long-read-mapper blasr --no-polishing --no-strain-clustering --short-read1 Li_cleaned_R1.fq.gz --short-read2 Li_cleaned_R2.fq.gz --contig-file spades.contigs.min300.fasta --long-read Li_long_read.fastq --out-dir 03_opera/ --num-processors 10

#removing contigs less than 1500bp

#load
load_seqtk
#move into 03_opera
cd 03_opera/
#removing contigs less than 1500bp
seqtk seq -L 1500 contigs.fasta > spades.opera.contigs.min1500.fasta

#copy required result files to safs-data02
cp spades.opera.contigs.min1500.fasta /safs-data02/dennislab/Public/belle/5soils/Li/03_spades_assembly/01_opera/

#move back to scratch
cd ../../
#clean out scratch directory
rm -r Li/'

#submit job
sbatch -c 24 --mem=250GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Li_sopera 3_opera.sh
10871140 #job id

#resubmit with contig file less that 4gb as opera wont work with contig files >4GB

sbatch -c 10 --mem=100GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Li_Sopera 3_opera.sh
11038527

$Binning

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
#load required modules
load_metabat
load_samtools_1.9
module load bwa

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir Li/

#move to input file location
cd /safs-data02/dennislab/Public/belle/5soils/Li/03_spades_assembly/

#copy your program input files to the scratch directory
cp 01_opera/spades.opera.contigs.min1500.fasta /safs-data01/uqbclar8/Li/

cd /safs-data02/dennislab/Public/belle/5soils/0_raw_data/without_musa_reads/
for i in `awk '{print $1}' Li.tsv`; do
  cp ${i}* /safs-data01/uqbclar8/Li/
done

#move to the scratch directory
cd /safs-data01/uqbclar8/Li/
mkdir 04_bins


#index contigs file
bwa index spades.opera.contigs.min1500.fasta

#map reads to contiq files and then sort by read name (puts f and r pairs next to each other)
for i in `ls *_R1.fq.gz`; do
  bwa mem -t "24" spades.opera.contigs.min1500.fasta ${i} ${i%R1.fq.gz}R2.fq.gz | samtools view -b -o ${i%_cleaned_R1.fq.gz}mapped.bam
  samtools sort ${i%_cleaned_R1.fq.gz}mapped.bam -o ${i%_cleaned_R1.fq.gz}_sorted.bam
  rm ${i%_cleaned_R1.fq.gz}mapped.bam
done

#calculate contig depth
jgi_summarize_bam_contig_depths --outputDepth Li_contigs_depth.txt --pairedContigs Li_contigs_paired.txt --minContigLength 1500 --minContigDepth 1 *sorted.bam

#binning
metabat2 --inFile spades.opera.contigs.min1500.fasta --outFile 04_bins/bin --abdFile Li_contigs_depth.txt --minContig=1500

#copy required files to safs server
cp *sorted.bam /safs-data02/dennislab/Public/belle/5soils/Li/03_spades_assembly/02_bam/
cp 04_bins/*fa /safs-data02/dennislab/Public/belle/5soils/Li/03_spades_assembly/03_bins/

#remove items from scratch drive
cd ../
rm -r Li'

sbatch -c 24 --mem=250GB --partition=safs --time=365-0:00:00 --no-kill --job-name=Li_Sbin 4_binning.sh
11038953

$CheckM_and_Polishing

#made and error on line 223, need to repeat from this point
{#checkM script
'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#set up some easy automation
SOIL=Li

#load required modules
load_checkm

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir ${SOIL}/

#go to input file location
cd /safs-data02/dennislab/Public/belle/5soils/In/03_spades_assembly/

#copy your program input files to the scratch directory
cp -r 03_bins/ /safs-data01/uqbclar8/${SOIL}/

#go to the scratch directory
cd /safs-data01/uqbclar8/${SOIL}/
mkdir output

#run program
checkm taxonomy_wf domain Bacteria -f output/${SOIL}_unpolished_spades.tsv --tab_table -x fa --threads 10 03_bins/ output/

#copy over relevant files
cp output/${SOIL}_unpolished_spades.tsv /safs-data02/dennislab/Public/belle/5soils/${SOIL}/03_spades_assembly/04_checkM/

#clear scratch
cd ..
rm -r ${SOIL}/'

#run as sbatch
sbatch -c 10 --mem=100GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Li_checkM 5_checkM.sh
Submitted batch job 11059555

#Pilon polishing script
'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

## SAM tools index and subset BAM by bin then pilon polish bins ##

#make a tsv files of all the good bins before running this script, put it in the same folder as the bam files
#vim good_bins.tsv #>45 complete <15 contam

#set up some easy automation
SOIL=Li

#load required modules
load_opera_ms
load_samtools_1.9

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir ${SOIL}/

#go to input file location
cd /safs-data02/dennislab/Public/belle/5soils/${SOIL}/03_spades_assembly/

#copy your program input files to the scratch directory
cp -r 02_bam/ /safs-data01/uqbclar8/${SOIL}/ #dir where sorted.bam files for each rep
cp -r 03_bins/ /safs-data01/uqbclar8/${SOIL}/ #dir where .fa files (bins) from opera are

#go to scratch dir and make an output directory
cd /safs-data01/uqbclar8/${SOIL}
mkdir polished_assembly

cd 02_bam/ #directory in scratch of sorted.bam files for each rep

for i in `ls *.bam`; do
  samtools index ${i}
done

for j in `awk "{print $1}" good_bins.tsv | tr "\n" " "`; do
  #j = bin names
  echo ${j}

  grep '>' ../03_bins/${j}.fa | sed 's/>//g' >> ../03_bins/${j}.contigs.tsv
  samtools faidx ../03_bins/${j}.fa
  counter=1
  for k in `ls *sorted.bam`; do
    #k = sample names, bam files
    echo ${k}
    samtools view -h ${k} `cat ../03_bins/${j}.contigs.tsv | tr "\n" " "` > tmp.sam

    if [ ${counter} -eq "1" ]; then
      grep "@HD" tmp.sam >> headerlines.sam
      for i in `awk "{print $1}" ../03_bins/${j}.contigs.tsv | tr "\n" " "`; do
        grep "SN:${i}\s" tmp.sam >> headerlines.sam
      done
      grep "@PG" tmp.sam >> headerlines.sam
      counter=2
    fi

    grep -v '@' tmp.sam >> mappedlines.sam
    rm tmp.sam
    cat headerlines.sam mappedlines.sam >> tmp.sam
    rm mappedlines.sam
    samtools view -S -b tmp.sam > bin.${k%sorted.bam}.bam
    rm tmp.sam
  done
  samtools merge -h headerlines.sam bin.bam bin.*.bam
  rm headerlines.sam
  samtools sort bin.bam -o sorted.bin.bam
  rm bin.bam
  rm bin.*.bam
  samtools index sorted.bin.bam
  java -Xmx500G -jar /safs-data02/dennislab/sw/opera-ms/OPERA-MS//tools_opera_ms//pilon.jar --fix bases --threads 15 --genome /safs-data01/uqbclar8/${SOIL}/03_bins/${j}.fa --bam /safs-data01/uqbclar8/${SOIL}/02_bam/sorted.bin.bam --outdir /safs-data01/uqbclar8/${SOIL}/polished_assembly/ > /safs-data01/uqbclar8/${SOIL}/polished_assembly/pilon.${j}.out 2> /safs-data01/uqbclar8/${SOIL}/polished_assembly/pilon.${j}.err
  mv ../polished_assembly/pilon.fasta ../polished_assembly/${j}.pilon.fa
  rm sorted.bin*
done

#copy polished assemblies over to safs
cd /safs-data01/uqbclar8/${SOIL}/
cp -r polished_assembly/ /safs-data02/dennislab/Public/belle/5soils/${SOIL}/03_spades_assembly/03_bins/

#clear scratch drive
cd ..
#rm -r ${SOIL}
'

sbatch -c 15 --mem=500GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Li_Spilon 6_pilon.sh
Submitted batch job 11198645

#checkM of polished bins
'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#set up some easy automation
SOIL=Li

#load required modules
load_checkm

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir ${SOIL}/

#go to input file location
cd /safs-data02/dennislab/Public/belle/5soils/${SOIL}/03_spades_assembly/03_bins/

#copy your program input files to the scratch directory
cp -r polished_assembly/ /safs-data01/uqbclar8/${SOIL}/

#go to the scratch directory
cd /safs-data01/uqbclar8/${SOIL}/
mkdir output

#run program
checkm taxonomy_wf domain Bacteria -f output/${SOIL}_polished_spades.tsv --tab_table -x fa --threads 10 polished_assembly/ output/

#copy over relevant files
cp output/${SOIL}_polished_spades.tsv /safs-data02/dennislab/Public/belle/5soils/${SOIL}/03_spades_assembly/04_checkM/

#clear scratch
cd ..
rm -r ${SOIL}/
'

sbatch -c 10 --mem=100GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Li_ScheckM 5_checkM.sh
Submitted batch job 11225990
}

#checkM rerun
'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#set up some easy automation
SOIL=Li

#load required modules
load_checkm

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir ${SOIL}/

#go to input file location
cd /safs-data02/dennislab/Public/belle/5soils/$SOIL/03_spades_assembly/

#copy your program input files to the scratch directory
cp -r 03_bins/ /safs-data01/uqbclar8/${SOIL}/

#go to the scratch directory
cd /safs-data01/uqbclar8/${SOIL}/
mkdir output

#run program
checkm taxonomy_wf domain Bacteria -f output/${SOIL}_unpolished_spades.tsv --tab_table -x fa --threads 10 03_bins/ output/

#copy over relevant files
cp output/${SOIL}_unpolished_spades.tsv /safs-data02/dennislab/Public/belle/5soils/${SOIL}/03_spades_assembly/04_checkM/

#clear scratch
cd ..
rm -r ${SOIL}/'

sbatch -c 10 --mem=100GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Li_checkM 5_checkM.sh
Submitted batch job 11229528

#rerun pilon using above script as it has no errors
sbatch -c 15 --mem=500GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Li_Spilon 6_pilon.sh
Submitted batch job 11229899

#rerun checkm on polished bins
'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#set up some easy automation
SOIL=Li

#load required modules
load_checkm

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir ${SOIL}/

#go to input file location
cd /safs-data02/dennislab/Public/belle/5soils/${SOIL}/03_spades_assembly/03_bins/

#copy your program input files to the scratch directory
cp -r polished_assembly/ /safs-data01/uqbclar8/${SOIL}/

#go to the scratch directory
cd /safs-data01/uqbclar8/${SOIL}/
mkdir output

#run program
checkm taxonomy_wf domain Bacteria -f output/${SOIL}_polished_spades.tsv --tab_table -x fa --threads 10 polished_assembly/ output/

#copy over relevant files
cp output/${SOIL}_polished_spades.tsv /safs-data02/dennislab/Public/belle/5soils/${SOIL}/03_spades_assembly/04_checkM/

#clear scratch
cd ..
rm -r ${SOIL}/
'

sbatch -c 10 --mem=100GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Li_checkM 5_checkM.sh
Submitted batch job 11272029
