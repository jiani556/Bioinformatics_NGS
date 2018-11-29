#!/usr/bin/perl
use strict;
use warnings;

###########################################################################################
#	  Script to align two sequence by Needleman-Wunsch (NW) algorithm                       #
#		Perl script (nwAlign.pl) takes two FASTA files as input.                              #
# 	# Usage: ./nwAlign.pl <input FASTA file 1> <input FASTA file 2>                       #
###########################################################################################

my($file1,$file2)=@ARGV;
open(IP1,$file1)or die "Unable to open $file1: $!";
open(IP2,$file2)or die "Unable to open $file2: $!";
my @f1=<IP1>;
my @f2=<IP2>;
my $s1=join('',@f1);
$s1=~s/\n//g;
my $s2=join('',@f2);
$s2=~s/\n//g;

my @seq1=split('',$s1);
my @seq2=split('',$s2);
#store input sequences into arrays each base as an element.

my $match=1;
my $dismatch=-1;
my $gap=-1;#initialize the score for match dismatch and gap

my @matrix;
$matrix[0][0]{score}=0;
$matrix[0][0]{pointer}="start";#initialize the martrix

for(my $i=1;$i<=scalar @seq1;$i++){
    $matrix[$i][0]{score}=$gap*$i;
    $matrix[$i][0]{pointer}="up";
}#initilaize the frist raw of the martrix
for(my $j=1;$j<=scalar @seq2;$j++){
    $matrix[0][$j]{score}=$gap*$j;
    $matrix[0][$j]{pointer}="left";
}#initilaize the frist column of the martrix

#fill the martrix
for(my $i=1;$i<=scalar @seq1;$i++){
  for(my $j=1;$j<=scalar @seq2;$j++){
    my($diagonal,$up,$left);
    my $base1=$seq1[$i-1];
    my $base2=$seq2[$j-1];

    if($base1 eq $base2){$diagonal=$matrix[$i-1][$j-1]{score}+$match;}
    else{$diagonal=$matrix[$i-1][$j-1]{score}+$dismatch;}#if match add 1 if dismatch minus 1

    $left=$matrix[$i][$j-1]{score}+$gap;#left and up both means a gap, the score minus 1
    $up=$matrix[$i-1][$j]{score}+$gap;

    if($diagonal>=$up && $diagonal>=$left){
                $matrix[$i][$j]{score}=$diagonal;
                $matrix[$i][$j]{pointer}="diagonal";}
    elsif($left>$diagonal && $left>=$up){
                $matrix[$i][$j]{score}=$left;
                $matrix[$i][$j]{pointer}="left";}
    else{$matrix[$i][$j]{score}=$up;
         $matrix[$i][$j]{pointer}="up";}#select the biggest number for diagonal left and up
    }
}

my $pair1="";
my $pair2="";
my $sign="";
my $i=scalar @seq1;
my $j=scalar @seq2;
my $score=$matrix[$i][$j]{score};

while(1){
  if($matrix[$i][$j]{pointer} eq "start"){last;}#end the loop when traced back to start position which is matrix[0][0]
  elsif($matrix[$i][$j]{pointer} eq "diagonal"){
    $pair1=$seq1[$i-1].$pair1;
    $pair2=$seq2[$j-1].$pair2;
    if($seq1[$i-1] eq $seq2[$j-1]){
      $sign="|".$sign;}
    else{$sign=" ".$sign;}
    $i-=1;
    $j-=1;
  }#if pointer is diagonal i and j all need minus 1 to go to the diagonal position
  elsif($matrix[$i][$j]{pointer} eq "left") {
    $pair2=$seq2[$j-1].$pair2;
    $pair1="-".$pair1;
    $sign=" ".$sign;
    $j-=1;
  }#if pointer is left j needs minus 1 to go to the left position and a gap will exist in sequence1
  elsif($matrix[$i][$j]{pointer} eq "up"){
    $pair2="-".$pair2;
    $pair1=$seq1[$i-1].$pair1;
    $sign=" ".$sign;
    $i-=1;
  }#if pointer is up i needs minus 1 to go to the up position and a gap will exist in sequence2
}

print "\n$pair1\n$sign\n$pair2\nAlignment score:$score\n";

exit;
