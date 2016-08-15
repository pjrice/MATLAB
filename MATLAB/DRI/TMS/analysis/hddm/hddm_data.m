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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%simple (no conditions, just subj_idx, stimrt, response)
simple_hddm = cat(2,subj_idx,stimrt,response);

nan_idx = find(isnan(simple_hddm(:,2)));

simple_hddm(nan_idx,:) = [];

csvwrite('C:\python\hddm\data\simple_hddm.csv',simple_hddm)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%more complex (aka add conditions)

old_data = csvread('Z:\Work\UW\projects\RR_TMS\data\andrea_data.csv');

%make strings to denote conditions
%inf/ins - X(0, inf)/Y(1, instr)
%sym/fin - S(0, sym)/F(1, fin)
%early/late/no stim - E(0, early)/L(1, late )/N(2, no)
%PMd/Vertex stim - P(0, PMd)/V(1, Vertex)

for i = 1:length(old_data)
    
    cond_string = char();
    
    if old_data(i,1)==0
        cond_string(1) = 'X';
    else
        cond_string(1) = 'Y';
    end
    
    if old_data(i,2)==0
        cond_string(2) = 'S';
    else
        cond_string(2) = 'F';
    end
    
    if old_data(i,3)==0
        cond_string(3) = 'E';
    elseif old_data(i,3)==1
        cond_string(3) = 'L';
    else
        cond_string(3) = 'N';
    end
    
    if old_data(i,4)==0
        cond_string(4) = 'P';
    else
        cond_string(4) = 'V';
    end
    
    cond_strings{i,1} = cond_string;
    
end

subj_idx = old_data(:,8);
stimrt = old_data(:,7);
response = old_data(:,5);

headers = cell(0);
headers{1} = 'subj_idx';
headers{2} = 'stim';
headers{3} = 'rt';
headers{4} = 'response';

cond_hddm = cat(2,num2cell(subj_idx),cond_strings,num2cell(stimrt),num2cell(response));

nan_idx = find(cell2mat(cellfun(@(x) isnan(x), cond_hddm(:,3), 'UniformOutput', false)));

cond_hddm(nan_idx,:) = [];

cond_hddm = cat(1,headers,cond_hddm);

fid = fopen('C:\python\hddm\data\cond_hddm.csv', 'w');
fprintf(fid,'%s, %s, %s, %s\n',cond_hddm{1,:})

for i = 2:length(cond_hddm)
    fprintf(fid,'%u, %s, %f, %u\n',cond_hddm{i,:})
end
fclose(fid)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%everything (add ruleRT); future: EMG measures?

old_data = csvread('Z:\Work\UW\projects\RR_TMS\data\andrea_data.csv');

%make strings to denote conditions
%inf/ins - X(0)/Y(1)
%sym/fin - S(0)/F(1)
%early/late/no stim - E(0)/L(1)/N(2)
%PMd/Vertex stim - P(0)/V(1)

for i = 1:length(old_data)
    
    cond_string = char();
    
    if old_data(i,1)==0
        cond_string(1) = 'X';
    else
        cond_string(1) = 'Y';
    end
    
    if old_data(i,2)==0
        cond_string(2) = 'S';
    else
        cond_string(2) = 'F';
    end
    
    if old_data(i,3)==0
        cond_string(3) = 'E';
    elseif old_data(i,3)==1
        cond_string(3) = 'L';
    else
        cond_string(3) = 'N';
    end
    
    if old_data(i,4)==0
        cond_string(4) = 'P';
    else
        cond_string(4) = 'V';
    end
    
    cond_strings{i,1} = cond_string;
    
end

subj_idx = old_data(:,8);
rulert = old_data(:,6);
stimrt = old_data(:,7);
response = old_data(:,5);

rrt_nans = find(isnan(rulert));
srt_nans = find(isnan(stimrt));
rulert(srt_nans) = NaN;
stimrt(rrt_nans) = NaN;

headers = cell(0);
headers{1} = 'subj_idx';
headers{2} = 'stim';
headers{3} = 'rt';
headers{4} = 'response';
headers{5} = 'rulert';

full_hddm = cat(2,num2cell(subj_idx),cond_strings,num2cell(stimrt),num2cell(response),num2cell(rulert));

nan_idx = find(cell2mat(cellfun(@(x) isnan(x), full_hddm(:,3), 'UniformOutput', false)));

full_hddm(nan_idx,:) = [];

full_hddm = cat(1,headers,full_hddm);

fid = fopen('C:\python\hddm\data\full_hddm.csv', 'w');
fprintf(fid,'%s, %s, %s, %s, %s\n',full_hddm{1,:});

for i = 2:length(full_hddm)
    fprintf(fid,'%u, %s, %f, %u, %f\n',full_hddm{i,:});
end
fclose(fid);













