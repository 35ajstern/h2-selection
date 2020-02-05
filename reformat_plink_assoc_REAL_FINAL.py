import numpy as np
import sys

assoc = sys.argv[1]
outFile = assoc + '.ldsc'

out = open(outFile,'w')
out.write('SNPID\tCHR\tbp\ta1\ta2\tbeta\tINFO\tP\n')
outSNPList = outFile+'.snplist'
outSNP = open(outSNPList,'w')
outSNP.write('SNP\tA1\tA2\n')
i = 0
for line in open(assoc,'r'):
	if i == 0:
		i += 1
		continue
	i += 1
	cols = line.split() 
	a1 = cols[3]
	if a1 == 'A': 
		a2 = 'T'
	else:
		a2 = 'A'
	newcols = [cols[1],cols[0],cols[2],a1,a2,cols[6],'0.999',cols[8]]
	newline = '\t'.join(newcols)+'\n'
	out.write(newline)
	outSNP.write('\t'.join([newcols[0],a1,a2])+'\n')
