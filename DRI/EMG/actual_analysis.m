%load all necessary variables in, assign to different variables and cat new
%files' variables into them, save as new filename

%condMatrix, evenoddchooser, fingerchooser, symbolchooser, abchooser, stim,
%respMat, numtrials, VBLTimestamp, streamstart_time

FileList = dir('*.mat');

data = cell(length(FileList),10);

for f = 1:length(FileList)
    
    load(FileList(f).name, 'condMatrix','evenoddchooser','fingerchooser','symbolchooser','abchooser','stim','respMat','numtrials','VBLTimestamp','streamstart_time','adblData_mat')
      
    data{f,1} = condMatrix;
    data{f,2} = evenoddchooser;
    data{f,3} = fingerchooser;
    data{f,4} = symbolchooser;
    data{f,5} = abchooser;
    data{f,6} = stim;
    data{f,7} = cell2mat(cat(2,respMat(7,:)))';
    data{f,8} = numtrials;
    data{f,9} = VBLTimestamp;
    data{f,10} = streamstart_time;
    data{f,11} = adblData_mat;
    
end

big_data = cell(1,size(data,2));

for z = 1:size(data,2)
    
    if isa(data{1,z},'double') | isa(data{1,z},'char')
        
        big_data{1,z} = cat(1,data{:,z});
        
    elseif isa(data{1,z},'cell')
        
        for f = 1:size(data,1)
            
            data{f,z} = cell2mat(data{f,z});
            
        end
        
        big_data{1,z} = cat(1,data{:,z});
        
    end
    
end

clear condMatrix evenoddchooser fingerchooser symbolchooser abchooser stim respMat numtrials VBLTimestamp streamstart_time adblData_mat f z

%now write a function that has either big_data or data as an input argument
%that makes pretty graphs and runs stats (aka adapt simon_effect)
        
        



        

        
