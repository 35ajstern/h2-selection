#!/bin/bash
NUM_ITERS=$1
MIG_RATE=$2
DIV_TIME=$3
DIPLOID_SSS=10000

#module load python
#module load gsl

source /global/home/users/crauchman/anaconda3/bin/activate /global/home/users/crauchman/anaconda3/envs/msprime-env
python /global/scratch/crauchman/scripts/mig_div_msprime_sims.py $NUM_ITERS $MIG_RATE $DIV_TIME $DIPLOID_SSS

for x in $(eval echo "{0..$((NUM_ITERS-1))}")
do
        python /global/scratch/crauchman/scripts/msprime_vcf_fix.py /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}_pre.i_${x}.vcf /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}.i_${x}.vcf
        python /global/scratch/crauchman/scripts/add_random_accession.py /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}.i_${x}.vcf
        mv /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}.i_${x}.rs.vcf /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}.i_${x}.vcf
        /global/home/users/crauchman/plink --vcf /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}.i_${x}.vcf --out /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}.i_${x}
        /global/home/users/crauchman/plink --bfile /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}.i_${x} --pheno /global/scratch/crauchman/msprime_data/case_control.pheno --fst case-control --allow-no-sex --out /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}_fst.i_${x}
done

source /global/home/users/crauchman/anaconda3/bin/activate /global/home/users/crauchman/anaconda3/envs/ldsc

for x in $(eval echo "{0..$((NUM_ITERS-1))}")
do
        python /global/home/users/crauchman/ldsc/ldsc.py --l2 --bfile /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}.i_${x} --ld-wind-kb 1000 --maf 0.05 --out /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}.i_${x} --yes-really
done


python /global/scratch/crauchman/scripts/pheno_sim.py $DIPLOID_SSS $DIPLOID_SSS 0.2 /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}_dm_0.2 > /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}_dm_0.2.pheno

for x in $(eval echo "{0..$((NUM_ITERS-1))}")
do
        /global/home/users/crauchman/plink --bfile /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}.i_${x} --pheno /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}_dm_0.2.pheno --linear --allow-no-sex --out /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}_dm_0.2.i_${x}
        python /global/scratch/crauchman/scripts/reformat_plink_assoc_REAL_FINAL.py /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}_dm_0.2.i_${x}.assoc.linear 1000
done

python /global/scratch/crauchman/scripts/pheno_sim.py $DIPLOID_SSS $DIPLOID_SSS 0.5 /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}_dm_0.5 > /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}_dm_0.5.pheno

for x in $(eval echo "{0..$((NUM_ITERS-1))}")
do
        /global/home/users/crauchman/plink --bfile /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}.i_${x} --pheno /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}_dm_0.5.pheno --linear --allow-no-sex --out /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}_dm_0.5.i_${x}
        python /global/scratch/crauchman/scripts/reformat_plink_assoc_REAL_FINAL.py /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}_dm_0.5.i_${x}.assoc.linear 1000
done


python /global/scratch/crauchman/scripts/pheno_sim.py $DIPLOID_SSS $DIPLOID_SSS 1 /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}_dm_1 > /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}_dm_1.pheno

for x in $(eval echo "{0..$((NUM_ITERS-1))}")
do
        /global/home/users/crauchman/plink --bfile /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}.i_${x} --pheno /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}_dm_1.pheno --linear --allow-no-sex --out /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}_dm_1.i_${x}
        python /global/scratch/crauchman/scripts/reformat_plink_assoc_REAL_FINAL.py /global/scratch/crauchman/msprime_data/mig_${MIG_RATE}_div_${DIV_TIME}_dm_1.i_${x}.assoc.linear 1000
done
