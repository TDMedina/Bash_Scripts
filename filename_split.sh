#!/bin/bash

fullfilename=$1
filename=$(basename "$fullfilename")
fname="${filename%.*}"

echo "Input File: $fullfilename"
echo "Filename without Path: $filename"
echo "Filename without Extension: $fname"
