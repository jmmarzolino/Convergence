#!/usr/bin/env python

#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/test.stdout
#SBATCH --job-name='test'
#SBATCH -p short
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=5G
#SBATCH --time=2:00:00

#set input file name
InFileName = '/rhome/jmarz001/bigdata/convergent_evolution/data/top'
#InFileName = 'Jill-2_S4_R1_001.fastq.gz'
InFile=open(InFileName, 'r')
codes = ["ATCACG", "CGATGT", "TTAGGC", "ACAGTG", "CAGATC", "ACTTGA", "GATCAG", "TAGCTT", "GGCTAC"]

foo=0
#Loop through each line in file
for i in InFile:
    foo= foo + 1
    if foo == 1:
        print(i)
    elif foo == 2:
        print(i)
        for n in codes:
            if n in i:
                with open ('ATCACG.fastq', 'a') as ATCACG:
                    ATCACG.write("%s\n") % (n)
    elif foo == 3:
        print(i)
    elif foo == 4:
        print(i)
        foo=0

InFile.close()
#It doesn't need to be elegant, it just needs to work