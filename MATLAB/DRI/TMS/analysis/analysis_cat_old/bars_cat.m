%index of block identity (0==PMd, 1==Vertex)


%correct all timestamps to trialstart time
for s = 1:size(ts_cat,4)
    
    ts_corr(:,:,:,s) = gsubtract(ts_cat(:,:,:,s),ts_cat(:,1,:,s));
    
end

%concatenate everything into one huge matrix
track=0;
for s = 1:size(ts_cat,4)
    
    for b = 1:4
        
        ts_all(1+track:60+track,:) = ts_corr(:,:,b,s);
        
        track = track+60;
        
    end
end

track=0;
for s = 1:size(ts_cat,4)
    
    %trials x (condMatrix)(rpspns)(block#)
    fuckit_all(1+track:240+track,:) = fuckit(:,:,s);
    
    track = track+240;
    
end


errors_all = nan(240*size(ts_cat,4),1);
track = 0;
for s = 1:size(ts_cat,4)
    
    for b = 1:4
        
        errors_all(1+track:60+track) = errors(:,b,s);
        
        track = track+60;
        
    end
    
end

fuckit_all(:,3) = blockid_cat;
    
for a = 1:2
    
    indices{1,1,a} = find(fuckit_all(:,1)==0 & fuckit_all(:,2)==0 & fuckit_all(:,3)==a-1);
    indices{1,2,a} = find(fuckit_all(:,1)==0 & fuckit_all(:,2)==1 & fuckit_all(:,3)==a-1);
    indices{1,3,a} = find(fuckit_all(:,1)==0 & fuckit_all(:,2)==2 & fuckit_all(:,3)==a-1);
    indices{2,1,a} = find(fuckit_all(:,1)==1 & fuckit_all(:,2)==0 & fuckit_all(:,3)==a-1);
    indices{2,2,a} = find(fuckit_all(:,1)==1 & fuckit_all(:,2)==1 & fuckit_all(:,3)==a-1);
    indices{2,3,a} = find(fuckit_all(:,1)==1 & fuckit_all(:,2)==2 & fuckit_all(:,3)==a-1);

end



%this is fucked - will sum errors across blocks, regardless of whether it
%is PMd or Vertex
%well, kind of
%sym/fin x es/ls/ns x subj x "block group"
%so, "block group" for some subjs 1==PMd and 2==Vertex, but for others
%in which we started with Vertex as first block, it's switched
for a = 1:2
    
    for s = 1:size(ts_cat,4)
    
        error_rates(1,1,s,a) = sum([errors(s_trials_es{s,a},1,s);errors(s_trials_es{s,a+2},1,s)])/...
            length([errors(s_trials_es{s,a},1,s);errors(s_trials_es{s,a+2},1,s)]);
        
        error_rates(1,2,s,a) = sum([errors(s_trials_ls{s,a},1,s);errors(s_trials_ls{s,a+2},1,s)])/...
            length([errors(s_trials_ls{s,a},1,s);errors(s_trials_ls{s,a+2},1,s)]);
        
        error_rates(1,3,s,a) = sum([errors(s_trials_ns{s,a},1,s);errors(s_trials_ns{s,a+2},1,s)])/...
            length([errors(s_trials_ns{s,a},1,s);errors(s_trials_ns{s,a+2},1,s)]);
        
        error_rates(2,1,s,a) = sum([errors(f_trials_es{s,a},1,s);errors(f_trials_es{s,a+2},1,s)])/...
            length([errors(f_trials_es{s,a},1,s);errors(f_trials_es{s,a+2},1,s)]);
        
        error_rates(2,2,s,a) = sum([errors(f_trials_ls{s,a},1,s);errors(f_trials_ls{s,a+2},1,s)])/...
            length([errors(f_trials_ls{s,a},1,s);errors(f_trials_ls{s,a+2},1,s)]);
        
        error_rates(2,3,s,a) = sum([errors(f_trials_ns{s,a},1,s);errors(f_trials_ns{s,a+2},1,s)])/...
            length([errors(f_trials_ns{s,a},1,s);errors(f_trials_ns{s,a+2},1,s)]);
        
    end
end

error_means = mean(error_rates,3);
error_sems = std(error_rates,0,3)/sqrt(size(ts_cat,4));
error_means = squeeze(error_means);
error_sems = squeeze(error_sems);

%side by side plot; error rates comparison
numgroups = 2;
numbars = 2;
groupwidth = min(0.8, numbars/(numbars+1.5));

h = figure(1);
h1 = subplot(1,3,1);
subplot(1,3,1),bar([error_means(1,3,1) error_means(1,3,2); error_means(2,3,1) error_means(2,3,2)])
h1.Children(1).BarWidth = 1;
h1.YLim = [0 1.05];
h1.YTick = [0:0.1:1];
h1.YLabel.String = 'Success Rate';
h1.XTickLabel = {'S','F'};
h1.Title.String = 'Success rates, no stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [error_means(1,3,1) error_means(1,3,2); error_means(2,3,1) error_means(2,3,2)], [error_sems(1,3,1) error_sems(1,3,2); error_sems(2,3,1) error_sems(2,3,2)], 'k', 'linestyle', 'none');
clear x

h2 = subplot(1,3,2);
subplot(1,3,2),bar([error_means(1,1,1) error_means(1,1,2); error_means(2,1,1) error_means(2,1,2)])
h2.Children(1).BarWidth = 1;
h2.YLim = [0 1.05];
h2.YTick = [0:0.1:1];
h2.XTickLabel = {'S','F'};
h2.Title.String = 'Success rates, early stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [error_means(1,1,1) error_means(1,1,2); error_means(2,1,1) error_means(2,1,2)], [error_sems(1,1,1) error_sems(1,1,2); error_sems(2,1,1) error_sems(2,1,2)], 'k', 'linestyle', 'none');
clear x

h3 = subplot(1,3,3);
subplot(1,3,3),bar([error_means(1,2,1) error_means(1,2,2); error_means(2,2,1) error_means(2,2,2)])
h3.Children(1).BarWidth = 1;
h3.YLim = [0 1.05];
h3.YTick = [0:0.1:1];
h3.XTickLabel = {'S','F'};
h3.Title.String = 'Success rates, late stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [error_means(1,2,1) error_means(1,2,2); error_means(2,2,1) error_means(2,2,2)], [error_sems(1,2,1) error_sems(1,2,2); error_sems(2,2,1) error_sems(2,2,2)], 'k', 'linestyle', 'none');
clear x

%just drag this shit to a good place
lh = legend('PMd','Vertex');
lh.Position = [0.4939 0.0654 0.0474 0.0395];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%RT stuff

ruleRT_all = ts_all(:,5) - ts_all(:,4);
stimRT_all = ts_all(:,9) - ts_all(:,8);


ruleRT_means(1,1,1) = mean(ruleRT_all(indices{1,1,1}(:)),'omitnan');
ruleRT_means(1,2,1) = mean(ruleRT_all(indices{1,2,1}(:)),'omitnan');
ruleRT_means(1,3,1) = mean(ruleRT_all(indices{1,3,1}(:)),'omitnan');
ruleRT_means(2,1,1) = mean(ruleRT_all(indices{2,1,1}(:)),'omitnan');
ruleRT_means(2,2,1) = mean(ruleRT_all(indices{2,2,1}(:)),'omitnan');
ruleRT_means(2,3,1) = mean(ruleRT_all(indices{2,3,1}(:)),'omitnan');

ruleRT_means(1,1,2) = mean(ruleRT_all(indices{1,1,2}(:)),'omitnan');
ruleRT_means(1,2,2) = mean(ruleRT_all(indices{1,2,2}(:)),'omitnan');
ruleRT_means(1,3,2) = mean(ruleRT_all(indices{1,3,2}(:)),'omitnan');
ruleRT_means(2,1,2) = mean(ruleRT_all(indices{2,1,2}(:)),'omitnan');
ruleRT_means(2,2,2) = mean(ruleRT_all(indices{2,2,2}(:)),'omitnan');
ruleRT_means(2,3,2) = mean(ruleRT_all(indices{2,3,2}(:)),'omitnan');

ruleRT_sems(1,1,1) = std(ruleRT_all(indices{1,1,1}(:)),'omitnan')/sqrt(length(ruleRT_all(indices{1,1,1}(:))));
ruleRT_sems(1,2,1) = std(ruleRT_all(indices{1,2,1}(:)),'omitnan')/sqrt(length(ruleRT_all(indices{1,2,1}(:))));
ruleRT_sems(1,3,1) = std(ruleRT_all(indices{1,3,1}(:)),'omitnan')/sqrt(length(ruleRT_all(indices{1,3,1}(:))));
ruleRT_sems(2,1,1) = std(ruleRT_all(indices{2,1,1}(:)),'omitnan')/sqrt(length(ruleRT_all(indices{2,1,1}(:))));
ruleRT_sems(2,2,1) = std(ruleRT_all(indices{2,2,1}(:)),'omitnan')/sqrt(length(ruleRT_all(indices{2,2,1}(:))));
ruleRT_sems(2,3,1) = std(ruleRT_all(indices{2,3,1}(:)),'omitnan')/sqrt(length(ruleRT_all(indices{2,3,1}(:))));

ruleRT_sems(1,1,2) = std(ruleRT_all(indices{1,1,2}(:)),'omitnan')/sqrt(length(ruleRT_all(indices{1,1,2}(:))));
ruleRT_sems(1,2,2) = std(ruleRT_all(indices{1,2,2}(:)),'omitnan')/sqrt(length(ruleRT_all(indices{1,2,2}(:))));
ruleRT_sems(1,3,2) = std(ruleRT_all(indices{1,3,2}(:)),'omitnan')/sqrt(length(ruleRT_all(indices{1,3,2}(:))));
ruleRT_sems(2,1,2) = std(ruleRT_all(indices{2,1,2}(:)),'omitnan')/sqrt(length(ruleRT_all(indices{2,1,2}(:))));
ruleRT_sems(2,2,2) = std(ruleRT_all(indices{2,2,2}(:)),'omitnan')/sqrt(length(ruleRT_all(indices{2,2,2}(:))));
ruleRT_sems(2,3,2) = std(ruleRT_all(indices{2,3,2}(:)),'omitnan')/sqrt(length(ruleRT_all(indices{2,3,2}(:))));





stimRT_means(1,1,1) = mean(stimRT_all(indices{1,1,1}(:)),'omitnan');
stimRT_means(1,2,1) = mean(stimRT_all(indices{1,2,1}(:)),'omitnan');
stimRT_means(1,3,1) = mean(stimRT_all(indices{1,3,1}(:)),'omitnan');
stimRT_means(2,1,1) = mean(stimRT_all(indices{2,1,1}(:)),'omitnan');
stimRT_means(2,2,1) = mean(stimRT_all(indices{2,2,1}(:)),'omitnan');
stimRT_means(2,3,1) = mean(stimRT_all(indices{2,3,1}(:)),'omitnan');

stimRT_means(1,1,2) = mean(stimRT_all(indices{1,1,2}(:)),'omitnan');
stimRT_means(1,2,2) = mean(stimRT_all(indices{1,2,2}(:)),'omitnan');
stimRT_means(1,3,2) = mean(stimRT_all(indices{1,3,2}(:)),'omitnan');
stimRT_means(2,1,2) = mean(stimRT_all(indices{2,1,2}(:)),'omitnan');
stimRT_means(2,2,2) = mean(stimRT_all(indices{2,2,2}(:)),'omitnan');
stimRT_means(2,3,2) = mean(stimRT_all(indices{2,3,2}(:)),'omitnan');

stimRT_sems(1,1,1) = std(stimRT_all(indices{1,1,1}(:)),'omitnan')/sqrt(length(stimRT_all(indices{1,1,1}(:))));
stimRT_sems(1,2,1) = std(stimRT_all(indices{1,2,1}(:)),'omitnan')/sqrt(length(stimRT_all(indices{1,2,1}(:))));
stimRT_sems(1,3,1) = std(stimRT_all(indices{1,3,1}(:)),'omitnan')/sqrt(length(stimRT_all(indices{1,3,1}(:))));
stimRT_sems(2,1,1) = std(stimRT_all(indices{2,1,1}(:)),'omitnan')/sqrt(length(stimRT_all(indices{2,1,1}(:))));
stimRT_sems(2,2,1) = std(stimRT_all(indices{2,2,1}(:)),'omitnan')/sqrt(length(stimRT_all(indices{2,2,1}(:))));
stimRT_sems(2,3,1) = std(stimRT_all(indices{2,3,1}(:)),'omitnan')/sqrt(length(stimRT_all(indices{2,3,1}(:))));

stimRT_sems(1,1,2) = std(stimRT_all(indices{1,1,2}(:)),'omitnan')/sqrt(length(stimRT_all(indices{1,1,2}(:))));
stimRT_sems(1,2,2) = std(stimRT_all(indices{1,2,2}(:)),'omitnan')/sqrt(length(stimRT_all(indices{1,2,2}(:))));
stimRT_sems(1,3,2) = std(stimRT_all(indices{1,3,2}(:)),'omitnan')/sqrt(length(stimRT_all(indices{1,3,2}(:))));
stimRT_sems(2,1,2) = std(stimRT_all(indices{2,1,2}(:)),'omitnan')/sqrt(length(stimRT_all(indices{2,1,2}(:))));
stimRT_sems(2,2,2) = std(stimRT_all(indices{2,2,2}(:)),'omitnan')/sqrt(length(stimRT_all(indices{2,2,2}(:))));
stimRT_sems(2,3,2) = std(stimRT_all(indices{2,3,2}(:)),'omitnan')/sqrt(length(stimRT_all(indices{2,3,2}(:))));


%side by side plot; rule RTs
numgroups = 2;
numbars = 2;
groupwidth = min(0.8, numbars/(numbars+1.5));

h = figure(1);
h1 = subplot(1,3,1);
subplot(1,3,1),bar([ruleRT_means(1,3,1) ruleRT_means(1,3,2); ruleRT_means(2,3,1) ruleRT_means(2,3,2)])
h1.Children(1).BarWidth = 1;
h1.YLim = [0 1.2];
h1.YTick = [0:0.1:1.2];
hold on
% plot(xlim, [ruleRT_control_mean ruleRT_control_mean],'r')
h1.YLabel.String = 'Response time (ms)';
h1.XTickLabel = {'S','F'};
h1.Title.String = 'Rule RTs, no stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [ruleRT_means(1,3,1) ruleRT_means(1,3,2); ruleRT_means(2,3,1) ruleRT_means(2,3,2)], [ruleRT_sems(1,3,1) ruleRT_sems(1,3,2); ruleRT_sems(2,3,1) ruleRT_sems(2,3,2)], 'k', 'linestyle', 'none');
clear x

h2 = subplot(1,3,2);
subplot(1,3,2),bar([ruleRT_means(1,1,1) ruleRT_means(1,1,2); ruleRT_means(2,1,1) ruleRT_means(2,1,2)])
h2.Children(1).BarWidth = 1;
h2.YLim = [0 1.2];
h2.YTick = [0:0.1:1.2];
hold on
% plot(xlim, [ruleRT_control_mean ruleRT_control_mean],'r')
h2.XTickLabel = {'S','F'};
h2.Title.String = 'Rule RTs, early stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [ruleRT_means(1,1,1) ruleRT_means(1,1,2); ruleRT_means(2,1,1) ruleRT_means(2,1,2)], [ruleRT_sems(1,1,1) ruleRT_sems(1,1,2); ruleRT_sems(2,1,1) ruleRT_sems(2,1,2)], 'k', 'linestyle', 'none');
clear x

h3 = subplot(1,3,3);
subplot(1,3,3),bar([ruleRT_means(1,2,1) ruleRT_means(1,2,2); ruleRT_means(2,2,1) ruleRT_means(2,2,2)])
h3.Children(1).BarWidth = 1;
h3.YLim = [0 1.2];
h3.YTick = [0:0.1:1.2];
hold on
% plot(xlim, [ruleRT_control_mean ruleRT_control_mean],'r')
h3.XTickLabel = {'S','F'};
h3.Title.String = 'Rule RTs, late stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [ruleRT_means(1,2,1) ruleRT_means(1,2,2); ruleRT_means(2,2,1) ruleRT_means(2,2,2)], [ruleRT_sems(1,2,1) ruleRT_sems(1,2,2); ruleRT_sems(2,2,1) ruleRT_sems(2,2,2)], 'k', 'linestyle', 'none');
clear x

%just drag this shit to a good place
lh = legend('PMd','Vertex');
lh.Position = [0.4939 0.0654 0.0474 0.0395];









%side by side plot; stim RTs
numgroups = 2;
numbars = 2;
groupwidth = min(0.8, numbars/(numbars+1.5));

h = figure(1);
h1 = subplot(1,3,1);
subplot(1,3,1),bar([stimRT_means(1,3,1) stimRT_means(1,3,2); stimRT_means(2,3,1) stimRT_means(2,3,2)])
h1.Children(1).BarWidth = 1;
h1.YLim = [0 1.2];
h1.YTick = [0:0.1:1.2];
hold on
% plot(xlim, [stimRT_control_mean stimRT_control_mean],'r')
h1.YLabel.String = 'Response time (ms)';
h1.XTickLabel = {'S','F'};
h1.Title.String = 'Stim RTs, no stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [stimRT_means(1,3,1) stimRT_means(1,3,2); stimRT_means(2,3,1) stimRT_means(2,3,2)], [stimRT_sems(1,3,1) stimRT_sems(1,3,2); stimRT_sems(2,3,1) stimRT_sems(2,3,2)], 'k', 'linestyle', 'none');
clear x

h2 = subplot(1,3,2);
subplot(1,3,2),bar([stimRT_means(1,1,1) stimRT_means(1,1,2); stimRT_means(2,1,1) stimRT_means(2,1,2)])
h2.Children(1).BarWidth = 1;
h2.YLim = [0 1.2];
h2.YTick = [0:0.1:1.2];
hold on
% plot(xlim, [stimRT_control_mean stimRT_control_mean],'r')
h2.XTickLabel = {'S','F'};
h2.Title.String = 'Stim RTs, early stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [stimRT_means(1,1,1) stimRT_means(1,1,2); stimRT_means(2,1,1) stimRT_means(2,1,2)], [stimRT_sems(1,1,1) stimRT_sems(1,1,2); stimRT_sems(2,1,1) stimRT_sems(2,1,2)], 'k', 'linestyle', 'none');
clear x

h3 = subplot(1,3,3);
subplot(1,3,3),bar([stimRT_means(1,2,1) stimRT_means(1,2,2); stimRT_means(2,2,1) stimRT_means(2,2,2)])
h3.Children(1).BarWidth = 1;
h3.YLim = [0 1.2];
h3.YTick = [0:0.1:1.2];
hold on
% plot(xlim, [stimRT_control_mean stimRT_control_mean],'r')
h3.XTickLabel = {'S','F'};
h3.Title.String = 'Stim RTs, late stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [stimRT_means(1,2,1) stimRT_means(1,2,2); stimRT_means(2,2,1) stimRT_means(2,2,2)], [stimRT_sems(1,2,1) stimRT_sems(1,2,2); stimRT_sems(2,2,1) stimRT_sems(2,2,2)], 'k', 'linestyle', 'none');
clear x

%just drag this shit to a good place
lh = legend('PMd','Vertex');
lh.Position = [0.4939 0.0654 0.0474 0.0395];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%compare no stim trials to vertex stim trials


index{1,1} = find(fuckit_all(:,1)==0 & fuckit_all(:,2)==2);
index{1,2} = find(fuckit_all(:,1)==0 & fuckit_all(:,2)~=2 & fuckit_all(:,3)==1);
index{2,1} = find(fuckit_all(:,1)==1 & fuckit_all(:,2)==2);
index{2,2} = find(fuckit_all(:,1)==1 & fuckit_all(:,2)~=2 & fuckit_all(:,3)==1);

cruleRT_means(1,1) = mean(ruleRT_all(index{1,1}(:)));
cruleRT_means(1,2) = mean(ruleRT_all(index{1,2}(:)));
cruleRT_means(2,1) = mean(ruleRT_all(index{2,1}(:)));
cruleRT_means(2,2) = mean(ruleRT_all(index{2,2}(:)));

cruleRT_sems(1,1) = std(ruleRT_all(index{1,1}(:)))/sqrt(length(ruleRT_all(index{1,1}(:))));
cruleRT_sems(1,2) = std(ruleRT_all(index{1,2}(:)))/sqrt(length(ruleRT_all(index{1,2}(:))));
cruleRT_sems(2,1) = std(ruleRT_all(index{2,1}(:)))/sqrt(length(ruleRT_all(index{2,1}(:))));
cruleRT_sems(2,2) = std(ruleRT_all(index{2,2}(:)))/sqrt(length(ruleRT_all(index{2,2}(:))));

cstimRT_means(1,1) = mean(stimRT_all(index{1,1}(:)));
cstimRT_means(1,2) = mean(stimRT_all(index{1,2}(:)));
cstimRT_means(2,1) = mean(stimRT_all(index{2,1}(:)));
cstimRT_means(2,2) = mean(stimRT_all(index{2,2}(:)));

cstimRT_sems(1,1) = std(stimRT_all(index{1,1}(:)))/sqrt(length(stimRT_all(index{1,1}(:))));
cstimRT_sems(1,2) = std(stimRT_all(index{1,2}(:)))/sqrt(length(stimRT_all(index{1,2}(:))));
cstimRT_sems(2,1) = std(stimRT_all(index{2,1}(:)))/sqrt(length(stimRT_all(index{2,1}(:))));
cstimRT_sems(2,2) = std(stimRT_all(index{2,2}(:)))/sqrt(length(stimRT_all(index{2,2}(:))));

cerrors_means(1,1) = mean(errors_all(index{1,1}(:)));
cerrors_means(1,2) = mean(errors_all(index{1,2}(:)));
cerrors_means(2,1) = mean(errors_all(index{2,1}(:)));
cerrors_means(2,2) = mean(errors_all(index{2,2}(:)));

cerrors_sems(1,1) = std(errors_all(index{1,1}(:)))/sqrt(length(errors_all(index{1,1}(:))));
cerrors_sems(1,2) = std(errors_all(index{1,2}(:)))/sqrt(length(errors_all(index{1,2}(:))));
cerrors_sems(2,1) = std(errors_all(index{2,1}(:)))/sqrt(length(errors_all(index{2,1}(:))));
cerrors_sems(2,2) = std(errors_all(index{2,2}(:)))/sqrt(length(errors_all(index{2,2}(:))));


ruleRT_control_mean = mean(mean(cruleRT_means));
stimRT_control_mean = mean(mean(cstimRT_means));


numgroups = 2;
numbars = 2;
groupwidth = min(0.8, numbars/(numbars+1.5));

h = figure(1);
h1 = subplot(1,3,2);
subplot(1,3,2),bar([cruleRT_means(1,1) cruleRT_means(1,2); cruleRT_means(2,1) cruleRT_means(2,2)])
h1.Children(1).BarWidth = 1;
h1.YLim = [0 1.2];
h1.YTick = [0:0.1:1.2];
h1.YLabel.String = 'Response time (ms)';
h1.XTickLabel = {'S','F'};
h1.Title.String = 'Rule RTs';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [cruleRT_means(1,1) cruleRT_means(1,2); cruleRT_means(2,1) cruleRT_means(2,2)], [cruleRT_sems(1,1) cruleRT_sems(1,2); cruleRT_sems(2,1) cruleRT_sems(2,2)], 'k', 'linestyle', 'none');
clear x

