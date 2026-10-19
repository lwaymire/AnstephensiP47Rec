#!/bin/bash
#PBS -l nodes=1:ppn=16
#PBS -l walltime=12:00:00
# =============================================================
# HADDOCK3 Contact Map Analysis - One complex at a time
# =============================================================

cd /your/directory/here
SIF=/your/directory/here/haddock3.sif

# function to run contactmap on a single model
run_single_contactmap() {
    local pdb=$1
    local run_dir=$2
    local config=$3

    echo "# Contact map analysis" > "$config"
    echo "run_dir = \"${run_dir}\"" >> "$config"
    echo "ncores = 16" >> "$config"
    echo "molecules = [" >> "$config"
    echo "    \"${pdb}\"" >> "$config"
    echo "]" >> "$config"
    echo "" >> "$config"
    echo "[topoaa]" >> "$config"
    echo "" >> "$config"
    echo "[contactmap]" >> "$config"

    apptainer run \
        "$SIF" \
        "$config"
}

# process glutamine variant
GLUT_DIR="/your/directory/here"

for pdb in $(ls ${GLUT_DIR}/cluster_*_model_1.pdb | sort); do
    cluster=$(basename $pdb | sed 's/_model_1.pdb//')
    run_dir="/your/directory/here/run_contactmap_glutamine_${cluster}"
    config="/your/directory/here/contactmap_glutamine_${cluster}.cfg"

    echo ">>> Running contactmap for glutamine ${cluster} ($(date))"
    run_single_contactmap "$pdb" "$run_dir" "$config"
    echo ">>> Done: ${cluster} ($(date))"
done

# process histidine variant
echo ""
echo ">>> Processing histidine clusters ($(date))"
HIS_DIR="/data/waymirel/HADDOCK_P47system/run_pfs47_sda500rec_4_29_2/10_seletopclusts"

for pdb in $(ls ${HIS_DIR}/cluster_*_model_1.pdb | sort); do
    cluster=$(basename $pdb | sed 's/_model_1.pdb//')
    run_dir="/your/directory/here/run_contactmap_histidine_${cluster}"
    config="/your/directory/here/contactmap_histidine_${cluster}.cfg"

    echo ">>> Running contactmap for histidine ${cluster} ($(date))"
    run_single_contactmap "$pdb" "$run_dir" "$config"
    echo ">>> Done: ${cluster} ($(date))"
done
