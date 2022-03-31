'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
#before you do the hybrid assembly make sure you sort you long read and short read samples into the same folder
## opera hybrid assembly ##
load_opera_ms
cd /safs-data02/dennislab/Public/Belle/5soils/In/
OPERA-MS.pl --long-read-mapper blasr --short-read1 01_reads/In_R1.fastq.gz --short-read2 01_reads/In_R2.fastq.gz --long-read 01_reads/In.pass.fastq --out-dir 02_opera_output/ --num-processors 48
'
##script was place in /safs-data02/dennislab/Public/Belle/5soils/In/ and rand from there with the following

#fixes formatting when moving from windows to linux
tr -d '\r' <3_hybrid_assembly.sh > tmp.sh
rm 3_hybrid_assembly.sh
mv tmp.sh 3_hybrid_assembly.sh
#runs job - run from spades folder
sbatch -c 48 --mem=1450GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=In_assembly 3_hybrid_assembly.sh
#follows running job, change "#######" to job id
tail -f slurm-#######.out

error
zcat In_R1.fastq.gz | grep '@' | wc -c
12582373964
zcat In_R2.fastq.gz | grep '@' | wc -c
12573604583

 #not the same, need to reconcat

#checking individual samples 03/08/21
zcat In10a_SD7438_S40_R1.fastq.gz | grep '@' | wc -c
2914824375
zcat In10a_SD7438_S40_R2.fastq.gz | grep '@' | wc -c
2914824375

zcat In1a_SD7439_S41_R1.fastq.gz | grep '@' | wc -c
2118141459
zcat In1a_SD7439_S41_R2.fastq.gz | grep '@' | wc -c
2118141459

zcat In2a_SD7441_S43_R1.fastq.gz | grep '@' | wc -c
1049813392
zcat In2a_SD7441_S43_R2.fastq.gz | grep '@' | wc -c
1049813392

zcat In2_SD7440_S42_R1.fastq.gz | grep '@' | wc -c
1303359941
zcat In2_SD7440_S42_R2.fastq.gz | grep '@' | wc -c
1303359941

zcat In4_SD7416_S18_R1.fastq.gz | grep '@' | wc -c
828309880
zcat In4_SD7416_S18_R2.fastq.gz | grep '@' | wc -c
828309880

zcat In6_SD7422_S24_R1.fastq.gz | grep '@' | wc -c
744119712
zcat In6_SD7422_S24_R2.fastq.gz | grep '@' | wc -c
744119712

zcat In8_SD7430_S32_R1.fastq.gz | grep '@' | wc -c
2641852860
zcat In8_SD7430_S32_R2.fastq.gz | grep '@' | wc -c
2641852860

zcat In9_SD7433_S35_R1.fastq.gz | grep '@' | wc -c
973182964
zcat In9_SD7433_S35_R2.fastq.gz | grep '@' | wc -c
973182964

#Reconcating all samples into one fwd and rvs 03/08/21
cd /rdm/Q0775-uqbclar8/belle/01_core/01_5soils_AER/02_novaseq/In/
#In10a
zcat In10a_SD7438_S40_R1.fastq.gz >> In_R1.fastq
zcat In10a_SD7438_S40_R2.fastq.gz >> In_R2.fastq
#In1a
zcat In1a_SD7439_S41_R1.fastq.gz >> In_R1.fastq
zcat In1a_SD7439_S41_R2.fastq.gz >> In_R2.fastq
#In2a
zcat In2a_SD7441_S43_R1.fastq.gz >> In_R1.fastq
zcat In2a_SD7441_S43_R2.fastq.gz >> In_R2.fastq
#In2
zcat In2_SD7440_S42_R1.fastq.gz >> In_R1.fastq
zcat In2_SD7440_S42_R2.fastq.gz >> In_R2.fastq
#In4
zcat In4_SD7416_S18_R1.fastq.gz >> In_R1.fastq
zcat In4_SD7416_S18_R2.fastq.gz >> In_R2.fastq
#In6
zcat In6_SD7422_S24_R1.fastq.gz >> In_R1.fastq
zcat In6_SD7422_S24_R2.fastq.gz >> In_R2.fastq
#In8
zcat In8_SD7430_S32_R1.fastq.gz >> In_R1.fastq
zcat In8_SD7430_S32_R2.fastq.gz >> In_R2.fastq
#In9
zcat In9_SD7433_S35_R1.fastq.gz >> In_R1.fastq
zcat In9_SD7433_S35_R2.fastq.gz >> In_R2.fastq

grep '@' In_R1.fastq | wc -c
12573604583
grep '@' In_R2.fastq | wc -c
12573604583

