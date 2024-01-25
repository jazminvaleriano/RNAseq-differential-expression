#!/bin/bash

# STEP 0 SET UP DIRECTORY FOR INPUT FILES-------------
#Create directory for reads and reference genomes and link them locally
source scripts/00_Link_Input_Files.sh

# STEP 1 READ QUALITY AND STATISTICS------------------
#Count reads and asses Quality of all samples/replicates
source scripts/01a_CountReads.sh
sbatch scripts/01b_doFASTQC.sh
#Generate a grouped quality report from the individual FastQC analyisis. 
sbatch scripts/01c_doMultiQC.sh

#Run this command on local terminal to store FASTQC and MultiQC html results and check on browser
#scp jvaleriano@binfservms01.unibe.ch:/data/users/jvaleriano/rna_seq/QC/*.html ~/Desktop/RNA.SEQ/FASTQC

# STEP 2 READ MAPPING ---------------------------------
# Get the genome indices and unzip them: 
cd reference_genome/
wget https://genome-idx.s3.amazonaws.com/hisat/hg38_genome.tar.gz 
tar -xzf hg38_genome.tar.gz ; cd ../
#Align to reference genome usign HISAT2, then Use Samtools convert to bam, sort and index:
sbatch scripts/02a_HISAT2_align_to_bam.sh
#Asses quality of resulting alignment
#sbatch scritps/02b_alignment_QC.sh

# STEP 3 TRANSCRIPTOME ASSEMBLY--------------------------
# Use StringTie to create a reference-guided transcriptome assembly based on the RNA-seq for each sample
sbatch scripts/03_StringTie_assemble.sh

# Merge the .gtf output files from all individual replicates into one meta-assembly .gtf file
sbatch scripts/04_StringTie_merge.sh

#Count the total number of exons, transcripts and genes, and single exon transcripts and genes for quality check 
source scripts/05_counting_tr_genes.sh 

# Create a transcript to genes table for downstream analyisis (Sleuth dif expression)
source scripts/06_Transcript_to_Gene.sh

# STEP 4 QUANTIFICATION-----------------------------------
#Create an fasta file from the transcript assembled on the previous step
sbatch scripts/07_fasta_from_gtf.sh

#Build an index from our transcripts
sbatch scripts/08_Kallisto_index.sh

#Quantify with kallisto 
sbatch scripts/09_Kallisto_quant.sh

# STEP 5 DIFFERENTIAL EXPRESSION ------------------------

# STEP 6 INTEGRATIVE ANALYSIS ----------------------------
sbatch scripts/11_create_bed_from_gtf.sh
sbatch scripts/12_intersect_bedtools.sh
sbatch scripts/13_protein_coding_potential.sh
sbatch scripts/14_statistics_step6.sh