#!/usr/bin/bash -l
#SBATCH -p batch
#SBATCH --ntasks=1
#SBATCH --mem=60G
#SBATCH --time=72:00:00
#SBATCH --output=filt003_balance.stdout
#SBATCH --job-name='filt003'

module load bcftools/1.8
FILT=/rhome/jmarz001/bigdata/convergent_evolution/data/vcf/filter
cd $FILT

# allele balance
bcftools view -i "INFO/AB > 0.25 && INFO/AB < 0.75 | INFO/AB < 0.01" conevo.combo.vcf -o conevo.allele_balance.vcf
grep -c "^chr" conevo.allele_balance.vcf > allele_balance_sites

bcftools view -e "SAF / SAR > 100 & SRF / SRR > 100 | SAR / SAF > 100 & SRR / SRF > 100" conevo.allele_balance.vcf -o
##INFO=<ID=ReadPosRankSum,Number=1,Type=Float,Description="Z-score from Wilcoxon rank sum test of Alt vs. Ref read position bias">
##INFO=<ID=SOR,Number=1,Type=Float,Description="Symmetric Odds Ratio of 2x2 contingency table to detect strand bias">
##INFO=<ID=FS,Number=1,Type=Float,Description="Phred-scaled p-value using Fisher's exact test to detect strand bias">

# ratio of mapping qualities between reference and alternate alleles
# "The rationale here is that, again, because RADseq loci and alleles all should start from the same genomic location there should not be large discrepancy between the mapping qualities of two alleles."
##INFO=<ID=MQRankSum,Number=1,Type=Float,Description="Z-score From Wilcoxon rank sum test of Alt vs. Ref read mapping qualities">
bcftools view -e "MQM / MQMR > 0.9 & MQM / MQMR < 1.05" CCXXIRAD.allele_balance.vcf -o CCXXIRAD.ref_alt_ratio.vcf
grep -c "^chr" CCXXIRAD.ref_alt_ratio.vcf > ref_alt_ratio_sites

REF=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa
# first get a list of all samples still contained in the vcf for passing into next line
# -l argument: list sample names and exit
bcftools query -l CCXXIRAD.ref_alt_ratio.vcf > post_filter_indv_list
# get the stats for every sample (in sample file) in the vcf file
bcftools stats --fasta-ref $REF --samples-file post_filter_indv_list CCXXIRAD.ref_alt_ratio.vcf > final_stats

$FILT/combo.genotype.vcf
