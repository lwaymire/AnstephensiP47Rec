#!/usr/bin/bash
#PBS -l nodes=1:ppn=10

# locating the directory with data
cd /your/directory/here

# setting background for conda environment activation
eval "$(conda shell.bash hook)"

# activating 'bioinfo' environment with conda. this could be named anything.
conda activate bioinfo

# set for loop to go through sorted bam files.
for VCF in `ls *.sorted.bam`

do

# call variants
bcftools mpileup -Ou -f ../anstephUCI/ANSTEPv1.fna ${VCF} | bcftools call -mv -Oz -o ${VCF}.vcf.gz
bcftools index ${VCF}.vcf.gz

# normalize indels
bcftools norm -f ../anstephUCI/ANSTEPv1.fna ${VCF}.vcf.gz -Ob --threads 35 -o ${VCF}.norm.bcf

# filter adjacent indels within 5bp
bcftools filter --IndelGap 5 -e 'QUAL<30 || DP<10' ${VCF}.norm.bcf -Ov -o ${VCF}.norm.flt-indels.vcf

# bgzipping the normalized and filtered calls
bgzip ${VCF}.norm.flt-indels.vcf

# Indexing filtered calls
bcftools index ${VCF}.norm.flt-indels.vcf.gz

done
