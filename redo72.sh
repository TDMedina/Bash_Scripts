#!/bin/bash

# SGE options=============

#$ -N Redo72_Variants
#$ -q all.q
#$ -cwd
#$ -v PATH
#$ -v LD_LIBRARY_PATH
#$ -v PYTHONPATH
#$ -S /bin/bash

# Commands================
# MERGE 72 AND FIXMATES------------------------------------
#for bam in ../sorted_bams/HN72*_namesorted.bam
#do
#	file="${bam##*/}"
#	samtools fixmate "$bam" "${file/.bam/_fixed_premerge.bam}"
#done
#samtools merge -n HN72_s2_normal.MergedPostFix_namesorted_fixed.bam HN72_s2_normal.AC254KACXX_namesorted_fixed_premerge.bam HN72_s2_normal.AH0LENADXX_namesorted_fixed_premerge.bam


# SORT BY CHR AND RMDUP-----------------------------------
#for bam in *MergedPostFix_namesorted_fixed.bam
#do
#	chr_sort="${bam/name/chr}"
#	samtools sort -m 10000000000 "$bam" "${chr_sort/.bam/}"
#	echo "$chr_sort"
#	samtools rmdup "$chr_sort" "${chr_sort/.bam/_rmdup.bam}"
#done


# INDEX BAM AND FLAGSTAT------------------------------------
for bam in *_rmdup.bam
do
#	echo "$bam"
	samtools index "$bam"
	stats=${bam/.bam/_mapstats.txt}
	samtools flagstat "$bam" > "$stats"
# VARIANT CALLING-----------------------------------------------
	bcf=${bam/_*/_PostMergeFix_var_raw.bcf}
	samtools mpileup -ugf ../ref/hg19.fa "$bam" | bcftools view -bvcg -> "$bcf"
	vcf=${bcf/_raw.bcf/_filtered.vcf}
	bcftools view "$bcf" | vcfutils.pl varFilter -d 60 >"$vcf"
done
