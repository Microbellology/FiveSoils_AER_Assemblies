


In: CoverM
Li: CCmetagen > CoverM
Pg: CCmetagen > CoverM
To: CCmetagen > CoverM
Tu: CCmetagen > CoverM
All: checkM > GTDBtk > enrichM > prokka > heatmap
CCmetagen for all

#spades workflow for Tu only at this stage
1. spades
2. blasr
3. as normal


drep on all bins

'#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

load_drep

#move to working directory
cd /safs-data02/dennislab/Public/Belle/5soils/final_bins/
mkdir dRep

#dereplicate genomes
dRep dereplicate dRep/ -g polished/*.fa'

sbatch -c 10 --mem=300GB --partition=safs --time=365-0:00:00 --no-kill --job-name=drep_all 9_drep.sh
tail -f slurm-10272559.out
