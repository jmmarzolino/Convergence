#!/usr/bin/bash -l

#SBATCH -p koeniglab
#SBATCH --ntasks=4
#SBATCH --mem=60G
#SBATCH --time=168:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/indv_concat.stdout
#SBATCH --job-name='indv_geno'

module load bcftools/1.8


# filter by individual
bcftools view -i 'COUNT(GT="het")<124 && COUNT(GT="alt")>0 && COUNT(GT="ref")>0' $FILE -o $NAME.gtcounts.vcf

#Extracting per-sample tags
#FORMAT tags can be extracted using the square brackets [] operator, which loops over all samples. For example, to print the GT field followed by PL field we can write:
bcftools query -f '%CHROM %POS[\t%GT]\n' $FILE -o genotype.vcf

#bcftools concat [options] <file1> <file2> [...]
bcftools concat --file-list $FILE -o CCXXIRAD.genomesnps.vcf


# get the stats for every sample (in sample file) in the vcf file
bcftools stats --fasta-ref $REF --samples-file $SAMP $FILE
# subset every sample's counts and no header info
grep "PSC" bcf_indv_filter.stdout | grep -v "," > /rhome/jmarz001/bigdata/CCXXIRAD/calls/bcftools_filtered/sample_calls


bgzip --threads 3 $FILE
bcftools index --threads 3 --csi $FILE.gz

# sample file must contain samples to subset by (ie. those included and not excluded)?
bcftools view --threads 3 --samples-file $SAMP --force-samples -o $WORK/CCXXIRAD.inv_filt.vcf $FILE.gz
