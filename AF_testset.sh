#!/bin/bash -l
#SBATCH -p koeniglab
#SBATCH --ntasks=1
#SBATCH --mem=20G
#SBATCH --time=01:00:00
#SBATCH --job-name='AF'
#SBATCH --output=AF.stdout

cd /rhome/jmarz001/bigdata/convergent_evolution/results/
module load bcftools
bcftools query -f '%CHROM %POS [\t%AD]\n' /rhome/jmarz001/bigdata/convergent_evolution/data/vcf/filter/conevo.strand_bias_filt.vcf -o AD

# take the site, 257, and 258 [CCV F6 D & B] AD &columns
cut AD -f1,2 > AD10
cut AD -f1,3 > AD16

cut AD -f1,4 > AD1
cut AD -f1,5 > AD24

cut AD -f1,6 > AD250
cut AD -f1,7 > AD255

cut AD -f1,8 > AD257
cut AD -f1,9 > AD258

cut AD -f1,10 > AD262
cut AD -f1,11 > AD267

cut AD -f1,12 > AD2
cut AD -f1,13 > AD7
####

cut -d, -f1 AD10 > 10A
cut -d, -f2 AD10 > 10B
paste 10A 10B > 10

cut -d, -f1 AD16 > 16A
cut -d, -f2 AD16 > 16B
paste 16A 16B > 16

cut -d, -f1 AD1 > 1A
cut -d, -f2 AD1 > 1B
paste 1A 1B > 1

cut -d, -f1 AD24 > 24A
cut -d, -f2 AD24 > 24B
paste 24A 24B > 24

cut -d, -f1 AD250 > 250A
cut -d, -f2 AD250 > 250B
paste 250A 250B > 250

cut -d, -f1 AD255 > 255A
cut -d, -f2 AD255 > 255B
paste 255A 255B > 255

cut -d, -f1 AD257 > 257A
cut -d, -f2 AD257 > 257B
paste 257A 257B > 257

cut -d, -f1 AD258 > 258A
cut -d, -f2 AD258 > 258B
paste 258A 258B > 258

cut -d, -f1 AD262 > 262A
cut -d, -f2 AD262 > 262B
paste 262A 262B > 262

cut -d, -f1 AD267 > 267A
cut -d, -f2 AD267 > 267B
paste 267A 267B > 267

cut -d, -f1 AD2 > 2A
cut -d, -f2 AD2 > 2B
paste 2A 2B > 2

cut -d, -f1 AD7 > 7A
cut -d, -f2 AD7 > 7B
paste 7A 7B > 7

# data has been formatted, now use python to calculate allele frequencies
# calcualte_freq.py script


# then paste together the relevant populations > Variant
paste 257_freq 10_freq 16_freq 258_freq 262_freq > CCV_Frequencies
paste 1_freq 2_freq 7_freq 250_freq 255_freq > CCII_Frequencies
paste 267_freq 24_freq > CCXXI_Frequencies

cut -f1,2,4,6,8,10 CCV_Frequencies > CCV_Frequencies2
cut -f1,2,4,6,8,10 CCII_Frequencies > CCII_Frequencies2
cut -f1,2,4 CCXXI_Frequencies > CCXXI_Frequencies2
