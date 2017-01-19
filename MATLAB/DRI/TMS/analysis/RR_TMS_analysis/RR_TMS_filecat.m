function RR_TMS_filecat(datapath, subj_folder)

%function to concatenate individual block files for a given RR_TMS subject

cd(strcat(datapath, '/', subj_folder))
disp(strcat('Folder is subject =',subj_folder))

files = dir('*.mat');

s = [files(:).datenum].';

[s,s] = sort(s);

b = input('Started with PMd block? (y/n): ','s');

for f = 1:length(s)
    
    load(files(s(f)).name, 'adblData_mat', 'timestamps', 'condMatrix','evenoddchooser','fingerchooser','symbolchooser','abchooser','stim','streamstart_time','filename', 'rpspns', 'subj_resp')
    
    %handle exception - for subject 2406, the first block (PMd in this
    %case) is invalid - the coil had drifted off target (see
    %Expt_record.xlsx). When this block's file is loaded, just NaN all of
    %the relevant data (so our vector lengths are all good)
    if strcmp(files(s(f)).name,'2406_1.mat')
        
        for q = 1:length(adblData_mat)
            
            adblData_mat{q}(1,:) = nan;
            evenoddchooser{q}(:,:) = nan;
            fingerchooser{q}(:,:) = nan;
            symbolchooser{q}(:,:) = nan;
            abchooser{q}(:,:) = nan;
            subj_resp{q} = nan;
              
        end
        
        timestamps(:,:) = nan;
        condMatrix(:,:) = nan;
        stim(:,:) = nan;
        streamstart_time = nan;
        rpspns(:,:) = nan;
        
    end
        
    emg(:,f) = adblData_mat;
    ts_blocks(:,:,f) = timestamps;
    data{f,1} = condMatrix; %index of symbol and finger trials 0==symbol 1==finger
    data{f,2} = evenoddchooser; %whether even or odd was presented 0==Even
    data{f,3} = fingerchooser; %whether index or middle was presented 0==Index
    data{f,4} = symbolchooser; %whether A or B was presented 0==A
    data{f,5} = abchooser; %placement of A/B on stimulus screen 0==A, first value prints on left, second on right
    data{f,6} = stim; %value of the stimulus presented
    data{f,7} = rpspns; %whether early, late, or no stimulation occurred; 0==early, 1==late, 2==no
    data{f,8} = subj_resp; %subj response; L==Index, R==Middle (all subjs worked right-handed)
    data{f,9} = repmat(f,60,1); %subj block number
    ss_time(f) = streamstart_time; %system time of beginning of emg stream
%     filenames{f} = filename;  %seems unnecessary, but keeping for now in
%     case it breaks
    subj_id = subj_folder; %subj id number
    
    %index whether block was PMd or Vertex stimulation
    %0==PMd 1==Vertex
    %not in original subject files, so it has to be entered manually
    %record of this can be found in 'Expt_record.xlsx'
    %generate blockids, put into data{f,10}
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
    
    clearvars -except files s f emg ts_blocks data ss_time filenames b datapath subj_folder subj_id
end


filename = strcat(datapath, '/', subj_folder,'cat.mat');

clear b s f subj_folder filenames

save(filename)
    
