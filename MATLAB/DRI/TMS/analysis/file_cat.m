files = dir('*.mat');

s = [files(:).datenum].';

[s,s] = sort(s);

b = input('Started with PMd block? (y/n): ','s');

for f = 1:length(s)
    
    load(files(s(f)).name, 'adblData_mat', 'timestamps', 'condMatrix','evenoddchooser','fingerchooser','symbolchooser','abchooser','stim','streamstart_time','filename', 'rpspns', 'subj_resp')
    
    emg(:,f) = adblData_mat;
    ts(:,:,f) = timestamps;
    data{f,1} = condMatrix;
    data{f,2} = evenoddchooser;
    data{f,3} = fingerchooser;
    data{f,4} = symbolchooser;
    data{f,5} = abchooser;
    data{f,6} = stim;
    data{f,7} = rpspns;
    data{f,8} = subj_resp;
    data{f,9} = repmat(f,60,1);
    ss_time(f) = streamstart_time;
    filenames{f} = filename;
    
    
    clearvars -except files s f emg ts data ss_time filenames b
end

if b=='y'

    a = [0 1 0 1];
    blockid = repmat(a,60,1);
    blockid = reshape(blockid,240,1);
    
else

    a = [1 0 1 0];
    blockid = repmat(a,60,1);
    blockid = reshape(blockid,240,1);
    
end

clear b

filename = input('Filename? ','s');
save(filename)
    
