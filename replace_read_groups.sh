#!/bin/bash -l

#SBATCH --ntasks=8
#SBATCH --mem=64G
#SBATCH --time=168:00:00
#SBATCH --job-name='rg'
#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/rg.stdout
#SBATCH -p koeniglab
#SBATCH -array=1-18%2

module load picard/2.18.3

# Define location variables
WORK=/rhome/jmarz001/bigdata/convergent_evolution/data/align
cd $WORK
SEQ=/rhome/jmarz001/bigdata/convergent_evolution/args/rerg
ls *_1.bam > $SEQ
RES=/rhome/jmarz001/bigdata/convergent_evolution/data/align_rerg
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQ | tail -n 1)
OUT=$(basename $FILE | cut -d_ -f1-2)

##RGPU (String)	Read Group platform unit (eg. run barcode) Required.
## Sequencing Lane (L003 or L004)
RGPU=$(basename "$FILE" | cut -d_ -f2)

##RGLB (String)	Read Group library Required.
## Population, 10 to 267
RGLB=$(basename "$FILE" | cut -d_ -f1)

# strip S226 or w/e from original fq file
SEQ2=/rhome/jmarz001/bigdata/convergent_evolution/args/fastq_files
SEG=$(head -n $SLURM_ARRAY_TASK_ID $SEQ2 | tail -n 1 | cut -f1 | cut -d_ -f5)

# strip barcode ie. ATCACG...
BAR=$(head -n $SLURM_ARRAY_TASK_ID $SEQ2 | tail -n 1 | cut -f3)

# file location
# /rhome/jmarz001/bigdata/convergent_evolution/data/align
# original fastq directory, for mining sequencing info
# /rhome/jmarz001/shared/SEQ_RUNS/10_8_2018/FASTQ

#"@RG\tID:Novaseq_10_S226_L003\tSM:10_pool\tPU:10_L003_ATCACG \tLB:lib1\tPL:ILLUMINA"
java -jar /opt/linux/centos/7.x/x86_64/pkgs/picard/2.18.3/lib/picard.jar AddOrReplaceReadGroups \
      I=$WORK/$FILE \
      O=$RES/"$OUT"_rg.bam \
      RGID=Novaseq_"$RGLB"_"$SEG"_"$RGPU" \
      RGLB=lib1 \
      RGPL=ILLUMINA \
      RGPU="$RGLB"_"$RGPU"_"$BAR" \
      RGSM="$RGLB"_pool \
| samtools sort -o $RES/"$RGLB"_"$RGPU"_rerg_sorted.bam
