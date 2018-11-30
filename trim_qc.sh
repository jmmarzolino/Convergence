#!/bin/bash -l

#SBATCH -p koeniglab
#SBATCH --ntasks=6
#SBATCH --mem=120G
#SBATCH --time=72:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/trim_qc.stdout
#SBATCH --job-name='trim_fastqc'
#SBATCH --array=1-150

module load java/7u40
module load fastqc/0.11.7

## Format for fastqc function: in files, out directory specification, number of threads (only use 6 on 32Gb machine and match with ntasks in header), -q (quiet) puts errors in stdout file not stdout and log (saves time and space)
# <fastqc somefile.txt someotherfile.txt --outdir=/some/other/dir/ -t 6 -q>

#pipe all file names into fastqc using ls (fed wildcard for files), tell fastqc to use stdin (ie. the files fed from pipe)
WORKINGDIR=/rhome/jmarz001/bigdata/convergent_evolution/data/trim_files
RESULTSDIR=/rhome/jmarz001/bigdata/convergent_evolution/quality/trim
SEQLIST=/rhome/jmarz001/bigdata/convergent_evolution/args/trimfq_qcseqs
cd $WORKINGDIR
ls *.fq > $SEQLIST

# get filenames from list
FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1)
# get basename of file, stripping at "."
#10_L003_1_trimmed_paired.fq
#10_L003_1_unpaired.fq
NAME=$(basename "$FILE" | cut -d. -f1)
#==10_L003_1_trimmed_paired
#==10_L003_1_unpaired

fastqc $NAME.fq --outdir=$RESULTSDIR/$NAME -t 6 -q
unzip $RESULTSDIR/$NAME