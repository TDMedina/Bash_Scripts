#!/bin/bash

# SGE options=============

#$ -N TREX_Variants
#$ -q all.q
#$ -cwd
#$ -v PATH
#$ -v LD_LIBRARY_PATH
#$ -v PYTHONPATH
#$ -S /bin/bash

# Commands================
# QC----------------------
for fastq in samples/*.fastq
do
	fastqc -o QC_test1 "$fastq"
done

multiqc -o QC_test1 QC_test1

# Trimming----------------
for file in samples/*P1*
do
        name=${file#*/}
	java -jar Trimmomatic-0.36/trimmomatic-0.36.jar PE -phred33 -trimlog trimlog.txt "$file" "${file/P1/P2}" -baseout trimmed/"$name" ILLUMINACLIP:Trimmomatic-0.36/adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
done
# QC 2--------------------
for fastq_trim in trimmed/*.fastq
do
        fastqc -o QC_test2 "$fastq_trim"
done

multiqc -o QC_test2 QC_test2

