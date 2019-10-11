#!/bin/bash -l

#SBATCH --ntasks=10
#SBATCH --mem=20G
#SBATCH --time=168:00:00
#SBATCH --job-name='align'
#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/con002_align.stdout
#SBATCH -p koeniglab
#SBATCH --array=1-4%4

# load modules
module load minimap2
module load samtools
module load trimmomatic

# Define locations and files
WORK=/rhome/jmarz001/bigdata/convergent_evolution/data/trim_files
FILE_LIST=/rhome/jmarz001/bigdata/convergent_evolution/args
RES=/rhome/jmarz001/bigdata/convergent_evolution/data/align
INDEX=/rhome/dkoenig/shared/GENOMES/NEW_BARLEY/GENOME_SPLIT/barley_split_reference.fa

# select each set of reads from the file in turn
thisfile_1=`head -n ${SLURM_ARRAY_TASK_ID} $FILE_LIST | tail -n1 | cut -f1`
thisfile_2=`head -n ${SLURM_ARRAY_TASK_ID} $FILE_LIST | tail -n1 | cut -f2`
sample_name=`head -n ${SLURM_ARRAY_TASK_ID} $FILE_LIST | tail -n1 | cut -f3`
run_name=`head -n ${SLURM_ARRAY_TASK_ID} $FILE_LIST | tail -n1 | cut -f4`

mkdir $WORK/TRIM_FASTQS
mkdir $WORK/TMP
mkdir $WORK/OUTPUT/BAM

java -jar /opt/linux/centos/7.x/x86_64/pkgs/trimmomatic/0.33/bin/trimmomatic.jar PE -threads 10 ${thisfile_1} ${thisfile_2} ${wkdir}/OUTPUT/TRIM_FASTQS/${sample_name}${run_name}_1.fq.gz ${wkdir}/OUTPUT/TRIM_FASTQS/${sample_name}${run_name}_1_un.fq.gz ${wkdir}/OUTPUT/TRIM_FASTQS/${sample_name}${run_name}_2.fq.gz ${wkdir}/OUTPUT/TRIM_FASTQS/${sample_name}${run_name}_2_un.fq.gz ILLUMINACLIP:/opt/linux/centos/7.x/x86_64/pkgs/trimmomatic/0.33/adapters/TruSeq3-PE.fa:2:30:10 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:75

minimap2 -t 10 -ax sr ~/shared/GENOMES/NEW_BARLEY/2019_Release_Morex_vers2/Barley.mmi -R "@RG\tID:bar_samp_${SLURM_ARRAY_TASK_ID}\tPL:illumina\tSM:${sample_name}\tLB:${sample_name}" ${wkdir}/OUTPUT/TRIM_FASTQS/${sample_name}${run_name}_1.fq.gz ${wkdir}/OUTPUT/TRIM_FASTQS/${sample_name}${run_name}_2.fq.gz > ${wkdir}/OUTPUT/BAM/${sample_name}${run_name}.sam

samtools view -b -T ~/shared/GENOMES/NEW_BARLEY/2019_Release_Morex_vers2/Barley_Morex_V2_pseudomolecules.fasta ${wkdir}/OUTPUT/BAM/${sample_name}${run_name}.sam | samtools sort -@ 20 > ${wkdir}/OUTPUT/BAM/${sample_name}${run_name}.bam
samtools index -c ${wkdir}/OUTPUT/BAM/${sample_name}${run_name}.bam
