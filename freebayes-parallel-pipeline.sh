#!/bin/bash

# run the command with ./freebayes-parallel-pipeline.sh

# this is an edited version of the freebayes-parallel script that:
##1. generates regions of number of reads
##2. calls variants on bamfiles defined by a file list and outputs them into small temporary vcf files
##3. merges all the temporary files and sorts the final raw vcf file.

# to run this script, copy the script to your directory, then edit all the variables to fit your project.
# run the command with ./freebayes-parallel-pipeline.sh

# this runs freebayes parallel with default settings, if you want to add any more options, you can add options in section 5


#1 define variables
threads=40
reference=alba_edited_genome_V2.fasta
chunks=2000
regions=target_regions
bamlist=multibam.lst # list of bamfiles you want to call variants on, one per row.
temp_out_dir=a_directory_to_put_temp_files_in
final_name=name_of_final_file.vcf

#2 add stuff to the path
PATH=/mnt/griffin/kaltun/software/:/mnt/griffin/kaltun/software/freebayes/vcflib/bin/:/mnt/griffin/kaltun/software/freebayes/scripts/:/data/programs/pigz/:$PATH

#3 generate regions of equal size
bamindexes=$(tr '\n' ' ' < $bamlist)
/mnt/griffin/kaltun/software/goleft_linux64 indexsplit --n $chunks --fai $ref.fai $bamindexes | awk '{print $1":"$2"-"$3}' > $regions

#4 run the edited script
/mnt/griffin/kaltun/software/freebayes/scripts/freebayes-parallel_no_sort $regions $threads -f $ref -L $bamlist -v $temp_out_dir/{}.vcf

#5 concatenate all the individual vcf files i and fipe the output into the cleaning script, which will remove headers and remove overlapping regions.
while read -r name; do cat "$temp_out_dir/$name.vcf"; done < $regions | vcffirstheader | vcfstreamsort | vcfuniq > $final_name
