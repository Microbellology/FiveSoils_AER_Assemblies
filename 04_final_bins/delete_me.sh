for i in `ls *.sam`; do
  #awk '$3 !="*" {print $1}' ${i} > ${i%_bwa.sam}_mapped_reads_list_temp.tsv
  #grep -v -e '@' ${i%_bwa.sam}_mapped_reads_list_temp.tsv > ${i%_bwa.sam}_mapped_reads_list.tsv
  python /safs-data02/dennislab/Public/scripts/fastq_filter_pairs_by_id.py -1 ../${i} -2 ../${i%_1.fq.gz}_2.fq.gz -o ../mapped_reads_${j}/${i%cleaned_paired_1.fq.gz}_${j} -l ${i%_1.fq.gz}_mapped_reads_list.tsv --include
done

for i in `ls *_1.fq.gz`; do
  #echo ${i}
  cd samfiles_${j}
  #grep -v -e '@' ${i%_1.fq.gz}_mapped_reads_list_temp.tsv > ${i%_1.fq.gz}_mapped_reads_list.tsv
  python /safs-data02/dennislab/Public/scripts/fastq_filter_pairs_by_id.py -1 ../${i} -2 ../${i%_1.fq.gz}_2.fq.gz -o ../mapped_reads_${j}/${i%cleaned_paired_1.fq.gz}_${j} -l ${i%_1.fq.gz}_mapped_reads_list.tsv --include
  cd ../
done

grep -v -e '@' SD7445_S47_L004_cleaned_paired_mapped_reads_list_temp.tsv > SD7445_S47_L004_cleaned_paired_mapped_reads_list.tsv
python /safs-data02/dennislab/Public/scripts/fastq_filter_pairs_by_id.py -1 ../SD7448_S50_L004_cleaned_paired_1.fq.gz -2 ../SD7448_S50_L004_cleaned_paired_2.fq.gz -o ../mapped_reads_${j}/SD7448_S50_L004_${j} -l SD7448_S50_L004_cleaned_paired_mapped_reads_list.tsv --include

head SD7448_S50_L004_cleaned_paired_mapped_reads_list.tsv
A00632:99:H7CGGDSX2:4:1124:4969:5368
A00632:99:H7CGGDSX2:4:1124:4969:5368
A00632:99:H7CGGDSX2:4:1330:6940:3771
A00632:99:H7CGGDSX2:4:1330:6940:3771
A00632:99:H7CGGDSX2:4:1330:7202:4257
A00632:99:H7CGGDSX2:4:1330:7202:4257
A00632:99:H7CGGDSX2:4:1330:8269:3537
A00632:99:H7CGGDSX2:4:1330:8269:3537
A00632:99:H7CGGDSX2:4:1330:8296:3583
A00632:99:H7CGGDSX2:4:1330:8296:3583

python /safs-data02/dennislab/Public/scripts/fastq_filter_pairs_by_id_cp.py -1 ../SD7448_S50_L004_cleaned_paired_1.fq.gz -2 ../SD7448_S50_L004_cleaned_paired_2.fq.gz -o ../mapped_reads_${j}/SD7448_S50_L004_${j} -l SD7448_S50_L004_cleaned_paired_mapped_reads_list.tsv --include

Traceback (most recent call last):
 File "/safs-data02/dennislab/Public/scripts/fastq_filter_pairs_by_id.py", line 124, in <module>
   main(args.forward_reads_file, args.reverse_reads_file, args.id_list_file, args.output_prefix, args.exclude)
 File "/safs-data02/dennislab/Public/scripts/fastq_filter_pairs_by_id.py", line 63, in main
   if not header_1.startswith('@'):
TypeError: startswith first arg must be bytes or a tuple of bytes, not str

for i in `ls *.fasta`; do
  mv ${i} ${i%.fasta}_shortread.fa
done

for i in `ls *.gz`; do
  echo ${i} >> sample_list.tsv
done

for i in `ls *table.txt`; do
  echo ${i} >> mega_table.tsv
  cat ${i} >> mega_table.tsv
done
