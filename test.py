#!/usr/bin/env python

#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/match.stdout
#SBATCH --job-name='test'
#SBATCH -p short
#SBATCH --ntasks=1
#SBATCH --mem=15G
#SBATCH --time=2:00:00

#set input file name
InFileName = '/rhome/jmarz001/bigdata/convergent_evolution/data/top'
InFile=open(InFileName, 'r')

a=open("/rhome/jmarz001/bigdata/convergent_evolution/data/ATCACG.fastq", "a+")
tmp=open("/rhome/jmarz001/bigdata/convergent_evolution/data/tmp.fastq", "w+")

foo=0

for i in InFile:
    foo = foo + 1
    if foo <= 4:
        tmp.write(i)
    if foo == 4:
        for i in tmp:
            atmatch = re.search('^@', i)
            if atmatch:
                var = i
            amatch = re.search('^ATCACG', i)
            if amatch:
                a.write(var)
                a.write(i)
                for line in tmp:
                    a.write(line)

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
                print("match!")
    elif foo == 3:
        print(i)
    elif foo == 4:
        print(i)
        foo=0

InFile.close()
#It doesn't need to be elegant, it just needs to work