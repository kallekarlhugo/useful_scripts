## run with bash freebayes_recall_sites.sh zerene.rg.bam 10
# generate a region file with regions containing aproximately same number of reads
# there is also a script included in freebayes, but I never got it to work, so I just use this awkward awk script (which is also from the freebayes creator)
PATH=/mnt/griffin/kaltun/ceu/bamfiles/alba_edited_genome/:/mnt/griffin/kaltun/software/freebayes/vcflib/bin:/mnt/griffin/kaltun/software/freebayes/vcflib/scripts/:/mnt/griffin/kaltun/software/freebayes/bin/:/mnt/griffin/kaltun/software/freebayes/scripts:$PATH
regions=target.regions
bamfile=$1
threads=$2
ref=alba_edited_genome_V2.fasta
outdir=
# note that the input vcf needs to be bgzipd and tabix indexed
sites=/mnt/griffin/kaltun/ceu/D-statistics/vcf/no_les_no_eux_merged.mm0.2q30DP5.m2M2.recode.vcf.gz

#make a regions file for parallel action.
/mnt/griffin/kaltun/software/goleft_linux64 indexsplit --n 400 --fai $ref.fai $bamfile | awk '{print $1":"$2"-"$3}' > $regions

# once you have the region file you can start to call SNPs

# run the edited script
## it is added to the path above.
freebayes-parallel_no_sort $regions $threads -f $ref -@ $sites $bamfile -v $outdir/{}.vcf
# concatenate all the individual vcf files in the same order as defined by the target.regions file and fipe the output into the cleaning script, which will remove headers and remove overlapping regions.
while read -r name; do cat "tmp1/$name.vcf"; done < $regions | vcffirstheader | vcfstreamsort | vcfuniq | bgzip ${bamfile%.bam}.vcf.gz
