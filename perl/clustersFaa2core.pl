#!/usr/bin/perl -w

=head1 SYNOPSIS

clustersFaa2core.pl - From the original faa files and the clusters, makes one fasta per core (i.e. 1 and only 1 gene per org) gene.

=head1 USAGE

clustersFaa2core.pl -c|--cluster file -o|--out-folder [-a|--add-these-genes -r|--reference-genome] [-n|--nucleotides] folder faa1 faa2 ...

=head1 INPUT

=head2 -c|--cluster file

A raw cluster file, one line per cluster

=head2 -o|--out-folder folder

Folder to put the results into

=head2 -n|--nucleotides

Outputs ffn files as well. In that case, for each faa file, there should be a ffn file in the same folder.

=head2 [-a|--add-these-genes -r|--reference-genome]

Complement the strict core genes with other. The reference genome is the fasta file in which to look for these genes. If they are present, they will be included, provided that there is one copy (at least) in each genome. The first copy will be taken. The gene list is a list of gene name. Each faa file is looked for a gene|more info field in the description and if the gene is found then the cluster is added.

=head2 faa1 faa2...

Fasta files with the genes, one per organism.

=head1 OUTPUT

One fasta file per core cluster.

=head1 AUTHOR

Lionel Guy (lionel.guy@icm.uu.se)

=head1 DATE

Wed Jun 15 09:06:01 CEST 2011

=cut

# libraries
use strict;
use Getopt::Long;
use Bio::SeqIO;
use File::Basename;

# options
my $cluster_file;
my $out_folder = 'fasta';
my $add_gene_file;
my $ref_genome;
my $doffn;

GetOptions(
    'c|cluster=s' => \$cluster_file,
    'o|out-folder=s' => \$out_folder,
    'a|add-these-genes=s' => \$add_gene_file,
    'r|ref-genome=s' => \$ref_genome,
    'n|nucleotids' => \$doffn,
);
usage() unless @ARGV;
# check that if a is set, r is as well
die "Set --ref-genome if --add-these-gene is set\n" 
    if ($add_gene_file && !$ref_genome);

# create output folder if necessary
mkdir($out_folder) or die unless (-e $out_folder);

# read additional genes
my %add_gene_names;
if ($add_gene_file){
    open ADD, '<', $add_gene_file or die;
    while (<ADD>){
	chomp;
	$add_gene_names{$_}++;
    }
}
#foreach (keys %add_gene_names) {print "$_\n"}; die;


# map genes
my %genes;
my %add_genes;
my @orgs;
print STDERR "Read fasta files:\n";
my $n_genes = 0;
my $found_ref_genome;
foreach my $faa_file (@ARGV){
    my @faexts = ('.faa', '.fasta', '.ffn', '.fa');
    my ($name, $path) = fileparse($faa_file, @faexts);
    $found_ref_genome++ if ($add_gene_file && 
				basename($ref_genome, @faexts) eq $name);
    push @orgs, $name;
    print STDERR "  $name: $faa_file\n";
    my $faa_in = Bio::SeqIO->new(-file => $faa_file,
				 -format => 'fasta');
    my $n_in_faa;
    while (my $seq = $faa_in->next_seq){
	$n_genes++;
	$n_in_faa++;
	my $id = $seq->id;
	$genes{$id}{'org'} = $name;
	$genes{$id}{'seq'} = $seq;
	# If browsing ref genome, check genes and add them if necessary
	if ($add_gene_file && basename($ref_genome, @faexts) eq $name){
	    #print STDERR "Browsing ref genome\n";
	    if ($seq->desc){
		my $desc = $seq->desc;
		if ($desc =~ /\|/){
		    $desc =~ s/^(\w+)\|.*$/$1/;
		    if ($add_gene_names{$desc}){
			#print STDERR "Found gene $desc in $name: $id\n";
			$add_gene_names{$desc}++;
			$add_genes{$id} = $desc;
		    }
		}
	    }
	}
    }
    # FFN
    if ($doffn){
	my $ffn_file = "$path/$name.ffn";
	die "FFN file $ffn_file not found\n" unless (-e $ffn_file);
	my $ffn_in = Bio::SeqIO->new(-file => $ffn_file,
				     -format => 'fasta');
	my $n_in_ffn = 0;
	while (my $ffn_seq = $ffn_in->next_seq){
	    my $id = $ffn_seq->id;
	    if ($genes{$id}){
		$n_in_ffn++;
		#die "ID $id in ffn not found in faa\n" unless $genes{$id};
		$genes{$id}{'nt'} = $ffn_seq;
	    }
	    else {
		warn "ID $id in ffn not found in faa\n";
	    }
	}
	die "Unequal number of genes in faa ($n_in_faa) and ffn ($n_in_ffn).\n"
	    unless ($n_in_ffn == $n_in_faa);
    }
}
# Check that the ref genome has been found
die "Ref genome not found in fasta files\n"
    if ($add_gene_file && !$found_ref_genome);
# Check that all genes have been found in the ref faa
foreach (keys %add_gene_names){
    die ("Gene $_ not found or found more than once\n")
	unless ($add_gene_names{$_} == 2);
}
#foreach (keys %add_genes) {print "$_\n"};

@orgs = sort @orgs;
my $n_org = scalar @orgs;
print STDERR "Read $n_genes genes in $n_org organisms\n\n";

# map clusters
open CLUS, '<', $cluster_file or die;
my $count = 0;
my $n_core = 0;
print STDERR "Read clusters\nCore clusters:";
while (<CLUS>){
    chomp;
    $count++;
    my $famcl = 'famcl' . sprintf("%05d", $count);
    my @genes = split;
    my %seen;
    my %byorg;
    my $add_gene;
    foreach my $gene (@genes){
	my $org = $genes{$gene}{'org'};
	die "ID not found in faa files: $gene" unless $org;
	$seen{$org}++;
	$byorg{$org} = $gene;
	# Check: is this cluster to be added?
	$add_gene = $gene if ($add_genes{$gene});
	print STDERR "  Adding $add_genes{$add_gene}: $famcl\n" 
	    if $add_genes{$gene};
    }
    # Check that if the gene is to add, it is present in all organisms (at
    # least once)
    die "Gene $add_genes{$add_gene} not found in all organisms\n"
	if ($add_gene && !(scalar(keys(%seen)) == $n_org));
    # Test if the cluster has the right number of genes (or is a gene to add) 
    # and if all are represented
    if ((scalar(@genes) == $n_org || $add_gene) 
	    && scalar(keys(%seen)) == $n_org){
	$n_core++;
	print STDERR " $famcl\r";
	my $fasta_out = Bio::SeqIO->new(-file => ">$out_folder/$famcl.faa",
					-format => 'fasta');
	foreach my $org (@orgs){
	    my $seq = $genes{$byorg{$org}}{'seq'};
	    $seq->desc($seq->id . "|" . $seq->desc);
	    $seq->id($org);
	    $fasta_out->write_seq($seq);
	}
	if ($doffn){
	    my $ffn_out = Bio::SeqIO->new(-file => ">$out_folder/$famcl.ffn",
				       -format => 'fasta');
	    foreach my $org (@orgs){
		my $seq = $genes{$byorg{$org}}{'nt'};
		$seq->desc($seq->id . "|" . $seq->desc);
		$seq->id($org);
		$ffn_out->write_seq($seq);
	    }
	}
    }
}
print STDERR "\nFound $n_core core clusters in $count clusters\n";

sub usage{
    system("perldoc $0");
    exit;
}
