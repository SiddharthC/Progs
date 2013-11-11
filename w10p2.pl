#!/usr/bin/perl -w

# Perl script to overlap two sets of genomic coordinates and finding intersecting members.

use strict;
use Getopt::Long;
use List::Util qw[min max]; 

my ($helpflag, $database, $input, $output, $temp);			
$database = "db"; 							#default database is 'db'
$helpflag = 0;

sub helpprinter{
	print "To run the scrpt: ./script_name <options> -d <database> -i <seq_in_fasta_to_be_searched> -o <output_file>\n";
	print "Options are:\nh -- help\n";
	exit;
}

&helpprinter() if (@ARGV < 1 or ! GetOptions(
		"help" => \$helpflag,
		"database=s" => \$database,
		"input=s" => \$input,
		"output=s" => \$output) or $helpflag == 1);

$temp =  "blastn -db $database -query $input -out $output";

print "$temp\n";

system("$temp");
