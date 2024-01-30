#!/usr/bin/env bash
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=1G
#SBATCH --time=00:05:00
#SBATCH --partition=pall

GTF_FILE='/data/users/jvaleriano/lncRNA/03_output_StringTie/all_alignments.gtf'
REFERENCE_GTF='/data/courses/rnaseq_course/lncRNAs/Project2/references/gencode.v44.annotation.gtf'
OUTPUT_DIR='/data/users/jvaleriano/lncRNA/04_output_quant'

# Create a .tsv file with a table mapping transcripts to genes for gene level differential expression analysis downstream.

# Extract columns 12, 10, and 14 from the meta assembly file for transcripts in chromosomes (column 1 matches "ch", and column 3 is "transcript").
# Remove semicolons and use tabs as separators
echo -e 'transcript_id\tgene_id\tgene_name' > $OUTPUT_DIR/transcripts.tsv
awk '$1 ~ /ch/ && $3 == "transcript" {print $12 "\t" $10 "\t" $14}' $GTF_FILE | sed 's/;//g' | sort >> $OUTPUT_DIR/transcripts.tsv

# Create a table with biotypes retrieved from the reference GTF file.
# Extract columns 12 and 14, remove semicolons, and use tabs as separators
echo -e 'transcript_id\tbiotype' > $OUTPUT_DIR/biotype.tsv
awk '$3 == "transcript" {print $12 "\t" $14}' $REFERENCE_GTF | sed 's/;//g'| sort >> $OUTPUT_DIR/biotype.tsv

# Join both tables (add gene_type as the 4th column from the reference genome GTF)
join --nocheck-order -t $'\t' -a 1 -a 2 -1 1 -2 1 $OUTPUT_DIR/transcripts.tsv $OUTPUT_DIR/biotype.tsv | sed 's/[[:blank:]]*$//'| tr -s ' ' > $OUTPUT_DIR/transcript_to_gene.tsv

# If the transcript was not associated to an annotated gene, the transcript id will be re assigned as gene id and name, under the assumption 
# that this is not an isoform, but a novel gene, and the biotype will be assigned as "novel"
awk 'BEGIN {OFS=FS="\t"} NF==2 {print $1, $1, $1, "\"novel\"" } NF!=2 {print $0}' $OUTPUT_DIR/transcript_to_gene.tsv > tmp && mv tmp $OUTPUT_DIR/transcript_to_gene.tsv
rm $OUTPUT_DIR/transcripts.tsv $OUTPUT_DIR/biotype.tsv








