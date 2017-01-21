

%I think this is money

%get all stim trials
stimIdx = find(dtable.success==1 &...
    dtable.eslsns_trials~=2);


y = dtable.stimRT(stimIdx);

SF = dtable.sf_trials(stimIdx);
PV = dtable.pmdver_trials(stimIdx);
EL = dtable.eslsns_trials(stimIdx);
InfIns = dtable.infins_trials(stimIdx);
subj = dtable.subj_ids(stimIdx);

[~,~,stats] = anovan(y,{SF PV EL InfIns},'model','full',...
    'varnames',{'SF','PV','EL','InfIns'});


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
























