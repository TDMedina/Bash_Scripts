#!/bin/bash

# SGE OPTIONS====================================

#$ -N RevComp
#$ -q all.q
#$ -cwd
#$ -v PATH
#$ -v LD_LIBRARY_PATH
#$ -v PYTHONPATH
#$ -S /bin/bash

# COMMANDS=======================================
head -n 1 "$1" > rev"$1"
sed -n "2p" "$1" | tr ACGT TGCA | rev >> rev"$1"
