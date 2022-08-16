#  SOP for *S. Aureus* Sequence Aggregation:

## Available Scripts:

**wgetNCBI.pl** - Download genome sequences from NCBI via FTP

**clusterGenes.pl** - Graph analysis of prophage clusters

**generate_Matrix_CSV_AlisEdits.ipynb** - Pairwise sequence analysis

**get_EDGES.pl** - Creates list of genes found in a cluster

**make_Edge_list.pl** - Creates list of phage that share genes, and the # of genes shared

**Make_matrix.pl** - Create Matrix of grouped genes in phage dataset

**runBlast.pl** - Blast comparison for multiple fasta files

**Staph_wgs.txt** - *S. aureus* files downloaded/used from NCBI

The *S. aureus* genome sequences were downloaded from multiple repositories: The National Center for BioTechnology Information (NCBI) genbank (Benson, Lipman and Ostell 1993), JGI IMG/M (Chen, Chu, Palaniappan, Pillay, Ratner, Huang and Kyrpides 2019) and the DNA Data Bank of Japan (Mashima, Kodama,  Fujisawa, Katayama, Okuda, Kaminuma and Takagi 2016)

## The National Center for BioTechnology Information (NCBI) genbank
26,446 *S. aureus* whole genome sequences were downloaded from NCBI on April 5th, 2022 via [FTP](https://www.ncbi.nlm.nih.gov/genbank/ftp/):

### Get assembly list:
wget ftp://ftp.ncbi.nih.gov/genomes/genbank/bacteria/assembly_summary.txt

### Create URL file for latest Staph sequences:
```
awk -F '\t' '{if(($11=="latest")&&($12=="Complete Genome")) print $20}' assembly_summary.txt > assembly_summary_complete_genomes.txt
```

### Download all Genbank files and save to references (using wgetNCBI.pl script):
```
./wgetNCBI.pl NCBI_assembly_summary_complete_genomes.txt
```
or
### Download all Genbank files and save to references (commandline):
```
for next in $(cat assembly_summary_complete_genomes.txt); do wget -P references "$next"/*genomic.gbff.gz; done
```

The data used for this project can be found in the following directory: references_08_08_2021

### DNA Data Bank of Japan (DDBJ)
515 *S. aureus* whole genome sequences were downloaded from DDBJ on April 27th, 2022 through the [Website's UI](http://ddbj.nig.ac.jp/arsa/search?lang=en&cond=quick_search&query=staphylococcus+aureus&operator=AND).

### JGI Integrated Microbial Genomes & Microbiomes (IMG/M)
5240 S. aureus whole genome sequences were downloaded from JGI IMG/M Database on April 27th, 2022 through the [Website's UI](https://img.jgi.doe.gov/cgi-bin/m/main.cgi).

## Viral Detection:

### PhiSpy
Putative prophage sequences were detected using PhiSpy, Version 3.2 [(Akhter, Aziz and Edwards 2012)](https://doi.org/10.1093/nar/gks406). PhiSpy uses a random forest algorithm that has been trained on seven distinct features of prophage: protein length, transcription strand directionality, AT and GC skew, the abundance of unique phage words (unique sequence of length 12 base pairs), phage insertion points and the similarity of phage proteins.  PhiSpy has 49 available training sets to increase accuracy for specific genomes.

### Virsorter2

## Phage Clustering:
## Validate of predicted phage:
## Unique Phage Sequence Annotation:
