#!/bin/bash

source /etc/biac_sge.sh
EXPERIMENT=`findexp NetTMS.01`
EXPERIMENT=${EXPERIMENT:?"Returned NULL Experiment"}

if [ $EXPERIMENT = "ERROR" ]
then
        exit 32
else   

#Timestamp
echo "----JOB [$JOB_NAME.$JOB_ID] START [`date`] on HOST [$HOSTNAME]----" 

# -- END PRE-USER --
# **********************************************************

# -- BEGIN USER DIRECTIVE --
# Send notifications to the following address
#$ -M matthew.slayton@duke.edu

# -- END USER DIRECTIVE --

# -- BEGIN USER SCRIPT --
# User script goes here

#SUBNUM="5014";
#DAY="1"
#RETTYPE="CMEM"
#RUN="1"

#SUBNUM=$1
#DAY=$2
#RETYPE=$3
#RUN=$4

cd /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/

subj=$1
day=$2
retType=$3
run=$4

#subj="5007"
#day="1"
#retType="CMEM"
#run="2"

#echo ${subj}
#echo ${day}
#echo ${retType}
#echo ${run}


#OUTPUT=/mnt/munin2/Simon/NetTMS.01/Analysis/TMS_Localizers/${SUBNUM}/lvl1_${SUBNUM}_Day${DAY}_ENC_${RETTYPE}_Run${RUN}
OUTPUT=/mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/${subj}/level1_design/lvl1_${subj}_Day${day}_ENC_${retType}_Run${run}

#echo $OUTPUT
#mkdir -p ${OUTPUT}
# change Volumes to mnt and Data to munin2 when you copy the path from Finder

#designTemplate=/mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/${subj}/level1_design/lvl1_${subj}_Day${day}_ENC_${retType}_Run${run}/design.fsf
#designTemplate=/mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/lv1l_design.fsf

#cp ${designTemplate} ${OUTPUT}

#echo ${OUTPUT}/design.fsf

echo "Begin Subj${subj} Day${day} ${retType} Run${run}"

feat ${OUTPUT}/design.fsf

#rm $Trial/design.feat/filtered_func_data.nii.gz
#rm $Trial/design.feat/stats/res4d.nii.gz

#rm $Trial/design.feat/stats/pe*.nii.gz
#rm $Trial/design.feat/stats/threshac1.nii.gz

OUTDIR=/mnt/munin2/Simon/${EXPERIMENT}/Analysis/Univariate/Logs
mkdir -p $OUTDIR

# from jim's script, john graner py script
python /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/makeFakeRegForHigherLevelFeat.py OUTPUT=/mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/${subj}/level1_design/lvl1_${subj}_Day${day}_ENC_${retType}_Run${run}.feat
rm -f OUTPUT=/mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/${subj}/level1_design/lvl1_${subj}_Day${day}_ENC_${retType}_Run${run}.feat/filtered_func_data.nii.gz

# -- END USER SCRIPT -- #

# **********************************************************
# -- BEGIN POST-USER --
echo "----JOB [$JOB_NAME.$JOB_ID] STOP [`date`]----"
#OUTDIR=${OUTDIR:-$EXPERIMENT/Scripts/cluster/feat_single_trials_fir/output_3x4/S2_indi_trials}
#OUTDIR=${OUTDIR:-$EXPERIMENT/Analysis/SingleTrials_FSL/5007/feat_output}
#mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
fi
# -- END POST USER--
