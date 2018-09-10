#!/bin/bash

# SGE OPTIONS====================================

#$ -N TREX_Variants
#$ -q all.q
#$ -cwd
#$ -v PATH
#$ -v LD_LIBRARY_PATH
#$ -v PYTHONPATH
#$ -S /bin/bash

# COMMANDS=======================================
# QC---------------------------------------------
mkdir QC_files
for fastq in samples/*.fastq
do
	fastqc -o QC_files "$fastq"
done
multiqc -o QC_files QC_files


# TRIMMING---------------------------------------
mkdir trimmed
mkdir unpaired
for file in samples/*P1*
do
        name=${file#*/}
	java -jar Trimmomatic-0.36/trimmomatic-0.36.jar PE -phred33 -trimlog trimlog.txt "$file" "${file/P1/P2}" trimmed/"$name" unpaired/"$name".unpaired trimmed/"${name/P1/P2}" unpaired/"${name/P1/P2}".unpaired ILLUMINACLIP:Trimmomatic-0.36/adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
done


# QC 2-------------------------------------------
mkdir QC_files_2
for fastq_trim in trimmed/*.fastq
do
        fastqc -o QC_files_2 "$fastq_trim"
done
multiqc -o QC_files_2 QC_files_2


# INDEXING---------------------------------------
cd ref
bwa index -a bwtsw hg19.fa
samtools faidx hg19.fa
cd ../


# ALIGNMENT--------------------------------------
mkdir sams
for file in trimmed/*P1*
do
	name=${file#*/}
	samfile=${name/.lane*/.sam}
	id1=${name#*.}
	id2=${id1/lane_}
	id=${id2/_*}
	sm=${name:0:4}
	rg="@RG\tID:$id\tSM:$sm\tPL:ILLUMINA\tLB:$sm"
	bwa mem -t 4 -R "$rg" ref/hg19.fa "$file" "${file/P1/P2}" > sams/"$samfile"
done


# SAM TO BAM-------------------------------------
mkdir bams
cd sams
for sam in *.sam
do
	bam=${sam/.sam/.bam}
	samtools view -Sb "$sam" > ../bams/"$bam"
done
cd ../


# SORT BY NAME-----------------------------------
mkdir sorted_bams
cd bams
for bam in *.bam
do
	sorted=${bam/.bam/_namesorted}
	samtools sort -n -m 10000000000 "$bam" ../sorted_bams/"$sorted"
done
cd ../


# FIXMATES--------------------------------------
mkdir fixmates_bams
cd sorted_bams
for bam in *namesorted.bam
do
       samtools fixmate "$bam" ../fixmates_bams/"${bam/.bam/_fixed.bam}"
done
cd ../


# MERGE 72--------------------------------------
cd fixmates_bams
samtools merge -n HN72_s2_normal.Merged_namesorted_fixed.bam HN72_s2_normal.AC254KACXX_namesorted_fixed.bam HN72_s2_normal.AH0LENADXX_namesorted_fixed.bam
mv HN72_s2_normal.AC254KACXX_namesorted_fixed.bam .HN72_s2_normal.AC254KACXX_namesorted_fixed.bam
mv HN72_s2_normal.AH0LENADXX_namesorted_fixed.bam .HN72_s2_normal.AH0LENADXX_namesorted_fixed.bam
cd ../


# SORT BY CHR AND REMOVE DUPLICATES-------------
mkdir rmdup_bams
cd fixmates_bams
for bam in *namesorted_fixed.bam
do
	chr_sort="${bam/name/chr}"
	samtools sort -m 10000000000 "$bam" "${chr_sort/.bam/}"
	samtools rmdup "$chr_sort" ../rmdup_bams/"${chr_sort/.bam/_rmdup.bam}"
done
cd ../


# INDEX BAMS AND GENERATE MAPPING STATS---------
mkdir bcfs
cd rmdup_bams
for bam in *_rmdup.bam
do
	samtools index "$bam"
	stats=${bam/.bam/_mapstats.txt}
	samtools flagstat "$bam" > ../mapstats/"$stats"


# VARIANT CALLING-------------------------------
	bcf=${bam/_*/_var_raw.bcf}
	samtools mpileup -ugf ../ref/hg19.fa "$bam" | bcftools view -bvcg -> ../bcfs/"$bcf"
done
cd ../


# VARIANT FILTERING-----------------------------
mkdir vcfs
cd bcfs
for bcf in *.bcf
do
	vcf=${bcf/_raw.bcf/_filtered.vcf}
	bcftools view "$bcf" | vcfutils.pl varFilter -d 60 > ../vcfs/"$vcf"
done

