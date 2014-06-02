#!/usr/bin/perl -w
use strict;

use Bio::SeqIO;

die "Usage: contig_size_cov_filter.pl <fasta-in> <fasta-out> <length-cutoff> <coverage-cutoff> <choose 'and' or 'or' filter>\n" unless @ARGV == 5;

my ($fa_in, $fa_out, $length_cutoff, $cov_cutoff, $type) = @ARGV;

my $in  = Bio::SeqIO->new(-format => 'fasta',
			  -file   => $fa_in);
my $out = Bio::SeqIO->new(-format => 'fasta',
			  -file   => ">$fa_out");

# Use ->next_seq to loop over the fasta file
while (my $seq = $in->next_seq) {
    # Use ->id() to retrieve fastaheader
    my $id = $seq->id;
    my @line = split "_", $id;
    my ($length, $cov) = ($line[3], $line[5]);
    # Use ->write_seq() to write sequences  ($seq) with sufficient length and cov to $out object
    if ($type eq "or") {
    $out->write_seq($seq) if ($length > $length_cutoff || $cov > $cov_cutoff);
    }
    elsif ($type eq "and") {
    $out->write_seq($seq) if ($length > $length_cutoff && $cov > $cov_cutoff);
    }
}
