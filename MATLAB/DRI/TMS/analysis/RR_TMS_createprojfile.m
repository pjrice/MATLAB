%from project file, create table containing all relevant information

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

%reshape ruleRT and stimRT to enter into data table
r_ruleRT = reshape(ruleRT,...
    (size(ruleRT,1)*size(ruleRT,2)*size(ruleRT,3)),1);

r_stimRT = reshape(stimRT,...
    (size(stimRT,1)*size(stimRT,2)*size(stimRT,3)),1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%make quick vector of trial num within subj block to enter into data table
tnum_subjblock = repmat([1:size(ts_corr,1)]',...
    (size(ts_corr,3)*size(ts_corr,4)),1);

%repmat subj_ids to enter into data table
subj_ids = str2num(subj_ids);
subj_ids = reshape(repmat(subj_ids,1,(size(ts_corr,1)*size(ts_corr,3)))'...
    ,(size(ts_corr,1)*size(ts_corr,3)*size(ts_corr,4)),1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%make indicies of individual trial conditions (sym/fin, es/ls/ns, inf/ins)

%first, determine if trials were inf/ins
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
        symbol{b,s} = symbol{b,s}-1; %0==A; 1==B
        
        ab{b,s} = cell2mat(data_cat{b,5,s});
        ab{b,s}(:,2) = [];
        ab{b,s} = ab{b,s}-1; %0==A was on left; 1==A was on right
        
        subj_resp{b,s} = data_cat{b,8,s};
        
    end
end

%0==inferred; 1==instructed
infins_trials = cellfun(@(x,y) eq(x,y), evenodd, evenodd_stim, 'UniformOutput', false);

%reshape it to enter into data table
infins_trials = cell2mat(infins_trials);
infins_trials = reshape(infins_trials,(size(infins_trials,1)*size(infins_trials,2)),1);

%get s/f trial index and reshape to enter into data table
sf_trials = squeeze(cell2mat(data_cat(:,1,:)));
sf_trials = reshape(sf_trials,(size(sf_trials,1)*size(sf_trials,2)),1);

%get PMd/Vertex trial index and reshape to enter into data table
pmdver_trials = squeeze(cell2mat(data_cat(:,10,:)));
pmdver_trials = reshape(pmdver_trials,(size(pmdver_trials,1)*size(pmdver_trials,2)),1);

%get Early/Late/No stimulation trial index and reshape to enter into data
%table
eslsns_trials = squeeze(cell2mat(data_cat(:,7,:)));
eslsns_trials = reshape(eslsns_trials,(size(eslsns_trials,1)*size(eslsns_trials,2)),1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%create data table
RR_TMS_Table = table(tnum_subjblock,subj_ids,r_ruleRT,r_stimRT,...
    sf_trials,pmdver_trials,eslsns_trials,infins_trials);















