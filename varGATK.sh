#!/bin/bash

# SGE OPTIONS=================================

#$ -N TREX_Variants
#$ -q all.q
#$ -cwd
#$ -v PATH
#$ -v LD_LIBRARY_PATH
#$ -v PYTHONPATH
#$ -S /bin/bash

# COMMANDS===================================
# INITIAL QC---------------------------------
#for fastq in samples/*.fastq
#do
#	fastqc -o QC_files "$fastq"
#done
#
#multiqc -o QC_files QC_files

# TRIMMING----------------------------------
#for file in samples/*P1*
#do
#        name=${file#*/}
#	java -jar Trimmomatic-0.36/trimmomatic-0.36.jar PE -phred33 -trimlog trimlog.txt "$file" "${file/P1/P2}" trimmed/"$name" trimmed/"$name".unpaired trimmed/"${name/P1/P2}" trimmed/"${name/P1/P2}".unpaired ILLUMINACLIP:Trimmomatic-0.36/adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
#done

# POST-TRIMMING QC-------------------------
#for fastq_trim in trimmed/*.fastq
#do
#        fastqc -o QC_files_2 "$fastq_trim"
#done
#
#multiqc -o QC_files_2 QC_files_2

# REFERENCE GENOME INDEXING----------------
#cd ref
#bwa index -a bwtsw hg19.fa
#samtools faidx hg19.fa
#cd ../

# ALIGNMENT--------------------------------
mkdir sams_GATK
for file in ../trimmed/*P1*
do
	name=${file##*/}
	samfile=${name/.lane*/_GATK.sam}
	id1=${name#*.}
	id2=${id1/lane_}
	id=${id2/_*}
	sm=${name:0:4}
	rg="@RG\tID:$id\tSM:$sm\tPL:ILLUMINA\tLB:$sm"
	bwa mem -t 4 -R "$rg" -M ../ref/hg19.fa "$file" "${file/P1/P2}" > sams_GATK/"$samfile"
done

# SORT BY NAME-----------------------------
mkdir name_sorted_bams_GATK
cd sams_GATK
for sam in *.sam
do
	java -jar ../picard.jar SortSam TMP_DIR=./ MAX_RECORDS_IN_RAM=2000000 I="$sam" O=../name_sorted_bams_GATK/"${sam/.sam/_namesorted.bam}" SORT_ORDER=queryname
done
cd ../

# FIXMATES-----------------------------------
mkdir fixmate_bams_GATK
cd name_sorted_bams_GATK
for file in *namesorted.bam
do
	java -jar ../picard.jar FixMateInformation TMP_DIR=./ MAX_RECORDS_IN_RAM=2000000 I="${file}" O=../fixmate_bams_GATK/"${file/namesorted.bam/fixed.bam}" SORT_ORDER=coordinate
done
cd ../

# MERGE HN72---------------------------------
cd fixmate_bams_GATK
java -jar ../picard.jar MergeSamFiles TMP_DIR=./ MAX_RECORDS_IN_RAM=2000000 I=HN72_s2_normal.AC254KACXX_GATK_fixed.bam I=HN72_s2_normal.AH0LENADXX_GATK_fixed.bam O=HN72_s2_normal.MERGED_GATK_fixed.bam
mv HN72_s2_normal.AC254KACXX_GATK_fixed.bam .HN72_s2_normal.AC254KACXX_GATK_fixed.bam
mv HN72_s2_normal.AH0LENADXX_GATK_fixed.bam .HN72_s2_normal.AH0LENADXX_GATK_fixed.bam
cd ../

# MARKDUPLICATES----------------------------------
mkdir markdup_bams_GATK
cd fixmate_bams_GATK
for file in *fixed.bam
do
	java -jar ../picard.jar MarkDuplicates TMP_DIR=./ MAX_RECORDS_IN_RAM=2000000 I="$file" O=../markdup_bams_GATK/"${file/_*.bam/_GATKmarkdup.bam}" M=../markdup_bams_GATK/"${file/_*.bam/_GATKmarkdup_metrics.txt}"
done
cd ../

qsub next.sh
