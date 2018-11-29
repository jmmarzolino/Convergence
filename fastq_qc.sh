#!/bin/bash -l

#SBATCH -p batch
#SBATCH --ntasks=4
#SBATCH --mem=24G
#SBATCH --time=10:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/fastq_qc.out
#SBATCH --job-name='fastq_qc'

# generate fastqc (quality reports)
# <fastqc somefile.txt someotherfile.txt --outdir=/some/other/dir/ -t # -q>
module load picard
module load fastqc/0.11.7

WORKINGDIR=/rhome/jmarz001/bigdata/convergent_evolution/data
RESULTSDIR=/rhome/jmarz001/bigdata/convergent_evolution/fastqcs

for file in $WORKINGDIR/*.fastq
do
  fastqc "$file" --outdir=$RESULTSDIR/"$file_qual" -t 4 -q
done