#!/bin/bash -l
#SBATCH --ntasks=12
#SBATCH --mem-per-cpu=10G
#SBATCH --time=10-00:00:00
#SBATCH --output=gatk_snps.stdout
#SBATCH --job-name="gatk_snp"
#SBATCH --partition=koeniglab
#SBATCH --array=1-27%3

module load java gatk/4.0.12.0 samtools
GATK=/opt/linux/centos/7.x/x86_64/pkgs/gatk/4.0.12.0/build/libs/gatk-package-4.0.12.0-20-gf9a2e5c-SNAPSHOT-local.jar
REF=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa
CHR=/rhome/jmarz001/bigdata/convergent_evolution/small_sample/args/chr_intervals.list
#
BAM=/rhome/jmarz001/bigdata/convergent_evolution/data/bam
SNP=/rhome/jmarz001/bigdata/convergent_evolution/data/calls
#

BAMFILE=$BAM/files
ls $BAM/*_dup_marked.bam > $BAMFILE
FILE=$(head -n $SLURM_ARRAY_TASK_ID $BAMFILE | tail -n 1 | cut -d/ -f8 | cut -d. -f1)

samtools index $BAM/$FILE.bam
for region in $CHR
do
gatk HaplotypeCaller -R $REF -L ${region} -I $BAM/${FILE}.bam -O $SNP/${FILE}.vcf
done