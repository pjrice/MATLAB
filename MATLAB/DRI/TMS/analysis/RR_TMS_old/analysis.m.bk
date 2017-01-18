% This is an ntrials x n x nblocks array for event timestamps
%rows are trials, columns:
%1st: trial start
%2nd: first fixation presentation
%3rd: timestamp for early stimulations
%4th: rule presentation
%5th: timestamp of self pacing through rule instruction
%6th: second fixation presentation
%7th: timestamp for late stimulations
%8th: stimulus presentation
%9th: timestamp of subject's response
%10th: ITI presentation
%11th: trial stop
%12th: 
% 
% emg(:,f) = adblData_mat;
% ts(:,:,f) = timestamps;
% data{f,1} = condMatrix;  %key: 0==symbols 1==fingers
% data{f,2} = evenoddchooser;
% data{f,3} = fingerchooser;
% data{f,4} = symbolchooser;
% data{f,5} = abchooser;
% data{f,6} = stim;
% data{f,7} = rpspns;
% ss_time(f) = streamstart_time;
% filenames{f} = filename;



%correct all timestamps to trialstart time
%instead of this stupid shit, use gsubtract
% test = gsubtract(timestamps,timestamps(:,1))
ts_corr = nan(size(ts));
for i = 1:length(ts)
    
    for ii = 1:4
        
        ts_corr(i,:,ii) = ts(i,:,ii) - ts(i,1,ii);
        
    end
end

%get timestamps in frames
ts_frames = ts_corr*3000;

%get rule RTs and stimulus RTs
ruleRT = nan(length(ts_corr),4);
stimRT = nan(length(ts_corr),4);
for i = 1:length(ts_corr)
    for ii = 1:4
        
        ruleRT(i,ii) = ts_corr(i,5,ii) - ts_corr(i,4,ii);
        stimRT(i,ii) = ts_corr(i,9,ii) - ts_corr(i,8,ii);
        
    end
end

%find and remove outliers
ruleRT_mean = mean(ruleRT);
ruleRT_std = std(ruleRT);

stimRT_mean = mean(stimRT);
stimRT_std = std(stimRT);

for b = 1:4
    
    rule_outliers{b} = find(ruleRT(:,b)>(ruleRT_mean(b)+(2*ruleRT_std(b)))...
        | ruleRT(:,b)<(ruleRT_mean(b)-(2*ruleRT_std(b))));
    
    stim_outliers{b} = find(stimRT(:,b)>(stimRT_mean(b)+(2*stimRT_std(b)))...
        | stimRT(:,b)<(stimRT_mean(b)-(2*stimRT_std(b))));
    
end

for b = 1:4
    
    ruleRT(rule_outliers{b},b) = nan;
    stimRT(stim_outliers{b},b) = nan;
    
end

allruleRT = [ruleRT(:,1);ruleRT(:,2);ruleRT(:,3);ruleRT(:,4)];
allstimRT = [stimRT(:,1);stimRT(:,2);stimRT(:,3);stimRT(:,4)];
% figure(1)
% hold on
% plot(allruleRT)
% plot(allstimRT)

%get indices
for i = 1:4
    
    s_trials(:,i) = find(data{i,1}==0);  %symbol trial index
    f_trials(:,i) = find(data{i,1}==1);  %finger trial index
    
    earlystim(:,i) = find(data{i,7}==0); %early stim trials index
    latestim(:,i) = find(data{i,7}==1);  %late stim trials index
    nostim(:,i) = find(data{i,7}==2);  %no stim trials index
    
    s_trials_es{:,i} = find(data{i,1}==0 & data{i,7}==0);  %symbol X early stim index
    s_trials_ls{:,i} = find(data{i,1}==0 & data{i,7}==1);  %symbol X late stim index
    s_trials_ns{:,i} = find(data{i,1}==0 & data{i,7}==2);  %symbol X no stim index
    
    f_trials_es{:,i} = find(data{i,1}==1 & data{i,7}==0);  %finger X early stim index
    f_trials_ls{:,i} = find(data{i,1}==1 & data{i,7}==1);  %finger X late stim index
    f_trials_ns{:,i} = find(data{i,1}==1 & data{i,7}==2);  %finger X no stim index
    
    
