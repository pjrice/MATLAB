%batch script to process RR_TMS behavioral data
%actually do it for realsies, make it flexible so if we collect more data
%you can run it once and get everything again
%then, use as a base to replicate into python and R

datapath = uigetdir;
cd(datapath)
subj_folders = dir;

%first, concatenate the individual subject block files into one file for
%each subject, then concatenate the subject files into one group file

%dropped subj 2406 due to coil drifting off target in first block; can
%manually add blocks 2,3,4 later if we want to

%cat indiv subj block files
for i = 3:length(subj_folders)%3:length() because first two are . and ..
    
    RR_TMS_filecat(datapath,subj_folders(i).name)
    
end

%cat subj files into group file
fname = RR_TMS_catcat(datapath);

%load the newly created file
load(fname)

%next, preprocessing

%correct all timestamps to trialstart time
%ts_corr is trials x events x blocks x subjects
ts_corr = zeros(size(ts_cat));
for s = 1:size(ts_cat,4)
    
    ts_corr(:,:,:,s) = gsubtract(ts_cat(:,:,:,s),ts_cat(:,1,:,s));
    
end


%get response times
%ruleRT/stimRT is trials x blocks x subjects
ruleRT = zeros(size(ts_corr,1),size(ts_corr,3),size(ts_corr,4));
stimRT = zeros(size(ts_corr,1),size(ts_corr,3),size(ts_corr,4));
for s = 1:size(ts_cat,4)
    
    ruleRT(:,:,s) = gsubtract(ts_corr(:,5,:,s),ts_corr(:,4,:,s));
    stimRT(:,:,s) = gsubtract(ts_corr(:,9,:,s),ts_corr(:,8,:,s));
    
end

%make indicies of individual trial conditions (sym/fin, es/ls/ns, inst/inf)
% indices of sym/fin trials (data_cat{:,1,:})
% indices of es/ls/ns trials (data_cat{:,7,:}
% indices of PMd/Vertex trials (blockid_cat)
% indices of instr/inf trials (evenoddchooser and mod(data{:,6,:})
% use intersect() to find shared trials to plot



%find successful trials and error trials

%make plots along different dimensions of condition space
%condition space 4d (es/ls/ns X PMd/Vertex X sym/fin X inst/inf)
%3d bar plot?
%es/ls/ns X PMd/Vertex X inst/inf; es/ls/ns X PMd/Vertex X sym/fin; 
%sym/fin X instr/inf X PMd/Vertex; etc etc etc... 

%after those made, get differences between conditions to reduce
%dimensionality and make more sensible plots (or just do this first??? but
%it would be helpful to see the plots to make the differences)
