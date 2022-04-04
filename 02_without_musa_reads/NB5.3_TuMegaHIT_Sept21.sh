#This is a running notebook, this is not a script, but it does contain details of all the scripts used
#It is in cronological order of exactly what scripts were run and how
#I wrap scripts in quote marks to make them stand out more '<script>' (in atom they appear green)
#I start titles with $ to make them stand ot more (in atom they appear red)
#comments start with #
#subtitles look like this ## subtile ##
#dates (dd.mm.yy) given are the dates jobs where submitted, not always when they ran/finished

$Opera_assembly #15.09.21
#using musa free reads. See the beginning of NB 5.2 for details

#this runs in the safs scratch drive and saves only the contigs file the opera produces
#it also removes any contigs less that 1500bp before saving
'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
#load your program(s)
load_opera_ms

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir Tu/

#move to input file location
cd /safs-data02/dennislab/Public/belle/5soils/Tu/

#copy your program input files to the scratch directory
cp 01_reads/*.gz /safs-data01/uqbclar8/Tu/
cp 01_reads/Tu_long_read.fastq /safs-data01/uqbclar8/Tu/
#cp 02_spades/contigs.fasta /safs-data01/uqbclar8/Li/
#move to the scratch directory
cd /safs-data01/uqbclar8/Tu/
mkdir 03_opera

#run your commands
OPERA-MS.pl --long-read-mapper blasr --no-polishing --no-strain-clustering --short-read1 Tu_cleaned_R1.fq.gz --short-read2 Tu_cleaned_R2.fq.gz --long-read Tu_long_read.fastq --out-dir 03_opera/ --num-processors 48

#removing contigs less than 1500bp

#load
load_seqtk
#mv into 03_opera
cd 03_opera/
#removing contigs less than 1500bp
seqtk seq -L 1500 contigs.fasta > contigs.min1500.fasta

#copy required result files to safs-data02
cp contigs.min1500.fasta /safs-data02/dennislab/Public/belle/5soils/Tu/03_opera/

#move back to scratch
cd ../../
#clean out scratch directory
rm -r Tu/'

#submit job - remove priority flag
sbatch -c 48 --mem=1450GB --partition=safs --time=365-0:00:00 --no-kill --job-name=Tu_opera 3_opera.sh
10645376 #job number

#failed as the long read file was called somthing different

#rerun
sbatch -c 24 --mem=250GB --partition=safs --time=365-0:00:00 --no-kill --job-name=Tu_opera 3_opera.sh
10871158

$binning

#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

'#load required modules
load_metabat
load_samtools_1.9
module load bwa

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir Tu/

#move to input file location
cd /safs-data02/dennislab/Public/belle/5soils/Tu/

#copy your program input files to the scratch directory
cp 03_opera/contigs.min1500.fasta /safs-data01/uqbclar8/Tu/

cd /safs-data02/dennislab/Public/belle/5soils/0_raw_data/without_musa_reads/
for i in `awk '{print $1}' Tu.tsv`; do
  cp ${i}* /safs-data01/uqbclar8/Tu/
done

#move to the scratch directory
cd /safs-data01/uqbclar8/Tu/
mkdir 04_bins
mkdir bam_files

#index contigs file
bwa index contigs.min1500.fasta

#map reads to contiq files and then sort by read name (puts f and r pairs next to each other)
for i in `ls *_R1.fq.gz`; do
  bwa mem -t "24" contigs.min1500.fasta ${i} ${i%R1.fq.gz}R2.fq.gz | samtools view -b -o ${i%_cleaned_R1.fq.gz}mapped.bam
  samtools sort ${i%_cleaned_R1.fq.gz}mapped.bam -o ${i%_cleaned_R1.fq.gz}sorted.bam
  rm ${i%_cleaned_R1.fq.gz}mapped.bam
done

#calculate contig depth
jgi_summarize_bam_contig_depths --outputDepth Tu_contigs_depth.txt --pairedContigs Tu_contigs_paired.txt --minContigLength 1500 --minContigDepth 1 *sorted.bam

#binning
metabat2 --inFile contigs.min1500.fasta --outFile 04_bins/bin --abdFile Tu_contigs_depth.txt --minContig=1500

#copy required files to safs server
mv *sorted.bam bam_files/
mv bam_files/ 04_bins/
cp -r 04_bins/ /safs-data02/dennislab/Public/belle/5soils/Tu/

#remove items from scratch drive
cd ../
rm -r Tu'

#Run manually in a screen with compute 10cores 100mem

$CheckM_and_Polishing

#checkM script
'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#set up some easy automation
SOIL=Tu

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

sbatch -c 10 --mem=100GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Tu_checkM 5.checkM.sh
Submitted batch job 11058286

#Polishing script
'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

## SAM tools index and subset BAM by bin then pilon polish bins ##

#make a tsv files of all the good bins before running this script, put it in the same folder as the bam files
#vim good_bins.tsv #>45 complete <15 contam

#set up some easy automation
SOIL=Tu

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
cp -r polished_assembly/ /safs-data02/dennislab/Public/belle/5soils/${SOIL}/02_megahit_assembly/03_bins/

#clear scratch drive
cd ..
rm -r ${SOIL}
'

sbatch -c 15 --mem=500GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Tu_pilon 6_pilon.sh
Submitted batch job 11195731


#checkM on polished bins
'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#set up some easy automation
SOIL=Tu

#load required modules
load_checkm

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir ${SOIL}/

#go to input file location
cd /safs-data02/dennislab/Public/belle/5soils/${SOIL}/02_megahit_assembly/03_bins/

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

sbatch -c 10 --mem=100GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Tu_checkM 5_checkM.sh
Submitted batch job 11225950
