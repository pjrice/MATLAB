function RR_TMS_2dbarplot(cond1,cond2,cond3,cond4,RTs,err_trial_idx,a)

%generate 2 x three subplots 2d paired bar plots
%in each plot, there are 2 groups of 2 bars each
%each plot is inferred or instructed
%each subplot is data from a stim timing condition (es/ls/ns)
%each group of bars is data from a rule type condition (sym/fin)
%each bar in a group is data from stim area condition (PMd/Ver)

% Argument management:
% arg7 is optional, assumes to plot success trials
% arg1/2/3/4/5/6 are mandatory
if nargin < 7
    
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

%just intersect each page to eventually get fully intersected indices
track=1;
for c1 = 1:size(cond1,3)
    
    for c2 = 1:size(cond2,3)
        
        c12{track,1} = cellfun(@(x,y) intersect(x,y), cond1(:,:,c1), cond2(:,:,c2), 'UniformOutput', false);
        
        track = track+1;
        
    end
end

track=1;
for c12i = 1:size(c12,1)  
    
    for c3 = 1:size(cond3,3)
        
        c123{track,1} = cellfun(@(x,y) intersect(x,y), cond3(:,:,c3), c12{c12i,1}, 'UniformOutput', false);
        
        track = track+1;
    end
end

for c4 = 1:size(cond4,3)
    
    for c123i = 1:size(c123,1)
        
        c1234{c123i,c4} = cellfun(@(x,y) intersect(x,y), cond4(:,:,c4),c123{c123i,1}, 'UniformOutput', false);
        
    end
end
        
      
%get means for the conditions
RTs_bycond = cell(size(c1234));
for i = 1:size(c1234,1)  %by number of condition combos
    
    for ii = 1:size(c1234,2)
        
        RT_vec = nan(sum(sum(cellfun(@length, c1234{i,ii}))),1);
        
        track=1;
        for s = 1:size(cond1,2)  %by subjects
            
            for b = 1:size(cond1,1)
                
                RT_ph = RTs(c1234{i,ii}{b,s},b,s);
                
                RT_vec(track:(track+length(RT_ph)-1)) = RT_ph;
                
                track = track+length(RT_ph);
                
                clear RT_ph
                
            end
        end
        
        RTs_bycond{i,ii} = RT_vec;
        
        clear RT_vec track
        
    end
end

RT_means = cellfun(@(x) mean(x,'omitnan'), RTs_bycond);
RT_sems = cellfun(@(x) sem(x), RTs_bycond);

%prep some things for plotting error bars
numgroups = 2;
numbars = 2;
groupwidth = min(0.8, numbars/(numbars+1.5));

for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

%this is bullshit but I'm tired

%inferred plots
h1 = subplot(1,3,1);
subplot(1,3,1),bar([RT_means(3,1) RT_means(6,1); RT_means(9,1) RT_means(12,1)])
h1.Children(1).BarWidth = 1;
h1.YLim = [0 1.5];
h1.YTick = [0:0.1:1.5];
hold on
h1.YLabel.String = 'Response time (ms)';
h1.XTickLabel = {'S','F'};
h1.Title.String = 'no stim';
errorbar(x, [RT_means(3,1) RT_means(6,1); RT_means(9,1) RT_means(12,1)], [RT_sems(3,1) RT_sems(6,1); RT_sems(9,1) RT_sems(12,1)], 'k', 'linestyle', 'none');

h2 = subplot(1,3,2);
subplot(1,3,2),bar([RT_means(1,1) RT_means(4,1); RT_means(7,1) RT_means(10,1)])
h2.Children(1).BarWidth = 1;
h2.YLim = [0 1.5];
h2.YTick = [0:0.1:1.5];
hold on
h2.XTickLabel = {'S','F'};
h2.Title.String = 'early stim';
errorbar(x, [RT_means(1,1) RT_means(4,1); RT_means(7,1) RT_means(10,1)], [RT_sems(1,1) RT_sems(4,1); RT_sems(7,1) RT_sems(10,1)], 'k', 'linestyle', 'none');

h3 = subplot(1,3,3);
subplot(1,3,3),bar([RT_means(2,1) RT_means(5,1); RT_means(8,1) RT_means(11,1)])
h3.Children(1).BarWidth = 1;
h3.YLim = [0 1.5];
h3.YTick = [0:0.1:1.5];
hold on
% plot(xlim, [ruleRT_control_mean ruleRT_control_mean],'r')
h3.YLabel.String = 'Response time (ms)';
h3.XTickLabel = {'S','F'};
h3.Title.String = 'late stim';
errorbar(x, [RT_means(2,1) RT_means(5,1); RT_means(8,1) RT_means(11,1)], [RT_sems(2,1) RT_sems(5,1); RT_sems(8,1) RT_sems(11,1)], 'k', 'linestyle', 'none');

%instructed plots
h1 = subplot(1,3,1);
subplot(1,3,1),bar([RT_means(3,2) RT_means(6,2); RT_means(9,2) RT_means(12,2)])
h1.Children(1).BarWidth = 1;
h1.YLim = [0 1.5];
h1.YTick = [0:0.1:1.5];
hold on
h1.YLabel.String = 'Response time (ms)';
h1.XTickLabel = {'S','F'};
h1.Title.String = 'no stim';
errorbar(x, [RT_means(3,2) RT_means(6,2); RT_means(9,2) RT_means(12,2)], [RT_sems(3,2) RT_sems(6,2); RT_sems(9,2) RT_sems(12,2)], 'k', 'linestyle', 'none');

h2 = subplot(1,3,2);
subplot(1,3,2),bar([RT_means(1,2) RT_means(4,2); RT_means(7,2) RT_means(10,2)])
h2.Children(1).BarWidth = 1;
h2.YLim = [0 1.5];
h2.YTick = [0:0.1:1.5];
hold on
h2.XTickLabel = {'S','F'};
h2.Title.String = 'early stim';
errorbar(x, [RT_means(1,2) RT_means(4,2); RT_means(7,2) RT_means(10,2)], [RT_sems(1,2) RT_sems(4,2); RT_sems(7,2) RT_sems(10,2)], 'k', 'linestyle', 'none');

h3 = subplot(1,3,3);
subplot(1,3,3),bar([RT_means(2,2) RT_means(5,2); RT_means(8,2) RT_means(11,2)])
h3.Children(1).BarWidth = 1;
h3.YLim = [0 1.5];
h3.YTick = [0:0.1:1.5];
hold on
% plot(xlim, [ruleRT_control_mean ruleRT_control_mean],'r')
h3.YLabel.String = 'Response time (ms)';
h3.XTickLabel = {'S','F'};
h3.Title.String = 'late stim';
errorbar(x, [RT_means(2,2) RT_means(5,2); RT_means(8,2) RT_means(11,2)], [RT_sems(2,2) RT_sems(5,2); RT_sems(8,2) RT_sems(11,2)], 'k', 'linestyle', 'none');






