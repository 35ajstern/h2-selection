import numpy as np
import sys
import pandas as pd

assoc_file = sys.argv[1]
freqs_file = sys.argv[2]
outFile = assoc_file + '.filt'

outFile = assoc_file + '.filt'

assoc = pd.read_csv(assoc_file, sep='\t', index_col='BP')
freqs = pd.read_csv(freqs_file, sep='\t', header=None, index_col=0)
freqs = freqs.rename(index=int, columns={1:'freq'})
df = freqs.join(assoc)
df = df[np.isfinite(df.P)]
df = df[np.isfinite(df.freq)]
freq = df['freq']
mask = (freq > 0.01) & (freq < 0.99)
df_filt = df[mask]
df_filt.index.name = 'BP'
df_filt = df_filt[['CHR', 'SNP', 'A1', 'TEST', 'BETA', 'STAT', 'P']]
df_filt.to_csv(outFile, sep='\t')