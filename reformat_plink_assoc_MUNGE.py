import numpy as np
import sys

assoc = sys.argv[1]
sampsize = sys.argv[2]



#####I just added these lines

#alleleFreqFile = sys.argv[3]
##for line in open(alleleFreqFile,'r'):
##	columns = line.rstrip().split('\t')
##	SNPs = columns[2]

outFile = assoc + '.sumstats'

out = open(outFile,'w')
out.write('SNP	A1	A2	Z	N\n')
#out.write('snpid chr bp a1 a2 beta INFO P\n')
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
	newcols = [cols[2],a1,a2,cols[6], sampsize]
	#newcols = [cols[1],cols[0],cols[2],a1,a2,cols[7],'0.500',cols[8]]
	newline = '\t'.join(newcols)+'\n'
	out.write(newline)
	outSNP.write('\t'.join([newcols[0],a1,a2])+'\n')
