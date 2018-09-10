#!/bin/bash

# SGE OPTIONS====================================

#$ -N trimmer
#$ -q all.q
#$ -cwd
#$ -v PATH
#$ -v LD_LIBRARY_PATH
#$ -v PYTHONPATH
#$ -S /bin/bash

# COMMANDS=======================================
# QC---------------------------------------------
        fastqc -o QC_files "$1"

# TRIMMING---------------------------------------
mkdir trimmed
mkdir unpaired
for file in samples/*P1*
do
        name=${file#*/}
        java -jar Trimmomatic-0.36/trimmomatic-0.36.jar PE -phred33 -trimlog trimlog.txt "$file" "${file/P1/P2}" trimmed/"$name" unpaired/"$name".unpaired trimmed/"${name/P1/P2}" 
unpaired/"${name/P1/P2}"$
done


# QC 2-------------------------------------------
for fastq_trim in trimmed/*.fastq
do
        fastqc -o QC_files_2 "$fastq_trim"
done
multiqc -o QC_files_2 QC_files_2
