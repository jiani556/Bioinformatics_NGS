#!/usr/bin/perl
use strict;
use warnings;

############################################################################################
#	 Script to convert EMBL/MEGA/PIR/FASTQ format file that is given to it into a FASTA file #
# # Usage: ./all2fasta.pl <input file name> 	                                             #
############################################################################################

my $filename=$ARGV[0];#read filename from command line
open(IP,$filename)or die "Unable to open $filename: $!";
if($filename=~m/(.*)\..+$/){
   $filename=~s/(.*)\..+$/$1\.fna/;
   open(OP,">$filename")or die "Unable to open $filename: $!";
 }
else{open(OP,">$filename.fna")or die "Unable to open $filename: $!";}
#if input file has extension repalce it with "fna" esle add an extention 'fna"

my $first_line=<IP>;#recoginze input file type by first line
if($first_line=~m/^@/){
  print "this is a FASTQ file\n";
  fq_to_fa();
}
elsif($first_line=~m/^ID/){
  print "this is a EMBL file\n";
  embl_to_fa();
}
elsif($first_line=~/^LOCUS/) {
  print "this is a GenBank file\n";
  gb_to_fa();
}
elsif($first_line=~m/^#mega/) {
  print "this is a MEGA file\n";
  mega_to_fa();
}
elsif($first_line=~m/^>.{2};/) {
  print "this is a PIR file\n";
  pir_to_fa();
}
else {print "error:unrecognizable format";exit;}


sub embl_to_fa {
my ($acc,$len,$de);
while(<IP>){
  my $line=$_;
  chomp $line;
  my @element= split(/\s+/,$line);
  if ($line=~m/^AC/){
     $acc=$element[1];
     next;
   }#line start with AC contain acc information
  elsif ($line=~m/^DE/){
     $line =s/^\s+//;
     $line =s/\s+$//;
     $de=$line;
   }#line start with DE contain description information
  elsif ($line=~m/^SQ/){
     $len=$element[2];
     $acc=~s/;//;
     print OP ">$acc|acc=$acc|descr=$de|len=$len\n";
   }#line start with SQ followed by sequences
  elsif ($line=~m/^\s+/){
    $line =~ s/\s//g;
    $line =~ s/\d+//g;
    $line =~ tr/[a-z]/[A-Z]/;
    print OP $line."\n";
  }}
}#embl fotmat to fa

sub fq_to_fa {
my @first_line=split(/\s+/,$first_line);
my $id=$first_line[0];
while(<IP>){
  my $line=$_;
  chomp $line;
  $id=~s/@/</;
  if($line=~m/^[ATCG]+/){
    print OP "$id\n$line\n";
  }
  elsif($line=~m/^@/){
  my @line=split(/\s+/,$line);
  $id=$line[0];
  }
}
}#fastq format to fasta

sub gb_to_fa {
  my $de;
  my @first_line=split(/\s+/,$first_line);
  my $id=$first_line[1];
  my $len=$first_line[2];
  while(<IP>){
    my $line=$_;
    chomp $line;
    if ($line=~m/^DEFINITION/){
       my $subline=substr($line,11,);
       $subline =~s/^\s+//;
       $subline =~s/\s+$//;
       $de=$subline;
       next;
     }#line start with DEFINITION contain description information
    elsif($line=~m/^LOCUS/){
      my @line=split(/\s+/,$line);
      $id=$line[1];
      $len=$line[2];
    }#line start with LOCUS contain location information
    elsif($line=~m/^ORIGIN/){
      print OP ">$id|acc=$id|descr=$de|len=$len\n";
    }
    elsif($line=~m/^\s+\d+/g){
      $line=~s/\s*//g;
      $line=~s/\d*//g;
      $line=~tr/[a-z]/[A-Z]/;
      print OP "$line\n";
    }#line start with spaces followed digits contain sequences
  }
}#genebank format to fasta

sub mega_to_fa {
  my %hash;
  my $id;
  while(<IP>){
    my $line=$_;
    chomp $line;
    if ($line=~m/^#/){#lines start with # sign contain ids
      my @line=split(/\s+/,$line);
      $line[0]=~s/#/>/;
      $id=$line[0];
      my $seq=$line[1];
      if($seq){
      $seq=~s/\s*//g;
      $seq=~tr/[a-z]/[A-Z]/;
      push(@{$hash{$id}},$seq);
      }
    }
      elsif($line=~m/^[ATCG]+$/){
      $line=~s/\s*//g;
      $line=~tr/[a-z]/[A-Z]/;
      push(@{$hash{$id}},$line);
    }
  }

foreach my $key(sort keys %hash){
    my $seq=join('',@{$hash{$key}});
    print OP ">$key\n$seq\n";
  }
}#mega to fasta eatablished a hash to store sequences of different IDs


sub pir_to_fa {
my @first_line=split(/;/,$first_line);
my $id=$first_line[1];
chomp $id;
while(<IP>){
  my $line=$_;
  chomp $line;
  if($line=~m/^[A-Z][a-z]+/){
  $line=~s/^\s*//;
  $line=~s/\s*$//;
  print OP ">$id|descr=$line\n";
  }
  if($line=~m/^[A-Z]+$/){
    print OP "$line\n";
  }
  elsif($line=~m/^>.{2};/){
  my @line=split(/;/,$line);
  $id=$line[1];
  }
}
}#PIR format to fasta


close IP;
close OP;
exit;
