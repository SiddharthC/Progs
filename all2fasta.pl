#!/usr/bin/perl -w

use strict;
use v5.14;
use File::Copy qw(move);

my (@file_info, $out_filename, $input_format, $nuc_flag, $line, $i, $infile, $out_file, $new_out_filename, $temp_flag);

#Initialization
$nuc_flag=0;

if (!(@ARGV > 0)){
	print "Please provide an input file to the script.\n";
	exit 1;
}

foreach (@ARGV){
	@file_info = split(/\./,$_);
	$input_format = $file_info[-1];
	$out_filename = join(".",@file_info[0 .. $#file_info -1]);
	
	open($infile, "<", $_) or die "Can't open input file: $_\n";
	open($out_file, ">", $out_filename) or die "Can't open output file: $out_filename\n";
	given($input_format){
		when("embl"){
			$nuc_flag=1;
			while ($line = <$infile>){
				if($line =~ /^ID.+/){
					print $out_file "$1";
				}
				elsif ($line =~ /^P[TA].+/){
					print $out_file "; $1";
				}
				elsif ($line =~ /^\s{4}.+(?=\s\d)/)
					$nuc_flag = 0 if($1 =~ /[^AGTCU]/);
					print $out_file "\n$1\n";
				}
			}
		}
		when("fastq"){
			$i=0;
			$nuc_flag = 1; 
			while($line = <$infile>){
				if(/^\@/&&$i==0){
					$line =~ s/^\@/\>/;
					print $out_file "$line";
				}
				elsif($i==1){
					$nuc_flag = 0 if($line =~ /[^AGTCU]/);
					print $out_file "$line";
					$i =- 3;
				}
				$i++;
			}
		}
		when("genbank"){}
		when("mega"){}
		when("pir"){
			$nuc_flag = 0;
			$temp_flag = 0;
			while($line = <$infile>){
				if(/^\>/&&$temp_flag==0){
					$temp_flag=1;
					print $out_file ">$1" if(m/(?<=;).*/);
				}
				elsif($temp_flag==1){
					$temp_flag=0 if (/.*(?=\*)/);
					print $out_file "$line";
				}
			}
		}
		default{
			print "Input file has an unrecognized format.\n";
			exit 1;
		}
	}
	close ($infile);
	close ($out_file);
	$new_out_filename = join(".",@file_info[0 .. $#file_info -1]).(($nuc_flag)?".fna":".faa");
	move $out_filename, $new_out_filename;
	print "The file for conversion -- $_\nThe output file would be saved as -- $out_filename\n";
}
