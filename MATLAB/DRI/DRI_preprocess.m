% function [outputs] = DRI_preprocess(data,~)
 
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
%     data{f,11} = adblData_mat;

for s = 1:size(data,1)
    
    evenpresent{s,1} = data{s,2}(:,1)==1;  %was Even chosen?
    fingerpresent{s,1} = data{s,3}(:,1)==1;  %was the index finger chosen?
    symbolpresent{s,1} = data{s,4}(:,1)==1;  %was A chosen?
    a_present{s,1} = data{s,5}(:,1)==1;  %on the stimulus screen, was A on the left?
    
    %was the answer odd?
    oddanswers{s,1} = mod(data{s,6},2);
    oddanswers{s,1} = logical(oddanswers{s,1});
    
    finger_trials_temp{s,1} = cat(2,data{s,1},evenpresent{s,1},fingerpresent{s,1},oddanswers{s,1},a_present{s,1});
    symbol_trials_temp{s,1} = cat(2,data{s,1},evenpresent{s,1},symbolpresent{s,1},oddanswers{s,1},a_present{s,1});
    
    %was it the finger condition; was even assigned to the index finger?
    even_index{s,1} = find(data{s,1}==1&evenpresent{s,1}==1&fingerpresent{s,1}==1);  %even-index presented
    odd_index{s,1} = find(data{s,1}==1&evenpresent{s,1}==0&fingerpresent{s,1}==1);  %odd-index presented
    even_middle{s,1} = find(data{s,1}==1&evenpresent{s,1}==1&fingerpresent{s,1}==0);  %even-middle presented
    odd_middle{s,1} = find(data{s,1}==1&evenpresent{s,1}==0&fingerpresent{s,1}==0);  %odd-middle presented
    
    finger_cond_trials{s,1} = cat(1,even_index{s,1},odd_index{s,1},even_middle{s,1},odd_middle{s,1});
    %error occurs here for some reason:
    finger_trials{s,1} = finger_trials_temp{s,1}(finger_cond_trials{s,1},:);
    
    %was it the symbol condition; was even assigned to A?
    even_A{s,1} = find(data{s,1}==0&evenpresent{s,1}==1&symbolpresent{s,1}==1);  %even-A presented
    odd_A{s,1} = find(data{s,1}==0&evenpresent{s,1}==0&symbolpresent{s,1}==1);  %odd-A presented
    even_B{s,1} = find(data{s,1}==0&evenpresent{s,1}==1&symbolpresent{s,1}==0);  %even-B presented
    odd_B{s,1} = find(data{s,1}==0&evenpresent{s,1}==0&symbolpresent{s,1}==0);  %odd-B presented
    
    symbol_cond_trials{s,1} = cat(1,even_A{s,1},odd_A{s,1},even_B{s,1},odd_B{s,1});
    symbol_trials{s,1} = symbol_trials_temp{s,1}(symbol_cond_trials{s,1},:);
    
    finger_trials{s,1}(:,6) = zeros(length(finger_trials{s,1}),1);
    for z = 1:length(finger_trials{s,1})
        
        if finger_trials{s,1}(z,2)==1&&finger_trials{s,1}(z,3)==1 && finger_trials{s,1}(z,4)==0
            
            finger_trials{s,1}(z,6)=1;
            
        elseif finger_trials{s,1}(z,2)==0&&finger_trials{s,1}(z,3)==1 && finger_trials{s,1}(z,4)==1
            
            finger_trials{s,1}(z,6)=1;
            
        elseif finger_trials{s,1}(z,2)==1&&finger_trials{s,1}(z,3)==0 && finger_trials{s,1}(z,4)==1
            
            finger_trials{s,1}(z,6)=1;
            
        elseif finger_trials{s,1}(z,2)==0&&finger_trials{s,1}(z,3)==0 && finger_trials{s,1}(z,4)==0
            
            finger_trials{s,1}(z,6)=1;
            
        end
        
    end
    
    symbol_trials{s,1}(:,6) = zeros(length(symbol_trials{s,1}),1);
    for z = 1:length(symbol_trials{s,1})
        
        if symbol_trials{s,1}(z,2)==1&&symbol_trials{s,1}(z,3)==1&&symbol_trials{s,1}(z,5)==1 && symbol_trials{s,1}(z,4)==1
            
            symbol_trials{s,1}(z,6)=1;
            
        elseif symbol_trials{s,1}(z,2)==1&&symbol_trials{s,1}(z,3)==1&&symbol_trials{s,1}(z,5)==0 && symbol_trials{s,1}(z,4)==0
            
            symbol_trials{s,1}(z,6)=1;
            
        elseif symbol_trials{s,1}(z,2)==0&&symbol_trials{s,1}(z,3)==1&&symbol_trials{s,1}(z,5)==1 && symbol_trials{s,1}(z,4)==0
            
            symbol_trials{s,1}(z,6)=1;
            
        elseif symbol_trials{s,1}(z,2)==0&&symbol_trials{s,1}(z,3)==1&&symbol_trials{s,1}(z,5)==0 && symbol_trials{s,1}(z,4)==1
            
            symbol_trials{s,1}(z,6)=1;
            
        elseif symbol_trials{s,1}(z,2)==1&&symbol_trials{s,1}(z,3)==0&&symbol_trials{s,1}(z,5)==1 && symbol_trials{s,1}(z,4)==0
            
            symbol_trials{s,1}(z,6)=1;
            
        elseif symbol_trials{s,1}(z,2)==1&&symbol_trials{s,1}(z,3)==0&&symbol_trials{s,1}(z,5)==0 && symbol_trials{s,1}(z,4)==1
            
            symbol_trials{s,1}(z,6)=1;
            
        elseif symbol_trials{s,1}(z,2)==0&&symbol_trials{s,1}(z,3)==0&&symbol_trials{s,1}(z,5)==1 && symbol_trials{s,1}(z,4)==1
            
            symbol_trials{s,1}(z,6)=1;
            
        elseif symbol_trials{s,1}(z,2)==0&&symbol_trials{s,1}(z,3)==0&&symbol_trials{s,1}(z,5)==0 && symbol_trials{s,1}(z,4)==0
            
            symbol_trials{s,1}(z,6)=1;
            
        end
    end
    
    
    %all_trials(:,1) answers the question, should the subject have responded with
    %their index finger? with yes or no
    all_trials{s,1} = nan(length(data{s,1}),1);
    all_trials{s,1}(symbol_cond_trials{s,1}) = symbol_trials{s,1}(:,6);
    all_trials{s,1}(finger_cond_trials{s,1}) = finger_trials{s,1}(:,6);

    %go back and confirm manually that all_trials(:,1) is the truth
    
    %add what finger they DID respond with
    actual_finger{s,1} = data{s,7};
    
    all_trials{s,1}(:,2) = zeros(30,1);
    all_trials{s,1}(find(actual_finger{s,1}=='S'),2) = 1;
    
    %did they get it right?
    all_trials{s,1}(:,3) = zeros(length(data{s,1}),1);
    all_trials{s,1}(find(all_trials{s,1}(:,1)==all_trials{s,1}(:,2)),3) = 1;
    


    %get emg channel data

    for c = 1:2
    
        c_index = c:2:length(data{s,11});
        channels_temp{s}(:,:,c) = data{s,11}(:,c_index);
    
    end

    for t = 1:data{s,8}
    
        zeros_index = find(channels_temp{s}(t,:,1)==0);
    
        if zeros_index(end)-zeros_index(1) == length(zeros_index)-1
        
            channels{t,s}(1,:) = channels_temp{s}(t,1:zeros_index(1)-1,1);
            channels{t,s}(2,:) = channels_temp{s}(t,1:zeros_index(1)-1,2);
        
        else
        
            sprintf('Error! Some real values==0 for trial %d!', t)
        
        end
    end
    

    %pad emg channels to the same length to make windowing the RMS calculation
    %easier later on
    c_lengths = cellfun(@length,channels);
    padsizes = cell(size(channels));
    padval = nan;
    
    for t = 1:length(padsizes)
        
        padsizes{t,s} = zeros(1,2);
        
        padsizes{t,s}(2) = 30000-c_lengths(t,s);
        
        channels_padded{t,s} = padarray(channels{t,s},padsizes{t,s},padval,'post');
        
    end


    
    
        
        
            
            
           
            
            
        
    
    
    
    
    
    
    
    
    
    
    
    
    
end


%get mean of each channel and subtract from each value

channel_means = cellfun(@(x) nanmean(x,2), channels_padded, 'UniformOutput',0);

cpad_adj = gsubtract(channels_padded,channel_means);


























    


%replicate for big_data
%preallocate arrays and put all necessary variables into output    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    