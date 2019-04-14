#!/usr/bin/bash -l
#SBATCH -p short
#SBATCH --ntasks=2
#SBATCH --mem=100G
#SBATCH --time=2:00:00
#SBATCH --output=con008_filtA.stdout
#SBATCH --job-name='con008'
#SBATCH --array=1-16

module load bcftools/1.8
SNPS=/rhome/jmarz001/bigdata/convergent_evolution/data/vcf
FILTER=$SNPS/filter
# define and generate file list
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SNPS/filter_vcf | tail -n 1)
NAME=$(basename "$FILE" | cut -d_ -f1-3)

# get the filter metrics
# bcftools stats [options] A.vcf.gz [B.vcf.gz]
bgzip $SNPS/$FILE
bcftools stats $SNPS/$FILE.gz > $FILTER/$NAME.stats
# extract allele frequency at each position
#bcftools query -f '%CHROM %POS %AF\n' $FILE -o "$NAME"_AF.vcf
#grep "^AF" $FILTER/"$NAME"_AF.vcf >> $FILTER/all_AFs

# filter by site based on stats
bcftools view -i 'F_MISSING<0.5 & DP>0 & DP<445 & QUAL>30 & N_ALT=1' $SNPS/$FILE -o $FILTER/$NAME.minalt.vcf
