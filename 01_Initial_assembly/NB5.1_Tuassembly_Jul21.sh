grep '@' Tu_R1.fastq | wc -c
14219291920
grep '@' Tu_R2.fastq | wc -c
14219291920

$hybrid_assembly
"#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
#before you do the hybrid assembly make sure you sort you long read and short read samples into the same folder
## opera hybrid assembly ##
load_opera_ms
cd /safs-data02/dennislab/Public/Belle/5soils/Tu/
OPERA-MS.pl --long-read-mapper blasr --short-read1 01_reads/Tu_R1.fastq.gz --short-read2 01_reads/Tu_R2.fastq.gz --long-read 01_reads/Tu.pass.fastq --out-dir 02_opera_output/ --num-processors 48

#this file has been rewritten for each soil, look in the relevant soil folder for the script"

#The above script was running using the following
tr -d '\r' <3_hybrid_assembly.sh > tmp.sh
rm 3_hybrid_assembly.sh
mv tmp.sh 3_hybrid_assembly.sh
#runs job - run from spades folder
sbatch -c 48 --mem=1450GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Tu_assembly 3_hybrid_assembly.sh
#follows running job, change "#######" to job id
tail -f slurm-#######.out

$Binning

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_metabat
load_samtools_1.9
module load bwa

cd /safs-data02/dennislab/Public/Belle/5soils/Tu/
mkdir 03_bam
# filter out anything less than 1500
cd /safs-data02/dennislab/Public/Belle/5soils/Tu/02_opera_output
load_seqtk
seqtk seq -L 1500 contigs.fasta > contigs.min1500.fasta
bwa index contigs.min1500.fasta
cd /safs-data02/dennislab/Public/Belle/5soils/Tu/01_reads/
## merge lane data and move Tu files to Tu folder on server
for i in `ls *_R1.fastq.gz`; do
  bwa mem -t "24" /safs-data02/dennislab/Public/Belle/5soils/Tu/02_opera_output/contigs.min1500.fasta ${i} ${i%R1.fastq.gz}R2.fastq.gz | samtools view -b -o /safs-data02/dennislab/Public/Belle/5soils/Tu/03_bam/${i%R1.fastq.gz}mapped.bam
  samtools sort /safs-data02/dennislab/Public/Belle/5soils/Tu/03_bam/${i%R1.fastq.gz}mapped.bam -o /safs-data02/dennislab/Public/Belle/5soils/Tu/03_bam/${i%R1.fastq.gz}sorted.bam
  rm /safs-data02/dennislab/Public/Belle/5soils/Tu/03_bam/${i%R1.fastq.gz}mapped.bam
