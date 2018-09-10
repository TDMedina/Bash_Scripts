#!/bin/bash

# Your job name
#$ -N TM_SAMtoSortBAM

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

#Will convert all SAM files in dir to BAM, then sort BAM files

for file in *.sam;
do
	samtools view -bS $file >${file//.sam/_unsorted.bam}
	samtools sort -@ 8 ${file//.sam/_unsorted.bam} ${file//.sam}
done
