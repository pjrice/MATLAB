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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%create data table
T = table(tnum_subjblock,subj_ids,r_ruleRT,r_stimRT);