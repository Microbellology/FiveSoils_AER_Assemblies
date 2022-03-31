#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_gtdbtk

cd /safs-data02/dennislab/Public/Belle/5soils/In/
mkdir 07_gtdbtk
cd /safs-data02/dennislab/Public/Belle/5soils/In/04_bins/polished_assembly/

for i in `ls *.tsv`; do
  mkdir /safs-data02/dennislab/Public/Belle/5soils/In/07_gtdbtk/${i%.tsv}
  gtdbtk classify_wf --batchfile ${i} --out_dir /safs-data02/dennislab/Public/Belle/5soils/In/07_gtdbtk/${i%.tsv} -x fa --prefix ${i%.tsv} --cpus 20
done
