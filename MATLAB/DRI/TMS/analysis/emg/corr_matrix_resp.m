
%cond_index: conditionXblock (conditions, rows1-6:
%S_ns;S_es;S_ls;F_ns;F_es;F_ls)
%trials performed under that condition
cond_index = cat(1,s_trials_ns,s_trials_es,s_trials_ls,f_trials_ns,f_trials_es,f_trials_ls);

%resp_index/middle: conditionXblock (conditions, rows1-6:
%S_ns;S_es;S_ls;F_ns;F_es;F_ls)
%indexes cond_index for trials performed under that condition where they responded with
%index/middle finger
%so, cond_index{1,1}(resp_index{1,1}(:)) are trials in the first block 
%that were S_ns and were answered with index finger;
%cond_index{5,3}(resp_middle{5,3}(:)) are trials in the third block
%that were F_es and were answered with middle finger
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

%make actual trial index for each condition and index/middle fingers

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

%convert seconds to frames for timestamps
ts_frames = ts_corr*3000;

%how many trials per block were answered with index and middle fingers
tlengths_index = sum(cellfun(@(x) length(x), resp_index));
tlengths_middle = sum(cellfun(@(x) length(x), resp_middle));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%following loops pull emg traces in a +-750ms window around time of subject
%response, and organize the trials according to the trial type: so, 
%S_ns;S_es;S_ls;F_ns;F_es;F_ls

%index
for b = 1:4

    resp_emg_index{b} = nan(1501,tlengths_index(b));
    tracker = 0;
    for i = 1:length(cond_index)
        
        ind_length = length(cond_index{i,b}(resp_index{i,b}));
        
        for t = 1:ind_length
            
            resp_emg_index{b}(:,t+tracker) = emg_proc{cond_index{i,b}(resp_index{i,b}(t)),b}(1,ts_frames(cond_index{i,b}(resp_index{i,b}(t)),9,b)-750:ts_frames(cond_index{i,b}(resp_index{i,b}(t)),9,b)+750)';
            
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
            
            resp_emg_middle{b}(:,t+tracker) = emg_proc{cond_index{i,b}(resp_middle{i,b}(t)),b}(2,ts_frames(cond_index{i,b}(resp_middle{i,b}(t)),9,b)-750:ts_frames(cond_index{i,b}(resp_middle{i,b}(t)),9,b)+750)';
            
        end
        tracker = tracker+ind_length;
    end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%correlate unlagged emg traces

for b = 1:4
    
    corr_index{b} = corr(resp_emg_index{b});
    corr_middle{b} = corr(resp_emg_middle{b});

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%use xcorr to find emg trace lag with maximal correlation

