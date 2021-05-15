# Bioinformatics_NGS


# Includes Perl Scripts for: 
1. Coverage.pl 
- find overlaps in a BED file.
- ```Usage: ./coverage.pl <input bed file name> <output file name> ```

FindOrtholog.pl - find orthologous genes using BLAST 

Random_Sequence.sh - Generate random DNA sequences

SNP-Calling.sh - SNP-calling pipeline

all2fasta.pl - convert EMBL/MEGA/PIR/FASTQ format file that is given to it into a FASTA file

blastTop2.pl - BLAST multiple sequences against a sequence database 

convertgb.pl - convert a GenBank file to a FASTA or EMBL file 

countKmers.pl - read in a FASTA file and computes the counts of all k-mers 
Usage: ./countKmers.pl <input file name> <length of k-mer> 

nwAlign.pl - align two sequence by Needleman-Wunsch (NW) algorithm 
Usage: ./nwAlign.pl <input FASTA file 1> <input FASTA file 2>   
