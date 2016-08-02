


%correct all timestamps to trialstart time
%trials x events x blocks x subjects
for s = 1:size(ts_cat,4)
    
    ts_corr(:,:,:,s) = gsubtract(ts_cat(:,:,:,s),ts_cat(:,1,:,s));
    
end

%get timestamps in frames
ts_frames = ts_corr*3000;

%trials x blocks x subjects
for s = 1:size(ts_cat,4)
    
    ruleRT(:,:,s) = gsubtract(ts_corr(:,5,:,s),ts_corr(:,4,:,s));
    stimRT(:,:,s) = gsubtract(ts_corr(:,9,:,s),ts_corr(:,8,:,s));
    
end

%get indices
for s = 1:size(ts_cat,4)
    
    for i = 1:4
        
        %trials x blocks x subjects
        s_trials(:,i,s) = find(data_cat{i,1,s}==0);  %symbol trial index
        f_trials(:,i,s) = find(data_cat{i,1,s}==1);  %finger trial index
        
        earlystim(:,i,s) = find(data_cat{i,7,s}==0); %early stim trials index
        latestim(:,i,s) = find(data_cat{i,7,s}==1);  %late stim trials index
        nostim(:,i,s) = find(data_cat{i,7,s}==2);  %no stim trials index
        
        %subject x block
        s_trials_es{s,i} = find(data_cat{i,1,s}==0 & data_cat{i,7,s}==0);  %symbol X early stim index
        s_trials_ls{s,i} = find(data_cat{i,1,s}==0 & data_cat{i,7,s}==1);  %symbol X late stim index
        s_trials_ns{s,i} = find(data_cat{i,1,s}==0 & data_cat{i,7,s}==2);  %symbol X no stim index
        
        f_trials_es{s,i} = find(data_cat{i,1,s}==1 & data_cat{i,7,s}==0);  %finger X early stim index
        f_trials_ls{s,i} = find(data_cat{i,1,s}==1 & data_cat{i,7,s}==1);  %finger X late stim index
        f_trials_ns{s,i} = find(data_cat{i,1,s}==1 & data_cat{i,7,s}==2);  %finger X no stim index
        
    end
end

%find successful trials and error trials

%figure out if stimulus was even or odd
%block x subject
for s = 1:size(ts_cat,4)
    
    for b = 1:4
        
        oddanswers{b,s} = mod(data_cat{b,6,s},2);
        oddanswers{b,s} = logical(oddanswers{b,s});
        
    end
end

