#!/usr/bin/bash -l
#SBATCH -p short
#SBATCH --ntasks=1
#SBATCH --mem=30G
#SBATCH --time=2:00:00
#SBATCH --output=res001_MAF.stdout
#SBATCH --job-name='res001'

module load bcftools/1.8
FILT=/rhome/jmarz001/bigdata/convergent_evolution/data/vcf/filter
RESULT=/rhome/jmarz001/bigdata/convergent_evolution/results
bcftools query -f '%CHROM %POS[\t%AD\t%DP]\n' $FILT/conevo.strand_bias_filt.vcf -o $RESULT/conevo_AF
