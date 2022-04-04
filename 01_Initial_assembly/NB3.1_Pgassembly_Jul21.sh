$Hybrid_Assembly

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
#before you do the hybrid assembly make sure you sort you long read and short read samples into the same folder
## opera hybrid assembly ##
load_opera_ms
cd /safs-data02/dennislab/PubPgc/Belle/5soils/Pg/
OPERA-MS.pl --long-read-mapper blasr --short-read1 01_reads/Pg_R1.fastq.gz --short-read2 01_reads/Pg_R2.fastq.gz --long-read 01_reads/Pg.pass.fastq --out-dir 02_opera_output/ --num-processors 48

#this file has been rewritten for each soil, look in the relevant soil folder for the script'

#fixes formatting when moving from windows to linux
tr -d '\r' <3_hybrid_assembly.sh> tmp.sh
rm 3_hybrid_assembly.sh
mv tmp.sh 3_hybrid_assembly.sh
#runs job - run from spades folder
sbatch -c 48 --mem=1450GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Pg_assembly 3_hybrid_assembly.sh
#follows running job, change "#######" to job id
tail -f slurm-10229930.out

$Binning

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_metabat
load_samtools_1.9
module load bwa

cd /safs-data02/dennislab/Public/Belle/5soils/Pg/
mkdir 03_bam
# filter out anything less than 1500
cd /safs-data02/dennislab/Public/Belle/5soils/Pg/02_opera_output
load_seqtk
seqtk seq -L 1500 contigs.fasta > contigs.min1500.fasta
bwa index contigs.min1500.fasta
cd /safs-data02/dennislab/Public/Belle/5soils/Pg/01_reads/
## merge lane data and move Pg files to Pg folder on server
for i in `ls *_R1.fastq.gz`; do
  bwa mem -t "24" /safs-data02/dennislab/Public/Belle/5soils/Pg/02_opera_output/contigs.min1500.fasta ${i} ${i%R1.fastq.gz}R2.fastq.gz | samtools view -b -o /safs-data02/dennislab/Public/Belle/5soils/Pg/03_bam/${i%R1.fastq.gz}mapped.bam
  samtools sort /safs-data02/dennislab/Public/Belle/5soils/Pg/03_bam/${i%R1.fastq.gz}mapped.bam -o /safs-data02/dennislab/Public/Belle/5soils/Pg/03_bam/${i%R1.fastq.gz}sorted.bam
  rm /safs-data02/dennislab/Public/Belle/5soils/Pg/03_bam/${i%R1.fastq.gz}mapped.bam
done
jgi_summarize_bam_contig_depths --outputDepth /safs-data02/dennislab/Public/Belle/5soils/Pg/03_bam/Pg_contigs_depth.txt --pairedContigs /safs-data02/dennislab/Public/Belle/5soils/Pg/03_bam/Pg_contigs_paired.txt --minContigLength 1500 --minContigDepth 1 /safs-data02/dennislab/Public/Belle/5soils/Pg/03_bam/*sorted.bam
metabat2 --inFile /safs-data02/dennislab/Public/Belle/5soils/Pg/02_opera_output/contigs.min1500.fasta --outFile /safs-data02/dennislab/Public/Belle/5soils/Pg/04_bins/bin --abdFile /safs-data02/dennislab/Public/Belle/5soils/Pg/03_bam/Pg_contigs_depth.txt --minContig=1500'

#fixes formatting when moving from windows to linux
tr -d '\r' <4_bwa_metabat.sh > tmp.sh
rm 4_bwa_metabat.sh
mv tmp.sh 4_bwa_metabat.sh
​
#runs job - run from spades folder
sbatch -c 10 --mem=200GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Pg_metabat 4_bwa_metabat.sh
​
#follows running job, change "#######" to job id
tail -f slurm-10247816.out

$CheckM_and_Pilon_Polishing

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_checkm
cd /safs-data02/dennislab/Public/Belle/5soils/Pg/
mkdir 06_checkm
mkdir 06_checkm/01_unpolished
checkm taxonomy_wf domain Bacteria -f 06_checkm/01_unpolished/qa.tsv --tab_table -x fa --threads 10 04_bins/ 06_checkm/01_unpolished'


r -d '\r' <5_checkM.sh > tmp.sh
rm 5_checkM.sh
mv tmp.sh 5_checkM.sh
​
#runs job - run from spades folder
sbatch -c 10 --mem=200GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Pg_checkM 5_checkM.sh

#follows running job, change "#######" to job id
tail -f slurm-10252039.out

#make good_bins.tsv in vim using data from the qa file from checkm - >45% complete <15% contamination

'#!/usr/bin/env bash
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
'

​
#runs job - run from spades folder
sbatch -c 48 --mem=1450GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Pg_pilon 6_subset_bam_run_pilon.sh

#follows running job, change "#######" to job id
tail -f slurm-10252382.out

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_checkm
cd /safs-data02/dennislab/Public/Belle/5soils/Pg/
#mkdir 06_checkm
mkdir 06_checkm/02_polished
checkm taxonomy_wf domain Bacteria -f 06_checkm/02_polished/qa.tsv --tab_table -x fa --threads 10 04_bins/ 06_checkm/02_polished'


#runs job - run from spades folder
sbatch -c 10 --mem=200GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Pg_checkM 5_checkM.sh

#follows running job, change "#######" to job id
tail -f slurm-10253726.out

$gtdbtk

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_gtdbtk

cd /safs-data02/dennislab/Public/Belle/5soils/Pg/
mkdir 07_gtdbtk

gtdbtk classify_wf --genome_dir 04_bins/polished_assembly/ --out_dir 07_gtdbtk/ -x fa  --cpus 20'


sbatch -c 20 --mem=800GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Li_GTDB-tk 8_GTDB-tk.sh
tail -f slurm-10255509.out

##not working due to pplacer making it look like it's using more cpus than it is. Use 1 cpu

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_gtdbtk

cd /safs-data02/dennislab/Public/Belle/5soils/Pg/
mkdir 07_gtdbtk
cd /safs-data02/dennislab/Public/Belle/5soils/Pg/04_bins/polished_assembly/

for i in `ls *.tsv`; do
  mkdir /safs-data02/dennislab/Public/Belle/5soils/Pg/07_gtdbtk/${i%.tsv}
  gtdbtk classify_wf --batchfile ${i} --out_dir /safs-data02/dennislab/Public/Belle/5soils/Pg/07_gtdbtk/${i%.tsv} -x fa  --cpus 1
done
'

sbatch -c 1 --mem=300GB --partition=safs --time=365-0:00:00 --no-kill --job-name=Pg_GTDB-tk 8.1_GTDBtk_forloop.sh
tail -f slurm-10280716.out



$dRep
10253849


$CCMetagen
10253843
