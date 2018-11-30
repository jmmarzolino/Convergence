#!/bin/bash -l

#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/trim_seqs.stdout
#SBATCH --job-name='seqs'
#SBATCH --ntasks=1
#SBATCH --mem=32G
#SBATCH --time=1:00:00
#SBATCH -p batch


DIR=/rhome/jmarz001/bigdata/convergent_evolution/data/trim_files
RES=/rhome/jmarz001/bigdata/convergent_evolution/args
cd $DIR
printf "\n Trimmed Files \n" >> $RES/trimmed_file_reads

for file in $DIR/*.fq
do
  count=$(grep -c "^@" $file)
  printf "$file \t $count \n" >> $RES/trimmed_file_reads
done