#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Bio::SearchIO;
use Bio::Tools::Run::StandAloneBlastPlus;#require install IPC::Run

#################################################################################################
# This script is to BLAST multiple sequences against a sequence database                        #
# Usage: ./blastTop2.pl -i [input_file] -d [sequence_db.fa] -m [blast_method] -o [output_file]  #
#################################################################################################

my $inputfile;
my $database;
my $method;
my $outputfile;
GetOptions ("i=s" => \$inputfile,
            "d=s"  => \$database,
            "m=s"  => \$method,
            "o=s"  => \$outputfile)
or die("Error in command line arguments\n");


my $factory = Bio::Tools::Run::StandAloneBlastPlus->new(-db_name => 'mydb',
                                                        -db_data =>$database,
                                                        -create => 1);#Given a StandAloneBlastPlus factory
my $blast_report = $factory->$method(-query => $inputfile,
                                     -outfile => 'output');#Name the blast output file, method here choose balst

my $searchio = Bio::SearchIO->new(-format =>'blast',
                                  -file=>'output');
open(OP,">$outputfile") or die "can not open $outputfile\n";

while ( my $result = $searchio->next_result() ) {
    my $i=0;
    my @hits = $result->hits;
    for my $hit (sort {$b->bits <=> $a->bits} @hits){
      while(my $hsp = $hit->next_hsp){
      if($i<2){
      print OP "Query:".$result->query_name."\t"."Hit:",$hit->name,"\t"."Length:",$hsp->length('total')."\t"."percent_identity:".$hsp->percent_identity."\n";
      $i++;
    }}
 }#sorting in Bio::SearchIO; sorts hits according to their bit scores; print the top two hits with biggest bit scores;
}

close OP;
$factory->_register_temp_for_cleanup('mydb');
$factory->_register_temp_for_cleanup('output');
$factory->cleanup;#clean up temp files


exit;
