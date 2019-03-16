#!/bin/bash -l

#SBATCH -p koeniglab
#SBATCH --ntasks=10
#SBATCH --mem-per-cpu=20G
#SBATCH --time=10:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/subset_data.out
#SBATCH --job-name='subset'
#SBATCH --array=1-18%2

# set up small_sample environment
cd /rhome/jmarz001/bigdata/convergent_evolution
mkdir small_sample
cd small_sample
mkdir args
mkdir data
mkdir scripts

cd /rhome/jmarz001/bigdata/convergent_evolution

################################################## Relocate and Subset Data ################
# constructed a file with file_R1 \t file_R2 \t barcode
SEQLIST=/rhome/jmarz001/bigdata/convergent_evolution/args/fastq_files

# subset the files, take the first 10,000 lines
# second sequencing run (CCXXI, V, II)
cd /rhome/jmarz001/shared/SEQ_RUNS/10_8_2018/FASTQ
FILER1=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1 | cut -f1 | cut -d/ -f7 | cut -d. -f1)
FILER2=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1 | cut -f2 | cut -d/ -f7 | cut -d. -f1)
zcat "$FILER1".fastq.gz | head -n 10000 >> /rhome/jmarz001/bigdata/convergent_evolution/small_sample/data/"$FILER1".fq
zcat "$FILER2".fastq.gz | head -n 10000 >> /rhome/jmarz001/bigdata/convergent_evolution/small_sample/data/"$FILER2".fq

# first sequencing run (CC II)
#CCIILIST=/rhome/jmarz001/bigdata/convergent_evolution/args/fastq_CCPool_files
#filer1=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1 | cut -f1)
#filer2=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 2 | cut -f2)

#CCIINAMES=/rhome/jmarz001/bigdata/convergent_evolution/args/fastq_CCPool_names
#name1=$(head -n $SLURM_ARRAY_TASK_ID $CCIINAMES | tail -n 1 | cut -f1)
#name2=$(head -n $SLURM_ARRAY_TASK_ID $CCIINAMES | tail -n 2 | cut -f2)

#cp $filer1 | head -n 10000 > /rhome/jmarz001/bigdata/convergent_evolution/small_sample/data/$filer1
#cp $filer2 | head -n 10000 > /rhome/jmarz001/bigdata/convergent_evolution/small_sample/data/$filer2
cp /rhome/jmarz001/shared/SEQ_RUNS/7_24_2018/FASTQ/UnL7/*L_S* /rhome/jmarz001/bigdata/convergent_evolution/small_sample/data/
cp /rhome/jmarz001/shared/SEQ_RUNS/7_24_2018/FASTQ/UnalignedL5_L8/*L_S* /rhome/jmarz001/bigdata/convergent_evolution/small_sample/data/
cp /rhome/jmarz001/shared/SEQ_RUNS/7_24_2018/FASTQ/UnL8/*L_S* /rhome/jmarz001/bigdata/convergent_evolution/small_sample/data/
cp /rhome/jmarz001/shared/SEQ_RUNS/7_24_2018/FASTQ/UnL7_B/*L_S* /rhome/jmarz001/bigdata/convergent_evolution/small_sample/data/
cd /rhome/jmarz001/bigdata/convergent_evolution/small_sample/data/
ls *gz > zip_files
SEQ=zip_files
ZIP=$(head -n $SLURM_ARRAY_TASK_ID $SEQ | tail -n 1)
NAME=$(head -n $SLURM_ARRAY_TASK_ID $SEQ | tail -n 1 | cut -d. -f1)
zcat $ZIP | head -n 10000 > $NAME.fq
rm *.gz
###############################################