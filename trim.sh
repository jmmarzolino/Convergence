#!/bin/bash -l

#SBATCH -p koeniglab
#SBATCH --ntasks=8
#SBATCH --mem=200G
#SBATCH --time=24:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/trim.out
#SBATCH --job-name='trim'
#SBATCH --array=1-36

###java -jar <path to trimmomatic jar> SE/PE [-threads <threads>] [-phred33/64] [-trimlog <log file>] <input1> <input2> <paired output 1> <unpaired output 1> <paired output 2> <unpaired output 2> <step 1>...
module load trimmomatic/0.36

TRIMMOMATIC=/opt/linux/centos/7.x/x86_64/pkgs/trimmomatic/0.36/trimmomatic.jar
ADAPTERDIR=/rhome/cfisc004/software/Trimmomatic-0.36/adapters

WORKINGDIR=/rhome/jmarz001/bigdata/convergent_evolution/data
RESULTSDIR=/rhome/jmarz001/bigdata/convergent_evolution/data/trim_files
SEQLIST=/rhome/jmarz001/bigdata/convergent_evolution/args/fastq_trim_seqs
cd $WORKINGDIR
ls *.fastq > $SEQLIST

# get filenames from list
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1)
# get basename of file, stripping at "."
#267_S234_L003_R1_001.fastq
#267_S234_L003_R2_001.fastq
#267_S234_L004_R1_001.fastq
#267_S234_L004_R2_001.fastq
# == 267_S234_L003(_R1_001)
NAME=$(basename "$FILE" | cut -d. -f1 | cut -d_ -f1-3)
# == 267_L003/4
SHORT=$(basename "$NAME" | cut -d_ -f1,3)

# Quality/Adapter trimming
java -jar $TRIMMOMATIC PE -threads 6 -trimlog trimlog\
$WORKINGDIR/"$NAME"_R1_001.fastq $WORKINGDIR/"$NAME"_R2_001.fastq \
$RESULTSDIR/"$SHORT"_1_trimmed_paired.fq $RESULTSDIR/"$SHORT"_1_unpaired.fq \
$RESULTSDIR/"$SHORT"_2_trimmed_paired.fq $RESULTSDIR/"$SHORT"_2_unpaired.fq \
ILLUMINACLIP:"$ADAPTERDIR"/PE_all.fa:2:30:10 \
LEADING:5 TRAILING:5 SLIDINGWINDOW:4:20 MINLEN:36
