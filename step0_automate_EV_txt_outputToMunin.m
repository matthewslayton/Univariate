% make the 3-column EV txt files for NetTMS

%%%% better to run on your local machine so the script can access box.

clear all

% H = hit
% M = miss
% FA = false alarm
% CR = correction rejection

% Old = YES, New = NO
% Old said old: 1, 1 H
% Old said new: 1, 2 M
% New said old: 2, 1 FA
% New said new: 2, 2 CR
% Or no response

%%%% to start we want only hits and misses.

%%%% onset files are e.g. 5014_Day1_ENC_CMEM_SR_RUN1.txt
% that's the subject number, day, encoding (which these all will be
% because we scanned during encoding), whether we're talking about
% Conceptual or Perceptual Retrieval, whether the item was subsequently
% remembered or forgotten, and the encoding run number

%%% Why is that? During encoding they see two objects per trial (picture and word). 
% During retrieval, they see one word or picture at a time and have to say
% whether it's old or new. So, we want the presentation time of the object
% during encoding and to know whether the participant got a hit or a miss
% for that item. Also, there's nothing special about the fact that there
% are two items in ENC and one per RET. It's just that in ENC we ask them
% to choose whether the two items are similar or not. We're interested in
% semantic relatedness but also it's just something to do! We really do
% care about the objects individually. 

%%% tl;dr
% ENC items were scanned. We need to know when they appeared on the screen.
% Then we have to know whether during retrieval the participant remembered it or not

%%% what do the txt files look like?
% three columns. First col has object onset times. Second col is 0s (always
% set Duration = 0 for univariate), and Third col is 1s for 'include this time point'
% In terms of formatting, they're separated by tabs like this:
% 3.4317781     0	1
% 27.3694756	0	1
% 36.0375881	0	1
% 42.4291426	0	1
% 50.7160884	0	1
% 57.0757981	0	1
% 67.5105371	0	1
% 73.6431092	0	1

%% Set the subject
subject = '5007';

% don't round to four decimal places. It messes with the formatting in the
% txt output file
%format long

%% Choose one
% %%%% MAGS %%%%
% addpath '/Users/margaretmcallister/Box Sync/ElectricDino/Projects/NetTMS/NetTMS_task'
% subdir = strcat('/Users/margaretmcallister/Box Sync/ElectricDino/Projects/NetTMS/NetTMS_task/',subject,'/');

%%%%% Sarrah %%%%%
% addpath to NetTMS_task
% add subdir

% %%%%% MATTHEW %%%%%
addpath /Users/matthewslayton/Library/CloudStorage/Box-Box/ElectricDino/Projects/NetTMS/NetTMS_task/
subdir = strcat('/Users/matthewslayton/Library/CloudStorage/Box-Box/ElectricDino/Projects/NetTMS/NetTMS_task/',subject,'/');

%%%%% Jim %%%%%
% addpath /Users/jinjiang-macair/Library/CloudStorage/Box-Box/ElectricDino/Projects/NetTMS/NetTMS_task/
% subdir = strcat('/Users/jinjiang-macair/Library/CloudStorage/Box-Box/ElectricDino/Projects/NetTMS/NetTMS_task/', subject, '/');


%% we need the output files
cd (subdir)
addpath(subdir)
output_files = dir('*.mat');
output_list = {output_files.name}.';
% output_list goes in day and run order (day1run1, day1run2, .... , day4run4)

%%% is there any day10?
isDay10True = zeros(length(output_list),1);
for row = 1:length(output_list)

    currFileName = output_list{row};
    currDay = extractBetween(currFileName,'day','_');
    if strcmp(currDay{:},'10') == 1
        isDay10True(row) = 1;
    end
end

% first find the order of these tbls within the subject folder
% then use the indices to isolate CRET and PRET
CRET_counter = 1;
PRET_counter = 1;
ENC_counter = 1;
for curr = 1:length(output_list)

    % if this is a day10, don't count it
    if isDay10True(curr) == 1
        %continue
        fprintf("There's day10 up in there! Those are for screening days and should not be analyzed \n Move it to a sub-folder. ctrl+c to end program")
        pause(inf)
       
    else

        currOutputCell = output_list(curr);
        currOutputMat = cell2mat(currOutputCell);
        strPos = strfind(currOutputMat,'_output');
        trialType = currOutputMat(strPos-4:strPos);
        if trialType == 'CRET_'
            CRET_files(CRET_counter) = curr;
            CRET_counter = CRET_counter + 1;
        elseif trialType == 'PRET_'
            PRET_files(PRET_counter) = curr;
            PRET_counter = PRET_counter + 1;
        elseif trialType == '_ENC_'
            ENC_files(ENC_counter) = curr;
            ENC_counter = ENC_counter + 1;
        end
    end
