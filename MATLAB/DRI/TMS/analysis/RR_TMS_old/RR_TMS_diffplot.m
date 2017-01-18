function RR_TMS_diffplot(cond1,cond2,cond3,cond4,RTs,err_trial_idx,a)

%plots inferred-instructed 2d paired barplot

% Argument management:
% arg7 is optional, assumes to plot success trials
% arg1/2/3/4/5/6 are mandatory
if nargin < 7
    
    a = 1;  %plot success trials
    
end

ylimit = 0.5;

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

%c1234: columns are inferred/instructed
%rows:
%1. S-P-E
%2. S-P-L
%3. S-P-N
%4. S-V-E
%5. S-V-L
%6. S-V-N
%7. F-P-E
%8. F-P-L
%9. F-P-N
%10. F-V-E
%11. F-V-L
%12. F-V-N
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

%remove the NaNs so you get the right error bars
for i = 1:length(RTs_bycond)
    
    RTs_bycond{i,1}(isnan(RTs_bycond{i,1})) = [];
    RTs_bycond{i,2}(isnan(RTs_bycond{i,2})) = [];
    
end

RT_bycond_lengths = cellfun(@length, RTs_bycond);
RT_means = cellfun(@(x) mean(x,'omitnan'), RTs_bycond);
RT_stds = cellfun(@(x) std(x,'omitnan'),RTs_bycond);
RT_sems = cellfun(@(x) sem(x), RTs_bycond);


RT_meandiff = RT_means(:,1)-RT_means(:,2);
for i = 1:length(RT_means)
    
    RT_semdiff(i,1) = sqrt((RT_stds(i,1)^2)/RT_bycond_lengths(i,1) + (RT_stds(i,2)^2)/RT_bycond_lengths(i,2));
    
end

%sqrt of the (sum of the (squared stds divided by the length)) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%prep some things for plotting error bars
numgroups = 2;
numbars = 2;
groupwidth = min(0.8, numbars/(numbars+1.5));

for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

%inferred minus instructed plots
figure(1)
h1 = subplot(1,3,1);
subplot(1,3,1),bar([RT_meandiff(3,1) RT_meandiff(6,1); RT_meandiff(9,1) RT_meandiff(12,1)])
h1.Children(1).BarWidth = 1;
h1.YLim = [-ylimit ylimit];
h1.YTick = [0:0.1:1.5];
hold on
h1.YLabel.String = 'Response time (ms)';
h1.XTickLabel = {'S','F'};
h1.Title.String = 'no stim';
errorbar(x, [RT_meandiff(3,1) RT_meandiff(6,1); RT_meandiff(9,1) RT_meandiff(12,1)], [RT_semdiff(3,1) RT_semdiff(6,1); RT_semdiff(9,1) RT_semdiff(12,1)], 'k', 'linestyle', 'none');

h2 = subplot(1,3,2);
subplot(1,3,2),bar([RT_meandiff(1,1) RT_meandiff(4,1); RT_meandiff(7,1) RT_meandiff(10,1)])
h2.Children(1).BarWidth = 1;
h2.YLim = [-ylimit ylimit];
h2.YTick = [0:0.1:1.5];
hold on
h2.XTickLabel = {'S','F'};
h2.Title.String = 'early stim';
errorbar(x, [RT_meandiff(1,1) RT_meandiff(4,1); RT_meandiff(7,1) RT_meandiff(10,1)], [RT_semdiff(1,1) RT_semdiff(4,1); RT_semdiff(7,1) RT_semdiff(10,1)], 'k', 'linestyle', 'none');

h3 = subplot(1,3,3);
subplot(1,3,3),bar([RT_meandiff(2,1) RT_meandiff(5,1); RT_meandiff(8,1) RT_meandiff(11,1)])
h3.Children(1).BarWidth = 1;
h3.YLim = [-ylimit ylimit];
h3.YTick = [0:0.1:1.5];
hold on
h3.YLabel.String = 'Response time (ms)';
h3.XTickLabel = {'S','F'};
h3.Title.String = 'late stim';
errorbar(x, [RT_meandiff(2,1) RT_meandiff(5,1); RT_meandiff(8,1) RT_meandiff(11,1)], [RT_semdiff(2,1) RT_semdiff(5,1); RT_semdiff(8,1) RT_semdiff(11,1)], 'k', 'linestyle', 'none');

