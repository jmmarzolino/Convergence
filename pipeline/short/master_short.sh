#!/bin/bash -l

#SBATCH --ntasks=10
#SBATCH --mem-per-cpu=15G
#SBATCH --time=200:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/small_sample/master_short.stdout
#SBATCH --job-name="master_short"
#SBATCH --partition=koeniglab
#SBATCH --array=1-27%2

module load trimmomatic/0.36 bwa samtools bedtools picard
TRIMMOMATIC=/opt/linux/centos/7.x/x86_64/pkgs/trimmomatic/0.36/trimmomatic.jar
ADAPTERDIR=/rhome/cfisc004/software/Trimmomatic-0.36/adapters
INDEX=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa

WORKINGDIR=/rhome/jmarz001/bigdata/convergent_evolution/small_sample
mkdir $WORKINGDIR/data
mkdir $WORKINGDIR/args
TRIM=/rhome/jmarz001/bigdata/convergent_evolution/small_sample/data/trim
mkdir "$TRIM"
BAM=/rhome/jmarz001/bigdata/convergent_evolution/small_sample/data/bam
mkdir "$BAM"

SEQ1=/rhome/jmarz001/bigdata/convergent_evolution/small_sample/args/fq_r1
SEQ2=/rhome/jmarz001/bigdata/convergent_evolution/small_sample/args/fq_r2
cd $WORKINGDIR/data
ls *R1* > $SEQ1
ls *R2* > $SEQ2
FILE_R1=$(head -n $SLURM_ARRAY_TASK_ID $SEQ1 | tail -n 1 | cut -d. -f1)
FILE_R2=$(head -n $SLURM_ARRAY_TASK_ID $SEQ2 | tail -n 1 | cut -d. -f1)

# Quality/Adapter trimming
java -jar $TRIMMOMATIC PE -threads 10 \
$WORKINGDIR/data/"$FILE_R1".fq $WORKINGDIR/data/"$FILE_R2".fq \
$TRIM/"$FILE_R1"_trim_pair.fq $TRIM/"$FILE_R1"_unpaired.fq \
$TRIM/"$FILE_R2"_trim_pair.fq $TRIM/"$FILE_R2"_unpaired.fq \
ILLUMINACLIP:"$ADAPTERDIR"/PE_all.fa:2:30:10 \
SLIDINGWINDOW:4:20 MINLEN:75 #or 100

#"@RG\tID:Novaseq_10_S226_L003\tSM:10_pool\tPU:10_L003_ATCACG \tLB:lib1\tPL:ILLUMINA"
RG=/rhome/jmarz001/bigdata/convergent_evolution/small_sample/args/file_r1
# Sample ID: <sequencer>_<gen>_<S#>_<lane>
SEQR=$(head -n $SLURM_ARRAY_TASK_ID $RG | tail -n 1 | cut -f2)
GEN=$(basename "$FILE_R1" | cut -d_ -f1)
RUN=$(basename "$FILE_R1" | cut -d_ -f2)
## Sequencing Lane (L003 or L004)
LANE=$(basename "$FILE_R1" | cut -d_ -f3)
BAR=$(head -n $SLURM_ARRAY_TASK_ID $RG | tail -n 1 | cut -f3)
SAMPLE=$(basename "$FILE_R1" | cut -d_ -f1-3)

bwa mem -R "@RG\tID:${SEQR}_${SAMPLE}\tSM:${GEN}_pool\tPU:${SAMPLE}_${BAR}\tLB:lib1\tPL:ILLUMINA" -t 10 $INDEX \
$TRIM/"$FILE_R1"_trim_pair.fq $TRIM/"$FILE_R2"_trim_pair.fq | samtools sort -@ 20 -o $BAM/"$SAMPLE"_001.bam

# view the header of a bam file to check the read groups are passed on right: samtools view -H 250_S229_L004_001.bam | less

PICARD=/opt/linux/centos/7.x/x86_64/pkgs/picard/2.18.3/lib/picard.jar
java -jar $PICARD MarkDuplicates \
  I=$BAM/"$SAMPLE"_001.bam \
  O=$BAM/"$SAMPLE"_dup_marked_001.bam \
  M=$BAM/"$SAMPLE"_marked_dup_metrics.txt

###################################################
#!/bin/bash -l

#SBATCH --ntasks=12
#SBATCH --mem-per-cpu=10G
#SBATCH --time=1-00:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/small_sample/master_snps.stdout
#SBATCH --job-name="master_snp"
#SBATCH --partition=koeniglab
#SBATCH --array=1-16%2

module load freebayes/1.2.0
REF=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa
CHR=/rhome/jmarz001/bigdata/CCXXIRAD/calls/chr_splits.txt
REGION=$(head -n $SLURM_ARRAY_TASK_ID $CHR | tail -n 1)

BAM=/rhome/jmarz001/bigdata/convergent_evolution/small_sample/data/bam
cd $BAM
SNP=/rhome/jmarz001/bigdata/convergent_evolution/small_sample/data/calls
mkdir $SNP
BAMFILE=$BAM/files
ls *_dup_marked_001.bam > $BAMFILE
# --bam-list also represented by -L
#freebayes -f [reference] [infiles.bam] > [outfiles.vcf]
freebayes -k -f $REF -r $REGION -L $BAMFILE > $SNP/$REGION.freebayes.snps.vcf
