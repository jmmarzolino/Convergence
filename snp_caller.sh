#!/bin/bash -l

#SBATCH --ntasks=20
#SBATCH --time=168:00:00
#SBATCH --mem=200G
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/split_snps.stdout
#SBATCH --job-name='split_chrs'
#SBATCH -p koeniglab
#SBATCH --array=1-16

WORK=/rhome/jmarz001/bigdata/CCXXIRAD/align
cd $WORK
RESULT=/rhome/jmarz001/bigdata/CCXXIRAD/calls
REF=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa

CHR=/rhome/jmarz001/bigdata/CCXXIRAD/calls/chr_splits.txt
REGION=$(head -n $SLURM_ARRAY_TASK_ID $CHR | tail -n 1)

module load freebayes/1.2.0

#freebayes -f [reference] [infiles.bam] > [outfiles.vcf]
freebayes -k -f $REF -r $REGION $WORK/*.bam > $RESULT/rad.$REGION.freebayes.snps.vcf
