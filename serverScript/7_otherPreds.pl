#! /usr/bin/perl

$taskID=$ARGV[0];

# path of the result file of disoRDPbind
open READDISO,"$taskID/disoRDPbind/results.txt";
chomp(@disofile=<READDISO>);
close READDISO;

# path of the result file of DNAPred
open READDNAPRED,"$taskID/DNAPred/result.txt";
chomp(@dnaPreds=<READDNAPRED>);
close READDNAPRED;

# path of the result file of DNAgenie
open READDNAGENIE,"$taskID/DNAgenie/results.csv";
chomp(@dnageniefile=<READDNAGENIE>);
close READDNAGENIE;

#----------disoRDPbind----------------
@disoDNAinfo=split(/:/,@disofile[5]);
@disoPreds=split(/,/,@disoDNAinfo[1]);
#----------disoRDPbind----------------


#------------DNAgenie-----------------
@DNAgenieAprb=();@DNAgenieAbin=();
@DNAgenieBprb=();@DNAgenieBbin=();
@DNAgenieSSprb=();@DNAgenieSSbin=();
for($cn=3;$cn<@dnageniefile;$cn++){
	@thisinfo=split(/,/,@dnageniefile[$cn]);
	push(@DNAgenieAprb,@thisinfo[2]);
	push(@DNAgenieAbin,@thisinfo[3]);
	push(@DNAgenieBprb,@thisinfo[4]);
	push(@DNAgenieBbin,@thisinfo[5]);
	push(@DNAgenieSSprb,@thisinfo[6]);
	push(@DNAgenieSSbin,@thisinfo[7]);
}

# transfer A/B/ss-DNA binding predictions to general DNA-binding scores
@DNAgeniePreds=();
for($ck=0;$ck<@DNAgenieAbin;$ck++){
	$thisDNAgeniePred=0.000;
	if(@DNAgenieAbin[$ck] eq "1" && @DNAgenieBbin[$ck] eq "0" && @DNAgenieSSbin[$ck] eq "0"){
		$thisDNAgeniePred=@DNAgenieAprb[$ck];
	}elsif(@DNAgenieAbin[$ck] eq "0" && @DNAgenieBbin[$ck] eq "1" && @DNAgenieSSbin[$ck] eq "0"){
		$thisDNAgeniePred=@DNAgenieBprb[$ck];
	}elsif(@DNAgenieAbin[$ck] eq "0" && @DNAgenieBbin[$ck] eq "0" && @DNAgenieSSbin[$ck] eq "1"){
		$thisDNAgeniePred=@DNAgenieSSprb[$ck];
	}elsif(@DNAgenieAbin[$ck] eq "1" && @DNAgenieBbin[$ck] eq "1" && @DNAgenieSSbin[$ck] eq "0"){
		if(@DNAgenieAprb[$ck] > @DNAgenieBprb[$ck]){$thisDNAgeniePred=@DNAgenieAprb[$ck];}
		else{$thisDNAgeniePred=@DNAgenieBprb[$ck];}
	}elsif(@DNAgenieAbin[$ck] eq "1" && @DNAgenieBbin[$ck] eq "0" && @DNAgenieSSbin[$ck] eq "1"){
		if(@DNAgenieAprb[$ck] > @DNAgenieSSprb[$ck]){$thisDNAgeniePred=@DNAgenieAprb[$ck];}
		else{$thisDNAgeniePred=@DNAgenieSSprb[$ck];}
	}elsif(@DNAgenieAbin[$ck] eq "0" && @DNAgenieBbin[$ck] eq "1" && @DNAgenieSSbin[$ck] eq "1"){
		if(@DNAgenieBprb[$ck] > @DNAgenieSSprb[$ck]){$thisDNAgeniePred=@DNAgenieBprb[$ck];}
		else{$thisDNAgeniePred=@DNAgenieSSprb[$ck];}
	}elsif(@DNAgenieAbin[$ck] eq "1" && @DNAgenieBbin[$ck] eq "1" && @DNAgenieSSbin[$ck] eq "1"){
		if(@DNAgenieAprb[$ck] >= @DNAgenieBprb[$ck] && @DNAgenieAprb[$ck] >= @DNAgenieSSprb[$ck]){
			$thisDNAgeniePred=@DNAgenieAprb[$ck];
		}elsif(@DNAgenieBprb[$ck] >= @DNAgenieAprb[$ck] && @DNAgenieBprb[$ck] >= @DNAgenieSSprb[$ck]){
			$thisDNAgeniePred=@DNAgenieBprb[$ck];
		}else{
			$thisDNAgeniePred=@DNAgenieSSprb[$ck];		
		}
	}else{
		$thisDNAgeniePred=(@DNAgenieAprb[$ck]+@DNAgenieBprb[$ck]+@DNAgenieSSprb[$ck])/3;	
	}
	push(@DNAgeniePreds,$thisDNAgeniePred);
}

# normalize the predictions of DNAgenie
$minDNAg=0.0586;$maxDNAg=0.9616;
@normalDNAg=();
for($cj=0;$cj<@DNAgeniePreds;$cj++){
	$tempthisDNAg=(@DNAgeniePreds[$cj]-$minDNAg)/($maxDNAg-$minDNAg);
	push(@normalDNAg,$tempthisDNAg);
}
#------------DNAgenie-----------------


#-------------------------------------
#--------hybrid method----------------
open WRITE,">$taskID/threePreds.txt";
for($cn=0;$cn<@normalDNAg;$cn++){
	
	printf WRITE ("%4.3f,%4.3f,%4.3f\n",$disoPreds[$cn],$normalDNAg[$cn],$dnaPreds[$cn]);
}
close WRITE;



