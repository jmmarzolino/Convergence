#!/bin/bash -l

#SBATCH --ntasks=10
#SBATCH --mem-per-cpu=10G
#SBATCH --time=48:00:00
#SBATCH --output=gatk_snps2.stdout
#SBATCH --job-name="gatk_snp2"
#SBATCH --partition=batch
#SBATCH --array=1-9

module load java picard
PICARD=/opt/linux/centos/7.x/x86_64/pkgs/picard/2.18.3/lib/picard.jar
BAM=/rhome/jmarz001/bigdata/convergent_evolution/data/bam
SEQLIST=/rhome/jmarz001/bigdata/convergent_evolution/args/bams2

NAME=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1 | cut -d_ -f1)
FILE1=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1 | cut -f1)
FILE2=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1 | cut -f2)

java -jar $PICARD MergeSamFiles \
      I=$BAM/"$FILE1" \
      I=$BAM/"$FILE2" \
      O=$BAM/"$NAME"_pooled_merged.bam
