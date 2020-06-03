# Use R studio server from duke or miles from anywhere by connecting via local host and ssh
ssh -N -L 8787:miles.zoologi.su.se:8787 kaltun@miles.zoologi.su.se
http://localhost:8787/ # open link in browser

#
# edit .gff (Cds -> cds, exclude exons)
sed 's/CDS/cds/g' rc3_pienap.gff > rc3_pienap.cds.gff
awk '$3!="exon"' rc3_pienap.cds.gff > rc3_pienap.cds.noexons.gff


# shift coordinates in gff file, just set the shift value to the desired number of bp
awk 'BEGIN {OFS="\t"} {if ($1==<"scaffold_you_want_to_shift"> && $4><600000>)sub($4, $4+<shift>)sub($5, $5+<shift>); print}' genemodel_edit.gff

#rename fasta to numbers
awk '/^>/{print ">" ++i; next}{print}' < file.fasta

#linearizing fasta
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < file.fa > out.fa

#log your commands
script <log_file> # ctrl + D to stop

#process the logfile to make it readable
cat log | perl -pe 's/\e([^\[\]]|\[.*?[a-zA-Z]|\].*?\a)//g' | col -b > log.txt


# bash script to grep all items from a list from another file, i.e using a list of genes and extracting them from a .gff file
--
#!/bin/bash
while read p; do grep $p $2 >> $1_by_$2 ; done < $1
--

# segment a single fasta file and create a multifasta with a specified length and named sequentially.

grep -v '^>' input.fa | tr -d '\n' | fold -w 60 | nl -n rz -s '
' | sed 's/^/>fragment_/;N' > output.fa

# turn multi line fasta into single line fasta
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < file.fa > file_single.fa

# Blast genome for Amino acid sequence
query=NSP_aa.fa
database=/cerberus/projects/chrwhe/Pieris_napi_fullAsm.fasta
dataroot=Pieris_napi_fullAsm
/data/programs/ncbi-blast-n-rmblast-2.2.28+/tblastn -query "$query" -db "$database" -evalue .00001 -out "$query"_v_"$dataroot".tsv -outfmt 6 -num_threads 20
/data/programs/ncbi-blast-n-rmblast-2.2.28+/tblastn -query "$query" -db "$database" -evalue .00001 -out "$query"_v_"$dataroot".aln -outfmt 2 -num_threads 20

blast_table="$query"_v_"$dataroot".tsv
echo 'query_id,geneID,identity,alignment_length,mismatches,gapopens,qstart,qend,sstart,send,evalue,bitscore' | cat - "$blast_table" | awk '{gsub(",","\t",$0); print;}' > "$blast_table".tsv


# Blast genome normal length DNA sequences
query=
database=
dataroot=
/data/programs/ncbi-blast-n-rmblast-2.2.28+/14,539-23,599
/data/programs/ncbi-blast-n-rmblast-2.2.28+/blastn -query "$query" -db $i  -evalue .0001 -out "$query"_v_"$dataroot".tsv -outfmt 6 -num_threads 20

# Blast genome short DNA sequences
query=
database=
dataroot=
/data/programs/ncbi-blast-n-rmblast-2.2.28+/blastn -query "$query" -db "$database" -task blastn-short -evalue .01 -out "$query"_v_"$dataroot".tsv -outfmt 6 -num_threads 20
/data/programs/ncbi-blast-n-rmblast-2.2.28+/blastn -query "$query" -db "$database" -task blastn -evalue .01 -out "$query"_v_"$dataroot".tsv -outfmt 6 -num_threads 20

blast_table="$query"_v_"$dataroot".tsv
echo 'query_id,geneID,identity,alignment_length,mismatches,gapopens,qstart,qend,sstart,send,evalue,bitscore' | cat - "$blast_table" | awk '{gsub(",","\t",$0); print;}' > "$blast_table".tsv

