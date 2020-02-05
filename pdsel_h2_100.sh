#!/bin/bash
SEL_COEFF=$1
DIFF_MEANS=0.2
NUM_ITERS=100
SAMP_SIZE=20000

for x in $(eval echo "{0..$((NUM_ITERS-1))}")
do
		python /global/scratch/crauchman/scripts/make_assoc_csv.py sel_${SEL_COEFF}_dm_${DIFF_MEANS}.i_${x}.assoc.linear
		python /global/scratch/crauchman/scripts/filter_by_freqs_sel.py sel_${SEL_COEFF}_dm_${DIFF_MEANS}.i_${x}.assoc.linear.csv sel_${SEL_COEFF}.i_${x}.freqs
        python /global/scratch/crauchman/scripts/reformat_plink_assoc_MUNGE.py sel_${SEL_COEFF}_dm_${DIFF_MEANS}.i_${x}.assoc.linear.csv.filt $SAMP_SIZE
        gunzip sel_${SEL_COEFF}.i_${x}.l2.ldscore.gz
done

#run from msprime_data
bash /global/scratch/crauchman/scripts/pdsel_change_rs_FILT.sh $SEL_COEFF $DIFF_MEANS

source /global/home/users/crauchman/anaconda3/bin/activate /global/home/users/crauchman/anaconda3/envs/ldsc

cp sel_${SEL_COEFF}_dm_${DIFF_MEANS}_toappend.i_1.assoc.linear.csv.filt.sumstats sel_${SEL_COEFF}_dm_${DIFF_MEANS}_appended.sumstats
cp sel_${SEL_COEFF}_toappend.i_1.l2.ldscore sel_${SEL_COEFF}_dm_${DIFF_MEANS}_appended.l2.ldscore

for x in $(eval echo "{1..$((NUM_ITERS-1))}")
do
	tail sel_${SEL_COEFF}.i_${x}.l2.M_5_50 >> sel_${SEL_COEFF}_dm_${DIFF_MEANS}_toappend.l2.M_5_50
	tail /global/scratch/crauchman/scripts/tab.txt >> sel_${SEL_COEFF}_dm_${DIFF_MEANS}_toappend.l2.M_5_50
	tail sel_${SEL_COEFF}.i_${x}.l2.M >> sel_${SEL_COEFF}_dm_${DIFF_MEANS}_toappend.l2.M
	tail /global/scratch/crauchman/scripts/tab.txt >> sel_${SEL_COEFF}_dm_${DIFF_MEANS}_toappend.l2.M
	tail -n +2 -q sel_${SEL_COEFF}_dm_${DIFF_MEANS}_toappend.i_${x}.assoc.linear.csv.filt.sumstats >> sel_${SEL_COEFF}_dm_${DIFF_MEANS}_appended.sumstats
	tail -n +2 -q sel_${SEL_COEFF}_toappend.i_${x}.l2.ldscore >> sel_${SEL_COEFF}_dm_${DIFF_MEANS}_appended.l2.ldscore
done

python /global/scratch/crauchman/scripts/add_m_vals.py sel_${SEL_COEFF}_dm_${DIFF_MEANS}_toappend.l2.M_5_50 sel_${SEL_COEFF}_dm_${DIFF_MEANS}_appended.l2.M_5_50
python /global/scratch/crauchman/scripts/add_m_vals.py sel_${SEL_COEFF}_dm_${DIFF_MEANS}_toappend.l2.M sel_${SEL_COEFF}_dm_${DIFF_MEANS}_appended.l2.M
python /global/home/users/crauchman/ldsc/ldsc.py --h2 sel_${SEL_COEFF}_dm_${DIFF_MEANS}_appended.sumstats --ref-ld sel_${SEL_COEFF}_dm_${DIFF_MEANS}_appended --w-ld sel_${SEL_COEFF}_dm_${DIFF_MEANS}_appended --out sel_${SEL_COEFF}_dm_${DIFF_MEANS}_h2
gzip sel_${SEL_COEFF}_dm_${DIFF_MEANS}_appended.l2.ldscore
gzip sel_${SEL_COEFF}.*.l2.ldscore
python /global/scratch/crauchman/scripts/output_h2_file_FILT.py sel_${SEL_COEFF}_dm_${DIFF_MEANS}_h2.log sel_${SEL_COEFF}_dm_${DIFF_MEANS}.h2





