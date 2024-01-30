#!/usr/bin/env bash
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G
#SBATCH --time=05:00:00

INT_ANALYSIS_DIR=/data/users/jvaleriano/lncRNA/06_output_int_analysis
REFERENCES_DIR=/data/courses/rnaseq_course/lncRNAs/Project2/references

module load UHTS/Analysis/BEDTools/2.29.2

cd $INT_ANALYSIS_DIR

#Find the transcripts that do not overlap with the annotated transcripts (intergenic)
bedtools intersect -v -a novel.bed -b annotated.bed > novel_intergenic.bed

# 5 prime overlaps
bedtools intersect -wa -s -a novel_5_TSS_window.bed -b $REFERENCES_DIR/refTSS_v4.1_human_coordinate.hg38.bed > overlap5_CAGE.bed

# 3 prime overlaps
bedtools intersect -wa -s -a novel_3_polyA_window.bed -b $REFERENCES_DIR/atlas.clusters.2.0.GRCh38.96.bed > overlap3_polyA.bed

cd ../