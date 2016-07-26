%means
%PMd stimulation, rule responses
mean1 = nanmean([ruleRT(s_trials_ns{1},1);ruleRT(s_trials_ns{3},3)]);
mean2 = nanmean([ruleRT(f_trials_ns{1},1);ruleRT(f_trials_ns{3},3)]);

mean3 = nanmean([ruleRT(s_trials_es{1},1);ruleRT(s_trials_es{3},3)]);
mean4 = nanmean([ruleRT(f_trials_es{1},1);ruleRT(f_trials_es{3},3)]);

mean5 = nanmean([ruleRT(s_trials_ls{1},1);ruleRT(s_trials_ls{3},3)]);
mean6 = nanmean([ruleRT(f_trials_ls{1},1);ruleRT(f_trials_ls{3},3)]);
%PMd stimulation, stimulus responses
mean7 = nanmean([stimRT(s_trials_ns{1},1);stimRT(s_trials_ns{3},3)]);
mean8 = nanmean([stimRT(f_trials_ns{1},1);stimRT(f_trials_ns{3},3)]);

mean9 = nanmean([stimRT(s_trials_es{1},1);stimRT(s_trials_es{3},3)]);
mean10 = nanmean([stimRT(f_trials_es{1},1);stimRT(f_trials_es{3},3)]);

mean11 = nanmean([stimRT(s_trials_ls{1},1);stimRT(s_trials_ls{3},3)]);
mean12 = nanmean([stimRT(f_trials_ls{1},1);stimRT(f_trials_ls{3},3)]);
%Vertex stimulation, rule responses
mean13 = nanmean([ruleRT(s_trials_ns{2},2);ruleRT(s_trials_ns{4},4)]);
mean14 = nanmean([ruleRT(f_trials_ns{2},2);ruleRT(f_trials_ns{4},4)]);

mean15 = nanmean([ruleRT(s_trials_es{2},2);ruleRT(s_trials_es{4},4)]);
mean16 = nanmean([ruleRT(f_trials_es{2},2);ruleRT(f_trials_es{4},4)]);

mean17 = nanmean([ruleRT(s_trials_ls{2},2);ruleRT(s_trials_ls{4},4)]);
mean18 = nanmean([ruleRT(f_trials_ls{2},2);ruleRT(f_trials_ls{4},4)]);
%Vertex stimulation, stimulus responses
mean19 = nanmean([stimRT(s_trials_ns{2},2);stimRT(s_trials_ns{4},4)]);
mean20 = nanmean([stimRT(f_trials_ns{2},2);stimRT(f_trials_ns{4},4)]);

mean21 = nanmean([stimRT(s_trials_es{2},2);stimRT(s_trials_es{4},4)]);
mean22 = nanmean([stimRT(f_trials_es{2},2);stimRT(f_trials_es{4},4)]);

mean23 = nanmean([stimRT(s_trials_ls{2},2);stimRT(s_trials_ls{4},4)]);
mean24 = nanmean([stimRT(f_trials_ls{2},2);stimRT(f_trials_ls{4},4)]);



%sems
%PMd stimulation, rule responses
sem1 = nanstd([ruleRT(s_trials_ns{1},1);ruleRT(s_trials_ns{3},3)])/...
    sqrt(length([ruleRT(s_trials_ns{1},1);ruleRT(s_trials_ns{3},3)]));
sem2 = nanstd([ruleRT(f_trials_ns{1},1);ruleRT(f_trials_ns{3},3)])/...
    sqrt(length([ruleRT(f_trials_ns{1},1);ruleRT(f_trials_ns{3},3)]));

sem3 = nanstd([ruleRT(s_trials_es{1},1);ruleRT(s_trials_es{3},3)])/...
    sqrt(length([ruleRT(s_trials_es{1},1);ruleRT(s_trials_es{3},3)]));
sem4 = nanstd([ruleRT(f_trials_es{1},1);ruleRT(f_trials_es{3},3)])/...
    sqrt(length([ruleRT(f_trials_es{1},1);ruleRT(f_trials_es{3},3)]));

sem5 = nanstd([ruleRT(s_trials_ls{1},1);ruleRT(s_trials_ls{3},3)])/...
    sqrt(length([ruleRT(s_trials_ls{1},1);ruleRT(s_trials_ls{3},3)]));
sem6 = nanstd([ruleRT(f_trials_ls{1},1);ruleRT(f_trials_ls{3},3)])/...
    sqrt(length([ruleRT(f_trials_ls{1},1);ruleRT(f_trials_ls{3},3)]));
