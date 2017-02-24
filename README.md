# Homework5

##Introduction
The purpose of the script is to use a BLAST tool to search through DNA sequences of five different chromosome of *Arabidopsis thaliana*, as well as the DNA sequences for the mitochondria and chlorophyl present in the species and determine if a test fasta contained DNA sequence portions that matched those in the sequence databases for *Arabidopsis thaliana*. The information from the search also outputs the local alignment scores and additonal information.

##Motivation
This provides an easy working script that can be used to compare any fasta type file against sequence databases for *Arabidopsis thaliana*. BLAST is a higly useful tool in that it can be used to map annotations from one species to another, map DNA to a known chromsome, generate a phylogenetic tree, and many more things. This information and more uses for BLAST can be found [here](http://resources.qiagenbioinformatics.com/manuals/clcmainworkbench/current/index.php?manual=Examples_BLAST_usage.html).

##Code

This portion of the code is used to created Blast databases for mitochondrial, chlorophyll, and Chromosome 5 DNA sequences fpr Arabidopsis Thaliana, as there were no databases yet for these portions of the genome within the obtained documents
````
makeblastdb -in ATchrV.fasta -dbtype nucl 
makeblastdb -in ATcp.fasta -dbtype nucl 
makeblastdb -in ATmt.fasta -dbtype nucl 
````
