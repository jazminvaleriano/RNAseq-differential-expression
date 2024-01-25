#!/bin/bash

#SBATCH --mail-type=fail
#SBATCH --mail-user=jazmin.valerianosaenz@students.unibe.ch
#SBATCH --job-name="HISAT_Align"
#SBATCH --cpus-per-task=8
#SBATCH --time=3:00:00
#SBATCH --mem=8G
#SBATCH --partition=pall
#SBATCH --array=1-6
#SBATCH --output=/data/users/jvaleriano/lncRNA/02_output_HISAT2/alignment.rate.%a.out

#Define an array of sample names and the names / paths of directories
SAMPLES=("3_2" "3_4" "3_7" "P1" "P2" "P3") 
OUTPUT_DIR='02_output_HISAT2'
READS_DIR='/data/users/jvaleriano/lncRNA/reads'
REFERENCE_DIR='/data/users/jvaleriano/lncRNA/reference_genome/hg38'

# Use the SLURM_ARRAY_TASK_ID as the index to get the sample name, and SLURM_CPUS_PER_TASK as number of threads. 
SAMPLE=${SAMPLES[$SLURM_ARRAY_TASK_ID-1]}
THREADS=$SLURM_CPUS_PER_TASK

module add UHTS/Aligner/hisat/2.2.1
module add UHTS/Analysis/samtools/1.10

mkdir $OUTPUT_DIR
cd $OUTPUT_DIR

#Options for hisat 2:
# --phred33 for the score format
# --rna-strandness R/RF if we have first strand 
# --dta : Output alignments suitable for transcriptome assembly. Mostly used for RNA-seq data analysis.
# -S: Output alignment to file (SAM format) instead of standard output
# -x : location of the reference genome

hisat2 -p $THREADS --phred33 --dta --rna-strandness RF \
-x $REFERENCE_DIR/genome \
-1 $READS_DIR/${SAMPLE}_R1.fastq.gz \
-2 $READS_DIR/${SAMPLE}_R2.fastq.gz \
-S ${SAMPLE}_alignment.sam

#Convert .sam into .bam, and directly pipe it to sort.
#options used:  -h option is to preserve header, -b is to have the output in bam format. 
samtools view -@ $THREADS -h -b ${SAMPLE}_alignment.sam | samtools sort -@ $THREADS -o sorted_${SAMPLE}_alignment.bam

#Generate the index 
samtools index -@ $THREADS sorted_${SAMPLE}_alignment.bam

#Remove SAM files to save space
rm ./*.sam     
cd ../