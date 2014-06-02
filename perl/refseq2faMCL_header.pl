#!/usr/bin/perl -w
use strict;

die "usage: header_fixer.pl <refseq_header_fasta> <faMCL_header_fasta>\n" unless @ARGV == 2;

# Right now its just from refseq header to faMCL matching header, but could be cool to expand this script into a generic header fixer script. For example, 
# header_fixer.pl <format 1> <format 2> -flag for format1 to format2.

my ($refseq, $famcl) = @ARGV;

open IN, "<$refseq";
while (<IN>) {
    if (/^>/) {
	my @line = split '\|', $_;
	my ($gi,$acc) = ($line[1], $line[3]);
	print OUT "\>$gi\|$acc\n";
    }
    else {
	print OUT $_;
    }
}
close IN;
