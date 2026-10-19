#!/usr/bin/bash
#PBS -l nodes=1:ppn=20

# locating the directory with data
cd /your/directory/here

# setting background for conda environment activation
eval "$(conda shell.bash hook)"

# activating 'bioinfo' environment with conda
conda activate bioinfo

# going through each vcf within the directory
for VCF in `ls *.norm.flt-indels.vcf.gz`

do

# filtering biallelic variants
bcftools view -Oz -m 2 -M 2 ${VCF} -o ${VCF}_biallelic.vcf.gz

# indexing new biallelic file
bcftools index ${VCF}_biallelic.vcf.gz

# setting input for the beagle
input_vcf=${VCF}_biallelic.vcf.gz

# defining output prefix for beagle output
output_prefix=${VCF}_out

# Running beagel
beagle gt=${input_vcf} out=${output_prefix} nthreads=20

done
