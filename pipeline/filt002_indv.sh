#!/usr/bin/bash -l

#SBATCH -p batch
#SBATCH --ntasks=4
#SBATCH --mem=60G
#SBATCH --time=168:00:00
#SBATCH --output=filt002_indv.stdout
#SBATCH --job-name='indv_geno'

module load bcftools/1.8

# combine vcfs
# gather file names into --file-list FILE
FILT=/rhome/jmarz001/bigdata/convergent_evolution/data/vcf/filter
LIST=/rhome/jmarz001/bigdata/convergent_evolution/data/vcf/filter/file_list
ls $FILT/*minalt.vcf > $LIST
FILE=/rhome/jmarz001/bigdata/convergent_evolution/data/vcf/filter/conevo.combo.vcf
#bcftools concat [options] <file1> <file2> [...]
bcftools concat --file-list $LIST -o $FILE

#Extracting per-sample tags
#FORMAT tags can be extracted using the square brackets [] operator, which loops over all samples. For example, to print the GT field followed by PL field we can write:
bcftools query -f '%CHROM %POS[\t%GT]\n' $FILE -o $FILT/combo.genotype.vcf
# get the stats for every sample (in sample file) in the vcf file
SAMP=/rhome/jmarz001/bigdata/convergent_evolution/args/populations
REF=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa
bcftools stats --fasta-ref $REF --samples-file $SAMP $FILE > $FILT/indv_stats
# subset every sample's counts and no header info
grep "PSC" $FILT/indv_stats | grep -v "," > $FILT/per_sample_calls



# remove individuals...
bgzip --threads 3 $FILE
bcftools index --threads 3 --csi $FILE.gz
# sample file must contain samples to subset by (ie. those included and not excluded)?
bcftools view --threads 3 --samples-file $SAMP --force-samples -o $WORK/CCXXIRAD.inv_filt.vcf $FILE.gz
# filter by individual
bcftools view -i 'COUNT(GT="het")<124 && COUNT(GT="alt")>0 && COUNT(GT="ref")>0' $FILE -o $NAME.gtcounts.vcf
