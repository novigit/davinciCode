#!/usr/bin/perl -w
use strict;

# countBlastTaxids.pl [.blast] [categories.dmp] > out.tsv

# Requires tabular blast file with staxid

my ($dmp, $blast) = @ARGV;

my %hash;

open DMP, $dmp;
while (<DMP>) {
    chomp;
    my @line = split '\t', $_;
    my ($cat, $id) = ($line[0], $line[2]);
    # print $cat, "\t", $id, "\n";
    $hash{$id} = $cat;
}
close DMP;

my @domains = ('A', 'B', 'E', 'V', 'U');
my %count;

open BLAST, $blast;
while (<BLAST>) {
    chomp;
    my @line = split '\t', $_;
    my ($query,$taxids) = ($line[0], $line[-1]);
    my @taxids = split ';', $taxids;
    my $taxid = $taxids[0];
    # print $query, "\t", $taxa[0], "\n";
    
    foreach my $dom (@domains) {
	if (exists $hash{$taxid}) {
	    $count{$query}{$dom}++ if ($hash{$taxid} =~ /$dom/);
	}
	else {print STDERR "$query:\t$taxid is not available in categories.dmp\n"}
    }       
}
close BLAST;

print "CDS", "\t";
foreach my $dom (@domains) {print $dom, "\t"}
print "\n";

foreach my $query (keys %count) {
    print $query, "\t";
    foreach my $dom (@domains) {
	if (exists $count{$query}{$dom}) {print $count{$query}{$dom}}
	else                             {print "0"}
	print "\t";
    }
    print "\n";
}
