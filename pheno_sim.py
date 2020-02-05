import sys
import numpy as np

# python pheno_sim.py n1 n2 d out

n1 = int(sys.argv[1])
n2 = int(sys.argv[2])
d = float(sys.argv[3])

y1 = np.random.normal(0,1,size=n1)
y2 = np.random.normal(d,1,size=n2)

y = np.concatenate((y1,y2))

#np.savetxt('%s.pheno'%(out),y)
for i in range(n1+n2):
	print('i%d\ti%d\t%f'%(i,i,y[i]))
