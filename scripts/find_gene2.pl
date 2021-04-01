#!/usr/bin/perl
use strict;
use warnings;
use File::Find;

if($#ARGV<0){
        die "Usage: ./exe.pl {DIRECTORIES}\n";
}

my $DIRECTORIES           = $ARGV[0]; #List of Directories to check
my $FILE_LIST = "GENES";
open(F,$FILE_LIST) or die "Could not open $DIRECTORIES\n";
my $geneToFind  = "";
my $newFileName = "";
my @stringSpit="";
while(my $line = <F>){
      chomp($line);
      $geneToFind = $line;
      print STDERR "Your're currently running $geneToFind\n";
      # grep -r $_ Satheesh | tee out.txt
      @stringSpit = split('\ ',$geneToFind);
      $newFileName = @stringSpit[0];
      print STDERR "Your Gene $newFileName\n";
      my $CMD =  "grep $newFileName *.ffn >> gene_info";
      print STDERR "$CMD\n";
      system($CMD);
}
print STDERR "Finished Successfully\n";
