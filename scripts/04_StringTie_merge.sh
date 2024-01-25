#!/bin/bash

#SBATCH --mail-type=fail
#SBATCH --mail-user=jazmin.valerianosaenz@students.unibe.ch
#SBATCH --job-name="StringTieMerge"
#SBATCH --cpus-per-task=8
#SBATCH --time=2:00:00
#SBATCH --mem=8G
#SBATCH --partition=pall

#Input and output directories
REF_DIR='/data/users/jvaleriano/lncRNA/reference_genome'
OUTPUT_DIR='/data/users/jvaleriano/lncRNA/03_output_StringTie'

# Use SLURM_CPUS_PER_TASK as number of threads. 
THREADS=$SLURM_CPUS_PER_TASK

module add UHTS/Aligner/stringtie/1.3.3b

#Create a list of all bam files from previous step (string tie assemble per replicate)
ls $OUTPUT_DIR/*.gtf > tmp.all.alignments.txt

#Run StringTie Merge to get one meta assemble
stringtie --merge -G $REF_DIR/gencode.v44.annotation.gtf -o $OUTPUT_DIR/all_alignments.gtf -p $THREADS tmp.all.alignments.txt

rm tmp.all.alignments.txt
