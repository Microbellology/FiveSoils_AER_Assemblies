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


for i in ` awk '{print $1}' nitrospiria.txt`; do
  echo ${i}* #>> nitrospiria_full_path.txt
done


for i in `ls *fna`; do
  echo /safs-data01/uqbclar8/01_missing_taxa_mapping/01_reference_fasta_files/1_nitrospiria/nitrospiria_cp/${i} >> nitrospiria_ref_list.txt
done
