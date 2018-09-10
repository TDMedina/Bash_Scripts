#!/bin/bash

# Your job name
#$ -N TM_Hisat

# The job should be placed into the queue 'all.q'
#$ -q all.q

# Running in the current directory
#$ -cwd

# Export some necessary environment variables
#$ -v PATH
#$ -v LD_LIBRARY_PATH
#$ -v PYTHONPATH
#$ -S /bin/bash

#Commands

for file in *.fastq
do
	hisat/hisat2 -p 8 --dta -x mm10 -U "$file" -S "${file//.fastq/.sam}"
done
