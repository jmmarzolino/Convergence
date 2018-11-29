#!/bin/bash -l

#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/seqs.stdout
#SBATCH --job-name='seqs'
#SBATCH --ntasks=1
#SBATCH --mem=10G
#SBATCH --time=1:00:00
#SBATCH -p short

DIR=/rhome/jmarz001/bigdata/convergent_evolution/data
RES=/rhome/jmarz001/bigdata/convergent_evolution/args
cd $DIR
printf "RAW FASTQ's \n" >> $RES/file_reads


for file in $DIR/*.fastq
do
  printf "$file \t" >> $RES/file_reads
  grep -c "^@" $file | wc -l >> $RES/file_reads
  printf "\n" >> $RES/file_reads
done


DIR=/rhome/jmarz001/bigdata/convergent_evolution/data/trim_files
cd $DIR
printf "\n Trimmed Files \n"

for file in $DIR/*.fastq
do
  printf "$file \t" >> $RES/file_reads
  grep -c "^@" $file | wc -l >> $RES/file_reads
  printf "\n" >> $RES/file_reads
done