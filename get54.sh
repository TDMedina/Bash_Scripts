#!/bin/bash

# Your job name
#$ -N SRA_get

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
#input="SRR_Acc_List.txt"

#while IFS= read var
#do
#	wget --no-parent ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/SRR/SRR165/"$var"/"$var".sra
#done < "$input"

wget --no-parent ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/SRR/SRR165/SRR1658054/SRR1658054.sra