%PMd stimulation, stimulus responses
sem7 = nanstd([stimRT(s_trials_ns{1},1);stimRT(s_trials_ns{3},3)])/...
    sqrt(length([stimRT(s_trials_ns{1},1);stimRT(s_trials_ns{3},3)]));
sem8 = nanstd([stimRT(f_trials_ns{1},1);stimRT(f_trials_ns{3},3)])/...
    sqrt(length([stimRT(f_trials_ns{1},1);stimRT(f_trials_ns{3},3)]));

sem9 = nanstd([stimRT(s_trials_es{1},1);stimRT(s_trials_es{3},3)])/...
    sqrt(length([stimRT(s_trials_es{1},1);stimRT(s_trials_es{3},3)]));
sem10 = nanstd([stimRT(f_trials_es{1},1);stimRT(f_trials_es{3},3)])/...
    sqrt(length([stimRT(f_trials_es{1},1);stimRT(f_trials_es{3},3)]));

sem11 = nanstd([stimRT(s_trials_ls{1},1);stimRT(s_trials_ls{3},3)])/...
    sqrt(length([stimRT(s_trials_ls{1},1);stimRT(s_trials_ls{3},3)]));
sem12 = nanstd([stimRT(f_trials_ls{1},1);stimRT(f_trials_ls{3},3)])/...
    sqrt(length([stimRT(f_trials_ls{1},1);stimRT(f_trials_ls{3},3)]));
%Vertex stimulation, rule responses
sem13 = nanstd([ruleRT(s_trials_ns{2},2);ruleRT(s_trials_ns{4},4)])/...
    sqrt(length([ruleRT(s_trials_ns{2},2);ruleRT(s_trials_ns{4},4)]));
sem14 = nanstd([ruleRT(f_trials_ns{2},2);ruleRT(f_trials_ns{4},4)])/...
    sqrt(length([ruleRT(f_trials_ns{2},2);ruleRT(f_trials_ns{4},4)]));

sem15 = nanstd([ruleRT(s_trials_es{2},2);ruleRT(s_trials_es{4},4)])/...
    sqrt(length([ruleRT(s_trials_es{2},2);ruleRT(s_trials_es{4},4)]));
sem16 = nanstd([ruleRT(f_trials_es{2},2);ruleRT(f_trials_es{4},4)])/...
    sqrt(length([ruleRT(f_trials_es{2},2);ruleRT(f_trials_es{4},4)]));

sem17 = nanstd([ruleRT(s_trials_ls{2},2);ruleRT(s_trials_ls{4},4)])/...
    sqrt(length([ruleRT(s_trials_ls{2},2);ruleRT(s_trials_ls{4},4)]));
sem18 = nanstd([ruleRT(f_trials_ls{2},2);ruleRT(f_trials_ls{4},4)])/...
    sqrt(length([ruleRT(f_trials_ls{2},2);ruleRT(f_trials_ls{4},4)]));
%Vertex stimulation, stimulus responses
sem19 = nanstd([stimRT(s_trials_ns{2},2);stimRT(s_trials_ns{4},4)])/...
    sqrt(length([stimRT(s_trials_ns{2},2);stimRT(s_trials_ns{4},4)]));
sem20 = nanstd([stimRT(f_trials_ns{2},2);stimRT(f_trials_ns{4},4)])/...
    sqrt(length([stimRT(f_trials_ns{2},2);stimRT(f_trials_ns{4},4)]));

sem21 = nanstd([stimRT(s_trials_es{2},2);stimRT(s_trials_es{4},4)])/...
    sqrt(length([stimRT(s_trials_es{2},2);stimRT(s_trials_es{4},4)]));
sem22 = nanstd([stimRT(f_trials_es{2},2);stimRT(f_trials_es{4},4)])/...
    sqrt(length([stimRT(f_trials_es{2},2);stimRT(f_trials_es{4},4)]));

sem23 = nanstd([stimRT(s_trials_ls{2},2);stimRT(s_trials_ls{4},4)])/...
    sqrt(length([stimRT(s_trials_ls{2},2);stimRT(s_trials_ls{4},4)]));
sem24 = nanstd([stimRT(f_trials_ls{2},2);stimRT(f_trials_ls{4},4)])/...
    sqrt(length([stimRT(f_trials_ls{2},2);stimRT(f_trials_ls{4},4)]));


means = [mean1,mean2,mean3,mean4,mean5,mean6,mean7,mean8,mean9,mean10,...
    mean11,mean12,mean13,mean14,mean15,mean16,mean17,mean18,mean19,mean20...
    ,mean21,mean22,mean23,mean24];
