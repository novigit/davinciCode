#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;

die "extract_contaminating_reads.pl <reads> <fastq fw in> <fastq rv in> <fastq fw out> <fastq rv out>\n" unless @ARGV == 5;

my ($reads, $fq_fw_in, $fq_rv_in, $fq_fw_out, $fq_rv_out) = @ARGV;

my $in_fw = Bio::SeqIO->new(-format  => 'fastq',
			     -file   => "zcat $fq_fw_in |");
my $in_rv = Bio::SeqIO->new(-format  => 'fastq',
			     -file   => "zcat $fq_rv_in |");
my $out_fw = Bio::SeqIO->new(-format => 'fastq',
			     -file   => ">$fq_fw_out");
my $out_rv = Bio::SeqIO->new(-format => 'fastq',
			     -file   => ">$fq_rv_out");

my %reads_fw;
my %reads_rv;
open IN, "<", $reads;
while (<IN>) {
    chomp;
    my ($read, $flag, $node) = split '\t', $_;
#    print "$read\t$flag\t$node\n";
    if ($flag =~ /r/) {$reads_rv{$read}++;}
    else              {$reads_fw{$read}++;}
}

while (my $seq = $in_fw->next_seq) {
    my $read = $seq->id;
    # print "$read\n";
    print $seq if (exists $reads_fw{$read});
    $out_fw->write_seq($seq) if (exists $reads_fw{$read});
}    
while (my $seq = $in_rv->next_seq) {
    my $read = $seq->id;
    $out_rv->write_seq($seq) if (exists $reads_rv{$read});
}    
