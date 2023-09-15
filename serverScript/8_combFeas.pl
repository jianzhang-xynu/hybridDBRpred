#! /usr/bin/perl

$taskID=$ARGV[0];
system "mkdir -p $taskID/feasComb/";


	open PREDS,"$taskID/threePreds.txt" or die "read error\n";
	chomp(@preds=<PREDS>);
	close PREDS;

	open PHYCHEM,"$taskID/Phychem/temp_pro.txt" or die "PHYCHEM error\n";
	chomp(@phychem=<PHYCHEM>);
	close PHYCHEM;

	open IUPRED,"$taskID/DISOscores/temp_pro.txt" or die "IUPRED error\n";
	chomp(@iupred=<IUPRED>);
	close IUPRED;

	open RSA,"$taskID/RSA/temp_pro.rsa" or die "RSA error\n";
	chomp(@rsa=<RSA>);
	close RSA;

	open TOPIDP,"$taskID/TOPIDP/temp_pro.txt" or die "TOPIDP error\n";
	chomp(@topidp=<TOPIDP>);
	close TOPIDP;

	open DISOCNTENT,"$taskID/Diso_ctent/temp_pro.txt" or die "DISOCNTENT error\n";
	chomp(@disocntent=<DISOCNTENT>);
	close DISOCNTENT;

	$predlen=@preds;


	open WRITE,">$taskID/feasComb/temp_pro.comb";
	for($count=0;$count<$predlen;$count++){
		print WRITE @preds[$count].",".@phychem[$count].",".@iupred[$count].",".@rsa[$count].",".@topidp[$count].",".@disocntent[$count]."\n";
	}
	close WRITE;





