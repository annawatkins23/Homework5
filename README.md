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

The following BLAST command were used to isolate the number of query hits within the chromosomes, mitchondria, and chlorophyl sequenes and output that information into an easy to read format. This command, however, does leave out the areas where no query hit was found.
````
blastn -db "ATmt.fasta ATcp.fasta Arabidopsis_thaliana/CHR_I/NC_003070.gbk Arabidopsis_thaliana/CHR_II/NC_003071.gbk Arabidopsis_thaliana/CHR_III/NC_003074.gbk Arabidopsis_thaliana/CHR_IV/NC_003075.gbk" -query test.fasta -evalue 0.00001 -max_target_seqs 1 -outfmt 7 |egrep -v '^#' | sed 's/[[:space:]]1_\/home.*NC_[0-9]*[[:space:]]/\tNT\t/' | awk '{print $1,$2}' |sort | uniq | awk '{print $2}' | sort | uniq -c | sort -n > RawCounts.txt 
````

This is the blast command that was used to determine the numbers where no query hits were determined. This number was saved into a variable to then be printed into the same file as the previously obtained infomation for easy access to the information.
````
NUM=$(blastn -db "ATmt.fasta ATcp.fasta ATmt.fasta ATchrV.fasta Arabidopsis_thaliana/CHR_I/NC_003070.gbk Arbidopsis_thaliana/CHR_II/NC_003071.gbk Arabidopsis_thaliana/CHR_III/NC_003074.gbk Arabidopsis_thaliana/CHRIV/NC_003075.gbk" -query test.fast -outfmt 7 -evalue 0.00001 -max_target_seqs 1 | grep -c ' 0 hits' ) && echo $NUM No_hits >> RawCounts.txt
````

##Output of the Code
The resulting information from this command will be in a tab delimited file that will resemble the following table without the header. In this table MT reprsents mitchondrial, CP represents chlorophyl, NT represents chromosomal.

| Number of Query Hits | DNA Seq. Type |
|----------------------|---------------|
| 76 | MT |
| 132 | CP |
| 370 | NT |
| 1 | No_hits |
