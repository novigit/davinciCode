#!/usr/bin/perl -w
use strict;

die "usage: quast_extracter.pl <quast report file> <out file>\n" unless @ARGV == 2;

open IN, "<$ARGV[0]";

my $assembly_id;
my $contigs;
my $total_length;
my $largest_contig;
my $n50;
my $genes;
my @metrics;
my %hash;

while (<IN>) {

    if (/\#{6}\s\S+\_(K\d+)/) {
	$assembly_id = $1;
#	print "$assembly_id\n";
    }
    if (/^\#\scontigs\s\(\>= 0 bp\)\s+(\d+)/) {
	$contigs = $1;
#	print "$contigs\n";
	push @metrics, $contigs;
    }
    if (/^Total length \(\>= 0 bp\)\s+(\d+)/) {
	$total_length = $1;
#	print "$total_length\n";
	push @metrics, $total_length;
    }
    if (/^Largest contig\s+(\d+)/) {
	$largest_contig = $1;
#	print "$largest_contig\n";
	push @metrics, $largest_contig;
    }
    if (/^N50\s+(\d+)/) {
	$n50 = $1;
#	print "$n50\n";
	push @metrics, $n50;
    }
    if (/\(unique\)\s+(\d+)/) {
	$genes = $1;
#	print "$genes\n";
	push @metrics, $genes;
#	foreach my $metric (@metrics) {print "$metric\n"};
	@{$hash{$assembly_id}} = @metrics;
#	print "$hash{$assembly_id}[0]\n";
	undef @metrics;
    }
}

close IN;

open OUT, ">$ARGV[1]";

printf OUT ("%-10s %-10s %-10s %-10s %-10s %-10s", "K", "\#Contigs", "Total", "Max\_Contig", "N50", "\#Genes");
print OUT "\n";

foreach my $key (sort keys %hash) {
    printf OUT ("%-11s", "$key");
    for (my $i=0; $i < @{$hash{$key}}; $i++) {
	printf OUT ("%-11s", "$hash{$key}[$i]");
    }
    print OUT "\n";
}
 
close OUT;

