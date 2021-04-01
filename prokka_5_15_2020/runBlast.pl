#!/usr/bin/perl


if($#ARGV<0){
        die "Usage: ./exe.pl {INDEX}\n";
}

$index = $ARGV[0];


$FILE_LIST = "PROKKA_FASTA_LIST";
open(F,$FILE_LIST) or die "Could not open $FILE_LIST\n";

$i = 1;
$dirToRun = "";
while($line = <F>){
     chomp($line);
     $dirToRun = $line;
     print STDERR "We are running $dirToRun\n";
     $OUTDIR = $dirToRun;
     $INDIR  = "/home/tsweet/Going_through_phages/prokka_5_15_2020/".$dirToRun;
     $CMD =  "blastn -db PROKKAdb -query $INDIR -out $OUTDIR.blastn -max_target_seqs 12000 -outfmt '7 qseqid sseqid pident qlen qcovs slen length mismatch gapope evalue bitscore'";
     print STDERR "$CMD\n";
     system($CMD); #In perl this is how you run something on the commandline.
}
print STDERR "Finished Successfully";
