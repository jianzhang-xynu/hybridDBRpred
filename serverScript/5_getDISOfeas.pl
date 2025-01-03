#! /usr/bin/perl

$taskID=$ARGV[0];
system "mkdir -p $taskID/DISOscores/";

	@alongDisoScores=();
	@ashortDisoScores=();

	open LONG,"$taskID/DISOlong/temp_pro.disoout";
	while(defined($eachline=<LONG>)){
		next if $. < 13;
		if($eachline =~ /^[0-9]+/){
			chomp($eachline);
			my @info=split(/\s+/,$eachline);
			push(@alongDisoScores,@info[2]);
		}
	}
	close LONG;

	open SHORT,"$taskID/DISOshort/temp_pro.disoout";
	while(defined($eachline=<SHORT>)){
		next if $. < 13;
		if($eachline =~ /^[0-9]+/){
			chomp($eachline);
			my @info=split(/\s+/,$eachline);
			push(@ashortDisoScores,@info[2]);
		}
	}
	close SHORT;

	open WRITE,">$taskID/DISOscores/temp_pro.txt";
	for($cn=0;$cn<@alongDisoScores;$cn++){
		print WRITE @alongDisoScores[$cn].",";
		print WRITE @ashortDisoScores[$cn]."\n";
	}
	close WRITE;




