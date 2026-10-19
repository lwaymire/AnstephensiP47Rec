#!/bin/bash
#PBS -l nodes=1:ppn=16:gpus=1
#PBS -l walltime=48:00:00

# =============================================================
# AlphaFold 3 PBS submission script
# runs two AF3 jobs sequentially
#   1. P47Rec UCI_ANSTEP_V1.0, 53Q (reference)
#   2. P47Rec UCI_ANSTEP_V1.0, 53H (substituted)
# =============================================================

# move to working directory
cd /your/directory/here

# paths (update these)
SIF=/your/apptainer/directory/here/alphafold3.sif
FASTA=/your/directory/here/UCI_ANSTEP_V1.0_P47Rec.fasta   # WT (53Q) single-sequence FASTA
AF3_MODELS=/your/directory/here/models
AF3_DB=/your/directory/here/databases
POS=53

JSON_DIR=/your/directory/here/inputs
OUT_DIR=/your/directory/here/outputs
PDB_DIR=/your/directory/here/pdb_models
mkdir -p "$JSON_DIR" "$OUT_DIR" "$PDB_DIR"

# build AF3 input JSONs (53Q reference, 53H substituted)
python3 - <<EOF
import json

seq = "".join(l.strip() for l in open("${FASTA}") if not l.startswith(">"))
pos = ${POS}
assert seq[pos-1] == "Q", f"Residue {pos} is {seq[pos-1]}, expected Q. Check numbering."

variants = {"53Q": seq, "53H": seq[:pos-1] + "H" + seq[pos:]}
for tag, s in variants.items():
    job = {
        "name": f"P47Rec_{tag}",
        "modelSeeds": [1],
        "sequences": [{"protein": {"id": "A", "sequence": s}}],
        "dialect": "alphafold3",
        "version": 1,
    }
    json.dump(job, open(f"${JSON_DIR}/P47Rec_{tag}.json", "w"), indent=2)
    print("Wrote", tag, "length", len(s))
EOF

# run 1: P47Rec 53Q
apptainer exec --nv \
    "$SIF" \
    python /app/alphafold/run_alphafold.py \
    --json_path=${JSON_DIR}/P47Rec_53Q.json \
    --model_dir=${AF3_MODELS} \
    --db_dir=${AF3_DB} \
    --output_dir=${OUT_DIR}

# run 2: P47Rec 53H
apptainer exec --nv \
    "$SIF" \
    python /app/alphafold/run_alphafold.py \
    --json_path=${JSON_DIR}/P47Rec_53H.json \
    --model_dir=${AF3_MODELS} \
    --db_dir=${AF3_DB} \
    --output_dir=${OUT_DIR}
