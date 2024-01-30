# Differential expression analyisis, annotation and characterization of lncRNAs in lung cancer
In this project, two subpopulations of the common NSCLC line A549—paraclonal and parental— were analyzed with the goal of identifying the differentially expressed genes, and of further characterizing the unannotated genes, looking for candidates for novel lncRNAs. 

In brief, the pipeline consists of 3 major steps: 
- Assembly of RNA transcriptome
- Differential expression analysis
- Characterization of the resulting novel genes based on their genomic context, expression level and protein coding potential. 

The RNA libraries were prepared and sequenced by Tièche et al. DOI: 10.1016/j.neo.2018.09.008

This analysis was made as a final project for the RNA-sequencing course (467713-HS2023) at the University of Bern. 


## Cluster paths to deliverable files: 

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
