#!/usr/bin/perl -w
use strict;
use Bio::TreeIO;

my ($file) = @ARGV;

my $nwk = Bio::TreeIO->new(-file   => $file,
			   -format => 'newick',
			   -internal_node_id => 'bootstrap');


my $tree = $nwk->next_tree;
# my $root = $tree->get_root_node;
# print "TEST\n";
# print $root;

my @taxa = $tree->get_leaf_nodes;
for my $taxon (@taxa) {
    print $taxon->id, "\n";
}


my $count = 0;
for my $node ($tree->get_nodes) {
    $count++;
    # print $count, "\t", $node->id, "\n" if ($node->is_Leaf);
    # print $count, "\t", "Support: ", $node->bootstrap, "\n", unless ($node->is_Leaf);
    
    next if ($node->is_Leaf);
    print "node:  ", $count, "\t", $node->bootstrap, "\t";

    # for my $child ($node->get_all_Descendents) {
    # 	print $child->id, " " if ($child->is_Leaf);
    # }

    # for my $child ($node->get_leaf_nodes) {
    # 	print $child->id, " ";
    # }
    print "\n";
}


