#!/usr/bin/perl -w
use strict;

die "contig_size_cov_filter2.pl <domain count file> <out file> <length cutoff> <cov cutoff>\n" unless @ARGV == 4;

my ($in, $out, $length_cutoff, $cov_cutoff) = @ARGV;

open IN, "<$in";
open OUT, ">$out";

print OUT scalar <IN>;

while (<IN>) {
    chomp;
    my @line = split '\t', $_;
    my ($length, $cov) = ($line[1], $line[2]);
    print OUT $_, "\n" if ($length > $length_cutoff && $cov > $cov_cutoff); 
} 

close IN;
close OUT;
