#!/usr/bin/perl 

use strict;
use v5.14;
use File::Copy qw(move);

my (@file_info, $out_filename, $input_format, $nuc_flag, $line, $i, $infile, $out_file, $new_out_filename, $temp_flag, $file_format, $first_flag);

$nuc_flag=0;
$first_flag = 1;

if (!(@ARGV > 0 )){
	print "Please provide an input file to the script.\n";
	exit 1;
}

foreach (@ARGV){
	@file_info = split(/\./, $_);
	open($infile, "<", $_) or die "Can't open input file: $_\n";

	$i=0;
	$line = <$infile>;

	if ($line =~ /^@/){
		$input_format = "fastq";
	}
	elsif ($line =~ /^#/){
		$input_format = "mega";

	}
	elsif ($line =~ /^LOCUS/){
		$input_format = "genbank";
	}
	elsif($line =~ /^ID.+/){
		$i=0;
		$nuc_flag = 1;
		$input_format = "embl";
	}
	elsif($line =~ /^\>/){
	$nuc_flag = 0;
	$temp_flag = 0;
	$input_format = "pir";
	}

	$out_filename =  join('.', @file_info[0..$#file_info-1], $input_format);
	open($out_file, ">", $out_filename) or die "Cannot open output file: $out_filename\n";

	close ($infile);
	open($infile, "<", $_) or die "Can't open input file: $_\n";

	given($input_format){
		when("embl"){
			$nuc_flag=1;
			while ($line = <$infile>){

				if($line =~/(^ID.+)/){
					$line =~ s/^ID\s+/\>/;
					if($line =~ /([^\s]*)/i){
						print $out_file "$1\n";
					}
				}
				elsif ($line =~ /^P[TA].+/){
					$line =~ s/^P[TA]\s+//;
					print $out_file "; $line";
				}
				elsif ($line =~/(^\s[^\d]*)/i){
					my $temp = $1;
					$temp =~s/^\s+//;
					print $out_file "$temp\n";
					$nuc_flag=1 if($temp =~ /[^AGTCU]/);
				}
			}
		}
		when("fastq"){
			$i=0;
			$nuc_flag = 1; 
			while($line = <$infile>){
				if($line =~/^\@/ && $i==0){
					$line =~ s/^\@/\>/;
					if($line =~ /([^\s]*)/i){
						print $out_file "$1\n";
					}
				}
				elsif($i==1){
					$nuc_flag = 0 if($line =~ /[^AGTCU]/);
					print $out_file "$line";
					$i =- 3;
				}
				$i++;
			}
		}
		when("genbank"){
			$nuc_flag = 0;
			my $temp_flag = 0;
			while ($line = <$infile>){
				if($temp_flag == 0){
					if($line =~ /^VERSION/){
						if ($line =~ /(GI:\w+)/){
							print $out_file ">$1\n";
						}
					}
					if($line =~ /^ORIGIN/){
						$temp_flag = 1;
					}
				}
				else{
					if($line =~ /^\/\//){
						$temp_flag = 0;
					}
					else{
						$line =~ s/^\s+\d+\s+//;
						$nuc_flag = 0 if ($line =~ /[^AGTCU]/);
						print $out_file "$line";
					}
				}


			}
		}
		when("mega"){
			$nuc_flag = 0;
			while($line = <$infile>){
				if($line =~ /(^\#[^\s]*)/){
					my $temp = $1;
					$temp =~ s/^\#/\>/;
					print $out_file "$temp\n";
					if($line =~ /\s([^\s]*$)/){
						print $out_file "$1\n" if($1 ne "");					}
				}
				else {
					print $out_file "$line";
				}

			}
		}
		when("pir"){
			$nuc_flag = 0;
			while($line = <$infile>){
				if($line =~ /^\>/){
					if($line =~ /(^\>[^;]*)/){
						print $out_file "$1\n";
					}
				}
				else{
					print $out_file "$line";
				}
			}
		}
		default{
			print "Input file has an unrecognized format.\n";
			exit 1;
		}
	}

	close($infile);
	close ($out_file);
	$new_out_filename = join(".",@file_info[0 .. $#file_info -1]).(($nuc_flag)?".fna":".faa");
	move $out_filename, $new_out_filename;
	print "The file for conversion -- $_\nThe output file would be saved as -- $new_out_filename\n";
}
