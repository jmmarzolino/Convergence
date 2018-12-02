#!/bin/bash -l

#SBATCH -p batch
#SBATCH --ntasks=6
#SBATCH --mem=24G
#SBATCH --time=100:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/fastq_qc.out
#SBATCH --job-name='fastq_qc'
#SBATCH --array=1-36

# generate fastqc (quality reports)
# <fastqc somefile.txt someotherfile.txt --outdir=/some/other/dir/ -t # -q>
module load picard
module load fastqc/0.11.7

RESULT=/rhome/jmarz001/bigdata/convergent_evolution/quality/fastq_qc
WORK=/rhome/jmarz001/bigdata/convergent_evolution/data
cd $WORK
SEQLIST=/rhome/jmarz001/bigdata/convergent_evolution/args/fqs
ls *.fastq > $SEQLIST

FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1)
NAME=$(basename "$FILE" | cut -d. -f1 | cut -d_ -f1-3)

fastqc "$FILE" --outdir=$RESULT/"$NAME" -q

cd $RESULT
SEQS=/rhome/jmarz001/bigdata/convergent_evolution/args/fq_qcs
ls *.zip > $SEQS

FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQS | tail -n 1)
unzip $FILE