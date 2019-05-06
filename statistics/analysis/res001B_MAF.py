#!/usr/bin/env python
#SBATCH -p short
#SBATCH --ntasks=1
#SBATCH --mem=15G
#SBATCH --time=00:15:00
#SBATCH --job-name='res001B'
#SBATCH --output=res001B.stdout

i = 0
PopList = ['10_AF2', '16_AF2', '1L_AF2', '24_AF2', '250_AF2', '255_AF2', '257_AF2', '258_AF2', '262_AF2', '267_AF2', '2L_AF2', '7L_AF2']
for Pop in PopList:
    InFileName = '/rhome/jmarz001/bigdata/convergent_evolution/results/'+ Pop
    InFile = open(InFileName, 'r')
    OutFileName = '/rhome/jmarz001/bigdata/convergent_evolution/results/' + Pop + '.stdout'
    OutFile = open(OutFileName, 'w+')
    i = i + 1
#Loop through each line in file
    for Line in InFile:
        Line = Line.strip('\n') # Split the file into lines
        ElementList = Line.split('\t') # Split the lines into elements
        #print "ElementList:", ElementList #uncomment for debugging
        # ElementList: ['chr1H_1_279267716 799', '13', '13']
        if ElementList[2] == "0":
            CHROM = ElementList[0]
            FREQ = "na"
            OutputString = "%s\t %s" % (CHROM, FREQ)
            OutFile.write(OutputString+"\n")
        elif ElementList[2] == ".":
            CHROM = ElementList[0]
            FREQ = "na"
            OutputString = "%s\t %s" % (CHROM, FREQ)
            OutFile.write(OutputString+"\n")
        else :
            #print "ElementList:", ElementList[2]
            ElementList[1] = float(ElementList[1])
            ElementList[2] = float(ElementList[2])
            CHROM = ElementList[0]
            FREQ = float(ElementList[1])/float(ElementList[2])
            FREQ = str(FREQ)
            OutputString = "%s\t %s" % (CHROM, FREQ)
            OutFile.write(OutputString+"\n")
    InFile.close()
    OutFile.close()

# the data is now formatted and files small enough to make the site freq spectrum graph!
