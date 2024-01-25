#!/bin/bash

#SBATCH --mail-type=fail
#SBATCH --mail-user=jazmin.valerianosaenz@students.unibe.ch
#SBATCH --job-name="StringTieAssemble"
#SBATCH --cpus-per-task=8
#SBATCH --time=3:00:00
#SBATCH --mem=4G
#SBATCH --partition=pall
#SBATCH --array=1-6

#Define an array of sample names 
SAMPLES=("3_2" "3_4" "3_7" "P1" "P2" "P3")

#Input and output directories
ALIGN_DIR='/data/users/jvaleriano/lncRNA/02_output_HISAT2'
REF_DIR='/data/users/jvaleriano/lncRNA/reference_genome'
OUTPUT_DIR='./03_output_StringTie'

mkdir $OUTPUT_DIR

# Use the SLURM_ARRAY_TASK_ID as the index to get the sample name, and SLURM_CPUS_PER_TASK as number of threads. 
SAMPLE=${SAMPLES[$SLURM_ARRAY_TASK_ID-1]}
THREADS=$SLURM_CPUS_PER_TASK

module add UHTS/Aligner/stringtie/1.3.3b

# -G option indicates that stringtie will use the reference annotation to guide the assembly process, 
# Output will include reference transcripts as well as novel transcripts it assembles.
# - o is the output GTF file where stringtie will write the assembled transcripts
# - p is the number of threads
# --rf is for strandedness - we know from RseQC our data is seqd by First-Strand Synthesis Method

stringtie $ALIGN_DIR/sorted_${SAMPLE}_alignment.bam -G $REF_DIR/gencode.v44.annotation.gtf -o $OUTPUT_DIR/${SAMPLE}_alignment.gtf -p $THREADS --rf


