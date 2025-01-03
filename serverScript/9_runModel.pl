#! /usr/bin/perl

$taskID=$ARGV[0];

system "cp $taskID/feasComb/temp_pro.comb feasfolder/temp_pro.txt";
system "python3 forWebUse.py";

system "mv final_preds/DNA_preds.txt $taskID/finalPreds.txt";
system "rm feasfolder/temp_pro.txt";
