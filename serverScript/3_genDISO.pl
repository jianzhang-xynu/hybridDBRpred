#! /usr/bin/perl

$taskID=$ARGV[0];

system "mkdir -p $taskID/DISOshort/";
system "mkdir -p $taskID/DISOlong/";

$IUPRED3A_dir="/home/ubuntu/iupred3"; # NEED check the path of iupred3
$thisServer_dir="$taskID";


system "python3 $IUPRED3A_dir/iupred3.py $taskID/fastas/temp_pro.txt short > $thisServer_dir/DISOshort/temp_pro.disoout";
system "python3 $IUPRED3A_dir/iupred3.py $taskID/fastas/temp_pro.txt long > $thisServer_dir/DISOlong/temp_pro.disoout";




