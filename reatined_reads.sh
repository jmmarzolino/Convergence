#!/bin/bash -l

#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/retained_trim.stdout
#SBATCH --job-name='trim retained'
#SBATCH --ntasks=1
#SBATCH --mem=10G
#SBATCH --time=5:00:00
#SBATCH -p batch

#Get the number of reads from before and after trimming

###BEFORE
#set and move to working directory
ARGS=/rhome/jmarz001/bigdata/convergent_evolution/args

PRE=/rhome/jmarz001/bigdata/convergent_evolution/quality/fastq_qc
cd $PRE/
printf "Filename \t Total Sequences \n" > $ARGS/pre_fileseqs.txt
#make a list of all the directory names so they can be cd'd into in turn
ls -d /rhome/jmarz001/bigdata/convergent_evolution/quality/fastq_qc/*fastqc
folders=$(ls -d *fastqc)
#move into each directory from the list
#copy directory name and Total Sequences line from fastqc data file into fileseqs
for dir in $folders; do
  cd $dir
  A=`grep "Filename" fastqc_data.txt | cut -f2`
  B=`grep "Total Sequences" fastqc_data.txt | cut -f2`
  printf "$A\t$B\n" >> $ARGS/pre_fileseqs.txt
  cd ..
done

###AFTER
#set and move to new working dir
POST=/rhome/jmarz001/bigdata/convergent_evolution/quality/trim
cd $POST
printf "Filename \t Total Sequences \n" > $ARGS/post_fileseqs.txt
#make a list of all the directory names so they can be cd'd into in turn
folders=$(ls -d *fastqc)
#move into each directory from the list
#copy directory name and Total Sequences line from fastqc data file into fileseqs
for dir in $folders; do
  cd $dir
  A=`grep "Filename" fastqc_data.txt | cut -f2`
  B=`grep "Total Sequences" fastqc_data.txt | cut -f2`
  printf "$A\t$B\n" >> $ARGS/post_fileseqs.txt
  cd ..
done

#Alternative idea
#strip.dirNAME=name
#cp fastqc_data.txt > ../name_data.txt

# take any column and paste them as columns into
#paste < (cut -f1,5,7 file)
#paste < (cut -f5 file) < (cut -f50 file) > outfile
