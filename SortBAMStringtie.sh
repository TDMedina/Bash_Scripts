#!/bin/bash

# Your job name
#$ -N TM_Stringtie

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

#Command line arguments: qsub script.sh gene_path

for file in *_sorted.bam;
do
	/data4/nextgen2015/users/13101308/tools/stringtie-1.3.4c/stringtie -p 8 -G $1 -o ${file//_sorted.bam/.gtf} -l ${file//_chrX_sorted.bam} $file
done
