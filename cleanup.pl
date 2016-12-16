#!/usr/bin/perl

## Filters out non cyrillic words from input file
## Removes non letter character at the beginning and the end of a word
## i.e (Соколова) -> Соколова
## Use of Unicode Properties
## input file : word tab occ

use strict;
use warnings;
binmode(STDOUT, ":utf8");

my $usage = "perl $0 input_file\n";
die $usage unless @ARGV == 1 && -f $ARGV[0];


open(FILE, "<:encoding(UTF8)", $ARGV[0]) || die $!;
while(<FILE>){
    my @cols = split(/\t/, $_);
    if($cols[0] =~ /\p{Script:Cyrillic}+/){
      $cols[0] =~ s/^\P{L}//g;
      $cols[0] =~ s/\P{L}$//g;
      print "$cols[0]\t$cols[1]";
  }
}
close(FILE);
