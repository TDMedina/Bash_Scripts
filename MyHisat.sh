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

#Command arguments: qsub script.sh ref_prefix

for file in *1.fastq.gz;
do
	/data4/nextgen2015/users/13101308/tools/hisat2-2.1.0/hisat2 -p 8 --dta -x $1 -1 $file -2 ${file//1.fastq.gz/2.fastq.gz} -S ${file//_1.fastq.gz/.sam}
done