for s = 1:size(ts_cat,4)
    
    for i = 1:size(data_cat,1)
        
        evenodd = cell2mat(data_cat{i,2,s});
        finger = cell2mat(data_cat{i,3,s});
        symbol = cell2mat(data_cat{i,4,s});
        ab = cell2mat(data_cat{i,5,s});
        
        %trial x block x subject
        for ii = 1:length(data_cat{i})
            
            if data_cat{i,1,s}(ii)==0  %symbolic trials
                
                if oddanswers{i,s}(ii)==0 && evenodd(ii,1)==1 && symbol(ii,1)==1 && ab(ii,1)==1
                    
                    correctans(ii,i,s) = 'L';%
                    
                elseif oddanswers{i,s}(ii)==0 && evenodd(ii,1)==1 && symbol(ii,1)==1 && ab(ii,1)==2
                    
                    correctans(ii,i,s) = 'R';%
                    
                elseif oddanswers{i,s}(ii)==0 && evenodd(ii,1)==1 && symbol(ii,1)==2 && ab(ii,1)==1
                    
                    correctans(ii,i,s) = 'R';%
                    
                elseif oddanswers{i,s}(ii)==0 && evenodd(ii,1)==1 && symbol(ii,1)==2 && ab(ii,1)==2
                    
                    correctans(ii,i,s) = 'L';%
                    
                elseif oddanswers{i,s}(ii)==0 && evenodd(ii,1)==2 && symbol(ii,1)==1 && ab(ii,1)==1
                    
                    correctans(ii,i,s) = 'R';%
                    
                elseif oddanswers{i,s}(ii)==0 && evenodd(ii,1)==2 && symbol(ii,1)==1 && ab(ii,1)==2
                    
                    correctans(ii,i,s) = 'L';%
                    
                elseif oddanswers{i,s}(ii)==0 && evenodd(ii,1)==2 && symbol(ii,1)==2 && ab(ii,1)==1
                    
                    correctans(ii,i,s) = 'L';%
                    
                elseif oddanswers{i,s}(ii)==0 && evenodd(ii,1)==2 && symbol(ii,1)==2 && ab(ii,1)==2
                    
                    correctans(ii,i,s) = 'R';%
                    
                elseif oddanswers{i,s}(ii)==1 && evenodd(ii,1)==1 && symbol(ii,1)==1 && ab(ii,1)==1
                    
                    correctans(ii,i,s) = 'R';%
                    
                elseif oddanswers{i,s}(ii)==1 && evenodd(ii,1)==1 && symbol(ii,1)==1 && ab(ii,1)==2
                    
                    correctans(ii,i,s) = 'L';%
                    
                elseif oddanswers{i,s}(ii)==1 && evenodd(ii,1)==1 && symbol(ii,1)==2 && ab(ii,1)==1
                    
                    correctans(ii,i,s) = 'L';%
                    
                elseif oddanswers{i,s}(ii)==1 && evenodd(ii,1)==1 && symbol(ii,1)==2 && ab(ii,1)==2
                    
                    correctans(ii,i,s) = 'R';%
                    
                elseif oddanswers{i,s}(ii)==1 && evenodd(ii,1)==2 && symbol(ii,1)==1 && ab(ii,1)==1
                    
                    correctans(ii,i,s) = 'L';%
                    
                elseif oddanswers{i,s}(ii)==1 && evenodd(ii,1)==2 && symbol(ii,1)==1 && ab(ii,1)==2
                    
                    correctans(ii,i,s) = 'R';%
                    
                elseif oddanswers{i,s}(ii)==1 && evenodd(ii,1)==2 && symbol(ii,1)==2 && ab(ii,1)==1
                    
                    correctans(ii,i,s) = 'R';%
                    
                elseif oddanswers{i,s}(ii)==1 && evenodd(ii,1)==2 && symbol(ii,1)==2 && ab(ii,1)==2
                    
                    correctans(ii,i,s) = 'L';%
                    
                end
                
            else  %finger trials
                
                if oddanswers{i,s}(ii)==0 && evenodd(ii,1)==1 && finger(ii,1)==1
                    
                    correctans(ii,i,s) = 'L';%
                    
                elseif oddanswers{i,s}(ii)==0 && evenodd(ii,1)==1 && finger(ii,1)==2
                    
                    correctans(ii,i,s) = 'R';%
                    
                elseif oddanswers{i,s}(ii)==0 && evenodd(ii,1)==2 && finger(ii,1)==1
                    
                    correctans(ii,i,s) = 'R';%
                    
                elseif oddanswers{i,s}(ii)==0 && evenodd(ii,1)==2 && finger(ii,1)==2
                    
                    correctans(ii,i,s) = 'L';%
                    
                elseif oddanswers{i,s}(ii)==1 && evenodd(ii,1)==1 && finger(ii,1)==1
                    
                    correctans(ii,i,s) = 'R';%
                    
                elseif oddanswers{i,s}(ii)==1 && evenodd(ii,1)==1 && finger(ii,1)==2
                    
                    correctans(ii,i,s) = 'L';%
                    
                elseif oddanswers{i,s}(ii)==1 && evenodd(ii,1)==2 && finger(ii,1)==1
                    
                    correctans(ii,i,s) = 'L';%
                    
                elseif oddanswers{i,s}(ii)==1 && evenodd(ii,1)==2 && finger(ii,1)==2
                    
                    correctans(ii,i,s) = 'R';%
                    
                end
            end
        end
    end
end


%compare correct answers to subject answers, find error trials, error
%rates, etc
%trial x block x subject
for s = 1:size(ts_cat,4)
    
    for i = 1:size(data_cat,1)
        
        errors(:,i,s) = strcmp(data_cat{i,8,s}, correctans(:,i,s));
        
    end
end


for s = 1:size(ts_cat,4)
    
    for b = 1:4
        
        error_ind = find(errors(:,b,s)==0);
        
        ruleRT(error_ind,b,s) = nan;
        stimRT(error_ind,b,s) = nan;
        
    end
end







