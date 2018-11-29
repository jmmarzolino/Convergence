#!/bin/bash -l

#SBATCH --ntasks=9
#SBATCH --mem=10G
#SBATCH --time=168:00:00
#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/mur_matching_reads.stdout
#SBATCH --job-name='matching_reads'
#SBATCH -p batch

DIR=/rhome/jmarz001/bigdata/convergent_evolution/scripts
REF=
module load bwa

bwa mem -t 9 -R "@RG\tID:Master\tSM:wildbarley\tPL:ILLUMINA" \
/rhome/jmarz001/bigdata/Practice/Hordeum_vulgare.Hv_IBSC_PGSB_v2.dna.toplevel/Hordeum_vulgare.Hv_IBSC_PGSB_v2.dna.toplevel \
/rhome/jmarz001/bigdata/Master/trim/wildbarley_pairout1.fastq.gz \
/rhome/jmarz001/bigdata/Master/trim/wildbarley_pairout2.fastq.gz \
> /rhome/jmarz001/bigdata/Master/raw_aligns/mur_align.sam


##script tailed after header