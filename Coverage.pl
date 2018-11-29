#!/usr/bin/env perl

use strict;
###########################################################################################
#				Script to finding overlaps in a BED file.                                         #
#				Usage: ./coverage.pl <input bed file name> <output file name>                     #
# 			./coverage.pl input.bed output3                                                   #
###########################################################################################

my $inFileName = $ARGV[0];
my $outFileName = $ARGV[1];

open(my $fh, $inFileName) or die "Can't open $inFileName! $!";
chomp(my @contents = <$fh>);
close($fh);

my (@splitLines, %terminals);

foreach (@contents) {
  @splitLines = split("\t", $_);
  $terminals{$splitLines[0]}{$splitLines[1]} = 0;
  $terminals{$splitLines[0]}{$splitLines[2]} = 0;
}

my (%sortTerminals, %preOutput);

foreach my $chr (sort keys %terminals) {
  my @tempSort = sort keys %{$terminals{$chr}};
  $sortTerminals{$chr} = \@tempSort;
}


foreach (@contents) {
  @splitLines = split("\t", $_);
   foreach my $chr (sort keys %sortTerminals){
     if ($chr!=@splitLines[0]){last;}
     my @tpsort=@{$sortTerminals{$chr}};

     for(my $i=0;$i<scalar @tpsort;$i++){
       if($tpsort[$i+1]<$splitLines[1]){next;}
       if($tpsort[$i]>$splitLines[2]){last;}
       if($tpsort[$i]>=$splitLines[1] && $tpsort[$i+1]<=$splitLines[2]){
         $preOutput{$chr}{$tpsort[$i]}{$tpsort[$i+1]}+=1;
       }
     }
   }
}

foreach my $chr (sort keys %preOutput){
  foreach my $start (sort keys $preOutput{$chr}){
    foreach my $end (sort keys $preOutput{$chr}{$start}){
        print $chr."\t".$start."\t".$end."\t".$preOutput{$chr}{$start}{$end}."\n";}}}

exit;
