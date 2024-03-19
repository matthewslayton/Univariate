#!/bin/bash
# second level FEAT gives you cope.feat and stats
# you need zstat.nii.gz (activation in MNI space) - rename subj_day_xmem_sr/sf
# linear transformation between subject space and MNI space (atlas vs our data)

source /etc/biac_sge.sh
EXPERIMENT=`findexp NetTMS.01`
EXPERIMENT=${EXPERIMENT:?"Returned NULL Experiment"}

#for subj in 5021 5022 5025; do echo $subj;
for subj in 5001; do echo $subj;
	#for day in 1 2 3 4; do echo $day;
	for day in 1; do echo $day;
		for retType in CMEM PMEM; do echo $retType;

			flirt -in /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/MNI152_T1_2mm_brain.nii.gz -ref /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/${subj}/${subj}_T1_brain.nii.gz -out /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/${subj}/MNI_in_subject_space_brain -omat /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/${subj}/subject_space.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
			flirt -in /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/${subj}/Activation/${subj}_Day${day}_${retType}_SRSF_MNI.nii -ref /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/${subj}/${subj}_T1_brain.nii.gz -out /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/${subj}/subject_space_shadowreg_${subj}_Day${day}_${retType}_SRSF -applyxfm -init /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/${subj}/subject_space.mat -interp trilinear
			flirt -in /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/${subj}/Activation/${subj}_Day${day}_${retType}_SR_MNI.nii -ref /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/${subj}/${subj}_T1_brain.nii.gz -out /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/${subj}/subject_space_shadowreg_${subj}_Day${day}_${retType}_SR -applyxfm -init /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/${subj}/subject_space.mat -interp trilinear
			flirt -in /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/${subj}/Activation/${subj}_Day${day}_${retType}_SF_MNI.nii -ref /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/${subj}/${subj}_T1_brain.nii.gz -out /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/${subj}/subject_space_shadowreg_${subj}_Day${day}_${retType}_SF -applyxfm -init /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/${subj}/subject_space.mat -interp trilinear
		done
	done
done 

