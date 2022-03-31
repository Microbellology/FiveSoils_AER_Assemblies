#This is a running notebook, this is not a script, but it does contain details of all the scripts used
#It is in cronological order of exactly what scripts were run and how
#I wrap scripts in quote marks to make them stand out more '<script>' (in atom they appear green)
#I start titles with $ to make them stand ot more (in atom they appear red)
#comments start with #
#subtitles look like this ## subtile ##
#dates (dd.mm.yy) given are the dates jobs where submitted, not always when they ran/finished

$matching_SSUs

## metataxa 2 ##

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#load required modules
load_metaxa2

#set up working directory in scratch
cd /safs-data01/uqbclar8/
mkdir metaxa

cd /safs-data01/uqbclar8/dereplicated_genomes/
#run program
for i in `ls *.fa`; do
  metaxa -i ${i} -o ../metaxa/${i%.fa} --cpu 1 -d /safs-data02/dennislab/sw/metaxa2/2.2.3/metaxa2_db/SSU/HMMs/
done
#100mem'

#all of the MAGs got a fasta file from them but on a few actually had any data in
#deleted the ones that had no data and kept the remaining ones for blast searching
#I then compiled all reads into one file

for i in `ls *fasta`; do
  cat ${i} >> MAG_SSUs.fasta
done

#getting the top 100 results
blastn -db SILVA_138.1_SSURef_NR99_tax_silva.fasta -query blast/MAG_SSUs.fasta -out blast/my_top_100.out -outfmt 6 -max_target_seqs 100 -num_threads 1

#repeat on Henry's samples
blastn -db SILVA_138.1_SSURef_NR99_tax_silva.fasta -query blast/Musa_candidate_core_bac_otus_47.fasta -out blast/henrys_core_top_100.out -outfmt 6 -max_target_seqs 100 -num_threads 1

#the silva taxa file is too big for excel
#wrote a forloop to make a smaller file to use in excel
for i in `awk '{print $2}' Henrys_top_100.out`; do
  j=`grep "${i}" Silva138_headers.tsv`
  echo ${j} >> Henys_SSU_Taxa.tsv
done

#the rest was done in excel

$mapping_raw_reads
#here I map my raw shotgun reads to Olwen's genomes to see if her genomes are present in my
#community. This is one way to tracing back to Henry's 16S data

#start with a test run, of just one list, if this works, can add in variable k to run through all lists
'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#load modules
module load bwa
load_samtools_1.9
module load_seqtk

#go to working directory
cd /safs-data02/dennislab/Public/Banana/Olwen_Belle

k=g__Chryseobacterium.tsv
#for k in `ls *.tsv`; do #k is the tsv files of each genera
  for i in `awk '{print $1}' ${k}`; do #i is each MAG
    l=`awk '{print $3}' ${k}`
    m=${l#*Belle_reads/concat/}
    n=${i#*Belle_MAGS/}
    #index mag (i)
    bwa index ${i} #row added after first error
    #map read 1 and 2 (l) to each MAG (i)
    bwa mem -t 24 ${i} ${l} ${l%R1.fastq.gz}R2.fastq.gz > MAGs_to_Isolates/${n%.fa}.sam
    #move to mapping file locations
    cd MAGs_to_Isolates
    #convert to bam and remove sam files to save space
    samtools view -bS ${n%.fa}.sam > ${n%.fa}.bam
    #sorting by read name (keeping paired reads together) remove bam to save space
    samtools sort -n -m 240G -@ 24 ${n%.fa}.bam -o ${n%.fa}_sorted.bam
    #rm ${l%R1.fastq.gz}.bam
    #extract mapped reads and remove sorted bam
    samtools view -b -F 4 ${n%.fa}_sorted.bam > ${n%.fa}_mapped.bam
    #rm ${i%.bam}_sorted.bam
    #sort again by read names and remove mapped bam to save space
    samtools sort -n -m 240G -@ 24 ${n%.fa}_mapped.bam -o ${n%.fa}_mapped_sorted.bam
    #rm ${l%R1.fastq.gz}_mapped.bam
    #extract mapped sorted read into forard and reverse paired read fq files and once again, remove to save space
    samtools fastq -@ 24 ${n%.fa}_mapped_sorted.bam -1 ${m%_R1.fastq.gz}_mapped_R1.fq.gz -2 ${m%_R1.fastq.gz}_mapped_R2.fq.gz -0 /dev/null -s /dev/null -n
    samtools view ${n%.fa}_mapped_sorted.bam > ${n%.fa}_mapped_sorted.sam
      for j in `awk '{print $2}' ${k}`; do #j is each isolate
        l=`awk '{print $3}' ${k}`
        o=${j#*Olwen_final_bins/}
        #now mapped these reads to isolates (j)
        bwa mem -t 24 ${j} ${m%_R1.fastq.gz}_mapped_R1.fq.gz ${m%_R1.fastq.gz}_mapped_R2.fq.gz > ${n}_to_${o}.sam
        #move back to raw reads dir
        #cd ../
      done
    cd ../
  done

#done
'

sbatch -c 24 --mem=240GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=M2I mags_to_isolates.sh
Submitted batch job 11781800

#Error messages
[E::bwa_idx_load_from_disk] fail to locate the index files
samtools sort: couldn''t allocate memory for bam_mem
[E::hts_open_format] Failed to open file In_bin.21_shortread_sorted.bam
samtools view: failed to open "In_bin.21_shortread_sorted.bam" for reading: No such file or directory
samtools sort: couldn''t allocate memory for bam_mem
[E::hts_open_format] Failed to open file In_bin.21_shortread_mapped_sorted.bam
samtools bam2fq: Cannot read file "In_bin.21_shortread_mapped_sorted.bam": No such file or directory
[E::hts_open_format] Failed to open file In_bin.21_shortread_mapped_sorted.bam
samtools view: failed to open "In_bin.21_shortread_mapped_sorted.bam" for reading: No such file or directory
awk: fatal: cannot open file `g__Chryseobacterium.tsv` for reading (No such file or directory)

#started by adding in index line
sbatch -c 24 --mem=240GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=M2I mags_to_isolates.sh
Submitted batch job 11783336
