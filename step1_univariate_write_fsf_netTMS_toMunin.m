%%%%%% Functional Localizer, step 1
%%% 1. First-level with three contrasts: SR>SF, SR, SF
%%% 2. Second-level, one for CMEM and one for PMEM
%%% 3. FLIRT (subject space and MNI space)

%%%% better to run on your local machine so the script can access box.


% cd /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate

close all
clear
clc

%%%%%% you have to load the three runs
% /Volumes/Data/Simon/NetTMS.01/Analysis/TMS_Localizers/5020/sub-01165_ses-1_task-encoding_run-1_space-MNI152NLin6Asym_desc-smoothAROMAnonaggr_bold.nii.gz

%%%%%% load onset files
% /Volumes/Data/Simon/NetTMS.01/Analysis/TMS_Localizers/5020/Onset_Files/5020_Day1_ENC_CMEM_SR_RUN1.txt

%%%%%% load confounds
% /Volumes/Data/Simon/NetTMS.01/Analysis/TMS_Localizers/5020/fmriprep_outputs/5020_DAY1_ENC_Confounds_RUN1.txt

%%%%%% load skull-stripped T1
% /Volumes/Data/Simon/NetTMS.01/Analysis/TMS_Localizers/5020/5020_t1_brain.nii.gz

%%%%%% set up the contrasts, which you can get from the template file

%%% then make sure the submit scripts give the info we need. Don't need Day because it's always day 1.



%% generate fsf
%%% template path should change to work for other users
template_file = '/Volumes/Data/Simon/NetTMS.01/Analysis/Univariate/template_files/design_level1.fsf';
template = textscan(fopen(template_file), '%s', 'Delimiter','\n', 'CollectOutput', true);
fclose('all');

% subjects = {'5001','5001','5001','5001',...
%     '5002','5002','5002','5002',...
%     '5004','5004','5004','5004',...
%     '5005','5005','5005','5005',...
%     '5006','5006','5006',...
%     '5007','5007','5007','5007',...
%     '5010','5010','5010','5010',...
%     '5011','5011','5011','5011',...
%     '5012','5012','5012','5012',...
%     '5014','5014','5014','5014',...
%     '5015','5015','5015','5015',...
%     '5016','5016','5016','5016',...
%     '5017','5017','5017','5017',...
%     '5019','5019','5019','5019',...
%     '5020','5020','5020','5020',...
%     '5021','5021','5021','5021',...
%     '5022','5022','5022','5022',...
%     '5025','5025','5025','5025',...
%     '5026','5026','5026','5026'};
% 
% biac_ID = {'00414','00595','00597','00598',... %5001
%     '00373','00706','00710','00713',... %5002
%     '00432','00562','00566','00568',... %5004
%     '00616','00655','00658','00661',... %5005
%     '00665','00742','00744',... %5006
%     '00867','00890','00893','00895',... %5007
%     '01224','01271','01275','01279',... %5010
%     '00961','00990','00995','01001',... %5011
%     '01087','01101','01104','01107',... %5012
%     '00940','00976','00979','00980',... %5014
%     '00953','01233','01239','01242',... %5015
%     '00971','01007','01012','01014',... %5016
%     '00992','01099','01103','01105',... %5017
%     '01086','01183','01187','01189',... %5019
%     '01165','01178','01182','01184',... %5020
%     '01210','01286','01292','01296',... %5021
%     '01228','01262','01266','01272',... %5022
%     '01325','01365','01368','01370',... %5025
%     '01375','01389','01392','01396',... %5026
%     '01699','01711','01716','01717'     %5028
%     }; 
% 
% 
% dayNum = {1,2,3,4,... %5001
%     1,2,3,4,... %5022
%     1,2,3,4,... %5004
%     1,2,3,4,... %5005
%     1,2,3,... %5006
%     1,2,3,4,... %5007
%     1,2,3,4,... %5010
%     1,2,3,4,... %5011
%     1,2,3,4,... %5012
%     1,2,3,4,... %5014
%     1,2,3,4,... %5015
%     1,2,3,4,... %5016
%     1,2,3,4,... %5017
%     1,2,3,4,... %5019
%     1,2,3,4,... %5020
%     1,2,3,4,... %5021
%     1,2,3,4,... %5022
%     1,2,3,4,... %5025
%     1,2,3,4,... %5026
%     };

