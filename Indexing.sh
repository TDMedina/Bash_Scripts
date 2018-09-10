#!/bin/bash

# Your job name
#$ -N TREX_DEX

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

#==Index Genome==============================
fasta_list="$(cat mm10_list.txt)"
echo $fasta_list
../hisat/hisat2-build -p 8 -f $fasta_list mm10ref
