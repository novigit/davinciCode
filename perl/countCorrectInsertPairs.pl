#!/usr/bin/perl -w
use strict;

# Estimates the percentage of 'Happy Pairs' in the assembly, i.e. read pairs that are aligned to assembly within expected distance

die "usage: countHappyPairs.pl <insert size file> <min insert size> <max insert size>\n" unless @ARGV == 3;
 
my ($in, $min, $max) = @ARGV;
my $total_count;
my $happy_count;
my $unhappy_count;

open IN, "<$in";

while (<IN>) {
    chomp;
    # print "$_\n";
    $total_count++;
   if (($_ < $min) || ($_ > $max)) {
	$unhappy_count++;
   }
   else {
	$happy_count++;
   }
}

my $happy_percentage = ($happy_count / $total_count) * 100;

close IN;

print "Total amount of Pairs: $total_count\n";
print "Amount of Happy Pairs: $happy_count\n";
print "Amount of Unhappy Pairs: $unhappy_count\n";
print "% Happy Pairs: "; 
printf "%.1f\n", "$happy_percentage";

