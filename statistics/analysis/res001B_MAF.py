#!/usr/bin/env python
#SBATCH -p short
#SBATCH --ntasks=1
#SBATCH --mem=30G
#SBATCH --time=02:00:00
#SBATCH --job-name='res001B'
#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/results/10_AF.stdout

#set input file name
InFileName = '/rhome/jmarz001/bigdata/convergent_evolution/results/10_AF2'
#InFileName = '/rhome/jmarz001/bigdata/convergent_evolution/results/16_AF2'
#InFileName = '/rhome/jmarz001/bigdata/convergent_evolution/results/1L_AF2'
#InFileName = '/rhome/jmarz001/bigdata/convergent_evolution/results/24_AF2'
#InFileName = '/rhome/jmarz001/bigdata/convergent_evolution/results/250_AF2'
#InFileName = '/rhome/jmarz001/bigdata/convergent_evolution/results/255_AF2'
#InFileName = '/rhome/jmarz001/bigdata/convergent_evolution/results/257_AF2'
#InFileName = '/rhome/jmarz001/bigdata/convergent_evolution/results/258_AF2'
#InFileName = '/rhome/jmarz001/bigdata/convergent_evolution/results/262_AF2'
#InFileName = '/rhome/jmarz001/bigdata/convergent_evolution/results/267_AF2'
#InFileName = '/rhome/jmarz001/bigdata/convergent_evolution/results/2L_AF2'
#InFileName = '/rhome/jmarz001/bigdata/convergent_evolution/results/7L_AF2'

#open input file
InFile = open(InFileName, 'r')
#Loop through each line in file
for Line in InFile:
    Line = Line.strip('\n') # Split the file into lines
    ElementList = Line.split('\t') # Split the lines into elements
    #print "ElementList:", ElementList #uncomment for debugging
    # ElementList: ['chr1H_1_279267716 799', '13', '13']
    CHROM = ElementList[0]
    FREQ = float(ElementList[1])/float(ElementList[2])
    FREQ = str(FREQ)
    OutputString = "%s\t %s" % \
(CHROM, FREQ)
    print OutputString+"\n"
InFile.close()
