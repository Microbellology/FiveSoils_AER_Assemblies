#for each of the orders:
  #1. grab a list of genome ID's within that oder (in excel spread sheet)
  #2. in excel there are 3 worksheet, use 1st and 3rd worksheet
  #3. Once you have list of genomes form the 2 worksheets, go to the dir that
  #has all the genome sequences rob has set up this list
  #4. use genome IDs from list to pull out genome sequences
  #5. Put genome sequences into one large .fa file
  #6. use makeblastdb in blast software to create DB.


#to do before Thursday;
  #generate list of genome ID's for each order
  #send you 3 missing orders to Young
  #send through genome ID lists to Young
  #ask Paul if I want top X or top 1 from blast search

#on Thursday use script to make DB'#!/bin/sh
#run blast on the server - talk to Young

#assign taxon you want to look at
taxon=streptomyces

##Getting the genomes you want#

#Make a copy of the text file w%ith the list of ID'#!/bin/sh
cp ${taxon}.txt ${taxon}_cp.txt
vi ${taxon}_cp.txt
%s/RS_//g   #removes RS_ characters
%s/GB_//g #%s/ replace, A/B replace A with B, /g do for all %s/A/B/g
%s/_//g #remove underscore

# . means any characters. use a back slash to make  . = . not . = *
%s/\.\d\+$//g  ##removes .1 and .2. \d = didget, \+ = didget that occurs once or more, $ anything in the regugar expression happens at the end of the line
%s/.\{3}/&\//g #add / between every 3 didgets split the string by chunks of three characters and at the end of each segment, add '/' to it
# .\{3} for any 3 characters, & detects the instance of every 3 characters, precer / with \ to make it the literal meaning.
%s/^/\/safs-data02\/dennislab\/db\/gtdbtk\/r202\/fastani\/database\//g #^ mean begining of each line
esc :wq
#now we have copy and original
touch ${taxon}_full_path.txt
paste ${taxon}_cp.txt ${taxon}.txt > ${taxon}_full_path.txt

#now remove the tab between the two files
vi ${taxon}_full_path.txt
%s/\r//g # this gets rid of the ^M (not always present)
%s/\t//g # \t= tab
%s/RS_//g   #removes RS_ characters
%s/GB_//g #%s/ replace, A/B replace A with B, /g do for all %s/A/B/g
#now add file extension
%s/$/_genomic\.fna\.gz/g #$ end of line
esc :wq

## alternative to the paste option, that bipasses the editing lines above ##
for i in ` awk '{print $1}' ${taxon}_cp.txt`; do
  echo ${i}* >> ${taxon}_full_path.txt
done
# to do this the original file needs to be copied from notepad to a brand new vi txt file
# if you drag and drop the txt file from you rlocal drive to the server, the forloop wont work

# not all the genomic files are actually there, which is why the forloop is useful
# so now just remove the lines without genomic file
vi ${taxon}_full_path.txt
g/*/d # g stands for global, and d stands for delete. the pattern goes in the middle. So, globally, delete lines with the pattern *
:wq

#make prep dir
mkdir ${taxon}_prep
mv ${taxon}_full_path.txt ${taxon}_prep/
cd ${taxon}_prep

#may want to split file into chunks of 100 when 1000's of genomes are present
split -l 100 ${taxon}_full_path.txt
cd ../

#now we can run the script "copy_genomes.sh"
vi copy_genomes.sh
%s/whateverNameIsThere/ClassYouWantToLookAt/
esc :wq
#run script
bash copy_genomes.sh #genome folder is made here

##putting all the genomes into one fasta file##

#now you will have a folder with many fna each containing the whole gneome of that ID
cp -r ${taxon}/ ${taxon}_cp/

#make a file with all the fna file names
ls -lht ${taxon}/*.fna > fasta_list_${taxon}.txt
awk -F ' ' '{print $9}' fasta_list_${taxon}.txt > ${taxon}_fna_contig_list.txt #-F flag means its seperated by whatever is inbetween first set of quotations

vi ${taxon}_fna_contig_list.txt
%s/${taxon}\///g

#make another prep folder
mkdir ${taxon}_contig_prep
mv ${taxon}_fna_contig_list.txt ${taxon}_contig_prep/

streptomyces_contig_list

#split it
cd ${taxon}_contig_prep/
split -l 100 ${taxon}_fna_contig_list.txt

#run replace name script on server
sbatch -c 1 --mem=50GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=replacenames replace_seq_names.sh

taxon=o__Streptomycetales
#make one large fasta file of all the genoems
cd ${taxon}_cp/
touch ${taxon}_species_rep_genomes.fasta
cat *.fna > ${taxon}_species_rep_genomes.fasta

##Making the blast database##

#use this compiled fasta file to make blast database
load_blast_plus
makeblastdb -in ${taxon}_species_rep_genomes.fasta -input_type fasta -dbtype nucl -out ${taxon}_species_rep_blastdb

#run in sbatch
sbatch -c 10 --mem=100GB --partition=safs --priority=999999999 --time=365-0:00:00 --no-kill --job-name=blastDB make_blastDB.sh
