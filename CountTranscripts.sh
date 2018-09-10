#!/bin/bash

# Your job name
#$ -N TM_CountTranscripts

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

#Command line arguments: qsub script.sh

for file in *_sorted.bam;
do
	/data4/nextgen2015/users/13101308/tools/stringtie-1.3.4c/stringtie -e -B -p 8 -G merged.gtf -o ballgown/${file//_chrX_sorted.bam}/${file//_sorted.bam/_B.gtf} $file
done
