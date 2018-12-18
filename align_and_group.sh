#!/bin/bash -l

#SBATCH --ntasks=8
#SBATCH --mem=64G
#SBATCH --time=168:00:00
#SBATCH --job-name='align'
#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/align_and_group.stdout
#SBATCH -p batch
#SBATCH --array=1-36

# BWA Alignment into raw sorted alignment
# then sam to sorted bam
# bwa mem ref reads.fq > aln.sam
# assign read groups and get mapping statistics

module load bwa samtools bedtools

# Define location variables
WORK=/rhome/jmarz001/bigdata/convergent_evolution/data/trim_files
cd $WORK
SEQLIST=/rhome/jmarz001/bigdata/convergent_evolution/args/align_files
ls *trimmed_paired.fq >> $SEQLIST
RES=/rhome/jmarz001/bigdata/convergent_evolution/data/align/
INDEX=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1)

##RGSM
# Sample ID
SAMPLE=$(basename "$FILE" | cut -d_ -f1-3)

##RGPU (String)	Read Group platform unit (eg. run barcode) Required.
## Sequencing Lane (L003 or L004)
RGPU=$(basename "$FILE" | cut -d_ -f2)

##RGLB (String)	Read Group library Required.
## Population, 10 to 267
RGLB=$(basename "$FILE" | cut -d_ -f1)

bwa mem -R "@RG\tID:$SLURM_ARRAY_TASK_ID\tSM:$SAMPLE\tPU:$RGPU\tLB:$RGLB" -t 8 $INDEX $WORK/"$FILE" > $RES/"$SAMPLE".sam

# mapping stats
samtools flagstat $RES/"$SAMPLE".sam > $RES/mappingstats/"$SAMPLE"_mapstats.txt

# sam to sorted bam and index long bams with csi file
samtools view -bS $RES/"$SAMPLE".sam | samtools sort -o $RES/"$SAMPLE".bam
samtools index -c $RES/"$SAMPLE".bam

# extract unmapped reads
samtools view -f4 -b $RES/"$SAMPLE".bam > $RES/"$SAMPLE".unmapped.bam

# export unmapped reads from original reads
bedtools bamtofastq -i $RES/"$SAMPLE".unmapped.bam -fq $RES/"$SAMPLE".unmapped.fq
