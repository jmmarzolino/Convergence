#!/usr/bin/env python
#SBATCH -p short
#SBATCH --ntasks=1
#SBATCH --mem=15G
#SBATCH --time=02:00:00
#SBATCH --job-name='site_freq'
#SBATCH --output=site_freq_spectrum.stdout

import numpy
PopList = ['10', '16', '1L', '24', '250', '255', '257', '258', '262', '267', '2L', '7L']
bins = [0.0, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1.1]
lines = 65381964
for Pop in PopList:
    InFileName = '/rhome/jmarz001/bigdata/convergent_evolution/results/'+ 'site_frq_' + Pop
    InFile = open(InFileName, 'r')
    OutFileName = '/rhome/jmarz001/bigdata/convergent_evolution/results/' + Pop + '_bins'
    OutFile = open(OutFileName, 'w+')
    a = 0
    b = 0
    c = 0
    d = 0
    e = 0
    f = 0
    g = 0
    h = 0
    i = 0
    j = 0
    k = 0
    l = 0
    m = 0
    n = 0
    o = 0
    p = 0
    q = 0
    r = 0
    s = 0
    t = 0
    u = 0
    zero = 0
    unknown = 0
    for Line in InFile:
        # take in the frequency, put it in a bin
        LineList = Line.strip('\n')
        #print "LineList:", LineList #uncomment for debugging
        if Line == "na":
            u = u + 1
        elif Line == bins[0]:
            zero = zero + 1
        elif Line > bins[0] and Line < bins[1]:
            a = a + 1
        elif Line > bins[1] and Line < bins[2]:
            b = b + 1
        elif Line > bins[2] and Line < bins[3]:
            c = c + 1
        elif Line > bins[3] and Line < bins[4]:
            d = d + 1
        elif Line > bins[4] and Line < bins[5]:
            e = e + 1
        elif Line > bins[5] and Line < bins[6]:
            f = f + 1
        elif Line > bins[6] and Line < bins[7]:
            g = g + 1
        elif Line > bins[7] and Line < bins[8]:
            h = h + 1
        elif Line > bins[8] and Line < bins[9]:
            i = i + 1
        elif Line > bins[9] and Line < bins[10]:
            j = j + 1
        elif Line > bins[10] and Line < bins[11]:
            k = k + 1
        elif Line > bins[11] and Line < bins[12]:
            l = l + 1
        elif Line > bins[12] and Line < bins[13]:
            m = m + 1
        elif Line > bins[13] and Line < bins[14]:
            n = n + 1
        elif Line > bins[14] and Line < bins[15]:
            o = o + 1
        elif Line > bins[15] and Line < bins[16]:
            p = p + 1
        elif Line > bins[16] and Line < bins[17]:
            q = q + 1
        elif Line > bins[17] and Line < bins[18]:
            r = r + 1
        elif Line > bins[18] and Line < bins[19]:
            s = s + 1
        elif Line > bins[19] and Line < bins[20]:
            t = t + 1
        else:
            unknown = unknown + 1
    # when the bins are done, divide by lines
    hist = [a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, zero]
    proportional = [unknown]
    for i in hist:
        i = float(i/lines)
        proportional.extend(i)
    proportional = string(proportional)
    hist = string(hist)
    OutputString = "%s\t %s" % (hist, proportional)
    OutFile.write(OutputString+"\n")
    InFile.close()
    OutFile.close()