end

%find successful trials and error trials

%figure out if stimulus was even or odd
for s = 1:size(data,1)
    
    oddanswers{s,1} = mod(data{s,6},2);
    oddanswers{s,1} = logical(oddanswers{s,1});
    
end

%futt bugly
for i = 1:size(data,1)
    
    evenodd = cell2mat(data{i,2});
    finger = cell2mat(data{i,3});
    symbol = cell2mat(data{i,4});
    ab = cell2mat(data{i,5});

    for ii = 1:length(data{i})
        
        if data{i,1}(ii)==0  %symbolic trials
            
            if oddanswers{i}(ii)==0 && evenodd(ii,1)==1 && symbol(ii,1)==1 && ab(ii,1)==1
            
                correctans(ii,i) = 'L';%
                
            elseif oddanswers{i}(ii)==0 && evenodd(ii,1)==1 && symbol(ii,1)==1 && ab(ii,1)==2
            
                correctans(ii,i) = 'R';%
                
            elseif oddanswers{i}(ii)==0 && evenodd(ii,1)==1 && symbol(ii,1)==2 && ab(ii,1)==1
                    
                correctans(ii,i) = 'R';%
                
            elseif oddanswers{i}(ii)==0 && evenodd(ii,1)==1 && symbol(ii,1)==2 && ab(ii,1)==2
                
                correctans(ii,i) = 'L';%
                
            elseif oddanswers{i}(ii)==0 && evenodd(ii,1)==2 && symbol(ii,1)==1 && ab(ii,1)==1
                
                correctans(ii,i) = 'R';%
                
            elseif oddanswers{i}(ii)==0 && evenodd(ii,1)==2 && symbol(ii,1)==1 && ab(ii,1)==2
                
                correctans(ii,i) = 'L';%
                
            elseif oddanswers{i}(ii)==0 && evenodd(ii,1)==2 && symbol(ii,1)==2 && ab(ii,1)==1
                
                correctans(ii,i) = 'L';%
                
            elseif oddanswers{i}(ii)==0 && evenodd(ii,1)==2 && symbol(ii,1)==2 && ab(ii,1)==2
                
                correctans(ii,i) = 'R';%

            elseif oddanswers{i}(ii)==1 && evenodd(ii,1)==1 && symbol(ii,1)==1 && ab(ii,1)==1
            
                correctans(ii,i) = 'R';%
                
            elseif oddanswers{i}(ii)==1 && evenodd(ii,1)==1 && symbol(ii,1)==1 && ab(ii,1)==2
            
                correctans(ii,i) = 'L';%
                
            elseif oddanswers{i}(ii)==1 && evenodd(ii,1)==1 && symbol(ii,1)==2 && ab(ii,1)==1
                    
                correctans(ii,i) = 'L';%
                
            elseif oddanswers{i}(ii)==1 && evenodd(ii,1)==1 && symbol(ii,1)==2 && ab(ii,1)==2
                
                correctans(ii,i) = 'R';%
                
            elseif oddanswers{i}(ii)==1 && evenodd(ii,1)==2 && symbol(ii,1)==1 && ab(ii,1)==1
                
                correctans(ii,i) = 'L';%
                
            elseif oddanswers{i}(ii)==1 && evenodd(ii,1)==2 && symbol(ii,1)==1 && ab(ii,1)==2
                
                correctans(ii,i) = 'R';%
                
            elseif oddanswers{i}(ii)==1 && evenodd(ii,1)==2 && symbol(ii,1)==2 && ab(ii,1)==1
                
                correctans(ii,i) = 'R';%
                
            elseif oddanswers{i}(ii)==1 && evenodd(ii,1)==2 && symbol(ii,1)==2 && ab(ii,1)==2
                
                correctans(ii,i) = 'L';%
                
            end
            
        else  %finger trials
            
            if oddanswers{i}(ii)==0 && evenodd(ii,1)==1 && finger(ii,1)==1
                
                correctans(ii,i) = 'L';%
                
            elseif oddanswers{i}(ii)==0 && evenodd(ii,1)==1 && finger(ii,1)==2
                
                correctans(ii,i) = 'R';%
            
            elseif oddanswers{i}(ii)==0 && evenodd(ii,1)==2 && finger(ii,1)==1
                
                correctans(ii,i) = 'R';%
                
            elseif oddanswers{i}(ii)==0 && evenodd(ii,1)==2 && finger(ii,1)==2
                
                correctans(ii,i) = 'L';%
                
            elseif oddanswers{i}(ii)==1 && evenodd(ii,1)==1 && finger(ii,1)==1
                
                correctans(ii,i) = 'R';%
                
            elseif oddanswers{i}(ii)==1 && evenodd(ii,1)==1 && finger(ii,1)==2
                
                correctans(ii,i) = 'L';%
            
            elseif oddanswers{i}(ii)==1 && evenodd(ii,1)==2 && finger(ii,1)==1
                
                correctans(ii,i) = 'L';%
                
            elseif oddanswers{i}(ii)==1 && evenodd(ii,1)==2 && finger(ii,1)==2
                
                correctans(ii,i) = 'R';%
                
            end
        end
    end
