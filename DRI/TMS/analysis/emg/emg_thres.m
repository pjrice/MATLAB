

es_index = cat(1,s_trials_es,f_trials_es);
ls_index = cat(1,s_trials_ls,f_trials_ls);

for b = 1:4
    
    for t = 1:length(cat(1,es_index{:,b}))
        
        es_indices = cat(1,es_index{:,b});
        ls_indices = cat(1,ls_index{:,b});
        
        es_emg{t,b,1} = emg_temp1{es_indices(t),b,1}(ts_frames(es_indices(t),3,b)-1500:ts_frames(es_indices(t),3,b)+2000);
        es_emg{t,b,2} = emg_temp1{es_indices(t),b,2}(ts_frames(es_indices(t),3,b)-1500:ts_frames(es_indices(t),3,b)+2000);
        
        ls_emg{t,b,1} = emg_temp1{ls_indices(t),b,1}(ts_frames(ls_indices(t),7,b)-1500:ts_frames(ls_indices(t),7,b)+2000);
        ls_emg{t,b,2} = emg_temp1{ls_indices(t),b,2}(ts_frames(ls_indices(t),7,b)-1500:ts_frames(ls_indices(t),7,b)+2000);
        
    end
end

es_thres = cellfun(@(x) std(x), es_emg, 'UniformOutput', false);
ls_thres = cellfun(@(x) std(x), ls_emg, 'UniformOutput', false);


% for t = 1:20
% 
%     es_mep_ind{t,1} = find(diff(es_emg{t} < 2*es_thres{t})==-1);
%     ls_mep_ind{t,1} = find(diff(ls_emg{t} < 2*ls_thres{t})==-1);
% 
% end

for b = 1:4
    
    for t = 1:20
        
        es_mep_ind{t,b,1} = find(diff(es_emg{t,b,1} < 2*es_thres{t,b,1})==-1);
        ls_mep_ind{t,b,1} = find(diff(ls_emg{t,b,1} < 2*ls_thres{t,b,1})==-1);
        
        es_mep_ind{t,b,2} = find(diff(es_emg{t,b,2} < 2*es_thres{t,b,2})==-1);
        ls_mep_ind{t,b,2} = find(diff(ls_emg{t,b,2} < 2*ls_thres{t,b,2})==-1);
        
    end
    
end


% b=1;
% for t = 1:20
%     
%     plot(ls_emg{t,b,2})
%     hold on
%     plot([xlim],[-2*ls_thres{t,b,2} -2*ls_thres{t,b,2}])
%     plot(diff(ls_emg{t,b,2} < 2*ls_thres{t,b,2}))
%     
%     hold off
%     waitforbuttonpress
% end

% for t = 1:20
%     
%     for m = 1:length(es_mep_ind{t})
%         
%         es_meps{t}(m,:) = es_emg{t,1,1}(es_mep_ind{t}(m)-150:es_mep_ind{t}(m)+150);
%         
%     end
%     
%     for n = 1:length(ls_mep_ind{t})
%         
%         ls_meps{t}(n,:) = ls_emg{t,1,1}(ls_mep_ind{t}(n)-150:ls_mep_ind{t}(n)+150);
%         
%     end
%     
% end

for b = [1 3]
    
    for t = 1:20
        
        for m = 1:length(es_mep_ind{t,b,1})
            
            if es_mep_ind{t,b,1}(m)-150 > 0 && es_mep_ind{t,b,1}(m)+150 < length(es_emg{t,b,1})
            
                es_meps{t,b,1}(m,:) = es_emg{t,b,1}(es_mep_ind{t,b,1}(m)-150:es_mep_ind{t,b,1}(m)+150);
            
            else
                
                es_meps{t,b,1}(m,:) = nan(1,301);
                
            end
            
        end
        
        for m1 = 1:length(es_mep_ind{t,b,2})
            
            if es_mep_ind{t,b,2}(m1)-150 > 0 && es_mep_ind{t,b,2}(m1)+150 < length(es_emg{t,b,2})
            
                es_meps{t,b,2}(m1,:) = es_emg{t,b,2}(es_mep_ind{t,b,2}(m1)-150:es_mep_ind{t,b,2}(m1)+150);
            
            else
                
                es_meps{t,b,2}(m1,:) = nan(1,301);
                
            end
            
        end   
        
        for n = 1:length(ls_mep_ind{t,b,1})
            
            if ls_mep_ind{t,b,1}(n)-150 > 0 && ls_mep_ind{t,b,1}(n)+150 < length(ls_emg{t,b,1})
            
                ls_meps{t,b,1}(n,:) = ls_emg{t,b,1}(ls_mep_ind{t,b,1}(n)-150:ls_mep_ind{t,b,1}(n)+150);
            
            else
                
                ls_meps{t,b,1}(n,:) = nan(1,301);
                
            end
            
        end
        
        for n1 = 1:length(ls_mep_ind{t,b,2})
            
            if ls_mep_ind{t,b,2}(n1)-150 > 0 && ls_mep_ind{t,b,2}(n1)+150 < length(ls_emg{t,b,2})
            
                ls_meps{t,b,2}(n1,:) = ls_emg{t,b,2}(ls_mep_ind{t,b,2}(n1)-150:ls_mep_ind{t,b,2}(n1)+150);
            
            else
                
                ls_meps{t,b,2}(n1,:) = nan(1,301);

            end
            
        end
        
    end
    
end


% 
% b=1;        
% for t = 1:20
%     
%     for m = 1:size(ls_meps{t,b,1},1)
%         
%         plot(ls_meps{t,b,1}(m,:))
%         ylim([-5 5])
%         
%         waitforbuttonpress
%         
%     end
%     
% end

es_mep_mins = cellfun(@(x) min(x,[],2), es_meps, 'UniformOutput', false);
es_mep_maxs = cellfun(@(x) max(x,[],2), es_meps, 'UniformOutput', false);

ls_mep_mins = cellfun(@(x) min(x,[],2), ls_meps, 'UniformOutput', false);
ls_mep_maxs = cellfun(@(x) max(x,[],2), ls_meps, 'UniformOutput', false);
        
es_mep_amps = gsubtract(es_mep_maxs, es_mep_mins);
ls_mep_amps = gsubtract(ls_mep_maxs, ls_mep_mins);

es_temp_amps = cellfun(@(x) max(x), es_mep_amps, 'UniformOutput', false);
ls_temp_amps = cellfun(@(x) max(x), ls_mep_amps, 'UniformOutput', false);

es_max_amp_index = max(cell2mat(es_temp_amps(:,:,1)));
ls_max_amp_index = max(cell2mat(ls_temp_amps(:,:,1)));

es_max_amp_middle = max(cell2mat(es_temp_amps(:,:,2)));
ls_max_amp_middle = max(cell2mat(ls_temp_amps(:,:,2)));

max_amp_index = max([es_max_amp_index ls_max_amp_index]);
max_amp_middle = max([es_max_amp_middle ls_max_amp_middle]);















