#!/usr/bin/bash -l
#SBATCH -p highmem
#SBATCH --ntasks=2
#SBATCH --mem=200G
#SBATCH --time=60:00:00
#SBATCH --output=gvcf_to_vcf.stdout
#SBATCH --job-name='to_vcf'
#SBATCH --array=1-12

# genotpye gVCF files > snp calls vcf file
GATK=/opt/linux/centos/7.x/x86_64/pkgs/gatk/4.0.12.0/build/libs/gatk-package-4.0.12.0-20-gf9a2e5c-SNAPSHOT-local.jar
REF=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa
CHR=/rhome/jmarz001/bigdata/convergent_evolution/small_sample/args/chr_intervals.list
#
SEQLIST=/rhome/jmarz001/bigdata/convergent_evolution/args/gvcf
SNP=/rhome/jmarz001/bigdata/convergent_evolution/data/calls
cd $SNP
#
ls *.g.vcf > $SEQLIST
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1 | cut -d. -f1)

for region in $CHR
do
java -jar $GATK \
   -T GenotypeGVCFs \
   --max-alternate-alleles 2 \
   -newQual \
   -L $region
   -R $REF \
   -V $FILE.g.vcf \
   -o "$FILE"_"$region"_raw_calls.vcf
done
