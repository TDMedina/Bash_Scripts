#!/bin/bash

# SGE options=============

#$ -N PRUEBA
#$ -q all.q
#$ -cwd
#$ -v PATH
#$ -v LD_LIBRARY_PATH
#$ -v PYTHONPATH
#$ -S /bin/bash

# Indexing----------------
cd tair
bwa index -a bwtsw tair10chr.fasta
samtools faidx tair10chr.fasta
cd ../

# Alignment---------------
for file in samples/*
do
        name=${file#*/}
        samfile=${name/.fastq/.sam}
        bwa mem -t 4 -R '@RG\tID:VC1\tSM:S64154\tLB:Lib1' tair/tair10chr.fasta "$file" > sams/"$samfile"
done

# Post-processing---------
cd sams
for sam in *.sam
do
        bam=${sam/.sam/.bam}
        samtools view -Sb "$sam" > ../bams/"$bam"
done

cd ../bams
for bam in *.bam
do
        rmdup=${bam/.bam/_rmdup.bam}
        samtools rmdup "$bam" ../rmdup_bams/"$rmdup"
done

cd ../rmdup_bams
for bam in *_rmdup.bam
do
        sorted=${bam/_rmdup.bam/_sorted}
        samtools sort "$bam" ../sorted_bams/"$sorted"
done

cd ../sorted_bams
for bam in *_sorted.bam
do
        samtools index "$bam"
        stats=${bam/_sorted.bam/_mapstats.txt}
        samtools flagstat "$bam" > ../mapstats/"$stats"

# Variant Calling-----------

        bcf=${bam/_*/_var_raw.bcf}
	vcf=${bam/_*/_var_raw.vcf}
	echo "FIRST BCF CALL================================================"
        samtools mpileup -uvf ../tair/tair10chr.fasta "$bam" > "$vcf"
 #| bcftools view -bvcg > ../bcfs/"$bcf"
done

cd ../bcfs
#for bcf in *.bcf
#do
#        vcf=${bcf/_raw.bcf/_filtered.vcf}
#	echo "SECOND BCF CALL=======================================++++++++++"
#        bcftools view "$bcf" | vcfutils.pl varFilter -d 10 -> ../vcfs/"$vcf"
#done

cd ../
