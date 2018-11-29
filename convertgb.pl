#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Bio::SeqIO;#install module with cpan

######################################################################################
# This script is to  convert a GenBank file to a FASTA or EMBL file                  #
# Usage: ./convertgb.pl -i [input_file] -f [fasta|embl] –o [output_file]             #
######################################################################################

my $inputfile;
my $format;
my $outputfile;
GetOptions ("i=s" => \$inputfile,
            "f=s"   => \$format,
            "o=s"  => \$outputfile)
or die("Error in command line arguments\n");#get input genebankn filename and filename and format of outputfile from command line

my $seq_in = Bio::SeqIO->new( -file   => "$inputfile",
                              -format => 'GenBank',
                            );

my $seq_out = Bio::SeqIO->new( -file   => ">$outputfile",
                               -format => $format,
                             );

# write each entry in the input file to the output file
while (my $inseq = $seq_in->next_seq) {
   $seq_out->write_seq($inseq);
}

exit;
