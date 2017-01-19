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

%First:
% Create a table reflecting the within subject factors 'S/F', 
%'Inf/Ins', and 'ns/Vstim' and their levels
factorNames = {'Sym_Fin','Inf_Ins','ns_Vstim'};
within = table({'S';'S';'S';'S';'F';'F';'F';'F'},...
    {'INF';'INF';'INS';'INS';'INF';'INF';'INS';'INS'},...
    {'NS';'VS';'NS';'VS';'NS';'VS';'NS';'VS'},'VariableNames',factorNames);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Second:
%Index condition combo trials and get means
%rows: 8 subjects
%columns: 8 condition combos
%each cell contains vector of indexed trials

%ONLY CORRECT TRIALS

%get trial indices
subj_ids = unique(dtable.subj_ids);
%for stimRTs
stim_nsVs_tidx = cell(8,8);
for i = 1:length(subj_ids)
    
    %S,INF,NS
    stim_nsVs_tidx{i,1} = find(dtable.subj_ids==subj_ids(i) &...
        dtable.success==1 &...
        dtable.sf_trials==0 &...
        dtable.infins_trials==0 &...
        dtable.eslsns_trials==2);
    
    %S,INF,VS
    stim_nsVs_tidx{i,2} = find(dtable.subj_ids==subj_ids(i) &...
        dtable.success==1 &...
        dtable.sf_trials==0 &...
        dtable.infins_trials==0 &...
        (dtable.pmdver_trials==1 & ...
        (dtable.eslsns_trials==0 | dtable.eslsns_trials==1)));
    
    %S,INS,NS
    stim_nsVs_tidx{i,3} = find(dtable.subj_ids==subj_ids(i) &...
        dtable.success==1 &...
        dtable.sf_trials==0 &...
        dtable.infins_trials==1 &...
        dtable.eslsns_trials==2);
    
    %S,INS,VS
    stim_nsVs_tidx{i,4} = find(dtable.subj_ids==subj_ids(i) &...
        dtable.success==1 &...
        dtable.sf_trials==0 &...
        dtable.infins_trials==1 &...
        (dtable.pmdver_trials==1 & ...
        (dtable.eslsns_trials==0 | dtable.eslsns_trials==1)));

    %F,INF,NS
    stim_nsVs_tidx{i,5} = find(dtable.subj_ids==subj_ids(i) &...
        dtable.success==1 &...
        dtable.sf_trials==1 &...
        dtable.infins_trials==0 &...
        dtable.eslsns_trials==2);
    
    %F,INF,VS
    stim_nsVs_tidx{i,6} = find(dtable.subj_ids==subj_ids(i) &...
        dtable.success==1 &...
        dtable.sf_trials==1 &...
        dtable.infins_trials==0 &...
        (dtable.pmdver_trials==1 & ...
        (dtable.eslsns_trials==0 | dtable.eslsns_trials==1)));
    
    %F,INS,NS
    stim_nsVs_tidx{i,7} = find(dtable.subj_ids==subj_ids(i) &...
        dtable.success==1 &...
        dtable.sf_trials==1 &...
        dtable.infins_trials==1 &...
        dtable.eslsns_trials==2);
    
    %F,INS,VS
    stim_nsVs_tidx{i,8} = find(dtable.subj_ids==subj_ids(i) &...
        dtable.success==1 &...
        dtable.sf_trials==1 &...
        dtable.infins_trials==1 &...
        (dtable.pmdver_trials==1 & ...
        (dtable.eslsns_trials==0 | dtable.eslsns_trials==1)));
    
end

