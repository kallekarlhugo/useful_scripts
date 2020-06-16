bamlist=multibam.lst # list of bamfiles you want to call variants on, one per row.
bams=$(tr '\n' ' ' < $bamlist)
samtools_path=/data/programs/samtools-1.7/
reference=
outfile_root=


# Try to generate mpileup using Cris' paralell script
# genome
mkdir paralell_mpileup
cd paralell_mpileup
ln -s ../genome.fasta* .
grep '>' genome.fasta | sed 's/>//g' > Chromo_list

samtools_path=/data/programs/samtools-1.7/
reference=
outfile_root=

# run
cat Chromo_list | parallel -j 30 "$samtools_path/samtools mpileup  -Q15 -C 50 -t DP -uf $reference-r {} $bams > $outfile_root.{}.mpileup"