lh = legend('PMd','Vertex');
lh.Position = [0.4939 0.0654 0.0474 0.0395];

%set global title
set(gcf,'NextPlot','add');
axes;
htitle = title(sprintf('Stim RTs, inferred minus instructed. n = %d',s));
set(gca,'Visible','off');
set(htitle,'Visible','on');
htitle.Position = [0.5 1.04 0.5];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2)
%Symbol-PMd
h4 = subplot(4,1,1);
subplot(4,1,1),bar([RT_meandiff(3,1) RT_meandiff(1,1) RT_meandiff(2,1)],'b')
h4.Children(1).BarWidth = 0.5;
h4.YLim = [-ylimit/4 ylimit];
h4.YTick = [0:0.1:1.5];
h4.XTick = [];
hold on
h4.YLabel.String = 'Response time (ms)';
h4.Title.String = 'Symbol-PMd';
errorbar([RT_meandiff(3,1) RT_meandiff(1,1) RT_meandiff(2,1)],[RT_semdiff(3,1) RT_semdiff(1,1) RT_semdiff(2,1)], 'k', 'linestyle', 'none')

%Symbol-Vertex
h5 = subplot(4,1,2);
subplot(4,1,2),bar([RT_meandiff(6,1) RT_meandiff(4,1) RT_meandiff(5,1)],'r')
h5.Children(1).BarWidth = 0.5;
h5.YLim = [-ylimit/4 ylimit];
h5.YTick = [0:0.1:1.5];
h5.XTick = [];
hold on
h5.YLabel.String = 'Response time (ms)';
h5.Title.String = 'Symbol-Vertex';
errorbar([RT_meandiff(6,1) RT_meandiff(4,1) RT_meandiff(5,1)],[RT_semdiff(6,1) RT_semdiff(4,1) RT_semdiff(5,1)], 'k', 'linestyle', 'none')

%Finger-PMd
h6 = subplot(4,1,3);
subplot(4,1,3),bar([RT_meandiff(9,1) RT_meandiff(7,1) RT_meandiff(8,1)],'g')
h6.Children(1).BarWidth = 0.5;
h6.YLim = [-ylimit/4 ylimit];
h6.YTick = [0:0.1:1.5];
h6.XTick = [];
hold on
h6.YLabel.String = 'Response time (ms)';
h6.Title.String = 'Finger-PMd';
errorbar([RT_meandiff(9,1) RT_meandiff(7,1) RT_meandiff(8,1)],[RT_semdiff(9,1) RT_semdiff(7,1) RT_semdiff(8,1)], 'k', 'linestyle', 'none')

%Finger-Vertex
h7 = subplot(4,1,4);
subplot(4,1,4),bar([RT_meandiff(12,1) RT_meandiff(10,1) RT_meandiff(11,1)],'y')
h7.Children(1).BarWidth = 0.5;
h7.YLim = [-ylimit/4 ylimit];
h7.YTick = [0:0.1:1.5];
h7.XLabel.String = 'Stim timing';
h7.XTickLabel = {'ns' 'es' 'ls'};
hold on
h7.YLabel.String = 'Response time (ms)';
h7.Title.String = 'Finger-Vertex';
errorbar([RT_meandiff(12,1) RT_meandiff(10,1) RT_meandiff(11,1)],[RT_semdiff(12,1) RT_semdiff(10,1) RT_semdiff(11,1)], 'k', 'linestyle', 'none')

%set global title
set(gcf,'NextPlot','add');
axes;
htitle = title(sprintf('Stim RTs, inferred minus instructed. n = %d',s));
set(gca,'Visible','off');
set(htitle,'Visible','on');
htitle.Position = [0.5 1.04 0.5];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RT_bycond_lengths_diff = sum(RT_bycond_lengths,2);

inf_control_mean = mean(RT_meandiff([3 6 9 12]));
inf_control_sem = (((RT_meandiff(3)-inf_control_mean)^2) + ((RT_meandiff(6)-inf_control_mean)^2) + ((RT_meandiff(9)-inf_control_mean)^2) + ((RT_meandiff(12)-inf_control_mean)^2))/(sum(([3 6 9 12]))-1); 


