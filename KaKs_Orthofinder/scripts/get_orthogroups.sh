#!/bin/bash

module load ncbi-blast/2.2.30+

filename=$1
while read line; do # reading each line

cd Duplicate_Orthogroups_Tania/ | cat $line | tblastn -query $line -db Friedmanniomyces_endolithicus_CCFEE_5311 -outfmt 6 -num_threads 3 -max_target_seqs 2000 -out $line.tab

done < $filename