for b = 1:4
    
    %get correlations at a bunch of different lags
    [xcorrs_index{b} lags_index{b}] = xcorr(resp_emg_index{:,b});
    [xcorrs_middle{b} lags_middle{b}] = xcorr(resp_emg_middle{:,b});
    
    %find the best correlation and index it to find the corresponding lag
    for c = 1:size(xcorrs_index{b},2)
        
        [~,I{b}(c)] = max(abs(xcorrs_index{b}(:,c)));
        lagDiffs_index{b}(c) = lags_index{b}(I{b}(c));
        
    end
    
    
    for c = 1:size(xcorrs_middle{b},2)
        
        [~,I{b}(c)] = max(abs(xcorrs_middle{b}(:,c)));
        lagDiffs_middle{b}(c) = lags_middle{b}(I{b}(c));
        
    end
    
    %reshape the result for easier indexing
    rs_size_i = [sqrt(size(lagDiffs_index{1,b},2)),sqrt(size(lagDiffs_index{1,b},2))];
    rs_size_m = [sqrt(size(lagDiffs_middle{1,b},2)),sqrt(size(lagDiffs_middle{1,b},2))];
    
    lagDiffs_index{b} = reshape(lagDiffs_index{b},rs_size_i);
    lagDiffs_middle{b} = reshape(lagDiffs_middle{b},rs_size_m);
    
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%get correlatins again, but this time with lagged emg traces to maximize 
for b = 1:4
    
    lagcorr_i{b} = nan(length(lagDiffs_index{1,b}));

    
    for i = 1:length(lagDiffs_index{1,b})
        
        for ii = 1:length(lagDiffs_index{1,b})
        
            lagcorr_i{b}(ii,i) = corr(emg_proc{condi_index{b}(i),b}(1,ts_frames(condi_index{b}(i),9,b)-750:ts_frames(condi_index{b}(i),9,b)+750)',...
                emg_proc{condi_index{b}(ii),b}(1,ts_frames(condi_index{b}(ii),9,b)-(750+lagDiffs_index{b}(ii,i)):ts_frames(condi_index{b}(ii),9,b)+(750-lagDiffs_index{b}(ii,i)))');
            
        end
    end
end

for b = 1:4
    
    lagcorr_m{b} = nan(length(lagDiffs_middle{1,b}));

    
    for i = 1:length(lagDiffs_middle{1,b})
        
        for ii = 1:length(lagDiffs_middle{1,b})
        
            lagcorr_m{b}(ii,i) = corr(emg_proc{condi_middle{b}(i),b}(2,ts_frames(condi_middle{b}(i),9,b)-750:ts_frames(condi_middle{b}(i),9,b)+750)',...
                emg_proc{condi_middle{b}(ii),b}(2,ts_frames(condi_middle{b}(ii),9,b)-(750+lagDiffs_middle{b}(ii,i)):ts_frames(condi_middle{b}(ii),9,b)+(750-lagDiffs_middle{b}(ii,i)))');
            
        end
    end
end


axeslabels = cell(6,1);
axeslabels{1,1} = 'S-ns';
axeslabels{2,1} = 'S-es';
axeslabels{3,1} = 'S-ls';
axeslabels{4,1} = 'F-ns';
axeslabels{5,1} = 'F-es';
axeslabels{6,1} = 'F-ls';

z=2;
h1 = figure(1);
imshow(lagcorr_m{z},'Colormap', jet)
h1.Children.XTick = cumsum(cellfun(@(x) length(x), resp_middle(:,z)));
h1.Children.YTick = cumsum(cellfun(@(x) length(x), resp_middle(:,z)));
h1.Children.XTickLabel = axeslabels;
h1.Children.YTickLabel = axeslabels;
h1.Children.Title.String = 'Darby, block 4 (Vertex)';



h1.Children.XTick = cumsum(cellfun(@(x) length(x), resp_middle(:,z)));
h1.Children.YTick = cumsum(cellfun(@(x) length(x), resp_middle(:,z)));



%get histograms of lags to check for normality
%index
for b = 1:4
    
    
    count = 0;
    for i = 1:length(lagDiffs_index{b})-1
        
        ld4h{b}(i+count:length(lagDiffs_index{b})-1+count) = lagDiffs_index{b}(i+1:length(lagDiffs_index{b}),i);
        
        count = count+(length(lagDiffs_index{b})-i);
        
    end
    
    subplot(2,2,b),histogram(ld4h{b})
    subplot(2,2,b),xlim([-1000 1000])
    subplot(2,2,b),title(sprintf('Block %d',b))
    
end

%middle
for b = 1:4
    
    
    count = 0;
    for i = 1:length(lagDiffs_middle{b})-1
        
        ld4h_m{b}(i+count:length(lagDiffs_middle{b})-1+count) = lagDiffs_middle{b}(i+1:length(lagDiffs_middle{b}),i);
        
        count = count+(length(lagDiffs_middle{b})-i);
        
    end
    
    subplot(2,2,b),histogram(ld4h_m{b})
    subplot(2,2,b),xlim([-1000 1000])
    subplot(2,2,b),title(sprintf('Block %d',b))
    
end

