function RR_TMS_filecat(datapath, subj_folder)

%function to concatenate individual block files for a given RR_TMS subject

cd(strcat(datapath, '\', subj_folder))
disp(strcat('Folder is subject =',subj_folder))

files = dir('*.mat');

s = [files(:).datenum].';

[s,s] = sort(s);

b = input('Started with PMd block? (y/n): ','s');

for f = 1:length(s)
    
    load(files(s(f)).name, 'adblData_mat', 'timestamps', 'condMatrix','evenoddchooser','fingerchooser','symbolchooser','abchooser','stim','streamstart_time','filename', 'rpspns', 'subj_resp')
    
    emg(:,f) = adblData_mat;
    timestamps(:,:,f) = timestamps;
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
    
    if b=='y' 
        
%         a = [0 1 0 1];
%         blockid = repmat(a,60,1);
%         blockid = reshape(blockid,240,1);
        
        if mod(f,2)==1
    
            a = 0; %PMd on odd blocks
            
        else
            
            a=1;  %Vertex on even blocks
            
        end
             
    else
        
%         a = [1 0 1 0];
%         blockid = repmat(a,60,1);
%         blockid = reshape(blockid,240,1);
        
        if mod(f,2)==1
            
            a = 1; %Vertex on odd blocks
            
        else
            
            a = 0;  %PMd on even blocks
            
        end
        
    end
    data{f,10} = repmat(a,60,1);
    
    clearvars -except files s f emg timestamps data ss_time filenames b datapath subj_folder
end

clear b

filename = strcat(datapath, '\', subj_folder,'cat.mat');
save(filename)
    