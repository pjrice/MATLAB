
%script to despike, filter, and common average reference individual trodes
%from 70bf0c

%get the filenames
% basepath = 'Z:\Work\UW\projects\SEM\ECoG\70bf0c\brain\';
% filelist = dir('Z:\Work\UW\projects\SEM\ECoG\70bf0c\brain\70bf0c_SEM_*.mat');

% basepath = 'Z:\Work\UW\projects\DRI\ECoG\70bf0c\brain\';
% filelist = dir('Z:\Work\UW\projects\DRI\ECoG\70bf0c\brain\70bf0c_DRI_*.mat');

basepath = 'Z:\Work\UW\projects\MAZE\ECoG\70bf0c\brain\';
filelist = dir('Z:\Work\UW\projects\MAZE\ECoG\70bf0c\brain\70bf0c_MAZE_*.mat');

%load the data and do stuff to it
for f = 1:length(filelist)
    
    load(strcat(basepath,filelist(f).name))
    
    %because I was dumb and labeled each dataset 'XXX_data'
    data = eval(matlab.lang.makeValidName(strcat(filelist(f).name(end-6:end-4),'_data')));
    
    %make butterworth filter
    [b,a] = butter(4,0.5,'high');
    
    %preallocate despiked
    despiked = nan(size(data));
    
    %remove artifacts and highpass filter
    for i = 1:size(data,2)
        
        %temporary
        despiked(:,i) = filtfilt(b,a,data(:,i));

        %despike v3 took forever on my system (aka overnight to despike 2
        %artifacts from one channel)
        
        %not despiked at all right now because new (better) data format is
        %breaking it - investigate
%         despiked(:,i) = despike(data(:,i));
        
%         despiked(:,i) = filtfilt(b,a,despiked(:,i));
        
    end
    
    clear data a b i 
    
    %common average reference
    ds_mean = mean(despiked,2);
    for i = 1:size(despiked,2)
        
        despiked(:,i) = despiked(:,i) - ds_mean;
        
    end
    
    clear i
    
    save(strcat(basepath,filelist(f).name),'-v7.3')
    
    clearvars -except basepath filelist f
    
end
    
    
    
    
    
    
    
    
    

