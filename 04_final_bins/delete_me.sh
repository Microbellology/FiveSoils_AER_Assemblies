for i in `ls *.fasta`; do
  mv ${i} ${i%.fasta}_shortread.fa
done

for i in `ls *.gz`; do
  echo ${i} >> sample_list.tsv
done

for i in `ls *table.txt`; do
  echo ${i} >> mega_table.tsv
  cat ${i} >> mega_table.tsv
  echo -e "\n" >> mega_table.tsv
done
