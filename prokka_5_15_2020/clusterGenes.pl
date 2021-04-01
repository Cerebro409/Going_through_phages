#!/usr/bin/perl


use strict;

my %GENES;
my %edges;

#Steps:
#(1) Read in and determine the nodes in the graph; DONE
#(2) Determine the edges in the graph DONE
#(3) Determine the connected components


my $FILE = "PROKKA.blastn";
open(F,$FILE);
while(my $line = <F>){
    chomp($line);
    if ($line =~ /\# Query/) { #If # Query
        # 0   1           2
        # # Query: JJAHEJNG_00002 hypothetical protein
        my @args=split(/\s+/,$line);
        my $geneName = $args[2];
        $GENES{$geneName} = 0;
    #print "GeneName = $geneName\n";
    }
    elsif($line=~/\#/){ # If it contains #
        
    }
    else{ #Does not contain #
        #     0                 1           2     3       4       5        6     7
        #KLDBMHLK_00002  EJFJIICA_00030  100.000 762     100     762     762     0       0.0     1408
        #            0          1            2           3                   4                      5                6
        # Fields: query id, subject id, % identity, query length, % query coverage per subject, subject length, alignment length, mismatches, evalue, bit score
       
        #print "\t$line\n";
        
        my @args=split(/\s+/,$line);
        my $NODE1 = $args[0];
        my $NODE2 = $args[1];
        my $PCTID = $args[2];
        my $PCTQRY = $args[4];
        my $PCTSUB = ($args[6]/$args[5])*100; #(AlignmentLength/SubjectLength)*100
        
        #print "\tPctID: $PCTID\tPctQry: $PCTQRY\tPctSub: $PCTSUB\n";
        
        if($PCTID >= 99 and $PCTQRY >= 90 and $PCTSUB >=90){
            if(exists($edges{$NODE1}) ){ $edges{$NODE1} = $edges{$NODE1}."\t".$NODE2; }
            else{ $edges{$NODE1} = $NODE2; }
            
            if(exists($edges{$NODE2}) ){ $edges{$NODE2} = $edges{$NODE2}."\t".$NODE1; }
            else{ $edges{$NODE2} = $NODE1; }
            
            #print "\t\t**Adding Edge $NODE1 to $NODE2\n";
        }
        
    }
}
close(F);

#Calculate Connected Components
foreach my $gene (keys %GENES)
{
    if($GENES{$gene}==0){
        print STDERR "We are exploring gene: $gene\n";

        #We have not visited it yet, let's explore the other genes linked to it.
        $GENES{$gene} = 1; #mark visited
        
        my $toVisitCurrent = $edges{$gene};
        my $componentSize = 1;
        my $connectedComponent = $gene;
        my $toVisitNext = "";
    
        my $loopIterate = 1;
        while(length($toVisitCurrent)>0){
            print STDERR "\tLoop Iterate:$loopIterate\tComponent Size: $componentSize\n";
            my @args     = split(/\t/,$toVisitCurrent);
            my $numEdges = split(/\t/,$toVisitCurrent); #The number of genes with an edge to this gene.
            
            
            $toVisitNext = "";
           for(my $i = 1; $i<$numEdges; $i++){
               my $nodeCurr = $args[$i];
               if($GENES{$nodeCurr} == 0){
                   $GENES{$nodeCurr} = 1; #mark visited
                   $componentSize++;
                   $connectedComponent = $connectedComponent.",".$nodeCurr;
                   if(length($toVisitNext)>0){
                       $toVisitNext = $toVisitNext."\t".$edges{$nodeCurr};
                   }
                   else{
                       $toVisitNext = $edges{$nodeCurr};
                   }
                   
                   #Clean Up $toVisitNext
                   my @words = split(/\t/,$toVisitNext);
                   my @unique_words = uniqNew(@words);
                   $toVisitNext = join("\t",@unique_words);
               }
           } #End For
            
            #print "\tLoop Start:\t$toVisitCurrent\n";
            #print "\tLoop End:\t$toVisitNext\n";
            #print "\t******************\n";
            
            $toVisitCurrent = $toVisitNext;
            $loopIterate++;
        } #End While
        
        #Now we need to print the connected component
        #print "$componentSize\t$connectedComponent\n";
        my @args     = split(/\,/,$connectedComponent);
        my $numNodes = split(/\,/,$connectedComponent);
        print "$componentSize\t";
        for(my $i = 0; $i<$numNodes; $i++){
            my $currNode = $args[$i];
            if($i<($numNodes-1)) { print "$currNode,"; }
            else{ print "$currNode\n";}
        }
    }
    else{
        #We already visited, we are done.
    }
}

print STDERR "Finished Successfully\n";



###############
## SUBROUTINE #
###############

sub uniqNew (@) {
    my %seen = ();
    grep { not $seen{$_}++ } @_;
}
