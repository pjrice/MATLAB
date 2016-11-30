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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%next, preprocessing

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%correct all timestamps to trialstart time
%ts_corr is trials x events x blocks x subjects
ts_corr = zeros(size(ts_cat));
for s = 1:size(ts_cat,4)
    
    ts_corr(:,:,:,s) = gsubtract(ts_cat(:,:,:,s),ts_cat(:,1,:,s));
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%get response times
%ruleRT/stimRT is trials x blocks x subjects
ruleRT = zeros(size(ts_corr,1),size(ts_corr,3),size(ts_corr,4));
stimRT = zeros(size(ts_corr,1),size(ts_corr,3),size(ts_corr,4));
for s = 1:size(ts_cat,4)
    
    ruleRT(:,:,s) = gsubtract(ts_corr(:,5,:,s),ts_corr(:,4,:,s));
    stimRT(:,:,s) = gsubtract(ts_corr(:,9,:,s),ts_corr(:,8,:,s));
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%determine whether trials were instructed or inferred

%cell2mat(data{1,2,1}) to get even/odd presentation
%convert into 0/1 in order to compare

evenodd = cell(size(data_cat,1),size(data_cat,3));
evenodd_stim = cell(size(data_cat,1),size(data_cat,3));
finger = cell(size(data_cat,1),size(data_cat,3));
symbol = cell(size(data_cat,1),size(data_cat,3));
ab = cell(size(data_cat,1),size(data_cat,3));
subj_resp = cell(size(data_cat,1),size(data_cat,3));

for s = 1:size(data_cat,3)  %by subjects
    
    for b = 1:size(data_cat,1)  %by blocks
        
        evenodd{b,s} = cell2mat(data_cat{b,2,s});
        evenodd{b,s}(:,2) = [];
        evenodd{b,s} = evenodd{b,s}-1; %0==Even; 1==Odd
        
        evenodd_stim{b,s} = data_cat{b,6,s};
        evenodd_stim{b,s} = mod(evenodd_stim{b,s},2); %0==Even; 1==Odd
        
        finger{b,s} = cell2mat(data_cat{b,3,s});
        finger{b,s}(:,2) = [];
        finger{b,s} = finger{b,s}-1; %0==Index; 1==Middle
        
        symbol{b,s} = cell2mat(data_cat{b,4,s});
        symbol{b,s}(:,2) = [];
        symbol{b,s} = symbol{b,s}-1; %0==Index; 1==Middle
        
        ab{b,s} = cell2mat(data_cat{b,4,s});
        ab{b,s}(:,2) = [];
        ab{b,s} = ab{b,s}-1; %0==Index; 1==Middle
        
        subj_resp{b,s} = data_cat{b,8,s};
        
    end
end

%0==inferred; 1==instructed
inst_inf = cellfun(@(x,y) eq(x,y), evenodd, evenodd_stim, 'UniformOutput', false);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%make indicies of individual trial conditions (sym/fin, es/ls/ns, inst/inf)
sf_trials = cell(size(data_cat,1),size(data_cat,3),length(unique([data_cat{:,1,1}])));
eslsns_trials = cell(size(data_cat,1),size(data_cat,3),length(unique([data_cat{:,7,1}])));
pmdver_trials = cell(size(data_cat,1),size(data_cat,3),length(unique([data_cat{:,10,1}])));
infins_trials = cell(size(data_cat,1),size(data_cat,3),2);

for s = 1:size(ts_cat,4) %by subjects
    
    for i = 1:size(ts_cat,3) %by blocks
        
        %indices of sym/fin trials (data_cat{:,1,:})
        %trials x blocks x subjects
        sf_trials{i,s,1} = find(data_cat{i,1,s}==0);  %symbol trial index
        sf_trials{i,s,2} = find(data_cat{i,1,s}==1);  %finger trial index
        
        %indices of es/ls/ns trials (data_cat{:,7,:})
        %trials x blocks x subjects
        eslsns_trials{i,s,1} = find(data_cat{i,7,s}==0); %early stim trials index
        eslsns_trials{i,s,2} = find(data_cat{i,7,s}==1);  %late stim trials index
        eslsns_trials{i,s,3} = find(data_cat{i,7,s}==2);  %no stim trials index
        
        %indices of PMd/Vertex trials (data_cat{:,10,:})
        %trials x blocks x subjects
        if isempty(find(data_cat{i,10,s}==0)) %#ok<EFIND>
            
            pmdver_trials{i,s,1} = nan(size(ts_cat,1),1);
            pmdver_trials{i,s,2} = find(data_cat{i,10,s}==1);
            
        else
            
            pmdver_trials{i,s,1} = find(data_cat{i,10,s}==0);
            pmdver_trials{i,s,2} = nan(size(ts_cat,1),1);
            
        end
        
        %indices of instr/inf trials (evenoddchooser and mod(data{:,6,:})
        inf_ph = find(inst_inf{i,s}==0);  %inferred trials index
        ins_ph = find(inst_inf{i,s}==1);  %instructed trials index
        
        infins_trials{i,s,1} = inf_ph;  %inferred trials index
        infins_trials{i,s,2} = ins_ph;  %instructed trials index
        
        clear inf_ph ins_ph
          
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%script to get the correct answer for every trial
RR_TMS_correctans

%compares correct answers to subject answers to determine success rates
success = cellfun(@(x,y) strcmp(x,y), correctans, subj_resp, 'UniformOutput', false);

%quick metrics? (Success rate by subject, by PMd/Vertex, etc...)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%function idea: RR_TMS_3dbarplot() takes at least 2 required arguments (trial
%indices for 2 conditions) and a paired optional argument (error trial
%index, and string flag to plot successful trials or error trials)
%  -if optional arg is present, masks the indicated trials, else plots all
%  -finds mean and sem of trials shared by condition
%  -plots on a 3d barplot
%  -make condition trial indices paged to make this easier

%can also create an RR_TMS_2dbarplot() to do the same thing for 2d barplots





%after those made, get differences between conditions to reduce
%dimensionality and make more sensible plots (or just do this first??? but
%it would be helpful to see the plots to make the differences)

%TODO
%error rates
%RT differences
%skip beginning if file exists














