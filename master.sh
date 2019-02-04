#!/bin/bash -l

#SBATCH --ntasks=10
#SBATCH --mem-per-cpu=20G
#SBATCH --time=300:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/master.stdout
#SBATCH --job-name="master"
#SBATCH --partition=koeniglab
#SBATCH --array=1-31%2

module load trimmomatic/0.36 bwa samtools bedtools picard
TRIMMOMATIC=/opt/linux/centos/7.x/x86_64/pkgs/trimmomatic/0.36/trimmomatic.jar
ADAPTERDIR=/rhome/cfisc004/software/Trimmomatic-0.36/adapters
INDEX=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa

# set up environment
WORKINGDIR=/rhome/jmarz001/bigdata/convergent_evolution
TRIM=/rhome/jmarz001/bigdata/convergent_evolution/data/trim
BAM=/rhome/jmarz001/bigdata/convergent_evolution/data/bam
# mkdir $WORKINGDIR ; mkdir $WORKINGDIR/args ; mkdir $WORKINGDIR/data ; mkdir $WORKINGDIR/scripts ; mkdir "$TRIM" ; mkdir "$BAM"
# write fq_file with: R1_file \t R2_file \t barcode :for ALL FILES w/ full file locations

SEQLIST=/rhome/jmarz001/bigdata/convergent_evolution/args/fastq_files
FILE_R1=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1 | cut -f1)
FILE_R2=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1 | cut -f2)
NAME=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1 | cut -f3)

# Quality/Adapter trimming
java -jar $TRIMMOMATIC PE -threads 10 \
/"$FILE_R1".gz /"$FILE_R2".gz \
$TRIM/"$NAME"_R1_trim_pair.fq $TRIM/"$NAME"_R1_unpaired.fq \
$TRIM/"$NAME"_R2_trim_pair.fq $TRIM/"$NAME"_R2_unpaired.fq \
ILLUMINACLIP:"$ADAPTERDIR"/PE_all.fa:2:30:10 \
SLIDINGWINDOW:4:20 MINLEN:75 #or 100

#"@RG\tID:Novaseq_10_S226_L003\tSM:10_pool\tPU:10_L003_ATCACG \tLB:lib1\tPL:ILLUMINA"
# Sample ID: <sequencer>_<gen>_<S#>_<lane>
SEQR=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1 | cut -f5)
GEN=$(basename "$NAME" | cut -d_ -f1)
RUN=$(basename "$NAME" | cut -d_ -f2)
## Sequencing Lane (L003 or L004)
LANE=$(basename "$NAME" | cut -d_ -f3)
BAR=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1 | cut -f4)
SAMPLE=$(basename "$NAME" | cut -d_ -f1-3)

bwa mem -R "@RG\tID:${SEQR}_${SAMPLE}\tSM:${GEN}_pool\tPU:${SAMPLE}_${BAR}\tLB:lib1\tPL:ILLUMINA" -t 10 $INDEX \
$TRIM/"$NAME"_R1_trim_pair.fq $TRIM/"$NAME"_R2_trim_pair.fq | samtools sort -@ 20 -o $BAM/"$NAME".bam
# view the header of a bam file to check the read groups are passed on right: samtools view -H 250_S229_L004_001.bam | less

PICARD=/opt/linux/centos/7.x/x86_64/pkgs/picard/2.18.3/lib/picard.jar
java -jar $PICARD MarkDuplicates \
  I=$BAM/"$NAME".bam \
  O=$BAM/"$NAME"_dup_marked.bam \
  M=$BAM/"$NAME"_dup_metrics.txt

###################################################
#!/bin/bash -l

#SBATCH --ntasks=12
#SBATCH --mem-per-cpu=10G
#SBATCH --time=200:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/master_snps.stdout
#SBATCH --job-name="master_snp"
#SBATCH --partition=koeniglab
#SBATCH --array=1-16%2

module load freebayes/1.2.0
REF=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa
CHR=/rhome/jmarz001/bigdata/CCXXIRAD/calls/chr_splits.txt
REGION=$(head -n $SLURM_ARRAY_TASK_ID $CHR | tail -n 1)

BAM=/rhome/jmarz001/bigdata/convergent_evolution/data/bam
cd $BAM
ls *_dup_marked.bam > $BAM/files
SNP=/rhome/jmarz001/bigdata/convergent_evolution/data/calls
# mkdir $SNP
# --bam-list also represented by -L
#freebayes -f [reference] [infiles.bam] > [outfiles.vcf]
freebayes -k -f $REF -r $REGION -L $BAM/files > $SNP/$REGION.freebayes.snps.vcf