#!/usr/bin/perl -w
use strict;
use Getopt::Long;

die "usage: header_fixer.pl -i|--in <refseq|prodigal> -o|--out <refseq-famcl|prodigal-famcl> <fasta>\n" unless @ARGV == 5;

# YOU CAN PROBABLY EASILY DO THIS WITH SED
# Right now its just from refseq header to faMCL matching header, but could be cool to expand this script into a generic header fixer script. For example, 
# header_fixer.pl <format 1> <format 2> -flag for format1 to format2.

my ($in, $out);
GetOptions(
    'i|in=s'  => \$in,
    'o|out=s' => \$out
);

open IN, "<$ARGV[0]";
while (<IN>) {
    if (/^>/) {

	if ($in eq 'refseq'   && $out eq 'refseq-famcl')   {
	    my @line = split '\|', $_;
	    my ($gi,$acc) = ($line[1], $line[3]);
	    print "\>$gi\|$acc\n";
	}

	if ($in eq 'prodigal' && $out eq 'prodigal-famcl') {
	    my @line = split '#', $_;
	    my $header = $line[0];
	    print "$header\n";
	}

    }
    else {
	print $_;
    }
}
close IN;