sems = [sem1,sem2,sem3,sem4,sem5,sem6,sem7,sem8,sem9,sem10,sem11,sem12,...
    sem13,sem14,sem15,sem16,sem17,sem18,sem19,sem20,sem21,sem22,sem23,sem24];

%make PMd, rule responses figure
h = figure(1);
%add bars/errorbars to first plot, set ylim, label XTicks and y axis
h1 = subplot(1,3,1);
subplot(1,3,1),bar(means(1:2))
hold on
subplot(1,3,1),errorbar(means(1:2),sems(1:2),'.')
subplot(1,3,1),ylim([0 1.2])
set(h1,'XTickLabel',{'S','F'});
ylabel('seconds')
%add bars/errorbars to second plot, set ylim, label XTicks
h2 = subplot(1,3,2);
subplot(1,3,2),bar(means(3:4))
hold on
subplot(1,3,2),errorbar(means(3:4),sems(3:4),'.')
subplot(1,3,2),ylim([0 1.2])
set(h2,'XTickLabel',{'S','F'});
%add bars/errorbars to third plot, set ylim, label XTicks
h3 = subplot(1,3,3);
subplot(1,3,3),bar(means(5:6))
hold on
subplot(1,3,3),errorbar(means(5:6),sems(5:6),'.')
subplot(1,3,3),ylim([0 1.2])
set(h3,'XTickLabel',{'S','F'});
%set global title
set(gcf,'NextPlot','add');
axes;
htitle = title('rule RTs, target: PMd; no stim/early stim/late stim');
set(gca,'Visible','off');
set(htitle,'Visible','on');

h1.Children(2).BarWidth = 0.5;
h2.Children(2).BarWidth = 0.5;
h3.Children(2).BarWidth = 0.5;

%make PMd, stimulus responses figure
h = figure(2);
%add bars/errorbars to first plot, set ylim, label XTicks and y axis
h1 = subplot(1,3,1);
subplot(1,3,1),bar(means(7:8))
hold on
subplot(1,3,1),errorbar(means(7:8),sems(7:8),'.')
subplot(1,3,1),ylim([0 1.2])
set(h1,'XTickLabel',{'S','F'});
ylabel('seconds')
%add bars/errorbars to second plot, set ylim, label XTicks
h2 = subplot(1,3,2);
subplot(1,3,2),bar(means(9:10))
hold on
subplot(1,3,2),errorbar(means(9:10),sems(9:10),'.')
subplot(1,3,2),ylim([0 1.2])
set(h2,'XTickLabel',{'S','F'});
%add bars/errorbars to third plot, set ylim, label XTicks
h3 = subplot(1,3,3);
subplot(1,3,3),bar(means(11:12))
hold on
subplot(1,3,3),errorbar(means(11:12),sems(11:12),'.')
subplot(1,3,3),ylim([0 1.2])
set(h3,'XTickLabel',{'S','F'});
%set global title
set(gcf,'NextPlot','add');
axes;
htitle = title('stimulus RTs, target: PMd; no stim/early stim/late stim');
set(gca,'Visible','off');
set(htitle,'Visible','on');

h1.Children(2).BarWidth = 0.5;
h2.Children(2).BarWidth = 0.5;
h3.Children(2).BarWidth = 0.5;

%make Vertex, rule responses figure
h = figure(3);
%add bars/errorbars to first plot, set ylim, label XTicks and y axis
h1 = subplot(1,3,1);
subplot(1,3,1),bar(means(13:14))
hold on
subplot(1,3,1),errorbar(means(13:14),sems(13:14),'.')
subplot(1,3,1),ylim([0 1.2])
set(h1,'XTickLabel',{'S','F'});
ylabel('seconds')
%add bars/errorbars to second plot, set ylim, label XTicks
h2 = subplot(1,3,2);
subplot(1,3,2),bar(means(15:16))
hold on
subplot(1,3,2),errorbar(means(15:16),sems(15:16),'.')
subplot(1,3,2),ylim([0 1.2])
set(h2,'XTickLabel',{'S','F'});
%add bars/errorbars to third plot, set ylim, label XTicks
h3 = subplot(1,3,3);
subplot(1,3,3),bar(means(17:18))
hold on
subplot(1,3,3),errorbar(means(17:18),sems(17:18),'.')
subplot(1,3,3),ylim([0 1.2])
set(h3,'XTickLabel',{'S','F'});
%set global title
set(gcf,'NextPlot','add');
axes;
htitle = title('rule RTs, target: Vertex; no stim/early stim/late stim');
set(gca,'Visible','off');
set(htitle,'Visible','on');

h1.Children(2).BarWidth = 0.5;
h2.Children(2).BarWidth = 0.5;
h3.Children(2).BarWidth = 0.5;

