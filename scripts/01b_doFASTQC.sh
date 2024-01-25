#!/bin/bash

#SBATCH --mail-type=fail
#SBATCH --mail-user=jazmin.valerianosaenz@students.unibe.ch
#SBATCH --job-name="FASTQC"
#SBATCH --cpus-per-task=8
#SBATCH --time=1:00:00
#SBATCH --mem=1G
#SBATCH --partition=pall

THREADS=$SLURM_CPUS_PER_TASK
OUTPUT_DIR="01_output_FastQC"

#Create directory for QC 
mkdir $OUTPUT_DIR

#Load FASTQC
module add UHTS/Quality_control/fastqc/0.11.9

#FASTQC accepts several samples at once 
fastqc -t $THREADS reads/*fastq.gz -o $OUTPUT_DIR/




