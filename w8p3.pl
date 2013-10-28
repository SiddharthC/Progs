#!/usr/bin/perl

# Program to count the occurances of a specific fields and to print them in a formatted manner.

use strict;
use warnings;

if(($#ARGV+1) != 1){
	print "Please pass the input BED file as command line argument.\n";
	exit;
}

my %strandHash;

my $file = $ARGV[0];
my $entry_count;
my $longest_entry_length=-9999999;
my $longest_entry;
my $shortest_entry_length=9999999;
my $shortest_entry;
my $total_length=0;

my $temp;
my $average;
my $sd;

my @cols;
my $value;

my $fh;
my $line;

open($fh, "<", $file) or die "Can't open file : $file\n";

while($line = <$fh>){
	$entry_count++;
	chomp $line;
	@cols = split("\t", $line);

	$strandHash{$cols[5]}++;
	
	$temp = $cols[2] - $cols[1];

	$total_length += $temp;

	if($temp > $longest_entry_length){
		$longest_entry_length = $temp;
		$longest_entry = $line;
	}

	if($temp < $shortest_entry_length){
		$shortest_entry_length = $temp;
		$shortest_entry = $line;
	}
}

close $fh;

$average = $total_length / $entry_count;

open($fh, "<", $file) or die "Can't open file : $file\n";

while($line = <$fh>){
	$entry_count++;
	chomp $line;
	@cols = split("\t", $line);
	$temp = $cols[2] - $cols[1];
	$sd += ($temp - $average)**2;
}

$sd = $sd**(1/2);

print "="x80;
print "\nData for BED file $file\n";
print "="x80;
print "\nTotal number of entries: $entry_count\n";
print "Total length of entries: $total_length\n";
print "Number of entries on strand: \n";
foreach (sort keys(%strandHash)){
	printf "Strand: $_ Count: $strandHash{$_}\n";
}
print "Longest entry has length $longest_entry_length.\n Entry is:\n $longest_entry\n";
print "Shortest entry has length $shortest_entry_length.\n Entry is:\n $shortest_entry\n";
print "Average length: $average\n";
print "Standard deviation: $sd\n";

print "="x80;
print "\n";
