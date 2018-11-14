#!/bin/bash -l

#SBATCH -p koeniglab
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time=10:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/fastqc.out
#SBATCH --job-name='fastqc'

# generate fastqc (quality reports) for downloaded fastq sequences
# <fastqc somefile.txt someotherfile.txt --outdir=/some/other/dir/ -t 6 -q>
module load picard
module load fastqc/0.11.7

WORKINGDIR=/rhome/jmarz001/shared/SEQ_RUNS/10_17_2018/FASTQ
RESULTSDIR=/rhome/jmarz001/bigdata/convergent_evolution/fastqcs
cd $WORKINGDIR

for file in $WORKINGDIR/*.fastq
do
  #gunzip "$file"
  fastqc "$file" --outdir=$RESULTSDIR/"$file_qual" -t 6 -q
done