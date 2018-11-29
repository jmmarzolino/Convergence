#!/bin/bash -l

#SBATCH -p batch
#SBATCH --ntasks=6
#SBATCH --mem=60G
#SBATCH --time=10:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/trim_qc.out
#SBATCH --job-name='trim_qc'

# generate fastqc (quality reports) for trimmed sequences
###java -jar <path to trimmomatic jar> SE/PE [-threads <threads>] [-phred33/64] [-trimlog <log file>] <input1> <input2> <paired output 1> <unpaired output 1> <paired output 2> <unpaired output 2> <step 1>...
module load trimmomatic/0.36

TRIMMOMATIC=/opt/linux/centos/7.x/x86_64/pkgs/trimmomatic/0.36/trimmomatic.jar
ADAPTERDIR=/opt/linux/centos/7.x/x86_64/pkgs/trimmomatic/0.33/adapters

WORKINGDIR=/rhome/jmarz001/bigdata/convergent_evolution/data
cd $WORKINGDIR
RESULTSDIR=/rhome/jmarz001/bigdata/convergent_evolution
SEQLIST=/rhome/jmarz001/bigdata/CCXXIRAD/barcode/seqs

for file in $WORKINGDIR/*.fastq.gz
do

done

# get filenames from list
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1)
# get basename of file, stripping at "."
NAME=$(basename "$FILE" | cut -d. -f1)

# Quality/Adapter trimming
java -jar $TRIMMOMATIC SE -threads 4 \
$WORKINGDIR/"$NAME".fq $RESULTSDIR/"$NAME"_trimmed.fq \
ILLUMINACLIP:"$ADAPTERDIR"/TruSeq3-SE.fa:2:30:10 \
LEADING:5 TRAILING:5 SLIDINGWINDOW:4:20 MINLEN:36