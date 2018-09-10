#!/bin/bash

# Your job name
#$ -N TM_GFFcompare

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

#Command line arguments: qsub script.sh path_to_gtf_reference_file

/data4/nextgen2015/users/13101308/tools/gffcompare -r $1 -o GFFc_out merged.gtf
