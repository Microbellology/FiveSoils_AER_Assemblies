#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs
load_checkm
cd /safs-data02/dennislab/Public/Belle/5soils/Pg/
mkdir 06_checkm
mkdir 06_checkm/01_unpolished
checkm taxonomy_wf domain Bacteria -f 06_checkm/01_unpolished/qa.tsv --tab_table -x fa --threads 10 04_bins/polished_assembly/ 06_checkm/01_unpolished
