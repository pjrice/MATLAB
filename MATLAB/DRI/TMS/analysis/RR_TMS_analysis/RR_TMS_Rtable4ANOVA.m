%trying to get a table with height of 128 (8 partipants, 16 conditions)
%one row for the mean of each participant under each condition
%first column subj_ids
%second stimRT data means for conditions
%rest of columns are condition indicies

%get indices of each condition combo for each subj

cond_combos = double([permpos(0,4);permpos(1,4);permpos(2,4);permpos(3,4);permpos(4,4)]);
%cond_combos:
% SF PV EL InfIns
%1.  S P E INF
%2.  F P E INF
%3.  S V E INF
%4.  S P L INF
%5.  S P E INS
%6.  F V E INF
%7.  F P L INF
%8.  F P E INS
%9.  S V L INF
%10. S V E INS
%11. S P L INS
%12. F V L INF
%13. F V E INS
%14. F P L INS
%15. S V L INS
%16. F V L INS

subj_ids = unique(dtable.subj_ids);

for i = 1:length(subj_ids)
    
    for ii = 1:length(cond_combos)
        
        indx{i,ii} = find(dtable.subj_ids==subj_ids(i) &...
            dtable.success==1 &...
            dtable.sf_trials==cond_combos(ii,1) &...
            dtable.pmdver_trials==cond_combos(ii,2) &...
            dtable.eslsns_trials==cond_combos(ii,3) &...
            dtable.infins_trials==cond_combos(ii,4));
        
    end
end

indx = indx';
indx = reshape(indx,(size(indx,1)*size(indx,2)),1);

means = cell2mat(cellfun(@(x) mean(dtable.stimRT(x),'omitnan'), indx, 'UniformOutput', false));


%make table

repelem(subj_ids,length(cond_combos))

cc_all = repmat(cond_combos,length(subj_ids),1);

means_table = table(repelem(subj_ids,length(cond_combos)),means,...
    cc_all(:,1),cc_all(:,2),cc_all(:,3),cc_all(:,4),'VariableNames',...
    {'subj_id','cond_mean','SF','PV','EL','InfIns'});

writetable(means_table)

















