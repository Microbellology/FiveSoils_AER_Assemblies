#check that the concat worked
cd /rdm/Q0775-uqbclar8/belle/01_core/01_5soils_AER/02_novaseq/Li/

zcat Li_R1.fastq.gz | grep '@' | wc -c
17515161613
zcat Li_R2.fastq.gz | grep '@' | wc -c
17594296343

rm Li_R1.fastq.gz
rm Li_R2.fastq.gz
touch Li_R1.fastq
touch Li_R2.fastq

#Checking individual samples
zcat Li10a_SD7442_S44_R1.fastq.gz | grep '@' | wc -c
1666781628
zcat Li10a_SD7442_S44_R2.fastq.gz | grep '@' | wc -c
1666781628

zcat Li2_SD7409_S11_R1.fastq.gz | grep '@' | wc -c
2953978329
zcat Li2_SD7409_S11_R2.fastq.gz | grep '@' | wc -c
2953978329

zcat Li3_SD7412_S14_R1.fastq.gz | grep '@' | wc -c
2832235531 # reads don't matchs, needs to be re concated
zcat Li3_SD7412_S14_R2.fastq.gz | grep '@' | wc -c
2794339473

zcat Li4_SD7417_S19_R1.fastq.gz | grep '@' | wc -c
1587038456
zcat Li4_SD7417_S19_R2.fastq.gz | grep '@' | wc -c
1587038456

zcat Li6_SD7423_S25_R1.fastq.gz | grep '@' | wc -c
1243442698
zcat Li6_SD7423_S25_R2.fastq.gz | grep '@' | wc -c
1243442698

zcat Li7_SD7426_S28_R1.fastq.gz | grep '@' | wc -c
2184055097
zcat Li7_SD7426_S28_R2.fastq.gz | grep '@' | wc -c
2184055097

zcat Li8_SD7431_S33_R1.fastq.gz | grep '@' | wc -c
3283093405
zcat Li8_SD7431_S33_R2.fastq.gz | grep '@' | wc -c
3283093405

zcat Li9_SD7434_S36_R1.fastq.gz | grep '@' | wc -c
1854566727
zcat Li9_SD7434_S36_R2.fastq.gz | grep '@' | wc -c
1854566727

rm Li3_SD7412_S14_R1.fastq.gz
rm Li3_SD7412_S14_R2.fastq.gz
touch Li3_SD7412_S14_R1.fastq
touch Li3_SD7412_S14_R2.fastq

cd /rdm/Q0775-uqbclar8/belle/01_core/01_5soils_AER/02_novaseq/
#Li3
zcat 0_raw_data/SD7412_S14_L003_R1_001.fastq.gz >> Li/Li3_SD7412_S14_R1.fastq
zcat 0_raw_data/SD7412_S14_L003_R2_001.fastq.gz >> Li/Li3_SD7412_S14_R2.fastq
zcat 0_raw_data/SD7412_S14_L004_R1_001.fastq.gz >> Li/Li3_SD7412_S14_R1.fastq
zcat 0_raw_data/SD7412_S14_L004_R2_001.fastq.gz >> Li/Li3_SD7412_S14_R2.fastq

cd /rdm/Q0775-uqbclar8/belle/01_core/01_5soils_AER/02_novaseq/Li/

grep '@' Li3_SD7412_S14_R1.fastq | wc -c
2674861311
grep '@' Li3_SD7412_S14_R2.fastq | wc -c
2674861311

gzip Li3_SD7412_S14_R1.fastq Li3_SD7412_S14_R2.fastq

##Reconcating all samples into one fwd and rvs 03/08/21
cd /rdm/Q0775-uqbclar8/belle/01_core/01_5soils_AER/02_novaseq/Li/
#Li10a
zcat Li10a_SD7442_S44_R1.fastq.gz >> Li_R1.fastq
zcat Li10a_SD7442_S44_R2.fastq.gz >> Li_R2.fastq
#Li2
zcat Li2_SD7409_S11_R1.fastq.gz >> Li_R1.fastq
zcat Li2_SD7409_S11_R2.fastq.gz >> Li_R2.fastq
#Li3
zcat Li3_SD7412_S14_R1.fastq.gz >> Li_R1.fastq
zcat Li3_SD7412_S14_R2.fastq.gz >> Li_R2.fastq
#Li4
zcat Li4_SD7417_S19_R1.fastq.gz >> Li_R1.fastq
zcat Li4_SD7417_S19_R2.fastq.gz >> Li_R2.fastq
#Li6
zcat Li6_SD7423_S25_R1.fastq.gz >> Li_R1.fastq
zcat Li6_SD7423_S25_R2.fastq.gz >> Li_R2.fastq
#Li7
zcat Li7_SD7426_S28_R1.fastq.gz >> Li_R1.fastq
zcat Li7_SD7426_S28_R2.fastq.gz >> Li_R2.fastq
#Li8
zcat Li8_SD7431_S33_R1.fastq.gz >> Li_R1.fastq
zcat Li8_SD7431_S33_R2.fastq.gz >> Li_R2.fastq
#Li9
zcat Li9_SD7434_S36_R1.fastq.gz >> Li_R1.fastq
zcat Li9_SD7434_S36_R2.fastq.gz >> Li_R2.fastq

