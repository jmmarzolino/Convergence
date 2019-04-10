#!/usr/bin/bash -l
#SBATCH -p highmem
#SBATCH --ntasks=2
#SBATCH --mem=200G
#SBATCH --time=14-0:00:00
#SBATCH --output=con007_vcf_call.stdout
#SBATCH --job-name='to_vcf'
#SBATCH --array=1-16

# genotpye gVCF files > snp calls vcf file
GATK=/opt/linux/centos/7.x/x86_64/pkgs/gatk/4.0.12.0/build/libs/gatk-package-4.0.12.0-20-gf9a2e5c-SNAPSHOT-local.jar
REF=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa
CHR=/rhome/jmarz001/bigdata/convergent_evolution/small_sample/args/chr_intervals.list
#
CALLS=/rhome/jmarz001/bigdata/convergent_evolution/data/calls/all_pops
region=$(head -n $SLURM_ARRAY_TASK_ID $CHR | tail -n 1)

java -jar $GATK \
   -T GenotypeGVCFs \
   --max-alternate-alleles 2 \
   -newQual \
   -L $region \
   -R $REF \
   -V gendb://$CALLS/${region}/genomicsdb_array \
   -o ${region}_raw_calls.vcf

# if -newQual doesn't work try --new-qual