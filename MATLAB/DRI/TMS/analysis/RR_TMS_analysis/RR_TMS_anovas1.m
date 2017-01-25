%ANOVAs for DRI

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Determine whether no stim trials are different than Vertex stim trials

%3 factor repeated measures ANOVA (2x2x2), only CORRECT ns and vertex stim
%trials

%do for both ruleRT and stimRT

%Factors/levels: 1. S/F; 2. Inf/Ins; 3. whether or not they had received a
%stimulation by that time point (rule/stimRT) in the trial (levels:
%ns/vertex stim)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%get index of the trials we want to examine
tIdx = find(dtable.success==1 &...  %find successes
    (dtable.pmdver_trials==1 | ...  %and vertex trials
    (dtable.pmdver_trials==0 & dtable.eslsns_trials==2))); %or no stim pmd trials

%make "stimmed or not stimmed" vector indexing whether they had been
%stimmed on that trial or not
vsNS = dtable.eslsns_trials(tIdx);

sIdx = find(vsNS~=2);
nsIdx = find(vsNS==2);

vsNS(sIdx) = 0;
vsNS(nsIdx) = 1;

%make data vector
y = dtable.stimRT(tIdx);

%make other condition index vectors
SF = dtable.sf_trials(tIdx);Rule:Site
InfIns = dtable.infins_trials(tIdx);

%run ANOVA
[~,~,stats] = anovan(y,{SF vsNS InfIns},'model','interaction',...
    'varnames',{'SF','vsNS','InfIns'});

%do comparisons
figure(2)
results = multcompare(stats,'Dimension',[1 2]);
figure(3)
results1 = multcompare(stats,'Dimension',[1 3]);
figure(4)
results2 = multcompare(stats,'Dimension',[2 3]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%two-way ANOVAs

%all successes

%get all stim trials
stimIdx = find(dtable.success==1 &...
    dtable.eslsns_trials~=2);

%SF, PV
stats_SFPV = RR_TMS_ANOVA1(dtable,stimIdx,5,[6 7]);

%SF, EL
stats_SFEL = RR_TMS_ANOVA1(dtable,stimIdx,5,[6 8]);

%SF, InfIns
stats_SFII = RR_TMS_ANOVA1(dtable,stimIdx,5,[6 9]);

%PV, EL
stats_PVEL = RR_TMS_ANOVA1(dtable,stimIdx,5,[7 8]);

%PV, InfIns
stats_PVII = RR_TMS_ANOVA1(dtable,stimIdx,5,[7 9]);

%EL, InfIns
stats_ELII = RR_TMS_ANOVA1(dtable,stimIdx,5,[8 9]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%drop other trials?

%three-way ANOVAs
%SF, PV, EL
stats_SFPVEL = RR_TMS_ANOVA1(dtable,stimIdx,5,[6 7 8]);

%SF, PV, InfIns
stats_SFPVII = RR_TMS_ANOVA1(dtable,stimIdx,5,[6 7 9]);

%SF, EL, InfIns
stats_SFELII = RR_TMS_ANOVA1(dtable,stimIdx,5,[6 8 9]);

%PV, EL, InfIns
stats_PVELII = RR_TMS_ANOVA1(dtable,stimIdx,5,[7 8 9]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%four-way ANOVA
stats_all = RR_TMS_ANOVA1(dtable,stimIdx,5,[6Rule:Site 7 8 9]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%try repeated measures anova with SF PV EL InfINs as predictors
%with means table from RR_TMS_Rtable4ANOVA
%check that you are indexing trials in that script properly


% Create a table reflecting the within subject factors 'S/F', 
%'Inf/Ins', and 'ns/Vstim' and their levels
factorNames = {'SF','PV','EL','InfIns'};

within = table({'S';'S';'S';'S';'S';'S';'S';'S';'F';'F';'F';'F';'F';'F';'F';'F'},...
    {'P';'P';'P';'P';'V';'V';'V';'V';'P';'P';'P';'P';'V';'V';'V';'V'},...
    {'E';'E';'L';'L';'E';'E';'L';'L';'E';'E';'L';'L';'E';'E';'L';'L'},...
    {'Inf';'Ins';'Inf';'Ins';'Inf';'Ins';'Inf';'Ins';'Inf';'Ins';'Inf';'Ins';'Inf';'Ins';'Inf';'Ins'},'VariableNames',factorNames);

%fit model
stim_rm = fitrm(means_table,'cond_mean~SF*PV*EL*InfIns','WithinDesign',within);


%run ANOVA
[stim_ranovatbl] = ranova(stim_rm);














