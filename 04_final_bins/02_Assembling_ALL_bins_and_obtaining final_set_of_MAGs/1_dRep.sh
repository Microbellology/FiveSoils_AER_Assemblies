#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

# this script can be used to run the program dRep to dereplicate genomes made from multiple
# genome asseblies
# The Qc function is not used here as it limits the number of bins that it outputs
# some low quality bins are still usefull as it demonstates that taxa was present

## Anna-Belle Clarke 5.4.2022

load_drep

#move to working directory
cd /safs-data01/uqbclar8/
#mkdir short_read_included
mkdir dRep_no_qc_ALL_bins

#dereplicate genomes
dRep dereplicate dRep_no_qc_ALL_bins -g all_bins_4assemblies/*.fa --ignoreGenomeQuality
#mem 100, cpu 10
