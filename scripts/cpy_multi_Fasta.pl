#!/usr/bin/perl
use strict;
use warnings;
use File::Find;

if($#ARGV<0){
        die "Usage: ./exe.pl {Directory List} {Path/to/Source/Directory} {Path/to/Destination/Directory} {File extension}\n";
}
#This script does the following:
# 1. Input will be a list of directories, and a path to the directory you want to write output files to, and the extension of the files that you're looking for
# 2. Checking each directory on the list, I want to go in and find files ending in specific extensions such as ".ffn" for Prokka and "necleuotice.seq.txt"
# 3. I want to rename the file with the Directory name's accession # and phage #
# 4. Output will the moved renamed file to the present directory

my $DIRECTORIES           = $ARGV[0]; #List of Directories to check
my $SRC		   = $ARGV[1], #Path to the source directory where the data is located
my $DEST		   = $ARGV[2]; #Path to directory you want the files to move
my $EXTENSION		   = $ARGV[3]; #File extension of the files you want to rename and move

my $FILE_LIST = "PROKKA_DIRECTORIES";
open(F,$FILE_LIST) or die "Could not open $DIRECTORIES\n";

#Split Directory name by a "." then rename the file I'm moving using columns 1 and 2
#     0               1                2   
#GCA_900482705.1_7915_6_43_genomic.gbff_pp16

#I want to replace column 0 with columns 1$2 above
#    0            1
#PROKKA_05152020.ffn

my $dirToRun = "";
my @stringSpit="";
my $newFileName="";
while(my $line = <F>){
      chomp($line);
      $dirToRun = $line;
#      ($First,$Last) = split '\.',"a.b"
      @stringSpit = split('\.',$line);
      $newFileName = $stringSpit[1].".".$stringSpit[2];
      print STDERR "Your file name is $newFileName\n";
      print STDERR "Your're currently running $dirToRun\n";
      my $CMD =  "cp $SRC/$dirToRun/*.$EXTENSION $DEST/$dirToRun.$EXTENSION";
      print STDERR "$CMD\n";
      system($CMD);
}
print STDERR "Finished Successfully\n";
