#!/usr/bin/env bash
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4G
#SBATCH --time=01:00:00
#SBATCH --partition=pall

OUTPUT_DIR=/data/users/jvaleriano/lncRNA/06_output_int_analysis
FILE_DIF_EXP=/data/users/jvaleriano/lncRNA/05_output_Differential_Expression/novel_wt_transcript.csv
FILE_NOVEL_COORDINATES=/data/users/jvaleriano/lncRNA/06_output_int_analysis/novel.bed
FILE_INTERGENIC=/data/users/jvaleriano/lncRNA/06_output_int_analysis/novel_intergenic.bed
FILE_POLYA=/data/users/jvaleriano/lncRNA/06_output_int_analysis/overlap3_polyA.bed
FILE_TSS=/data/users/jvaleriano/lncRNA/06_output_int_analysis/overlap5_TSS.bed
FILE_CPAT=/data/users/jvaleriano/lncRNA/06_output_int_analysis/protein_coding_potential.dat

#Preprocess the input files from Sleuth, CPAT
tail -n +2 $FILE_DIF_EXP | awk -F ',' '{print $1, $2, $5, $6, $7}' | tr -s ' ' | tr -d '"'| tr ' ' '\t'| sort > summary.de.tmp
awk -F '\t' '{print $4, $1, $2, $3, $6}' $FILE_NOVEL_COORDINATES |tr ' "' '\t' | sort -n > sorted.coords.tmp
tr '::' '\t' < $FILE_CPAT | awk -F '\t' '{print $1 "\t" $7}'| sort > tabbed.pcp.tmp

# Join the coordinates and Sleuth results (will only conserve the transcripts included in Sleuth analysis)
join --nocheck-order -t$'\t' sorted.coords.tmp summary.de.tmp  -a 2 | sed 's/ $//' > summary.tsv

# Add a column to indicate if the transcrips are listed in the results for Intergenic, 3' poly A, 5' TSS 
awk -F'\t' 'NR==FNR{a[$4]=$4;next} {print $0 "\t" ($1 in a ? "intergenic" : "not_intergenic")}' $FILE_INTERGENIC summary.tsv > temp && mv temp summary.tsv
awk -F'\t' 'NR==FNR{a[$4]=$4;next} {print $0 "\t" ($1 in a ? "poly_a" : "no_poly_a")}' $FILE_POLYA summary.tsv > temp && mv temp summary.tsv
awk -F'\t' 'NR==FNR{a[$4]=$4;next} {print $0 "\t" ($1 in a ? "TSS_match" : "no_TSS_match")}' $FILE_TSS summary.tsv > temp && mv temp summary.tsv

# Add the protein coding potential score
join --nocheck-order -t$'\t' summary.tsv tabbed.pcp.tmp > temp && mv temp summary.tsv

# Add heder row
echo -e "target_id\tchr\tstart\tend\tstrand\tgene_id\tDE_pval\tDE_qval\tlog2fold_change\tintergenic\t3_poly_A_match\t5_TSS_match\tcoding_potential" | cat - summary.tsv > temp && mv temp summary.tsv

# Remove temporary files and save summary in output folder
rm *tmp
mv summary.tsv ${OUTPUT_DIR}