%make Vertex, stimulus responses figure
h = figure(4);
%add bars/errorbars to first plot, set ylim, label XTicks and y axis
h1 = subplot(1,3,1);
subplot(1,3,1),bar(means(19:20))
hold on
subplot(1,3,1),errorbar(means(19:20),sems(19:20),'.')
subplot(1,3,1),ylim([0 1.2])
set(h1,'XTickLabel',{'S','F'});
ylabel('seconds')
%add bars/errorbars to second plot, set ylim, label XTicks
h2 = subplot(1,3,2);
subplot(1,3,2),bar(means(21:22))
hold on
subplot(1,3,2),errorbar(means(21:22),sems(21:22),'.')
subplot(1,3,2),ylim([0 1.2])
set(h2,'XTickLabel',{'S','F'});
%add bars/errorbars to third plot, set ylim, label XTicks
h3 = subplot(1,3,3);
subplot(1,3,3),bar(means(23:24))
hold on
subplot(1,3,3),errorbar(means(23:24),sems(23:24),'.')
subplot(1,3,3),ylim([0 1.2])
set(h3,'XTickLabel',{'S','F'});
%set global title
set(gcf,'NextPlot','add');
axes;
htitle = title('stimulus RTs, target: Vertex; no stim/early stim/late stim');
set(gca,'Visible','off');
set(htitle,'Visible','on');

h1.Children(2).BarWidth = 0.5;
h2.Children(2).BarWidth = 0.5;
h3.Children(2).BarWidth = 0.5;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%side by side plot; rule RTs
numgroups = 2;
numbars = 2;
groupwidth = min(0.8, numbars/(numbars+1.5));

h = figure(1);
h1 = subplot(1,3,1);
subplot(1,3,1),bar([means(1:2)',means(13:14)'])
h1.Children(1).BarWidth = 1;
h1.YLim = [0 1.6];
h1.XTickLabel = {'S','F'};
h1.Title.String = 'Rule RTs, no stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [means(1:2)',means(13:14)'], [sems(1:2)',sems(13:14)'], 'k', 'linestyle', 'none');
clear x

h2 = subplot(1,3,2);
subplot(1,3,2),bar([means(3:4)',means(15:16)'])
h2.Children(1).BarWidth = 1;
h2.YLim = [0 1.6];
h2.XTickLabel = {'S','F'};
h2.Title.String = 'Rule RTs, early stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [means(3:4)',means(15:16)'], [sems(3:4)',sems(15:16)'], 'k', 'linestyle', 'none');
clear x

h3 = subplot(1,3,3);
subplot(1,3,3),bar([means(5:6)',means(17:18)'])
h3.Children(1).BarWidth = 1;
h3.YLim = [0 1.6];
h3.XTickLabel = {'S','F'};
h3.Title.String = 'Rule RTs, late stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [means(5:6)',means(17:18)'], [sems(5:6)',sems(17:18)'], 'k', 'linestyle', 'none');
clear x


%just drag this shit to a good place
lh = legend('PMd','Vertex');
set(lh,'Location','BestOutside','Orientation','vertical')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%side by side plot; stim RTs
numgroups = 2;
numbars = 2;
groupwidth = min(0.8, numbars/(numbars+1.5));

h = figure(1);
h1 = subplot(1,3,1);
subplot(1,3,1),bar([means(7:8)',means(19:20)'])
h1.Children(1).BarWidth = 1;
h1.YLim = [0 1.6];
h1.XTickLabel = {'S','F'};
h1.Title.String = 'Stim RTs, no stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [means(7:8)',means(19:20)'], [sems(7:8)',sems(19:20)'], 'k', 'linestyle', 'none');
clear x

h2 = subplot(1,3,2);
subplot(1,3,2),bar([means(9:10)',means(21:22)'])
h2.Children(1).BarWidth = 1;
h2.YLim = [0 1.6];
h2.XTickLabel = {'S','F'};
h2.Title.String = 'Stim RTs, early stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [means(9:10)',means(21:22)'], [sems(9:10)',sems(21:22)'], 'k', 'linestyle', 'none');
clear x

h3 = subplot(1,3,3);
subplot(1,3,3),bar([means(11:12)',means(23:24)'])
h3.Children(1).BarWidth = 1;
h3.YLim = [0 1.6];
h3.XTickLabel = {'S','F'};
h3.Title.String = 'Stim RTs, late stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [means(11:12)',means(23:24)'], [sems(11:12)',sems(23:24)'], 'k', 'linestyle', 'none');
clear x