end



%%%%%%%% (1) Calculate info for each day %%%%%%%%%%

% how many days of data do we have?
day_total = length(CRET_files)/4;

%%% day loop
for day = 1:day_total %day_total
    tic

    % the indices depend on which day we're running
    if day == 1
        index_cret = 1;
        index_enc = 1;
    elseif day == 2
        index_cret = 5;
        index_enc = 4;
    elseif day == 3
        index_cret = 9;
        index_enc = 7;
    elseif day == 4
        index_cret = 13;
        index_enc = 10;
    end

    % get all three ENC outputs for current day
    currOutputCell = output_list(ENC_files(index_enc)); %run 1
    currOutputMat = cell2mat(currOutputCell);
    load(currOutputMat)
    % add something for if outputs loads as pdata? Maybe not necessary
    output_tbl_enc1 = output_tbl;
    clear output_tbl %clear it now that we're done with it so it can load again fresh.
    % if it doesn't load correctly, we won't just assign run 1's data to
    % run 2, for example
    currOutputCell = output_list(ENC_files(index_enc+1)); %run 2
    currOutputMat = cell2mat(currOutputCell);
    load(currOutputMat)
    output_tbl_enc2 = output_tbl;
    clear output_tbl
    currOutputCell = output_list(ENC_files(index_enc+2)); %run 3
    currOutputMat = cell2mat(currOutputCell);
    load(currOutputMat)
    output_tbl_enc3 = output_tbl;
    clear output_tbl

    % get all four CRET outputs for current day
    currOutputCell = output_list(CRET_files(index_cret)); %run 1
    currOutputMat = cell2mat(currOutputCell);
    load(currOutputMat)
    output_tbl_cret1 = output_tbl;
    clear output_tbl
    currOutputCell = output_list(CRET_files(index_cret+1)); %run 2
    currOutputMat = cell2mat(currOutputCell);
    load(currOutputMat)
    output_tbl_cret2 = output_tbl;
    clear output_tbl
    currOutputCell = output_list(CRET_files(index_cret+2)); %run 3
    currOutputMat = cell2mat(currOutputCell);
    load(currOutputMat)
    output_tbl_cret3 = output_tbl;
    clear output_tbl
    currOutputCell = output_list(CRET_files(index_cret+3)); %run 4
    currOutputMat = cell2mat(currOutputCell);
    load(currOutputMat)
    output_tbl_cret4 = output_tbl;
    clear output_tbl

    % get all three PRET outputs for current day
    index_pret = index_enc; %it's the same but seems to want a name change
    currOutputCell = output_list(PRET_files(index_pret)); %run 1
    currOutputMat = cell2mat(currOutputCell);
    load(currOutputMat)
    output_tbl_pret1 = output_tbl;
    clear output_tbl
    currOutputCell = output_list(PRET_files(index_pret+1)); %run 2
    currOutputMat = cell2mat(currOutputCell);
    load(currOutputMat)
    output_tbl_pret2 = output_tbl;
    clear output_tbl

    if strcmp(subject,'5016') == 1 && day == 4 %day 4 run 3 corrupted
        continue
    end
    % could put all the load(currOutputMat) lines in try/catch statements in case load() fails
    % if the file is just not there, exist(currOutputMat) == 0

    currOutputCell = output_list(PRET_files(index_pret+2)); %run 3
    currOutputMat = cell2mat(currOutputCell);
    load(currOutputMat)
    output_tbl_pret3 = output_tbl;
    clear output_tbl

    %%%%%%%%%%%%%
    %%% what if there are missing responses?
    %%%%% later on, make a version of this that will work if the file won't load
    %% ENC
    % any empty cells? (1=yes, 0=no)
    emptyCells_enc1 = cellfun ('isempty', output_tbl_enc1.resp);
    emptyCells_enc2 = cellfun ('isempty', output_tbl_enc2.resp);
    emptyCells_enc3 = cellfun ('isempty', output_tbl_enc3.resp);

    % now I want only the non-empties (does nothing if all responses are there)
    non_empty_enc1 = ~emptyCells_enc1;
    output_tbl_enc1_clean = output_tbl_enc1(non_empty_enc1,:);
    non_empty_enc2 = ~emptyCells_enc2;
    output_tbl_enc2_clean = output_tbl_enc2(non_empty_enc2,:);
    non_empty_enc3 = ~emptyCells_enc3;
    output_tbl_enc3_clean = output_tbl_enc3(non_empty_enc3,:);
    
    %% CRET
    % any empty cells? (1=yes, 0=no)
    emptyCells_cret1 = cellfun ('isempty', output_tbl_cret1.resp);
    emptyCells_cret2 = cellfun ('isempty', output_tbl_cret2.resp);
    emptyCells_cret3 = cellfun ('isempty', output_tbl_cret3.resp);
    emptyCells_cret4 = cellfun ('isempty', output_tbl_cret4.resp);

    non_empty_cret1 = ~emptyCells_cret1;
    output_tbl_cret1_clean = output_tbl_cret1(non_empty_cret1,:);
    non_empty_cret2 = ~emptyCells_cret2;
    output_tbl_cret2_clean = output_tbl_cret2(non_empty_cret2,:);
    non_empty_cret3 = ~emptyCells_cret3;
    output_tbl_cret3_clean = output_tbl_cret3(non_empty_cret3,:);
    non_empty_cret4 = ~emptyCells_cret4;
    output_tbl_cret4_clean = output_tbl_cret4(non_empty_cret4,:);

    %% PRET
    % any empty cells? (1=yes, 0=no)
    emptyCells_pret1 = cellfun ('isempty', output_tbl_pret1.resp);
    emptyCells_pret2 = cellfun ('isempty', output_tbl_pret2.resp);
    emptyCells_pret3 = cellfun ('isempty', output_tbl_pret3.resp);

    % now I want only the non-emptys (does nothing if all responses are there)
    non_empty_pret1 = ~emptyCells_pret1;
    output_tbl_pret1_clean = output_tbl_pret1(non_empty_pret1,:);
    non_empty_pret2 = ~emptyCells_pret2;
    output_tbl_pret2_clean = output_tbl_pret2(non_empty_pret2,:);
    non_empty_pret3 = ~emptyCells_pret3;
    output_tbl_pret3_clean = output_tbl_pret3(non_empty_pret3,:);

    %% now I need an ENC object ID reference table
    % I want to match CRET performance with the ENC onset

    % enc
    if iscell(output_tbl_enc1.ID1) == 1 %is the output a cell?
        all_enc_IDs = cell2mat(vertcat(output_tbl_enc1_clean.ID1,output_tbl_enc1_clean.ID2,...
            output_tbl_enc2_clean.ID1,output_tbl_enc2_clean.ID2,output_tbl_enc3_clean.ID1,output_tbl_enc3_clean.ID2));
        all_enc_objOnsets = cell2mat(vertcat(output_tbl_enc1_clean.tObj1Onset,output_tbl_enc1_clean.tObj2Onset,...
            output_tbl_enc2_clean.tObj1Onset,output_tbl_enc2_clean.tObj2Onset,...
            output_tbl_enc3_clean.tObj1Onset,output_tbl_enc3_clean.tObj2Onset));
    else
    %enc
        all_enc_IDs = vertcat(output_tbl_enc1_clean.ID1,output_tbl_enc1_clean.ID2,...
            output_tbl_enc2_clean.ID1,output_tbl_enc2_clean.ID2,output_tbl_enc3_clean.ID1,output_tbl_enc3_clean.ID2);
        all_enc_objOnsets = vertcat(output_tbl_enc1_clean.tObj1Onset,output_tbl_enc1_clean.tObj2Onset,...
            output_tbl_enc2_clean.tObj1Onset,output_tbl_enc2_clean.tObj2Onset,...
            output_tbl_enc3_clean.tObj1Onset,output_tbl_enc3_clean.tObj2Onset);
    end
    encRunCounter = 1:120; %we need the info to be specific to each Enc Run

    if iscell(output_tbl_cret1.stimID) == 1 % is output a cell?
    % cret
        all_cret_stimIDs = cell2mat(vertcat(output_tbl_cret1_clean.stimID,output_tbl_cret2_clean.stimID,...
            output_tbl_cret3_clean.stimID,output_tbl_cret4_clean.stimID));
        all_cret_oldNew = cell2mat(vertcat(output_tbl_cret1_clean.OldNew,output_tbl_cret2_clean.OldNew,...
            output_tbl_cret3_clean.OldNew,output_tbl_cret4_clean.OldNew));
        all_cret_resp = cell2mat(vertcat(output_tbl_cret1_clean.resp,output_tbl_cret2_clean.resp,...
            output_tbl_cret3_clean.resp,output_tbl_cret4_clean.resp));
    % pret
        all_pret_stimIDs = cell2mat(vertcat(output_tbl_pret1_clean.stimID,output_tbl_pret2_clean.stimID,output_tbl_pret3_clean.stimID));
        all_pret_oldNew = cell2mat(vertcat(output_tbl_pret1_clean.OldNew,output_tbl_pret2_clean.OldNew,output_tbl_pret3_clean.OldNew));
        all_pret_resp = cell2mat(vertcat(output_tbl_pret1_clean.resp,output_tbl_pret2_clean.resp,output_tbl_pret3_clean.resp));

    else
    % cret
        all_cret_stimIDs = vertcat(output_tbl_cret1_clean.stimID,output_tbl_cret2_clean.stimID,...
            output_tbl_cret3_clean.stimID,output_tbl_cret4_clean.stimID);
        all_cret_oldNew = vertcat(output_tbl_cret1_clean.OldNew,output_tbl_cret2_clean.OldNew,...
            output_tbl_cret3_clean.OldNew,output_tbl_cret4_clean.OldNew);
        all_cret_resp = vertcat(output_tbl_cret1_clean.resp,output_tbl_cret2_clean.resp,...
            output_tbl_cret3_clean.resp,output_tbl_cret4_clean.resp);
    % pret
        all_pret_stimIDs = vertcat(output_tbl_pret1_clean_clean.stimID,output_tbl_pret2_clean.stimID,output_tbl_pret3_clean.stimID);
        all_pret_oldNew = vertcat(output_tbl_pret1_clean.OldNew,output_tbl_pret2_clean.OldNew,output_tbl_pret3_clean.OldNew);
        all_pret_resp = vertcat(output_tbl_pret1_clean.resp,output_tbl_pret2_clean.resp,output_tbl_pret3_clean.resp);
    end

    % which rows have hits and misses?
    cret_rowIndex = zeros(length(all_cret_resp),1);
    pret_rowIndex = zeros(length(all_pret_resp),1);

    for row = 1:length(all_cret_oldNew)
        if all_cret_oldNew(row) == 1 && all_cret_resp(row) == 1
            cret_rowIndex(row) = 1; %hit
        elseif all_cret_oldNew(row) == 1 && all_cret_resp(row) == 2
            cret_rowIndex(row) = 2; %miss
            %0 would mean CR, FA, or NR
            %lures are where oldNew==2, so they're automatically excluded
        end

        if row < length(all_pret_oldNew)+1 %121 for subjects with complete responses
            if all_pret_oldNew(row) == 1 && all_pret_resp(row) == 1
                pret_rowIndex(row) = 1; %hit
            elseif all_pret_oldNew(row) == 1 && all_pret_resp(row) == 2
                pret_rowIndex(row) = 2; %miss
            end
        end
    end

    %% need to grab the ENC onset time for a specific item
    objTimes_SR_cret = zeros(length(cret_rowIndex),2); %I'll remove the zeros later
    objTimes_SF_cret = zeros(length(cret_rowIndex),2);
    objTimes_SR_pret = zeros(length(pret_rowIndex),2);
    objTimes_SF_pret = zeros(length(pret_rowIndex),2);    
    count_sr_cret = 1;
    count_sf_cret = 1;
    count_sr_pret = 1;
    count_sf_pret = 1;

    for row = 1:length(cret_rowIndex)

        % there was an error where we added two objects to both day 3 and
        % day 2 so need to skip 1009 whisk 729 rocket for 5011, but might
        % not always be the same?
        %%% need to tell it to skip if currEncRow = [];

        if cret_rowIndex(row) == 1 %hit
    
            % what was the cret stimID? Which Enc row is that?
            currEncRow = find(all_enc_IDs == all_cret_stimIDs(row));
            if isempty(currEncRow)
                objTimes_SR_cret(count_sr_cret,1) = 0; 
                %trial not presented at same day enc, put a 0 to be deleted along with the new items
                %there was an error with generate_new_stimtbl.m that only
                %affected two trials for few subjects and has since been fixed, so this
                %condition should only apply to a handful of old subjects, e.g. 5011
            elseif length(currEncRow) > 1 %obj presented more than once
                objTimes_SR_cret(count_sr_cret,1) = 0; 
            else
                % store the onset
                objTimes_SR_cret(count_sr_cret,1) = all_enc_objOnsets(currEncRow);   
                % add the run so we can sort by run later
                if currEncRow < 41 %run 1
                    objTimes_SR_cret(count_sr_cret,2) = 1;
                elseif currEncRow > 80 %run3
                    objTimes_SR_cret(count_sr_cret,2) = 3;
                else %run2
                    objTimes_SR_cret(count_sr_cret,2) = 2;
                end
                count_sr_cret = count_sr_cret+1;
            end

        elseif cret_rowIndex(row) == 2 %miss
            currEncRow = find(all_enc_IDs == all_cret_stimIDs(row));
            if isempty(currEncRow)
                objTimes_SF_cret(count_sf_cret,1) = 0; 
                %same issue as above with hits. Two trials were added
                %incorrectly by the old stimtbl script. Set to 0 and remove below
            elseif length(currEncRow) > 1 %obj presented more than once
                objTimes_SF_cret(count_sf_cret,1) = 0; 
            else
                objTimes_SF_cret(count_sf_cret,1) = all_enc_objOnsets(currEncRow);   
                if currEncRow < 41 %run 1
                    objTimes_SF_cret(count_sf_cret,2) = 1;
                elseif currEncRow > 80 %run3
                    objTimes_SF_cret(count_sf_cret,2) = 3;
                else %run2
                    objTimes_SF_cret(count_sf_cret,2) = 2;
                end
                count_sf_cret = count_sf_cret+1;
            end
        end %cret if statement

         %pret only has 120, not 172 like CRET
        if row<length(all_pret_oldNew)+1 %121 for subjects with complete responses  
            if pret_rowIndex(row) == 1 %hit
                currEncRow = find(all_enc_IDs == all_pret_stimIDs(row));
                %%% if the same obj was shown in enc twice, skip
                if isempty(currEncRow) == 1
                    objTimes_SR_pret(count_sr_pret,1) = 0;
                elseif length(currEncRow) > 1
                    objTimes_SR_pret(count_sr_pret,1) = 0;
                else
                    objTimes_SR_pret(count_sr_pret,1) = all_enc_objOnsets(currEncRow);   
                    if currEncRow < 41 %run 1
                        objTimes_SR_pret(count_sr_pret,2) = 1;
                    elseif currEncRow > 80 %run3
                        objTimes_SR_pret(count_sr_pret,2) = 3;
                    else %run2
                        objTimes_SR_pret(count_sr_pret,2) = 2;
                    end
                    count_sr_pret = count_sr_pret+1;
                end

            elseif pret_rowIndex(row) == 2 %miss
                currEncRow = find(all_enc_IDs == all_pret_stimIDs(row));

                %%% if the same obj was shown in enc twice, skip. e.g. 5001
                if isempty(currEncRow) == 1
                    objTimes_SF_pret(count_sf_pret,1) = 0;
                elseif length(currEncRow) > 1
                    objTimes_SF_pret(count_sf_pret,1) = 0;
                else
                    objTimes_SF_pret(count_sf_pret,1) = all_enc_objOnsets(currEncRow);   
                    if currEncRow < 41 %run 1
                        objTimes_SF_pret(count_sf_pret,2) = 1;
                    elseif currEncRow > 80 %run3
                        objTimes_SF_pret(count_sf_pret,2) = 3;
                    else %run2
                        objTimes_SF_pret(count_sf_pret,2) = 2;
                    end
                    count_sf_pret = count_sf_pret+1;
                end
            end 
        end %pret if statement
    end %row loop
    
    % remove all those unneeded zeros
    objTimes_SR_cret( all(~objTimes_SR_cret,2), : ) = [];
    objTimes_SF_cret( all(~objTimes_SF_cret,2), : ) = [];
    objTimes_SR_pret( all(~objTimes_SR_pret,2), : ) = [];
    objTimes_SF_pret( all(~objTimes_SF_pret,2), : ) = [];

    %% make three-column tables. Four right now with enc run but we'll
    % remove that later
    col2= zeros(length(objTimes_SR_cret),1); %duration
    col3 = ones(length(objTimes_SR_cret),1); %include in the analysis
    SR_cret_tbl = table(objTimes_SR_cret(:,1),objTimes_SR_cret(:,2),col2,col3);
    SR_cret_tbl = renamevars(SR_cret_tbl,["Var1","Var2"],["ObjTime","EncRun"]);
    %SR_cret_tbl_sort = sortrows(SR_cret_tbl,{'EncRun','ObjTime'},{'ascend','ascend'});

    col2= zeros(length(objTimes_SF_cret),1); %duration
    col3 = ones(length(objTimes_SF_cret),1); %include in the analysis
    SF_cret_tbl = table(objTimes_SF_cret(:,1),objTimes_SF_cret(:,2),col2,col3);
    SF_cret_tbl = renamevars(SF_cret_tbl,["Var1","Var2"],["ObjTime","EncRun"]);
    %SF_cret_tbl_sort = sortrows(SF_cret_tbl,{'EncRun','ObjTime'},{'ascend','ascend'});

    col2= zeros(length(objTimes_SR_pret),1); %duration
    col3 = ones(length(objTimes_SR_pret),1); %include in the analysis
    SR_pret_tbl = table(objTimes_SR_pret(:,1),objTimes_SR_pret(:,2),col2,col3);
    SR_pret_tbl = renamevars(SR_pret_tbl,["Var1","Var2"],["ObjTime","EncRun"]);
    %SR_pret_tbl_sort = sortrows(SR_pret_tbl,{'EncRun','ObjTime'},{'ascend','ascend'});

    col2= zeros(length(objTimes_SF_pret),1); %duration
    col3 = ones(length(objTimes_SF_pret),1); %include in the analysis
    SF_pret_tbl = table(objTimes_SF_pret(:,1),objTimes_SF_pret(:,2),col2,col3);
    SF_pret_tbl = renamevars(SF_pret_tbl,["Var1","Var2"],["ObjTime","EncRun"]);
    %SF_pret_tbl_sort = sortrows(SF_pret_tbl,{'EncRun','ObjTime'},{'ascend','ascend'});

    %%% SR CRET
    % get the EncRun-specific rows
    SR_cret_run1 = SR_cret_tbl(SR_cret_tbl.EncRun==1,:);
    % remove the EncRun col
    SR_cret_run1 = removevars(SR_cret_run1,"EncRun");
    % sort so the ObjTimes are in order
    SR_cret_run1 = sortrows(SR_cret_run1,"ObjTime");

    %%% write to Box
    %subfolder = 'Automated_Onset_Files/';
    %if ~exist(subfolder,'dir'); mkdir(subfolder); end
    %%% write to the cluster when you run in matlab
    cluster_dir = sprintf('/Volumes/Data/Simon/NetTMS.01/Analysis/Univariate/%s/Onset_Files/',subject);
    if ~exist(cluster_dir,'dir'); mkdir(cluster_dir); end

    writetable(SR_cret_run1,strcat(cluster_dir,subject,'_Day',num2str(day),'_ENC_CMEM_SR_Run1.txt'),'Delimiter','\t','WriteVariableNames',false)
    % run 2
    SR_cret_run2 = SR_cret_tbl(SR_cret_tbl.EncRun==2,:);
    SR_cret_run2 = removevars(SR_cret_run2,"EncRun");
    SR_cret_run2 = sortrows(SR_cret_run2,"ObjTime");
    writetable(SR_cret_run2,strcat(cluster_dir,subject,'_Day',num2str(day),'_ENC_CMEM_SR_Run2.txt'),'Delimiter','\t','WriteVariableNames',false)
    % run 3
    SR_cret_run3 = SR_cret_tbl(SR_cret_tbl.EncRun==3,:);
    SR_cret_run3 = removevars(SR_cret_run3,"EncRun");
    SR_cret_run3 = sortrows(SR_cret_run3,"ObjTime");
    writetable(SR_cret_run3,strcat(cluster_dir,subject,'_Day',num2str(day),'_ENC_CMEM_SR_Run3.txt'),'Delimiter','\t','WriteVariableNames',false)
   
    %%% SF CRET
    % run 1
    SF_cret_run1 = SF_cret_tbl(SF_cret_tbl.EncRun==1,:);
    SF_cret_run1 = removevars(SF_cret_run1,"EncRun");
    SF_cret_run1 = sortrows(SF_cret_run1,"ObjTime");
    writetable(SF_cret_run1,strcat(cluster_dir,subject,'_Day',num2str(day),'_ENC_CMEM_SF_Run1.txt'),'Delimiter','\t','WriteVariableNames',false)
    % run 2
    SF_cret_run2 = SF_cret_tbl(SF_cret_tbl.EncRun==2,:);
    SF_cret_run2 = removevars(SF_cret_run2,"EncRun");
    SF_cret_run2 = sortrows(SF_cret_run2,"ObjTime");
    writetable(SF_cret_run2,strcat(cluster_dir,subject,'_Day',num2str(day),'_ENC_CMEM_SF_Run2.txt'),'Delimiter','\t','WriteVariableNames',false)
    % run 3
    SF_cret_run3 = SF_cret_tbl(SF_cret_tbl.EncRun==3,:);
    SF_cret_run3 = removevars(SF_cret_run3,"EncRun");
    SF_cret_run3 = sortrows(SF_cret_run3,"ObjTime");
    writetable(SF_cret_run3,strcat(cluster_dir,subject,'_Day',num2str(day),'_ENC_CMEM_SF_Run3.txt'),'Delimiter','\t','WriteVariableNames',false)
   
    %%% SR PRET
    SR_pret_run1 = SR_pret_tbl(SR_pret_tbl.EncRun==1,:);
    SR_pret_run1 = removevars(SR_pret_run1,"EncRun");
    SR_pret_run1 = sortrows(SR_pret_run1,"ObjTime");
    writetable(SR_pret_run1,strcat(cluster_dir,subject,'_Day',num2str(day),'_ENC_PMEM_SR_Run1.txt'),'Delimiter','\t','WriteVariableNames',false)
    % run 2
    SR_pret_run2 = SR_pret_tbl(SR_pret_tbl.EncRun==2,:);
    SR_pret_run2 = removevars(SR_pret_run2,"EncRun");
    SR_pret_run2 = sortrows(SR_pret_run2,"ObjTime");
    writetable(SR_pret_run2,strcat(cluster_dir,subject,'_Day',num2str(day),'_ENC_PMEM_SR_Run2.txt'),'Delimiter','\t','WriteVariableNames',false)
    % run 3
    SR_pret_run3 =SR_pret_tbl(SR_pret_tbl.EncRun==3,:);
    SR_pret_run3 = removevars(SR_pret_run3,"EncRun");
    SR_pret_run3 = sortrows(SR_pret_run3,"ObjTime");
    writetable(SR_pret_run3,strcat(cluster_dir,subject,'_Day',num2str(day),'_ENC_PMEM_SR_Run3.txt'),'Delimiter','\t','WriteVariableNames',false)
   
    %%% SF PRET
    SF_pret_run1 = SF_pret_tbl(SF_pret_tbl.EncRun==1,:);
    SF_pret_run1 = removevars(SF_pret_run1,"EncRun");
    SF_pret_run1 = sortrows(SF_pret_run1,"ObjTime");
    writetable(SF_pret_run1,strcat(cluster_dir,subject,'_Day',num2str(day),'_ENC_PMEM_SF_Run1.txt'),'Delimiter','\t','WriteVariableNames',false)
    % run 2
    SF_pret_run2 = SF_pret_tbl(SF_pret_tbl.EncRun==2,:);
    SF_pret_run2 = removevars(SF_pret_run2,"EncRun");
    SF_pret_run2 = sortrows(SF_pret_run2,"ObjTime");
    writetable(SF_pret_run2,strcat(cluster_dir,subject,'_Day',num2str(day),'_ENC_PMEM_SF_Run2.txt'),'Delimiter','\t','WriteVariableNames',false)
    % run 3
    SF_pret_run3 = SF_pret_tbl(SF_pret_tbl.EncRun==3,:);
    SF_pret_run3 = removevars(SF_pret_run3,"EncRun");
    SF_pret_run3 = sortrows(SF_pret_run3,"ObjTime");
    writetable(SF_pret_run3,strcat(cluster_dir,subject,'_Day',num2str(day),'_ENC_PMEM_SF_Run3.txt'),'Delimiter','\t','WriteVariableNames',false)

    toc

end % end day loop




