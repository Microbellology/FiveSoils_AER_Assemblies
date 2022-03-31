## MinION data workflow ##
cp
​
##Update guppy from ONT guppy page
https://community.nanoporetech.com/downloads
# use linux 64-bit GPU version #copy link address and use wget
wget "https://mirror.oxfordnanoportal.com/software/analysis/ont-guppy_4.5.4_linux64.tar.gz"
​
#now install the updated guppy
tar -xf ont-guppy_4.5.4_linux64.tar.gz
mv ont-guppy/ ont-guppy_4.5.4/
#remove large tar.gz guppy file
rm ont-guppy_4.5.4_linux64.tar.gz
​
#move all fast5 files into same folder
#make sure they all have unique names
​
#move final fast5 folder to scratch
mkdir /scratch/sees/uqbclar8/
cd /afm01/Q0/Q0775/Kattie_Belle_MinION/
cp -r fast5/ /scratch/sees/uqbclar8/
mkdir belle_fast5/
cd ABC01/
cp */*/*.fast5 ../fast5/ #copies all fast5 files (passed, failed, unclassified)
cp -r fast5/ /scratch/sees/uqbclar8/
​
#move to guppy scripts
cd
cd ont-guppy_4.5.4/bin/
​
#find basecaller workflow
barc=EXP-NBD104 #barcoding kit
seqk=SQK-LSK109 #library prep kit
fcell=FLO-MIN106 #flow cell model number
​
./guppy_basecaller --print_workflows | grep ${fcell} | grep ${seqk}
#dna_r9.4.1_450bps_hac
​
##write bash script for basecalling
cd
vim call_fastq_core_soils.sh
#insert
#!/usr/bin/env bash
~/ont-guppy_4.5.4/bin/guppy_basecaller -i /scratch/sees/uqbclar8/belle_fast5/ -s fastq/ -c dna_r9.4.1_450bps_hac.cfg --device cuda:0 -q 0 --barcode_kits EXP-NBD104
#copy and paste one line at a time as windows has a different interpretation of end of line
​
sbatch -p gpu -c 1 --mem=40G --gres=gpu:1 -t 72:0:0 call_fastq_core_soils.sh
​
tail -f slurm-####.out
​
#when done, move to output directory and gzip pass and fail barcodes
​
cd /afm01/Q0/Q0775/Kattie_Belle_MinION/ABC01/
mkdir pass
mkdir fail

for i in `ls fastq_fail/`; do
 cat fastq_fail/${i}/*fastq | gzip > fail/${i}.fail.fastq.gz
done

for i in `ls fastq_pass/`; do
 cat fastq_pass/${i}/*fastq | gzip > pass/${i}.pass.fastq.gz
done
#delete original fastqs, delete log
rm -r fail/
rm -r pass/
rm *.log
​
#zip seq_summary, seq_telemetry, pass and fail into single directory
cd ../
tar -zcvf KW01.fastq.tar.gz fastq/
rm -r fastq/
​
#move into RDM then onto safs
cp KW01.fastq.tar.gz /afm01/Q0/Q0775/Kattie_Belle_MinION/
rm KW01.fastq.tar.gz
