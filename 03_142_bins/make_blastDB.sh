#!/usr/bin/env bash
. /safs-data02/dennislab/sw/.config/software_defs

#load modules
load_blast_plus

#loop through all the fasta files you want to make a DB for (if only one, just run what's inside the forloop)
for i in `ls *.fasta`; do
  #make a shortcut
  taxon=${i%_species_rep_genomes.fasta}

  #go to relevant directory
  cd /safs-data02/dennislab/Public/belle/5soils/databases/

  #mk folder to copy to later
  mkdir ${taxon}_blastDB

  #copy required file to scratch drive
  cp ${i} /safs-data01/uqbclar8/databases/

  #go to scratch drive
  cd /safs-data01/uqbclar8/databases/

  #make database using blast
  makeblastdb -in ${i} -input_type fasta -dbtype nucl

  #copy the database back to safs02 and remove files from scratch drive
  cp *fasta.n* /safs-data02/dennislab/Public/belle/5soils/databases/${taxon}_blastDB/
  cd ../
  rm databases/*
done
#10cpu, 100mem
