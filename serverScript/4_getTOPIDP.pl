#! /usr/bin/perl

$taskID=$ARGV[0];
system "mkdir -p $taskID/TOPIDP/";

sub TOPIDPScores{
	
	$thisAA= $_[0];
	if($thisAA eq "A"){$thisvalue = "0.06";}
	if($thisAA eq "R"){$thisvalue = "0.180";}
	if($thisAA eq "N"){$thisvalue = "0.007";}
	if($thisAA eq "D"){$thisvalue = "0.192";}
	if($thisAA eq "C"){$thisvalue = "0.02";}

	if($thisAA eq "Q"){$thisvalue = "0.318";}
	if($thisAA eq "E"){$thisvalue = "0.736";}
	if($thisAA eq "G"){$thisvalue = "0.166";}
	if($thisAA eq "H"){$thisvalue = "0.303";}
	if($thisAA eq "I"){$thisvalue = "-0.486";}

	if($thisAA eq "L"){$thisvalue = "-0.326";}
	if($thisAA eq "K"){$thisvalue = "0.586";}
	if($thisAA eq "M"){$thisvalue = "-0.397";}
	if($thisAA eq "F"){$thisvalue = "-0.697";}
	if($thisAA eq "P"){$thisvalue = "0.987";}

	if($thisAA eq "S"){$thisvalue = "0.341";}
	if($thisAA eq "T"){$thisvalue = "0.059";}
	if($thisAA eq "W"){$thisvalue = "-0.884";}
	if($thisAA eq "Y"){$thisvalue = "-0.510";}
	if($thisAA eq "V"){$thisvalue = "-0.121";}

	return $thisvalue;
}

	open READ,"$taskID/fastas/temp_pro.txt";
	chomp(@array=<READ>);
	close READ;

	@callen=split(//,@array[1]);
	$length=0;$templen=0;
	for($temp=0;$temp<@callen;$temp++){
		if(@callen[$temp] =~ /[A-Z]/){$templen++;}
	}
	$length=$templen;

	@AAs=split(//,@array[1]);

	open WRITE,">$taskID/TOPIDP/temp_pro.txt";
	for($cn=0;$cn<$length;$cn++){
		my $thisScores=TOPIDPScores(@AAs[$cn]);
		print WRITE $thisScores."\n";
	}
	close WRITE;




