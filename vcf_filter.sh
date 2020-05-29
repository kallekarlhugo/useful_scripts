# run with bash filter_vcf.sh input_file.vcf.gz
vcffile=$1
vcftools --gzvcf $vcffile --max-missing 0.2 --minQ 30 --minDP 5  --recode --recode-INFO-all --out ${vcffile%.vcf.gz}.mm0.2q30DP5
vcftools --vcf ${vcffile%.vcf.gz}.mm0.2q30DP5.recode.vcf  --min-alleles 2 --max-alleles 2  --recode --recode-INFO-all --out ${vcffile%.vcf.gz}.mm0.2q30DP5.m2M2
