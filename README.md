# Bioinformatics_NGS


# Includes Perl Scripts for: 
1. Coverage.pl 
- find overlaps in a BED file.
- ```Usage: ./coverage.pl <input bed file name> <output file name> ```

2. FindOrtholog.pl 
- find orthologous genes using BLAST 
- ```./findOrtholog.pl <input fasta file 1> <input fasta file 2> <output file name> -type [n or p] ```

3. Random_Sequence.sh 
- Generate random DNA sequences
- ```./Random_Sequence.sh -n [INT] -m [INT] ```

4. SNP-Calling.sh 
- SNP-calling pipeline
  - 1) Aligning genomic reads to a reference genome
  - 2) Processing the alignment file (conversion, sorting, alignment improvement)
  - 3) Calling the variants
  - You will be using the following tools for the development of the pipeline:
    - 1) bwaforthealignment:http://bio-bwa.sourceforge.net/
    - 2) samtools/HTSpackageforprocessingandcallingvariants:http://www.htslib.org/
    - 3) GATKforimprovingthealignment:https://software.broadinstitute.org/gatk/

5. all2fasta.pl 
- convert EMBL/MEGA/PIR/FASTQ format file that is given to it into a FASTA file
- ```./all2fasta.pl <input file name> ```	 

6. blastTop2.pl 
- BLAST multiple sequences against a sequence database 
- ```./blastTop2.pl -i [input_file] -d [sequence_db.fa] -m [blast_method] -o [output_file]  ```

7. convertgb.pl 
- convert a GenBank file to a FASTA or EMBL file 
- ```./convertgb.pl -i [input_file] -f [fasta|embl] –o [output_file]  ``` 

8. countKmers.pl 
- read in a FASTA file and computes the counts of all k-mers 
- ```Usage: ./countKmers.pl <input file name> <length of k-mer> ```

9. nwAlign.pl - align two sequence by Needleman-Wunsch (NW) algorithm 
- ```Usage: ./nwAlign.pl <input FASTA file 1> <input FASTA file 2> ```  
