#!/bin/bash
#SBATCH  --time 1-0:00:00 --ntasks 8 --nodes 1 --mem 24G --out logs/fasta.%a.log

module load ncbi-blast/2.2.30+

CPU=1
if [ $SLURM_CPUS_ON_NODE ] ; then
    CPU=$SLURM_CPUS_ON_NODE
fi


INFILE=Orthogroups_nofa.tsv
N=${SLURM_ARRAY_TASK_ID}
INDIR=seqIDS
OUT=results

if [ ! $N ]; then
    N=$1
    if [ ! $N ]; then
        echo "need to provide a number by --array or cmdline"
        exit
    fi
fi

IFS=,
sed -n ${N}p $INFILE | while read NAME
do
    FILE=$INDIR/$NAME.fa.seqID 
    echo $FILE
    if [ ! -f $OUT/$NAME.CDS.fa ]; then
        cat $FILE | xargs -I{} -n 1 grep CCFEE5311 | blastdbcmd -entry $FILE -db Friedmanniomyces_endolithicus_CCFEE_5311 >> $NAME.CDS.fa
        cat $FILE | xargs -I{} -n 1 grep NAJQ01 | blastdbcmd -entry $FILE -db  Friedmanniomyces_simplex_CCFEE_5184 >> $NAME.CDS.fa
        cat $FILE | xargs -I{} -n 1 grep MUNK01 | blastdbcmd -entry $FILE -db  Hortaea_werneckii_EXF-2000-UCR >> $NAME.CDS.fa
    fi
done
