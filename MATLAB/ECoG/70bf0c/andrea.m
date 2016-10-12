
%script to organize data by trial and timestamp for Andrea

behavfile = 'Z:\Work\UW\projects\DRI\ECoG\70bf0c\behav\70bf0c_DRI.mat';
brainbasepath = 'Z:\Work\UW\projects\DRI\ECoG\70bf0c\brain\';
filelist = dir('Z:\Work\UW\projects\DRI\ECoG\70bf0c\brain\70bf0c_DRI_*_trials.mat');

load(behavfile,'evenoddchooser','symfinchooser','symbolchooser','fingerchooser','abchooser','antiabchooser','stimuli','subj_resp','hand')

%make hand clearer
if hand==1
    hand = 'Right';
elseif hand==0
    hand = 'Left';
else 
    error('Hand variable was fucked up!')
end

%convert subject responses into logical
sr_log = cellfun(@(x) x=='L',subj_resp);

%symbol trials presented first

evenpresent = evenoddchooser==1;  %was Even chosen?
fingerpresent = fingerchooser==1;  %was index chosen?
symbolpresent = symbolchooser==1;  %was A chosen?
a_present = abchooser==1;  %on the stimulus screen, was A on the left?
oddanswers = logical(mod(stimuli,2));  %was the answer odd?

%from these, determine correct answer, then compare to actual
symboltrials = cat(2,evenpresent(:,1),symbolpresent,a_present(:,1),oddanswers(:,1));
fingertrials = cat(2,evenpresent(:,2),fingerpresent,oddanswers(:,2));

%find different trial types
%symbol
% 1111 = Even; A; A left; odd answer == press(right/middle) 
% 0111 = Odd; A; A left; odd answer == press(left/index)
% 1101 = Even; A; A right; odd answer == press(left/index)
% 0101 = Odd; A; A right; odd answer == press(right/middle)

% 1110 = Even; A; A left; even answer == press(left/index) 
% 0110 = Odd; A; A left; even answer == press(right/middle)
% 1100 = Even; A; A right; even answer == press(right/middle)
% 0100 = Odd; A; A right; even answer == press(left/index)

% 1011 = Even; B; A left; odd answer == press(left/index)
% 0011 = Odd; B; A left; odd answer == press(right/middle)
% 1001 = Even; B; A right; odd answer == press(right/middle)
% 0001 = Odd; B; A right; odd answer == press(left/index)

% 1010 = Even; B; A left; even answer == press(right/middle)
% 0010 = Odd; B; A left; even answer == press(left/index)
% 1000 = Even; B; A right; even answer == press(left/index)
% 0000 = Odd; B; A right; even answer == press(right/middle)

%first four values in each row are the "bitcodes" listed above to id trial
%type; fifth value in row is the correct answer (1 for left/index, 0 for
%right/middle)
sym_trial_types = [1 1 1 1 0; 0 1 1 1 1; 1 1 0 1 1; 0 1 0 1 0;...
    1 1 1 0 1; 0 1 1 0 0; 1 1 0 0 0; 0 1 0 0 1;...
    1 0 1 1 1; 0 0 1 1 0; 1 0 0 1 0; 0 0 0 1 1;...
    1 0 1 0 0; 0 0 1 0 1; 1 0 0 0 1; 0 0 0 0 0];

for i = 1:length(symboltrials)
    
    for ii = 1:length(sym_trial_types) 
        
        if isequal(symboltrials(i,:),sym_trial_types(ii,1:4)) 
            correct_ans(i,1) = sym_trial_types(ii,5);
        elseif ~isequal(symboltrials(i,:),sym_trial_types(ii,1:4))
            continue
        end
    end
end   

%finger
% 111 = Even; Index; odd answer == press(right/middle)
% 011 = Odd; Index; odd answer == press(left/index)

% 110 = Even; Index; even answer == press(left/index)
% 010 = Odd; Index; even answer == press(right/middle)

% 101 = Even; Middle; odd answer == press(left/index)
% 001 = Odd; Middle; odd answer == press(right/middle)

% 100 = Even; Middle; even answer == press(right/middle)
% 000 = Odd; Middle; even answer == press(left/index)

%first three values in each row are the "bitcodes" listed above to id trial
%type; fourth value in row is the correct answer (1 for left/index, 0 for
%right/middle)
fin_trial_types = [1 1 1 0; 0 1 1 1;...
    1 1 0 1; 0 1 0 0;...
    1 0 1 1; 0 0 1 0;...
    1 0 0 0; 0 0 0 1];

for i = 1:length(fingertrials)
    
    for ii = 1:length(fin_trial_types)
        
        if isequal(fingertrials(i,:),fin_trial_types(ii,1:3))
            correct_ans(i,2) = fin_trial_types(ii,4);
        elseif ~isequal(fingertrials(i,:),fin_trial_types(ii,1:3))
            continue
        end
    end
end

%determine whether the subject got it right or not
%success is trials X blocks
% 1==success
% 0==error
success = arrayfun(@isequal,correct_ans,sr_log);

for f = 1:length(filelist)
    
    load(strcat(brainbasepath,filelist(f).name))
    
    % brain_area (if it exists) is location of linear depth electrode (8-12
    % channels) in the brain
    
    % fs is sampling rate of signal in Hz
    
    % subj_resp is a trials X blocks cell array of subject responses -
    % L::Index; R::Middle
    
    %trial_data is a channel X trial X block cell array containing the
    %electrophysiological data (vectors of varying length per trial)
    
    %MAKE TS_CORR AND TS_SAMP RELATIVE TO INDIVIDUAL TRIAL START
    
    for i = 1:2
        
        for ii = 1:length(ts_corr)
            
            ts_corr(ii,:,i) = ts_corr(ii,:,i) - ts_corr(ii,1,i);
            
        end
    end
    
    clear ts_samp
    
    ts_samp = round(ts_corr.*fs);
    
    %enc_ts and exe_ts are trial X trial phase start/stop X block arrays of
    %the event timestamps in samples relative to trial start
    enc_ts = cat(2,ts_samp(:,4,:),ts_samp(:,5,:));
    
    exe_ts = cat(2,ts_samp(:,8,:),ts_samp(:,9,:));
    
    filename = strcat('Z:\Work\UW\projects\DRI\ECoG\70bf0c\','70bf0c_trials.mat');
    save(filename,'brain_area','correct_ans','enc_ts','exe_ts','fs','hand','success','trial_data','subj_resp')
    
    clearvars -except correct_ans fs hand success f filelist brainbasepath subj_resp
    
end
    
    
    
    
    
    