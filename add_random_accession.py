import sys

vcfFile = sys.argv[1]
outFile = '.'.join(vcfFile.split('.')[:-1])+'.rs.vcf'
out = open(outFile,'w')
i = 10**6 
for line in open(vcfFile,'r'):
	if line[0] == '#': 
		out.write(line)
		continue
	i += 1
	cols = line.split('\t')
	cols[2] = 'rs%d'%(i)
	line = '\t'.join(cols)
	out.write(line)	
