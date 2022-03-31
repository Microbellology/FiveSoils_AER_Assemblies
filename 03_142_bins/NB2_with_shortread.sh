#This is a running notebook, this is not a script, but it does contain details of all the scripts used
#It is in cronological order of exactly what scripts were run and how
#I wrap scripts in quote marks to make them stand out more '<script>' (in atom they appear green)
#I start titles with $ to make them stand ot more (in atom they appear red)
#comments start with #
#subtitles look like this ## subtile ##
#dates (dd.mm.yy) given are the dates jobs where submitted, not always when they ran/finished

#This is done on all genomes including the short read only assemblies

#all bins with just the short read assemblies were moved into the all bins folder using the below comand
SOIL=Tu

ls
for i in `ls *fa`; do
  mv ${i} ${SOIL}_${i%.fa}_shortread.fa
done
ls
cp *fa /safs-data01/uqbclar8/all/
ls /safs-data01/uqbclar8/all/*shortread.fa

$All_bins
#after the addition of the shortread bins as well, there were 731 bins before dRep

## checkM ##

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#set up some easy automation
#SOIL=Li

#load required modules
load_checkm

#set up working directory in scratch
cd /safs-data01/uqbclar8/
#mkdir ${SOIL}/
mkdir short_read_included/03_checkm

#go to input file location
#cd /safs-data02/dennislab/Public/belle/5soils/${SOIL}/03_spades_assembly/03_bins/

#copy your program input files to the scratch directory
#cp -r polished_assembly/ /safs-data01/uqbclar8/${SOIL}/

#go to the scratch directory
#cd /safs-data01/uqbclar8/${SOIL}/
#mkdir output

#run program
checkm taxonomy_wf domain Bacteria -f short_read_included/03_checkm/all_with_shortread_bins.tsv --tab_table -x fa --threads 10 all/ short_read_included/03_checkm/
'

sbatch -c 10 --mem=100GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=checkM_all 4_checkM.sh
Submitted batch job 11757609

## gtdbtk ##
'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#load required modules
load_gtdbtk

#set up working directory in scratch
cd /safs-data01/uqbclar8/short_read_included/
#mkdir 02c_gtdbtk_no_qc

#run program
gtdbtk classify_wf --genome_dir all/ --out_dir short_read_included/02_gtdb_all/ -x fa --cpus 1
#mem start at 300 and go up from there. This was 300+ genomes. so started at 500

#copy results over
#cp -r gtdbtk/ /safs-data02/dennislab/Public/belle/5soils/final_bins/'

sbatch -c 1 --mem=800GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=gtdbtk_all 3a_gtdbtk.sh
Submitted batch job 11746935


$With_dReps_inbuilt_checkM_QC_function

## dRep ##
'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

load_drep

#move to working directory
cd /safs-data01/uqbclar8/
mkdir short_read_included
mkdir short_read_included/01_dRep

#dereplicate genomes
dRep dereplicate short_read_included/01_dRep/ -g all/*.fa
#mem 100, cpu 10'

sbatch -c 10 --mem=100GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=drep 2a_dRep.sh
Submitted batch job 11743932

#exceeded job memory limit

sbatch -c 10 --mem=300GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=dRep 2a_dRep.sh
Submitted batch job 11757632

## gtdbtk ##
'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#load required modules
load_gtdbtk

#set up working directory in scratch
cd /safs-data01/uqbclar8/short_read_included/
mkdir 02b_gtdbtk

#run program
gtdbtk classify_wf --genome_dir 01a_dRep/dereplicated_genomes/ --out_dir 02b_gtdbtk/ -x fa  --cpus 1
#mem start at 300 and go up from there.

#copy results over
#cp -r gtdbtk/ /safs-data02/dennislab/Public/belle/5soils/final_bins/
'

sbatch -c 1 --mem=300GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=gtdbtk 3a_gtdbtk.sh
Submitted batch job 11762042

#ran out of memory

sbatch -c 1 --mem=500GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=gtdbtk 3a_gtdbtk.sh
Submitted batch job 11763691

## checkM ##
'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#set up some easy automation
#SOIL=Li

#load required modules
load_checkm

#set up working directory in scratch
cd /safs-data01/uqbclar8/
#mkdir ${SOIL}/
mkdir short_read_included/03b_checkm_dRep

#go to input file location
#cd /safs-data02/dennislab/Public/belle/5soils/${SOIL}/03_spades_assembly/03_bins/

#copy your program input files to the scratch directory
#cp -r polished_assembly/ /safs-data01/uqbclar8/${SOIL}/

#go to the scratch directory
#cd /safs-data01/uqbclar8/${SOIL}/
#mkdir output

#run program
checkm taxonomy_wf domain Bacteria -f short_read_included/03b_checkm_dRep/dRep_bins.tsv --tab_table -x fa --threads 10 short_read_included/01a_dRep/dereplicated_genomes/ short_read_included/03b_checkm_dRep/

#copy over relevant files
#cp checkm/final_bins.tsv /safs-data02/dennislab/Public/belle/5soils/final_bins/

#clear scratch
#cd ..
#rm -r ${SOIL}/'

sbatch -c 10 --mem=100GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=checkM 4_checkM.sh
Submitted batch job 11761892

# wrong file path provided, correct file path shown above

sbatch -c 10 --mem=100GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=checkM 4_checkM.sh
Submitted batch job 11762043

$Without_dReps_inbuilt_checkM_QC_function
'## dRep ##
#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

load_drep

#move to working directory
cd /safs-data01/uqbclar8/
#mkdir short_read_included
mkdir short_read_included/02_dRep_no_qc

#dereplicate genomes
dRep dereplicate short_read_included/02_dRep_no_qc -g all/*.fa --ignoreGenomeQuality
#mem 100, cpu 10'

#the --ignoreGenomeQuality flag stops dRep from using checkM (usually not recommended)
#without this flag drep will choose the best version of identical genomes based on checkm
#completeness, contamination, and heterogeneity. You should manually curate this
#final list, chosing representative genomes based on the following criteria:
#1. isolate genomes are always prefered if checkm scores are similar
#2. single sample assemblies are prefered over co-assemblies

#move the final set of dereplicated bins to a final bins genome_directory
#mv drep/dereplicated_genomes/ mags/

sbatch -c 10 --mem=100GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=drep_no_qc 2b_dRep_no_qc.sh
Submitted batch job 11743965

## gtdbtk ##

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#load required modules
load_gtdbtk

#set up working directory in scratch
cd /safs-data01/uqbclar8/short_read_included/
mkdir 02c_gtdbtk_no_qc

#run program
gtdbtk classify_wf --genome_dir 01b_dRep_no_qc/dereplicated_genomes/ --out_dir 02c_gtdbtk_no_qc/ -x fa  --cpus 1
#mem start at 300 and go up from there. This was 300+ genomes. so started at 500

#copy results over
#cp -r gtdbtk/ /safs-data02/dennislab/Public/belle/5soils/final_bins/
'
sbatch -c 1 --mem=600GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=gtdb_noQC 3a_gtdbtk.sh
Submitted batch job 11757629

## checkM ##
'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#set up some easy automation
#SOIL=Li

#load required modules
load_checkm

#set up working directory in scratch
cd /safs-data01/uqbclar8/
#mkdir ${SOIL}/
mkdir short_read_included/03c_checkm_no_qc

#go to input file location
#cd /safs-data02/dennislab/Public/belle/5soils/${SOIL}/03_spades_assembly/03_bins/

#copy your program input files to the scratch directory
#cp -r polished_assembly/ /safs-data01/uqbclar8/${SOIL}/

#go to the scratch directory
#cd /safs-data01/uqbclar8/${SOIL}/
#mkdir output

#run program
checkm taxonomy_wf domain Bacteria -f short_read_included/03c_checkm_no_qc/dRep_bins.tsv --tab_table -x fa --threads 10 short_read_included/01b_dRep_no_qc/dereplicated_genomes/ short_read_included/03c_checkm_no_qc/'

sbatch -c 10 --mem=100GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=checkM 4_checkM.sh
Submitted batch job 11763511

$Coverage_profile

## Mapping reads to each sample ##
#use cleaned reads here to avoid any confusion wiht Musa reads
#did it in two parts, first make the mega mag and count the reads from each sample that map to the megamag
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
done

#4cpu 200mem'

sbatch -c 4 --mem=200GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=megamag reads_to_megamag.sh
Submitted batch job 11783391

#then map each read to each sample
#use the same reads that were used in coverM
