#!/bin/bash -l

#SBATCH --ntasks=20
#SBATCH --time=168:00:00
#SBATCH --mem=200G
#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/snp_call.stdout
#SBATCH --job-name='snps'
#SBATCH -p koeniglab

WORK=/rhome/jmarz001/bigdata/convergent_evolution/data/align
cd $WORK
RESULT=/rhome/jmarz001/bigdata/convergent_evolution/data/calls
mkdir $RESULT
REF=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa

CHR=/rhome/jmarz001/bigdata/CCXXIRAD/calls/chr_splits.txt
REGION=$(head -n $SLURM_ARRAY_TASK_ID $CHR | tail -n 1)

module load freebayes/1.2.0

#freebayes -f [reference] [infiles.bam] > [outfiles.vcf]
freebayes -k -f $REF -r $REGION $WORK/*.bam > $RESULT/rad.$REGION.freebayes.snps.vcf

#population priors:
#-k --no-population-priors Equivalent to --pooled-discrete and removal of Ewens Sampling Formula priors

#-r --region <chrom>:<start_position>..<end_position>
#Limit analysis to the specified region, 0-base coordinates, end_position not included (same as BED format).
