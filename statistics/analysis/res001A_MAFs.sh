#!/usr/bin/bash -l
#SBATCH -p short
#SBATCH --ntasks=1
#SBATCH --mem=30G
#SBATCH --time=2:00:00
#SBATCH --output=res001_MAF.stdout
#SBATCH --job-name='res001'

module load bcftools/1.8
FILT=/rhome/jmarz001/bigdata/convergent_evolution/data/vcf/filter
RESULT=/rhome/jmarz001/bigdata/convergent_evolution/results
bcftools query -f '%CHROM %POS[\t%AD\t%DP]\n' $FILT/conevo.strand_bias_filt.vcf -o $RESULT/conevo_AF


cut -f1-3 conevo_AF > 10_AF
cut -f1,4-5 conevo_AF > 16_AF
cut -f1,6-7 conevo_AF > 1L_AF
cut -f1,8-9 conevo_AF > 24_AF
cut -f1,10-11 conevo_AF > 250_AF
cut -f1,12-13 conevo_AF > 255_AF
cut -f1,14-15 conevo_AF > 257_AF
cut -f1,16-17 conevo_AF > 258_AF
cut -f1,18-19 conevo_AF > 262_AF
cut -f1,20-21 conevo_AF > 267_AF
cut -f1,22-23 conevo_AF > 2L_AF
cut -f1,24-25 conevo_AF > 7L_AF

#!/usr/bin/bash -l
#SBATCH -p batch
#SBATCH --ntasks=1
#SBATCH --mem=30G
#SBATCH --time=2-00:00:00
#SBATCH --output=res001A_MAF.stdout
#SBATCH --job-name='res001'
#SBATCH --array=1-12

RESULT=/rhome/jmarz001/bigdata/convergent_evolution/results
POPS=/rhome/jmarz001/bigdata/convergent_evolution/args/populations
NAME=$(head -n $SLURM_ARRAY_TASK_ID $POPS | tail -n 1)
SHORT=$(basename $NAME | cut -d_ -f1)

for line in $RESULT/${SHORT}_AF
do
   A=$(cut $line -f1)
   B=$(cut $line -f2 | cut -d, -f1)
   C=$(cut $line -f3)
   paste $A $B $C > $RESULT/${SHORT}_AF2B
done