%just drag this shit to a good place
lh = legend('PMd','Vertex');
set(lh,'Location','BestOutside','Orientation','vertical')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%code to generate same plots for 2406 without 1st block (due to coil drift)

%PMd stimulation, rule responses, block 3
mean1 = mean([ruleRT(s_trials_ns{3},3)]);
mean2 = mean([ruleRT(f_trials_ns{3},3)]);

mean3 = mean([ruleRT(s_trials_es{3},3)]);
mean4 = mean([ruleRT(f_trials_es{3},3)]);

mean5 = mean([ruleRT(s_trials_ls{3},3)]);
mean6 = mean([ruleRT(f_trials_ls{3},3)]);
%PMd stimulation, stimulus responses, block 3
mean7 = mean([stimRT(s_trials_ns{3},3)]);
mean8 = mean([stimRT(f_trials_ns{3},3)]);

mean9 = mean([stimRT(s_trials_es{3},3)]);
mean10 = mean([stimRT(f_trials_es{3},3)]);

mean11 = mean([stimRT(s_trials_ls{3},3)]);
mean12 = mean([stimRT(f_trials_ls{3},3)]);

%Vertex stimulation, rule responses
mean13 = mean([ruleRT(s_trials_ns{2},2);ruleRT(s_trials_ns{4},4)]);
mean14 = mean([ruleRT(f_trials_ns{2},2);ruleRT(f_trials_ns{4},4)]);

mean15 = mean([ruleRT(s_trials_es{2},2);ruleRT(s_trials_es{4},4)]);
mean16 = mean([ruleRT(f_trials_es{2},2);ruleRT(f_trials_es{4},4)]);

mean17 = mean([ruleRT(s_trials_ls{2},2);ruleRT(s_trials_ls{4},4)]);
mean18 = mean([ruleRT(f_trials_ls{2},2);ruleRT(f_trials_ls{4},4)]);
%Vertex stimulation, stimulus responses
mean19 = mean([stimRT(s_trials_ns{2},2);stimRT(s_trials_ns{4},4)]);
mean20 = mean([stimRT(f_trials_ns{2},2);stimRT(f_trials_ns{4},4)]);

mean21 = mean([stimRT(s_trials_es{2},2);stimRT(s_trials_es{4},4)]);
mean22 = mean([stimRT(f_trials_es{2},2);stimRT(f_trials_es{4},4)]);

mean23 = mean([stimRT(s_trials_ls{2},2);stimRT(s_trials_ls{4},4)]);
mean24 = mean([stimRT(f_trials_ls{2},2);stimRT(f_trials_ls{4},4)]);

%PMd stimulation, rule responses, block 3
sem1 = std([ruleRT(s_trials_ns{3},3)])/...
    sqrt(length([ruleRT(s_trials_ns{3},3)]));
sem2 = std([ruleRT(f_trials_ns{3},3)])/...
    sqrt(length([ruleRT(f_trials_ns{3},3)]));

sem3 = std([ruleRT(s_trials_es{3},3)])/...
    sqrt(length([ruleRT(s_trials_es{3},3)]));
sem4 = std([ruleRT(f_trials_es{3},3)])/...
    sqrt(length([ruleRT(f_trials_es{3},3)]));

sem5 = std([ruleRT(s_trials_ls{3},3)])/...
    sqrt(length([ruleRT(s_trials_ls{3},3)]));
sem6 = std([ruleRT(f_trials_ls{3},3)])/...
    sqrt(length([ruleRT(f_trials_ls{3},3)]));
%PMd stimulation, stimulus responses, block 3
sem7 = std([stimRT(s_trials_ns{3},3)])/...
    sqrt(length([stimRT(s_trials_ns{3},3)]));
sem8 = std([stimRT(f_trials_ns{3},3)])/...
    sqrt(length([stimRT(f_trials_ns{3},3)]));

sem9 = std([stimRT(s_trials_es{3},3)])/...
    sqrt(length([stimRT(s_trials_es{3},3)]));
sem10 = std([stimRT(f_trials_es{3},3)])/...
    sqrt(length([stimRT(f_trials_es{3},3)]));

sem11 = std([stimRT(s_trials_ls{3},3)])/...
    sqrt(length([stimRT(s_trials_ls{3},3)]));
sem12 = std([stimRT(f_trials_ls{3},3)])/...
    sqrt(length([stimRT(f_trials_ls{3},3)]));

%Vertex stimulation, rule responses
sem13 = std([ruleRT(s_trials_ns{2},2);ruleRT(s_trials_ns{4},4)])/...
    sqrt(length([ruleRT(s_trials_ns{2},2);ruleRT(s_trials_ns{4},4)]));
