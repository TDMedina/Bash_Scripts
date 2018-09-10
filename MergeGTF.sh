#!/bin/bash

# Your job name
#$ -N TM_Stringtie_Merge

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

touch mergelist.txt

for file in *.gtf;
do
	echo $file >> mergelist.txt 
done

/data4/nextgen2015/users/13101308/tools/stringtie-1.3.4c/stringtie --merge -p 8 -G $1 -o merged.gtf mergelist.txt
