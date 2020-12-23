#!/bin/bash

module load ncbi-blast/2.2.30+

find *.fa.seqID | xargs -I{} -n 1 cat {} | grep CCFEE5311 | blastdbcmd -entry {} -db Friedmanniomyces_endolithicus_CCFEE_5311 >> {}.CDS.fa
find *.fa.seqID | xargs -I{} -n 1 cat {} | grep	NAJQ01 | blastdbcmd -entry {} -db  Friedmanniomyces_simplex_CCFEE_5184 >> {}.CDS.fa
find *.fa.seqID | xargs -I{} -n 1 cat {} | grep	MUNK01 | blastdbcmd -entry {} -db  Hortaea_werneckii_EXF-2000-UCR >> {}.CDS.fa
