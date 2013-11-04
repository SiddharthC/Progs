#!/usr/bin/perl

# Perl version of bedItemOverlapCount program. Given an input file.

use strict;
use warnings;

my $numArgs = $#ARGV + 1;
if ($numArgs != 1){
	print "Please pass the input file as argument.\n";
	exit;
}

my %covers;
my $file = $ARGV[0];
my @cols;
my $i = 0;
my @coverCount;
my $start;
my $end;
my $count;
my $tag = 0;
my $tempTag;
my $low;
my $high;

open(my $fh, "<", $file) or die "Can't open file : $file\n";

while(my $line = <$fh>)
{
	chomp $line;
	( $tempTag, $low, $high ) = split("\t", $line);

	if ($tag != 0 && $tempTag != $tag){
		print "Tag mismatch. Only a single tag is allowed.\n";
		exit;
	}
	$tag = $tempTag if ($tag == 0);

	map { $covers{$_}++ }($low .. $high);
}

foreach ( sort { $a<=>$b } keys %covers){
	if($covers{$_} != $count || $_ > $end + 1){
		$end = $_ if ($_ == $end + 1);
			
		print "$tag\t$start\t$end\t$count\n" if ($count > 0);

		$count = $covers{$_};
		$start = $_;
		$end = $_;
	}
	else{
		$end = $_;
	}
}

print "$tag\t$start\t$end\t$count\n" if($count > 0);
