for i in `ls *fasta`; do
  cat ${i} >> MAG_SSUs.fasta
done

module load blast
blastn -db SILVA_138.1_SSURef_NR99_tax_silva.fasta -query blast/MAG_SSUs.fasta -out blast/my_top_100.out -outfmt 6 -max_target_seqs 100 -num_threads 1

blastn -db SILVA_138.1_SSURef_NR99_tax_silva.fasta -query blast/Musa_candidate_core_bac_otus_47.fa -out blast/my_top_100.out -outfmt 6 -max_target_seqs 100 -num_threads 1


#the silva taxa file is too big for excel
#wrote a forloop to make a smaller file to use in excel
for i in `awk '{print $2}' my_top_100.out`; do
  j=`grep "${i}" Silva138_headers.tsv`
  echo ${j} >> SSU_Taxa.tsv
done
