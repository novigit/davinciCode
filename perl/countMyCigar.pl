#!/usr/bin/perl -w
use strict;
my $removed = 0;
while (<>){
    if (/^@/) {
	print $_;
	next;
    }
    chomp;
    my @fs = split;
    my $cigar = $fs[5];
    #print STDERR "$cigar \n";
    my @matches = $cigar =~ /(\d+[MIDNSHP])/g;
    my $sum = 0;
    foreach my $match (@matches){
	$match =~ /(\d+)(\w)/;
	die "Cigar bits not matching criteria $match\n" unless ($1 && $2);
	$sum += $1 if ($2 eq 'S' || $2 eq 'M' || $2 eq 'I');
    }
    if ($sum == length($fs[9])){
	print "$_\n";
    }
    else {
	print STDERR "$_\n";
	$removed++;
    }
}
print STDERR "Removed $removed lines\n";
