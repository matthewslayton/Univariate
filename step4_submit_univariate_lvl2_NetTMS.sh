#!/bin/bash

#EXPERIMENT=NetTMS.01 #environmental variable
source /etc/biac_sge.sh
EXPERIMENT=`findexp NetTMS.01`
EXPERIMENT=${EXPERIMENT:?"Returned NULL Experiment"}

for subj in 5020; do echo $subj;
	#cd /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/$subj/
	for day in 1 2 3 4; do echo $day; 
	#for day in 1; do echo $day;
		for retType in CMEM PMEM; do echo $retType;
		#for retType in CMEM; do echo $retType;

			#qsub -v EXPERIMENT=$EXPERIMENT -v SUBNUM=${subj} -v DAY=${day} -v RETTYPE=${retType} -v /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/run_univariate_lvl2_NetTMS.sh
			qsub -v EXPERIMENT=$EXPERIMENT /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/run_univariate_lvl2_NetTMS.sh ${subj} ${day} ${retType}
			echo "Job submitted for Subj ${subj} Day${day} ${retType}"
		done
	done
done
#keep checking qstat to see if it goes from qw for queued to r for running. if not, try emailing BIAC IT person who is Chris Petty