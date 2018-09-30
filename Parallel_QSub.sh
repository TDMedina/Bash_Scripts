#!/bin/bash

for file in *_1.fastq
do
	qsub Strike.sh "$file"
done
