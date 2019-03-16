#!/usr/bin/env python

#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/barcode.stdout
#SBATCH --job-name='test'
#SBATCH -p koeniglab
#SBATCH --ntasks=15
#SBATCH --mem=150G
#SBATCH --time=50:00:00
#SBATCH --array=1-384

#set input file name
InFileName = '/rhome/jmarz001/bigdata/convergent_evolution/data/top'
#InFileName = 'Jill-1_S3_R1_001.fastq'
#InFileName = 'Jill-2_S4_R1_001.fastq'
InFile=open(InFileName, 'r')
#codes = ["ATCACG", "CGATGT", "TTAGGC", "ACAGTG", "CAGATC", "ACTTGA", "GATCAG", "TAGCTT", "GGCTAC"]
a=open("/rhome/jmarz001/bigdata/convergent_evolution/data/ATCACG.fastq", "a+")
b=open("/rhome/jmarz001/bigdata/convergent_evolution/data/CGATGT.fastq", "a+")
c=open("/rhome/jmarz001/bigdata/convergent_evolution/data/TTAGGC.fastq", "a+")
d=open("/rhome/jmarz001/bigdata/convergent_evolution/data/ACAGTG.fastq", "a+")
e=open("/rhome/jmarz001/bigdata/convergent_evolution/data/CAGATC.fastq", "a+")
f=open("/rhome/jmarz001/bigdata/convergent_evolution/data/ACTTGA.fastq", "a+")
g=open("/rhome/jmarz001/bigdata/convergent_evolution/data/GATCAG.fastq", "a+")
h=open("/rhome/jmarz001/bigdata/convergent_evolution/data/TAGCTT.fastq", "a+")
j=open("/rhome/jmarz001/bigdata/convergent_evolution/data/GGCTAC.fastq", "a+")
tmp=open("/rhome/jmarz001/bigdata/convergent_evolution/data/tmp.fastq", "w+")

foo=0

#Loop through each line in file
for i in InFile:
    foo= foo + 1
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
            bmatch = re.search('^CGATGT', i)
            if bmatch:
                b.write(var)
                b.write(i)
                for line in tmp:
                    b.write(line)
            cmatch = re.search('^TTAGGC', i)
            if cmatch:
                c.write(var)
                c.write(i)
                for line in tmp:
                    c.write(line)
            dmatch = re.search('^ACAGTG', i)
            if dmatch:
                d.write(var)
                d.write(i)
                for line in tmp:
                    d.write(line)
            ematch = re.search('^CAGATC', i)
            if ematch:
                e.write(var)
                e.write(i)
                for line in tmp:
                    e.write(line)
            fmatch = re.search('^ACTTGA', i)
            if fmatch:
                f.write(var)
                f.write(i)
                for line in tmp:
                    f.write(line)
            gmatch = re.search('^GATCAG', i)
            if gmatch:
                g.write(var)
                g.write(i)
                for line in tmp:
                    g.write(line)
            hmatch = re.search('^TAGCTT', i)
            if hmatch:
                h.write(var)
                h.write(i)
                for line in tmp:
                    h.write(line)
            jmatch = re.search('^GGCTAC', i)
            if jmatch:
                j.write(var)
                j.write(i)
                for line in tmp:
                    j.write(line)
        tmp.close()
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