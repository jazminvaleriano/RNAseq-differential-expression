# Differential expression analyisis, annotation and characterization of lncRNAs in lung cancer
In this project, two subpopulations of the common NSCLC line A549—paraclonal and parental— were analyzed. The main goals were to identify the differentially expressed genes, and to characterize the unannotated genes, looking for novel lncRNAs candidates. 

In brief, the pipeline consists of 3 major steps: 
- Assembly of RNA transcriptome
- Differential expression analysis
- Characterization of the resulting novel genes based on their genomic context, expression level and protein coding potential. 

The RNA libraries were prepared and sequenced by Tièche et al., and were retrieved from DOI: 10.1016/j.neo.2018.09.008

This repository is part of the final project for the RNA-sequencing course (467713-HS2023) at the University of Bern. 

# Analysis pipeline
All steps, except for step 5 (Differential expression) were carried out in the IBU cluster. Step 5 can be run locally. 
It is recommended to verify the input/output file paths at the beginning of each script. 

## Step 1. Read quality and statistics
Create directory for reads and reference genomes and link them locally

	source scripts/00_Link_Input_Files.sh
Count reads and asses Quality of all samples/replicates:

	source scripts/01a_CountReads.sh
 	sbatch scripts/01b_doFASTQC.sh
Generate a grouped quality report from the individual FastQC analyisis:
	
 	sbatch scripts/01c_doMultiQC.sh
 
FastQC and MultiQC reports can be downloaded to inspect in the local browser:

	#Example: scp <user>@binfservms01.unibe.ch:/data/users/jvaleriano/rna_seq/QC/*.html ~/Desktop/RNA.SEQ/FASTQC

## Step 2. Reads mapping
The indices were downloaded from the Hisat documentation: 

 	cd reference_genome/
	wget https://genome-idx.s3.amazonaws.com/hisat/hg38_genome.tar.gz 
	tar -xzf hg38_genome.tar.gz ; cd ../

Align to reference genome usign HISAT2, then Use Samtools convert to bam, sort and index:
	
 	sbatch scripts/02a_HISAT2_align_to_bam.sh
Asses quality of resulting alignment, and run experiment to confirm strandedness
	
 	sbatch scritps/02b_alignment_QC.sh

## Step 3. Transcriptome assembly
Use StringTie to create a reference-guided transcriptome assembly based on the RNA-seq for each sample
	
 	sbatch scripts/03_StringTie_assemble.sh

Merge the .gtf output files from all individual replicates into one meta-assembly .gtf file

	sbatch scripts/04_StringTie_merge.sh

Count the total number of exons, transcripts and genes, and single exon transcripts and genes for quality check 

	source scripts/05_counting_tr_genes.sh 

Create a transcript to genes table for downstream analyisis (Sleuth diff expression)

	source scripts/06_Transcript_to_Gene.sh

## Step 4. Quantification
Create an fasta file from the transcript assembled on the previous step

	sbatch scripts/07_fasta_from_gtf.sh

Build an index from our transcripts

	sbatch scripts/08_Kallisto_index.sh

Quantify with kallisto 

	sbatch scripts/09_Kallisto_quant.sh

As a quality check, verify that all the TPM add up to 1M in all samples

	sbatch scripts/10_QC_tpm_addition.sh

## Step 5. Differential Expression
Run statistic tests on the quantification to find differentially expressed genes at transcript and gene level
This step was run locally on R studio. The input files can be found in this repository (R_sleuth input), or in the IBU cluster:

 	/data/users/jvaleriano/lncRNA/R_Sleuth_input
	
 Rscript: scripts/11_Diff_Expression_Sleuth.R

## Step 6. Integrative analysis 
Create a set of bed files from the merged assembly gtf file with the novel and annotated genes/transcripts

	sbatch scripts/12_create_bed_from_gtf.sh
Use bedtools to find intergenic novel genes, and to check if they overlap with annotated 5' and 3' ends
	
 	sbatch scripts/13_intersect_bedtools.sh
Asses coding potential score for novel genes
	
 	sbatch scripts/14_protein_coding_potential.sh

Create a summary file with the statistics from previous steps 
	
 	sbatch scripts/15_statistics_step6.sh
Create a summary table with all the data generated for novel genes

	sbatch scripts/16_summary.sh


# Cluster paths to results: 

Read Mapping; BAM Files for every replicate:

	/data/users/jvaleriano/lncRNA/02_output_HISAT2/sorted_3_2_alignment.bam
	/data/users/jvaleriano/lncRNA/02_output_HISAT2/sorted_3_4_alignment.bam
	/data/users/jvaleriano/lncRNA/02_output_HISAT2/sorted_3_7_alignment.bam
	/data/users/jvaleriano/lncRNA/02_output_HISAT2/sorted_P1_alignment.bam
	/data/users/jvaleriano/lncRNA/02_output_HISAT2/sorted_P2_alignment.bam
	/data/users/jvaleriano/lncRNA/02_output_HISAT2/sorted_P3_alignment.bam

Transcriptome assembly (meta-assembly GTF file):

	/data/users/jvaleriano/lncRNA/03_output_StringTie/all_alignments.gtf

Transcript and Gene expression table in TPM:

	/data/users/jvaleriano/lncRNA/04_output_quant/Transcript_abundance_table.csv

Results for differential expression analysis at the transcript and gene level: 

	/data/users/jvaleriano/lncRNA/05_output_Differential_Expression/significant_tl.csv
	/data/users/jvaleriano/lncRNA/05_output_Differential_Expression/significant_gl.csv

Statistics summary for Integrative Analysis:

	/data/users/jvaleriano/lncRNA/06_output_int_analysis/int_analysis_stats.txt

Summary table of results for novel genes:	

	/data/users/jvaleriano/lncRNA/06_output_int_analysis/summary.tsv

Novel lncRNA candidates:	

	/data/users/jvaleriano/lncRNA/06_output_int_analysis/lncRNA_candidates.tsv