end

%compare correct answers to subject answers, find error trials, error
%rates, etc

for i = 1:size(data,1)
    
    errors(:,i) = strcmp(data{i,8}, correctans(:,i));
    
end

%find and remove incorrect trials

for b = 1:4
    
    error_ind = find(errors(:,b)==0);
    
    ruleRT(error_ind,b) = nan;
    stimRT(error_ind,b) = nan;
    
end

%emg stuff
indices = cellfun(@(x) find(x==0), emg, 'UniformOutput', false);
for t = 1:size(emg,2)
    
    for tt = 1:length(emg)
        
        if indices{tt,t}(end)-indices{tt,t}(1) == length(indices{tt,t})-1
            
            emg_temp{tt,t} = emg{tt,t}(1,1:indices{tt,t}(1)-1);
            
        else
            
            sprintf('Error! Some real values==0 for trial %d!', tt)
            
        end
        
        emg_temp1{tt,t,1} = emg_temp{tt,t}(1:2:end)-mean(emg_temp{tt,t}(1:2:end));
        emg_temp1{tt,t,2} = emg_temp{tt,t}(2:2:end)-mean(emg_temp{tt,t}(2:2:end));
        
        %THIS IS THE WRONG FUCKING WAY TO NORMALIZE YOU DIPSHIT
        %MOTHERFUCKER GODDAMN IT
        %AVERAGE EVERY SINGLE TRIAL, GET THE STD OF THAT, NORM TO THAT
        %VALUE YOU DENSE FUCK
        emg_shitty{tt,t} = emg_temp1{tt,t,1}/std(emg_temp1{tt,t,1});
        emg_shitty{tt,t} = emg_temp1{tt,t,2}/std(emg_temp1{tt,t,2});
        
        
        

    end
end

emg_thres

maxlength = max(max(cell2mat(cellfun(@(x) length(x), emg_temp1, 'UniformOutput', false))));


for b = 1:4
    
    for t = 1:60
        
        init = length(emg_temp1{t,b,1})+1;
        
        emg_temp1{t,b,1}(init:maxlength(1)) = nan;
        emg_temp1{t,b,2}(init:maxlength(1)) = nan;

        
    end
end

b1i = cell2mat(emg_temp1(:,1,1));
b2i = cell2mat(emg_temp1(:,2,1));
b3i = cell2mat(emg_temp1(:,3,1));
b4i = cell2mat(emg_temp1(:,4,1));

