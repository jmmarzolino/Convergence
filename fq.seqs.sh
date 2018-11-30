#!/bin/bash -l

#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/fq_seqs.stdout
#SBATCH --job-name='seqs'
#SBATCH --ntasks=1
#SBATCH --mem=32G
#SBATCH --time=1:00:00
#SBATCH -p batch

DIR=/rhome/jmarz001/bigdata/convergent_evolution/data
RES=/rhome/jmarz001/bigdata/convergent_evolution/args
cd $DIR
printf "RAW FASTQ's \n" >> $RES/file_reads


for file in $DIR/*.fastq
do
  count=$(grep -c "^@" $file)
  printf "$file \t $count \n" >> $RES/file_reads
done