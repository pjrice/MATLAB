function RR_TMS_symloc_barplot(c1234,cond5,RTs,err_trial_idx,a)

if nargin < 7
    
    a = 1;  %plot success trials
    
end

%set plot ylims depending on error or success
if a==1
    ylimit = 2.0;
elseif a==0 
    ylimit = 3.0;
else   
    error('Ya done fucked up - plot successful or error trials?')   
end

%blank either error or success trials
%since 1 indexes successes in err_trial_idx input, invert to plot them
if a==1
    
    err_trial_idx = cellfun(@(x) not(x), err_trial_idx, 'UniformOutput',false);
        
end

%now NaN the indexed trials
for s = 1:size(c1234{1,1},2)  %by subjects
    
    for b = 1:size(c1234{1,1},1)  %by blocks
        
        RTs(err_trial_idx{b,s},b,s) = NaN;
        
    end
end

%remove bottom half of c1234 - these are all finger trials (shouldnt matter
%where A is)

c1234(length(c1234)/2+1:end,:) = [];

%get intersect of symbol trials and A left/right



for i = 1:size(c1234,1)  %by number of condition combos
    
    for ii = 1:size(c1234,2)  %by inf/ins
        
        for s = 1:size(c1234{1,1},2)  %by subjects
            
            for b = 1:size(c1234{1,1},1)  %by blocks
                
                Aleft_trials{i,ii}{b,s} = intersect(c1234{i,ii}{b,s},find(cond5{b,s}==0));
                Aright_trials{i,ii}{b,s} = intersect(c1234{i,ii}{b,s},find(cond5{b,s}==1));
                
            end
        end
    end
end


Aleft_RTs_bycondbysubj = cell(size(Aleft_trials));
Aright_RTs_bycondbysubj = cell(size(Aright_trials));
for i = 1:size(c1234,1)  %by number of condition combos
    
    for ii = 1:size(c1234,2)  %by inf/ins
        
        for s = 1:size(c1234{1,1},2)  %by subjects
            
            for b = 1:size(c1234{1,1},1)  %by blocks
                
                Aleft_RTs_bycondbysubj{i,ii}{b,s} = RTs(Aleft_trials{i,ii}{b,s},b,s);
                Aright_RTs_bycondbysubj{i,ii}{b,s} = RTs(Aright_trials{i,ii}{b,s},b,s);
                
            end
        end
    end
end

%remove the NaNs so you get the right error bars
for i = 1:length(Aleft_RTs_bycondbysubj)
    
    for s = 1:size(c1234{1,1},2)  %by subjects
        
        for b = 1:size(c1234{1,1},1)  %by blocks
            
            Aleft_RTs_bycondbysubj{i,1}{b,s}(isnan(Aleft_RTs_bycondbysubj{i,1}{b,s})) = [];
            Aleft_RTs_bycondbysubj{i,2}{b,s}(isnan(Aleft_RTs_bycondbysubj{i,2}{b,s})) = [];
            
            Aright_RTs_bycondbysubj{i,1}{b,s}(isnan(Aright_RTs_bycondbysubj{i,1}{b,s})) = [];
            Aright_RTs_bycondbysubj{i,2}{b,s}(isnan(Aright_RTs_bycondbysubj{i,2}{b,s})) = [];
            
        end
    end
end

%get mean for each subject (so you have 7 means for each condition)
%then get mean across subjects, and SEM from that
for i = 1:length(Aleft_RTs_bycondbysubj)
    
    for s = 1:size(c1234{1,1},2)  %by subjects
        
        Aleft_RT_means_bysubj{i,1}(s) = mean(vertcat(Aleft_RTs_bycondbysubj{i,1}{:,s}));
        Aleft_RT_means_bysubj{i,2}(s) = mean(vertcat(Aleft_RTs_bycondbysubj{i,2}{:,s}));
        
        Aright_RT_means_bysubj{i,1}(s) = mean(vertcat(Aright_RTs_bycondbysubj{i,1}{:,s}));
        Aright_RT_means_bysubj{i,2}(s) = mean(vertcat(Aright_RTs_bycondbysubj{i,2}{:,s}));
        
    end
    
    Aleft_RT_means_bysubj{i,1}(isnan(Aleft_RT_means_bysubj{i,1})) = [];
    Aleft_RT_means_bysubj{i,2}(isnan(Aleft_RT_means_bysubj{i,2})) = [];
    
    Aright_RT_means_bysubj{i,1}(isnan(Aright_RT_means_bysubj{i,1})) = [];
    Aright_RT_means_bysubj{i,2}(isnan(Aright_RT_means_bysubj{i,2})) = [];
end


Aleft_RT_means = cell2mat(cellfun(@(x) mean(x), Aleft_RT_means_bysubj, 'UniformOutput', false));
Aleft_RT_sems = cell2mat(cellfun(@(x) sem(x), Aleft_RT_means_bysubj, 'UniformOutput', false));

