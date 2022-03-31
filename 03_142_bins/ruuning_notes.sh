j=c__Alphaproteobacteria_species_rep_genomes.fasta

module load bwa
load_samtools_1.9

#make bwa db
bwa index ${j}

cp ${j}* /safs-data01/uqbclar8/reads/without_musa_original/
cd /safs-data01/uqbclar8/reads/without_musa_original/
mkdir mapped_to_${j%_species_rep_genomes.fasta}

#loop through each read pair and map it to the class
for i in `ls *R1.fq.gz`; do
  bwa mem -t 2 ${j} ${i} ${i%R1.fq.gz}R2.fq.gz > mapped_to_${j%_species_rep_genomes.fasta}/${i%_R1.fq.gz}.sam
  cd mapped_to_${j%_species_rep_genomes.fasta}
  #convert to bam and remove sam files to save space
  samtools view -bS ${i%_R1.fq.gz}.sam > ${i%_R1.fq.gz}.bam
  rm ${i%_R1.fq.gz}.sam
  #sorting by read name (keeping paired reads together) remove bam to save space
  samtools sort -n -m 50G -@ 2 ${i%_R1.fq.gz}.bam -o ${i%_R1.fq.gz}_sorted.bam
  rm ${i%_R1.fq.gz}.bam
  #extract unmapped reads and remove sorted bam
  samtools view -b -F 4 ${i%_R1.fq.gz}_sorted.bam > ${i%_R1.fq.gz}_mapped.bam
  rm ${i%_R1.fq.gz}_sorted.bam
  #sort again by read names and remove unmapped bam to save space
  samtools sort -n -m 50G -@ 24 ${i%_R1.fq.gz}_mapped.bam -o ${i%_R1.fq.gz}_mapped_sorted.bam
  rm ${i%_R1.fq.gz}_mapped.bam
  #extract unmapped sorted read into forard and reverse paired read fq files and once again, remove to save space
  samtools fastq -@ 2 ${i%_R1.fq.gz}_mapped_sorted.bam -1 ${i%_R1.fq.gz}_mapped_${j%_species_rep_genomes.fasta}_R1.fq.gz -2 ${i%_R1.fq.gz}_mapped_${j%_species_rep_genomes.fasta}_R2.fq.gz -0 /dev/null -s /dev/null -n
  samtools view ${i%_R1.fq.gz}_mapped_sorted.bam > ${i%_R1.fq.gz}_mapped_sorted.sam
  rm ${i%_R1.fq.gz}_mapped_sorted.bam
  cd ../
done

#might want to add a concat step?

#move final back to RDM
cp -r mapped_to_${j%_species_rep_genomes.fasta}/ /QRISdata/Q0775/belle/01_core/01_5soils_AER/Run_on_RCC/


for i in `ls *.fq.gz`; do
  gunzip ${i}
  seqtk seq -L 300 ${i} > ../trimmed/${i%.fq.gz}_trimmed.fa

  java -jar trimmomatic-0.30.jar PE In10a_SD7438_S40_R1.fastq.gz In10a_SD7438_S40_R2.fastq.gz ILLUMINACLIP:TruSeq3-PE-2.fa

  trimmomatic PE In10a_SD7438_S40_R1.fastq.gz rIn10a_SD7438_S40_R2.fastq.gz output_forward_paired.fq.gz output_forward_unpaired.fq.gz output_reverse_paired.fq.gz output_reverse_unpaired.fq.gz ILLUMINACLIP:NexteraPE-PE.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 MINLEN:36




list of matches = grep -v -e '@' SD7407_S9_L004_cleaned.sam | awk '$3 != "*" {print $1}' | uniq > my_list.txt
python /safs-data02/dennislab/Public/scripts/fastx_extract_by_id.py
input = read, keeper file = list of matches
run for both read 1 and 2


for i in 'ls *unpaired_1.fq.gz.fq.gz'; do
  mv ${i} ../trimmed_reads/${i%.fq.gz}
done
Belle_MAGS/Li_bin.58_shortread.fa
bwa mem -t 2 Belle_MAGS/Li_bin.58_shortread.fa Belle_reads/concat/Li_R1.fastq.gz Belle_reads/concat/Li_R2.fastq.gz > MAGs_to_isolates/Li_bin.58_shortread.sam
