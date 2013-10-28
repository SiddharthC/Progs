#!/usr/bin/perl -w

# Program to take input from STDIN and append to an array for +ve and prepend for -ve. ) exits the program.

use strict;
use warnings;

my @num_array;
my $num;
my $sum;
while(1)
{
	$num = <STDIN>;
	chomp $num;
	if ($num == 0)
	{
		last;
	}
	if($num > 0){
		push @num_array, $num;
	}
	if($num < 0){
		unshift @num_array, $num;
	}
	$sum +=$num;
}
print join("." , @num_array);
print "\n";
print "The sum is $sum\n";
