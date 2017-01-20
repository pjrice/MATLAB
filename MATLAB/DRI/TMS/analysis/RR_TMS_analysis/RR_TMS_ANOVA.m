function [ranovatbl,mc1,mc2] = RR_TMS_ANOVA(dtable,RT_idx,factor_idx,within_levels,success)

%only for RR_TMS project
%does the ANOVA for any two of the factors it's given
%only works for factors with 2 levels
%if it's given eslsns, drops ns trials
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%dtable is your data in table format
%RT_idx is a vector index of the data table variable that contains the RT
%data you are interested in
%factor_idx is a vector index of the data table variables (columns) that 
%you wish to run the ANOVA on
%within_levels is a 1xN cell array of the levels of your factors
%success is an optional flag to analyze success or error trials. Defaults
%to success

%check if error trials were flagged; if not, analyze successful trials
if nargin < 5
    
    success = 1;  %plot success trials
    
end

%make the RT_idx into a string containing the column name
RT_name = dtable.Properties.VariableNames(RT_idx);


%First:
% Create a table reflecting the within subject factors and their levels
factorNames = dtable.Properties.VariableNames(factor_idx);
f1_levels = [repmat({within_levels{1}},1,2) repmat({within_levels{2}},1,2)];
f2_levels = repmat({within_levels{3:4}},1,2);
within = table(f1_levels',f2_levels','VariableNames',factorNames);

%Second:
%Index condition combo trials and get means
%rows: subjects
%columns: condition combos
%each cell contains vector of indexed trials

%get trial indices
subj_ids = unique(dtable.subj_ids);
%for stimRTs
tidx = cell(length(unique(dtable.subj_ids)),4);

for i = 1:length(subj_ids)
    
    tidx{i,1} = find(dtable.subj_ids==subj_ids(i) &...
        dtable.success==success &...
        dtable.(factorNames{1})==0 &...
        dtable.(factorNames{2})==0);
    
    tidx{i,2} = find(dtable.subj_ids==subj_ids(i) &...
        dtable.success==success &...
        dtable.(factorNames{1})==0 &...
        dtable.(factorNames{2})==1);

    tidx{i,3} = find(dtable.subj_ids==subj_ids(i) &...
        dtable.success==success &...
        dtable.(factorNames{1})==1 &...
        dtable.(factorNames{2})==0);
    
    tidx{i,4} = find(dtable.subj_ids==subj_ids(i) &...
        dtable.success==success &...
        dtable.(factorNames{1})==1 &...
        dtable.(factorNames{2})==1);
   
end

%Third
%Create tables storing the data
%rows: observations
%columns: conditions

%get the means

means = cell2mat(cellfun(@(x) mean(dtable.(RT_name{1})(x),'omitnan'),...
    tidx, 'UniformOutput', false));

%make the table
ph = within.Variables;

for i = 1:length(ph)
    
    varNames{1,i} = strcat(ph{i,:});
    
end

means_t = array2table(means,'VariableNames',varNames);

%Fourth
%fit the repeated measures models

modelspec = strcat(varNames{1},'-',varNames{end},'~1');

rm = fitrm(means_t,modelspec,'WithinDesign',within);

%Fifth
%run repeated measures ANOVAs
[ranovatbl] = ranova(rm, 'WithinModel',...
    strcat(factorNames{1},'*',factorNames{2}));

%Sixth
%Run multiple comparisons
mc1 = multcompare(rm, factorNames{1},'By',factorNames{2});
mc2 =multcompare(rm, factorNames{2},'By',factorNames{1});
