gzip *.fastq


###Metabat###

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_metabat
load_samtools_1.9
module load bwa

cd /safs-data02/dennislab/Public/Belle/5soils/In/
mkdir 03_bam
# filter out anything less than 1500
cd /safs-data02/dennislab/Public/Belle/5soils/In/02_opera_output
load_seqtk
seqtk seq -L 1500 contigs.fasta > contigs.min1500.fasta
bwa index contigs.min1500.fasta
cd /safs-data02/dennislab/Public/Belle/5soils/In/01_reads/
## merge lane data and move In files to In folder on server
for i in `ls *_R1.fastq.gz`; do
  bwa mem -t "24" /safs-data02/dennislab/Public/Belle/5soils/In/02_opera_output/contigs.min1500.fasta ${i} ${i%R1.fastq.gz}R2.fastq.gz | samtools view -b -o /safs-data02/dennislab/Public/Belle/5soils/In/03_bam/${i%R1.fastq.gz}mapped.bam
  samtools sort /safs-data02/dennislab/Public/Belle/5soils/In/03_bam/${i%R1.fastq.gz}mapped.bam -o /safs-data02/dennislab/Public/Belle/5soils/In/03_bam/${i%R1.fastq.gz}sorted.bam
  rm /safs-data02/dennislab/Public/Belle/5soils/In/03_bam/${i%R1.fastq.gz}mapped.bam
