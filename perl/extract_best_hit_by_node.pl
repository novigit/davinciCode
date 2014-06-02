#!/usr/bin/perl
# All credits go to Johan Viklund for this script. 
# Basicly this script parses a blastp outfile, while listing down in a new outfile the gi identifiers of the best hits. 
# The gi identifiers are listed per contig (or NODE) 

use strict;
use warnings;
use Bio::SearchIO;

# CHECK SearchIO tutorial and EUtilities cookbook on bioperl site
my %node_accession;
my $in = new Bio::SearchIO(-format => 'blast', 
                           -file   => $ARGV[0]);


my $count;
QUERY:
while( my $result = $in->next_result ) {
  ## $result is a Bio::Search::Result::ResultI compliant object
  my $hit = $result->next_hit; ## $hit is a Bio::Search::Hit::HitI compliant object
  #print "Query=",   $result->query_name,
  #      " Hit=",        $hit->name, "\n";

  printf STDERR "\rProcessing Query %d", $count++;
  #last if $count > 10; # For debugging

  my ($node_name) = $result->query_name =~ /(NODE_\d+)/;
  if ( ! exists $node_accession{$node_name} ) {
    $node_accession{$node_name} = [];
  }
  if ( !$hit ) {
    # Maybe add to sum...
    next QUERY;
  }

  my $accession; # Extract from $hit->name
  if ( $hit->name =~ /^.*?\|(.*?)\|/ ) {
    $accession = $1;
  }
  else {
    print "No accession number in ", $hit->name, " !!!!\n";
    next;
  }
  push @{ $node_accession{$node_name} }, $accession; # ( NODE_001 => [ AZ239874, TN9834759, ...] )
}
printf STDERR "\nDone\n";
for my $node ( sort keys %node_accession ) {
  print "$node\t", join('\t', @{ $node_accession{$node} } ), "\n";
}
