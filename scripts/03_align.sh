#!/bin/bash
#SBATCH  --time 1-0:00:00 --ntasks 8 --nodes 1 --mem 24G --out logs/align.%a.log

module load muscle

CPU=1
if [ $SLURM_CPUS_ON_NODE ] ; then
    CPU=$SLURM_CPUS_ON_NODE
fi


INFILE=Orthogroups_nofa.tsv
N=${SLURM_ARRAY_TASK_ID}
INDIR=results
OUT=CDS_ALIGNED

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
    FILE=$INDIR/$NAME.CDS.fa
    echo $FILE
    if [ ! -f $OUT/$NAME.aligned.CDS.fa ]; then
       muscle -quiet -in $FILE -out $OUT/$NAME.aligned.CDS.fa 
    fi
done
