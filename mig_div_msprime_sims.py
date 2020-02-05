import math
import numpy as np
import sys
sys.path.append('/global/home/users/crauchman/anaconda3/lib/python3.7/site-packages') 

import msprime
import tskit

num_iters = int(sys.argv[1])
mig_rate = float(sys.argv[2])
div_time = int(sys.argv[3])

n = 10**4
N1 = 2*10**4
N2 = 2*10**4
tDiv = div_time
mig = mig_rate 

population_configurations = [
        msprime.PopulationConfiguration(
            sample_size=n, initial_size=N1),
        msprime.PopulationConfiguration(
            sample_size=n, initial_size=N2)
    ]
migration_matrix = [
        [      0, mig],
        [mig,       0],
    ]
demographic_events = [
        msprime.MassMigration(
            time=tDiv, source=1, destination=0, proportion=1.0),
        msprime.MigrationRateChange(time=tDiv, rate=0)
    ]

tree_sequence = msprime.simulate(length=1e6, mutation_rate=1e-8, recombination_rate=1e-8,
	demographic_events=demographic_events,migration_matrix=migration_matrix, population_configurations=population_configurations,
	num_replicates = num_iters)

tree_list = [tree for tree in tree_sequence]
print(tree_list[0], tree_list[1])
prevPosn = -1
for x in np.arange(num_iters):
    t = tree_list[x]
    freqs_file = open("/global/scratch/crauchman/msprime_data/mig_%s_div_%s.i_%s.freqs"%(np.str(mig_rate), np.str(tDiv), x), "w")
    for variant in t.variants():
        site = variant.site
        currPosn = round(site.position)
        if currPosn != prevPosn:
            f = np.str(np.sum(variant.genotypes/(2*n)))
            freqs_file.write('%d\t%s\n'%(currPosn,f))
            prevPosn = currPosn
    freqs_file.close()
    

i = 0
for file in tree_list:
	with open("/global/scratch/crauchman/msprime_data/mig_%s_div_%s_pre.i_%s.vcf"%(np.str(mig_rate), np.str(tDiv), i), "w") as vcf_file:
		file.write_vcf(vcf_file, 2)
	i += 1














