#!/usr/bin/bash -l
#SBATCH -p short
#SBATCH --ntasks=1
#SBATCH --mem=30G
#SBATCH --time=2:00:00
#SBATCH --output=res001_MAF.stdout
#SBATCH --job-name='res001'
#SBATCH --array=1-16

POPS=/rhome/jmarz001/bigdata/convergent_evolution/args/populations
NAME=$(head -n $SLURM_ARRAY_TASK_ID $POPS | tail -n 1)
SHORT=$(basename $NAME | cut -d_ -f1)

module load bcftools/1.8
FILT=/rhome/jmarz001/bigdata/convergent_evolution/data/vcf/filter
RESULT=/rhome/jmarz001/bigdata/convergent_evolution/results

for file in $RESULT/
do
  bcftools query --regions-file $REGION -f '%CHROM %POS[\t%AD\t%DP]\n' $FILT/conevo.strand_bias_filt.vcf -o $RESULT/conevo_AF
done

############################################################
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
############################################################

#!/usr/bin/bash -l
#SBATCH -p batch
#SBATCH --ntasks=5
#SBATCH --mem-per-cpu=30G
#SBATCH --time=02:00:00
#SBATCH --output=res001A_MAF.stdout
#SBATCH --job-name='res001'
#SBATCH --array=1-12

RESULT=/rhome/jmarz001/bigdata/convergent_evolution/results
cd $RESULT
FILE=$(head -n $SLURM_ARRAY_TASK_ID files | tail -n 1)
NAME=$(basename $FILE | cut -d_ -f1)

cut $FILE -d, -f1 > ${NAME}_test2
cut $FILE -f3 > ${NAME}_test3
paste ${NAME}_test2 ${NAME}_test3 > ${NAME}_AF2
