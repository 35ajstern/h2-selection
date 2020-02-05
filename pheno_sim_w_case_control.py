import sys
import numpy as np

# python pheno_sim.py n1 n2 d out

n1 = int(sys.argv[1])
n2 = int(sys.argv[2])

c1 = np.array([1] * n1)
c2 = np.array([2] * n2)
c = np.array([])
c = np.append(c, c1)
c = np.append(c, c2)

#np.savetxt('%s.pheno'%(out),y)
for i in range(n1+n2):
	print('i%d\ti%d\t%s'%(i,i, np.int(c[i])))
