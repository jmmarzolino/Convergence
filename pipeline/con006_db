#!/usr/bin/bash -l
#SBATCH -p highmem
#SBATCH --ntasks=2
#SBATCH --mem=400G
#SBATCH --time=14-00:00:00
#SBATCH --output=con006_db.stdout
#SBATCH --job-name='to_vcf'
#SBATCH --array=1-16

# combine the population-per-chromosome gvcf files into an all-samples per-chromosome database for conversion into vcf files
module load gatk/4.0.12.0
CALLS=/rhome/jmarz001/bigdata/convergent_evolution/data/calls
cd $CALLS
CHR=/rhome/jmarz001/bigdata/convergent_evolution/small_sample/args/chr_intervals.list
# GenomicsDBImport takes in one or more single-sample GVCFs and imports data over at least one genomics interval, and outputs a directory containing a GenomicsDB datastore with combined multi-sample data.
# GenotypeGVCFs can then read from the created GenomicsDB directly and output the final multi-sample VCF.
region=$(head -n $SLURM_ARRAY_TASK_ID $CHR | tail -n 1)

gatk GenomicsDBImport \
  -V 10_${region}.g.vcf \
  -V 16_${region}.g.vcf \
  -V 1L_${region}.g.vcf \
  -V 24_${region}.g.vcf \
  -V 250_${region}.g.vcf \
  -V 255_${region}.g.vcf \
  -V 257_${region}.g.vcf \
  -V 258_${region}.g.vcf \
  -V 262_${region}.g.vcf \
  -V 267_${region}.g.vcf \
  -V 2L_${region}.g.vcf \
  -V 7L_${region}.g.vcf \
  --genomicsdb-workspace-path $CALLS/all_pops/${region} \
  --intervals ${region}
