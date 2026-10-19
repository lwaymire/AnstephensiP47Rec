#!/usr/bin/bash
#PBS -l nodes=1:ppn=15

# locating the directory with data
cd /your/directory/here

# setting background for conda environment activation
eval "$(conda shell.bash hook)"

# activating 'bioinfo' environment with conda
conda activate bioinfo

# looping over sorted vcf files for consensus calling
for i in `ls *_out.vcf.gz`
do

#index phased files
bcftools index ${i}

# Extracting consensus coding sequences
samtools faidx ../SDA500redo/GCA_000349045.1_Anop_step_SDA-500_V1_genomic.fna " KB664345.1:242275-243272" | bcftools consensus ${i} > ${i}_out.vcf.gz.cds.fa

done