subject_oneSub = {'5004'};
% how do I automate finding the biac IDs?
biac_oneSub = {'00562'};
dayNum_oneSub = 2;
% convert these so I can run just the one subject
subjects = subject_oneSub;
biac_ID = biac_oneSub;
dayNum = dayNum_oneSub;


for subj = 1:length(subjects) %remember subj is my day  loop too
    
    subject = subjects{subj};
	biac = biac_ID{subj};
    currDay = dayNum(subj); %biac number determines the day number, so we don't need a loop

    for retType = 1:2
        if retType == 1
            currRetType = 'CMEM';
        elseif retType == 2
            currRetType = 'PMEM';
        end

        for currRun = 1:3
	    
		        tic
			    %%%%% MATTHEW %%%%%
                %%%%% should we add these to the cluster or run this script locally?
			    addpath /Users/matthewslayton/Library/CloudStorage/Box-Box/ElectricDino/Projects/NetTMS/NetTMS_task/
			    subdir = strcat('/Users/matthewslayton/Library/CloudStorage/Box-Box/ElectricDino/Projects/NetTMS/NetTMS_task/',subject,'/');
		        %subdir = strcat('/mnt/Data/munin2/NetTMS.01/Analysis/Univariate/',subject,'5007_behavioral_outputMatFiles/');

                %%%%% Jane %%%%%
		        % paths here
                %cd(subdir);
	            % modify appropriate rows of the template
	            design = template{1,1};
    
                design{18,1} = 'set fmri(analysis) 7'; %full analysis
	            
                % # Output directory on munin
                outputdir = sprintf('/Volumes/Data/Simon/NetTMS.01/Analysis/Univariate/%s/level1_design/lvl1_%s_Day%d_ENC_%s_Run%d',subject,subject,currDay,currRetType,currRun);
                if ~exist(outputdir); mkdir(outputdir); end
    
                design{33,1} = sprintf('set fmri(outputdir) "/mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/%s/level1_design/lvl1_%s_Day%d_ENC_%s_Run%d"',subject,subject,currDay,currRetType,currRun);

	            % # Total volumes
	            design{36,1} = 'set fmri(tr) 2.000000';
                
                if subject == '5001'
	                design{39,1} = 'set fmri(npts) 160';
                    design{42,1} = 'set fmri(ndelete) 0';

                elseif strcmp(subject,'5004') && currDay == 1
                    design{39,1} = 'set fmri(npts) 165';
                % # Delete volumes
                    design{42,1} = 'set fmri(ndelete) 4';

                elseif strcmp(subject,'5004') && currDay == 2
                    design{39,1} = 'set fmri(npts) 167';
                    design{42,1} = 'set fmri(ndelete) 4';
                end
    
	            % # Z threshold
	            design{188,1} = 'set fmri(z_thresh) 2.7';

                % # Standard Image
                %design{248,1} = 'set fmri(regstandard) "/usr/local/fsl/data/standard/MNI152_T1_2mm_brain"';
                design{248,1} = 'set fmri(regstandard) "/mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/MNI152_T1_2mm_brain.nii.gz"';
                % /mnt/munin2/Simon/NetTMS.01/Analysis/Univariate_Analyses/MNI152_T1_2mm_brain.nii.gz
                % /usr/local/fsl/data/standard/MNI152_T1_2mm_brain
                
                % for confounds we need to load the original tsv file, remove the first 4 time points, and get CSF, WM, FD, DVARS
                % load the raw confound file
                % task name might be "func" or "encoding"
                % also run format might be "run-1" or "run-01"
                % # 4D AVW data or FEAT directory (1)
                %%% four different versions of line 276 below in the try-catch block
                %design{276,1} = sprintf('set feat_files(1) "/mnt/munin2/Simon/NetTMS.01/Data/Processed_Data/fmriprep_out/sub-%s/ses-1/func/sub-%s_ses-1_task-encoding_run-%d_space-MNI152NLin6Asym_desc-smoothAROMAnonaggr_bold"',biac,biac,currRun);
                
                try
                    currConfoundFile = sprintf('/Volumes/Data/Simon/NetTMS.01/Data/Processed_Data/fmriprep_out/sub-%s/ses-1/func/sub-%s_ses-1_task-encoding_run-%d_desc-confounds_timeseries.tsv',biac,biac,currRun);
                    t = readtable(currConfoundFile, "FileType","text",'Delimiter', '\t');
                    design{276,1} = sprintf('set feat_files(1) "/mnt/munin2/Simon/NetTMS.01/Data/Processed_Data/fmriprep_out/sub-%s/ses-1/func/sub-%s_ses-1_task-encoding_run-%d_space-MNI152NLin6Asym_desc-smoothAROMAnonaggr_bold"',biac,biac,currRun);
                catch
                    try
                        currConfoundFile = sprintf('/Volumes/Data/Simon/NetTMS.01/Data/Processed_Data/fmriprep_out/sub-%s/ses-1/func/sub-%s_ses-1_task-encoding_run-%02d_desc-confounds_timeseries.tsv',biac,biac,currRun);
                        t = readtable(currConfoundFile, "FileType","text",'Delimiter', '\t');
                        design{276,1} = sprintf('set feat_files(1) "/mnt/munin2/Simon/NetTMS.01/Data/Processed_Data/fmriprep_out/sub-%s/ses-1/func/sub-%s_ses-1_task-encoding_run-%02d_space-MNI152NLin6Asym_desc-smoothAROMAnonaggr_bold"',biac,biac,currRun);
                    catch
                        try
                            currConfoundFile = sprintf('/Volumes/Data/Simon/NetTMS.01/Data/Processed_Data/fmriprep_out/sub-%s/ses-1/func/sub-%s_ses-1_task-func_run-%d_desc-confounds_timeseries.tsv',biac,biac,currRun);
                            t = readtable(currConfoundFile, "FileType","text",'Delimiter', '\t');
                            design{276,1} = sprintf('set feat_files(1) "/mnt/munin2/Simon/NetTMS.01/Data/Processed_Data/fmriprep_out/sub-%s/ses-1/func/sub-%s_ses-1_task-func_run-%d_space-MNI152NLin6Asym_desc-smoothAROMAnonaggr_bold"',biac,biac,currRun);
                        catch
                            currConfoundFile = sprintf('/Volumes/Data/Simon/NetTMS.01/Data/Processed_Data/fmriprep_out/sub-%s/ses-1/func/sub-%s_ses-1_task-func_run-%02d_desc-confounds_timeseries.tsv',biac,biac,currRun);
                            t = readtable(currConfoundFile, "FileType","text",'Delimiter', '\t');
                            design{276,1} = sprintf('set feat_files(1) "/mnt/munin2/Simon/NetTMS.01/Data/Processed_Data/fmriprep_out/sub-%s/ses-1/func/sub-%s_ses-1_task-func_run-%02d_space-MNI152NLin6Asym_desc-smoothAROMAnonaggr_bold"',biac,biac,currRun);
                        end
                    end
                end

                
				


                % make a new confound table
                % remove first four and grab only CSF, WM, DVARS, FD
                t_clean = t(5:end,["csf","white_matter","dvars","framewise_displacement"]);
                % write table as txt file 
                output_path = sprintf('/Volumes/Data/Simon/NetTMS.01/Analysis/Univariate/%s/Onset_Files/%s_Day%d_ENC_Confounds_Run%d.txt',subject,subject,currDay,currRun);
                writetable(t_clean,output_path)

               %  # Confound EVs text file for analysis 1
                design{282,1} = sprintf('set confoundev_files(1) "/mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/%s/Onset_Files/%s_Day%d_ENC_Confounds_Run%d.txt"',subject,subject,currDay,currRun);

                % # Subject's structural image for analysis 1
                %design{285,1} = sprintf('set highres_files(1) "/mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/%s/%s_t1_brain"',subject,subject);

	            % # Custom EV file (EV 1)
	            design{317,1} = sprintf('set fmri(custom1) "/mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/%s/Onset_Files/%s_Day%d_ENC_%s_SR_Run%d.txt"',subject,subject,currDay,currRetType,currRun);
    
	            % # Custom EV file (EV 2)
	            design{361,1} = sprintf('set fmri(custom2) "/mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/%s/Onset_Files/%s_Day%d_ENC_%s_SF_Run%d.txt"',subject,subject,currDay,currRetType,currRun);

                cd(outputdir)
	            fid = fopen('design.fsf','w');
	            fprintf(fid,'%s\n', design{:});
	            fclose(fid);
		        fprintf(strcat('finished: ',subject));
		        toc
    
        end %currRun loop
    end %retType loop
end %sub loop


%%%% each 1st-level model generates a 
%%% filtered_func_data.nii.gz which is big and useless, and can probably be deleted at the end of the 1st-level script
