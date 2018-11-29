#!/bin/bash -l

#SBATCH -p koeniglab
#SBATCH --nodes=1
#SBATCH --ntasks=6
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=20G
#SBATCH --time=40:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/CCXXIRAD/Scripts/trim_fastqc.stdout
#SBATCH --mail-user=jmarz001@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name='rad_trim_fastqc'

module load java/7u40
module load fastqc/0.11.7

## Format for fastqc function: in files, out directory specification, number of threads (only use 6 on 32Gb machine and match with ntasks in header), -q (quiet) puts errors in stdout file not stdout and log (saves time and space)
# <fastqc somefile.txt someotherfile.txt --outdir=/some/other/dir/ -t 6 -q>

#pipe all file names into fastqc using ls (fed wildcard for files), tell fastqc to use stdin (ie. the files fed from pipe)
WORKINGDIR=/rhome/jmarz001/bigdata/CCXXIRAD/trim
RESULTSDIR=/rhome/jmarz001/bigdata/CCXXIRAD/trim/fastqc
cd $WORKINGDIR

for file in $WORKINGDIR/*.fq
do
  #gunzip "$file"
  fastqc "$file" --outdir=$RESULTSDIR/"$file_qual" -t 6 -q
done