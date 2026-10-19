#!/usr/bin/bash
#PBS -l nodes=1:ppn=15

cd /your/directory/here

# Here we are setting the background for conda environment activation. This will retrieve details of the packages installed on Miniconda.
eval "$(conda shell.bash hook)"

# activating a conda environment. The name of the environment could be anything.
conda activate bioinfo

# loop through each file, this text file is just a list of sample names with no extensions.
for i in `cat samplenames.txt`
do
bowtie2 -x ../anstephUCI/Anstep -1 ${i}_1.fq -2 ${i}_2.fq  --no-unal -p 15 | samtools view -bS -o ${i}_output.bam
done
