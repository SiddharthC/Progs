#!/usr/bin/perl

# Program to display coordinates of required genes obtained from file.

use strict;
use warnings;

if(($#ARGV+1) != 3){
	print "Please pass the 3 arguments in correct order.\n";
	exit;
}

my $knownGene = $ARGV[0];
my $kgXref = $ARGV[1];
my $geneSet = $ARGV[2];

my %geneSetHash;
my $headingflag=0;
my %kgXrefMatches;

my @cols;

my $fh;
my $line;

open($fh, "<", $geneSet) or die "Can't open file : $geneSet\n";

while($line = <$fh>){
	chomp $line;
	if ($headingflag == 0)
	{
		$headingflag=1;
		next;
	}
	$geneSetHash{$line}=$line;
}

close $fh;

open($fh, "<", $kgXref) or die "Can't open file : $kgXref\n";

while($line = <$fh>){
	chomp $line;
	
	@cols = split("\t", $line);

	if (exists $geneSetHash{$cols[4]}){
		$kgXrefMatches{$cols[0]}=$cols[4];
	}
}

close $fh;

open($fh, "<", $knownGene) or die "Can't open file : $knownGene\n";

while($line = <$fh>){
	chomp $line;

	@cols = split("\t", $line);

	if (exists $kgXrefMatches{$cols[0]}){
		print "Infections Disease Gene:\n$kgXrefMatches{$cols[0]}:\nCoordinates: \n$line\n";
	}
}

close $fh;
