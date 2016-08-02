function [outputs] = DRI_stats(inputs)
%add inputs (essentially, output of DRI_preprocess
%add output


%     data{f,1} = condMatrix;
%     data{f,2} = evenoddchooser;
%     data{f,3} = fingerchooser;
%     data{f,4} = symbolchooser;
%     data{f,5} = abchooser;
%     data{f,6} = stim;
%     data{f,7} = cell2mat(cat(2,respMat(7,:)))';
%     data{f,8} = numtrials;
%     data{f,9} = VBLTimestamp;
%     data{f,10} = streamstart_time;



for s = 1:size(data,1)
    
    percent_correct{s,1} = sum(all_trials{s,1}(:,3))/length(all_trials{s,1});
    
    for t = 1:data{s,8}
        
        %correct so that first timestamp is at time zero (trial start)
        events{s,1}(t,:) = data{s,9}(t,:)-data{s,10};
        events{s,1}(t,:) = events{s,1}(t,:)-events{s,1}(t,1);
        
    end
    
    respTime{s,1} = events{s,1}(:,5) - events{s,1}(:,4);
    
    index_trials{s,1} = find(all_trials{s,1}(:,1));
    middle_trials{s,1} = find(~all_trials{s,1}(:,1));
    
    respTime_index{s,1} = respTime{s,1};
    respTime_middle{s,1} = respTime{s,1};
    
    respTime_index{s,1}(middle_trials) = nan;
    respTime_middle{s,1}(index_trials) = nan;
    
    
    wrong{s,1} = find(~all_trials{s,1}(:,3));
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    %get emg RMS through different window sizes    
    
    % %let's try window sizes of 25, 50, 75, and 100 SAMPLES
    % %this is equal to window lengths of samplelength*(1/3000) (emg was
    % sampled at 3 KHz)
    % %pad with NaNs to makes all vectors divisible by these values
    % %try just str8 up rms and then try nanrms
    % %nanrms = sqrt(nanmean(x.^2));
    
    %make indexes that step through the length of the emg vectors at these
    %divisions
    
    
    
    %get rms for unadjusted emg channels using binning rather than sliding window
    %use interp() function to upsample rms vector length to match emg
    %channel legnth
    for z = 1:4
        
        window_index = 1:z*25:length(channels_padded{1,1});
        
        for y = 1:length(window_index)-1
            
            window_indexes{y,z} = [window_index(y) window_index(y+1)-1];
            
        end
        
        window_indexes{length(channels_padded{1,1})/(z*25),z} = ...
            [window_indexes{length(channels_padded{1,1})/(z*25)-1,z}(2)+1 length(channels_padded{1,1})];
        
    end
        
        
    for z = 1:4
        
        for t = 1:length(channels_padded)
            
            for i = 1:length(window_indexes)/z
                
                rms_vectors{t,s,z}(1,i) = rms(channels_padded{t,s}(1,window_indexes{i,z}(1):window_indexes{i,z}(2)));
                rms_vectors{t,s,z}(2,i) = rms(channels_padded{t,s}(2,window_indexes{i,z}(1):window_indexes{i,z}(2)));

            end
            
        end
        
    end
        
    %get rms for adjusted emg channels using binning rather than sliding window
    %use interp() function to upsample rms vector length to match emg
    %channel legnth
    
    for z = 1:4
        
        window_index = 1:z*25:length(cpad_adj{1,1});
        
        for y = 1:length(window_index)-1
            
            window_indexes{y,z} = [window_index(y) window_index(y+1)-1];
            
        end
        
        window_indexes{length(cpad_adj{1,1})/(z*25),z} = ...
            [window_indexes{length(cpad_adj{1,1})/(z*25)-1,z}(2)+1 length(cpad_adj{1,1})];
        
    end
    
    
    for z = 1:4
        
        for t = 1:length(cpad_adj)
            
            for i = 1:length(window_indexes)/z
                
                rms_vectors_adj{t,s,z}(1,i) = rms(cpad_adj{t,s}(1,window_indexes{i,z}(1):window_indexes{i,z}(2)));
                rms_vectors_adj{t,s,z}(2,i) = rms(cpad_adj{t,s}(2,window_indexes{i,z}(1):window_indexes{i,z}(2)));
                
            end
            
        end
        
    end
    
    %get rms for unadjusted emg channels using sliding window
    
    for z = 1:4
        
        for t = 1:length(channels_padded)
            
            for y = 1:(25*z):length(channels_padded{t,s})-(25*z)+1
                
                sw_rms_vec{t,s,z}(1,y) = rms(channels_padded{t,s}(1,y:y+z*25-1));
                sw_rms_vec{t,s,z}(2,y) = rms(channels_padded{t,s}(2,y:y+z*25-1));
                
            end
        end
    end
                
                
              
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


