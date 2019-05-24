#!/usr/bin/env python
#SBATCH -p short
#SBATCH --ntasks=1
#SBATCH --mem=15G
#SBATCH --time=00:15:00
#SBATCH --job-name='res001B'
#SBATCH --output=res001B.stdout

InFileName = '/rhome/jmarz001/bigdata/convergent_evolution/results/position_populations'
InFile = open(InFileName, 'r')
OutFileName = '/rhome/jmarz001/bigdata/convergent_evolution/results/VariantBins'
OutFile = open(OutFileName, 'w+')

#Loop through each line in file
for Line in InFile:
    Line = Line.strip('\n') # Split the file into lines
    ElementList = Line.split('\t') # Split the lines into elements
    #print "ElementList:", ElementList #uncomment for debugging
    if ElementList[13] == 1:
        pass
    else:
        OutputString = "%s\n" % (Line)
        OutFile.write(OutputString)
InFile.close()
OutFile.close()
