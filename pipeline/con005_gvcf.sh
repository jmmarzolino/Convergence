#!/bin/bash -l

#SBATCH --ntasks=4
#SBATCH --mem-per-cpu=30G
#SBATCH --time=7-00:00:00
#SBATCH --output=con005.stdout
#SBATCH --job-name="gatk_snp"
#SBATCH --partition=intel
#SBATCH --array=10-12

module load java gatk/4.0.12.0 samtools picard
REF=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa
CHR=/rhome/jmarz001/bigdata/convergent_evolution/small_sample/args/chr_intervals.list
#
SEQLIST=/rhome/jmarz001/bigdata/convergent_evolution/args/bams
BAM=/rhome/jmarz001/bigdata/convergent_evolution/data/bam
SNP=/rhome/jmarz001/bigdata/convergent_evolution/data/calls
#
cd $BAM
ls *_pooled_merged.bam > $SEQLIST
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1 | cut -d_ -f1)

for region in $CHR
do
gatk HaplotypeCaller -R $REF -L ${region} -I $BAM/${FILE}_pool_merge_dup_marked.bam -O $SNP/${FILE}_${region}.g.vcf -ERC GVCF
done
