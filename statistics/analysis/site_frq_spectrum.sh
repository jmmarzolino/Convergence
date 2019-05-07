#!/usr/bin/bash
#SBATCH -p short
#SBATCH --ntasks=1
#SBATCH --mem=30G
#SBATCH --time=02:00:00
#SBATCH --job-name='site_freq'
#SBATCH --output=site_freq.stdout
#SBATCH --array=1-12

cd /rhome/jmarz001/bigdata/convergent_evolution/results
LIST=/rhome/jmarz001/bigdata/convergent_evolution/args/spectra
FILE=$(head -n $SLURM_ARRAY_TASK_ID $LIST | tail -n 1)
POP=$(basename $FILE | cut -d_ -f3)
# count occurances of 'na'
grep -c 'na' $FILE > missing_sites_${POP}
# remove 'na' lines
sed -i -e 's/na//g' $FILE > ${FILE}_nona
# remove blank spaces leftover from sed
grep '[^[:blank:]]' $FILE > ${FILE}_floats
