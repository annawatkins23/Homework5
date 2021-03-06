#################
#!/bin/env sh
#################

####################################
##Commands to run before varaibles and modules
#A directory was created for the class lecture
mkdir ClassLectureFeb21

#the files needed for the lecture were copied over from a supplied shared folder
cp ./class_shared/GuestLectureII/AT* ./ClassLectureFeb21/
cp ./class_shared/GuestLectureII/test.fasta ./ClassLectureFeb21/

#moved into the lecture directory and load blast module
cd ClassLectureFeb21/
##################################

##########################
###Modules
module load blast+
#########################

#################
##Variable
test=test.fasta
#################

########################################
##Commands
#Creation of Blast databases for mitochondrial, chlorophyll, and Chromosome 5 DNA sequences fpr Arabidopsis Thaliana, as there were no databases yet for these portions of the genome
makeblastdb -in ATchrV.fasta -dbtype nucl
makeblastdb -in ATcp.fasta -dbtype nucl
makeblastdb -in ATmt.fasta -dbtype nucl

#The command below can be used to view the README file for the Arabidopsis Thaliana documents and databases
#less /apps/bio/unzipped/genomes/Arabidopsis_thaliana/README

##Used to check the number of files for Chromosome 1
#ls /apps/bio/unzipped/genomes/Arabidopsis_thaliana/CHR_I

#creation of a link within the current working directory back to the databases for Arabidopsis Thaliana that already existed
ln -s /apps/bio/unzipped/genomes/Arabidopsis_thaliana/ .

#Several different output formats for Blast were viewed to determine the ideal one for the information desired, Output format 7 was chosen (tabular with comment lines, as this would give the most information in an somewhat easy to view manner) a more comprehesive list can be found using blastn -help
#blastn -query $test -db ATmt.fasta -outfmt 17 | less -S
#blastn -query $test -db ATmt.fasta -outfmt 6 | less -S
#blastn -query $test -db ATcp.fasta -outfmt 7 | less -S
#blastn -query $test -db ATmt.fasta -outfmt 7 | less -S

#output from blast saved into files to be compared later
#blastn -query $test -db ATmt.fasta -outfmt 7 >qtest_dbmt.blastn_out
#blastn -query $test -db ATmt.fasta -outfmt 7 >qtest_dbmt.blastn_out
#blastn -query $test -db ATcp.fasta -outfmt 7 >qtest_dbcp.blastn_out
#blastn -query $test -db Arabidopsis_thaliana/CHR_I/NC_003070.gbk -outfmt 7 >qtest_dbI.blastn_out

##example query to determine amount of hits in database
#grep "ATMG00020.1" qtest_dbcp.blastn_out 
#grep "ATMG00020.1" qtest_dbI.blastn_out 
#blastn -db "ATmt.fasta ATcp.fasta Arabidopsis_thaliana/CHR_I/NC_003070.gbk Arabidopsis_thaliana/CHR_II/NC_003070.gbk Arabidopsis_thaliana/CHR_III/NC_003070.gbk Arabidopsis_thaliana/CHR_IV/NC_003070.gbk" -query $test -outfmt 7 | less -S 
#blastn -db "ATmt.fasta ATcp.fasta Arabidopsis_thaliana/CHR_I/NC_003070.gbk Arabidopsis_thaliana/CHR_II/NC_003071.gbk Arabidopsis_thaliana/CHR_III/NC_003074.gbk Arabidopsis_thaliana/CHR_IV/NC_003075.gbk" -query $test -outfmt 7 | less -S 

##Blast and awk command build script and analyze only those results with one matched sequence hit, and a good quality score 
#blastn -db "ATmt.fasta ATcp.fasta Arabidopsis_thaliana/CHR_I/NC_003070.gbk Arabidopsis_thaliana/CHR_II/NC_003071.gbk Arabidopsis_thaliana/CHR_III/NC_003074.gbk Arabidopsis_thaliana/CHR_IV/NC_003075.gbk" -query $test -evalue 0.00001 -max_target_seqs 1 -outfmt 7 | less -S 
#blastn -db "ATmt.fasta ATcp.fasta Arabidopsis_thaliana/CHR_I/NC_003070.gbk Arabidopsis_thaliana/CHR_II/NC_003071.gbk Arabidopsis_thaliana/CHR_III/NC_003074.gbk Arabidopsis_thaliana/CHR_IV/NC_003075.gbk" -query $test -evalue 0.00001 -max_target_seqs 1 -outfmt 7 |egrep -v '^#' | less -S 
#blastn -db "ATmt.fasta ATcp.fasta Arabidopsis_thaliana/CHR_I/NC_003070.gbk Arabidopsis_thaliana/CHR_II/NC_003071.gbk Arabidopsis_thaliana/CHR_III/NC_003074.gbk Arabidopsis_thaliana/CHR_IV/NC_003075.gbk" -query $test -evalue 0.00001 -max_target_seqs 1 -outfmt 7 |egrep -v '^#' | sed 's/[[:space:]]1_\/home.*NC_[0-9]*[[:space:]]/\tNT\t/' | awk '{print $1,$2}' | less -S 

##This command isolated the number of hits within the searched compared chromosomes sequences (all together), chlorophyll sequences, and mitochondrial sequences, and will print the output in an easy to read format, however this missed those options where no matched seqeunces occured.
blastn -db "ATmt.fasta ATcp.fasta Arabidopsis_thaliana/CHR_I/NC_003070.gbk Arabidopsis_thaliana/CHR_II/NC_003071.gbk Arabidopsis_thaliana/CHR_III/NC_003074.gbk Arabidopsis_thaliana/CHR_IV/NC_003075.gbk" -query test.fasta -evalue 0.00001 -max_target_seqs 1 -outfmt 7 |egrep -v '^#' | sed 's/[[:space:]]1_\/home.*NC_[0-9]*[[:space:]]/\tNT\t/' | awk '{print $1,$2}' |sort | uniq | awk '{print $2}' | sort | uniq -c | sort -n > RawCounts.txt 

#less -S qtest_dbI.blastn_out

##used to determine how many occurences where there were no matched sequences found
#grep '0 hits ' qtest_dbcp.blastn_out 
#grep -c '0 hits ' qtest_dbcp.blastn_out 

##Building process for the command to isolate instances where no matched sequences occured (no hits), and add this information into the RawCounts.txt file
#blastn -db "ATcp.fasta ATmt.fasta ATchrV.fasta Arabidopsis_thaliana/CHR_I/NC_003070.gbk Arbidopsis_thaliana/CHR_II/NC_003071.gbk Arabidopsis_thaliana/CHR_III/NC_003074.gbk Arabidopsis_thaliana/CHRIV/NC_003075.gbk" -query test.fasta -outfmt 7 -evalue 0.00001 -max_target_seqs 1 | grep -c ' 0 hits'

NUM=$(blastn -db "ATmt.fasta ATcp.fasta ATmt.fasta ATchrV.fasta Arabidopsis_thaliana/CHR_I/NC_003070.gbk Arbidopsis_thaliana/CHR_II/NC_003071.gbk Arabidopsis_thaliana/CHR_III/NC_003074.gbk Arabidopsis_thaliana/CHRIV/NC_003075.gbk" -query test.fast -outfmt 7 -evalue 0.00001 -max_target_seqs 1 | grep -c ' 0 hits' ) && echo $NUM No_hits >> RawCounts.txt
head RawCounts.txt
########################