lh = legend('No stimulation','Vertex');
lh.Position = [0.4939 0.0654 0.0474 0.0395];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numgroups = 2;
numbars = 2;
groupwidth = min(0.8, numbars/(numbars+1.5));

h = figure(1);
h1 = subplot(1,3,2);
subplot(1,3,2),bar([cstimRT_means(1,1) cstimRT_means(1,2); cstimRT_means(2,1) cstimRT_means(2,2)])
h1.Children(1).BarWidth = 1;
h1.YLim = [0 1.2];
h1.YTick = [0:0.1:1.2];
h1.YLabel.String = 'Response time (ms)';
h1.XTickLabel = {'S','F'};
h1.Title.String = 'Stim RTs';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [cstimRT_means(1,1) cstimRT_means(1,2); cstimRT_means(2,1) cstimRT_means(2,2)], [cstimRT_sems(1,1) cstimRT_sems(1,2); cstimRT_sems(2,1) cstimRT_sems(2,2)], 'k', 'linestyle', 'none');
clear x

lh = legend('No stimulation','Vertex');
lh.Position = [0.4939 0.0654 0.0474 0.0395];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h = figure(1);
h1 = subplot(1,3,2);
subplot(1,3,2),bar([cerrors_means(1,1) cerrors_means(1,2); cerrors_means(2,1) cerrors_means(2,2)])
h1.Children(1).BarWidth = 1;
h1.YLim = [0 1.05];
h1.YTick = [0:0.1:1];
h1.YLabel.String = 'Success Rate';
h1.XTickLabel = {'S','F'};
h1.Title.String = 'Success Rate';

lh = legend('No stimulation','Vertex');
lh.Position = [0.4939 0.0654 0.0474 0.0395];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





