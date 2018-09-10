#!/bin/bash

# Your job name
#$ -N Sharesies

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
bcftools isec -n +2 -O v HN51.vcf.gz HN60.vcf.gz
