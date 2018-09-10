#!/bin/bash

# Your job name
#$ -N ChIPper

# The job should be placed into the queue 'all.q'
#$ -q all.q

# Running in the current directory
#$ -cwd

# Export some necessary environment variables
#$ -v PATH
#$ -v LD_LIBRARY_PATH
#$ -v PYTHONPATH
#$ -S /bin/bash

#Commands---------------------------------------------------------------------------------

#Command-line arguments: qsub script.sh referencegenome chip_fastqfile input_fastqfile


#FastQC
for f in *.fastq;
do
       	fastqc $f;
done


#MultiQC
multiqc .;


#Make Indexes from Reference Genome
bowtie2-build $1 ref_index
touch IndexingDone.txt


#Alignment and Post-Processing
for file in *.fastq;
do
	sam=${file//.fastq/.sam}
	bam=${file//.fastq/.bam}
	dups_out=${bam//.bam/.rmdup.bam}
	sorted=${dups_out//.rmdup.bam/.rmdup.sorted.bam}
	stats=${file//.fastq/_mappingstats.txt}	

	bowtie2 -x ref_index -U $file -S $sam
	samtools view -Sb $sam > $bam
	samtools rmdup $bam $dups_out
	samtools sort $dups_out ${sorted//.bam}
	samtools index $sorted
	samtools flagstat $sorted > $stats

	touch ${file//.fastq/IsDone.txt}
done

#ChIP Peak Calling
macs2 callpeak -t ${2//.fastq/.rmdup.sorted.bam} -c ${3//.fastq/.rmdup.sorted.bam} -f BAM -g hs -n macs_out --call-summits -B
touch MacsIsDone.txt

#MACS XLS Trimmer
awk '!/^#|^$/ {print $1,$2,$3}' macs_out_peaks.xls | sed '1d' > peaks.bed
#awk '$1="chr"$1' peaks.bed > chr_peaks.bed
#awk '!/^#|^$/ {$1="chr"$1; print $1,$2,$3}' macs_out_peaks.xls | sed '1d' > peaks.bed


#Extract ChIP Sequences
bedtools getfasta -fi $1 -bed peaks.bed -fo peaks.fasta
touch GetFastaIsDone.txt

#Motif Analysis
meme peaks.fasta -dna -mod zoops -minw 6 -maxw 26 -nmotifs 5 -o meme_out
touch MemeIsDone.txt
