%script to split up 70bf0c SEM ECoG data into individual trial vectors

%get the filenames
% behavfile = 'Z:\Work\UW\projects\SEM\ECoG\70bf0c\behav\70bf0c_sem.mat';
% brainbasepath = 'Z:\Work\UW\projects\SEM\ECoG\70bf0c\brain\';
% filelist = dir('Z:\Work\UW\projects\SEM\ECoG\70bf0c\brain\70bf0c_SEM_*.mat');

% behavfile = 'Z:\Work\UW\projects\DRI\ECoG\70bf0c\behav\70bf0c_DRI.mat';
% brainbasepath = 'Z:\Work\UW\projects\DRI\ECoG\70bf0c\brain\';
% filelist = dir('Z:\Work\UW\projects\DRI\ECoG\70bf0c\brain\70bf0c_DRI_*.mat');

behavfile = 'Z:\Work\UW\projects\MAZE\ECoG\70bf0c\behav\70bf0c_MAZE.mat';
brainbasepath = 'Z:\Work\UW\projects\MAZE\ECoG\70bf0c\brain\';
filelist = dir('Z:\Work\UW\projects\MAZE\ECoG\70bf0c\brain\70bf0c_MAZE_*.mat');

%load the behavioral data (one file)
load(behavfile,'timestamps','stepper_ts','subj_resp','TDT_recording_start','TDT_recording_stop')

%need sampling rate to determine ts of events - equal across all channels
%in this dataset, so load once
load(strcat(brainbasepath,filelist(1).name),'fs')

%do things to timestamps
%ts(:,1)==trial start
%ts(:,2)==disp of enter screen
%ts(:,3)==resp to enter
%ts(:,4)==trial stop

%stepper_ts is a 4D trials X [100 possible steps] X [disp of entered room, resp to leave room] X blocks cell array
ts_corr = gsubtract(timestamps,TDT_recording_start);
sts_corr = gsubtract(stepper_ts,TDT_recording_start);

%this is certainly wrong
ts_rec_start = 1; %recording starts at the first sample
ts_rec_stop = (TDT_recording_stop-TDT_recording_start)*fs; %last sample?

%get ts of events in samples rather than seconds
ts_samp = ts_corr.*fs;
sts_samp = gmultiply(sts_corr,fs);


for f = 1:length(filelist)
    
    load(strcat(brainbasepath,filelist(f).name))
    
    brain_area = filelist(f).name(end-6:end-4);
    
    %preallocate
    trial_data = cell(size(despiked,2),length(ts_samp));
    
    %split despiked into individual trial vectors
    for iii = 1:size(ts_samp,3)
    
        for i = 1:size(despiked,2)
            
            for ii = 1:length(ts_samp)
                
                %channels X trials X blocks cell array with trial vectors
                trial_data{i,ii,iii} = despiked(ts_samp(ii,1,iii):ts_samp(ii,4,iii),i);
                
            end
        end
    end
    
    %save everything important!!! 
    newfile = strcat(brainbasepath,filelist(f).name(1:end-4),'_trials.mat');
    save(newfile,'ts_corr','ts_samp','subj_resp','brain_area','trial_data','fs')
    
    clearvars -except behavfile brainbasepath f filelist fs subj_resp ts_corr ts_samp
    
end