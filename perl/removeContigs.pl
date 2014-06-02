#!/usr/bin/perl -w

=head1 NAME

removeContigs.pl

=head1 SYNOPSIS

This script will remove contigs from a FASTA file that you specify. 

=head1 COMMENTS

Used to be called 'select_contigs.pl'.
Currently only works with FASTA files whos headers have this format:

>NODE_[number]_

=head1 AUTHOR

Joran Martijn (joran.martijn@icm.uu.se)

=cut

use strict;
use Bio::SeqIO;

die "usage: removeContigs.pl [fasta-in] [contig1] [contig2] [etc] > [fasta-out]\n" unless @ARGV >= 2;

my ($fa, @contigs) = @ARGV;

my $in  = Bio::SeqIO->new(-format => 'fasta',
			  -file   => $fa);
my $out = Bio::SeqIO->new(-format => 'fasta',
			  -fh     => \*STDOUT);

while (my $seq = $in->next_seq) {
    my $id = $seq->display_id;
    my ($node) = $id =~ /NODE\_(\d+)\_/;
    $out->write_seq($seq) unless $node ~~ @contigs;
}    
