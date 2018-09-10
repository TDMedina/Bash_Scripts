#!/bin/bash

# Your job name
#$ -N get_dat_ass

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
file=1
while [ $file -lt 6 ]
do
	this="ftp://ftp.ncbi.nlm.nih.gov/sra/wgs_aux/PS/ZQ/PSZQ01/PSZQ01.$file.fsa_nt.gz"
	wget -b $this
	((file++))
done

