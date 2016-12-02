function RR_TMS_RTdist(cond1,cond2,cond3,cond4,RTs,err_trial_idx,a)

%plot RT distribution for at least one condition
%make the other condition arguments optional; if present, get the indices
%and make all the plots


histfit(RTs_bycond{1,1},20,'normal')
%RTs definitely skewed (not normal); dist arguments that produced skew:
%gamma; inversegaussian; loglogistic; lognormal; nakagami; rayleigh;
%rician; weibull

for i = 1:length(RTs_bycond)
    
    RTs_bycond{i,1}(isnan(RTs_bycond{i,1})) = [];
    RTs_bycond{i,2}(isnan(RTs_bycond{i,2})) = [];
    
end




for i = 1:length(RTs_bycond)
    
    h1 = histfit(RTs_bycond{i,1},20,'gamma');
    h1(1).FaceColor = [0 0 1];
    hold on
    h2 = histfit(RTs_bycond{i,2},20,'gamma');
    h2(1).FaceColor = [0 1 0];
    
    waitforbuttonpress
    close all
    
end
    