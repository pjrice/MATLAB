%emg cross correlations for delay phase

cond_index = cat(1,s_trials_ns,s_trials_es,s_trials_ls,f_trials_ns,f_trials_es,f_trials_ls);

for b = 1:4

    resp_index{1,b} = find(cell2mat(data{b,8}(s_trials_ns{b}))=='L');
    resp_middle{1,b} = find(cell2mat(data{b,8}(s_trials_ns{b}))=='R');
    
    resp_index{2,b} = find(cell2mat(data{b,8}(s_trials_es{b}))=='L');
    resp_middle{2,b} = find(cell2mat(data{b,8}(s_trials_es{b}))=='R');
    
    resp_index{3,b} = find(cell2mat(data{b,8}(s_trials_ls{b}))=='L');
    resp_middle{3,b} = find(cell2mat(data{b,8}(s_trials_ls{b}))=='R');
    
    resp_index{4,b} = find(cell2mat(data{b,8}(f_trials_ns{b}))=='L');
    resp_middle{4,b} = find(cell2mat(data{b,8}(f_trials_ns{b}))=='R');
    
    resp_index{5,b} = find(cell2mat(data{b,8}(f_trials_es{b}))=='L');
    resp_middle{5,b} = find(cell2mat(data{b,8}(f_trials_es{b}))=='R');
    
    resp_index{6,b} = find(cell2mat(data{b,8}(f_trials_ls{b}))=='L');
    resp_middle{6,b} = find(cell2mat(data{b,8}(f_trials_ls{b}))=='R');

end

ts_frames = ts_corr*3000;

tlengths_index = sum(cellfun(@(x) length(x), resp_index));
tlengths_middle = sum(cellfun(@(x) length(x), resp_middle));

%index
%vector length for resp_emg_index/middle is hardcoded to 1501 when delay
%phases etc is different

%the lengths of each delay phase are just very slightly different; either
%find the longest and pad the rest, or find the shortest and cut the rest

for b = 1:4
    
    for i = 1:length(cond_index)
        
        ind_length = length(cond_index{i,b}(resp_index{i,b}));
        
        for t = 1:ind_length
            
            fucking_lengths{b}(i,t) = length(emg_proc{cond_index{i,b}(resp_index{i,b}(t)),b}(1,ts_frames(cond_index{i,b}(resp_index{i,b}(t)),6,b):ts_frames(cond_index{i,b}(resp_index{i,b}(t)),8,b))');
            
        end
    end
end



%have I been overwriting emg traces???? CHECK THAT SHIT
%nope, thanks to tracker because I am the tits


for b = 1:4

    resp_emg_index_delay{b} = nan(5979,tlengths_index(b));
    tracker = 0;
    for i = 1:length(cond_index)
        
        ind_length = length(cond_index{i,b}(resp_index{i,b}));
        
        for t = 1:ind_length
            
            trim = length(emg_proc{cond_index{i,b}(resp_index{i,b}(t)),b}(1,ts_frames(cond_index{i,b}(resp_index{i,b}(t)),6,b):ts_frames(cond_index{i,b}(resp_index{i,b}(t)),8,b))') - 5979;
            %if it isn't the proper length, trim to make it the proper
            %length
            %better yet, always trim, and most of the time the trim equals
            %0
            resp_emg_index_delay{b}(:,t+tracker) = emg_proc{cond_index{i,b}(resp_index{i,b}(t)),b}(1,ts_frames(cond_index{i,b}(resp_index{i,b}(t)),6,b):ts_frames(cond_index{i,b}(resp_index{i,b}(t)),8,b))';
            
        end
        tracker = tracker+ind_length;
    end

end

%middle
for b = 1:4

    resp_emg_middle{b} = nan(1501,tlengths_middle(b));
    tracker = 0;
    for i = 1:length(cond_index)
        
        ind_length = length(cond_index{i,b}(resp_middle{i,b}));
        
        for t = 1:ind_length
            
            resp_emg_middle_delay{b}(:,t+tracker) = emg_proc{cond_index{i,b}(resp_middle{i,b}(t)),b}(2,ts_frames(cond_index{i,b}(resp_middle{i,b}(t)),6,b):ts_frames(cond_index{i,b}(resp_middle{i,b}(t)),8,b))';
            
        end
        tracker = tracker+ind_length;
    end

end