done
jgi_summarize_bam_contig_depths --outputDepth /safs-data02/dennislab/Public/Belle/5soils/Tu/03_bam/Tu_contigs_depth.txt --pairedContigs /safs-data02/dennislab/Public/Belle/5soils/Tu/03_bam/Tu_contigs_paired.txt --minContigLength 1500 --minContigDepth 1 /safs-data02/dennislab/Public/Belle/5soils/Tu/03_bam/*sorted.bam
metabat2 --inFile /safs-data02/dennislab/Public/Belle/5soils/Tu/02_opera_output/contigs.min1500.fasta --outFile /safs-data02/dennislab/Public/Belle/5soils/Tu/04_bins/bin --abdFile /safs-data02/dennislab/Public/Belle/5soils/Tu/03_bam/Tu_contigs_depth.txt --minContig=1500
'

#fixes formatting when moving from windows to linux
tr -d '\r' <4_bwa_metabat.sh > tmp.sh
rm 4_bwa_metabat.sh
mv tmp.sh 4_bwa_metabat.sh
​
#runs job - run from spades folder
sbatch -c 10 --mem=200GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Tu_metabat 4_bwa_metabat.sh
​
#follows running job, change "#######" to job id
tail -f slurm-#######.out


$CheckM_and_Pilon_polishing

'#!/usr/bTu/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_checkm
cd /safs-data02/dennislab/Public/Belle/5soils/Tu/
mkdir 06_checkm/01_unpolished
checkm taxonomy_wf domaTu Bacteria -f 06_checkm/qa.tsv --tab_table -x fa --threads 10 04_bins/ 06_checkm/01_unpolished
'

#fixes formatting when moving from windows to linux
tr -d '\r' <5_checkM.sh > tmp.sh
rm 5_checkM.sh
mv tmp.sh 5_checkM.sh
​
#runs job - run from spades folder
sbatch -c 10 --mem=200GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Tu_checkM 5_checkM.sh

#follows running job, change "#######" to job id
tail -f slurm-10242729.out

#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

## SAM tools index and subset BAM by bin then pilon polish bins ##

'load_opera_ms
load_samtools_1.9
cd /safs-data02/dennislab/Public/Belle/5soils/Tu/04_bins/
mkdir polished_assembly
#touch good_bins.tsv #qual >60
#touch okay_bins.tsv #>45 complete <15 contam
cd /safs-data02/dennislab/Public/Belle/5soils/Tu/03_bam

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
  java -Xmx200G -jar /safs-data02/dennislab/sw/opera-ms/OPERA-MS//tools_opera_ms//pilon.jar --fix bases --threads 48 --genome /safs-data02/dennislab/Public/Belle/5soils/Tu/04_bins/${j}.fa --bam /safs-data02/dennislab/Public/Belle/5soils/Tu/03_bam/sorted.bin.bam --outdir /safs-data02/dennislab/Public/Belle/5soils/Tu/04_bins/polished_assembly/ > /safs-data02/dennislab/Public/Belle/5soils/Tu/04_bins/polished_assembly/pilon.${j}.out 2> /safs-data02/dennislab/Public/Belle/5soils/Tu/04_bins/polished_assembly/pilon.${j}.err
  mv ../04_bins/polished_assembly/pilon.fasta ../04_bins/polished_assembly/${j}.pilon.fa
  rm sorted.bin*
done'

tr -d '\r' <6_subset_bam_run_pilon.sh > tmp.sh
rm 6_subset_bam_run_pilon.sh
mv tmp.sh 6_subset_bam_run_pilon.sh
​
#runs job - run from spades folder
sbatch -c 48 --mem=1450GB --partition=safs --time=365-0:00:00 --no-kill --job-name=Tu_pilon 6_subset_bam_run_pilon.sh

#follows running job, change "#######" to job id
tail -f slurm-10244262.out

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_checkm
cd /safs-data02/dennislab/Public/Belle/5soils/Tu/
mkdir 06_checkm/02_polished
checkm taxonomy_wf domain Bacteria -f 06_checkm/02_polished/qa.tsv --tab_table -x fa --threads 10 04_bins/polished_assembly/  06_checkm/02_polished
~'

#fixes formatting when moving from windows to linux
tr -d '\r' <5_checkM.sh > tmp.sh
rm 5_checkM.sh
mv tmp.sh 5_checkM.sh
​
#runs job - run from spades folder
sbatch -c 10 --mem=200GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Tu_checkM 5_checkM.sh

#follows running job, change "#######" to job id
tail -f slurm-10247867.out

$GTDBtk

'usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_gtdbtk

cd /safs-data02/dennislab/Public/Belle/5soils/Tu/
mkdir 07_gtdbtk

gtdbtk classify_wf --genome_dir 04_bins/polished_assembly/ --out_dir 07_gtdbtk/ -x fa  --cpus 20'

#fixes formatting when moving from windows to linux
tr -d '\r' <8_GTDB-tk.sh > tmp.sh
rm 8_GTDB-tk.sh
mv tmp.sh 8_GTDB-tk.sh
​
#runs job
sbatch -c 20 --mem=230GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Tu_GTDB-tk 8_GTDB-tk.sh
#rerun as it was running out of cpus
sbatch -c 30 --mem=400GB --partition=safs --time=365-0:00:00 --no-kill --job-name=Tu_GTDB-tk 8_GTDB-tk.sh
#rerun again as that didn't work? Double checked script
sbatch -c 20 --mem=300GB --partition=safs --time=365-0:00:00 --no-kill --job-name=Tu_GTDB-tk 8_GTDB-tk.sh

#follows running job, change "#######" to job id
tail -f slurm-10248215.out
tail -f slurm-10252114.out
tail -f slurm-10252422.out
tail -f slurm-10253622.out #rerun with 500GB mem

##not working due to pplacer making it look like it's using more cpus than it is. Use 1 cpu

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_gtdbtk

cd /safs-data02/dennislab/Public/Belle/5soils/Tu/
mkdir 07_gtdbtk
cd /safs-data02/dennislab/Public/Belle/5soils/Tu/04_bins/polished_assembly/

for i in `ls *.tsv`; do
  mkdir /safs-data02/dennislab/Public/Belle/5soils/Tu/07_gtdbtk/${i%.tsv}
  gtdbtk classify_wf --batchfile ${i} --out_dir /safs-data02/dennislab/Public/Belle/5soils/Tu/07_gtdbtk/${i%.tsv} -x fa  --cpus 1
done
'

sbatch -c 1 --mem=300GB --partition=safs --time=365-0:00:00 --no-kill --job-name=Tu_GTDB-tk 8.1_GTDBtk_forloop.sh
tail -f slurm-10280955.out

$Drep

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

load_drep

#move to working directory
cd /safs-data02/dennislab/Public/Belle/5soils/Tu
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
sbatch -c 10 --mem=300GB --partition=safs --time=365-0:00:00 --no-kill --job-name=Tu_drep 9_drep.sh

tail -f slurm-10248579.out

## CheckM on drep bins ##

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_checkm
cd /safs-data02/dennislab/Public/Belle/5soils/Tu/
mkdir 06_checkm/03_drep
checkm taxonomy_wf domain Bacteria -f 06_checkm/03_drep/qa.tsv --tab_table -x fa --threads 10 08_drep/dereplicated_genomes 06_checkm/03_drep'

sbatch -c 10 --mem=200GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=Tu_checkM 5_checkM.sh
tail -f slurm-10252077.out

$CCMetagen

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

load_ccmetagen

cd /safs-data02/dennislab/Public/Belle/5soils/Tu
#run kma first
kma -ipe 01_reads/Tu_R1.fastq.gz 01_reads/Tu_R2.fastq.gz -o 05_Krona/sample_out_kma -t_db /safs-data02/dennislab/db/ccmetagen/ncbi_nt_kma_jan_2018/ncbi_nt -t 15 -1t1 -mem_mode -and -apm f'

tr -d '\r' <10_CCMetagen.sh > tmp.sh
rm 10_CCMetagen.sh
mv tmp.sh 10_CCMetagen.sh
​
sbatch -c 15 --mem=200GB --partition=safs --time=365-0:00:00 --no-kill --job-name=Tu_ccmetagen 10_CCMetagen.sh

tail -f slurm-10252217.out #incorrect db
10253847
