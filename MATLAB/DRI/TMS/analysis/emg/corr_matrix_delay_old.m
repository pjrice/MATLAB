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




%index
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
            resp_emg_index_delay{b}(:,t+tracker) = emg_proc{cond_index{i,b}(resp_index{i,b}(t)),b}(1,ts_frames(cond_index{i,b}(resp_index{i,b}(t)),6,b):ts_frames(cond_index{i,b}(resp_index{i,b}(t)),8,b)-trim)';
            
        end
        tracker = tracker+ind_length;
    end

end



%middle
for b = 1:4

    resp_emg_middle_delay{b} = nan(5979,tlengths_middle(b));
    tracker = 0;
    for i = 1:length(cond_index)
        
        ind_length = length(cond_index{i,b}(resp_middle{i,b}));
        
        for t = 1:ind_length
            
            trim = length(emg_proc{cond_index{i,b}(resp_middle{i,b}(t)),b}(2,ts_frames(cond_index{i,b}(resp_middle{i,b}(t)),6,b):ts_frames(cond_index{i,b}(resp_middle{i,b}(t)),8,b))') - 5979;
            %if it isn't the proper length, trim to make it the proper
            %length
            %better yet, always trim, and most of the time the trim equals
            %0
            resp_emg_middle_delay{b}(:,t+tracker) = emg_proc{cond_index{i,b}(resp_middle{i,b}(t)),b}(2,ts_frames(cond_index{i,b}(resp_middle{i,b}(t)),6,b):ts_frames(cond_index{i,b}(resp_middle{i,b}(t)),8,b)-trim)';
            
        end
        tracker = tracker+ind_length;
    end

end

for b = 1:4
    
    corr_index_delay{b} = corr(resp_emg_index_delay{b});
    corr_middle_delay{b} = corr(resp_emg_middle_delay{b});

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%find optimal lag for optimal corr, correct, remake corr matrices

for b = 1:4
    
    [xcorrs_index_delay{b} lags_index_delay{b}] = xcorr(resp_emg_index_delay{:,b});
    [xcorrs_middle_delay{b} lags_middle_delay{b}] = xcorr(resp_emg_middle_delay{:,b});
    
    for c = 1:size(xcorrs_index_delay{b},2)
        
        [~,I{b}(c)] = max(abs(xcorrs_index_delay{b}(:,c)));
        lagDiffs_index_delay{b}(c) = lags_index_delay{b}(I{b}(c));
        
    end
    
    
    for c = 1:size(xcorrs_middle_delay{b},2)
        
        [~,I{b}(c)] = max(abs(xcorrs_middle_delay{b}(:,c)));
        lagDiffs_middle_delay{b}(c) = lags_middle_delay{b}(I{b}(c));
        
    end
    
    rs_size_i_delay = [sqrt(size(lagDiffs_index_delay{1,b},2)),sqrt(size(lagDiffs_index_delay{1,b},2))];
    rs_size_m_delay = [sqrt(size(lagDiffs_middle_delay{1,b},2)),sqrt(size(lagDiffs_middle_delay{1,b},2))];
    
    lagDiffs_index_delay{b} = reshape(lagDiffs_index_delay{b},rs_size_i_delay);
    lagDiffs_middle_delay{b} = reshape(lagDiffs_middle_delay{b},rs_size_m_delay);
    
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for b = 1:4
    trackeri = 0;
    trackerm = 0;
    for i = 1:length(cond_index)
        
        ind_length_i = length(cond_index{i,b}(resp_index{i,b}));
        ind_length_m = length(cond_index{i,b}(resp_middle{i,b}));
        
        for t = 1:ind_length_i
            
            condi_index{b}(t+trackeri) = cond_index{i,b}(resp_index{i,b}(t));
            
        end
        trackeri = trackeri+ind_length_i;
        
        for tt = 1:ind_length_m
            
            condi_middle{b}(tt+trackerm) = cond_index{i,b}(resp_middle{i,b}(tt));
            
        end
        trackerm = trackerm+ind_length_m;
        
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%index, lagged
for b = 1:4
    
    lagcorr_i_delay{b} = nan(length(lagDiffs_index_delay{1,b}));
    tester{b} = nan(length(lagDiffs_index_delay{1,b}));

    
    for i = 1:length(lagDiffs_index_delay{1,b})
        
        for ii = 1:length(lagDiffs_index_delay{1,b})
        
            lagcorr_i_delay{b}(ii,i) = corr(emg_proc{condi_index{b}(i),b}(1,ts_frames(condi_index{b}(i),6,b):ts_frames(condi_index{b}(i),8,b))',...
                emg_proc{condi_index{b}(ii),b}(1,ts_frames(condi_index{b}(ii),6,b)+lagDiffs_index_delay{b}(ii,i):ts_frames(condi_index{b}(ii),8,b)+lagDiffs_index_delay{b}(ii,i))');
            
            tester{b}(ii,i) = corr(emg_proc{condi_index{b}(i),b}(1,ts_frames(condi_index{b}(i),6,b):ts_frames(condi_index{b}(i),8,b))',...
                emg_proc{condi_index{b}(ii),b}(1,ts_frames(condi_index{b}(ii),6,b)-lagDiffs_index_delay{b}(ii,i):ts_frames(condi_index{b}(ii),8,b)-lagDiffs_index_delay{b}(ii,i))');
            
        end
    end
end





length(ts_frames(condi_index{b}(i),6,b):ts_frames(condi_index{b}(i),8,b))

length(ts_frames(condi_index{b}(ii),6,b)+lagDiffs_index_delay{b}(ii,i):ts_frames(condi_index{b}(ii),8,b)+lagDiffs_index_delay{b}(ii,i))




