sem14 = std([ruleRT(f_trials_ns{2},2);ruleRT(f_trials_ns{4},4)])/...
    sqrt(length([ruleRT(f_trials_ns{2},2);ruleRT(f_trials_ns{4},4)]));

sem15 = std([ruleRT(s_trials_es{2},2);ruleRT(s_trials_es{4},4)])/...
    sqrt(length([ruleRT(s_trials_es{2},2);ruleRT(s_trials_es{4},4)]));
sem16 = std([ruleRT(f_trials_es{2},2);ruleRT(f_trials_es{4},4)])/...
    sqrt(length([ruleRT(f_trials_es{2},2);ruleRT(f_trials_es{4},4)]));

sem17 = std([ruleRT(s_trials_ls{2},2);ruleRT(s_trials_ls{4},4)])/...
    sqrt(length([ruleRT(s_trials_ls{2},2);ruleRT(s_trials_ls{4},4)]));
sem18 = std([ruleRT(f_trials_ls{2},2);ruleRT(f_trials_ls{4},4)])/...
    sqrt(length([ruleRT(f_trials_ls{2},2);ruleRT(f_trials_ls{4},4)]));
%Vertex stimulation, stimulus responses
sem19 = std([stimRT(s_trials_ns{2},2);stimRT(s_trials_ns{4},4)])/...
    sqrt(length([stimRT(s_trials_ns{2},2);stimRT(s_trials_ns{4},4)]));
sem20 = std([stimRT(f_trials_ns{2},2);stimRT(f_trials_ns{4},4)])/...
    sqrt(length([stimRT(f_trials_ns{2},2);stimRT(f_trials_ns{4},4)]));

sem21 = std([stimRT(s_trials_es{2},2);stimRT(s_trials_es{4},4)])/...
    sqrt(length([stimRT(s_trials_es{2},2);stimRT(s_trials_es{4},4)]));
sem22 = std([stimRT(f_trials_es{2},2);stimRT(f_trials_es{4},4)])/...
    sqrt(length([stimRT(f_trials_es{2},2);stimRT(f_trials_es{4},4)]));

sem23 = std([stimRT(s_trials_ls{2},2);stimRT(s_trials_ls{4},4)])/...
    sqrt(length([stimRT(s_trials_ls{2},2);stimRT(s_trials_ls{4},4)]));
sem24 = std([stimRT(f_trials_ls{2},2);stimRT(f_trials_ls{4},4)])/...
    sqrt(length([stimRT(f_trials_ls{2},2);stimRT(f_trials_ls{4},4)]));


means = [mean1,mean2,mean3,mean4,mean5,mean6,mean7,mean8,mean9,mean10,...
    mean11,mean12,mean13,mean14,mean15,mean16,mean17,mean18,mean19,mean20...
    ,mean21,mean22,mean23,mean24];
sems = [sem1,sem2,sem3,sem4,sem5,sem6,sem7,sem8,sem9,sem10,sem11,sem12,...
    sem13,sem14,sem15,sem16,sem17,sem18,sem19,sem20,sem21,sem22,sem23,sem24];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%code to compare b1+3 to b3 only for 2406

%PMd stimulation, rule responses
mean1 = mean([ruleRT(s_trials_ns{1},1);ruleRT(s_trials_ns{3},3)]);
mean2 = mean([ruleRT(f_trials_ns{1},1);ruleRT(f_trials_ns{3},3)]);

mean3 = mean([ruleRT(s_trials_es{1},1);ruleRT(s_trials_es{3},3)]);
mean4 = mean([ruleRT(f_trials_es{1},1);ruleRT(f_trials_es{3},3)]);

mean5 = mean([ruleRT(s_trials_ls{1},1);ruleRT(s_trials_ls{3},3)]);
mean6 = mean([ruleRT(f_trials_ls{1},1);ruleRT(f_trials_ls{3},3)]);
%PMd stimulation, stimulus responses
mean7 = mean([stimRT(s_trials_ns{1},1);stimRT(s_trials_ns{3},3)]);
mean8 = mean([stimRT(f_trials_ns{1},1);stimRT(f_trials_ns{3},3)]);

mean9 = mean([stimRT(s_trials_es{1},1);stimRT(s_trials_es{3},3)]);
mean10 = mean([stimRT(f_trials_es{1},1);stimRT(f_trials_es{3},3)]);

mean11 = mean([stimRT(s_trials_ls{1},1);stimRT(s_trials_ls{3},3)]);
mean12 = mean([stimRT(f_trials_ls{1},1);stimRT(f_trials_ls{3},3)]);

