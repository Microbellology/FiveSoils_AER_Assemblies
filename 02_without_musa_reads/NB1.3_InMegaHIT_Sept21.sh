#This is a running notebook, this is not a script, but it does contain details of all the scripts used
#It is in cronological order of exactly what scripts were run and how
#I wrap scripts in quote marks to make them stand out more '<script>' (in atom they appear green)
#I start titles with $ to make them stand ot more (in atom they appear red)
#comments start with #
#subtitles look like this ## subtile ##
#dates (dd.mm.yy) given are the dates jobs where submitted, not alwasy when they ran/finished

$Opera_assembly #15.09.21
#using musa free reads - see beginning of NB 1.2 for details
#run on SAFS scratch drive

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
#load your program(s)
load_opera_ms

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir In/

#move to input file location
cd /safs-data02/dennislab/Public/Belle/5soils/In/

#copy your program input files to the scratch directory
cp 01_reads/*.gz /safs-data01/uqbclar8/In/
cp 01_reads/In_long_read.fastq /safs-data01/uqbclar8/In/
#cp 02_spades/contigs.fasta /safs-data01/uqbclar8/In/
#move to the scratch directory
cd /safs-data01/uqbclar8/In/
mkdir 03_opera

#run your commands
OPERA-MS.pl --long-read-mapper blasr --no-polishing --no-strain-clustering --short-read1 In_cleaned_R1.fq.gz --short-read2 In_cleaned_R2.fq.gz --long-read In_long_read.fastq --out-dir 03_opera/ --num-processors 48

#removing contigs less than 1500bp

#load
load_seqtk
#mv into 03_opera
cd 03_opera/
#removing contigs less than 1500bp
seqtk seq -L 1500 contigs.fasta > contigs.min1500.fasta

#copy required result files to safs-data02
cp contigs.min1500.fasta /safs-data02/dennislab/Public/Belle/5soils/In/03_opera_output/

#move back to scratch
cd ../../
#clean out scratch directory
rm -r In/'

#submit script
sbatch -c 48 --mem=1450GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=In_opera 3_opera.sh
10645343 #job ID

$Checkm_and_Polishing

#Script for checkM
'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#set up some easy automation
SOIL=In

#load required modules
load_checkm

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir ${SOIL}/

#go to input file location
cd /safs-data02/dennislab/Public/belle/5soils/${SOIL}/02_megahit_assembly/

#copy your program input files to the scratch directory
cp -r 03_bins/ /safs-data01/uqbclar8/${SOIL}/

#go to the scratch directory
cd /safs-data01/uqbclar8/${SOIL}/
mkdir output

#run program
checkm taxonomy_wf domain Bacteria -f output/${SOIL}_unpolished_megahit.tsv --tab_table -x fa --threads 10 03_bins/ output/

#copy over relevant files
cp output/${SOIL}_unpolished_megahit.tsv /safs-data02/dennislab/Public/belle/5soils/${SOIL}/02_megahit_assembly/04_checkM/

#clear scratch
cd ..
rm -r ${SOIL}/'

#ran manually on a compute node using 10 cores and 100mem

#Polishing script
#this script didn't work - file names and pathways were incorrect
{'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

## SAM tools index and subset BAM by bin then pilon polish bins ##

#make a tsv files of all the good bins before running this script, put it in the same folder as the bam files
#vim good_bins.tsv #>45 complete <15 contam

#set up some easy automation
SOIL=In

#load required modules
load_opera_ms
load_samtools_1.9

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir ${SOIL}/

#go to input file location
cd /safs-data02/dennislab/Public/belle/5soils/${SOIL}/02_megahit_assembly/

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

  grep '>' ../03_bins/${j}.fa | sed 's/>//g' >> ../03_bins/${j}.contigs.tsv
  samtools faidx ../03_bins/${j}.fa
  counter=1
  for k in `ls *_sorted.bam`; do
    #k = sample names
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
    samtools view -S -b tmp.sam > bin.${k%_sorted.bam}.bam
    rm tmp.sam
  done
  samtools merge -h headerlines.sam bin.bam bin.*.bam
  rm headerlines.sam
  samtools sort bin.bam -o sorted.bin.bam
  rm bin.bam
  rm bin.*.bam
  samtools index sorted.bin.bam
  java -Xmx200G -jar /safs-data02/dennislab/sw/opera-ms/OPERA-MS//tools_opera_ms//pilon.jar --fix bases --threads 24 --genome /safs-data01/uqbclar8/${SOIL}/03_bins/${j}.fa --bam /safs-data01/uqbclar8/${SOIL}/02_bam/sorted.bin.bam --outdir /safs-data01/uqbclar8/${SOIL}/03_bins/polished_assembly/ > /safs-data01/uqbclar8/${SOIL}/03_bins/polished_assembly/pilon.${j}.out 2> /safs-data01/uqbclar8/${SOIL}/03_bins/polished_assembly/pilon.${j}.err
  mv ../03_bins/polished_assembly/pilon.fasta ../03_bins/polished_assembly/${j}.pilon.fa
  rm sorted.bin*
done

#copy polished assemblies over to safs
cd /safs-data01/uqbclar8/${SOIL}/
cp -r polished_assembly /safs-data02/dennislab/Public/belle/5soils/In/02_megahit_assembly/03_bins/

#clear scratch drive
#cd ..
#rm -r ${SOIL}'
}

sbatch -c 24 --mem=250GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=In_pilon 6_pilon.sh
Submitted batch job 11063350

#new script
'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

## SAM tools index and subset BAM by bin then pilon polish bins ##

#make a tsv files of all the good bins before running this script, put it in the same folder as the bam files
#vim good_bins.tsv #>45 complete <15 contam

#set up some easy automation
SOIL=In

#load required modules
load_opera_ms
load_samtools_1.9

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir ${SOIL}/

#go to input file location
cd /safs-data02/dennislab/Public/belle/5soils/${SOIL}/02_megahit_assembly/

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

  grep '>' ../03_bins/${j}.fa | sed 's/>//g' >> ../03_bins/${j}.contigs.tsv
  samtools faidx ../03_bins/${j}.fa
  counter=1
  for k in `ls *sorted.bam`; do
    #k = sample names
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
  samtools merge -h headerlines.sam bin.bam bin.*.bamqe
  rm headerlines.sam
  samtools sort bin.bam -o sorted.bin.bam
  rm bin.bam
  rm bin.*.bam
  samtools index sorted.bin.bam
  java -Xmx200G -jar /safs-data02/dennislab/sw/opera-ms/OPERA-MS//tools_opera_ms//pilon.jar --fix bases --threads 10 --genome /safs-data01/uqbclar8/${SOIL}/03_bins/${j}.fa --bam /safs-data01/uqbclar8/${SOIL}/02_bam/sorted.bin.bam --outdir /safs-data01/uqbclar8/${SOIL}/polished_assembly/ > /safs-data01/uqbclar8/${SOIL}/polished_assembly/pilon.${j}.out 2> /safs-data01/uqbclar8/${SOIL}/polished_assembly/pilon.${j}.err
  mv ../polished_assembly/pilon.fasta ../polished_assembly/${j}.pilon.fa
  rm sorted.bin*
done

#copy polished assemblies over to safs
cd /safs-data01/uqbclar8/${SOIL}/
cp -r polished_assembly/ /safs-data02/dennislab/Public/belle/5soils/In/02_megahit_assembly/03_bins/

#clear scratch drive
#cd ..
#rm -r ${SOIL}'

#rerun with edited script
sbatch -c 10 --mem=150GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=In_pilon 6_pilon.sh
Submitted batch job 11079671

sbatch -c 15 --mem=500GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=In_pilon 6_pilon.sh
Submitted batch job 11135815

#checkM on polished bins
'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#set up some easy automation
SOIL=In

#load required modules
load_checkm

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir ${SOIL}/

#go to input file location
cd /safs-data02/dennislab/Public/belle/5soils/In/02_megahit_assembly/03_bins/

#copy your program input files to the scratch directory
cp -r polished_assembly/ /safs-data01/uqbclar8/${SOIL}/

#go to the scratch directory
cd /safs-data01/uqbclar8/${SOIL}/
mkdir output

#run program
checkm taxonomy_wf domain Bacteria -f output/${SOIL}_polished_megahit.tsv --tab_table -x fa --threads 10 polished_assembly/ output/

#copy over relevant files
cp output/${SOIL}_polished_megahit.tsv /safs-data02/dennislab/Public/belle/5soils/${SOIL}/02_megahit_assembly/04_checkM/

#clear scratch
cd ..
rm -r ${SOIL}/
'
sbatch -c 10 --mem=100GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=In_checkM 5_checkM.sh
Submitted batch job 11207521
