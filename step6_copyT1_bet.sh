#!/bin/bash

#cd /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/

# (1) Copy over the subject numbers BIAC IDs from one of the previous matlab steps
subjects=('5020' '5020' '5020' '5020',
    '5021' '5021' '5021' '5021',
    '5022' '5022' '5022' '5022',
    '5025' '5025' '5025' '5025')

biac_ID=('01165' '01178' '01182' '01184'
         '01210' '01286' '01292' '01296'
         '01228' '01262' '01266' '01272'
         '01325' '01365' '01368' '01370')

# (2) Get the first of every group of 4 since we only need one T1 per subject
# Initialize arrays
one_ID_per_subject=()
one_subj_num=()

# Loop through every fourth element
for ((i=0; i<${#biac_ID[@]}; i+=4)); do
    one_ID_per_subject+=("${biac_ID[i]}")
    one_subj_num+=("${subjects[i]}")
done

for ((num=0; num<${#one_ID_per_subject[@]}; num++)); do
    currNum=${one_ID_per_subject[num]}
    currSubj=${one_subj_num[num]}
    preprocessed_t1="/mnt/munin2/Simon/NetTMS.01/Data/Processed_Data/fmriprep_out/sub-${currNum}/ses-1/anat/sub-${currNum}_ses-1_acq-t1_run-01_desc-preproc_T1w.nii.gz"
    final_name="${currSubj}_T1.nii.gz"
    final_name_brain="${currSubj}_T1_brain.nii.gz"

    cd "/mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/${currSubj}"
    # (3) paste the renamed T1
    cp "$preprocessed_t1" "$final_name"
    # (4) skull strip
    bet "$final_name" "$final_name_brain" -f 0.6 -m

    echo "Completed Subject ${currSubj}"
done


