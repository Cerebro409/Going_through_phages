#!/usr/bin/perl
use strict;
use warnings;

#	This Script will do the following:
#
#	Step 1:
#		Inputs: Clusters of genes sequences with the clustersize leading.
#
#			  0		1		2		3		4		5		6		7		8	
#		Example: 8	PHBHOCAB_00002,IFAAAHMD_00008,BLGPNOEN_00002,AEAFPCAL_00003,CKIFJHEA_00005,PODMHCNB_00003,LKIPDCDL_00003,AGBBPLPD_00005
#
#		Read in this file, and parse out all of the genes (1-8 in example)
#	
#	Step 2:	
#		Take each gene and searches a directory to find which file the gene came from (each gene has a unique name) and creates a list: my $CMD =  "grep $geneToFind *.ffn >> gene_info";
#				0                                  1                     2		
#		Example:	Prophage			gene			function
#			 1_ASM16041v1_genomic.gbff_pp13.ffn:>EFEAKEDL_00048 "Glycine betaine transporter OpuD"
#
#	Step 3:
#		Take each prophage (191 which is the list of all genomes) 
#
#	Output: List that looks like the following
#		
#		Prophage name1, Prophage name2, number of genes in common
#
# Keep propahge in array during for loop,
# Print out the forma



if($#ARGV<0){
        die "Usage: ./exe.pl {PATH} {COMPONENTS}\n"; # ./make_Edge_list.pl /Going_through_Phages/results/prokka_Phage_Clusters/ PROKKA_CONNECTED_COMPONENTS
}

my $SRC           	   = $ARGV[0]; #List of Directories to check
my $COMPONENTS 	   = $ARGV[1];

open(F,$COMPONENTS) or die "Could not open $COMPONENTS\n";

my $geneToRun   = "";
my $gene      ="";

my %edges;
while(my $line = <F>){

	chomp($line);
	$geneToRun = $line;
	# @args=split(/\s+/,$line)
        my @stringsplit = split(/\s+/,$line);
        my $clustersize = $stringsplit[0];
        $gene = $stringsplit[1];
	print STDERR "The genes in your cluster group are: $gene \n";
	
	if($clustersize > 1){
	   my @genesplit = split(/,/,$gene);
	   my @phage_names;
	   for(my $i=0; $i<$clustersize; $i++){
	       $geneToRun = $genesplit[$i];
	       print STDERR "You're processing gene: $geneToRun\n"; 
	       #my $CMD =  "grep $geneToRun *.ffn;
	       
	       my $grepOutput = `grep $geneToRun *.seq`;
	       print STDERR "The gene was found in this file: $grepOutput";
	       my @args = split(/\:/,$grepOutput);
	       print STDERR "The prophage name is: $args[0]\n";
	       #my $phage_name = $args[0];
	       $phage_names[$i] = $args[0];
	       print STDERR "The prophage name should match the one above: $phage_names[$i]\n";
              #system($CMD);
	   }
	   for(my $i = 0; $i<$clustersize; $i++){ 
	   	for(my $j = $i+1; $j<$clustersize; $j++){
	   		$edges{$phage_names[$i]}{$phage_names[$j]}++;
	   		$edges{$phage_names[$j]}{$phage_names[$i]}++;
	   	}
	   }
	}
}
foreach my $phage1 (sort keys %edges) {
    foreach my $phage2 (keys %{ $edges{$phage1} }) {
        print "$phage1, $phage2, $edges{$phage1}{$phage2}  \n";
    }
}
print STDERR "Finished Successfully\n";
