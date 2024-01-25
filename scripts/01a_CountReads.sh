#!/bin/bash

# Make a list with FASTQ files

ls reads/ > reads.txt

# Count the reads on each file (As Fastq format uses 4 lines per read, we divide the line count by 4)

mkdir 01_output_counts

while read -r file || [[ -n "$file" ]]; do
    count=$(zcat "reads/$file" | wc -l)
    reads=$((count / 4))
    echo "File $file has $reads reads."
done < reads.txt >> output_counts/read_counts.txt 

rm reads.txt
