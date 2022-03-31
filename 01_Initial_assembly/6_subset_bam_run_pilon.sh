#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

## SAM tools index and subset BAM by bin then pilon polish bins ##

load_opera_ms
load_samtools_1.9
cd /safs-data02/dennislab/Public/Belle/5soils/Pg/04_bins/ #directory where the .fa files from metabat are
mkdir polished_assembly
#touch good_bins.tsv #qual >60
#touch okay_bins.tsv #>45 complete <15 contam
cd /safs-data02/dennislab/Public/Belle/5soils/Pg/03_bam #directory of sorted.bam files for each rep

for i in `ls *.bam`; do
  samtools index ${i}
done

for j in `awk "{print $1}" good_bins.tsv | tr "\n" " "`; do
  #j = bin names

  grep '>' ../04_bins/${j}.fa | sed 's/>//g' >> ../04_bins/${j}.contigs.tsv
  samtools faidx ../04_bins/${j}.fa
  counter=1
  for k in `ls *_sorted.bam`; do
    #k = sample names
    samtools view -h ${k} `cat ../04_bins/${j}.contigs.tsv | tr "\n" " "` > tmp.sam

    if [ ${counter} -eq "1" ]; then
      grep "@HD" tmp.sam >> headerlines.sam
      for i in `awk "{print $1}" ../04_bins/${j}.contigs.tsv | tr "\n" " "`; do
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
  java -Xmx200G -jar /safs-data02/dennislab/sw/opera-ms/OPERA-MS//tools_opera_ms//pilon.jar --fix bases --threads 48 --genome /safs-data02/dennislab/Public/Belle/5soils/Pg/04_bins/${j}.fa --bam /safs-data02/dennislab/Public/Belle/5soils/Pg/03_bam/sorted.bin.bam --outdir /safs-data02/dennislab/Public/Belle/5soils/Pg/04_bins/polished_assembly/ > /safs-data02/dennislab/Public/Belle/5soils/Pg/04_bins/polished_assembly/pilon.${j}.out 2> /safs-data02/dennislab/Public/Belle/5soils/Pg/04_bins/polished_assembly/pilon.${j}.err
  mv ../04_bins/polished_assembly/pilon.fasta ../04_bins/polished_assembly/${j}.pilon.fa
  rm sorted.bin*
done
