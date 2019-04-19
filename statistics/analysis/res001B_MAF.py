#!/usr/bin/env python
#SBATCH -p short
#SBATCH --ntasks=1
#SBATCH --mem=30G
#SBATCH --time=00:20:00
#SBATCH --output=res001B_MAF.stdout
#SBATCH --job-name='res001B'

ABANDONED

#set input file name
InFileName = '/rhome/jmarz001/bigdata/convergent_evolution/results/conevo_AF'
#open input file
InFile = open(InFileName, 'r')
#Loop through each line in file
for Line in InFile:
    Line = Line.strip('\n') # Split the file into lines
    ElementList = Line.split('\t') # Split the lines into elements
    AlleleList = Element.split(',') # Split the elements by ',' character to split AD entries
    print "ElementList:", ElementList #uncomment for debugging
    #CHROM = ElementList[0]
    #POS = ElementList[1]


    #Retained = float(Altref[0])/float(ElementList[3])

    #Retained = int(Retained * 100)

    #Retained = str(Retained)

    #OutputString = "%s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s" % \
    #(CHROM, POS, AF1, AF2, AF3, AF4, AF5, AF6, AF7, AF8, AF9, AF10, AF11, AF12) # CHROM and POS first two col
    #print OutputString+"\n"
InFile.close()

chr1H_1_279267716       [0]
 799
 13,0
 13
 13,2
 15
 0,0
 0
 6,0
 6
 6,2
 8
 8,0
 8
3,0
3
7,0
7
22,0
22
6,0
6
0,0
0
0,0
0

take pairs of columns, calculate AF for the population, print it out as a column and move onto the next
printing a header column to make all this clear is desirable
then loop this over all lines and write out
