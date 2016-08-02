%error rates
%PMd resp errors, finger trials
er_pmdf_ns = sum([errors(f_trials_ns{1},1);errors(f_trials_ns{3},3)])/...
    length([errors(f_trials_ns{1},1);errors(f_trials_ns{3},3)]);

er_pmdf_es = sum([errors(f_trials_es{1},1);errors(f_trials_es{3},3)])/...
    length([errors(f_trials_es{1},1);errors(f_trials_es{3},3)]);

er_pmdf_ls = sum([errors(f_trials_ls{1},1);errors(f_trials_ls{3},3)])/...
    length([errors(f_trials_ls{1},1);errors(f_trials_ls{3},3)]);

%PMd resp errors, symbolic trials
er_pmds_ns = sum([errors(s_trials_ns{1},1);errors(s_trials_ns{3},3)])/...
    length([errors(s_trials_ns{1},1);errors(s_trials_ns{3},3)]);

er_pmds_es = sum([errors(s_trials_es{1},1);errors(s_trials_es{3},3)])/...
    length([errors(s_trials_es{1},1);errors(s_trials_es{3},3)]);

er_pmds_ls = sum([errors(s_trials_ls{1},1);errors(s_trials_ls{3},3)])/...
    length([errors(s_trials_ls{1},1);errors(s_trials_ls{3},3)]);

%Vertex resp errors, finger trials
er_verf_ns = sum([errors(f_trials_ns{2},2);errors(f_trials_ns{4},4)])/...
    length([errors(f_trials_ns{2},2);errors(f_trials_ns{4},4)]);

er_verf_es = sum([errors(f_trials_es{2},2);errors(f_trials_es{4},4)])/...
    length([errors(f_trials_es{2},2);errors(f_trials_es{4},4)]);

er_verf_ls = sum([errors(f_trials_ls{2},2);errors(f_trials_ls{4},4)])/...
    length([errors(f_trials_ls{2},2);errors(f_trials_ls{4},4)]);

%Vertex resp errors, symbolic trials
er_vers_ns = sum([errors(s_trials_ns{2},2);errors(s_trials_ns{4},4)])/...
    length([errors(s_trials_ns{2},2);errors(s_trials_ns{4},4)]);

er_vers_es = sum([errors(s_trials_es{2},2);errors(s_trials_es{4},4)])/...
    length([errors(s_trials_es{2},2);errors(s_trials_es{4},4)]);

er_vers_ls = sum([errors(s_trials_ls{2},2);errors(s_trials_ls{4},4)])/...
    length([errors(s_trials_ls{2},2);errors(s_trials_ls{4},4)]);


%make PMd, error rates figure
h = figure(1);
%add bars/errorbars to first plot, set ylim, label XTicks and y axis
h1 = subplot(1,3,1);
subplot(1,3,1),bar([er_pmds_ns er_pmdf_ns])
hold on
subplot(1,3,1),ylim([0 1.2])
set(h1,'XTickLabel',{'S','F'});
ylabel('success rate')
%add bars/errorbars to second plot, set ylim, label XTicks
h2 = subplot(1,3,2);
subplot(1,3,2),bar([er_pmds_es er_pmdf_es])
hold on
subplot(1,3,2),ylim([0 1.2])
set(h2,'XTickLabel',{'S','F'});
%add bars/errorbars to third plot, set ylim, label XTicks
h3 = subplot(1,3,3);
subplot(1,3,3),bar([er_pmds_ls er_pmdf_ls])
hold on
subplot(1,3,3),ylim([0 1.2])
set(h3,'XTickLabel',{'S','F'});
%set global title
set(gcf,'NextPlot','add');
axes;
htitle = title('Error rates, target: PMd; no stim/early stim/late stim');
set(gca,'Visible','off');
set(htitle,'Visible','on');

h1.Children(1).BarWidth = 0.5;
h2.Children(1).BarWidth = 0.5;
h3.Children(1).BarWidth = 0.5;

