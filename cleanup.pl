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

my $ASPELL_FILE = "./ru-aspell-wordlist.txt";

## reads russian from aspell list
## args : aspell file (ru-aspell-wordlist.txtru-aspell-wordlist.txt)
## returns a hash of words (key: word, value: none). hash if used for lookup
sub russian_words{
    my $russian_file = shift;
    my %words_ru;
    open(FILE, "<:encoding(UTF8)", $russian_file) || die $!;
    while(<FILE>){
	my $word = $_;
	chomp $word;
	$word =~ s/(\p{L}+)(\/[A-Za-z])?/$1/;
	$words_ru{$word} = "";
    }
    close FILE;

    return %words_ru;
}

my %words_ru = russian_words($ASPELL_FILE);

open(FILE, "<:encoding(UTF8)", $ARGV[0]) || die $!;
while(<FILE>){
    my @cols = split(/\t/, $_);
    if($cols[0] =~ /\p{Script:Cyrillic}+/){
	$cols[0] =~ s/^\P{L}//g;
	$cols[0] =~ s/\P{L}$//g;
	unless(exists($words_ru{$cols[0]})){
	    print "$cols[0]\t$cols[1]";
	}
    }
}
close(FILE);
