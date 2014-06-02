#!/usr/bin/perl -w
use strict;

use Bio::SeqIO;

die "usage: select_contigs.pl <fasta in> <fasta out> <contigid 1> <contigid 2> <etc>\n" unless @ARGV >= 3;

my ($fa_in, $fa_out, @contigs) = @ARGV;

my $in  = Bio::SeqIO->new(-format => 'fasta',
			  -file   => $fa_in);
my $out = Bio::SeqIO->new(-format => 'fasta',
			  -file   => ">$fa_out");

while (my $seq = $in->next_seq) {
    my $id = $seq->display_id;
    my ($node) = $id =~ /NODE\_(\d+)\_/;
    $out->write_seq($seq) unless $node ~~ @contigs;
}    