%for ruleRTs
rule_nsVs_tidx = cell(8,8);
for i = 1:length(subj_ids)
    
    %S,INF,NS
    rule_nsVs_tidx{i,1} = find(dtable.subj_ids==subj_ids(i) &...
        dtable.success==1 &...
        dtable.sf_trials==0 &...
        dtable.infins_trials==0 &...
        (dtable.eslsns_trials==2 | dtable.eslsns_trials==1));
    
    %S,INF,VS
    rule_nsVs_tidx{i,2} = find(dtable.subj_ids==subj_ids(i) &...
        dtable.success==1 &...
        dtable.sf_trials==0 &...
        dtable.infins_trials==0 &...
        (dtable.pmdver_trials==1 & dtable.eslsns_trials==0));
    
    %S,INS,NS
    rule_nsVs_tidx{i,3} = find(dtable.subj_ids==subj_ids(i) &...
        dtable.success==1 &...
        dtable.sf_trials==0 &...
        dtable.infins_trials==1 &...
        (dtable.eslsns_trials==2 | dtable.eslsns_trials==1));
    
    %S,INS,VS
    rule_nsVs_tidx{i,4} = find(dtable.subj_ids==subj_ids(i) &...
        dtable.success==1 &...
        dtable.sf_trials==0 &...
        dtable.infins_trials==1 &...
        (dtable.pmdver_trials==1 & dtable.eslsns_trials==0));
    
    %F,INF,NS
    rule_nsVs_tidx{i,5} = find(dtable.subj_ids==subj_ids(i) &...
        dtable.success==1 &...
        dtable.sf_trials==1 &...
        dtable.infins_trials==0 &...
        (dtable.eslsns_trials==2 | dtable.eslsns_trials==1));
    
    %F,INF,VS
    rule_nsVs_tidx{i,6} = find(dtable.subj_ids==subj_ids(i) &...
        dtable.success==1 &...
        dtable.sf_trials==1 &...
        dtable.infins_trials==0 &...
        (dtable.pmdver_trials==1 & dtable.eslsns_trials==0));
    
    %F,INS,NS
    rule_nsVs_tidx{i,7} = find(dtable.subj_ids==subj_ids(i) &...
        dtable.success==1 &...
        dtable.sf_trials==1 &...
        dtable.infins_trials==1 &...
        (dtable.eslsns_trials==2 | dtable.eslsns_trials==1));
    
    %F,INS,VS
    rule_nsVs_tidx{i,8} = find(dtable.subj_ids==subj_ids(i) &...
        dtable.success==1 &...
        dtable.sf_trials==1 &...
        dtable.infins_trials==1 &...
        (dtable.pmdver_trials==1 & dtable.eslsns_trials==0));
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Third
%Create tables storing the data
%rows: observations (8 rows, 8 subjects) (means of RTs)
%columns: conditions (8 columns, 8 condition combos)

%get the means
stim_nsVs_means = cell2mat(cellfun(@(x) mean(dtable.stimRT(x),'omitnan'),...
    stim_nsVs_tidx, 'UniformOutput', false));

rule_nsVs_means = cell2mat(cellfun(@(x) mean(dtable.ruleRT(x),'omitnan'),...
    rule_nsVs_tidx, 'UniformOutput', false));

%make the table
varNames = {'S_INF_NS','S_INF_VS','S_INS_NS','S_INS_VS',...
    'F_INF_NS','F_INF_VS','F_INS_NS','F_INS_VS'};

stim_t = array2table(stim_nsVs_means,'VariableNames',varNames);
rule_t = array2table(rule_nsVs_means,'VariableNames',varNames);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Fourth
%fit the repeated measures models
stim_rm = fitrm(stim_t,'S_INF_NS-F_INS_VS~1','WithinDesign',within);
rule_rm = fitrm(rule_t,'S_INF_NS-F_INS_VS~1','WithinDesign',within);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Fifth
%run repeated measures ANOVAs
[stim_ranovatbl] = ranova(stim_rm, 'WithinModel','Sym_Fin*Inf_Ins*ns_Vstim');
[rule_ranovatbl] = ranova(rule_rm, 'WithinModel','Sym_Fin*Inf_Ins*ns_Vstim');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Sixth
%make pairwise comparisons for the two-way interactions

%this gives us what we want
multcompare(stim_rm, 'ns_Vstim','By','Sym_Fin')
multcompare(stim_rm, 'ns_Vstim','By','Inf_Ins')

multcompare(rule_rm, 'ns_Vstim','By','Sym_Fin')
multcompare(rule_rm, 'ns_Vstim','By','Inf_Ins')

%other pairwise comparisons
multcompare(stim_rm, 'Sym_Fin','By','Inf_Ins')
multcompare(stim_rm, 'Sym_Fin','By','ns_Vstim')

multcompare(stim_rm, 'Inf_Ins','By','Sym_Fin')
multcompare(stim_rm, 'Inf_Ins','By','ns_Vstim')

multcompare(rule_rm, 'Sym_Fin','By','Inf_Ins')
multcompare(rule_rm, 'Sym_Fin','By','ns_Vstim') %this is the only one that is meaningful

multcompare(rule_rm, 'Inf_Ins','By','Sym_Fin')
multcompare(rule_rm, 'Inf_Ins','By','ns_Vstim')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Do three-way interaction

%1. convert factors to categorical
within2 = within;
within2.Sym_Fin = categorical(within2.Sym_Fin);
within2.Inf_Ins = categorical(within2.Inf_Ins);
within2.ns_Vstim = categorical(within2.ns_Vstim);

%2. create interaction factors
within2.SymFin_InfIns = within2.Sym_Fin .* within2.Inf_Ins;

%3. fitrm with the modified design
rm = fitrm(stim_t,