%PMd stimulation, rule responses, block 3
mean13 = mean([ruleRT(s_trials_ns{3},3)]);
mean14 = mean([ruleRT(f_trials_ns{3},3)]);

mean15 = mean([ruleRT(s_trials_es{3},3)]);
mean16 = mean([ruleRT(f_trials_es{3},3)]);

mean17 = mean([ruleRT(s_trials_ls{3},3)]);
mean18 = mean([ruleRT(f_trials_ls{3},3)]);
%PMd stimulation, stimulus responses, block 3
mean19 = mean([stimRT(s_trials_ns{3},3)]);
mean20 = mean([stimRT(f_trials_ns{3},3)]);

mean21 = mean([stimRT(s_trials_es{3},3)]);
mean22 = mean([stimRT(f_trials_es{3},3)]);

mean23 = mean([stimRT(s_trials_ls{3},3)]);
mean24 = mean([stimRT(f_trials_ls{3},3)]);

%sems
%PMd stimulation, rule responses
sem1 = std([ruleRT(s_trials_ns{1},1);ruleRT(s_trials_ns{3},3)])/...
    sqrt(length([ruleRT(s_trials_ns{1},1);ruleRT(s_trials_ns{3},3)]));
sem2 = std([ruleRT(f_trials_ns{1},1);ruleRT(f_trials_ns{3},3)])/...
    sqrt(length([ruleRT(f_trials_ns{1},1);ruleRT(f_trials_ns{3},3)]));

sem3 = std([ruleRT(s_trials_es{1},1);ruleRT(s_trials_es{3},3)])/...
    sqrt(length([ruleRT(s_trials_es{1},1);ruleRT(s_trials_es{3},3)]));
sem4 = std([ruleRT(f_trials_es{1},1);ruleRT(f_trials_es{3},3)])/...
    sqrt(length([ruleRT(f_trials_es{1},1);ruleRT(f_trials_es{3},3)]));

sem5 = std([ruleRT(s_trials_ls{1},1);ruleRT(s_trials_ls{3},3)])/...
    sqrt(length([ruleRT(s_trials_ls{1},1);ruleRT(s_trials_ls{3},3)]));
sem6 = std([ruleRT(f_trials_ls{1},1);ruleRT(f_trials_ls{3},3)])/...
    sqrt(length([ruleRT(f_trials_ls{1},1);ruleRT(f_trials_ls{3},3)]));
%PMd stimulation, stimulus responses
sem7 = std([stimRT(s_trials_ns{1},1);stimRT(s_trials_ns{3},3)])/...
    sqrt(length([stimRT(s_trials_ns{1},1);stimRT(s_trials_ns{3},3)]));
sem8 = std([stimRT(f_trials_ns{1},1);stimRT(f_trials_ns{3},3)])/...
    sqrt(length([stimRT(f_trials_ns{1},1);stimRT(f_trials_ns{3},3)]));

sem9 = std([stimRT(s_trials_es{1},1);stimRT(s_trials_es{3},3)])/...
    sqrt(length([stimRT(s_trials_es{1},1);stimRT(s_trials_es{3},3)]));
sem10 = std([stimRT(f_trials_es{1},1);stimRT(f_trials_es{3},3)])/...
    sqrt(length([stimRT(f_trials_es{1},1);stimRT(f_trials_es{3},3)]));

sem11 = std([stimRT(s_trials_ls{1},1);stimRT(s_trials_ls{3},3)])/...
    sqrt(length([stimRT(s_trials_ls{1},1);stimRT(s_trials_ls{3},3)]));
sem12 = std([stimRT(f_trials_ls{1},1);stimRT(f_trials_ls{3},3)])/...
    sqrt(length([stimRT(f_trials_ls{1},1);stimRT(f_trials_ls{3},3)]));

%PMd stimulation, rule responses, block 3
sem13 = std([ruleRT(s_trials_ns{3},3)])/...
    sqrt(length([ruleRT(s_trials_ns{3},3)]));
sem14 = std([ruleRT(f_trials_ns{3},3)])/...
    sqrt(length([ruleRT(f_trials_ns{3},3)]));

sem15 = std([ruleRT(s_trials_es{3},3)])/...
    sqrt(length([ruleRT(s_trials_es{3},3)]));
sem16 = std([ruleRT(f_trials_es{3},3)])/...
    sqrt(length([ruleRT(f_trials_es{3},3)]));

sem17 = std([ruleRT(s_trials_ls{3},3)])/...
    sqrt(length([ruleRT(s_trials_ls{3},3)]));
sem18 = std([ruleRT(f_trials_ls{3},3)])/...
    sqrt(length([ruleRT(f_trials_ls{3},3)]));
