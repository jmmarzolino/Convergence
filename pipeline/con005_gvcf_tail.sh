#!/bin/bash -l

#SBATCH --ntasks=1
#SBATCH --mem=100G
#SBATCH --time=14-00:00:00
#SBATCH --output=gatk_split_10.stdout
#SBATCH --job-name="gatk_snp"
#SBATCH --partition=koeniglab
#SBATCH --array=11-16

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
region=$(head -n $SLURM_ARRAY_TASK_ID $CHR | tail -n 1)

gatk HaplotypeCaller -R $REF -L ${region} -I $BAM/10_pool_merge_dup_marked.bam -O $SNP/10_${region}.g.vcf -ERC GVCF


10_pool_merge_dup_marked.bam
  -chr11
#########################################################################################################

#!/bin/bash -l

#SBATCH --ntasks=4
#SBATCH --mem-per-cpu=40G
#SBATCH --time=7-00:00:00
#SBATCH --output=gatk_split_16.stdout
#SBATCH --job-name="gatk_snp16"
#SBATCH --partition=highmem
#SBATCH --array=10-16

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
region=$(head -n $SLURM_ARRAY_TASK_ID $CHR | tail -n 1)

gatk HaplotypeCaller -R $REF -L ${region} -I $BAM/16_pool_merge_dup_marked.bam -O $SNP/16_${region}.g.vcf -ERC GVCF

16_pool_merge_dup_marked.bam
  -chr 10
#########################################################################################################

#!/bin/bash -l

#SBATCH --ntasks=4
#SBATCH --mem-per-cpu=30G
#SBATCH --time=7-00:00:00
#SBATCH --output=gatk_split_1L.stdout
#SBATCH --job-name="gatk_snp"
#SBATCH --partition=batch
#SBATCH --array=12-16

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
region=$(head -n $SLURM_ARRAY_TASK_ID $CHR | tail -n 1)

gatk HaplotypeCaller -R $REF -L ${region} -I $BAM/1L_pool_merge_dup_marked.bam -O $SNP/1L_${region}.g.vcf -ERC GVCF

1L_pool_merge_dup_marked.bam
  -chr12
#########################################################################################################

#!/bin/bash -l

#SBATCH --ntasks=1
#SBATCH --mem=100G
#SBATCH --time=11-00:00:00
#SBATCH --output=gatk_split_24.stdout
#SBATCH --job-name="gatk_snp"
#SBATCH --partition=batch
#SBATCH --array=11-16

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
region=$(head -n $SLURM_ARRAY_TASK_ID $CHR | tail -n 1)

gatk HaplotypeCaller -R $REF -L ${region} -I $BAM/24_pool_merge_dup_marked.bam -O $SNP/24_${region}.g.vcf -ERC GVCF

24_pool_merge_dup_marked.bam
  -chr11
#########################################################################################################

#!/bin/bash -l

#SBATCH --ntasks=1
#SBATCH --mem=55G
#SBATCH --time=14-00:00:00
#SBATCH --output=gatk_split_250.stdout
#SBATCH --job-name="gatk_snp"
#SBATCH --partition=batch
#SBATCH --array=13-16

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
region=$(head -n $SLURM_ARRAY_TASK_ID $CHR | tail -n 1)

gatk HaplotypeCaller -R $REF -L ${region} -I $BAM/250_pool_merge_dup_marked.bam -O $SNP/250_${region}.g.vcf -ERC GVCF

250_pool_merge_dup_marked.bam
  -chr13
#########################################################################################################

#!/bin/bash -l

#SBATCH --ntasks=1
#SBATCH --mem=50G
#SBATCH --time=14-00:00:00
#SBATCH --output=gatk_split_255.stdout
#SBATCH --job-name="gatk_snp"
#SBATCH --partition=intel
#SBATCH --array=10-16

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
region=$(head -n $SLURM_ARRAY_TASK_ID $CHR | tail -n 1)

gatk HaplotypeCaller -R $REF -L ${region} -I $BAM/255_pool_merge_dup_marked.bam -O $SNP/255_${region}.g.vcf -ERC GVCF

255_pool_merge_dup_marked.bam
  -chr10
#########################################################################################################

#!/bin/bash -l

#SBATCH --ntasks=4
#SBATCH --mem-per-cpu=50G
#SBATCH --time=7-00:00:00
#SBATCH --output=gatk_split_257.stdout
#SBATCH --job-name="gatk_snp"
#SBATCH --partition=batch
#SBATCH --array=10-16

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
region=$(head -n $SLURM_ARRAY_TASK_ID $CHR | tail -n 1)

gatk HaplotypeCaller -R $REF -L ${region} -I $BAM/257_pool_merge_dup_marked.bam -O $SNP/257_${region}.g.vcf -ERC GVCF

257_pool_merge_dup_marked.bam
  -chr10
#########################################################################################################

#!/bin/bash -l

#SBATCH --ntasks=4
#SBATCH --mem-per-cpu=55G
#SBATCH --time=7-00:00:00
#SBATCH --output=gatk_split_258.stdout
#SBATCH --job-name="gatk_snp"
#SBATCH --partition=koeniglab
#SBATCH --array=6-16

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
region=$(head -n $SLURM_ARRAY_TASK_ID $CHR | tail -n 1)

gatk HaplotypeCaller -R $REF -L ${region} -I $BAM/258_pool_merge_dup_marked.bam -O $SNP/258_${region}.g.vcf -ERC GVCF

258_pool_merge_dup_marked.bam
  -chr6

  #########################################################################################################

#!/bin/bash -l

#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=60G
#SBATCH --time=7-00:00:00
#SBATCH --output=gatk_split_262.stdout
#SBATCH --job-name="gatk_snp"
#SBATCH --partition=koeniglab
#SBATCH --array=10-16

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
region=$(head -n $SLURM_ARRAY_TASK_ID $CHR | tail -n 1)
gatk HaplotypeCaller -R $REF -L ${region} -I $BAM/262_pool_merge_dup_marked.bam -O $SNP/262_${region}.g.vcf -ERC GVCF


262_pool_merge_dup_marked.bam
    -chr10
  #########################################################################################################

#!/bin/bash -l

#SBATCH --ntasks=4
#SBATCH --mem=200G
#SBATCH --time=7-00:00:00
#SBATCH --output=gatk_split_2L.stdout
#SBATCH --job-name="gatk_snp"
#SBATCH --partition=intel
#SBATCH --array=13-16

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
region=$(head -n $SLURM_ARRAY_TASK_ID $CHR | tail -n 1)

gatk HaplotypeCaller -R $REF -L ${region} -I $BAM/2L_pool_merge_dup_marked.bam -O $SNP/2L_${region}.g.vcf -ERC GVCF

2L_pool_merge_dup_marked.bam
  -chr13
