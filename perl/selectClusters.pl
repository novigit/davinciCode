#!/usr/bin/perl -w
use strict;
use Getopt::Long;

=head1 NAME

selectClusters.pl

=head1 SYNOPSIS

It parses the 'normalCluster.clus' file from the faMCL output, and looks for specific clusters/lines (each cluster is one line), specified by already existing .faa clusters.

=head1 COMMENTS

This script is still very specific. It solely works on the faMCL normalCluster.clus file, and the Clusters should already have been made before in a directory.

=head1 AUTHOR

Joran Martijn (joran.martijn@icm.uu.se)

=cut

# Usage
die "usage: selectClusters.pl", "\n",
    "\t", "-c|--clus", "\t", "[.clus file]", "\n",
    "\t", "-p|--proteomes", "\t", "[directory with .faa clusters]", "\n",
    "\t", "-l|--list", "\t", "[.list] with COG names that you want to extract", "\n",
    "\t", "> [out.clus]", "\n" unless @ARGV >= 2;

# Options
my ($clus, $dir, $list);
GetOptions('c|clus=s'      => \$clus,
	   'p|proteomes=s' => \$dir,
	   'l|list=s'      => \$list);

# Main data structures
my %hash;

# If selection is made from pre-existing clusters
if ($dir) {
    opendir DIR, "$dir";
    print STDERR "Loading cluster names...\n";
    foreach my $file (readdir DIR) {
	next if ($file =~ m/^\./);
	# print $file, "\n";
	my ($clus_no) = $file =~ m/famcl00(\d{3})\.faa/;
	# print $clus_no, "\n";
	$hash{$clus_no}++
    }
    print STDERR "Loading cluster names... DONE!\n";
    closedir DIR;
}

# If selection is made from a list
if ($list) {
    open LIST, '<', $list;
    while (<LIST>) {
	my ($id) = $_ =~ m/rickCOG(\d+)/;
	$id =~ s/0*(\d+)/$1/;
	$hash{$id}++;
    }
}

# Open .clus file and prints selected clusters.
open CLUS, "$clus";
while (<CLUS>) {
    next unless (exists $hash{$.});
    my $name = "rickCOG" . sprintf("%05d", $.);
    print $name, "\t", $_;
}
close CLUS;
