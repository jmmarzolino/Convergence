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

# strand bias
bcftools query -f '%CHROM %POS %SOR\n' conevo.combo.vcf > symmetric_odds_ratio_strand_bias
bcftools query -f '%CHROM %POS %FS\n' conevo.combo.vcf > fishers_strand_bias
# keep sites with less than a 23 for Fisher test and less than 3.4 for symmetric odds ratio stats
bcftools view -i "FS<23 && SOR<3.4" conevo.combo.vcf -o conevo.strand_bias_filt.vcf
##INFO=<ID=SOR,Number=1,Type=Float,Description="Symmetric Odds Ratio of 2x2 contingency table to detect strand bias">
##INFO=<ID=FS,Number=1,Type=Float,Description="Phred-scaled p-value using Fisher's exact test to detect strand bias">

# get the stats for every sample (in sample file) in the vcf file
REF=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa
POP=/rhome/jmarz001/bigdata/convergent_evolution/args/populations
bcftools stats --fasta-ref $REF --samples-file $POP conevo.strand_bias_filt.vcf > conevo_final_stats

########################################################################################
# pull out info tags for each site to see what I can filter based on and set informed threshholds
#bcftools query -f '%CHROM %POS %AF\n' conevo.combo.vcf > allele_freq
#bcftools query -f '%CHROM %POS %AB\n' conevo.combo.vcf > allele_balance
#    the allele_balance file has no lines == there's no "AB" INFO tag
# do not filter for allele balance on this type of data anyways

# ratio of mapping qualities between reference and alternate alleles
# "The rationale here is that, again, because RADseq loci and alleles all should start from the same genomic location there should not be large discrepancy between the mapping qualities of two alleles."
# filtering on this may not make sense for whole genome sequences
#bcftools query -f '%CHROM %POS %MQRankSum\n' conevo.combo.vcf > alt_ref_map_quals
#bcftools query -f '%CHROM %POS %MQ\n' conevo.combo.vcf > map_qual
# and when I checked for outliers in the MQRankSum values there weren't any!
##INFO=<ID=MQRankSum,Number=1,Type=Float,Description="Z-score From Wilcoxon rank sum test of Alt vs. Ref read mapping qualities">
