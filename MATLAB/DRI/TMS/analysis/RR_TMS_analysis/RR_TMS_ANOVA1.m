function stats = RR_TMS_ANOVA1(dtable,tIdx,rtIdx,factorIdx)

%only for RR_TMS project
%does the ANOVA for 2, 3, or 4 factors
%examines successful trials only
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%dtable is the data table
%tIdx is the index of trials you want to examine
%rtIdx is an index of the type of RT (rule/stim) you want to examine
%factorIdx is a vector index of the data table variables (columns) that 
%you wish to run the ANOVA on

%get the number and names of factors we are working with
numFactors = length(factorIdx);
factorNames = dtable.Properties.VariableNames(factorIdx);

%get the name of the dtable column the RT data is in
rtName = dtable.Properties.VariableNames(rtIdx);

%make data vector
y = dtable.(rtName{1})(tIdx);

%make factor vectors
%always at least 2
f1 = dtable.(factorNames{1})(tIdx);
f2 = dtable.(factorNames{2})(tIdx);

%make the others if need be and run ANOVA
if numFactors==2
    
    [~,~,stats] = anovan(y,{f1 f2},'model','full',...
    'varnames',{factorNames{1},factorNames{2}});

elseif numFactors==3
    
    f3 = dtable.(factorNames{3})(tIdx);
    [~,~,stats] = anovan(y,{f1 f2 f3},'model','full',...
        'varnames',{factorNames{1},factorNames{2},factorNames{3}});
    
elseif numFactors==4
    
    f3 = dtable.(factorNames{3})(tIdx);
    f4 = dtable.(factorNames{4})(tIdx);
    [~,~,stats] = anovan(y,{f1 f2 f3 f4},'model','full',...
        'varnames',{factorNames{1},factorNames{2},factorNames{3},factorNames{4}});
    
end