# turn blast output fmt6 into a bedfile to be viewed in IGV
# Warning, currently it does not handöe direction well.
blast_output="$query"_v_"$dataroot".tsv
cat $blast_output | awk '{print($2"\t"$9-1"\t"$10-1"\t"$1)}' > blast_otput.bed
    # if the match is on the reverse strand
 cat $blast_output |awk '{print($2"\t"$10-1"\t"$9-1"\t"$1)}' >> blast_otput.bed
# map multiple reads to the same reference
reference=alba_edited_genome_v2.fasta
for sample in `ls ./*ctq20.fq `
do
base=$(basename $sample "_2.ctq20.fq")
/data/programs/NextGenMap-0.4.12/bin/ngm-0.4.12/ngm -r "$reference" -1 ${base}_1.ctq20.fq -2 ${base}_2.ctq20.fq  -t 64 -p -b -o ${base}alba_edited_genome_NGM.bam
done

# start IGV on server, view in X11
# duke
/data/programs/IGV_Linux_2.5.0/igv.sh # optional -g <fasta_or_genomefile> <1.bam> <2.bam> <1.gff>

# view all hidden charachters in a file
sed -n 'l' myfile.txt

# SPALN

export PATH=$PATH:/data/programs/spaln2.1.4/bin
export ALN_TAB=/data/DB/annotation/spaln_db/table/
export ALN_DBS=/data/DB/annotation/spaln_db/seqdb

cp "$species"_consensus.concensus.rd5.p10.fa /data/DB/annotation/spaln_db/seqdb/
cd /data/DB/annotation/spaln_db/seqdb
mv "$species"_consensus.concensus.rd5.p10.fa "$species"_consensus_concensus_rd5_p10.mfa

make "$species"_consensus_concensus_rd5_p10.idx
make "$species"_consensus_concensus_rd5_p10.bkp

# grep lines containing matching lines, ie specific names in one file and names and measurment in other file
awk -F' ' 'NR==FNR{c[$1]++;next};c[$1] > 0' f1.txt f2.txt > output.txt # f1 is subset file, and f2 is larger file. -F determines type of delimitor in f2

# reverse complement of sequence
tr -d "\n " < input.txt | tr "[ATGCatgcNn]" "[TACGtacgNn]" | rev
tr -d "\n " < tail*fa | tr "[ATGCatgcNn]" "[TACGtacgNn]" | rev

# search .tsv file for rows where one column contain value between specific numbers
awk -F "\t" '{ if(($7 >= 500 && $7 <= 800)) { print } }' final_bases.fa_v_Ce_fixed_NGM_polish.fasta.tsv

# kill other byobu sessions to make window larger
/usr/lib/byobu/include/tmux-detach-all-but-current-client

#Print all sequences annotated in a GFF3 file.
cut -s -f 1,9 yourannots.gff3 | grep $'\t' | cut -f 1 | sort | uniq

# replace multuple spaces with tab
sed -i 's/\  */\t/g' meta.tsv

# edit output from plink to be a proper tsv
plink_output=
sed 's/\  */\t/g'  $plink_output | sed 's/\t$//g' | sed 's/:/\t/g' | sed 's/CHR/\tCHR/g' |  cut -f3- > $plink_output.tsv

# merge selected columns from files that matches pattern, and add filename for each row.
find . -name "Bmori90_v_C*blasttab" -exec awk 'NR>1 {print FILENAME,$1,$4,$5,$6}' {} \; | sed 's/.\//''/' > Bmori_v_Ceur_superbundle.txt
find . -name "w600q10c0.depth.bed" -exec awk 'NR>1 {print FILENAME,$1,$2,$4}' {} \; | sed 's/.\//''/' > Cnas_depth_superbundle.txt

# list processes
pgrep # command
pgrep -u kaltun # all processes run by kaltun
pgrep -u -a kaltun # descriptive info of all processes run by kaltun
pgrep ssh # match processes with command
