%script to split up 70bf0c SEM ECoG data into individual trial vectors

%get the filenames
behavfile = 'Z:\Work\UW\projects\SEM\ECoG\70bf0c\behav\70bf0c_sem.mat';
brainbasepath = 'Z:\Work\UW\projects\SEM\ECoG\70bf0c\brain\';
filelist = dir('Z:\Work\UW\projects\SEM\ECoG\70bf0c\brain\70bf0c_SEM_*.mat');

% basepath = 'Z:\Work\UW\projects\DRI\ECoG\70bf0c\brain\';
% filelist = dir('Z:\Work\UW\projects\DRI\ECoG\70bf0c\brain\70bf0c_DRI_*.mat');

% basepath = 'Z:\Work\UW\projects\MAZE\ECoG\70bf0c\brain\';
% filelist =
% dir('Z:\Work\UW\projects\MAZE\ECoG\70bf0c\brain\70bf0c_MAZE_*.mat');.

%load the behavioral data (one file)
load(behavfile,'timestamps','subj_resp','TDT_recording_start','TDT_recording_stop')

%need sampling rate to determine ts of events - equal across all channels
%in this dataset, so load once
load(strcat(brainbasepath,filelist(1).name),'fs')

%do things to timestamps
%ts(:,1)==trial start
%ts(:,2)==fix presentation
%ts(:,3)==stimulus presentation
%ts(:,4)==ts of subj resp
%ts(:,5)==trial end

%correct all timestamps to TDT_recording_start
ts_corr = gsubtract(timestamps,TDT_recording_start);

%this shit is certainly wrong
ts_rec_start = 1; %recording starts at the first sample
ts_rec_stop = (TDT_recording_stop-TDT_recording_start)*fs; %last sample?

%get ts of events in samples rather than seconds
ts_samp = ts_corr.*fs;


for f = 1:length(filelist)
    
    load(strcat(brainbasepath,filelist(f).name))
    
    brain_area = filelist(f).name(end-6:end-4);
    
%     %because I was dumb and labeled each dataset 'XXX_data'
%     data = despiked;
    
    %preallocate
    trial_data = cell(size(despiked,1),length(ts_samp));
    
    %split despiked into individual trial vectors
    for i = 1:size(despiked,1)
        
        for ii = 1:length(ts_samp)
        
            %channels X trials cell array with trial vectors
            trial_data{i,ii} = despiked(i,ts_samp(ii,1):ts_samp(ii,5));
            
        end
    end
    
    %save everything important!!!
    %saves with x in from front of file name because matlab does not allow 
    newfile = strcat(brainbasepath,filelist(f).name(1:end-4),'_trials.mat');
    save(newfile,'ts_corr','ts_samp','subj_resp','brain_area','trial_data','fs')
    
    clearvars -except behavfile brainbasepath f filelist fs subj_resp ts_corr ts_samp
    
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    