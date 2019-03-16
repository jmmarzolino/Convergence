#!/usr/bin/bash -l
#SBATCH -p short
#SBATCH --ntasks=2
#SBATCH --mem=100G
#SBATCH --time=2:00:00
#SBATCH --output=para_first_filter.stdout
#SBATCH --job-name='para_filter'
#SBATCH --array=1-12

module load bcftools/1.8

SNPS=/rhome/jmarz001/bigdata/convergent_evolution/data/calls
cd $SNPS
FILTER=/rhome/jmarz001/bigdata/convergent_evolution/data/calls/filtered
# define and generate file list
SEQLIST=$SNPS/filter_vcf
ls * > $SEQLIST

FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1)
NAME=$(basename "$FILE" | cut -d_ -f1)

# bcftools stats [options] A.vcf.gz [B.vcf.gz]
bcftools stats $FILE > $FILTER/$NAME.stats

bcftools query -f '%CHROM %POS %AF\n' $FILE -o "$NAME"_AF.vcf

# extract allele frequency at each position

#Extracting per-sample tags
#FORMAT tags can be extracted using the square brackets [] operator, which loops over all samples. For example, to print the GT field followed by PL field we can write:
bcftools query -f '%CHROM %POS[\t%GT]\n' $FILE -o genotype.vcf


# filter by site
# N_ALT=1 makes only options ref/single alt allele (biallelic site instead of 4 alt alleles or something)

#???DP max???
bcftools view -i 'F_MISSING<0.5 & DP>0 & DP< & QUAL>30 & N_ALT=1' $FILE -o $RESULT/$NAME.minalt.vcf

# filter by individual
bcftools view -i 'COUNT(GT="het")<124 && COUNT(GT="alt")>0 && COUNT(GT="ref")>0' $FILE -o $NAME.gtcounts.vcf