grep '@' Li_R1.fastq | wc -c
17447817651
grep '@' Li_R2.fastq | wc -c
17447817651

gzip *.fastq

###Opera###

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
#before you do the hybrid assembly make sure you sort you long read and short read samples into the same folder
## opera hybrid assembly ##
load_opera_ms
cd /safs-data02/dennislab/Public/Belle/5soils/Li/
OPERA-MS.pl --long-read-mapper blasr --short-read1 01_reads/Li_R1.fastq.gz --short-read2 01_reads/Li_R2.fastq.gz --long-read 01_reads/Li.pass.fastq --out-dir 02_opera_output/ --num-processors 48

#this file has been rewritten for each soil, look in the relevant soil folder for the script'

#fixes formatting when moving from windows to linux
tr -d '\r' <3_hybrid_assembly.sh> tmp.sh
rm 3_hybrid_assembly.sh
mv tmp.sh 3_hybrid_assembly.sh
#runs job - run from spades folder
sbatch -c 48 --mem=1450GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Li_assembly 3_hybrid_assembly.sh
#follows running job, change "#######" to job id
tail -f slurm-#######.out

###Metabat###

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_metabat
load_samtools_1.9
module load bwa

cd /safs-data02/dennislab/Public/Belle/5soils/Li/
mkdir 03_bam
# filter out anything less than 1500
cd /safs-data02/dennislab/Public/Belle/5soils/Li/02_opera_output
load_seqtk
seqtk seq -L 1500 contigs.fasta > contigs.min1500.fasta
bwa index contigs.min1500.fasta
cd /safs-data02/dennislab/Public/Belle/5soils/Li/01_reads/
## merge lane data and move Li files to Li folder on server
for i in `ls *_R1.fastq.gz`; do
  bwa mem -t "24" /safs-data02/dennislab/Public/Belle/5soils/Li/02_opera_output/contigs.min1500.fasta ${i} ${i%R1.fastq.gz}R2.fastq.gz | samtools view -b -o /safs-data02/dennislab/Public/Belle/5soils/Li/03_bam/${i%R1.fastq.gz}mapped.bam
  samtools sort /safs-data02/dennislab/Public/Belle/5soils/Li/03_bam/${i%R1.fastq.gz}mapped.bam -o /safs-data02/dennislab/Public/Belle/5soils/Li/03_bam/${i%R1.fastq.gz}sorted.bam
  rm /safs-data02/dennislab/Public/Belle/5soils/Li/03_bam/${i%R1.fastq.gz}mapped.bam
