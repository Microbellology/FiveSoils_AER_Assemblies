#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

##before you begin you will need to make a "custom_taxonomy_file.tsv" file for the bins you would like to look at
#this is a tab seperated file with the first column as your bin names (w/o extension, no .fa) and the second column as the 7rank taxonomy

#This script looks at specific taxonomy's. You will need to look at prior gtdbtk output to work out which taxa you want to look at
#Use AnnoTree to find the outgroup. You want the outgroup to be related to your taxa of interest but, different enough. You also want your outgroup to have many subtaxa within it

#load required modules
load_gtdbtk

#go to working directory and make an output directory
cd /safs-data02/dennislab/Public/belle/5soils/final_bins/


#run program
gtdbtk de_novo_wf --batchfile dRep/dereplicated_genomes/f_Sphingomonadaceae_bins.tsv --taxa_filter f__Sphingomonadaceae --outgroup_taxon p__Cyanobacteria --bacteria --custom_taxonomy_file gtdbtk_tree/f__Sphingomonadaceae.tsv -x fa --out_dir gtdbtk_tree/

#"custom_taxonomy_file" is the file you make earlier, read above
#--taxa_filter is the taxa you're looking at
#--outgroup found using AnnoTree