b1m = cell2mat(emg_temp1(:,1,2));
b2m = cell2mat(emg_temp1(:,2,2));
b3m = cell2mat(emg_temp1(:,3,2));
b4m = cell2mat(emg_temp1(:,4,2));

allindex = vertcat(b1i,b2i,b3i,b4i);
allmiddle = vertcat(b1m,b2m,b3m,b4m);

meanindex = nanmean(allindex);
meanmiddle = nanmean(allmiddle);

stdindex = nanstd(meanindex);
stdmiddle = nanstd(meanmiddle);

for b = 1:4
    
    for t = 1:60
        
        emg_stdnorm{t,b,1} = emg_temp1{t,b,1}/stdindex;
        emg_stdnorm{t,b,2} = emg_temp1{t,b,2}/stdmiddle;
        
        emg_mmnorm{t,b,1} = emg_temp1{t,b,1}/max_amp_index;
        emg_mmnorm{t,b,2} = emg_temp1{t,b,2}/max_amp_middle;
        
    end
end









































% %do simple t tests on different conditions
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %symbol trial rule RTs; PMd vs. Vertex stimulation
% [H,P,CI] = ttest2([ruleRT(s_trials(:,1),1);ruleRT(s_trials(:,3),3)],...
%     [ruleRT(s_trials(:,2),2);ruleRT(s_trials(:,4),4)]);
% 
% %symbol trial stimulus RTs; PMd vs. Vertex stimulation
% [H,P,CI] = ttest2([stimRT(s_trials(:,1),1);stimRT(s_trials(:,3),3)],...
%     [stimRT(s_trials(:,2),2);stimRT(s_trials(:,4),4)]);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %finger trial rule RTs; PMd vs. Vertex stimulation
% [H,P,CI] = ttest2([ruleRT(f_trials(:,1),1);ruleRT(f_trials(:,3),3)],...
%     [ruleRT(f_trials(:,2),2);ruleRT(f_trials(:,4),4)]);
% 
% %finger trial stimulus RTs; PMd vs. Vertex stimulation
% [H,P,CI] = ttest2([stimRT(f_trials(:,1),1);stimRT(f_trials(:,3),3)],...
%     [stimRT(f_trials(:,2),2);stimRT(f_trials(:,4),4)]);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %early stimulation rule RTs; PMd vs. Vertex stimulation
% [H,P,CI] = ttest2([ruleRT(earlystim(:,1),1);ruleRT(earlystim(:,3),3)],...
%     [ruleRT(earlystim(:,2),2);ruleRT(earlystim(:,4),4)]);
% 
% %early stimulation stim RTs; PMd vs. Vertex stimulation
% [H,P,CI] = ttest2([stimRT(earlystim(:,1),1);stimRT(earlystim(:,3),3)],...
%     [stimRT(earlystim(:,2),2);stimRT(earlystim(:,4),4)]);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %late stimulation rule RTs; PMd vs. Vertex stimulation
% [H,P,CI] = ttest2([ruleRT(latestim(:,1),1);ruleRT(latestim(:,3),3)],...
%     [ruleRT(latestim(:,2),2);ruleRT(latestim(:,4),4)]);
% 
% %late stimulation stimulus RTs; PMd vs. Vertex stimulation
% [H,P,CI] = ttest2([stimRT(latestim(:,1),1);stimRT(latestim(:,3),3)],...
%     [stimRT(latestim(:,2),2);stimRT(latestim(:,4),4)]);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %no stimulation rule RTs; PMd vs. Vertex stimulation
% [H,P,CI] = ttest2([ruleRT(nostim(:,1),1);ruleRT(nostim(:,3),3)],...
%     [ruleRT(nostim(:,2),2);ruleRT(nostim(:,4),4)]);
% 
% %no stimulation stimulus RTs; PMd vs. Vertex stimulation
% [H,P,CI] = ttest2([stimRT(nostim(:,1),1);stimRT(nostim(:,3),3)],...
%     [stimRT(nostim(:,2),2);stimRT(nostim(:,4),4)]);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %early stimulation X symbol trials, rule RTs; PMd vs. Vertex
% [H,P,CI] = ttest2([ruleRT(s_trials_es{1},1);ruleRT(s_trials_es{3},3)],...
%     [ruleRT(s_trials_es{2},2);ruleRT(s_trials_es{4},4)]);
% 
% %early stimulation X symbol trials, stim RTs; PMd vs. Vertex
% [H,P,CI] = ttest2([stimRT(s_trials_es{1},1);stimRT(s_trials_es{3},3)],...
%     [stimRT(s_trials_es{2},2);stimRT(s_trials_es{4},4)]);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %late stimulation X symbol trials, rule RTs; PMd vs. Vertex
% [H,P,CI] = ttest2([ruleRT(s_trials_ls{1},1);ruleRT(s_trials_ls{3},3)],...
%     [ruleRT(s_trials_ls{2},2);ruleRT(s_trials_ls{4},4)]);
% 
% %late stimulation X symbol trials, stim RTs; PMd vs. Vertex
% [H,P,CI] = ttest2([stimRT(s_trials_ls{1},1);stimRT(s_trials_ls{3},3)],...
%     [stimRT(s_trials_ls{2},2);stimRT(s_trials_ls{4},4)]);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %no stimulation X symbol trials, rule RTs; PMd vs. Vertex
% [H,P,CI] = ttest2([ruleRT(s_trials_ns{1},1);ruleRT(s_trials_ns{3},3)],...
%     [ruleRT(s_trials_ns{2},2);ruleRT(s_trials_ns{4},4)]);
% 
% %no stimulation X symbol trials, stim RTs; PMd vs. Vertex
% [H,P,CI] = ttest2([stimRT(s_trials_ns{1},1);stimRT(s_trials_ns{3},3)],...
%     [stimRT(s_trials_ns{2},2);stimRT(s_trials_ns{4},4)]);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %early stimulation X finger trials, rule RTs; PMd vs. Vertex
% [H,P,CI] = ttest2([ruleRT(f_trials_es{1},1);ruleRT(f_trials_es{3},3)],...
%     [ruleRT(f_trials_es{2},2);ruleRT(f_trials_es{4},4)]);
% 
% %early stimulation X finger trials, stim RTs; PMd vs. Vertex
% [H,P,CI] = ttest2([stimRT(f_trials_es{1},1);stimRT(f_trials_es{3},3)],...
%     [stimRT(f_trials_es{2},2);stimRT(f_trials_es{4},4)]);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %late stimulation X finger trials, rule RTs; PMd vs. Vertex
% [H,P,CI] = ttest2([ruleRT(f_trials_ls{1},1);ruleRT(f_trials_ls{3},3)],...
%     [ruleRT(f_trials_ls{2},2);ruleRT(f_trials_ls{4},4)]);
% 
% %late stimulation X finger trials, stim RTs; PMd vs. Vertex
% [H,P,CI] = ttest2([stimRT(f_trials_ls{1},1);stimRT(f_trials_ls{3},3)],...
%     [stimRT(f_trials_ls{2},2);stimRT(f_trials_ls{4},4)]);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %no stimulation X finger trials, rule RTs; PMd vs. Vertex
% [H,P,CI] = ttest2([ruleRT(f_trials_ns{1},1);ruleRT(f_trials_ns{3},3)],...
%     [ruleRT(f_trials_ns{2},2);ruleRT(f_trials_ns{4},4)]);
% 
% %no stimulation X finger trials, stim RTs; PMd vs. Vertex
% [H,P,CI] = ttest2([stimRT(f_trials_ns{1},1);stimRT(f_trials_ns{3},3)],...
%     [stimRT(f_trials_ns{2},2);stimRT(f_trials_ns{4},4)]);


























