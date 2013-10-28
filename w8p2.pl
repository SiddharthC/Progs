#!/usr/bin/perl

# Program to count the occurances of a specific fields and to print them in a formatted manner.

use strict;
use warnings;

my %refNameHash;
my %refFamilyHash;
my %refClassHash;
my $file = "RepeatMasker.txt";
my @cols;
my $value;

open(my $fh, "<", $file) or die "Can't open file : $file\n";

while(my $line = <$fh>){
	chomp $line;
	@cols = split("\t", $line);
	$refNameHash{$cols[13]}++;
	$refFamilyHash{$cols[14]}++;
	$refClassHash{$cols[15]}++;
}

print "Data for every repName:\n";
print "-"x31;
print "\n";
foreach (sort {$a <=> $b} keys(%refNameHash)){
	printf("| Key: %5d | value : %6d |\n", $_, $refNameHash{$_});
}
print "-"x31;
print "\n";

print "Data for every repFamily:\n";
print "-"x31;
print "\n";
foreach (sort {$a <=> $b} keys(%refFamilyHash)){
	printf("| Key: %5d | value : %6d |\n", $_, $refFamilyHash{$_});
}
print "-"x31;
print "\n";

print "Data for every repClass:\n";
print "-"x31;
print "\n";
foreach (sort {$a <=> $b} keys(%refClassHash)){
	printf("| Key: %5d | value : %6d |\n", $_, $refClassHash{$_});
}
print "-"x31;
print "\n";
