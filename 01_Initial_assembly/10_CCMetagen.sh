#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

load_ccmetagen

cd /safs-data02/dennislab/Public/Belle/5soils/Li/

#assign directories
input_dir=00_raw_reads
output_dir=01_KMA_res
mkdir $output_dir
nt_db=/safs-data02/dennislab/db/ccmetagen/ncbi_nt_kma_jan_2018/ncbi_nt

#run KMA for each sample
for r1 in $input_dir/*R1.fq.gz; do
  r2=${r1/R1.fq.gz/R2.fq.gz}
  echo $r2
  o_part1=$output_dir/${r1/$input_dir\//''}
  echo $o_part1
  o=${o_part1/.R*/}
	echo $o
  kma -ipe $r1 $r2 -o $o -t_db $nt_db -t 15 -1t1 -mem_mode -and -apm f
done

#assign new directoies
input_dir=01_KMA_res
output_dir=02_CCMetagen
mkdir -p $output_dir

#run CCMetagen for each sample
for f in $input_dir/*.res; do
  echo $f
  out=$output_dir/${f/$input_dir\/}
  CCMetagen.py -i $f -o $out
done

#merge tables together
CCMetagen_merge.py -i $output_dir -t Superkingdom -o merged_table
