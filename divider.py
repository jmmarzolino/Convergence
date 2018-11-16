#!/usr/bin/env python

import itertools
#itertools.islice(iterable, stop)
#itertools.islice(iterable, start, stop[, step])

# take a fastq file and a file with barcode info and separates the fastq reads into barcode named and sorted files

File=open("fastq.txt", 'r')

search file for "@" in File and capture that line + 3 following lines
string1="@"
for Line in File:								# search for strings
	if string1 in Line:
    Lines=islice(File, 3)
    TmpFile=open("tmp.txt", 'w')
		TmpFile.write(Line, Lines)
    
    Bar=open("bar.txt", 'r')
    
    for Line in Bar
      Line=Line.strip('\n')
      ElementList=Line.split('\t')
      
      if ('^ %s' % Line) in TmpFile   # does this need a /^ or is '^' ok on its own?
        OutFileName='%s' % Line
        OutFile=open("%s.txt" % Line, 'w')
        print "FileLine"

File.close()
OutFile.close()

# itertools.islice(iterable, stop)
# itertools.islice(iterable, start, stop[, step])	

## 'Hello {0}'.format(name)
## 'Hello %s' % name
