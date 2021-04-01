#!/usr/bin/perl


if($#ARGV<0){
        die "Usage: ./exe.pl {INDEX}\n";
}

$index = $ARGV[0];


$FILE_LIST = "FASTA_FILES";
open(F,$FILE_LIST) or die "Could not open $FILE_LIST\n";

$i = 1;
$found = 0;
$dirToRun = "";
while($line = <F> || $found == 0){

        if($i == $index){
                chomp($line);
                $dirToRun = $line;
                $found = 1;
        }
        $i = $i + 1;
}

print STDERR "We are running $dirToRun\n";

$OUTDIR = $dirToRun;
$INDIR  = "/Going_through_Phages/results/prokka_Phage_Clusters/".$dirToRun;

$CMD =  "blastn -db prokkaGeneAnnotations.db -query $INDIR -out $OUTDIR.blastn -max_target_seqs 12000 -outfmt '7 qseqid sseqid pident qlen qcovs slen length mismatch gapope evalue bitscore'";
print STDERR "$CMD\n";
system($CMD); #In perl this is how you run something on the commandline.
print STDERR "FINISHED SUCCESSFULLY";
