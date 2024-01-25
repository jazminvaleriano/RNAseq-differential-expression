#!/bin/bash

#SBATCH --mail-type=fail
#SBATCH --mail-user=jazmin.valerianosaenz@students.unibe.ch
#SBATCH --job-name="MultiQC"
#SBATCH --cpus-per-task=8
#SBATCH --time=1:00:00
#SBATCH --mem=1G
#SBATCH --partition=pall

THREADS=$SLURM_CPUS_PER_TASK
FASTQC_OUTPUT_DIR="01_output_FastQC"

cd $FASTQC_OUTPUT_DIR

module add UHTS/Analysis/MultiQC/1.8

#MultiQC will scan the working directory and produce a report based on details found in any FastQC log files that it recognises.
multiqc .

cd../