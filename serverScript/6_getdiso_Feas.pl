#! /usr/bin/perl

use Statistics::Descriptive;

$taskID=$ARGV[0];
system "mkdir -p $taskID/Diso_ctent/";


	open DISOFEAS,"$taskID/DISOscores/temp_pro.txt";
	chomp(@disofeas=<DISOFEAS>);
	close DISOFEAS;

	@aDisoLong=();
	@aDisoShort=();
	
	for($cn=0;$cn<@disofeas;$cn++){
		my @tempinfo=split(/,/,@disofeas[$cn]);
		push(@aDisoLong,@tempinfo[0]);
		push(@aDisoShort,@tempinfo[1]);
	}

	$prolength=@aDisoLong;

	#---------------------------------------------------------------
	my $statDisoLong = Statistics::Descriptive::Full->new();
	$statDisoLong->add_data(@aDisoLong);
	$MeanDisoLong = $statDisoLong->mean();
	$StdDevDisoLong=$statDisoLong->standard_deviation();

	#---------------------------------------------------------------
	my $statDisoShort = Statistics::Descriptive::Full->new();
	$statDisoShort->add_data(@aDisoShort);
	$MeanDisoShort = $statDisoShort->mean();
	$StdDevDisoShort=$statDisoShort->standard_deviation();

	#---------------------------------------------------------------


	#===============================================================	
	@seqdisoLong04=();@seqdisoLong05=();@seqdisoLong06=();@seqdisoLong07=();
	$numdisoLong04=0;$numdisoLong05=0;$numdisoLong06=0;$numdisoLong07=0;

	#---------------------------------------------------------------
	open TEMP,">$taskID/tempinfo.long04";
	for($cn=0;$cn<$prolength;$cn++){
		if(@aDisoLong[$cn] >= 0.4){
			push(@seqdisoLong04,"1");$numdisoLong04=$numdisoLong04+1;
			print TEMP "1";
		}else{
			push(@seqdisoLong04,"0");
			print TEMP "\n";
		}
	}
	close TEMP;

	open READTEMP,"$taskID/tempinfo.long04";
	chomp(@aTemp04=<READTEMP>);
	close READTEMP;

	$maxdisoLong04seg=0;
	for($cm=0;$cm<@aTemp04;$cm++){
		my $templen04=length(@aTemp04[$cm]);
		if($templen04 > $maxdisoLong04seg){$maxdisoLong04seg = $templen04;}
	}
	system "rm $taskID/tempinfo.long04";
	#---------------------------------------------------------------
	open TEMP,">$taskID/tempinfo.long05";
	for($cn=0;$cn<$prolength;$cn++){
		if(@aDisoLong[$cn] >= 0.5){
			push(@seqdisoLong05,"1");$numdisoLong05=$numdisoLong05+1;
			print TEMP "1";
		}else{
			push(@seqdisoLong05,"0");
			print TEMP "\n";
		}
	}
	close TEMP;

	open READTEMP,"$taskID/tempinfo.long05";
	chomp(@aTemp05=<READTEMP>);
	close READTEMP;

	$maxdisoLong05seg=0;
	for($cm=0;$cm<@aTemp05;$cm++){
		my $templen05=length(@aTemp05[$cm]);
		if($templen05 > $maxdisoLong05seg){$maxdisoLong05seg = $templen05;}
	}
	system "rm $taskID/tempinfo.long05";
	#---------------------------------------------------------------
	open TEMP,">$taskID/tempinfo.long06";
	for($cn=0;$cn<$prolength;$cn++){
		if(@aDisoLong[$cn] >= 0.6){
			push(@seqdisoLong06,"1");$numdisoLong06=$numdisoLong06+1;
			print TEMP "1";
		}else{
			push(@seqdisoLong06,"0");
			print TEMP "\n";
		}
	}
	close TEMP;

	open READTEMP,"$taskID/tempinfo.long06";
	chomp(@aTemp06=<READTEMP>);
	close READTEMP;

	$maxdisoLong06seg=0;
	for($cm=0;$cm<@aTemp06;$cm++){
		my $templen06=length(@aTemp06[$cm]);
		if($templen06 > $maxdisoLong06seg){$maxdisoLong06seg = $templen06;}
	}
	system "rm $taskID/tempinfo.long06";
	#---------------------------------------------------------------
	open TEMP,">$taskID/tempinfo.long07";
	for($cn=0;$cn<$prolength;$cn++){
		if(@aDisoLong[$cn] >= 0.7){
			push(@seqdisoLong07,"1");$numdisoLong07=$numdisoLong07+1;
			print TEMP "1";
		}else{
			push(@seqdisoLong07,"0");
			print TEMP "\n";
		}
	}
	close TEMP;

	open READTEMP,"$taskID/tempinfo.long07";
	chomp(@aTemp07=<READTEMP>);
	close READTEMP;

	$maxdisoLong07seg=0;
	for($cm=0;$cm<@aTemp07;$cm++){
		my $templen07=length(@aTemp07[$cm]);
		if($templen07 > $maxdisoLong07seg){$maxdisoLong07seg = $templen07;}
	}
	system "rm $taskID/tempinfo.long07";
	#===============================================================

	@seqdisoShort04=();@seqdisoShort05=();@seqdisoShort06=();@seqdisoShort07=();
	$numdisoShort04=0;$numdisoShort05=0;$numdisoShort06=0;$numdisoShort07=0;
	#---------------------------------------------------------------
	open TEMP,">$taskID/tempinfo.Short04";
	for($cn=0;$cn<$prolength;$cn++){
		if(@aDisoShort[$cn] >= 0.4){
			push(@seqdisoShort04,"1");$numdisoShort04=$numdisoShort04+1;
			print TEMP "1";
		}else{
			push(@seqdisoShort04,"0");
			print TEMP "\n";
		}
	}
	close TEMP;

	open READTEMP,"$taskID/tempinfo.Short04";
	chomp(@aTemp04=<READTEMP>);
	close READTEMP;

	$maxdisoShort04seg=0;
	for($cm=0;$cm<@aTemp04;$cm++){
		my $templen04=length(@aTemp04[$cm]);
		if($templen04 > $maxdisoShort04seg){$maxdisoShort04seg = $templen04;}
	}
	system "rm $taskID/tempinfo.Short04";
	#---------------------------------------------------------------
	open TEMP,">$taskID/tempinfo.Short05";
	for($cn=0;$cn<$prolength;$cn++){
		if(@aDisoShort[$cn] >= 0.5){
			push(@seqdisoShort05,"1");$numdisoShort05=$numdisoShort05+1;
			print TEMP "1";
		}else{
			push(@seqdisoShort05,"0");
			print TEMP "\n";
		}
	}
	close TEMP;

	open READTEMP,"$taskID/tempinfo.Short05";
	chomp(@aTemp05=<READTEMP>);
	close READTEMP;

	$maxdisoShort05seg=0;
	for($cm=0;$cm<@aTemp05;$cm++){
		my $templen05=length(@aTemp05[$cm]);
		if($templen05 > $maxdisoShort05seg){$maxdisoShort05seg = $templen05;}
	}
	system "rm $taskID/tempinfo.Short05";
	#---------------------------------------------------------------
	open TEMP,">$taskID/tempinfo.Short06";
	for($cn=0;$cn<$prolength;$cn++){
		if(@aDisoShort[$cn] >= 0.6){
			push(@seqdisoShort06,"1");$numdisoShort06=$numdisoShort06+1;
			print TEMP "1";
		}else{
			push(@seqdisoShort06,"0");
			print TEMP "\n";
		}
	}
	close TEMP;

	open READTEMP,"$taskID/tempinfo.Short06";
	chomp(@aTemp06=<READTEMP>);
	close READTEMP;

	$maxdisoShort06seg=0;
	for($cm=0;$cm<@aTemp06;$cm++){
		my $templen06=length(@aTemp06[$cm]);
		if($templen06 > $maxdisoShort06seg){$maxdisoShort06seg = $templen06;}
	}
	system "rm $taskID/tempinfo.Short06";
	#---------------------------------------------------------------
	open TEMP,">$taskID/tempinfo.Short07";
	for($cn=0;$cn<$prolength;$cn++){
		if(@aDisoShort[$cn] >= 0.7){
			push(@seqdisoShort07,"1");$numdisoShort07=$numdisoShort07+1;
			print TEMP "1";
		}else{
			push(@seqdisoShort07,"0");
			print TEMP "\n";
		}
	}
	close TEMP;

	open READTEMP,"$taskID/tempinfo.Short07";
	chomp(@aTemp07=<READTEMP>);
	close READTEMP;

	$maxdisoShort07seg=0;
	for($cm=0;$cm<@aTemp07;$cm++){
		my $templen07=length(@aTemp07[$cm]);
		if($templen07 > $maxdisoShort07seg){$maxdisoShort07seg = $templen07;}
	}
	system "rm $taskID/tempinfo.Short07";
	#===============================================================


	open WRITE,">$taskID/Diso_ctent/temp_pro.txt";
	for($ct=0;$ct<$prolength;$ct++){

		printf WRITE ("%4.3f,%4.3f,",$MeanDisoLong,$StdDevDisoLong);
		printf WRITE ("%4.3f,%4.3f,",$numdisoLong04/$prolength,$numdisoLong05/$prolength);
		printf WRITE ("%4.3f,%4.3f,",$numdisoLong06/$prolength,$numdisoLong07/$prolength);
		print WRITE $maxdisoLong04seg.",".$maxdisoLong05seg.",";
		print WRITE $maxdisoLong06seg.",".$maxdisoLong07seg.",";

		printf WRITE ("%4.3f,%4.3f,",$MeanDisoShort,$StdDevDisoShort);
		printf WRITE ("%4.3f,%4.3f,",$numdisoShort04/$prolength,$numdisoShort05/$prolength);
		printf WRITE ("%4.3f,%4.3f,",$numdisoShort06/$prolength,$numdisoShort07/$prolength);
		print WRITE $maxdisoShort04seg.",".$maxdisoShort05seg.",";
		print WRITE $maxdisoShort06seg.",".$maxdisoShort07seg."\n";
	}


