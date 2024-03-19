%%%%%% Functinoal Localizer, step 2
%%% 1. First-level with three contrasts: SR>SF, SR, SF
%%% 2. Second-level, one for CMEM and one for PMEM
%%% 3. FLIRT (subject space and MNI space?)

close all
clear
clc

%% generate fsf
template_file = '/Volumes/Data/Simon/NetTMS.01/Analysis/Univariate/template_files/design_level2.fsf';
template = textscan(fopen(template_file), '%s', 'Delimiter','\n', 'CollectOutput', true);
fclose('all');

subjects = {'5001','5001','5001','5001',...
    '5002','5002','5002','5002',...
    '5004','5004','5004','5004',...
    '5005','5005','5005','5005',...
    '5006','5006','5006',...
    '5007','5007','5007','5007',...
    '5010','5010','5010','5010',...
    '5011','5011','5011','5011',...
    '5012','5012','5012','5012',...
    '5014','5014','5014','5014',...
    '5015','5015','5015','5015',...
    '5016','5016','5016','5016',...
    '5017','5017','5017','5017',...
    '5019','5019','5019','5019',...
    '5020','5020','5020','5020',...
    '5021','5021','5021','5021',...
    '5022','5022','5022','5022',...
    '5025','5025','5025','5025',...
    '5026','5026','5026','5026'};

biac_ID = {'00414','00595','00597','00598',... %5001
    '00373','00706','00710','00713',... %5002
    '00432','00562','00566','00568',... %5004
    '00616','00655','00658','00661',... %5005
    '00665','00742','00744',... %5006
    '00867','00890','00893','00895',... %5007
    '01224','01271','01275','01279',... %5010
    '00961','00990','00995','01001',... %5011
    '01087','01101','01104','01107',... %5012
    '00940','00976','00979','00980',... %5014
    '00953','01233','01239','01242',... %5015
    '00971','01007','01012','01014',... %5016
    '00992','01099','01103','01105',... %5017
    '01086','01183','01187','01189',... %5019
    '01165','01178','01182','01184',... %5020
    '01210','01286','01292','01296',... %5021
    '01228','01262','01266','01272',... %5022
    '01325','01365','01368','01370',... %5025
    '01375','01389','01392','01396',... %5026
    }; 


dayNum = {1,2,3,4,... %5001
    1,2,3,4,... %5022
    1,2,3,4,... %5004
    1,2,3,4,... %5005
    1,2,3,... %5006
    1,2,3,4,... %5007
    1,2,3,4,... %5010
    1,2,3,4,... %5011
    1,2,3,4,... %5012
    1,2,3,4,... %5014
    1,2,3,4,... %5015
    1,2,3,4,... %5016
    1,2,3,4,... %5017
    1,2,3,4,... %5019
    1,2,3,4,... %5020
    1,2,3,4,... %5021
    1,2,3,4,... %5022
    1,2,3,4,... %5025
    1,2,3,4,... %5026
    };

subject_oneSub = {'5007','5007','5007','5007'};
% how do I automate finding the biac IDs?
biac_oneSub = {'00867','00890','00893','00895'};
dayNum_oneSub = [1,2,3,4];
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
	            
                % modify appropriate rows of the template
	            design = template{1,1};

                design{18,1} = 'set fmri(analysis) 2'; %statistics
                
                % # Output directory on munin
                outputdir = sprintf('/Volumes/Data/Simon/NetTMS.01/Analysis/Univariate/%s/level2_design/lvl2_%s_Day%d_ENC_%s',subject,subject,currDay,currRetType);
                if ~exist(outputdir); mkdir(outputdir); end

                design{33,1} = sprintf('set fmri(outputdir) "/mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/%s/level2_design/lvl2_%s_Day%d_ENC_%s"',subject,subject,currDay,currRetType);

                % # Standard Image
                design{248,1} = 'set fmri(regstandard) "/mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/MNI152_T1_2mm_brain.nii.gz"';
                
                % # 4D AVW data or FEAT directory (1)
                design{285,1} = sprintf('set feat_files(1) "/mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/%s/level1_design/lvl1_%s_Day%d_ENC_%s_Run1.feat"',subject,subject,currDay,currRetType);

                % # 4D AVW data or FEAT directory (2)
                design{288,1} = sprintf('set feat_files(2) "/mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/%s/level1_design/lvl1_%s_Day%d_ENC_%s_Run2.feat"',subject,subject,currDay,currRetType);

                % # 4D AVW data or FEAT directory (3)
                design{291,1} = sprintf('set feat_files(3) "/mnt/munin2/Simon/NetTMS.01/Analysis/Univariate/%s/level1_design/lvl1_%s_Day%d_ENC_%s_Run3.feat"',subject,subject,currDay,currRetType);
                
                cd(outputdir)
                fid = fopen('design.fsf','w');
                fprintf(fid,'%s\n', design{:});
                fclose(fid);
                
                fprintf(strcat('finished: ',subject));

				toc
        end %currRun loop
    end %retType loop
end %sub loop