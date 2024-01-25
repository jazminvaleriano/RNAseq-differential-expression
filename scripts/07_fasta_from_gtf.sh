#!/bin/bash

#SBATCH --mail-type=fail
#SBATCH --mail-user=jazmin.valerianosaenz@students.unibe.ch
#SBATCH --job-name="FastaFromGTF"
#SBATCH --cpus-per-task=8
#SBATCH --time=1:00:00
#SBATCH --mem=4G
#SBATCH --partition=pall


#Input and output directories
REF_DIR='/data/users/jvaleriano/lncRNA/reference_genome'
OUTPUT_DIR='/data/users/jvaleriano/lncRNA/04_output_quant'
INPUT_FILE='/data/users/jvaleriano/lncRNA/03_output_StringTie/all_alignments.gtf'

mkdir $OUTPUT_DIR

# Use SLURM_CPUS_PER_TASK as number of threads. 
THREADS=$SLURM_CPUS_PER_TASK

module add UHTS/Assembler/cufflinks/2.2.1

gffread -w $OUTPUT_DIR/all_transcripts.fa -g $REF_DIR/GRCh38.genome.fa $INPUT_FILE
