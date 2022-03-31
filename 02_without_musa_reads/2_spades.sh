
for i in `ls *_1.fq.gz`; do
  # Mapping
  bwa aln -n 0.1 ${j}_species_rep_genomes.fasta ${i} > mapping_${j}/${i%_1.fq.gz}_1.sai
  bwa aln -n 0.1 ${j}_species_rep_genomes.fasta ${i%_1.fq.gz}_2.fq.gz > mapping_${j}/${i%_1.fq.gz}_2.sai

  # Covert to samfile
  cd mapping_${j}
  bwa sampe ../${j}_species_rep_genomes.fasta ${i%_1.fq.gz}_1.sai ${i%_1.fq.gz}_2.sai ../${i} ../${i%_1.fq.gz}_2.fq.gz > ../samfiles_${j}/${i%_1.fq.gz}_bwa.sam
  cd ..

  # Extract mapped reads
  cd samfiles_${j}
  awk '$3 !="*" {print $1}' ${i%_1.fq.gz}_bwa.sam > ${i%_1.fq.gz}_mapped_reads_list_temp.tsv
  grep -v -e '@' ${i%_1.fq.gz}_mapped_reads_list_temp.tsv > ${i%_1.fq.gz}_mapped_reads_list.tsv
  python /safs-data02/dennislab/Public/scripts/fastq_filter_pairs_by_id.py -1 ../${i} -2 ../${i%_1.fq.gz}_2.fq.gz -o ../mapped_reads_${j}/${i%_1.fq.gz} -l ${i%_1.fq.gz}_mapped_reads_list.tsv --include
  cd ..
