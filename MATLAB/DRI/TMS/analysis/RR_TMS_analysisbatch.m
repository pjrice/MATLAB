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

for s = 1:size(data_cat,3)
    
    for b = 1:size(data_cat,1)
        
        evenodd{b,s} = cell2mat(data_cat{b,2,s});
        evenodd{b,s}(:,2) = [];
        evenodd{b,s} = evenodd{b,s}-1; %0==Even; 1==Odd
        
    end
end

%data{1,6,1} for actual stimulus number
%do the mod trick to determine even/odd

evenodd_stim = cell(size(data_cat,1),size(data_cat,3));

for s = 1:size(data_cat,3)
    
    for b = 1:size(data_cat,1)
        
        evenodd_stim{b,s} = data_cat{b,6,s};
        evenodd_stim{b,s} = mod(evenodd_stim{b,s},2); %0==Even; 1==Odd
        
    end
end

%0==inferred; 1==instructed
inst_inf = cellfun(@(x,y) eq(x,y), evenodd, evenodd_stim, 'UniformOutput', false);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%make indicies of individual trial conditions (sym/fin, es/ls/ns, inst/inf)
s_trials = nan(size(ts_cat,1)/length(unique([data_cat{:,1,1}])),size(ts_cat,3),size(ts_cat,4));
f_trials = nan(size(ts_cat,1)/length(unique([data_cat{:,1,1}])),size(ts_cat,3),size(ts_cat,4));
es_trials = nan(size(ts_cat,1)/length(unique([data_cat{:,7,1}])),size(ts_cat,3),size(ts_cat,4));
ls_trials = nan(size(ts_cat,1)/length(unique([data_cat{:,7,1}])),size(ts_cat,3),size(ts_cat,4));
ns_trials = nan(size(ts_cat,1)/length(unique([data_cat{:,7,1}])),size(ts_cat,3),size(ts_cat,4));
pmd_trials = nan(size(ts_cat,1),size(ts_cat,3),size(ts_cat,4));
ver_trials = nan(size(ts_cat,1),size(ts_cat,3),size(ts_cat,4));
inf_trials = nan(size(ts_cat,1),size(ts_cat,3),size(ts_cat,4));
ins_trials = nan(size(ts_cat,1),size(ts_cat,3),size(ts_cat,4));

for s = 1:size(ts_cat,4) %by subjects
    
    for i = 1:size(ts_cat,3) %by blocks
        
        %indices of sym/fin trials (data_cat{:,1,:})
        %trials x blocks x subjects
        s_trials(:,i,s) = find(data_cat{i,1,s}==0);  %symbol trial index
        f_trials(:,i,s) = find(data_cat{i,1,s}==1);  %finger trial index
        
        %indices of es/ls/ns trials (data_cat{:,7,:})
        %trials x blocks x subjects
        es_trials(:,i,s) = find(data_cat{i,7,s}==0); %early stim trials index
        ls_trials(:,i,s) = find(data_cat{i,7,s}==1);  %late stim trials index
        ns_trials(:,i,s) = find(data_cat{i,7,s}==2);  %no stim trials index
        
        %indices of PMd/Vertex trials (data_cat{:,10,:})
        %trials x blocks x subjects
        if isempty(find(data_cat{i,10,s}==0)) %#ok<EFIND>
            
            pmd_trials(:,i,s) = nan(size(ts_cat,1),1);
            ver_trials(:,i,s) = find(data_cat{i,10,s}==1);
            
        else
            
            pmd_trials(:,i,s) = find(data_cat{i,10,s}==0);
            ver_trials(:,i,s) = nan(size(ts_cat,1),1);
            
        end
        
        %indices of instr/inf trials (evenoddchooser and mod(data{:,6,:})
        inf_ph = find(inst_inf{i,s}==0);  %inferred trials index
        ins_ph = find(inst_inf{i,s}==1);  %instructed trials index
        
        inf_trials(1:length(inf_ph),i,s) = inf_ph;  %inferred trials index
        ins_trials(1:length(ins_ph),i,s) = ins_ph;  %instructed trials index
        
        clear inf_ph ins_ph
          
    end
end


% use RR_TMS_intersect() to find shared trials to plot


%find successful trials and error trials
%aka have to figure out what the answer should have been, and compare that
%to the answer given

%whether even or odd was presented already determined in:
%evenodd %0==Even; 1==Odd

%whether the stimulus was even or odd was already determined in:
%evenodd_stim %0==Even; 1==Odd

%determine whether index or middle finger was displayed for finger trials
finger = cell(size(data_cat,1),size(data_cat,3));

for s = 1:size(data_cat,3)
    
    for b = 1:size(data_cat,1)
        
        finger{b,s} = cell2mat(data_cat{b,3,s});
        finger{b,s}(:,2) = [];
        finger{b,s} = finger{b,s}-1; %0==Index; 1==Middle
        
    end
end

%determine whether A or B was displayed for symbol trials
symbol = cell(size(data_cat,1),size(data_cat,3));

for s = 1:size(data_cat,3)
    
    for b = 1:size(data_cat,1)
        
        symbol{b,s} = cell2mat(data_cat{b,4,s});
        symbol{b,s}(:,2) = [];
        symbol{b,s} = symbol{b,s}-1; %0==Index; 1==Middle
        
    end
end

%determine whether A was on left or right side
ab = cell(size(data_cat,1),size(data_cat,3));

for s = 1:size(data_cat,3)
    
    for b = 1:size(data_cat,1)
        
        ab{b,s} = cell2mat(data_cat{b,4,s});
        ab{b,s}(:,2) = [];
        ab{b,s} = ab{b,s}-1; %0==Index; 1==Middle
        
    end
end






%mask error trials to make RT plots






%make plots along different dimensions of condition space
%condition space 4d (es/ls/ns X PMd/Vertex X sym/fin X inst/inf)
%3d bar plot?
%es/ls/ns X PMd/Vertex X inst/inf; es/ls/ns X PMd/Vertex X sym/fin; 
%sym/fin X instr/inf X PMd/Vertex; etc etc etc... 

%after those made, get differences between conditions to reduce
%dimensionality and make more sensible plots (or just do this first??? but
%it would be helpful to see the plots to make the differences)
