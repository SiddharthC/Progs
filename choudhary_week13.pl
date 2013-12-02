#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use Bio::SeqIO;
use Bio::Seq;
use Bio::Tools::Run::StandAloneBlast;

my ($input_file, $out_format, $seq, $seq_db, $in_stream, $out_stream, $out_file, @params, $seq_obj, $blast_obj, $result_obj, $report_obj, $blast_flag, $blast_parser, $blast_query, $seq_db2, $seq_obj2, $blast_query2, $hit, $hsp);

$out_file = "";
$input_file = "";
$out_format = "x";
$seq_db = "default.fa";
$blast_flag = 0;
$blast_parser = "SearchIO";

GetOptions("i|in_file=s" => \$input_file,
		"f|out_format=s" => \$out_format,
		"o|out_file=s" => \$out_file,
		"h|help" => \&help_printer,
		"b|blast_flag" => \$blast_flag,
		"s|seq_db=s" => \$seq_db,
		"q2|query2=s" => \$blast_query2,
		"p|blast_parser=s" => \$blast_parser,
		"q|query=s" => \$blast_query);

sub help_printer{
	print "Usage ./script_name -i <input_genbank_file> -f <fasta|embl> -o <output_file>\n";
	exit 1;
}

&help_printer if ($out_format ne "fasta" && $out_format ne "embl" && $out_format ne "x");
&help_printer if ($blast_parser ne "BPbl2seq" && $blast_parser ne "BPpslite" && $blast_parser ne "SearchIO" && $blast_parser ne "BPlite");

if ($out_format ne "x"){
#print "Out file is - $out_file and Out format - $out_format and infile is $input_file\n";
	
	#create file if not exists
	open my $temp, ">>", $out_file or die "Can't open file - $out_file\n";
	close $temp;

	$in_stream = Bio::SeqIO->new(-file => $input_file,
				-format => 'GenBank');
	$out_stream = Bio::SeqIO->new(-file => ">$out_file",
				-format => $out_format);

	while($seq = $in_stream->next_seq()){
		$out_stream->write_seq($seq);
	}
}

if($blast_flag){
	@params = (program => 'blastn', database => $seq_db);

	$seq_obj = Bio::Seq->new(-id => "query",
			-seq => $blast_query);

	$blast_obj = Bio::Tools::Run::StandAloneBlast->new(@params);
	if ($blast_parser eq "SearchIO" ){
		$report_obj = $blast_obj->blastall($seq_obj);
		$result_obj = $report_obj->next_result;
		$hit = $result_obj->next_hit;
		$hsp = $hit->next_hsp;
		print "1 - $hsp\n";
		$hsp = $hit->next_hsp;
		print "2 - $hsp\n";
	}
	elsif ($blast_parser eq "BPbl2seq"){
		$seq_obj2 = Bio::Seq->new(-id => "query",
				-seq => $blast_query2);
		$report_obj = $blast_obj->bl2seq($seq_obj, $seq_obj2);
		$hsp = $report_obj->next_feature;
		print "1 - $hsp\n";	
		$hsp = $report_obj->next_feature;
		print "2 - $hsp\n";

# TODO figure out pslite and lite
	}
}