Aright_RT_means = cell2mat(cellfun(@(x) mean(x), Aright_RT_means_bysubj, 'UniformOutput', false));
Aright_RT_sems = cell2mat(cellfun(@(x) sem(x), Aright_RT_means_bysubj, 'UniformOutput', false));

%A on the left inferred symbol trials
figure(1)
h1 = subplot(1,3,1);
subplot(1,3,1),bar([Aleft_RT_means(3,1) Aleft_RT_means(6,1)]);
h1.Children(1).BarWidth = 0.5;
h1.YLim = [0 ylimit];
h1.YTick = [0:0.1:ylimit];
hold on
h1.YLabel.String = 'Response time (ms)';
h1.XTickLabel = {'PMd','Vertex'};
h1.Title.String = 'no stim';
errorbar([Aleft_RT_means(3,1) Aleft_RT_means(6,1)], [Aleft_RT_sems(3,1) Aleft_RT_sems(6,1)], 'k', 'linestyle', 'none');

h2 = subplot(1,3,2);
subplot(1,3,2),bar([Aleft_RT_means(1,1) Aleft_RT_means(4,1)])
h2.Children(1).BarWidth = 0.5;
h2.YLim = [0 ylimit];
h2.YTick = [0:0.1:ylimit];
hold on
h2.XTickLabel = {'PMd','Vertex'};
h2.Title.String = 'early stim';
errorbar([Aleft_RT_means(1,1) Aleft_RT_means(4,1)], [Aleft_RT_sems(1,1) Aleft_RT_sems(4,1)], 'k', 'linestyle', 'none');

h3 = subplot(1,3,3);
subplot(1,3,3),bar([Aleft_RT_means(2,1) Aleft_RT_means(5,1)])
h3.Children(1).BarWidth = 0.5;
h3.YLim = [0 ylimit];
h3.YTick = [0:0.1:ylimit];
hold on
h3.YLabel.String = 'Response time (ms)';
h3.XTickLabel = {'PMd','Vertex'};
h3.Title.String = 'late stim';
errorbar([Aleft_RT_means(2,1) Aleft_RT_means(5,1)], [Aleft_RT_sems(2,1) Aleft_RT_sems(5,1)], 'k', 'linestyle', 'none');

% lh = legend('PMd','Vertex');
% lh.Position = [0.4939 0.0654 0.0474 0.0395];

%set global title
set(gcf,'NextPlot','add');
axes;
htitle = title(sprintf('Stim RTs, inferred. A is on left. n = %d',s));
set(gca,'Visible','off');
set(htitle,'Visible','on');
htitle.Position = [0.5 1.04 0.5];

%A on the right inferred symbol trials
figure(2)
h1 = subplot(1,3,1);
subplot(1,3,1),bar([Aright_RT_means(3,1) Aright_RT_means(6,1)]);
h1.Children(1).BarWidth = 0.5;
h1.YLim = [0 ylimit];
h1.YTick = [0:0.1:ylimit];
hold on
h1.YLabel.String = 'Response time (ms)';
h1.XTickLabel = {'PMd','Vertex'};
h1.Title.String = 'no stim';
errorbar([Aright_RT_means(3,1) Aright_RT_means(6,1)], [Aright_RT_sems(3,1) Aright_RT_sems(6,1)], 'k', 'linestyle', 'none');

h2 = subplot(1,3,2);
subplot(1,3,2),bar([Aright_RT_means(1,1) Aright_RT_means(4,1)])
h2.Children(1).BarWidth = 0.5;
h2.YLim = [0 ylimit];
h2.YTick = [0:0.1:ylimit];
hold on
h2.XTickLabel = {'PMd','Vertex'};
h2.Title.String = 'early stim';
errorbar([Aright_RT_means(1,1) Aright_RT_means(4,1)], [Aright_RT_sems(1,1) Aright_RT_sems(4,1)], 'k', 'linestyle', 'none');

h3 = subplot(1,3,3);
subplot(1,3,3),bar([Aright_RT_means(2,1) Aright_RT_means(5,1)])
h3.Children(1).BarWidth = 0.5;
h3.YLim = [0 ylimit];
h3.YTick = [0:0.1:ylimit];
hold on
h3.YLabel.String = 'Response time (ms)';
h3.XTickLabel = {'PMd','Vertex'};
h3.Title.String = 'late stim';
errorbar([Aright_RT_means(2,1) Aright_RT_means(5,1)], [Aright_RT_sems(2,1) Aright_RT_sems(5,1)], 'k', 'linestyle', 'none');

% lh = legend('PMd','Vertex');
% lh.Position = [0.4939 0.0654 0.0474 0.0395];

