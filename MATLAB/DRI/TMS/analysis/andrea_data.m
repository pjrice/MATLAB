%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%older stuff
andrea_data = indices_all;
andrea_data(:,5) = errors_all;
andrea_data(:,6) = ruleRT_all;
andrea_data(:,7) = stimRT_all;

track = 0;
for w = 1:s
    
    sub_num(1+track:240+track) = w;
    
    track = track+240;
    
end

andrea_data(:,8) = sub_num;

csvwrite('andrea_data.csv',andrea_data)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%reorg it for hddm

old_data = csvread('Z:\Work\UW\projects\RR_TMS\data\andrea_data.csv');


subj_idx = old_data(:,8);

stimrt = old_data(:,7);

response = old_data(:,5);


simple_hddm = cat(2,subj_idx,stimrt,response);

nan_idx = find(isnan(simple_hddm(:,2)));

simple_hddm(nan_idx,:) = [];

csvwrite('C:\python\hddm\data\simple_hddm.csv',simple_hddm)