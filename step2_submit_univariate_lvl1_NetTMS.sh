#!/bin/bash

#EXPERIMENT=NetTMS.01 #environmental variable
source /etc/biac_sge.sh
EXPERIMENT=`findexp NetTMS.01`
EXPERIMENT=${EXPERIMENT:?"Returned NULL Experiment"}

for subj in 5020 5021 5022 5025; do echo $subj;
	#cd /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/$subj/
	for day in 1 2 3 4; do echo $day; 
	#for day in 1; do echo $day;
		for retType in CMEM PMEM; do echo $retType;
		#for retType in CMEM; do echo $retType;
			for run in 1 2 3; do echo $run;
			#for run in 3; do echo $run;

				#qsub -v EXPERIMENT=$EXPERIMENT -v subj=${subj} -v day=${day} -v retType=${retType} -v run=${run} /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/run_univariate_lvl1_NetTMS.sh
				qsub -v EXPERIMENT=$EXPERIMENT /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/run_univariate_lvl1_NetTMS.sh ${subj} ${day} ${retType} ${run}
				echo "Job submitted for Subj ${subj} Day${day} ${retType} Run${run}"

			done
		done
	done
done
#keep checking qstat to see if it goes from qw for queued to r for running. if not, try emailing BIAC IT person who is Chris Petty
