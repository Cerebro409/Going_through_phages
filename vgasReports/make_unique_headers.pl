#!/usr/bin/perl
use strict;
use warnings;
use File::Find;

if($#ARGV<0){
        die "Usage: ./exe.pl {DIRECTORIES}\n";
}

my $DIRECTORIES           = $ARGV[0]; #List of Directories to check

my $FILE_LIST = "VGAS_FINAL";
my $COUNTER = 0;
open(F,$FILE_LIST) or die "Could not open $DIRECTORIES\n";
my $dirToRun = "";
while(my $line = <F>){
      chomp($line);
      $COUNTER++;
      $dirToRun = $line;
      print STDERR "Your're currently running $dirToRun\n";
      # sed -e 's/Potential/testing/' -e 's/chr_V/V/' -e 's/chr_X/X/' testing > testing.fasta
      my $CMD =  "awk \'/^>/ {$1=$1 "_" ++i}1\' $dirToRun > $dirToRun.clean;
      print STDERR "$CMD\n";
      system($CMD);
}
print STDERR "Finished Successfully\n";
