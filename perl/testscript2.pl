#!/usr/bin/perl -w
use strict;
use Getopt::Long;

die "usage: select_single_domain_contigs.pl --domain <ar|bac|euk|vir> --filter <only|majority> --cutoff <0<x<1> <domain_count.tsv>\n" unless (@ARGV == 5 || @ARGV == 7);

my ($domain, $filter,$cutoff);
GetOptions("domain=s" => \$domain,
           "filter=s" => \$filter,
           "cutoff=s" => \$cutoff); 

open IN, "<$ARGV[0]";

print scalar <IN>;

while (<IN>) {
    chomp;
    my ($node, @taxa) = split '\t', $_;

    my $sum = 0;
    my $limit = @taxa;
    for (my $i=0; $i<$limit; $i++) {
	# print $taxa[$i], "\n";
	$sum+=$taxa[$i];
    }

    my $nh = pop @taxa;

    if ($filter eq 'only') {
	print $_, "\n" if ($domain eq 'ar'  && $taxa[0]+$taxa[1] == $sum);
	print $_, "\n" if ($domain eq 'bac' && $taxa[2]+$taxa[3] == $sum);
	print $_, "\n" if ($domain eq 'euk' && $taxa[4]          == $sum);
	print $_, "\n" if ($domain eq 'vir' && $taxa[5]          == $sum);
	print $_, "\n" if ($domain eq 'nh'  && $nh               == $sum);
    }

    if ($filter eq 'majority') {
	print $_, "\n" if ($domain eq 'ar'  && $taxa[0]+$taxa[1] > $cutoff * $sum);
	print $_, "\n" if ($domain eq 'bac' && $taxa[2]+$taxa[3] > $cutoff * $sum);
	print $_, "\n" if ($domain eq 'euk' && $taxa[4]          > $cutoff * $sum);
	print $_, "\n" if ($domain eq 'vir' && $taxa[5]          > $cutoff * $sum);
	print $_, "\n" if ($domain eq 'nh'  && $nh               > $cutoff * $sum);
    }
}

close IN;
    

