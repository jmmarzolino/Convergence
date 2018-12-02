#!/bin/bash -l

#SBATCH --ntasks=5
#SBATCH --mem=20G
#SBATCH --time=1:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/unzip.stdout
#SBATCH --job-name='unzip'
#SBATCH -p batch
#SBATCH --array=1-36

DIR=/rhome/jmarz001/bigdata/convergent_evolution/quality/fastq_qc
cd $DIR
SEQS=/rhome/jmarz001/bigdata/convergent_evolution/args/fq_qcs
ls *.zip > $SEQS
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)
unzip $FILE