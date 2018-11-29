#!/usr/bin/perl
use warnings;
use strict;

###########################################################################################
# This script is to find orthologous genes using BLAST                                    #
# Usage: ./findOrtholog.pl <input fasta file 1> <input fasta file 2> <output file name> n #
# "n" stands for sequence type "nucleotide"                                               #
# Usage: ./findOrtholog.pl <input fasta file 1> <input fasta file 2> <output file name> p #
# "p" stands for sequence type "protein"                                                  #
###########################################################################################

my ($seq1,$seq2,$output,$np)=@ARGV;#get filenames from command line
open(FILE1,$seq1)or die "Unable to open $seq1: $!";
open(FILE2,$seq2)or die "Unable to open $seq2: $!";
open(OP,">>$output") or die("could not open");

if($np eq "n"){
  system("makeblastdb -in $seq1 -parse_seqids -dbtype nucl -out DB1");#make database1 for first fasta file
  system("makeblastdb -in $seq2 -parse_seqids -dbtype nucl -out DB2");#make database2 for second fasta file
  system("blastn -query $seq2 -db DB1 -out output1.txt -outfmt 6");#blast database1 with second fasta file output format "6"
  system("blastn -query $seq1 -db DB2 -out output2.txt -outfmt 6");#blast database2 with first fasta file output format "6"
}
elsif($np eq "p"){
  system("makeblastdb -in $seq1 -parse_seqids -dbtype prot -out DB1");#make database1 for first fasta file
  system("makeblastdb -in $seq2 -parse_seqids -dbtype prot -out DB2");#make database2 for second fasta file
  system("blastp -query $seq2 -db DB1 -out output1.txt -outfmt 6");#blast database1 with second fasta file output format "6"
  system("blastp -query $seq1 -db DB2 -out output2.txt -outfmt 6");#blast database2 with first fasta file output format "6"
  }
else{print "\nIncorrect type of sequence\n";}

close FILE1;
close FILE2;

open(OP1,"output1.txt");
open(OP2,"output2.txt");

my @op1 = <OP1>;
my @op2 = <OP2>;

close OP1;
close OP2;

system("rm DB*");#delete all temp database files
system("rm output1.txt");#delete all output files
system("rm output2.txt");

my %hash_db1;#generate two hash to store blast result for two database
my %hash_db2;

for(my $i=0;$i<scalar @op1;$i++){
  my $output = substr($op1[$i],4);
  my @colunms = split("\t",$output);
  my $db1Q = $colunms[0];
  my $db1T = $colunms[1];
  $hash_db1{$db1Q} = $db1T;
}#query as keys , target as results

for(my $i=0;$i<scalar @op2;$i++){
  my $output = substr($op2[$i],4);
  my @colunms = split("\t",$output);
  my $db2Q = $colunms[0];
  my $db2T = $colunms[1];
  $hash_db2{$db2Q} = $db2T;
}#same as database1

foreach my $key(keys %hash_db1){
  my $og=$hash_db1{$key};
  if(!$hash_db2{$og}){next;}
  if($key eq $hash_db2{$og}){
    print OP $key,"\t", $hash_db1{$key},"\n";
  }
}
#for every keys in hash of detabase1, using its value as the key of dabtabase2's hash.
#they are matched if the key is equal to the value print it into outputfile.

close OP;

exit;
