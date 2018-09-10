#!/bin/bash

# Your job name
#$ -N MergeJob

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
samtools merge -n HN72_s2_normal.Merged_namesorted.bam HN72_s2_normal.AC254KACXX_namesorted.bam HN72_s2_normal.AH0LENADXX_namesorted.bam
#samtools fixmate HN51* ../fixmates_bams/HN51_namesorted_fixed.bam
#samtools fixmate HN60* ../fixmates_bams/HN60_namesorted_fixed.bam
samtools fixmate *Merged* ../fixmates_bams/HN72_namesorted_fixed.bam

