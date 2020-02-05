import sys
import numpy as np
import pandas as pd

infile = sys.argv[1]
outfile = sys.argv[2]
f = open(infile,"r")
out = open(outfile,'w+')
M_sum = 0
for line in f:
	line_nums = line.split('\t')
	for i in line_nums:
		try:
			M_sum += int(i)
		except:
			print(i)
out.write(str(M_sum))
f.close()
out.close()