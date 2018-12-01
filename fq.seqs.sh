#!/bin/bash -l

#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/fq_seqs.stdout
#SBATCH --job-name='seqs'
#SBATCH --ntasks=6
#SBATCH --mem=32G
#SBATCH --time=1:00:00
#SBATCH -p batch
#SBATCH --array=1-36

DIR=/rhome/jmarz001/bigdata/convergent_evolution/data
RES=/rhome/jmarz001/bigdata/convergent_evolution/args
cd $DIR
SEQLIST=/rhome/jmarz001/bigdata/convergent_evolution/args/fastq_trim_seqs

# get filenames from list
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1)

COUNT=$(grep -c "^@" $FILE)
printf "$FILE \t $COUNT \n" >> $RES/file_reads