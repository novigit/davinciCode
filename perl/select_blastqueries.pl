#!/usr/bin/perl -w
use strict;

die "usage: select_blastqueries.pl <blast> <assembly>\n" unless @ARGV >= 2;

my ($blast_in, $contigs) = @ARGV;

my %hash;
open NODES, "<", $contigs;
while (<NODES>) {
    chomp;
    if (/\>/) {
	my ($node) = $_ =~ /NODE\_(\d+)\_/;
	$hash{$node}++;
    }
}
close NODES;

open BLAST, "<", $blast_in;
my $print = 1;
while (<BLAST>) {
    if ($_ =~ m/Query=/) {
 	my ($node) = $_ =~ /NODE\_(\d+)\_/;
	if (exists $hash{$node}) {
	    $print = 1;
	}
	else {
	    $print = 0;
	}
    }
    print $_ if $print;
}
close BLAST;
