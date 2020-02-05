#!/bin/bash
NUM_ITERS=$1
MIG_RATE=$2
SEL_COEFF=$3
DIPLOID_SSS=10000 

#module load python
#module load gsl
for x in $(eval echo "{0..$((NUM_ITERS-1))}")
do
        /global/home/users/crauchman/slim_build/slim -d sel_coeff=$SEL_COEFF -d mig_rate=$MIG_RATE -d sim_count=$x /global/scratch/crauchman/scripts/positive_directional_selection.slim
done

for x in $(eval echo "{0..$((NUM_ITERS-1))}")
do
        python /global/scratch/crauchman/scripts/add_random_accession.py /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}.i_${x}.vcf
        mv /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}.i_${x}.rs.vcf /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}.i_${x}.vcf
        /global/home/users/crauchman/plink --vcf /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}.i_${x}.vcf --out /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}.i_${x}
        /global/home/users/crauchman/plink --bfile /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}.i_${x} --pheno /global/scratch/crauchman/msprime_data/case_control.pheno --fst case-control --allow-no-sex --out /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}_fst.i_${x}
        /global/home/users/crauchman/plink --bfile /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}.i_${x} --pca 10 --out /global/scratch/crauchman//msprime_data/sel_${SEL_COEFF}.i_${x}
        python /global/scratch/crauchman/scripts/allele_freq.py /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}.i_${x}.vcf  > /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}.i_${x}.freqs
done

source /global/home/users/crauchman/anaconda3/bin/activate /global/home/users/crauchman/anaconda3/envs/ldsc

for x in $(eval echo "{0..$((NUM_ITERS-1))}")
do
        python /global/home/users/crauchman/ldsc/ldsc.py --l2 --bfile /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}.i_${x} --ld-wind-kb 1000 --out /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}.i_${x} --yes-really
done

python /global/scratch/crauchman/scripts/pheno_sim.py $DIPLOID_SSS $DIPLOID_SSS 0.2 /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}_dm_0.2 > /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}_dm_0.2.pheno
python /global/scratch/crauchman/scripts/pheno_sim.py $DIPLOID_SSS $DIPLOID_SSS 0.5 /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}_dm_0.5 > /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}_dm_0.5.pheno
python /global/scratch/crauchman/scripts/pheno_sim.py $DIPLOID_SSS $DIPLOID_SSS 1 /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}_dm_1 > /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}_dm_1.pheno

for x in $(eval echo "{0..$((NUM_ITERS-1))}")
do
        /global/home/users/crauchman/plink --bfile /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}.i_${x} --pheno /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}_dm_0.2.pheno --covar /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}.i_${x}.eigenvec --hide-covar --linear --allow-no-sex --out /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}_dm_0.2.i_${x}
        python /global/scratch/crauchman/scripts/reformat_plink_assoc_REAL_FINAL.py /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}_dm_0.2.i_${x}.assoc.linear 1000
        /global/home/users/crauchman/plink --bfile /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}.i_${x} --pheno /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}_dm_0.5.pheno --covar /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}.i_${x}.eigenvec --hide-covar --linear --allow-no-sex --out /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}_dm_0.5.i_${x}
        python /global/scratch/crauchman/scripts/reformat_plink_assoc_REAL_FINAL.py /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}_dm_0.5.i_${x}.assoc.linear 1000
        /global/home/users/crauchman/plink --bfile /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}.i_${x} --pheno /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}_dm_1.pheno --covar /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}.i_${x}.eigenvec --hide-covar  --linear --allow-no-sex --out /global/scratch/crauchman/msprime_data/sel_${SEL_COEFF}_dm_1.i_${x}
done

