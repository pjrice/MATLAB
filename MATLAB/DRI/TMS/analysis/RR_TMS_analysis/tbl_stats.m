

testtbl = table(dtable.stimRT,dtable.subj_ids,dtable.sf_trials,...
    dtable.pmdver_trials,dtable.eslsns_trials,dtable.infins_trials,...
    'VariableNames',{'stimRT';'subj_ids';'sf';'pv';'eln';'ii'});

test = grpstats(testtbl,{'subj_ids';'sf';'pv';'eln';'ii'});