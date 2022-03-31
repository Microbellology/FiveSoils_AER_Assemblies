SOIL=Tu

ls
for i in `ls *fa`; do
  mv ${i} ${SOIL}_${i%.fa}_shortread.fa
done
ls
cp *fa /safs-data01/uqbclar8/all/
ls /safs-data01/uqbclar8/all/*shortread.fa
