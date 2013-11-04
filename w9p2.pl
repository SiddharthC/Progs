#!/usr/bin/perl

# Perl script to overlap two sets of genomic coordinates and finding intersecting members.

use strict;
use warnings;
use Getopt::Std;
use List::Util qw[min max]; 

my %args;
my @cols;
my $joinFlag=0;
my $str_cond='any';							#default condition is 'any'
my $str_cond_flag = 0;
my $file1="file1.bed";
my $file2="file2.bed";
my $per_over=100;							#default overlap percentage is 100
my $tagf1;
my $startf1=0;
my $endf1=0;
my $strf1;
my $tagf2;
my $startf2=0;
my $endf2=0;
my $strf2;
my $linef1;
my $linef2;
my $maxStart;
my $minEnd;

sub helpprinter{
	print "To run the scrpt: ./script_name <options> -o <overlap_percentage> -f1 <bed_file1> -f2 <bed_file2>\n";
	print "Options are:\nh -- help\nj -- join\nc -- strand_condition{E.g.: -c eq or -c ne}\n";
#	exit;
}

&helpprinter() if($#ARGV == 0);

getopts('hj:o:f1:f2:c:', \%args);

print "To run the script: ./script_name <options> -f1 <bed_file1> -f2 <bed_file2>\n" if ($args{h});

#Option to print overlapping member. i.e. result of joining the rows.
$joinFlag = 1 if ($args{'j'});

if (defined $args{'f1'}){
	$file1 = $args{'f1'};
}
else{
	&helpprinter();
}

if (defined $args{f2}){
	$file2 = $args{f2};
}
else{
	&helpprinter();
}

if (defined $args{o}){
	$per_over = $args{o};
}

if (defined $args{c}){
	$str_cond_flag=1;
	$str_cond = $args{c};
}

open(my $fh1, "<", $file1) or die "Can't open file: $file1\n";
open(my $fh2, "<", $file2) or die "Can't open file: $file2\n";

$linef2 = <$fh2>;
chomp $linef2;
@cols = split("\t", $linef2);
$tagf2 = $cols[0];
if ($startf2 > $cols[1]){
	print "The file $file2 is not sorted. Program is exiting.\n";
	exit;
}
$startf2 = $cols[1];
if ($endf2 > $cols[2]){
	print "The file $file2 is not sorted. Program is exiting.\n";
	exit;
}
$endf2 = $cols[2];
$strf2 = $cols[5];

while($linef1 = <$fh1>){
	chomp $linef1;
	@cols = split("\t", $linef1);
	$tagf1 = $cols[0];
	if ($startf1 > $cols[1]){
		print "The file $file1 is not sorted. Program is exiting.\n";
		exit;
	}
	$startf1 = $cols[1];
	if ($endf1 > $cols[2]){
		print "The file $file1 is not sorted. Program is exiting.\n";
		exit;
	}
	$endf1 = $cols[2];
	$strf1 = $cols[5];

	while (1){
		last if(($startf2 < $endf1) && ($tagf1 eq $tagf2));
		$linef2 = <$fh2>;
		chomp $linef2;
		@cols = split("\t", $linef2);
		$tagf2 = $cols[0];
		if ($startf2 > $cols[1]){
			print "The file $file2 is not sorted. Program is exiting.\n";
			exit;
		}
		$startf2 = $cols[1];
		if ($endf2 > $cols[2]){
			print "The file $file2 is not sorted. Program is exiting.\n";
			exit;
		}
		$endf2 = $cols[2];
		$strf2 = $cols[5];
	}
	$maxStart = max($startf1, $startf2);
	$minEnd = min($endf1, $endf2);
	if((($minEnd - $maxStart)/($endf1 - $startf1) * 100) >= $per_over){
		if($joinFlag){
			if($str_cond_flag)
			{
				print "$linef1\t$linef2\n" if((($str_cond eq 'eq') && ($strf1 eq $strf2))||(($str_cond eq 'ne')&&($strf1 ne $strf2)));
			}
			else{
				print "$linef1\t$linef2\n";
			}
		}
		else{
			if($str_cond_flag){
				print "$linef1\n" if((($str_cond eq 'eq') && ($strf1 eq $strf2))||(($str_cond eq 'ne')&&($strf1 ne $strf2)));
			}
			else{
				print "$linef1\n";
			}
		}
	}
}
