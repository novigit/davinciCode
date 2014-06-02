#!/usr/bin/perl -w
use strict;

die "usage: quast_extracter.pl <quast report file> <out file>\n" unless @ARGV == 2;

open IN, "<$ARGV[0]";

my ($assembly_id, $assembly_type);
my ($contigs_0, $contigs_300, $contigs_600, $contigs_1000);
my ($total_0, $total_300, $total_600, $total_1000);
my $largest_contig;
my $n50;
my $genes;
my $gc;
my $ntN;

my @metrics;


while (<IN>) {

    if (/^\#{6}\s(\S+\s\-\s\S+).+(\s\-\s\S+)\s\#{6}$/) {
	$assembly_id = $1;
	$assembly_type = $2;
#	print "$assembly_id\n";
#	print "$assembly_type\n";
    }

    if (/^scaffolds/) {
	my @line = split '\t', $_;
	($contigs_0, $contigs_300, $contigs_600, $contigs_1000) = ($line[1], $line[2], $line[3], $line[4]);
	($total_0, $total_300, $total_600, $total_1000) = ($line[5], $line[6], $line[7], $line[8]);
	$largest_contig = $line[10];
	$gc = $line[12];
	$n50 = $line[13];
	$ntN = $line[15];
	$genes = $line[16];
    }

    if (/^contigs/) {
	my @line = split '\t', $_;
	($contigs_0, $contigs_300, $contigs_600, $contigs_1000) = ($line[1], $line[2], $line[3], $line[4]);
	($total_0, $total_300, $total_600, $total_1000) = ($line[5], $line[6], $line[7], $line[8]);
	$largest_contig = $line[10];
	$gc = $line[12];
	$n50 = $line[13];
	$ntN = $line[15];
	$genes = $line[16];
    }

}

close IN;

open OUT, ">$ARGV[1]";

print OUT "$assembly_id$assembly_type", "\t",
          "$contigs_0", "\t",
          "$total_0", "\t",
          "$contigs_300", "\t",
          "$total_300", "\t",
          "$contigs_600", "\t",
          "$total_600", "\t",
          "$contigs_1000", "\t",
          "$total_1000", "\t",
          "$largest_contig", "\t",
          "$n50","\t",
          "$gc","\t",
          "$ntN", "\t",
          "$genes","\n";
 
close OUT;

