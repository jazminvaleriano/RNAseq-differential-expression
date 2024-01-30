#!/usr/bin/env bash
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=1G
#SBATCH --time=01:00:00

INPUT_GTF=/data/users/jvaleriano/lncRNA/03_output_StringTie/all_alignments.gtf
INT_ANALYSIS_DIR=/data/users/jvaleriano/lncRNA/06_output_int_analysis

#Create directory if it doesn't exist
mkdir -p $INT_ANALYSIS_DIR

#Extract all transcripts and convert to bed
awk '$3 == "transcript" {gsub(/[;"]/, "", $12) ; print $1"\t"$4"\t"$5"\t"$12"\t"$6"\t"$7}' $INPUT_GTF > $INT_ANALYSIS_DIR/all_transcripts.bed

#Filter annotated transcripts and save in a separate file
awk '$4 ~ /ENST/' ${INT_ANALYSIS_DIR}/all_transcripts.bed > ${INT_ANALYSIS_DIR}/annotated.bed

#Filter novel transcripts and save in a separate file 
awk '$4 !~ /ENST/' ${INT_ANALYSIS_DIR}/all_transcripts.bed > ${INT_ANALYSIS_DIR}/novel.bed

#create a 5´ bed file of novel transcripts with a window of +-50n, 
#correcting to 0 in case the coordinates end up being negative
awk -v window=50 '
{
    if ($6 == "+") {
        start = $2 - window - 1;
        end = $2 + window;
    } else if ($6 == "-") {
        start = $3 - window;
        end = $3 + window + 1;
    }
    printf("%s\t%d\t%d\t%s\t%s\t%s\n", $1, start, end, $4, $5, $6);
}' ${INT_ANALYSIS_DIR}/novel.bed > ${INT_ANALYSIS_DIR}/novel_5_CAGE_window.bed


#create a 3´ (polyA site) bed file of novel transcripts with a window of +-50n, 
#correcting to 0 in case the coordinates end up being negative
awk -v window=50 '
{
    if ($6 == "+") {
        start = $3 - window - 1;
        end = $3 + window;
    } else if ($6 == "-") {
        start = $2 - window;
        end = $2 + window + 1;
    }
    printf("%s\t%d\t%d\t%s\t%s\t%s\n", $1, start, end, $4, $5, $6);
}' ${INT_ANALYSIS_DIR}/novel.bed > ${INT_ANALYSIS_DIR}/novel_3_polyA_window.bed

