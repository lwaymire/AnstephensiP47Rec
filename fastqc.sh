#!/usr/bin/bash
#PBS -l nodes=1:ppn=5

# locating the directory with data
cd /your/directory/here

# setting background for conda environment activation
eval "$(conda shell.bash hook)"

# activating 'bioinfo' environment with conda. could be named anything.
conda activate bioinfo

# unzipping files
gunzip *.gz

# quality check
fastqc -t 5 *.fq

echo "worked!"
