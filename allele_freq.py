import numpy as np
import sys

vcfFile = sys.argv[1]

for line in open(vcfFile,'r'):
	if line[0] == '#':
		continue
	columns = line.rstrip().split('\t')
	genotypes = columns[9:]
	alleles = []
	for geno in genotypes:
		x = geno.split('|')
		alleles += [float(x[0]),float(x[1])]
	freq = np.sum(alleles)/len(alleles)
	posn = columns[1]
	rsid = columns[2]
	print('\t'.join([str(x) for x in [posn,rsid,freq]]))
