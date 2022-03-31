#!/bin/bash
#
#PBS -S /bin/bash
#PBS -A UQ-SCI-SEES
#PBS -N spades_Tu
#PBS -l select=1:ncpus=24:mem=1975GB
#PBS -l walltime=167:00:00

module load spades/3.15.3

cd $TMPDIR

mkdir spades
metaspades.py -1 /QRISdata/Q0775/belle/01_core/01_5soils_AER/02_novaseq/Tu/01_reads/Tu_R1.fastq.gz -2 /QRISdata/Q0775/belle/01_core/01_5soils_AER/02_novaseq/Tu/01_reads/Tu_R2.fastq.gz -o spades/ -t 24 -m 1975

cp -r spades/ /QRISdata/Q0775/belle/01_core/01_5soils_AER/02_novaseq/Tu/

qsub spades.pbs