%set global title
set(gcf,'NextPlot','add');
axes;
htitle = title(sprintf('Stim RTs, inferred. A is on right. n = %d',s));
set(gca,'Visible','off');
set(htitle,'Visible','on');
htitle.Position = [0.5 1.04 0.5];

%A on the left instructed symbol trials
figure(3)
h1 = subplot(1,3,1);
subplot(1,3,1),bar([Aleft_RT_means(3,2) Aleft_RT_means(6,2)]);
h1.Children(1).BarWidth = 0.5;
h1.YLim = [0 ylimit];
h1.YTick = [0:0.1:ylimit];
hold on
h1.YLabel.String = 'Response time (ms)';
h1.XTickLabel = {'PMd','Vertex'};
h1.Title.String = 'no stim';
errorbar([Aleft_RT_means(3,2) Aleft_RT_means(6,2)], [Aleft_RT_sems(3,2) Aleft_RT_sems(6,2)], 'k', 'linestyle', 'none');

h2 = subplot(1,3,2);
subplot(1,3,2),bar([Aleft_RT_means(1,2) Aleft_RT_means(4,2)])
h2.Children(1).BarWidth = 0.5;
h2.YLim = [0 ylimit];
h2.YTick = [0:0.1:ylimit];
hold on
h2.XTickLabel = {'PMd','Vertex'};
h2.Title.String = 'early stim';
errorbar([Aleft_RT_means(1,2) Aleft_RT_means(4,2)], [Aleft_RT_sems(1,2) Aleft_RT_sems(4,2)], 'k', 'linestyle', 'none');

h3 = subplot(1,3,3);
subplot(1,3,3),bar([Aleft_RT_means(2,2) Aleft_RT_means(5,2)])
h3.Children(1).BarWidth = 0.5;
h3.YLim = [0 ylimit];
h3.YTick = [0:0.1:ylimit];
hold on
h3.YLabel.String = 'Response time (ms)';
h3.XTickLabel = {'PMd','Vertex'};
h3.Title.String = 'late stim';
errorbar([Aleft_RT_means(2,2) Aleft_RT_means(5,2)], [Aleft_RT_sems(2,2) Aleft_RT_sems(5,2)], 'k', 'linestyle', 'none');

% lh = legend('PMd','Vertex');
% lh.Position = [0.4939 0.0654 0.0474 0.0395];

%set global title
set(gcf,'NextPlot','add');
axes;
htitle = title(sprintf('Stim RTs, instructed. A is on left. n = %d',s));
set(gca,'Visible','off');
set(htitle,'Visible','on');
htitle.Position = [0.5 1.04 0.5];

%A on the right instructed symbol trials
figure(4)
h1 = subplot(1,3,1);
subplot(1,3,1),bar([Aright_RT_means(3,2) Aright_RT_means(6,2)]);
h1.Children(1).BarWidth = 0.5;
h1.YLim = [0 ylimit];
h1.YTick = [0:0.1:ylimit];
hold on
h1.YLabel.String = 'Response time (ms)';
h1.XTickLabel = {'PMd','Vertex'};
h1.Title.String = 'no stim';
errorbar([Aright_RT_means(3,2) Aright_RT_means(6,2)], [Aright_RT_sems(3,2) Aright_RT_sems(6,2)], 'k', 'linestyle', 'none');

h2 = subplot(1,3,2);
subplot(1,3,2),bar([Aright_RT_means(1,2) Aright_RT_means(4,2)])
h2.Children(1).BarWidth = 0.5;
h2.YLim = [0 ylimit];
h2.YTick = [0:0.1:ylimit];
hold on
h2.XTickLabel = {'PMd','Vertex'};
h2.Title.String = 'early stim';
errorbar([Aright_RT_means(1,2) Aright_RT_means(4,2)], [Aright_RT_sems(1,2) Aright_RT_sems(4,2)], 'k', 'linestyle', 'none');

h3 = subplot(1,3,3);
subplot(1,3,3),bar([Aright_RT_means(2,2) Aright_RT_means(5,2)])
h3.Children(1).BarWidth = 0.5;
h3.YLim = [0 ylimit];
h3.YTick = [0:0.1:ylimit];
hold on
h3.YLabel.String = 'Response time (ms)';
h3.XTickLabel = {'PMd','Vertex'};
h3.Title.String = 'late stim';
errorbar([Aright_RT_means(2,2) Aright_RT_means(5,2)], [Aright_RT_sems(2,2) Aright_RT_sems(5,2)], 'k', 'linestyle', 'none');

% lh = legend('PMd','Vertex');
% lh.Position = [0.4939 0.0654 0.0474 0.0395];

%set global title
set(gcf,'NextPlot','add');
axes;
htitle = title(sprintf('Stim RTs, instructed. A is on right. n = %d',s));
set(gca,'Visible','off');
set(htitle,'Visible','on');
htitle.Position = [0.5 1.04 0.5];
                
                
                
                
                
                
                
                
                
                
                
                
                
                