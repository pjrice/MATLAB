function RR_TMS_3dbarplot(cond1,cond2,RTs,err_trial_idx,a)

%cond1, cond2, and err_trial idx assumed to be block X subject cells
%containing column vectors of trial condition indexes (in the case of
%cond1/2) or error trials (in the case of err_trial_idx; 1==success trial)
%a is the switch to plot either the error trials(0) or success trials (1)

% Argument management:
% arg5 is optional, assumes to plot success trials
% arg1/2/3/4 are mandatory
if nargin < 5
    
    a = 1;  %plot success trials
    
end

%blank either error or success trials
%since 1 indexes successes in err_trial_idx input, invert to plot them
if a==1
    
    err_trial_idx = cellfun(@(x) not(x), err_trial_idx, 'UniformOutput',false);
        
end

%now NaN the indexed trials
for s = 1:size(cond1,2)  %by subjects
    
    for b = 1:size(cond1,1)  %by blocks
        
        RTs(err_trial_idx{b,s},b,s) = NaN;
        
    end
end

%get indexes of the joint conditions
track=1;
for c1 = 1:size(cond1,3)  %by the first condition
    
    for c2 = 1:size(cond2,3)  %by the second condition
        
        for s = 1:size(cond1,2)  %by subjects
            
            for b = 1:size(cond1,1)  %by blocks
                
                c12{b,s,track} = intersect(cond1{b,s,c1},cond2{b,s,c2});
               
            end
        end
        track = track+1;
    end
end
        




%get means for the conditions
        
        
        

            
            
            
            
