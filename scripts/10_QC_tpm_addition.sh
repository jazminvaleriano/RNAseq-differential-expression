#!/usr/bin/env bash
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=1G
#SBATCH --time=01:00:00

INPUT_DIR=/data/users/jvaleriano/lncRNA/04_output_quant
SAMPLES_VECTOR="3_2 3_4 3_7 P1 P2 P3"

for i in $SAMPLES_VECTOR
do awk -v i=$i -F'\t' '{sum += $5} END {print "Sum of TPM for " i " =" sum}' $INPUT_DIR/${i}/abundance.tsv 
done > $INPUT_DIR/sum_of_TPM.txt