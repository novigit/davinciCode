#!/usr/bin/perl
# All credits go to Johan Viklund for this script
# This script parses the "extract_best_hit_by_node.pl" outfile and checks for each gi identifier which taxonomic clade it belongs to (Archaeal, Bacterial, Alphaproteobacterial, Eukaryal or Viral)
# It then counts per contig (or NODE) how much of each clade are presented in this contig

use strict;
use warnings;
use Bio::DB::EUtilities;
use Bio::SeqIO;

# CHECK SearchIO tutorial and EUtilities cookbook on bioperl site
my %node_counts;

open my $IN, '<', $ARGV[0] or die "Can't open file $ARGV[0]: $!";

while ( my $line = <$IN> ) {
chomp($line);
  my ($node_name, $accession) = split "\t", $line;
  my @accessions = split ',', $accession;
  print STDERR "Processing $node_name\n";

  if ( !@accessions ) {
    $node_counts{$node_name}{'SUM'} = 0;
    next;
  }


  my $factory = Bio::DB::EUtilities->new(-eutil   => 'efetch',
					 -db      => 'protein',
					 -rettype => 'gb',
					 -email   => 'mymail@foo.bar',
					 -id      => \@accessions );

  my $file = 'myseqs.gb';
 
  # dump HTTP::Response content to a file (not retained in memory)
  $factory->get_Response(-file => $file);
 
  my $seqin = Bio::SeqIO->new(-file   => $file,
                              -format => 'genbank');
 
  while (my $seq = $seqin->next_seq) {
    my $species = $seq->species;
    my @taxonomy = $species->classification; # LAST element is Bacteria/Euk...
    #print STDERR "$node_name $taxonomy[$#taxonomy]\n";
    if ( $taxonomy[$#taxonomy] eq 'Bacteria' ) {
        if ( grep /Alphaproteobacteria/, @taxonomy ) {
            $node_counts{ $node_name }{Alphaproteobacteria}++
        }
    }
    $node_counts{ $node_name }{ $taxonomy[$#taxonomy] }++;
    $node_counts{ $node_name }{'SUM'}++;
    #if ($node_counts{$node_name}{'SUM'} > 10 ) { last QUERY } # QUIT EARLY
  }
}

# Quote Words
my @superkingdoms = qw( Archaea Bacteria Alphaproteobacteria Eukaryota other unclassified Viruses );
my @sorted_nodes = sort { ($a =~ /(\d+)$/)[0] <=> ($b =~ /(\d+)$/)[0] } keys %node_counts;

print "NODE_ID @superkingdoms\n";

for my $node ( @sorted_nodes ) {
  my $sum = $node_counts{$node}{'SUM'} || 1;
  print $node;
  for my $kingdom ( @superkingdoms ) {
    my $count = $node_counts{$node}{$kingdom} || 0; # If kingdom hasn't been seen yet, use 0.
    printf " %d", $count;
    # printf " %5d", $count; # 
  }
  print "\n";
}

