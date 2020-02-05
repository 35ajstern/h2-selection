#!/bin/bash
MIG_RATE=$1
DIV_TIME=$2
DIFF_MEANS=0.2
NUM_ITERS=100
SAMP_SIZE=20000

for x in $(eval echo "{0..$((NUM_ITERS-1))}")
do
		python /global/scratch/crauchman/scripts/make_assoc_csv.py mig_${MIG_RATE}_div_${DIV_TIME}_dm_${DIFF_MEANS}.i_${x}.assoc.linear
		python /global/scratch/crauchman/scripts/filter_by_freqs_struc.py mig_${MIG_RATE}_div_${DIV_TIME}_dm_${DIFF_MEANS}.i_${x}.assoc.linear.csv mig_${MIG_RATE}_div_${DIV_TIME}.i_${x}.freqs
        python /global/scratch/crauchman/scripts/reformat_plink_assoc_MUNGE.py mig_${MIG_RATE}_div_${DIV_TIME}_dm_${DIFF_MEANS}.i_${x}.assoc.linear.csv.filt $SAMP_SIZE
        gunzip mig_${MIG_RATE}_div_${DIV_TIME}.i_${x}.l2.ldscore.gz
done


#run from msprime_data

bash /global/scratch/crauchman/scripts/mig_div_change_rs_FILT.sh $MIG_RATE $DIV_TIME $DIFF_MEANS

source /global/home/users/crauchman/anaconda3/bin/activate /global/home/users/crauchman/anaconda3/envs/ldsc

cp mig_${MIG_RATE}_div_${DIV_TIME}_dm_${DIFF_MEANS}_toappend.i_1.assoc.linear.csv.filt.sumstats mig_${MIG_RATE}_div_${DIV_TIME}_dm_${DIFF_MEANS}_appended.sumstats
cp mig_${MIG_RATE}_div_${DIV_TIME}_toappend.i_1.l2.ldscore mig_${MIG_RATE}_div_${DIV_TIME}_dm_${DIFF_MEANS}_appended.l2.ldscore

for x in $(eval echo "{1..$((NUM_ITERS-1))}")
do
	tail mig_${MIG_RATE}_div_${DIV_TIME}.i_${x}.l2.M_5_50 >> mig_${MIG_RATE}_div_${DIV_TIME}_dm_${DIFF_MEANS}_toappend.l2.M_5_50
	tail /global/scratch/crauchman/scripts/tab.txt >> mig_${MIG_RATE}_div_${DIV_TIME}_dm_${DIFF_MEANS}_toappend.l2.M_5_50
	tail mig_${MIG_RATE}_div_${DIV_TIME}.i_${x}.l2.M >> mig_${MIG_RATE}_div_${DIV_TIME}_dm_${DIFF_MEANS}_toappend.l2.M
	tail /global/scratch/crauchman/scripts/tab.txt >> mig_${MIG_RATE}_div_${DIV_TIME}_dm_${DIFF_MEANS}_toappend.l2.M
	tail -n +2 -q mig_${MIG_RATE}_div_${DIV_TIME}_dm_${DIFF_MEANS}_toappend.i_${x}.assoc.linear.csv.filt.sumstats >> mig_${MIG_RATE}_div_${DIV_TIME}_dm_${DIFF_MEANS}_appended.sumstats
	tail -n +2 -q mig_${MIG_RATE}_div_${DIV_TIME}_toappend.i_${x}.l2.ldscore >> mig_${MIG_RATE}_div_${DIV_TIME}_dm_${DIFF_MEANS}_appended.l2.ldscore
done

python /global/scratch/crauchman/scripts/add_m_vals.py mig_${MIG_RATE}_div_${DIV_TIME}_dm_${DIFF_MEANS}_toappend.l2.M_5_50 mig_${MIG_RATE}_div_${DIV_TIME}_dm_${DIFF_MEANS}_appended.l2.M_5_50
python /global/scratch/crauchman/scripts/add_m_vals.py mig_${MIG_RATE}_div_${DIV_TIME}_dm_${DIFF_MEANS}_toappend.l2.M mig_${MIG_RATE}_div_${DIV_TIME}_dm_${DIFF_MEANS}_appended.l2.M
python /global/home/users/crauchman/ldsc/ldsc.py --h2 mig_${MIG_RATE}_div_${DIV_TIME}_dm_${DIFF_MEANS}_appended.sumstats --ref-ld mig_${MIG_RATE}_div_${DIV_TIME}_dm_${DIFF_MEANS}_appended --w-ld mig_${MIG_RATE}_div_${DIV_TIME}_dm_${DIFF_MEANS}_appended --out mig_${MIG_RATE}_div_${DIV_TIME}_dm_${DIFF_MEANS}_h2
gzip mig_${MIG_RATE}_div_${DIV_TIME}_dm_${DIFF_MEANS}_appended.l2.ldscore
gzip mig_${MIG_RATE}_div_${DIV_TIME}.*.l2.ldscore
python /global/scratch/crauchman/scripts/output_h2_file_FILT.py mig_${MIG_RATE}_div_${DIV_TIME}_dm_${DIFF_MEANS}_h2.log mig_${MIG_RATE}_div_${DIV_TIME}_dm_${DIFF_MEANS}.h2




