

## Counting number of reads that mapped to each sample ##

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#load relevant modules
module load bwa #0.7.17-r1188

#go to relevant dir
cd /safs-data01/uqbclar8/current_MAGs/

#concat all MAGs into one mag
for i in `ls *.fa`; do
  cat ${i} >> megamag142.fa
done

#move megamag into reads folder
mv megamag142.fa /safs-data02/dennislab/Public/belle/5soils/0_raw_data/without_musa_reads/
cd /safs-data02/dennislab/Public/belle/5soils/0_raw_data/without_musa_reads/

#index megamag
bwa index megamag142.fa

#run for each sample
for i in `ls *R1.fq.gz`; do
  bwa mem -t 4 -k 19 -d 120 -r 1.5 -L 7 megamag142.fa ${i} ${i%R1.fq.gz}R2.fq.gz > tmp.sam
  j=`samtools view tmp.sam | awk '{print $1}' | sort | uniq | wc -l`
  echo ${i} ${j} >> mapped_counts.tsv
  rm tmp.sam
done'

#4cpu 200mem

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
​
load_samtools_1.9
module load bwa
load_bamm

#copy megamap to new location
cd /safs-data02/dennislab/Public/belle/5soils/0_raw_data/without_musa_reads/
cp megamag142.fa /safs-data01/uqbclar8/

#re index it for next step
bwa index megamag142.fa
​
#go to new working directory
cd /safs-data01/uqbclar8/reads/

#loop though the raw reads for each sample (i) and map them to the megamag. Use the same reads as coverM here
for i in `ls *R1.fastq.gz`; do
  bwa mem -t "24" ../megamag142.fa ${i} ${i%R1.fastq.gz}R2.fastq.gz -o ${i%R1.fastq.gz}mapped.sam #map raw reads to megamags
  samtools sort -O bam -@ 24 -T ${i%R1.fastq.gz} ${i%R1.fastq.gz}mapped.sam > ${i%R1.fastq.gz}sorted.bam #sort by read name
  rm *mapped.sam
  samtools index ${i%R1.fastq.gz}sorted.bam #index for filtering
  bamm filter -b ${i%R1.fastq.gz}sorted.bam --percentage_id 0.95 --percentage_aln 0.75  #filter to meaningful mappings
  rm *sorted.bam *sorted.bam.bai
  #bamm parse -t 24 -b ${i%R1.fastq.gz}sorted_filtered.bam -c ${i%R1.fastq.gz}coverage.tsv -m tpmean #This line is calculates coverage, which you've alredy done in coverm
  k=`samtools view ${i%R1.fastq.gz}sorted_filtered.bam | awk '{print $1}' | sort | uniq | wc -l` #same thing as "grep -c -v '@'"....counts number of mapped reads
  echo "${i%_R1.fastq.gz} ${k}" >> mapped_reads_count.tsv #writes to tsv
  rm *filtered.bam *filtered.bam.bai #cleanup
done''
#cput 24, 240 mem
