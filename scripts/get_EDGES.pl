#!/usr/bin/perl
use strict;
use warnings;

if($#ARGV<0){
        die "Usage: ./exe.pl {Path/to/Source/Directory}\n";
}

# This script does the following:
#	Input is a comma-delimeted Textfile (CSV)

#	0		        1     2      	
#	clustersize (int)	gene, gene (number of genes varies)

#	Process:
#	I want to take each line from the file, and create a new file named "clustergroup_(whichever line)" and write out a list of the genes to a file

#	Output will be a file named "clustergroup_#", that has a list of the genes
#
#
#
#	Example:
#	Filename = clustergroup_1
#
#	Contents:		gene1
#				gene2
#				gene3
#
#


my $SRC           = $ARGV[0]; #List of Directories to check
my $FILE_LIST = $SRC;
open(F,$FILE_LIST) or die "Could not open $FILE_LIST\n";

my $clusterGroup = "";
while(my $line = <F>){
      chomp($line);
      $clusterGroup = $line;
      print STDERR "Your're currently running $clusterGroup\n";
      
      my @genes = split(',', $clusterGroup);
      foreach my $group (@genes) {
              print "$group\n";
              }
}
print STDERR "Finished Successfully\n";
