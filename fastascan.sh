#!/bin/bash

## Midterm3 assignment
## Script to analyze fasta/fa files in a directory and generate reports.
## current version: fastascan.sh

####### Firstly: check the arguments

##### Arguments check
# Argument 1 check (folder)
if [[ -z $1 ]]; then
    folder=.   # If folder argument is empty, default to current folder
elif [[ ! -d $1 ]]; then
    echo "Error: '$1' is not a correct directory."
    exit 1
else
    folder=$1
fi
# Argument 2 check (number of lines)
if [[ -z $2 ]]; then
    N=0   #If number argument is empty, default to 0
elif [[ ! $2 =~ ^[0-9]+$ ]]; then
    echo "Error: '$2' is not a correct number."
    exit 1
else
    N=$2
fi
    
    
####### Secondly: create the report

##### Overall information
### Print the title
echo "############### Report of fasta/fa files in "$folder" folder ###############"

### Print the total number of files
# Define variables
fastafiles=$(find "$folder" -name "*.fasta" -o -name "*.fa" )    # Find fasta/fa files in folder and sub-folders
total_files=$(echo "$fastafiles" | wc -l)   # Count total files.
# Print the total number of files
echo "The total number of fasta/fa files in "$folder" folder is "$total_files""

### Calculate the total number of unique fasta IDs
total_IDs=$(cat $fastafiles | awk '/^>/{print $0}' | sort | uniq | wc -l)  
echo "The total number of unique fasta IDs is "$total_IDs""
echo    #Print an empty line of so that the overall information and the information of each file is directly divided.

##### Information for ecach file
for i in $fastafiles; do 
    
    ### Print the title
    echo "========== $i =========="
   
    ### Check whether the file a symlink or not
    if [[ -L "$i" ]]; then
	echo "Symlink: Yes"
    else
	echo "Symlink: No"
    fi
    
    ### Calculate the total number of sequences inside
    total_seqs=$(grep ">" "$i" | wc -l)
    echo "Number of sequences: $total_seqs"
    
    ### Calculate the total sequence length in each file(gaps "-", spaces, newline characters should not be counted)
    total_length=$(awk '/^[^>]/ {gsub(/[- ]/, ""); seq=seq $0} END {print length(seq)}' "$i")
    echo "Sequence length is: $total_length"
    
    ### Determine if the file is nucleotide or amino acids
    seqs=$(grep -v '>' "$i")
    # Define sets of characters
    nucleotide_chars="ATGCNatgcn"
    amino_acid_chars="ACDEFGHIKLMNPQRSTVWYacdefghiklmpnqrswvyx"
    # Check if the sequence contains any characters outside the nucleotide set
    if [[ "$seqs" =~ [^$nucleotide_chars] ]]; then
        echo "Type: amino acids file"
    else
        echo "Type: nucleotide file"
    fi
    
    ### Print some lines of the file
    echo    #Print an empty line of so that the information of each file is directly divided.
    file_lines=$(wc -l < "$i")
    if [[ $N -gt 0 ]]; then    #If the number of lines is 0, no printing is required.
        if [[ $file_lines -le $((2 * N)) ]]; then    #If the file has 2N lines or fewer, then display its full content.
            echo "ALl content:"
            cat "$i"
        else
            echo "Summary of content:"
            head -n "$N" "$i"
            echo "..."
            tail -n "$N" "$i"
        fi
    fi
    echo    #Print an empty line of so that the information of each file is directly divided.
done
