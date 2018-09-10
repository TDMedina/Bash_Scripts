#!/bin/bash

# Your job name
#$ -N Investigate_HN72_AH

# The job should be placed into the queue 'all.q'
#$ -q all.q

# Running in the current directory
#$ -cwd

# Export some necessary environment variables
#$ -v PATH
#$ -v LD_LIBRARY_PATH
#$ -v PYTHONPATH
#$ -S /bin/bash

#Finally, put your command here

#samtools sort -m 10000000000 HN72_s2_normal.AH0LENADXX_namesorted_fixed_premerge.bam HN72_AH_test.bam
samtools index HN72_AH_test.bam
