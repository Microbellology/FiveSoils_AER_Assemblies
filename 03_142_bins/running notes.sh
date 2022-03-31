samtools sort: couldn't allocate memory for bam_mem
[E::hts_open_format] Failed to open file In10a_SD7438_S40_sorted.bam
samtools view: failed to open "In10a_SD7438_S40_sorted.bam" for reading: No such file or directory
samtools sort: couldn't allocate memory for bam_mem
[E::hts_open_format] Failed to open file In10a_SD7438_S40_unmapped_sorted.bam
samtools bam2fq: Cannot read file "In10a_SD7438_S40_unmapped_sorted.bam": No such file or directory

#!/usr/bin/env bash
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
samtools sort -n -m 500G -@ 24 ${i%_R1.fastq.gz}.bam -o ${i%_R1.fastq.gz}_sorted.bam
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
