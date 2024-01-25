#!/bin/bash

#SBATCH --mail-type=fail
#SBATCH --mail-user=jazmin.valerianosaenz@students.unibe.ch
#SBATCH --job-name="Kallisto.Q"
#SBATCH --time=5:00:00
#SBATCH --mem=30G
#SBATCH --cpus-per-task=8
#SBATCH --partition=pall
#SBATCH --array=1-6

#Define an array of sample names 
SAMPLES=("3_2" "3_4" "3_7" "P1" "P2" "P3")

#Input and output directories
READS_DIR='/data/users/jvaleriano/lncRNA/reads'
INDEX_FILE='/data/users/jvaleriano/lncRNA/04_output_quant/kallisto.index'

REF_DIR='/data/users/jvaleriano/lncRNA/reference_genome'
OUTPUT_DIR='/data/users/jvaleriano/lncRNA/04_output_quant'
INPUT_FILE='/data/users/jvaleriano/lncRNA/04_output_quant/all_transcripts.fa'

# Use the SLURM_ARRAY_TASK_ID as the index to get the sample name, and SLURM_CPUS_PER_TASK as number of threads. 
SAMPLE=${SAMPLES[$SLURM_ARRAY_TASK_ID-1]}
THREADS=$SLURM_CPUS_PER_TASK

# Add Kallisto module
module add UHTS/Analysis/kallisto/0.46.0

# Make a directory for the output files for each sample 
mkdir $OUTPUT_DIR/$SAMPLE

#Quantify with kallisto
# options: 
# -b : number of bootstrap samples
# --rf-stranded : Strand specific reads, first read reverse
# -t : Threads to use 
kallisto quant -i $INDEX_FILE -o $OUTPUT_DIR/$SAMPLE -b 50 --rf-stranded -t $THREADS $READS_DIR/${SAMPLE}_R1.fastq.gz $READS_DIR/${SAMPLE}_R2.fastq.gz 


