#!/usr/bin/bash
#PBS -l nodes=1:ppn=15

# locating the directory with data
cd /your/directory/here

# setting background for conda environment activation
eval "$(conda shell.bash hook)"

# activating 'bioinfo' environment with conda
conda activate bioinfo

# set for loop to go through each file ending in .bam
for j in `ls *.bam`
do

# sorting and indexing bam files
samtools sort $j -o $j.sorted.bam -@ 10
samtools index $j.sorted.bam -@ 10

# looping over sorted bam files for consensus calling
for i in `ls *.sorted.bam`
do

# call variants
bcftools mpileup -Ou -f ../anstephUCI/ANSTEPv1.fna  ${i} | bcftools call -mv --ploidy 2 -Oz -o ${i}.calls.vcf.gz
bcftools index ${i}.calls.vcf.gz

# normalize indels
bcftools norm -f ../anstephUCI/ANSTEPv1.fna ${i}.calls.vcf.gz -Ob -o ${i}.calls.norm.bcf

# filter adjacent indels within 5bp
bcftools filter --IndelGap 5 -e 'QUAL<30 || DP<10' ${i}.calls.norm.bcf -Ov -o ${i}.calls.norm.flt-indels.vcf

# bgzipping the normalized and filtered calls
bgzip ${i}.calls.norm.flt-indels.vcf

# Indexing filtered calls
bcftools index ${i}.calls.norm.flt-indels.vcf.gz
