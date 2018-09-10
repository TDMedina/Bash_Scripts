#!/bin/bash

# SGE OPTIONS=================================

#$ -N Race1
#$ -q all.q
#$ -cwd
#$ -v PATH
#$ -v LD_LIBRARY_PATH
#$ -v PYTHONPATH
#$ -S /bin/bash

# COMMANDS===================================
cd markdup_bams_GATK

java -jar ../picard.jar BuildBamIndex I=HN51_GATKmarkdup.bam
#java -jar ../picard.jar BuildBamIndex I=HN60_GATKmarkdup.bam
#java -jar ../picard.jar BuildBamIndex I=HN72_GATKmarkdup.bam

java -jar ../gatk.jar HaplotypeCaller --TMP_DIR ./ -I HN51_GATKmarkdup.bam -O ../vcf_race/HN51_RACE.g.vcf.gz -R ../../ref/hg19.fa -ERC GVCF -bamout HN51_RACE_bamout.bam
#java -jar ../gatk.jar HaplotypeCaller --TMP_DIR ./ -I HN60_GATKmarkdup.bam -O ../vcf_race/HN60_RACE.g.vcf.gz -R ../../ref/hg19.fa -ERC GVCF -bamout HN60_RACE_bamout.bam
#java -jar ../gatk.jar HaplotypeCaller --TMP_DIR ./ -I HN72_GATKmarkdup.bam -O ../vcf_race/HN72_RACE.g.vcf.gz -R ../../ref/hg19.fa -ERC GVCF -bamout HN72_RACE_bamout.bam
