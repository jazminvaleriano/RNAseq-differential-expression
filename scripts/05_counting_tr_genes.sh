#!/usr/bin/env bash

MERGED_GTF_FILE=03_output_StringTie/all_alignments.gtf
OUTPUT_FILE="03_output_StringTie/counts_summary.txt"

# Total count of genes
echo "Total number of genes:" >> "$OUTPUT_FILE"
awk '$3 == "transcript" {print $10}' "$MERGED_GTF_FILE" | sort | uniq -c | wc -l >> "$OUTPUT_FILE"

# Total count of exons
echo "Total number of exons:" >> "$OUTPUT_FILE"
awk '$3 == "exon" {print $3}' "$MERGED_GTF_FILE" | wc -l >> "$OUTPUT_FILE"

# Total count of transcripts
echo "Total number of transcripts:" >> "$OUTPUT_FILE"
awk '$3 == "transcript" {print $3}' "$MERGED_GTF_FILE" | wc -l >> "$OUTPUT_FILE"

# Count of Single Exon Transcripts
echo "Number of Single Exon Transcripts:" >> "$OUTPUT_FILE"
awk '$3 == "exon" {print $12}' "$MERGED_GTF_FILE" | sort | uniq -c | awk '$1 == 1' | wc -l >> "$OUTPUT_FILE"

# Count of Single Exon Genes
echo "Number of Single Exon Genes:" >> "$OUTPUT_FILE"
awk '$3 == "transcript" {print $14}' "$MERGED_GTF_FILE" | sort | uniq -c | awk '$1 == 1' | wc -l >> "$OUTPUT_FILE"

# Count of Novel transcripts
echo "Number of Novel transcripts:" >> "$OUTPUT_FILE"
awk '$3 == "transcript" {print}' "$MERGED_GTF_FILE" | uniq | awk '$9=="gene_id" && $13!="gene_name" {print}' | wc -l >> "$OUTPUT_FILE"

# Count of Novel exons
echo "Number of Novel exons:" >> "$OUTPUT_FILE"
awk '$3 == "exon" {print}' "$MERGED_GTF_FILE" | awk '$9=="gene_id" && $15!="gene_name" {print}' | wc -l >> "$OUTPUT_FILE"


