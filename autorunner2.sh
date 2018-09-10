#!/bin/bash

# Your job name
#$ -N TMauto

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

#Command arguments: qsub script.sh referencegenome indexname

#Make indexes from reference
bowtie2-build $1 $2
touch IndexingDone.txt

for file in *.fastq;
do
	sam=${file//.fastq/.sam}
	bam=${file//.fastq/.bam}
	dups_out=${bam//.bam/.rmdup.bam}
	sorted=${dups_out//.rmdup.bam/.rmdup.sorted.bam}
	stats=${file//.fastq/_mappingstats.txt}	

	bowtie2 -x $2 -U $file -S $sam
	samtools view -Sb $sam > $bam
	samtools rmdup $bam $dups_out
	samtools sort $dups_out ${sorted//.bam}
	samtools index $sorted
	samtools flagstat $sorted > $stats

	touch ${file//.fastq/IsDone.txt}
done
