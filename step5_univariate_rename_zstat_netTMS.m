% in between localizer steps 2 and 4, after you've run the higher-level
% analysis and before you run FLIRT, you have to grab the zstat1.nii.gz
% files and rename. There are two second-level output folders. One for cmem
% and one for pmem. Each has three copes that correspond to the three
% contrasts: SR>SF, SR, and SF

% to use SPM
% on laptop
% addpath /Users/matthewslayton/Documents/Duke/Simon_Lab/Scripts/spm12;
% on velociraptor
%addpath '/Users/matthewslayton/spm12';

%addpath /Users/jane/Library/Mobile Documents/com~apple~CloudDocs/Documents/Duke/davis/netTMS/netTMS-analysis/mfMRI_v2-master
addpath /Volumes/Data/Simon/NetTMS.01/Analysis/Univariate/NIfTI_20140122/ %load_untouch_nii.m etc

% for subj %<- add later when I have more subjects


% subjects = {'5001','5002','5004','5005','5006','5007','5010',...
%     '5011','5012','5014','5015','5016','5017','5019',...
%     '5020','5021','5022','5025','5026'};



subjects = {'5020','5021','5022','5025'};

for subj = 1:length(subjects) 

    subject = subjects{subj};

    % need an output folder for the renamed zstat files
    fsl_dir = sprintf('/Volumes/Data/Simon/NetTMS.01/Analysis/Univariate/%s/Activation',subject);
    if ~exist(fsl_dir,'dir'); mkdir(fsl_dir); end

    for currDay = 1:4
        tic
        for retType = 1:2
            if retType == 1
                currRetType = 'CMEM';
            elseif retType == 2
                currRetType = 'PMEM';
            end

            for currCope = 1:3
               
                source_= sprintf('/Volumes/Data/Simon/NetTMS.01/Analysis/Univariate/%s/level2_design/lvl2_%s_Day%d_ENC_%s.gfeat',subject,subject,currDay,currRetType);
                currFilePath = sprintf('/Volumes/Data/Simon/NetTMS.01/Analysis/Univariate/%s/level2_design/lvl2_%s_Day%d_ENC_%s.gfeat/cope%d.feat/stats/zstat1.nii.gz',subject,subject,currDay,currRetType,currCope);
                currFileUnzip = gunzip(currFilePath); %loads as a cell
                currFile = load_untouch_nii(currFileUnzip{:});

                newFile.('hdr') = currFile.hdr;
                newFile.('filetype') = 2;
                newFile.('fileprefix') = currFile.fileprefix;
                newFile.('machine') = currFile.machine;
                newFile.('ext') = currFile.ext;
                newFile.('img') = currFile.img;
                newFile.('untouch') = currFile.untouch;

                if currCope == 1 %SR>SF
                    save_untouch_nii(newFile,strcat(fsl_dir,sprintf('/%s_Day%d_%s_SRSF_MNI.nii',subject,currDay,currRetType)))
                elseif currCope == 2 %SR
                    save_untouch_nii(newFile,strcat(fsl_dir,sprintf('/%s_Day%d_%s_SR_MNI.nii',subject,currDay,currRetType)))
                elseif currCope == 3 %SF
                    save_untouch_nii(newFile,strcat(fsl_dir,sprintf('/%s_Day%d_%s_SF_MNI.nii',subject,currDay,currRetType)))
                end
            end %currCope loop

        end % retType loop
        toc
    end %currDay loop
end %subject loop

%% can we copy, rename, and paste the T1's