done
jgi_summarize_bam_contig_depths --outputDepth /safs-data02/dennislab/Public/Belle/5soils/In/03_bam/In_contigs_depth.txt --pairedContigs /safs-data02/dennislab/Public/Belle/5soils/In/03_bam/In_contigs_paired.txt --minContigLength 1500 --minContigDepth 1 /safs-data02/dennislab/Public/Belle/5soils/In/03_bam/*sorted.bam
metabat2 --inFile /safs-data02/dennislab/Public/Belle/5soils/In/02_opera_output/contigs.min1500.fasta --outFile /safs-data02/dennislab/Public/Belle/5soils/In/04_bins/bin --abdFile /safs-data02/dennislab/Public/Belle/5soils/In/03_bam/In_contigs_depth.txt --minContig=1500
'

#fixes formatting when moving from windows to linux
tr -d '\r' <4_bwa_metabat.sh > tmp.sh
rm 4_bwa_metabat.sh
mv tmp.sh 4_bwa_metabat.sh
​
#runs job - run from spades folder
sbatch -c 10 --mem=200GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=In_metabat 4_bwa_metabat.sh
​
#follows running job, change "#######" to job id
tail -f slurm-#######.out

###CheckM###

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_checkm
cd /safs-data02/dennislab/Public/Belle/5soils/In/
mkdir 06_checkm/01_unpolished
checkm taxonomy_wf domain Bacteria -f 06_checkm/qa.tsv --tab_table -x fa --threads 10 04_bins/ 06_checkm/'

#fixes formatting when moving from windows to linux
tr -d '\r' <5_checkM.sh > tmp.sh
rm 5_checkM.sh
mv tmp.sh 5_checkM.sh
​
#runs job - run from spades folder
sbatch -c 10 --mem=200GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=In_checkM 5_checkM.sh

#follows running job, change "#######" to job id
tail -f slurm-#######.out

#Just realised I ran metabat without the files for each samples in the folder. Will no run again with the individual samples in the folder

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_metabat
load_samtools_1.9
module load bwa

cd /safs-data02/dennislab/Public/Belle/5soils/In/
mkdir 03_bam
# filter out anything less than 1500
cd /safs-data02/dennislab/Public/Belle/5soils/In/02_opera_output
load_seqtk
seqtk seq -L 1500 contigs.fasta > contigs.min1500.fasta
bwa index contigs.min1500.fasta
cd /safs-data02/dennislab/Public/Belle/5soils/In/01_reads/
## merge lane data and move In files to In folder on server
for i in `ls *_R1.fastq.gz`; do
  bwa mem -t "24" /safs-data02/dennislab/Public/Belle/5soils/In/02_opera_output/contigs.min1500.fasta ${i} ${i%R1.fastq.gz}R2.fastq.gz | samtools view -b -o /safs-data02/dennislab/Public/Belle/5soils/In/03_bam/${i%R1.fastq.gz}mapped.bam
  samtools sort /safs-data02/dennislab/Public/Belle/5soils/In/03_bam/${i%R1.fastq.gz}mapped.bam -o /safs-data02/dennislab/Public/Belle/5soils/In/03_bam/${i%R1.fastq.gz}sorted.bam
  rm /safs-data02/dennislab/Public/Belle/5soils/In/03_bam/${i%R1.fastq.gz}mapped.bam
done
jgi_summarize_bam_contig_depths --outputDepth /safs-data02/dennislab/Public/Belle/5soils/In/03_bam/In_contigs_depth.txt --pairedContigs /safs-data02/dennislab/Public/Belle/5soils/In/03_bam/In_contigs_paired.txt --minContigLength 1500 --minContigDepth 1 /safs-data02/dennislab/Public/Belle/5soils/In/03_bam/*sorted.bam
metabat2 --inFile /safs-data02/dennislab/Public/Belle/5soils/In/02_opera_output/contigs.min1500.fasta --outFile /safs-data02/dennislab/Public/Belle/5soils/In/04_bins/bin --abdFile /safs-data02/dennislab/Public/Belle/5soils/In/03_bam/In_contigs_depth.txt --minContig=1500
'

#fixes formatting when moving from windows to linux
tr -d '\r' <4_bwa_metabat.sh > tmp.sh
rm 4_bwa_metabat.sh
mv tmp.sh 4_bwa_metabat.sh
​
#runs job - run from spades folder
sbatch -c 10 --mem=200GB --partition=safs --time=365-0:00:00 --no-kill --job-name=In_metabat 4_bwa_metabat.sh

#Run checkm again
'#!/usr/bTu/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_checkm
cd /safs-data02/dennislab/Public/Belle/5soils/In/
mkdir 06_checkm/01_unpolished
checkm taxonomy_wf domaTu Bacteria -f 06_checkm/qa.tsv --tab_table -x fa --threads 10 04_bins/ 06_checkm/01_unpolished'

tr -d '\r' <5_checkM.sh > tmp.sh
rm 5_checkM.sh
mv tmp.sh 5_checkM.sh
​
#runs job - run from spades folder
sbatch -c 10 --mem=200GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=In_checkM 5_checkM.sh

#follows running job, change "#######" to job id
tail -f slurm-#####.out

###pilon polishing###

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

## SAM tools index and subset BAM by bin then pilon polish bins ##

load_opera_ms
load_samtools_1.9
cd /safs-data02/dennislab/Public/Belle/5soils/In/04_bins/
mkdir polished_assembly
#touch good_bins.tsv #qual >60
#touch okay_bins.tsv #>45 complete <15 contam
cd /safs-data02/dennislab/Public/Belle/5soils/In/03_bam

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
  java -Xmx200G -jar /safs-data02/dennislab/sw/opera-ms/OPERA-MS//tools_opera_ms//pilon.jar --fix bases --threads 48 --genome /safs-data02/dennislab/Public/Belle/5soils/In/04_bins/${j}.fa --bam /safs-data02/dennislab/Public/Belle/5soils/In/03_bam/sorted.bin.bam --outdir /safs-data02/dennislab/Public/Belle/5soils/In/04_bins/polished_assembly/ > /safs-data02/dennislab/Public/Belle/5soils/In/04_bins/polished_assembly/pilon.${j}.out 2> /safs-data02/dennislab/Public/Belle/5soils/In/04_bins/polished_assembly/pilon.${j}.err
  mv ../04_bins/polished_assembly/pilon.fasta ../04_bins/polished_assembly/${j}.pilon.fa
  rm sorted.bin*
done'

tr -d '\r' <6_subset_bam_run_pilon.sh > tmp.sh
rm 6_subset_bam_run_pilon.sh
mv tmp.sh 6_subset_bam_run_pilon.sh
​
#runs job - run from spades folder
sbatch -c 48 --mem=1450GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=In_pilon 6_subset_bam_run_pilon.sh

#follows running job, change "#######" to job id
tail -f slurm-#####.out

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_checkm
cd /safs-data02/dennislab/Public/Belle/5soils/In/
#mkdir 06_checkm
mkdir 06_checkm/02_polished
checkm taxonomy_wf domain Bacteria -f 06_checkm/02_polished/qa.tsv --tab_table -x fa --threads 10 04_bins/polished_assembly/ 06_checkm/02_polished'

tr -d '\r' <5_checkM.sh > tmp.sh
rm 5_checkM.sh
mv tmp.sh 5_checkM.sh
​
#runs job - run from spades folder
sbatch -c 10 --mem=200GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=In_checkM 5_checkM.sh

#follows running job, change "#######" to job id
tail -f slurm-10245927.out

$GTDBtk

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_gtdbtk

cd /safs-data02/dennislab/Public/Belle/5soils/In/
mkdir 07_gtdbtk

gtdbtk classify_wf --genome_dir 04_bins/polished_assembly/ --out_dir 07_gtdbtk/ -x fa  --cpus 20'

tr -d '\r' <8_GTDB-tk.sh > tmp.sh
rm 8_GTDB-tk.sh
mv tmp.sh 8_GTDB-tk.sh
​
#runs job - run from spades folder
sbatch -c 20 --mem=230GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=In_GTDB-tk 8_GTDB-tk.sh
sbatch -c 20 --mem=300GB --partition=safs --time=365-0:00:00 --no-kill --job-name=In_GTDB-tk 8_GTDB-tk.sh

#follows running job, change "#######" to job id
tail -f slurm-10248174.out
tail -f slurm-10252424.out #rerun with 300GB mem
tail -f slurm-10253723.out #rerun with 500GB mem
tail -f slurm-10255508.out #rerun with 800GB mem

## trying forloop ##

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_gtdbtk

cd /safs-data02/dennislab/Public/Belle/5soils/In/
mkdir 07_gtdbtk
cd /safs-data02/dennislab/Public/Belle/5soils/In/04_bins/polished_assembly/

for i in `ls *.tsv`; do
  mkdir /safs-data02/dennislab/Public/Belle/5soils/In/07_gtdbtk/${i%.tsv}
  gtdbtk classify_wf --batchfile ${i} --out_dir /safs-data02/dennislab/Public/Belle/5soils/In/07_gtdbtk/${i%.tsv} -x fa  --cpus 20
done
'

tr -d '\r' <8.1_GTDBtk_forloop.sh > tmp.sh
rm 8.1_GTDBtk_forloop.sh
mv tmp.sh 8.1_GTDBtk_forloop.sh
​
#runs job - run from spades folder
sbatch -c 20 --mem=400GB --partition=safs --time=365-0:00:00 --no-kill --job-name=In_GTDB-tk 8.1_GTDBtk_forloop.sh
sbatch -c 1 --mem=400GB --partition=safs --time=365-0:00:00 --no-kill --job-name=In_GTDB-tk 8.1_GTDBtk_forloop.sh

#follows running job, change "#######" to job id
tail -f slurm-10267913.out
tail -f slurm-10270154.out #rerun with 800mem
tail -f slurm-10271938.out #rerun with 1 cpu, 400GB


$dRep

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

load_drep

#move to working directory
cd /safs-data02/dennislab/Public/Belle/5soils/In
mkdir 08_drep/

#dereplicate genomes
dRep dereplicate 08_drep/ -g 04_bins/polished_assembly/*.pilon.fa

#drep will choose the best version of identical genomes based on checkm
#completeness, contamination, and heterogeneity. You should manually curate this
#final list, chosing representative genomes based on the following criteria:
#1. isolate genomes are always prefered if checkm scores are similar
#2. single sample assemblies are prefered over co-assemblies

#move the final set of dereplicated bins to a final bins genome_directory
#mv drep/dereplicated_genomes/ mags/'

#fixes formatting when moving from windows to linux
tr -d '\r' <9_drep.sh > tmp.sh
rm 9_drep.sh
mv tmp.sh 9_drep.sh
​
#runs job - run from spades folder
sbatch -c 10 --mem=300GB --partition=safs --time=365-0:00:00 --no-kill --job-name=In_drep 9_drep.sh

tail -f slurm-10248580.out




$CCMetagen

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

load_ccmetagen

cd /safs-data02/dennislab/Public/Belle/5soils/In
#run kma first
kma -ipe 01_reads/In_R1.fastq.gz 01_reads/In_R2.fastq.gz -o 05_Krona/sample_out_kma -t_db /safs-data02/dennislab/db/ccmetagen/ncbi_nt_kma_jan_2018/ncbi_nt -t 15 -1t1 -mem_mode -and -apm f

#once the KMA is done you can run ccmetagen
#CCMetagen.py -i 05_Krona/sample_out_kma.res -o 05_Krona/

#should now have a Krona file'

tr -d '\r' <10_Krona.sh > tmp.sh
rm 10_Krona.sh
mv tmp.sh 10_Krona.sh
​
sbatch -c 15 --mem=200GB --partition=safs --time=365-0:00:00 --no-kill --job-name=In_ccmetagen 10_Krona.sh

tail -f slurm-10248229.out #incorrect db
tail -f slurm-10248244.out #rerun (correct db in script above)

#need internet access to run CCMetagen.py so do this in a screen or bash in the terminal itself. can't run on computer node
#Best to run in the same directory as files

cd /safs-data02/dennislab/Public/Belle/5soils/In/05_Krona
#once the KMA is don't you can run ccmetagen
CCMetagen.py -i sample_out_kma.res -o results
#should now have a Krona file
