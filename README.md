# Homework5

##Main 
Creation of Blast databases for mitochondrial, chlorophyll, and Chromosome 5 DNA sequences fpr Arabidopsis Thaliana, as there were no databases yet for these portions of the genome

makeblastdb -in ATchrV.fasta -dbtype nucl 
makeblastdb -in ATcp.fasta -dbtype nucl 
makeblastdb -in ATmt.fasta -dbtype nucl 
