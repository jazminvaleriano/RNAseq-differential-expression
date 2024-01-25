#!/bin/bash

#SBATCH --mail-type=fail
#SBATCH --mail-user=jazmin.valerianosaenz@students.unibe.ch
#SBATCH --job-name="KallistoIndex"
#SBATCH --time=8:00:00
#SBATCH --mem=20G
#SBATCH --partition=pall

#Input and output directories
OUTPUT_DIR='/data/users/jvaleriano/lncRNA/04_output_quant'
INPUT_FILE='/data/users/jvaleriano/lncRNA/04_output_quant/all_transcripts.fa'

# Add Kallisto module
module add UHTS/Analysis/kallisto/0.46.0

kallisto index -i $OUTPUT_DIR/kallisto.index $INPUT_FILE