%make Vertex, error rates figure
h = figure(1);
%add bars/errorbars to first plot, set ylim, label XTicks and y axis
h1 = subplot(1,3,1);
subplot(1,3,1),bar([er_vers_ns er_verf_ns])
hold on
subplot(1,3,1),ylim([0 1.2])
set(h1,'XTickLabel',{'S','F'});
ylabel('success rate')
%add bars/errorbars to second plot, set ylim, label XTicks
h2 = subplot(1,3,2);
subplot(1,3,2),bar([er_vers_es er_verf_es])
hold on
subplot(1,3,2),ylim([0 1.2])
set(h2,'XTickLabel',{'S','F'});
%add bars/errorbars to third plot, set ylim, label XTicks
h3 = subplot(1,3,3);
subplot(1,3,3),bar([er_vers_ls er_verf_ls])
hold on
subplot(1,3,3),ylim([0 1.2])
set(h3,'XTickLabel',{'S','F'});
%set global title
set(gcf,'NextPlot','add');
axes;
htitle = title('Error rates, target: Vertex; no stim/early stim/late stim');
set(gca,'Visible','off');
set(htitle,'Visible','on');

h1.Children(1).BarWidth = 0.5;
h2.Children(1).BarWidth = 0.5;
h3.Children(1).BarWidth = 0.5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%side by side plot; error rates comparison
h = figure(1);
h1 = subplot(1,3,1);
subplot(1,3,1),bar([er_pmds_ns er_vers_ns;er_pmdf_ns er_verf_ns])
h1.Children(1).BarWidth = 1;
h1.YLim = [0 1.2];
h1.XTickLabel = {'S','F'};
h1.Title.String = 'Success rates, no stim';

hold on;

h2 = subplot(1,3,2);
subplot(1,3,2),bar([er_pmds_es er_vers_es;er_pmdf_es er_verf_es])
h2.Children(1).BarWidth = 1;
h2.YLim = [0 1.2];
h2.XTickLabel = {'S','F'};
h2.Title.String = 'Success rates, early stim';

hold on;

h3 = subplot(1,3,3);
subplot(1,3,3),bar([er_pmds_ls er_vers_ls;er_pmdf_ls er_verf_ls])
h3.Children(1).BarWidth = 1;
h3.YLim = [0 1.2];
h3.XTickLabel = {'S','F'};
h3.Title.String = 'Success rates, late stim';

hold on;

%just drag this shit to a good place
lh = legend('PMd','Vertex');
set(lh,'Location','BestOutside','Orientation','vertical')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%code to make figure w/o block 1 for 2406

%error rates
%PMd resp errors, finger trials
er_pmdf_ns = sum([errors(f_trials_ns{3},3)])/...
    length([errors(f_trials_ns{3},3)]);

er_pmdf_es = sum([errors(f_trials_es{3},3)])/...
    length([errors(f_trials_es{3},3)]);

er_pmdf_ls = sum([errors(f_trials_ls{3},3)])/...
    length([errors(f_trials_ls{3},3)]);

%PMd resp errors, symbolic trials
er_pmds_ns = sum([errors(s_trials_ns{3},3)])/...
    length([errors(s_trials_ns{3},3)]);

er_pmds_es = sum([errors(s_trials_es{3},3)])/...
    length([errors(s_trials_es{3},3)]);

er_pmds_ls = sum([errors(s_trials_ls{3},3)])/...
    length([errors(s_trials_ls{3},3)]);

%Vertex resp errors, finger trials
er_verf_ns = sum([errors(f_trials_ns{4},4)])/...
    length([errors(f_trials_ns{4},4)]);

er_verf_es = sum([errors(f_trials_es{4},4)])/...
    length([errors(f_trials_es{4},4)]);

er_verf_ls = sum([errors(f_trials_ls{4},4)])/...
    length([errors(f_trials_ls{4},4)]);

%Vertex resp errors, symbolic trials
er_vers_ns = sum([errors(s_trials_ns{4},4)])/...
    length([errors(s_trials_ns{4},4)]);

er_vers_es = sum([errors(s_trials_es{4},4)])/...
    length([errors(s_trials_es{4},4)]);

er_vers_ls = sum([errors(s_trials_ls{4},4)])/...
    length([errors(s_trials_ls{4},4)]);

