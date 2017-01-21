

%I think this is money

%get all stim trials
stimIdx = find(dtable.success==1 &...
    dtable.eslsns_trials~=2);

%make data vector
y = dtable.stimRT(stimIdx);

%make condition indices
SF = dtable.sf_trials(stimIdx);
PV = dtable.pmdver_trials(stimIdx);
EL = dtable.eslsns_trials(stimIdx);
InfIns = dtable.infins_trials(stimIdx);

%run ANOVA
[~,~,stats] = anovan(y,{SF PV EL InfIns},'model','full',...
    'varnames',{'SF','PV','EL','InfIns'});

%do multiple comparisons
figure(1)
results = multcompare(stats,'Dimension',[1]);
figure(2)
results = multcompare(stats,'Dimension',[2]);
figure(3)
results = multcompare(stats,'Dimension',[3]);
figure(4)
results = multcompare(stats,'Dimension',[4]);


figure(5)
results = multcompare(stats,'Dimension',[1 2]);
figure(6)
results = multcompare(stats,'Dimension',[1 3]);
figure(7)
results = multcompare(stats,'Dimension',[1 4]);
figure(8)
results = multcompare(stats,'Dimension',[2 3]);
figure(9)
results = multcompare(stats,'Dimension',[2 4]);
figure(10)
results = multcompare(stats,'Dimension',[3 4]);

figure(11)
results = multcompare(stats,'Dimension',[1 2 3]);
figure(12)
results = multcompare(stats,'Dimension',[1 2 4]);
figure(13)
results = multcompare(stats,'Dimension',[1 3 4]);
figure(14)
results = multcompare(stats,'Dimension',[2 3 4]);

figure(15)
results = multcompare(stats,'Dimension',[1 2 3 4]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Test ALL Vertex stim trials against ALL no stim trials
nsVsidx = find(dtable.success==1 &... %successes and...
    dtable.pmdver_trials==1 |... %vertex trials or...
    dtable.eslsns_trials==2); %all no stim trials

y = dtable.stimRT(nsVsidx);

ELN = dtable.eslsns_trials(nsVsidx);

[~,~,stats] = anovan(y,{ELN},'model','full',...
    'varnames',{'ELN'});

multcompare(stats,'Dimension',[1])

%this shows that both early vertex and late vertex stimulation trials are
%not different than PMd/Vertex no stimulation trials


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%the following is probably fucked because I was haphazardly testing

%test no stim against vertex stim

%get trials to test
nsVs_idx = find(dtable.success==1 &... %successes and...
    (dtable.eslsns_trials==2 |... %no stim trials or...
    (dtable.pmdver_trials==1 & dtable.eslsns_trials~=2))); %vertex stim trials

%make data vector
y = dtable.stimRT(nsVs_idx);

%make "stimmed or not stimmed" vector
nsVs = dtable.eslsns_trials(nsVs_idx);
% sIdx = find(nsVs~=2);
% nsIdx = find(nsVs==2);
% nsVs(sIdx) = 1; %1 indexes Vstim trials
% nsVs(nsIdx) = 0; %0 indexes nostim trials

%make other condition indices
SF = dtable.sf_trials(nsVs_idx);
InfIns = dtable.infins_trials(nsVs_idx);


% [~,~,stats] = anovan(y,{nsVs},'model','full',...
%     'varnames',{'nsVs'});
nsVs_idx = find(dtable.success==1 &... %successes and...
    (dtable.eslsns_trials==2 |... %no stim trials or...
    (dtable.pmdver_trials==1 & dtable.eslsns_trials~=2))); %vertex stim trial

%make data vector
y = dtable.stimRT(nsVs_idx);

SF = dtable.sf_trials(nsVs_idx);
PV = dtable.pmdver_trials(nsVs_idx);
ELN = dtable.eslsns_trials(nsVs_idx);
InfIns = dtable.infins_trials(nsVs_idx);

[~,~,stats] = anovan(y,{SF PV ELN InfIns},'model','full',...
    'varnames',{'SF','PV','EL','InfIns'});
[~,~,stats] = anovan(y,{SF nsVs InfIns},'model','full',...
    'varnames',{'SF','nsVs','InfIns'});

multcompare(stats,'Dimension',[2])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%in "actual" analysis (aka comparing PMd trials to something else), replace
%Vertex stim trials with PMd no stim trials and see what's up






