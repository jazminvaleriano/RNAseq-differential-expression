#!/bin/bash

#SBATCH --job-name="AlignmentQC"
#SBATCH --cpus-per-task=4
#SBATCH --time=2:00:00
#SBATCH --mem=8G
#SBATCH --partition=pall

EXAMPLE_BAM=/data/users/jvaleriano/rna_seq/HISAT2/run1/3_7alignment.bam
REFERENCE_BED=/data/users/jvaleriano/rna_seq/reference_genome/GRCh38.BED
# NOTE: to replicate strandedness experiment, the BED file must be downloaded again (it is no longer avail in the directory)

#Load RSeQC module
module load UHTS/Quality_control/RSeQC/4.0.0;

# Experiment to infer read strandedness 
infer_experiment.py -i $EXAMPLE_BAM -r 

#Output of the experiment: 
#This is PairEnd Data
#Fraction of reads failed to determine: 0.1266
#Fraction of reads explained by "1++,1--,2+-,2-+": 0.0060
#Fraction of reads explained by "1+-,1-+,2++,2--": 0.8674

#Interpretation:
#The majority of the reads (86.49%) are consistent with a first-strand synthesis protocol. 
#This means that during library preparation, the first strand of cDNA synthesized was used as
# a template for the subsequent steps, leading to this pattern of read mapping.
#A small fraction (0.74%) aligns with a second-strand synthesis pattern, but this is likely too small to be significant 
#or could be due to technical variations or artifacts.

# statistics for bam files
bam_stat.py -i /data/users/jvaleriano/lncRNA/02_output_HISAT2/sorted_3_7_alignment.bam

#bam_stat OUTPUT:

#==================================================
#All numbers are READ count
#==================================================

#Total records:                          73701439

#QC failed:                              0
#Optical/PCR duplicate:                  0
#Non primary hits                        6210483
#Unmapped reads:                         1585506
#mapq < mapq_cut (non-unique):           3555237

#mapq >= mapq_cut (unique):              62350213
#Read-1:                                 31449515
#Read-2:                                 30900698
#Reads map to '+':                       31126454
#Reads map to '-':                       31223759
#Non-splice reads:                       30595438
#Splice reads:                           31754775
#Reads mapped in proper pairs:           61118928
#Proper-paired reads map to different chrom:0