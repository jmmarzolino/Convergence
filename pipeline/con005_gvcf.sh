#!/bin/bash -l

#SBATCH --ntasks=10
#SBATCH --mem=200G
#SBATCH --time=24:00:00
#SBATCH --output=gatk_snps.stdout
#SBATCH --job-name="gatk_snp"
#SBATCH --partition=highmem
#SBATCH --array=1-12

module load java gatk/4.0.12.0 samtools picard
PICARD=/opt/linux/centos/7.x/x86_64/pkgs/picard/2.18.3/lib/picard.jar
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
gatk HaplotypeCaller -R $REF -L ${region} -I $BAM/"$FILE"_pool_merge_dup_marked.bam -O $SNP/$FILE.g.vcf -ERC GVCF
done
