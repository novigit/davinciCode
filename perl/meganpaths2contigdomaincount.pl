#!/usr/bin/perl -w
use strict;

die "usage:meganpaths2contigdomaincount.pl <megan path file> <out.tsv>", "\n" unless @ARGV == 2;

my ($in, $out) = @ARGV;

my $id;
my %count;
my @taxa = ('Archaea',
	    'Methanobacteria',
	    'Bacteria',
	    'Alphaproteobacteria',
	    'Eukaryota', 
	    'Viruses', 
	    'No hits');

open IN, "<$in";
while (<IN>) {
    chomp;
    my ($node) = split ';', $_;
    my @node = split '_', $node;
    my $id = join '_', @node[0..5];
    print $id, "\n";
    foreach my $taxon (@taxa) {
	$count{$id}{$taxon}++ if (/$taxon/);
    }

    $count{$id}{'Archaea'}--  if (/Methanobacteria/);
    $count{$id}{'Bacteria'}-- if (/Alphaproteobacteria/);
}
close IN;

open OUT, ">$out";
print OUT "NODE", "\t";
foreach my $taxon (@taxa) {print OUT $taxon, "\t"}
print OUT "\n"; 

foreach my $node (keys %count ) {
    print OUT $node, "\t"; 
    foreach my $taxon (@taxa) {
	if (exists $count{$node}{$taxon})   {print OUT $count{$node}{$taxon}}
	else                                {print OUT "0"}
	print OUT "\t";
    }
    print OUT "\n";
}
close OUT;


