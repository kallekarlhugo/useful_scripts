query=
database=
dataroot=
# makeblastdb -in $database -dbtype nucl  #generate blast database is one does not exist
/data/programs/ncbi-blast-n-rmblast-2.2.28+/blastn -query "$query" -db "$database" -task blastn -evalue .01 -out "$query"_v_"$dataroot".tsv -outfmt 6 -num_threads 20

blast_output="$query"_v_"$dataroot".tsv
cat $blast_output | awk '{print($2"\t"$9-1"\t"$10-1"\t"$1)}' > ${blast_output%.tsv}.bed
    # if the match is on the reverse strand
cat $blast_output |awk '{print($2"\t"$10-1"\t"$9-1"\t"$1)}' >> ${blast_output%.tsv}.bed
