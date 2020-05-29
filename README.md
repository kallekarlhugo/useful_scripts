# useful_scripts

## In this repo I am collecting some general usage scripts that I frequenctly use.

*Detailed usage information is generally found within each script*

### Freebayes_parallel_pipeline.sh

The default parallel script for freebayes can be very slow on bigger projects or if the runtime of each window differ. This happens because the script is unable to sart looking at any new regions before all the regions in each batch have completed.
This modified script takes a list of bamfiles, divides it into equal sized regions, and then calls variants in them, outputting the data in temporary region specific vcf files. Once all the regions have been called they are merged, sorted and cleaned up.

To run the script you need:
- goleft installed
- freebayes installed
- a list of sorted and indexed .bam files

Before running the script edit the variables within the script for:
threads= # number of threads
reference= # reference genome
chunks=2000 # number of regions to divide the genome into
regions=target_regions # name of the region file
bamlist=multibam.lst # list of bamfiles you want to call variants on, one per row. 
temp_out_dir=a_directory_to_put_temp_files_in # name and then make a temp directory for output files
final_name=name_of_final_file.vcf # name of final vcf file.
