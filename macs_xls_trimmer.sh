#!/bin/bash

#MACS Trimmer
for file in *.xls;
do
       	out=${file//.xls/.bed}
	awk '!/^#|^$/ {print $1,$2,$3}' $file | sed '1d' > $out
done

