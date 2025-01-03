#! /usr/bin/perl

$taskID=$ARGV[0];

#calculate values
system "perl serverScript/0_split.pl $taskID";
system "perl serverScript/1_genRSA.pl $taskID";
system "perl serverScript/2_getPhychem.pl $taskID";
system "perl serverScript/3_genDISO.pl $taskID";
system "perl serverScript/4_getTOPIDP.pl $taskID";
system "perl serverScript/5_getDISOfeas.pl $taskID";
system "perl serverScript/6_getdiso_Feas.pl $taskID";
system "perl serverScript/7_otherPreds.pl $taskID";
system "perl serverScript/8_combFeas.pl $taskID";
system "perl serverScript/9_runModel.pl $taskID";

