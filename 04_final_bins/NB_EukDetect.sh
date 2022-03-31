# This is a running notebook, this is not a script, but it does contain details of all the scripts/code used
# It is in cronological order of exactly what scripts were run and how
# I wrap scripts in quote marks to make them stand out more '<script>' (in atom they appear green)
# I start titles with $ to make them stand out more (in atom they appear red)
# notes start with #
# subtitles look like this ## subtile ##
# dates (dd.mm.yy) given are the dates jobs where submitted, not always when they ran/finished


$ EukDetect #30.03.2022

## Aim ##

# Here is am using the software EukDetect to see what eukaryote reads I may have

## Approach ##

# I am using my without_musa reads untrimmed because in the configfile, it states
# "pre-trimming reads not recommended" when giving read length. I am using musa
# free as I think this may affect the detection of other euk reads

# the defaut config file can be found at: /safs-data02/dennislab/sw/EukDetect/github_src/

# first edit the configfile
cd /safs-data02/dennislab/sw/EukDetect/github_src/
cp default_configfile.yml /path/to/working/directory/<project_name>_configfile.yml
vi <project_name>_configfile.yml

# adjust perameters as described
# To count your reads you can use Biosquid or this line of code
gzip -dc <file.fastq.gz> | head -n 10000 | awk '{ if (NR%4==2){count++; bases += length}} END{printf "%3.0f\n", bases/count}'

# I then listed my sampes as decribed in the configfile
# I generated a list of my samples using this:

for i in `ls *.gz`; do
  echo ${i} >> sample_list.tsv
done

# I used excel to sort between read 1's and 2's

#example configfile layout:

'#Directory where EukDetect output should be written
output_dir: "/safs-data01/uqbclar8/eukdetect/"

#Indicate whether reads are paired (true) or single (false)
paired_end: true

#filename excluding sample name. no need to edit if paired_end = false
fwd_suffix: "_R1.fq.gz"

#filename excludign sample name. no need to edit if paired_end = false
rev_suffix: "_R2.fq.gz"

#file name excluding sample name. no need to edit if paired_end = true
se_suffix: ".fastq.gz"

#length of your reads. pre-trimming reads not recommended
readlen: 120

#full path to directory with raw fastq files
fq_dir: "/safs-data01/uqbclar8/reads/without_musa_original"

#full path to folder with eukdetect database files (NOTE: No need to change - already set for SAFS server)
database_dir: "/safs-data02/dennislab/db/EukDetect/v7_20210121"

#name of database
database_prefix: "ncbi_eukprot_met_arch_markers.fna"

#full path to eukdetect installation folder (NOTE: No need to change - already set for SAFS server)
eukdetect_dir: "/safs-data02/dennislab/sw/EukDetect/github_src"

#list sample names here. fastqs must correspond to {samplename}{se_suffix} for SE reads or {samplename}{fwd_suffix} and {samplename}{rev_suffix} for PE
#each sample name should be preceded by 2 spaces and followed by a colon character
samples:
  SD7407_S9_L003_cleaned:
  SD7407_S9_L004_cleaned:
  SD7408_S10_L003_cleaned:
  SD7408_S10_L004_cleaned:
  SD7409_S11_L003_cleaned:
  SD7409_S11_L004_cleaned:
  SD7410_S12_L003_cleaned:
  SD7410_S12_L004_cleaned:
'
# Once the config file had been edited I ran the below line in a screen with
# 1 core and 5 mem.

eukdetect --mode runall --configfile core_microbiome_configfile2.yml --cores 1

#It is worth noting that once I got back to my computer the next
# day the screen was gone?? when typing in screen -r I go thte message:
# There is no screen to be resumed. even though I know I had 3 screens running
# nonetheless it seems to have run fully:

#log_output, last few lines
[Thu Mar 31 05:15:26 2022]
Finished job 0.
841 of 841 steps (100%) done
Complete log: /home/safs-data01/uqbclar8/eukdetect/.snakemake/log/2022-03-30T132854.956707.snakemake.log

## Conslusion ##

# most samples don't seem to have any Euk reads in them, a few samples did however
