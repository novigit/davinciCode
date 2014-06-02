#!/usr/bin/perl -w
use strict;

my ($fasta, $dictionary) = @ARGV;
my %hash;

open DICT, "<$dictionary";
while (<DICT>) {
    chomp;
    my ($query, $replace) = split '\t', $_;
    # print $query, "\t", $replace, "\n";
    $hash{$query} = $replace;
}
close DICT;

open FASTA, "<$fasta";
while (<FASTA>) {
    my $line = $_;
    print $_ unless (/^>/);
    if (/^>/) {
	foreach my $key (keys %hash) {
	    $line =~ s/$key/$hash{$key}/ig;
	}
        print $line;
    }
}
close FASTA;

