#!/usr/bin/perl -w
use strict;
use Bio::Seq;
use Bio::SeqIO;
use Bio::SeqUtils;

my $gbk = shift @ARGV;
my @seqs;

my $in  = Bio::SeqIO->new(-file   => $gbk,
			  -format => 'genbank');

my $spacer = Bio::Seq->new(-seq      => "N"x50,
			   -alphabet => 'dna',
			   -format   => 'genbank');


my $out = Bio::SeqIO->new(-format => 'genbank',
			  -fh     => \*STDOUT);

while (my $seq = $in->next_seq) {
    push @seqs, $seq;
    push @seqs, $spacer;
}

Bio::SeqUtils->cat(@seqs);
$out->write_seq($seqs[0]);

