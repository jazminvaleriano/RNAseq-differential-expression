#!/bin/bash

#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=32G
#SBATCH --time=04:00:00

module add UHTS/Analysis/BEDTools/2.29.2
module load SequenceAnalysis/GenePrediction/cpat/1.2.4

INT_ANALYSIS_DIR=/data/users/jvaleriano/lncRNA/06_output_int_analysis
REFERENCES_DIR=/data/courses/rnaseq_course/lncRNAs/Project1/references

# Convert novel transcripts bed file into fasta
bedtools getfasta -s -name -fi $REFERENCES_DIR/GRCh38.genome.fa -bed $INT_ANALYSIS_DIR/novel.bed -fo $INT_ANALYSIS_DIR/novel.fa

# Use CPAT to evaluate protein coding potential
cpat.py -x $REFERENCES_DIR/Human_Hexamer.tsv -d $REFERENCES_DIR/Human_logitModel.RData -g $INT_ANALYSIS_DIR/novel.fa -o $INT_ANALYSIS_DIR/protein_coding_potential

# Run output R script to get file with prot. coding potential values 
Rscript $INT_ANALYSIS_DIR/protein_coding_potential.r

