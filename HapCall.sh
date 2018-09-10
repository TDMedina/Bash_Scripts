#!/bin/bash

# SGE OPTIONS=================================

#$ -N GREX2_Variants
#$ -q all.q
#$ -cwd
#$ -v PATH
#$ -v LD_LIBRARY_PATH
#$ -v PYTHONPATH
#$ -S /bin/bash

# COMMANDS===================================
#mkdir gvcfs_GATK
#cd markdup_bams_GATK
#
#for file in *markdup.bam
#do
#	java -jar ../picard.jar BuildBamIndex I="$file"
#	name="${file:0:4}"
#	java -jar ../gatk.jar HaplotypeCaller --TMP_DIR ./ -I "$file" -O ../gvcfs_GATK/"$name".g.vcf.gz -R ../../ref/hg19.fa -ERC GVCF -bamout "$name"_bamout.bam
#done

#cd ../gvcfs_GATK/
cd vcf_race
java -jar ../gatk.jar CombineGVCFs --TMP_DIR ./ -O combine.g.vcf.gz -V HN51_RACE.g.vcf.gz -V HN60_RACE.g.vcf.gz -V HN72_RACE.g.vcf.gz -R ../../ref/hg19.fa
java -jar ../gatk.jar GenotypeGVCFs --TMP_DIR ./ -O combo.vcf -R ../../ref/hg19.fa -V combine.g.vcf.gz
