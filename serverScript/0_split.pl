#! /usr/bin/perl

$taskID=$ARGV[0];

print $taskID."\n";
system "mkdir -p $taskID/orgifastas/";
system "mkdir -p $taskID/fastas/";

open READ,"$taskID/$taskID.txt" or die "read error\n";
open NAME,">$taskID/name.txt";

while($eachline=<READ>){
	chomp($eachline);
	if($eachline =~ /^>/){
		print NAME $eachline."\n";
		open FASTA,">$taskID/orgifastas/temp_pro.txt";
		print FASTA $eachline."\n";
		close FASTA;
	}else{
		open FASTA,">>$taskID/orgifastas/temp_pro.txt";
		print FASTA $eachline."\n";
		close FASTA;
	}
}
close READ;
close NAME;


	open FASTA,"$taskID/orgifastas/temp_pro.txt";
	chomp(@array=<FASTA>);
	close FASTA;

	@callen=split(//,@array[1]);
	$length=0;$templen=0;
	for($temp=0;$temp<@callen;$temp++){
		if(@callen[$temp] =~ /[A-Z]/){$templen++;}
	}
	$length=$templen;

	$proID=@array[0];
	@AA=split(//,@array[1]);
	
	open WRITE,">$taskID/fastas/temp_pro.txt";
	print WRITE $proID."\n";
	for($cm=0;$cm<$length;$cm++){
		if(@AA[$cm] =~ /B|J|O|U|X|Z/){
			print WRITE "C";
		}else{
			print WRITE @AA[$cm];
		}
	}
	print WRITE "\n";
	close WRITE;

