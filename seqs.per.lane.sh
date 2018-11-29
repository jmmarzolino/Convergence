#!/bin/bash -l

#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/seqs.stdout
#SBATCH --job-name='seqs'
#SBATCH --ntasks=1
#SBATCH --mem=10G
#SBATCH --time=1:00:00
#SBATCH -p short

DIR=/rhome/jmarz001/bigdata/convergent_evolution/data
cd $DIR

for file in $DIR/*
do
  
done

printf "HvRADA2 \n" > $DIR/flowcell_reads
grep "^@" HvRADA2_S8_L008_R1_001.fastq | wc -l >> $DIR/flowcell_reads

printf "HvRADP3 \n" >> $DIR/flowcell_reads
grep "^@" HvRADP3_S5_L005_R1_001.fastq | wc -l >> $DIR/flowcell_reads

printf "HvRADO2 \n" >> $DIR/flowcell_reads
grep "^@" HvRADO2_S7_L007_R1_001.fastq | wc -l >> $DIR/flowcell_reads

printf "HvRADY3 \n" >> $DIR/flowcell_reads
grep "^@" HvRADY3_S6_L006_R1_001.fastq | wc -l >> $DIR/flowcell_reads


#next time remember that you can just grep -c to count instead of finding seqs and piping it to word count -l