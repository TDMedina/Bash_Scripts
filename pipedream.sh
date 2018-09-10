#!/bin/bash

# Your job name
#$ -N TREX_Pipedream

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

#==REFERENCE INDEX BUILDING====
fasta_list="$(cat mm10_list.txt)"
echo $fasta_list
../hisat/hisat2-build -p 8 -f $fasta_list mm10ref 

#==FILE NAMING==================
for file in *.fastq
do
	prefix="${file%.fastq}"
	sam="${prefix}.sam"
	bam="${prefix}.bam"
	rmdup="${prefix}.rmdup.bam"
	sorted="${prefix}.sorted.rmdup.bam"
	stats="${prefix}.mapstats.txt"	

#==ALIGNMENT====================
  	hisat/hisat2 -p 8 --dta -x mm10ref -U "$file" -S "${prefix}.sam"

#==SAM TO BAM===================	
	samtools view -Sb "$sam" > "$bam"

#==REMOVE PCR DUPLICATES========
	samtools rmdup "$bam" "$rmdup"

#==SORTING======================
	samtools sort "$rmdup" "${sorted%.bam}"

#==INDEXING=====================
	samtools index "$sorted"

#==MAPPING STATS================
	samtools flagstat "$sorted" > $stats

#==STRINGTIE====================
	../stringtie/stringtie -p 8 -G 


done

