#!/bin/bash

ncbi-blast/2.2.30+

filename=$1
while read line; do # reading each line

for id in $line; do
blastdbcmd -entry $id -db Friedmanniomyces_endolithicus_CCFEE_5311 >> $line.CDS.fa
blastdbcmd -entry $id -db Friedmanniomyces_simplex_CCFEE_5184 >> $line.CDS.fa
blastdbcmd -entry $id -db Hortaea_werneckii_EXF-2000-UCR >> $line.CDS.fa

done < $filename
