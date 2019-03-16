#!/bin/bash -l

#SBATCH --ntasks=4
#SBATCH --mem=200G
#SBATCH --time=160:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/dupfree.stdout
#SBATCH --job-name='dups'
#SBATCH -p batch
#SBATCH --array=1-18

module load java picard
PICARD=/opt/linux/centos/7.x/x86_64/pkgs/picard/2.18.3/lib/picard.jar

WORK=/rhome/jmarz001/bigdata/convergent_evolution/data/align
cd $WORK
SEQ=$WORK/file_list
ls *.bam > $SEQ
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQ | tail -n 1)
NAME=$(basename "$FILE" | cut -d. -f1)
RES=/rhome/jmarz001/bigdata/convergent_evolution/data/dup_free

java -jar $PICARD MarkDuplicates \
  I=$FILE \
  O=$RES/$NAME.bam \
  M=$WORK/$NAME.marked_dup_metrics.txt

#java -jar $PICARD SortSam \
#  I=$NAME.bam \
#  O=$NAME.sorted.bam \
#  SORT_ORDER=coordinate

