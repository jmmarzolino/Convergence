#!/bin/bash -l

#SBATCH --ntasks=10
#SBATCH --mem-per-cpu=20G
#SBATCH --time=300:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/master.stdout
#SBATCH --job-name="master"
#SBATCH --partition=koeniglab
#SBATCH --array=1-30

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
ls $BAM/*001.bam > /rhome/jmarz001/bigdata/convergent_evolution/args/bam_merge

###################################################
#!/bin/bash -l
#SBATCH --ntasks=12
#SBATCH --mem-per-cpu=10G
#SBATCH --time=10-00:00:00
#SBATCH --output=gatk_snps.stdout
#SBATCH --job-name="gatk_snp"
#SBATCH --partition=koeniglab
#SBATCH --array=1-9
#
#SBATCH --array=1-3

module load java picard
PICARD=/opt/linux/centos/7.x/x86_64/pkgs/picard/2.18.3/lib/picard.jar
BAM=/rhome/jmarz001/bigdata/convergent_evolution/data/bam
SEQLIST=/rhome/jmarz001/bigdata/convergent_evolution/args/bams
SEQLIST2=/rhome/jmarz001/bigdata/convergent_evolution/args/bams2
#
SEQLIST4=/rhome/jmarz001/bigdata/convergent_evolution/args/bams4


NAME=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1 | cut -d_ -f1)
FILE1=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1 | cut -f1)
FILE2=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1 | cut -f2)

FILE3=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1 | cut -f3)
FILE4=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1 | cut -f4)

# is it going to wreck because not every line has 4 columns?
# --SORT_ORDER -SO	coordinate	Sort order of output file
java -jar $PICARD MergeSamFiles \
      I=$BAM/$FILE1.bam \
      I=$BAM/$FILE2.bam \
      I=$BAM/$FILE3.bam \
      I=$BAM/$FILE4.bam \
      O=$BAM/"$NAME"_pooled_merged.bam

###################################################
#!/bin/bash -l

#SBATCH --ntasks=12
#SBATCH --mem=220G
#SBATCH --time=6-00:00:00
#SBATCH --output=gatk_snps.stdout
#SBATCH --job-name="gatk_snp"
#SBATCH --partition=koeniglab
#SBATCH --array=1-12

module load java gatk/4.0.12.0 samtools picard
PICARD=/opt/linux/centos/7.x/x86_64/pkgs/picard/2.18.3/lib/picard.jar
GATK=/opt/linux/centos/7.x/x86_64/pkgs/gatk/4.0.12.0/build/libs/gatk-package-4.0.12.0-20-gf9a2e5c-SNAPSHOT-local.jar
REF=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa
CHR=/rhome/jmarz001/bigdata/convergent_evolution/small_sample/args/chr_intervals.list
#
SEQLIST=/rhome/jmarz001/bigdata/convergent_evolution/args/bams
BAM=/rhome/jmarz001/bigdata/convergent_evolution/data/bam
SNP=/rhome/jmarz001/bigdata/convergent_evolution/data/calls
#
cd $BAM
ls *_pooled_merged.bam > $SEQLIST
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1 | cut -d_ -f1)

java -jar $PICARD MarkDuplicates \
  I=$BAM/"$FILE"_pooled_merged.bam \
  O=$BAM/"$FILE"_pool_merge_dup_marked.bam \
  M=$BAM/"$FILE"_dup_metrics.txt

samtools index $BAM/"$FILE"_pool_merge_dup_marked.bam

for region in $CHR
do
gatk HaplotypeCaller -R $REF -L ${region} -I $BAM/"$FILE"_pool_merge_dup_marked.bam -O $SNP/$FILE.g.vcf -ERC GVCF
done
###################################################
#!/bin/bash -l

#SBATCH --ntasks=12
#SBATCH --mem=220G
#SBATCH --time=6-00:00:00
#SBATCH --output=gatk_snps.stdout
#SBATCH --job-name="gatk_snp"
#SBATCH --partition=koeniglab
#SBATCH --array=1-12

# combine the split-by-genome-region gvcf files into per-population/sample gVCF files

# CombineGVCFs is meant to be used for hierarchical merging of gVCFs that will eventually be input into GenotypeGVCFs. One would use this tool when needing to genotype too large a number of individual gVCFs; instead of passing them all in to GenotypeGVCFs, one would first use CombineGVCFs on smaller batches of samples and then pass these combined gVCFs to GenotypeGVCFs.
# So don't use CombineGVCFs?

# normally you would use GatherVcfs when the gvcf was generated per-chromosome, but in this case I have a problem with slight overlapping regions
# GatherVcfs (Picard)  Input files must ... not have events at overlapping positions.
# so you can't use that either

# Picard MergeVcfs can work with overlapping positions, it basically just needs working files
# will this work with gvcf? I sure hope so
java -jar picard.jar MergeVcfs \
          I=input_variants.01.vcf \
          I=input_variants.02.vcf.gz \
          O=output_variants.vcf.gz


ls 10_chr*.vcf >


# Then use GenomicsDBImport to:
# take in one or more single-sample GVCFs and imports data over at least one genomics interval, and outputs a directory containing a GenomicsDB datastore with combined multi-sample data.
# GenotypeGVCFs can then read from the created GenomicsDB directly and output the final multi-sample VCF.
# So if you have a trio of GVCFs your GenomicsDBImport command would look like this, assuming you're running per chromosome (here we're showing the tool running on chromosome 20 and chromosome 21):
DIR=
gatk GenomicsDBImport \
    -V data/gvcfs/mother.g.vcf \
    -V data/gvcfs/father.g.vcf \
    -V data/gvcfs/son.g.vcf \
    --genomicsdb-workspace-path my_database \
    --intervals chr20,chr21


###################################################

#!/usr/bin/bash -l
#SBATCH -p short
#SBATCH --ntasks=2
#SBATCH --mem=100G
#SBATCH --time=2:00:00
#SBATCH --output=para_first_filter.stdout
#SBATCH --job-name='para_filter'
#SBATCH --array=1-12

# genotpye gVCF files > snp calls vcf file
GATK=/opt/linux/centos/7.x/x86_64/pkgs/gatk/4.0.12.0/build/libs/gatk-package-4.0.12.0-20-gf9a2e5c-SNAPSHOT-local.jar
REF=/rhome/jmarz001/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa
CHR=/rhome/jmarz001/bigdata/convergent_evolution/small_sample/args/chr_intervals.list
#
SEQLIST=/rhome/jmarz001/bigdata/convergent_evolution/args/gvcf
SNP=/rhome/jmarz001/bigdata/convergent_evolution/data/calls
cd $SNP
#
ls *.g.vcf > $SEQLIST
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1 | cut -d. -f1)

for region in $CHR
do
java -jar $GATK \
   -T GenotypeGVCFs \
   --max-alternate-alleles 2 \
   -newQual
   -R $REF \
   -V $FILE.g.vcf \
   -o "$FILE"_"$region"_raw_calls.vcf
done

###################################################