RT_infstimeffects = RT_meandiff - inf_control_mean;

%sqrt of the (sum of the (squared stds divided by the length)) 

for i = 1:length(RT_infstimeffects)
    
    RT_infstimeffects_sem(i,1) = sqrt((RT_semdiff(i,1)^2)/RT_bycond_lengths_diff(i,1) + (inf_control_sem^2)/sum(([3 6 9 12])));
end

figure(3)
%Symbol-PMd
h8 = subplot(4,1,1);
subplot(4,1,1),bar([RT_infstimeffects(3,1) RT_infstimeffects(1,1) RT_infstimeffects(2,1)],'b')
h8.Children(1).BarWidth = 0.5;
h8.YLim = [-ylimit/4 ylimit];
h8.YTick = [0:0.1:1.5];
h8.XTick = [];
hold on
h8.YLabel.String = 'Response time (ms)';
h8.Title.String = 'Symbol-PMd';
% errorbar([RT_infstimeffects(3,1) RT_infstimeffects(1,1) RT_infstimeffects(2,1)],[RT_infstimeffects_sem(3,1) RT_infstimeffects_sem(1,1) RT_infstimeffects_sem(2,1)], 'k', 'linestyle', 'none')

%Symbol-Vertex
h9 = subplot(4,1,2);
subplot(4,1,2),bar([RT_infstimeffects(6,1) RT_infstimeffects(4,1) RT_infstimeffects(5,1)],'r')
h9.Children(1).BarWidth = 0.5;
h9.YLim = [-ylimit/4 ylimit];
h9.YTick = [0:0.1:1.5];
h9.XTick = [];
hold on
h9.YLabel.String = 'Response time (ms)';
h9.Title.String = 'Symbol-Vertex';
% errorbar([RT_infstimeffects(6,1) RT_infstimeffects(4,1) RT_infstimeffects(5,1)],[RT_infstimeffects_sem(6,1) RT_infstimeffects_sem(4,1) RT_infstimeffects_sem(5,1)], 'k', 'linestyle', 'none')

%Finger-PMd
h10 = subplot(4,1,3);
subplot(4,1,3),bar([RT_infstimeffects(9,1) RT_infstimeffects(7,1) RT_infstimeffects(8,1)],'g')
h10.Children(1).BarWidth = 0.5;
h10.YLim = [-ylimit/4 ylimit];
h10.YTick = [0:0.1:1.5];
h10.XTick = [];
hold on
h10.YLabel.String = 'Response time (ms)';
h10.Title.String = 'Finger-PMd';
% errorbar([RT_infstimeffects(9,1) RT_infstimeffects(7,1) RT_infstimeffects(8,1)],[RT_infstimeffects_sem(9,1) RT_infstimeffects_sem(7,1) RT_infstimeffects_sem(8,1)], 'k', 'linestyle', 'none')

%Finger-Vertex
h11 = subplot(4,1,4);
subplot(4,1,4),bar([RT_infstimeffects(12,1) RT_infstimeffects(10,1) RT_infstimeffects(11,1)],'y')
h11.Children(1).BarWidth = 0.5;
h11.YLim = [-ylimit/4 ylimit];
h11.YTick = [0:0.1:1.5];
h11.XLabel.String = 'Stim timing';
h11.XTickLabel = {'ns' 'es' 'ls'};
hold on
h11.YLabel.String = 'Response time (ms)';
h11.Title.String = 'Finger-Vertex';
% errorbar([RT_infstimeffects(12,1) RT_infstimeffects(10,1) RT_infstimeffects(11,1)],[RT_infstimeffects_sem(12,1) RT_infstimeffects_sem(10,1) RT_infstimeffects_sem(11,1)], 'k', 'linestyle', 'none')

%set global title
set(gcf,'NextPlot','add');
axes;
htitle = title(sprintf('Stim RTs, (inferred minus instructed) minus mean of no stim(inf-ins). \n Should be effect of stimulation on inferred trials.'));
set(gca,'Visible','off');
set(htitle,'Visible','on');
htitle.Position = [0.5 1.04 0.5];






