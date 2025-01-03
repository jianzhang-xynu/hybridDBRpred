#! /usr/bin/perl

$taskID=$ARGV[0];

system "mkdir -p $taskID/Phychem/";

sub phycheScores{
	
	$thisAA= $_[0];
	if($thisAA eq "A"){$thisvalue = "0.85,0.046,0";}
	if($thisAA eq "R"){$thisvalue = "0.2,0.291,1";}
	if($thisAA eq "N"){$thisvalue = "-0.48,0.134,0";}
	if($thisAA eq "D"){$thisvalue = "-1.1,0.105,-1";}
	if($thisAA eq "C"){$thisvalue = "2.1,0.128,0";}

	if($thisAA eq "Q"){$thisvalue = "-0.42,0.180,0";}
	if($thisAA eq "E"){$thisvalue = "-0.79,0.151,-1";}
	if($thisAA eq "G"){$thisvalue = "0,0.000,0";}
	if($thisAA eq "H"){$thisvalue = "0.22,0.230,0";}
	if($thisAA eq "I"){$thisvalue = "3.14,0.186,0";}

	if($thisAA eq "L"){$thisvalue = "1.99,0.186,0";}
	if($thisAA eq "K"){$thisvalue = "-1.19,0.219,1";}
	if($thisAA eq "M"){$thisvalue = "1.42,0.221,0";}
	if($thisAA eq "F"){$thisvalue = "1.69,0.290,0";}
	if($thisAA eq "P"){$thisvalue = "-1.14,0.131,0";}

	if($thisAA eq "S"){$thisvalue = "-0.52,0.062,0";}
	if($thisAA eq "T"){$thisvalue = "-0.08,0.108,0";}
	if($thisAA eq "W"){$thisvalue = "1.76,0.409,0";}
	if($thisAA eq "Y"){$thisvalue = "1.37,0.298,0";}
	if($thisAA eq "V"){$thisvalue = "2.53,0.140,0";}

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

	open WRITE,">$taskID/Phychem/temp_pro.txt";
	for($cn=0;$cn<$length;$cn++){
		my $thisScores=phycheScores(@AAs[$cn]);

		print WRITE $thisScores."\n";
	}
	close WRITE;