done
jgi_summarize_bam_contig_depths --outputDepth /safs-data02/dennislab/Public/Belle/5soils/Li/03_bam/Li_contigs_depth.txt --pairedContigs /safs-data02/dennislab/Public/Belle/5soils/Li/03_bam/Li_contigs_paired.txt --minContigLength 1500 --minContigDepth 1 /safs-data02/dennislab/Public/Belle/5soils/Li/03_bam/*sorted.bam
metabat2 --inFile /safs-data02/dennislab/Public/Belle/5soils/Li/02_opera_output/contigs.min1500.fasta --outFile /safs-data02/dennislab/Public/Belle/5soils/Li/04_bins/bin --abdFile /safs-data02/dennislab/Public/Belle/5soils/Li/03_bam/Li_contigs_depth.txt --minContig=1500
'

#fixes formatting when moving from windows to linux
tr -d '\r' <4_bwa_metabat.sh > tmp.sh
rm 4_bwa_metabat.sh
mv tmp.sh 4_bwa_metabat.sh
​
#runs job - run from spades folder
sbatch -c 10 --mem=200GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Li_metabat 4_bwa_metabat.sh
​
#follows running job, change "#######" to job id
tail -f slurm-10247860.out

### Polishing and checkm ###

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_checkm
cd /safs-data02/dennislab/Public/Belle/5soils/Li/
mkdir 06_checkm
mkdir 06_checkm/01_unpolished
checkm taxonomy_wf domain Bacteria -f 06_checkm/01_unpolished/qa.tsv --tab_table -x fa --threads 10 04_bins/ 06_checkm/01_unpolished'

r -d '\r' <5_checkM.sh > tmp.sh
rm 5_checkM.sh
mv tmp.sh 5_checkM.sh
​
#runs job - run from spades folder
sbatch -c 10 --mem=200GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Li_checkM 5_checkM.sh

#follows running job, change "#######" to job id
tail -f slurm-10252041.out

#make good_bins.tsv in vim using data from the qa file from checkm - >45% complete <15% contamination

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

## SAM tools index and subset BAM by bin then pilon polish bins ##

load_opera_ms
load_samtools_1.9
cd /safs-data02/dennislab/Public/Belle/5soils/Li/04_bins/ #directory where the .fa files from metabat are
mkdir polished_assembly
#touch good_bins.tsv #qual >60
#touch okay_bins.tsv #>45 complete <15 contam
cd /safs-data02/dennislab/Public/Belle/5soils/Li/03_bam #directory of sorted.bam files for each rep

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
  java -Xmx200G -jar /safs-data02/dennislab/sw/opera-ms/OPERA-MS//tools_opera_ms//pilon.jar --fix bases --threads 48 --genome /safs-data02/dennislab/Public/Belle/5soils/Li/04_bins/${j}.fa --bam /safs-data02/dennislab/Public/Belle/5soils/Li/03_bam/sorted.bin.bam --outdir /safs-data02/dennislab/Public/Belle/5soils/Li/04_bins/polished_assembly/ > /safs-data02/dennislab/Public/Belle/5soils/Li/04_bins/polished_assembly/pilon.${j}.out 2> /safs-data02/dennislab/Public/Belle/5soils/Li/04_bins/polished_assembly/pilon.${j}.err
  mv ../04_bins/polished_assembly/pilon.fasta ../04_bins/polished_assembly/${j}.pilon.fa
  rm sorted.bin*
done'

tr -d '\r' <6_subset_bam_run_pilon.sh > tmp.sh
rm 6_subset_bam_run_pilon.sh
mv tmp.sh 6_subset_bam_run_pilon.sh
​
#runs job - run from spades folder
sbatch -c 48 --mem=1450GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Li_pilon 6_subset_bam_run_pilon.sh

#follows running job, change "#######" to job id
tail -f slurm-10252236.out

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

load_checkm

cd /safs-data02/dennislab/Public/Belle/5soils/Li/
#mkdir 06_checkm
mkdir 06_checkm/02_polished

checkm taxonomy_wf domain Bacteria -f 06_checkm/02_polished/qa.tsv --tab_table -x fa --threads 10 04_bins/polished_assembly/ 06_checkm/02_polished
'

r -d '\r' <5_checkM.sh > tmp.sh
rm 5_checkM.sh
mv tmp.sh 5_checkM.sh
​
#runs job - run from spades folder
sbatch -c 10 --mem=200GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Li_checkM 5_checkM.sh

#follows running job, change "#######" to job id
tail -f slurm-10252449.out

$GTDBtk

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_gtdbtk

cd /safs-data02/dennislab/Public/Belle/5soils/Li/
mkdir 07_gtdbtk

gtdbtk classify_wf --genome_dir 04_bins/polished_assembly/ --out_dir 07_gtdbtk/ -x fa  --cpus 20'


sbatch -c 20 --mem=800GB --partition=safs --time=365-0:00:00 --no-kill --job-name=Li_GTDB-tk 8_GTDB-tk.sh
tail -f slurm-10255504.out


'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_gtdbtk

cd /safs-data02/dennislab/Public/Belle/5soils/Li/
mkdir 07_gtdbtk
cd /safs-data02/dennislab/Public/Belle/5soils/Li/04_bins/polished_assembly/

for i in `ls *.tsv`; do
  mkdir /safs-data02/dennislab/Public/Belle/5soils/Li/07_gtdbtk/${i%.tsv}
  gtdbtk classify_wf --batchfile ${i} --out_dir /safs-data02/dennislab/Public/Belle/5soils/Li/07_gtdbtk/${i%.tsv} -x fa  --cpus 1
done
'

sbatch -c 1 --mem=300GB --partition=safs --time=365-0:00:00 --no-kill --job-name=Li_GTDB-tk 8.1_GTDBtk_forloop.sh
tail -f slurm-10280723.out

$dRep

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

load_drep

#move to working directory
cd /safs-data02/dennislab/Public/Belle/5soils/Li
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

tail -f slurm-10253725.out




$CCMetagen

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

load_ccmetagen

cd /safs-data02/dennislab/Public/Belle/5soils/Li
#run kma first
kma -ipe 01_reads/Li_R1.fastq.gz 01_reads/Li_R2.fastq.gz -o 05_Krona/sample_out_kma -t_db /safs-data02/dennislab/db/ccmetagen/ncbi_nt_kma_jan_2018/ncbi_nt -t 15 -1t1 -mem_mode -and -apm f'

tr -d '\r' <10_CCMetagen.sh > tmp.sh
rm 10_CCMetagen.sh
mv tmp.sh 10_CCMetagen.sh
​
sbatch -c 15 --mem=200GB --partition=safs --time=365-0:00:00 --no-kill --job-name=Li_ccmetagen 10_CCMetagen.sh
sbatch -c 15 --mem=400GB --partition=safs --time=365-0:00:00 --no-kill --job-name=Li_ccmetagen 10_CCMetagen.sh

tail -f slurm-10252209.out #incorrect db
tail -f slurm-10253728.out #ran out of space on the server, rerunning with space
tail -f slurm-10255456.out #400GB run

#retry with 1 cpu. changed number of threads (-t) in the above script, to 1, not shown here
sbatch -c 1 --mem=400GB --partition=safs --time=365-0:00:00 --no-kill --job-name=Li_ccmetagen 10_CCMetagen.sh
tail -f slurm-10281107.out
