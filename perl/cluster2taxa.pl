#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;

my ($clus, $prot_dir) = @ARGV;

# Main data structures
my %genes;

# Parse protein files
opendir DIR, "$prot_dir";
foreach my $fasta (readdir DIR) {
    next if ($fasta =~ m/^\./);
    print STDERR "Reading $fasta ...\n";

    # name species from fasta file
    my ($org) = $fasta =~ m/(\S+).faa.fix/;
    
    # connect sequence id with species name
    my $fasta_in = Bio::SeqIO->new(-file   => "<$prot_dir$fasta",
				   -format => 'fasta');
    while (my $seq = $fasta_in->next_seq){
	my $id = $seq->id();
	$genes{$id} = $org;
    }
	
}
closedir DIR;

print STDERR "==============LOADED ALL GENES=================\n";

# Parse .clus file
open CLUS, '<', $clus;
print STDERR "Reading $clus ...\n";
while (<CLUS>) {  
    chomp;
    
    # converting gene id to corresponding taxon name
    my @genes = split "\t", $_;
    foreach my $gene (@genes) {
	
	# retrieve species names from %genes
	my $org = $genes{$gene};
	die "$gene was not found in provided protein files\n" unless $org;

	# print out
	print $org, "\t";
    }
    print "\n";
}
close CLUS;
