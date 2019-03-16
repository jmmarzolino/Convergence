#!/bin/bash -l
#SBATCH --ntasks=10
#SBATCH --mem=60G
#SBATCH --time=1:00:00
#SBATCH --output=gvcf_short.stdout
#SBATCH --job-name="gvcf"
#SBATCH --partition=short
#SBATCH --array=1-12

module load java gatk/4.0.12.0 samtools picard
REF=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa
CHR=/rhome/jmarz001/bigdata/convergent_evolution/small_sample/args/chr_intervals.list
#
BAM=/rhome/jmarz001/bigdata/convergent_evolution/small_sample/data/bam
SNP=/rhome/jmarz001/bigdata/convergent_evolution/small_sample/data/calls
cd $BAM
SEQLIST=/rhome/jmarz001/bigdata/convergent_evolution/small_sample/args/gvcfs
ls *_dup_marked_001.bam > $SEQLIST
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1)

for region in $CHR
do
gatk HaplotypeCaller -R $REF -L ${region} -I $FILE -O $SNP/$NAME.g.vcf -ERC GVCF
done
