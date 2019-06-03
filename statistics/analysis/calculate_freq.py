#!/usr/bin/env python
#SBATCH -p koeniglab
#SBATCH --ntasks=1
#SBATCH --mem=20G
#SBATCH --time=01:00:00
#SBATCH --job-name='calc_frq'
#SBATCH --output=calculate_freq.stdout

PopList = ['10', '16', '1', '24', '250', '255', '257', '258', '262', '267', '2', '7']
for Pop in PopList:
    InFileName = '/rhome/jmarz001/bigdata/convergent_evolution/results/' + Pop
    InFile = open(InFileName, 'r')
    OutFileName = '/rhome/jmarz001/bigdata/convergent_evolution/results/' + Pop + '_freq'
    OutFile = open(OutFileName, 'w+')
    #Loop through each line in file
    for Line in InFile:
        Line = Line.strip('\n') # Split the file into lines
        ElementList = Line.split('\t') # Split the lines into elements
        #print "ElementList:", ElementList #uncomment for debugging
        SITE = ElementList[0]
        REF = float(ElementList[1])
        ALT = float(ElementList[2])
        DEPTH = ALT + REF
        if DEPTH == 0:
            OutputString = "%s\t%s\n" % (SITE, "NA")
            OutFile.write(OutputString)
        else:
            FREQUENCY = float(ALT/DEPTH)
            OutputString = "%s\t%s\n" % (SITE, FREQUENCY)
            OutFile.write(OutputString)
    InFile.close()
    OutFile.close()