%PMd stimulation, stimulus responses, block 3
sem19 = std([stimRT(s_trials_ns{3},3)])/...
    sqrt(length([stimRT(s_trials_ns{3},3)]));
sem20 = std([stimRT(f_trials_ns{3},3)])/...
    sqrt(length([stimRT(f_trials_ns{3},3)]));

sem21 = std([stimRT(s_trials_es{3},3)])/...
    sqrt(length([stimRT(s_trials_es{3},3)]));
sem22 = std([stimRT(f_trials_es{3},3)])/...
    sqrt(length([stimRT(f_trials_es{3},3)]));

sem23 = std([stimRT(s_trials_ls{3},3)])/...
    sqrt(length([stimRT(s_trials_ls{3},3)]));
sem24 = std([stimRT(f_trials_ls{3},3)])/...
    sqrt(length([stimRT(f_trials_ls{3},3)]));


means = [mean1,mean2,mean3,mean4,mean5,mean6,mean7,mean8,mean9,mean10,...
    mean11,mean12,mean13,mean14,mean15,mean16,mean17,mean18,mean19,mean20...
    ,mean21,mean22,mean23,mean24];
sems = [sem1,sem2,sem3,sem4,sem5,sem6,sem7,sem8,sem9,sem10,sem11,sem12,...
    sem13,sem14,sem15,sem16,sem17,sem18,sem19,sem20,sem21,sem22,sem23,sem24];

%side by side plot; rule RTs; b1+3 v b3
numgroups = 2;
numbars = 2;
groupwidth = min(0.8, numbars/(numbars+1.5));

h = figure(1);
h1 = subplot(1,3,1);
subplot(1,3,1),bar([means(1:2)',means(13:14)'])
h1.Children(1).BarWidth = 1;
h1.YLim = [0 1.6];
h1.XTickLabel = {'S','F'};
h1.Title.String = 'Rule RTs, no stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [means(1:2)',means(13:14)'], [sems(1:2)',sems(13:14)'], 'k', 'linestyle', 'none');
clear x

h2 = subplot(1,3,2);
subplot(1,3,2),bar([means(3:4)',means(15:16)'])
h2.Children(1).BarWidth = 1;
h2.YLim = [0 1.6];
h2.XTickLabel = {'S','F'};
h2.Title.String = 'Rule RTs, early stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [means(3:4)',means(15:16)'], [sems(3:4)',sems(15:16)'], 'k', 'linestyle', 'none');
clear x

h3 = subplot(1,3,3);
subplot(1,3,3),bar([means(5:6)',means(17:18)'])
h3.Children(1).BarWidth = 1;
h3.YLim = [0 1.6];
h3.XTickLabel = {'S','F'};
h3.Title.String = 'Rule RTs, late stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [means(5:6)',means(17:18)'], [sems(5:6)',sems(17:18)'], 'k', 'linestyle', 'none');
clear x


%just drag this shit to a good place
lh = legend('blocks 1+3','block 3 only');
set(lh,'Location','BestOutside','Orientation','vertical')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%side by side plot; stim RTs
numgroups = 2;
numbars = 2;
groupwidth = min(0.8, numbars/(numbars+1.5));

h = figure(1);
h1 = subplot(1,3,1);
subplot(1,3,1),bar([means(7:8)',means(19:20)'])
h1.Children(1).BarWidth = 1;
h1.YLim = [0 1.6];
h1.XTickLabel = {'S','F'};
h1.Title.String = 'Stim RTs, no stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [means(7:8)',means(19:20)'], [sems(7:8)',sems(19:20)'], 'k', 'linestyle', 'none');
clear x

h2 = subplot(1,3,2);
subplot(1,3,2),bar([means(9:10)',means(21:22)'])
h2.Children(1).BarWidth = 1;
h2.YLim = [0 1.6];
h2.XTickLabel = {'S','F'};
h2.Title.String = 'Stim RTs, early stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [means(9:10)',means(21:22)'], [sems(9:10)',sems(21:22)'], 'k', 'linestyle', 'none');
clear x

h3 = subplot(1,3,3);
subplot(1,3,3),bar([means(11:12)',means(23:24)'])
h3.Children(1).BarWidth = 1;
h3.YLim = [0 1.6];
h3.XTickLabel = {'S','F'};
h3.Title.String = 'Stim RTs, late stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [means(11:12)',means(23:24)'], [sems(11:12)',sems(23:24)'], 'k', 'linestyle', 'none');
clear x


%just drag this shit to a good place
lh = legend('blocks 1+3','block 3 only');
set(lh,'Location','BestOutside','Orientation','vertical')
