#!/bin/bash

# SGE OPTIONS====================================

#$ -N SRA_get
#$ -q all.q
#$ -cwd
#$ -v PATH
#$ -v LD_LIBRARY_PATH
#$ -v PYTHONPATH
#$ -S /bin/bash

# COMMANDS=======================================

for i in {0..6}
do
	wget -b ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/SRR/SRR551/SRR551597"$i"/SRR551597"$i".sra
done

wget -b ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/SRR/SRR551/SRR5516015/SRR5516015.sra

#for file in *.sra
#do
#	SRAtools/fastq-dump --split-spot --readids "$file" 
#done
