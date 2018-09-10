#!/bin/bash

# SGE OPTIONS=================================

#$ -N GREX_Variants
#$ -q all.q
#$ -cwd
#$ -v PATH
#$ -v LD_LIBRARY_PATH
#$ -v PYTHONPATH
#$ -S /bin/bash

# COMMANDS===================================

# REFERENCE DICTIONARY CREATION----------------
java -jar picard.jar CreateSequenceDictionary R=../ref/hg19.fa O=../ref/hg19.dict


# BQSR----------------------------------
#mkdir BQSR_tables
#mkdir BQSR_corrected
#cd markdup_bams_GATK
#for file in *markdup.bam
#do
#	java -jar ../gatk.jar BaseRecalibrator --TMP_DIR ./ -I "$file" -O ../BQSR_tables/"${file/.bam/_bqsr_data.table}" -R ../../ref/hg19.fa --known-sites ../ExAC.r1.sites.vep.vcf
#	java -jar ../gatk.jar ApplyBQSR --TMP_DIR ./ -I "$file" -O ../BQSR_corrected/"${file/.bam/_BQSR.bam}" -R ../../ref/hg19.fa -bqsr ../BQSR_tables/"${file/.bam/_bqsr_data.table}"
#done
#
#cd ../
#
#qsub HapCall.sh
