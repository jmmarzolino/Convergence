#!/bin/bash -l

#SBATCH -p batch
#SBATCH --ntasks=4
#SBATCH --mem=15G
#SBATCH --time=10:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/prep.out
#SBATCH --job-name='prep'

WORKINGDIR=rhome/jmarz001/shared/SEQ_RUNS/10_8_2018/FASTQ/
RESULTSDIR=/rhome/jmarz001/bigdata/convergent_evolution

for file in $WORKINGDIR/*.fastq.gz
do
  cp "$file" $RESULTSDIR/data/
done

cd $RESULTSDIR
gunzip *