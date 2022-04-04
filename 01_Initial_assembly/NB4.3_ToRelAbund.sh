$CCMetagen

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

load_ccmetagen

cd /safs-data02/dennislab/Public/Belle/5soils/To
#run kma first
kma -ipe 01_reads/To_R1.fastq.gz 01_reads/To_R2.fastq.gz -o 05_Krona/sample_out_kma -t_db /safs-data02/dennislab/db/ccmetagen/ncbi_nt_kma_jan_2018/ncbi_nt -t 15 -1t1 -mem_mode -and -apm f'

tr -d '\r' <10_CCMetagen.sh > tmp.sh
rm 10_CCMetagen.sh
mv tmp.sh 10_CCMetagen.sh
​
sbatch -c 15 --mem=200GB --partition=safs --time=365-0:00:00 --no-kill --job-name=To_ccmetagen 10_CCMetagen.sh

tail -f slurm-10252220.out #incorrect db
