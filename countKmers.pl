#!/usr/bin/perl
use strict;
use warnings;

###########################################################################################
#	  Script to read in a FASTA file and computes the counts of all k-mers                  #
# 	# Usage: ./countKmers.pl <input file name> <length of k-mer>                          #
###########################################################################################

my($filename,$kmer)=@ARGV;#get input filename and length of kmer from command line
open(IP,$filename)or die "Unable to open $filename: $!";
my @file=<IP>;
shift @file;#remove the first line of FASTA file
my $seq=join('',@file);
$seq=~s/\n//g;

my %hash;#for each sequence with a length of kmer, make it a key for the hash.
for(my $i=0;$i<length($seq)-$kmer;$i++){
  my $dna=substr($seq,$i,$kmer);
  $hash{$dna}+=1;
}#count the occurrence times of each keys by reading through the sequence and store it as values of keys

foreach my $key (sort { $hash{$a} <=> $hash{$b} } keys(%hash)){
    print "$key\t$hash{$key}\n";
}#sort it by values and print each key and its value
close IP;
exit;
