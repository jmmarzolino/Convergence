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
a=open("ATCACG.fastq", "a+")
b=open("CGATGT.fastq", "a+")
c=open("TTAGGC.fastq", "a+")
d=open("ACAGTG.fastq", "a+")
e=open("CAGATC.fastq", "a+")
f=open("ACTTGA.fastq", "a+")
g=open("GATCAG.fastq", "a+")
h=open("TAGCTT.fastq", "a+")
j=open("GGCTAC.fastq", "a+")
tmp=open("tmp.fastq", "w+")

foo=0

#Loop through each line in file
for i in InFile:
    foo= foo + 1
    if foo <= 4:
        tmp.write(i)
    if foo == 4:
        for i in tmp:
            match = re.search('^@', i)
            if match:
                var = i
            match = re.search('^ATCACG', i)
            if match:
                a.write(var)
                a.write(i)
                for line in tmp:
                    a.write(line)
            match = re.search('^CGATGT', i)
            elif match:
                b.write(var)
                b.write(i)
                for line in tmp:
                    b.write(line)
            match = re.search('^TTAGGC', i)
            elif match:
                c.write(var)
                c.write(i)
                for line in tmp:
                    c.write(line)
            match = re.search('^ACAGTG', i)
            elif match:
                d.write(var)
                d.write(i)
                for line in tmp:
                    d.write(line)
            match = re.search('^CAGATC', i)
            elif match:
                e.write(var)
                e.write(i)
                for line in tmp:
                    e.write(line)
            match = re.search('^ACTTGA', i)
            elif match:
                f.write(var)
                f.write(i)
                for line in tmp:
                    f.write(line)
            match = re.search('^GATCAG', i)
            elif match:
                g.write(var)
                g.write(i)
                for line in tmp:
                    g.write(line)
            match = re.search('^TAGCTT', i)
            elif match:
                h.write(var)
                h.write(i)
                for line in tmp:
                    h.write(line)
            match = re.search('^GGCTAC', i)
            elif match:
                j.write(var)
                j.write(i)
                for line in tmp:
                    j.write(line)
        tmp.close
        tmp=open("tmp.fastq", "w+")
        foo=0

a.close()
b.close()
c.close()
d.close()
e.close()
f.close()
g.close()
h.close()
j.close()
tmp.close()
InFile.close()
#It doesn't need to be elegant, it just needs to work