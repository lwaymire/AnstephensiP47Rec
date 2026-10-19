#!/bin/bash
#PBS -l nodes=1:ppn=16
#PBS -l walltime=48:00:00

# =============================================================
# HADDOCK3 PBS submission script
# runs two docking jobs sequentially:
#   1. Pfs47 + glutamate_p47Rec_alphafold
#   2. Pfs47 + sda500rec_model_0
# =============================================================

# move to working directory
cd /your/directory/here

# path to Apptainer image
SIF=/your/directory/here/apptainersif.sif

# run 1: Pfs47 + glutamate P47Rec
apptainer run \
    "$SIF" \
    /your/directory/here/pfs47_glutamate.cfg

# run 2: Pfs47 + sda500rec
apptainer run \
    "$SIF" \
    /your/directory/here/pfs47_sda500rec.cfg
