## extract headers and sequences from a fasta file that contain specific characters / a string in the header (e.g. "16S")
​
#template
#awk '/^>/ { ok=index($0,"string")!=0;} {if(ok) print;}' input.ffn > output.fa
​
​
# for example
​
cd /safs-data01/uqkweigh/prokka/outputs/
for i in `ls *.fa`; do
  awk '/^>/ { ok=index($0,"16S")!=0;} {if(ok) print;}' ${i%} > ${i%.ffn}_16S.fa
done
