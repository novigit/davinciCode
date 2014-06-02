#!/usr/bin/perl -w
use strict;
use Bio::TreeIO;

my ($clus, $tree_in) = @ARGV;

# Major data structures
my %nodes;
my %count;

# Create tree object
my $nwk = Bio::TreeIO->new(-file => $tree_in,
			   -format => 'newick');
my $tree = $nwk->next_tree;

# Parse all nodes of the tree
my $id;
for my $node ($tree->get_nodes) {
    $id++;

    # Link node with number of descendent taxa of node
    my @desc;
    for my $child ($node->get_all_Descendents) {
	push @desc, $child if ($child->is_Leaf);
    }
    my $desc = scalar @desc;
    # internal nodes
    $nodes{$id}{$desc}++ if (scalar @desc > 1);
    # leaf nodes
    $nodes{$id}{'1'}++   if (scalar @desc < 1);
}

foreach my $node (sort {$a <=> $b} keys %nodes) {
    foreach my $key (sort {$a <=> $b} keys %nodes{$node}) {
	print $node, "\t", $nodes{$node}, "\t", $nodes{$node}{$key}, "\n";
    }
}


# # Parse .clus file
# open CLUS, "$clus";
# while (<CLUS>) {
#     chomp;

# }
# close CLUS;
