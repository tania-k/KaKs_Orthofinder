#!/usr/bin/bash
#SBATCH -N 1 -n 8 --mem 2gb -p short --out logs/makepairs.%a.log -J makepairs
module load fasta
module unload perl
module load subopt-kaks
module load muscle


CPUS=$SLURM_CPUS_ON_NODE
if [ -z $CPUS ]; then
	CPUS=1
fi
N=${SLURM_ARRAY_TASK_ID}

if [ -z $N ]; then
    N=$1
    if [ -z $N ]; then
        echo "Need an array id or cmdline val for the job"
        exit
    fi
fi

INFILE=samples.tsv
PEPDIR=pep
PEPEXT=aa.fasta
IN=results
PAIRS=pairs
OUTKAKS=kaks
YN00=$(which yn00_cds_prealigned)
if [ ! -f $YN00 ]; then
    echo "need to have installed yn00_cds_prealigned - see https://github.com/hyphaltip/subopt-kaks"
    
    exit
fi
TEMP=/scratch
mkdir -p $PAIRS $OUTKAKS
sed -n ${N}p $INFILE | while read NAME
do

    F=$IN/$NAME.FASTA.tab
    prefix=$(head -n 1 $PEPDIR/$NAME.$PEPEXT | perl -p -e 's/^>([^\|]+)\|.+/$1/')
    if [ ! -d $PAIRS/$prefix ]; then
	perl scripts/make_pair_seqfiles.pl -t $TEMP -i $F -o $PAIRS
    fi
    parallel -j $CPUS muscle -quiet -in {} -out {}.aln ::: $PAIRS/$prefix/*.pep
    parallel -j $CPUS ./scripts/bp_mrtrans.pl -i {}.aln -if fasta -s {.}.cds -of fasta -o {.}.cds.aln ::: $PAIRS/$prefix/*.pep

    cp lib/yn00_header.tsv $OUTKAKS/$NAME.yn00.tab
    $YN00 pairs/$prefix/*.cds.aln | grep -v '^SEQ1' >> $OUTKAKS/$NAME.yn00.tab
done
