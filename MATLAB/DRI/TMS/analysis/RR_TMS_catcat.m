function y = RR_TMS_catcat(datapath)

cd(datapath)

filelist = dir('*cat.mat');

%there's already an f in the files, oops
for ff = 1:length(filelist)
    
    load(filelist(ff).name)
    
    emg_cat(:,:,ff) = emg;
    ts_cat(:,:,:,ff) = timestamps;
    data_cat(:,:,ff) = data;
    ss_time_cat(ff,:) = ss_time;
    
    %trials x (condMatrix)(rpspns)(block#) x subject
%     fuckit(:,1,ff) = cat(1,data{:,1});
%     fuckit(:,2,ff) = cat(1,data{:,7});
%     fuckit(:,3,ff) = cat(1,data{:,9});
    
%     blockid_cat(:,ff) = blockid;
    
    clearvars -except filelist ff emg_cat ts_cat data_cat ss_time_cat fuckit blockid_cat datapath
    
end

% blockid_cat = reshape(blockid_cat,ff*240,1);

clear ff

filename = strcat(datapath,'\RR_TMS_subjcat.mat');
save(filename,'-v7.3')

y = filename;