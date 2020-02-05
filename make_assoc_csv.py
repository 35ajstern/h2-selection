import sys
import pandas as pd
import numpy as np

assoc = sys.argv[1]
outFile = assoc + '.csv'

out = open(outFile,'w')
for line in open(assoc,'r'):
        cols = line.split()
        newline = '\t'.join(cols)+'\n'
        out.write(newline)
out.close() 