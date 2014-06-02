#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
use Getopt::Long;

# Based on sequence
# Based on id


my %unique;

my ($file) = @ARGV;
my $in     = Bio::SeqIO->new(-file => $file,    -format => "fasta");
my $out    = Bio::SeqIO->new(-fh   => \*STDOUT, -format => "fasta");

while(my $seq_obj = $in->next_seq) {
  my $id  = $seq_obj->display_id;
  my $seq = $seq_obj->seq;
  unless(exists($unique{$id})) {
    $out->write_seq($seq_obj);
    $unique{$id}++;
  }
}
