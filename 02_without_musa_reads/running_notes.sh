#this is running notes, maybe script drafting or tester job numbers  as well as to do at the top





'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#load required modules
load_coverm

#set up working directory in scratch
#cd /safs-data01/uqbclar8/
#mkdir coverm/

#go to input file location
#cd /safs-data02/dennislab/Public/belle/5soils/final_bins/
#copy your program input files to the scratch directory
#cp -r dRep/dereplicated_genomes/ /safs-data01/uqbclar8/ #dir with bins only
#cp -r reads/ /safs-data01/uqbclar8/ #each samples, merged lanes raw reads

#go to the scratch directory
cd /safs-data01/uqbclar8/

#run program
coverm genome -c reads/*R1.fastq.gz reads/*R2.fastq.gz -d dereplicated_genomes/ -x fa -o coverm/AER_coverage.tsv -m trimmed_mean -t 15
#150mem

#copy dir back over
cp -r coverm/ /safs-data02/dennislab/Public/belle/5soils/final_bins/'


sbatch -c 15 --mem=150GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=coverM 8_coverM.sh
Submitted batch job 11285506


for i in `ls *gz`; do
  j=`zcat ${i} | grep -c "@"`
  echo ${i%.fastq.gz} ${j} >> raw_read_clean_count.tsv
done

cd /safs-data01/uqkweigh/prokka/outputs/
for i in `ls *.fa`; do
  awk '/^>/ { ok=index($0,"16S")!=0;} {if(ok) print;}' ${i%} > ${i%.fa}_16S.fa
done


samtools sort: couldn't allocate memory for bam_mem
[E::hts_open_format] Failed to open file In10a_SD7438_S40_sorted.bam


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
#rm ${i%.bam}_unmapped_sorted.bam
'
~
