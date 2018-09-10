#!/bin/bash

# SGE OPTIONS====================================

#$ -N Fa_To_Fas
#$ -q all.q
#$ -cwd
#$ -v PATH
#$ -v LD_LIBRARY_PATH
#$ -v PYTHONPATH
#$ -S /bin/bash

# COMMANDS=======================================
my_list=$(cat scaff_list.txt)

for scaffold in $my_list
do
	line_no=$(grep -n "^>JREZ010*$scaffold\.1" JREZ.fa | cut -f1 -d :)
	line_after=$(grep -n "^>JREZ010*$((scaffold+1))\.1" JREZ.fa | cut -f1 -d :)
	touch scaff"$scaffold".fasta
	sed -n "${line_no}p" JREZ.fa > scaff"$scaffold".fasta
	sed -n "$((line_no+1)),$((line_after-1))p;${line_after}q" JREZ.fa | tr -d "\n" >> scaff"$scaffold".fasta  
done
