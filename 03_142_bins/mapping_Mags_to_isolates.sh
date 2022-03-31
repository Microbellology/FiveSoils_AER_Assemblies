
#!/bin/bash
#
#PBS -S /bin/bash
#PBS -A UQ-SCI-SEES
#PBS -N M2I
#PBS -l select=1:ncpus=24:mem=240GB
#PBS -l walltime=23:00:00

#load modules
module load bwa
module load samtools/1.9

#make working directory
cd $TMPDIR
mkdir MAGs_to_isolates

#copy over relevant files
cd /QRISdata/Q0775/belle/01_core/01_5soils_AER/Run_on_RCC/
cp g__Ralstonia.tsv $TMPDIR/
cp Belle_MAGS $TMPDIR/
cp Belle_reads $TMPDIR/
cp Olwen_final_bins $TMPDIR/

cd $TMPDIR

k=g__Rhizobium.tsv
for i in `awk '{print $1}' ${k}`; do
  #i is each MAG
  l=`awk '{print $3}' ${k}`
  n=${i#*Belle_MAGS/}
  #l is the reads to be mapped (gives read 1, have to change for read 2)
  #n is the just the MAG name
  #index MAG i
  bwa index ${i}
  #map read 1 and 2 (l) to each MAG (i) and output as a sam file
  bwa mem -t 2 ${i} ${l} ${l%R1.fastq.gz}R2.fastq.gz > MAGs_to_isolates/${n%.fa}.sam
  #move to mapping file location
  cd MAGs_to_isolates/
  #convert to bam and remove sam files to save space
  samtools view -bS ${n%.fa}.sam > ${n%.fa}.bam
  #rm ${n%.fa}.sam
  #sort by read name (keeping paired together) and remove bam to save space
  samtools sort -n -m 50G -@ 2 ${n%.fa}.bam -o ${n%.fa}_sorted.bam
  #rm ${n%.fa}.bam
  #extract mapped reads and remove sorted bam
  samtools view -b -F 4 ${n%.fa}_sorted.bam > ${n%.fa}_mapped.bam
  #rm ${n%.fa}_sorted.bam
  #sort mapped bam and remove
  samtools sort -n -m 50G -@ 2 ${n%.fa}_mapped.bam -o ${n%.fa}_mapped_sorted.bam
  #rm ${n%.fa}_mapped.bam
  #extract mapped sorted read into forard and reverse paired read fq files and once again, remove to save space
  samtools fasta -@ 2 ${n%.fa}_mapped_sorted.bam -1 ${n%.fa}_mapped_reads_R1.fq.gz -2 ${n%.fa}_mapped_reads_R2.fq.gz -0 /dev/null -s /dev/null -n
  samtools view ${n%.fa}_mapped_sorted.bam > ${n%.fa}_mapped_sorted.sam
  #rm ${n%.fa}_mapped_sorted.bam
  #move out of the mapping dir
  cd ../
  for j in `awk '{print $2}' ${k}`; do
    #j is each isolate
    o=${j#*Olwen_final_bins/}
    bwa index ${j}
    #now mapped the reads to the isolates
    bwa mem -t 2 ${j} MAGs_to_isolates/${n%.fa}_mapped_reads_R1.fq.gz MAGs_to_isolates/${n%.fa}_mapped_reads_R2.fq.gz > MAGs_to_isolates/${n%.fa}_to_${o%.fa}.sam
  done
done





cp -r MAGs_to_Isolates/* /QRISdata/Q0775/belle/01_core/01_5soils_AER/Run_on_RCC/MAGs_to_Isolates/
