#!/bin/bash -l

#SBATCH --ntasks=10
#SBATCH --mem-per-cpu=10G
#SBATCH --time=48:00:00
#SBATCH --output=gatk_snps_short.stdout
#SBATCH --job-name="gatk_snp_short"
#SBATCH --partition=batch
#SBATCH --array=1-12

module load java gatk/4.0.12.0 samtools picard
PICARD=/opt/linux/centos/7.x/x86_64/pkgs/picard/2.18.3/lib/picard.jar
GATK=/opt/linux/centos/7.x/x86_64/pkgs/gatk/4.0.12.0/build/libs/gatk-package-4.0.12.0-20-gf9a2e5c-SNAPSHOT-local.jar
REF=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa
CHR=/rhome/jmarz001/bigdata/convergent_evolution/small_sample/args/chr_intervals.list
#
BAM=/rhome/jmarz001/bigdata/convergent_evolution/small_sample/data/bam
SNP=/rhome/jmarz001/bigdata/convergent_evolution/small_sample/data/calls

# create two argument files with 2 or four columns depending on how many files to merge and commit the merge twice but no more than that
SEQLIST2=/rhome/jmarz001/bigdata/convergent_evolution/args/bams2
SEQLIST4=/rhome/jmarz001/bigdata/convergent_evolution/args/bams4


NAME=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1 | cut -d_ -f1)
FILE1=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1 | cut -f1)
FILE2=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1 | cut -f2)
FILE3=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1 | cut -f3)
FILE4=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1 | cut -f4)



# is it going to wreck because not every line has 4 columns?
java -jar $PICARD MergeSamFiles \
      I=$BAM/"$FILE1" \
      I=$BAM/"$FILE2" \
      I=$BAM/"$FILE3" \
      I=$BAM/"$FILE4" \
      O=$BAM/"$NAME"_pooled_merged.bam




samtools sort -@ 20 $BAM/"$NAME"_pooled_merged.bam -o $BAM/"$NAME"_pooled_merged_sort.bam

java -jar $PICARD MarkDuplicates \
  I=$BAM/"$NAME"_pooled_merged_sort.bam \
  O=$BAM/"$NAME"_pool_merge_dup_marked.bam \
  M=$BAM/"$NAME"_dup_metrics.txt

samtools index $BAM/"$NAME"_pool_merge_dup_marked.bam
for region in $CHR
do
gatk HaplotypeCaller -R $REF -L ${region} --input-prior 0 -I $BAM/"$NAME"_pool_merge_dup_marked.bam -O $SNP/${NAME}.vcf
done