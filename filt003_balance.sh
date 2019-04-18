#!/usr/bin/bash -l
#SBATCH -p short
#SBATCH --ntasks=1
#SBATCH --mem=60G
#SBATCH --time=2:00:00
#SBATCH --output=filt003_balance.stdout
#SBATCH --job-name='filt003'

module load bcftools/1.8
FILT=/rhome/jmarz001/bigdata/convergent_evolution/data/vcf/filter
cd $FILT

# pull out info tags for each site to see what I can filter based on and set informed threshholds
#bcftools query -f '%CHROM %POS %AF\n' conevo.combo.vcf > allele_freq
#bcftools query -f '%CHROM %POS %AB\n' conevo.combo.vcf > allele_balance
#    the allele_balance file has no lines == there's no "AB" INFO tag
bcftools query -f '%CHROM %POS %SOR\n' conevo.combo.vcf > symmetric_odds_ratio_strand_bias
bcftools query -f '%CHROM %POS %FS\n' conevo.combo.vcf > fishers_strand_bias
#bcftools query -f '%CHROM %POS %MQRankSum\n' conevo.combo.vcf > alt_ref_map_quals
#bcftools query -f '%CHROM %POS %MQ\n' conevo.combo.vcf > map_qual

# do not filter for allele balance

# strand bias
bcftools view -e "SAF / SAR > 100 & SRF / SRR > 100 | SAR / SAF > 100 & SRR / SRF > 100"  -o
##INFO=<ID=SOR,Number=1,Type=Float,Description="Symmetric Odds Ratio of 2x2 contingency table to detect strand bias">
##INFO=<ID=FS,Number=1,Type=Float,Description="Phred-scaled p-value using Fisher's exact test to detect strand bias">

# ratio of mapping qualities between reference and alternate alleles
# "The rationale here is that, again, because RADseq loci and alleles all should start from the same genomic location there should not be large discrepancy between the mapping qualities of two alleles."
# filtering on this may not make sense for whole genome sequences
# and when I checked for outliers in the MQRankSum values there weren't any!
##INFO=<ID=MQRankSum,Number=1,Type=Float,Description="Z-score From Wilcoxon rank sum test of Alt vs. Ref read mapping qualities">

# get the stats for every sample (in sample file) in the vcf file
REF=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa
bcftools stats --fasta-ref $REF --samples-file post_filter_indv_list CCXXIRAD.ref_alt_ratio.vcf > final_stats
