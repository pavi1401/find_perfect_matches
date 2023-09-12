#!/bin/bash

# Check for the correct number of command-line arguments
if [ "$#" -ne 3 ]; then
	    echo "Usage: ./find_perfect_matches.sh <query file> <subject file> <output file>"
	        exit 1
fi

# Assign command-line arguments to variables
query_file="$1"
subject_file="$2"
output_file="$3"

# Run BLAST and capture the output
blast_output=$(blastn -query "$query_file" -subject "$subject_file" -outfmt "6 qseqid sseqid pident" 2>/dev/null)

# Check if BLAST returned an error
if [ $? -ne 0 ]; then
	    echo "BLAST failed. Please make sure BLAST is installed and configured correctly."
	        exit 1
fi

# Use awk to filter perfect matches (100% identity) and count them
awk '$3 == 100 { print }' <<< "$blast_output" > "$output_file"
num_perfect_matches=$(awk '$3 == 100 { count++ } END { print count }' <<< "$blast_output")

# Print the number of perfect matches to stdout
echo "Number of perfect matches: $num_perfect_matches"
:
