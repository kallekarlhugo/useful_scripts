#!/bin/bash
#$ -V -cwd
#$ -l h_vmem=8G
#$ -q parallel.q
#$ -pe openmp 2
#$ -R y
#$ -j y
#$ -N Add_readgroups_master
#$ -e Add_readgroups_master.err.txt
#$ -o Add_readgroups_master.out.txt
#$ -S /bin/bash


### This script will add readgroups to the bam files N.B this script isn't a batch array

### Before running this script, your need to get the RG information from the fastq files. I have made these files for all the populations (see /lifesci_fraser/SHARED/readgroup_metadata.tsv
## NB the sample_ID information may be different if you changed the names at the end of the 2_bwa_align_script.sh


## Change the directories ##

metadata=./
bam_path=./

## Metadata file for each population

# 1 simple_ID
# 2 sample_ID
# 3 instrument
# 4 seq number
# 5 run number
# 6 flow cell
# 7 lane
# 8 barcode


META=metadata_whole.tsv
while read LINE
do
    simpleID=$(echo "$LINE" | awk '{print $1}')
    sampleID=$(echo "$LINE" | awk '{print $2}')
    instrument=$(echo "$LINE" | awk '{print $3}')
    seqnum=$(echo "$LINE" | awk '{print $4}')
    run_number=$(echo "$LINE" | awk '{print $5}')
    flow_cell=$(echo "$LINE" | awk '{print $6}')
    lane=$(echo "$LINE" | awk '{print $7}')
    barcode=$(echo "$LINE" | awk '{print $8}')

### Run picard tools AddreplaceRGs

    java -Xmx10g  -jar /data/programs/picard-tools-1.139/picard.jar AddOrReplaceReadGroups\
      I=$bam_path/${sampleID} O=$bam_path/${sampleID%.bam}.rg.bam RGID=${flow_cell}.${lane}.${simpleID} RGLB=${simpleID}.${seqnum} \
      RGPL=${instrument} RGSM=${simpleID} RGPU=${flow_cell}.${lane}.${barcode}

done < $META
