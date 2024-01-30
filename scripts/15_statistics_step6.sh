#!/usr/bin/env bash
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2G
#SBATCH --time=01:00:00

INT_ANALYSIS_DIR=/data/users/jvaleriano/lncRNA/06_output_int_analysis

cd $INT_ANALYSIS_DIR

# Count of novel intergenic transcripts
novel_transcripts=$(wc -l < novel.bed)
novel_intergenic_transcripts=$(wc -l < novel_intergenic.bed)
percent=$(echo "scale=2; ($novel_intergenic_transcripts/$novel_transcripts) * 100" | bc)
echo "Total novel transcripts: $novel_transcripts" > int_analysis_stats.txt
echo "Number of novel intergenic transcripts : $novel_intergenic_transcripts" >> int_analysis_stats.txt
echo "Percentage of novel intergeneic transcripts: $percent %" >> int_analysis_stats.txt

# Correct 3' and 5' annotation
correct_3=$(wc -l < overlap3_polyA.bed)
percent_3=$(echo "scale=2; ($correct_3/$novel_transcripts) * 100" | bc)
correct_5=$(wc -l < overlap5_CAGE.bed)
percent_5=$(echo "scale=2; ($correct_5/$novel_transcripts) * 100" | bc)
echo "Number of correctly annotated novel transcripts at 3': $correct_3" >> int_analysis_stats.txt 
echo "Percentage of correctly annotated novel transcripts at 3': $percent_3 %" >> int_analysis_stats.txt
echo "Number of correctly annotated novel transcripts at 5': $correct_5" >> int_analysis_stats.txt
echo "Percentage of correctly annotated novel transcripts at 5': $percent_5 %" >> int_analysis_stats.txt

# Protein coding potential for novel transcripts (cutoff = 0.364)
# [A threshold of 0.364 gave the highest sensitivity and specificity (0.966 for both) for human data.]
protein_coding=$(awk '$5 >= 0.364' $INT_ANALYSIS_DIR/protein_coding_potential.dat | wc -l)
percent_coding=$(echo "scale=2; ($protein_coding/$novel_transcripts) * 100" | bc)
echo "Number of protein coding novel transcripts: $protein_coding" >> int_analysis_stats.txt
echo "Percentage of protein coding novel transcripts: $percent_coding %" >> int_analysis_stats.txt

cd ../