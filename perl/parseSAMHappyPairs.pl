#!/usr/bin/perl -w
use strict;

# Parses the bitwise flag field of the sam file and counts happy paired reads, i.e. mapped within expected insert size and correct orientation#

die "usage: parseSAMHappyPairs.pl <SAM file>\n" unless @ARGV == 1;

my $total_count;
my $happy_count;
my $unhappy_count;

my %flags = (
    '147' => 1,
    '99' => 1,
    '83' => 1,
    '163' => 1,
    );

open IN, "< $ARGV[0]";

while (<IN>) {
    next if (/^@/); 
    $total_count++;                
    my @line = split "\t";;     
    my $flag = $line[1];           
#   print "$flag\n";
    if ($flags{$flag}) {  
	# print "Happy Pair\t";
	# print "$_";
	$happy_count++;
    }
    else {
	# print "Unhappy Pair\t";
	# print "$_";
	$unhappy_count++;
    }
}

close IN;

print "Total amount of Pairs:".($total_count / 2)."\n";
print "Amount of Happy Pairs:".($happy_count / 2)."\n";
print "Amount of Unhappy Pairs:".($unhappy_count / 2)."\n";
print "% Happy Pairs: "; printf "%.1f\n", ($happy_count / $total_count * 100);
