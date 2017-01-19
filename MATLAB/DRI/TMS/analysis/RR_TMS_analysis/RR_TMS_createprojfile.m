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
ruleRT = reshape(ruleRT,...
    (size(ruleRT,1)*size(ruleRT,2)*size(ruleRT,3)),1);

stimRT = reshape(stimRT,...
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

%preallocate arrays
evenodd = cell(size(data_cat,1),size(data_cat,3));
evenodd_stim = cell(size(data_cat,1),size(data_cat,3));
finger = cell(size(data_cat,1),size(data_cat,3));
symbol = cell(size(data_cat,1),size(data_cat,3));
ab = cell(size(data_cat,1),size(data_cat,3));
subj_resp = cell(size(data_cat,1),size(data_cat,3));

for s = 1:size(data_cat,3)  %by subjects
    
    for b = 1:size(data_cat,1)  %by blocks
        
        %whether even or odd was presented
        evenodd{b,s} = cell2mat(data_cat{b,2,s});
        evenodd{b,s}(:,2) = [];
        evenodd{b,s} = evenodd{b,s}-1; %0==Even; 1==Odd
        
        %whether the stimulus presented was even or odd
        stim_values{b,s} = data_cat{b,6,s};
        evenodd_stim{b,s} = mod(stim_values{b,s},2); %0==Even; 1==Odd
        
        %for finger trials, whether Index or Middle finger was presented
        finger{b,s} = cell2mat(data_cat{b,3,s});
        finger{b,s}(:,2) = [];
        finger{b,s} = finger{b,s}-1; %0==Index; 1==Middle
        
        %for symbol trials, whether A or B was presented
        symbol{b,s} = cell2mat(data_cat{b,4,s});
        symbol{b,s}(:,2) = [];
        symbol{b,s} = symbol{b,s}-1; %0==A; 1==B
        
        %placement of A and B on the stimulus screen
        ab{b,s} = cell2mat(data_cat{b,5,s});
        ab{b,s}(:,2) = [];
        ab{b,s} = ab{b,s}-1; %0==A was on left; 1==A was on right
        
        %the subject's response
        subj_resp{b,s} = data_cat{b,8,s};
        
        %subject block id
        block_id{b,s} = data_cat{b,9,s};
        
    end
end

%0==inferred; 1==instructed
infins_trials = cellfun(@(x,y) eq(x,y), evenodd, evenodd_stim, 'UniformOutput', false);

%reshape it to enter into data table
infins_trials = cell2mat(infins_trials);
infins_trials = reshape(infins_trials,(size(infins_trials,1)*size(infins_trials,2)),1);

%get s/f trial index and reshape to enter into data table
%0==symbol 1==finger
sf_trials = squeeze(cell2mat(data_cat(:,1,:)));
sf_trials = reshape(sf_trials,(size(sf_trials,1)*size(sf_trials,2)),1);

%get PMd/Vertex trial index and reshape to enter into data table
%0==PMd 1==Vertex
pmdver_trials = squeeze(cell2mat(data_cat(:,10,:)));
pmdver_trials = reshape(pmdver_trials,(size(pmdver_trials,1)*size(pmdver_trials,2)),1);

%get Early/Late/No stimulation trial index and reshape to enter into data
%table
%0==early, 1==late, 2==no stimulation
eslsns_trials = squeeze(cell2mat(data_cat(:,7,:)));
eslsns_trials = reshape(eslsns_trials,(size(eslsns_trials,1)*size(eslsns_trials,2)),1);

%reshape subject responses to enter into data table
subj_resp = vertcat(subj_resp{:,:});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%add additional trial conditions for further inquiry

%whether even or odd was presented
%0==Even; 1==Odd
evenodd = cell2mat(evenodd);
evenodd = reshape(evenodd,(size(evenodd,1)*size(evenodd,2)),1);

%for finger trials, whether Index or Middle finger was presented
%0==Index; 1==Middle
finger = cell2mat(finger);
finger = reshape(finger,(size(finger,1)*size(finger,2)),1);

%for symbol trials, whether A or B was presented
%0==A; 1==B
symbol = cell2mat(symbol);
symbol = reshape(symbol,(size(symbol,1)*size(symbol,2)),1);

%replace symbol trials with NaN in finger and viceversa in symbol
finger(sf_trials==0) = NaN;
symbol(sf_trials==1) = NaN;

%value of the stimulus presented
stim_values = cell2mat(stim_values);
stim_values = reshape(stim_values,(size(stim_values,1)*size(stim_values,2)),1);

%parity of the stimulus presented
%0==Even; 1==Odd
evenodd_stim = cell2mat(evenodd_stim);
evenodd_stim = reshape(evenodd_stim,(size(evenodd_stim,1)*size(evenodd_stim,2)),1);

%placement of A and B on the stimulus screen
%0==A was on left; 1==A was on right
ab = cell2mat(ab);
ab = reshape(ab,(size(ab,1)*size(ab,2)),1);

%block id number
block_id = cell2mat(block_id);
block_id = reshape(block_id,(size(block_id,1)*size(block_id,2)),1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%TODO: rather than combining subconditions in a vector (i.e. sf_trials
%where 0==symbol and 1==finger), just have vectors for each subcondition
%(so, [symbol_trials] where 0==it wasn't a symbol trial and 1==it was a
%symbol trial). Might make indexing easier later on?

% [f,xi] = ksdensity(RT DATA);
% plot(xi,f)
%above will give you RT density plots that you were looking for (?)



%create data table
dtable = table(subj_ids,block_id,tnum_subjblock,ruleRT,stimRT,...
    sf_trials,pmdver_trials,eslsns_trials,infins_trials,evenodd,finger,...
    symbol,stim_values,evenodd_stim,ab,subj_resp);

%take care of remaining exceptions for 2406 block 1 (see Expt_record.xlsx)
dtable.pmdver_trials(find(dtable.block_id==1 & dtable.subj_ids==2406)) = nan;
dtable.infins_trials = double(dtable.infins_trials);
dtable.infins_trials(find(dtable.block_id==1 & dtable.subj_ids==2406)) = nan;

%from elements contained in dtable, determine what the correct answer
%should have been for each trial
RR_TMS_table_correctans

%compare the correct answer to the subject's answer
%take care of 2406 block1
success = double(strcmp(dtable.subj_resp,dtable.correctans));

%quickly index 2406 block 1 trials
s2406_b1_idx = find(dtable.subj_ids==2406 & dtable.block_id==1);
%nan these "successes"
success(s2406_b1_idx) = nan;

%add to dtable
dtable.success = success;

%clear all vars except dtable and datapath
clearvars -except dtable datapath

%save
save(strcat(datapath, '/RR_TMS_Table.mat'))













