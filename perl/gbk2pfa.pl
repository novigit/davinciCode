#!/usr/bin/perl -w
#   Written by Jimmy Saw - 10-11-2007
#   This program takes a Genbank file and extract protein sequence fastas
#   You have to redirect output to a file

# Edited by Joran Martijn, 2013-10-21

use Bio::SeqIO;
use strict;

die "Usage: gbk2pfa.pl [gbk-in] > [protein-fasta-out]\n" unless @ARGV == 1;

my ($gbk) = @ARGV;

my $in  = Bio::SeqIO->new (-file   => $gbk, 
			   -format => 'genbank');

while (my $seq = $in->next_seq) {

    for my $feature ($seq->get_SeqFeatures){
	if ($feature->primary_tag eq "CDS"){

	    if ($feature->has_tag('locus_tag')){
		for my $locus_tag ($feature->get_tag_values('locus_tag')){
		    print ">", $locus_tag, "__";
		}
	    }
	    
	    if ($feature->has_tag('product')){
		for my $product ($feature->get_tag_values('product')){
		    print $product, "\n";
		}
	    }

	    if ($feature->has_tag('translation')){
		for my $translation ($feature->get_tag_values('translation')){
		    print $translation, "\n";
		}
	    }
	}
    }

}
