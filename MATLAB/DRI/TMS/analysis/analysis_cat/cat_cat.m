clear

filelist = dir('*_cat.mat');

%there's already an f in the files, oops
for ff = 1:length(filelist)
    
    load(filelist(ff).name)
    
    emg_cat(:,:,ff) = emg;
    ts_cat(:,:,:,ff) = ts;
    data_cat(:,:,ff) = data;
    ss_time_cat(ff,:) = ss_time;
    
    %trials x (condMatrix)(rpspns)(block#) x subject
    fuckit(:,1,ff) = cat(1,data{:,1});
    fuckit(:,2,ff) = cat(1,data{:,7});
    fuckit(:,3,ff) = cat(1,data{:,9});
    
    blockid_cat(:,ff) = blockid;
    
    clearvars -except filelist ff emg_cat ts_cat data_cat ss_time_cat fuckit blockid_cat
    
end

blockid_cat = reshape(blockid_cat,ff*240,1);

clear ff

filename = 'cat_cat';
save(filename,'-v7.3')