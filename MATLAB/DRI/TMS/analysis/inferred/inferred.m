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

ruleRT_all = ts_all(:,5) - ts_all(:,4);
stimRT_all = ts_all(:,9) - ts_all(:,8);

%cell2mat(data{1,2,1}) to get even/odd presentation
%convert into 0/1 in order to compare
%cat them bitches together

track=0;
for s = 1:size(data_cat,3)
    
    for b = 1:size(data_cat,1)
        
        evenodd(1+track:60+track,:) = cell2mat(data_cat{b,2,s});
        
        track = track+60;
        
    end
end

evenodd(:,2) = [];

evenodd = evenodd-1; %0==Even; 1==Odd

track=0;
for s = 1:size(data_cat,3)
    
    for b = 1:size(data_cat,1)
        
        ab_all(1+track:60+track,:) = cell2mat(data_cat{b,5,s});
        
        track = track+60;
        
    end
end

ab_all(:,2) = [];

ab_all = ab_all-1; %0=="A" was on left; 1=="B" was on left
        
        

%data{1,6,1} for actual stimulus number
%do the mod trick to determine even/odd
%cat them bitches together

track=0;
for s = 1:size(data_cat,3)
    
    for b = 1:size(data_cat,1)
        
        evenodd_stim(1+track:60+track,:) = data_cat{b,6,s};
        
        track = track+60;
        
    end
end

evenodd_stim = mod(evenodd_stim,2); %0==Even; 1==Odd

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

%isequal or equivalent to determine instructed/inferred index
%index PMd/Vertex, early/late, symbol/finger

%indices_all(:,1)==inferred(0), instructed(1)
%indices_all(:,2)==symbol(0), finger(1)
%indices_all(:,3)==early stim(0), late stim (1), no stim (2)
%indices_all(:,4)==PMd(0), Vertex(1)
indices_all(:,1) = evenodd == evenodd_stim;%0==inferred; 1==instructed
indices_all = double(indices_all);
indices_all(:,2:4) = fuckit_all;
indices_all(:,4) = blockid_cat;
% indices_all(:,5) = errors_all;
% indices_all(:,6) = ab_all;


%a==inferred(0), instructed(1)
%b==symbol(0), finger(1)
%c==es(0) ls(1) ns(2)
%d==PMd(0), Vertex(1)
for a = 0:1
    
    for b = 0:1
        
        for c = 0:2
            
            for d = 0:1
                
                t_index{a+1,b+1,c+1,d+1} = find(ismember(indices_all,[a b c d],'rows'));
                
            end
        end
    end
end

for a = 1:2
    
    for b = 1:2
        
        for c = 1:3
            
            for d = 1:2
                
                rRT_means(a,b,c,d) = mean(ruleRT_all(t_index{a,b,c,d}),'omitnan');
                sRT_means(a,b,c,d) = mean(stimRT_all(t_index{a,b,c,d}),'omitnan');
                
                rRT_sems(a,b,c,d) = sem(ruleRT_all(t_index{a,b,c,d}));
                sRT_sems(a,b,c,d) = sem(stimRT_all(t_index{a,b,c,d}));
                
            end
        end
    end
end

%a==inferred(0), instructed(1)
%b==symbol(0), finger(1)
%c==es(0) ls(1) ns(2)
%d==PMd(0), Vertex(1)

%side by side plot; stim RTs, inferred
numgroups = 2;
numbars = 2;
groupwidth = min(0.8, numbars/(numbars+1.5));

h = figure(1);
h1 = subplot(1,3,1);
subplot(1,3,1),bar([sRT_means(1,1,3,1) sRT_means(1,1,3,2); sRT_means(1,2,3,1) sRT_means(1,2,3,2)])
h1.Children(1).BarWidth = 1;
h1.YLim = [0 1.5];
h1.YTick = [0:0.1:1.5];
hold on
% plot(xlim, [ruleRT_control_mean ruleRT_control_mean],'r')
h1.YLabel.String = 'Response time (ms)';
h1.XTickLabel = {'S','F'};
h1.Title.String = 'no stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [sRT_means(1,1,3,1) sRT_means(1,1,3,2); sRT_means(1,2,3,1) sRT_means(1,2,3,2)], [sRT_sems(1,1,3,1) sRT_sems(1,1,3,2); sRT_sems(1,2,3,1) sRT_sems(1,2,3,2)], 'k', 'linestyle', 'none');
clear x

h2 = subplot(1,3,2);
subplot(1,3,2),bar([sRT_means(1,1,1,1) sRT_means(1,1,1,2); sRT_means(1,2,1,1) sRT_means(1,2,1,2)])
h2.Children(1).BarWidth = 1;
h2.YLim = [0 1.5];
h2.YTick = [0:0.1:1.5];
hold on
% plot(xlim, [ruleRT_control_mean ruleRT_control_mean],'r')
h2.XTickLabel = {'S','F'};
h2.Title.String = 'early stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [sRT_means(1,1,1,1) sRT_means(1,1,1,2); sRT_means(1,2,1,1) sRT_means(1,2,1,2)], [sRT_sems(1,1,1,1) sRT_sems(1,1,1,2); sRT_sems(1,2,1,1) sRT_sems(1,2,1,2)], 'k', 'linestyle', 'none');
clear x

h3 = subplot(1,3,3);
subplot(1,3,3),bar([sRT_means(1,1,2,1) sRT_means(1,1,2,2); sRT_means(1,2,2,1) sRT_means(1,2,2,2)])
h3.Children(1).BarWidth = 1;
h3.YLim = [0 1.5];
h3.YTick = [0:0.1:1.5];
hold on
% plot(xlim, [ruleRT_control_mean ruleRT_control_mean],'r')
h3.XTickLabel = {'S','F'};
h3.Title.String = 'late stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [sRT_means(1,1,2,1) sRT_means(1,1,2,2); sRT_means(1,2,2,1) sRT_means(1,2,2,2)], [sRT_sems(1,1,2,1) sRT_sems(1,1,2,2); sRT_sems(1,2,2,1) sRT_sems(1,2,2,2)], 'k', 'linestyle', 'none');
clear x

%just drag this shit to a good place
lh = legend('PMd','Vertex');
lh.Position = [0.4939 0.0654 0.0474 0.0395];

%set global title
set(gcf,'NextPlot','add');
axes;
htitle = title(sprintf('Stim RTs, inferred. n = %d',s));
set(gca,'Visible','off');
set(htitle,'Visible','on');
htitle.Position = [0.5 1.04 0.5];



%side by side plot; stim RTs, instructed
numgroups = 2;
numbars = 2;
groupwidth = min(0.8, numbars/(numbars+1.5));

h = figure(1);
h1 = subplot(1,3,1);
subplot(1,3,1),bar([sRT_means(2,1,3,1) sRT_means(2,1,3,2); sRT_means(2,2,3,1) sRT_means(2,2,3,2)])
h1.Children(1).BarWidth = 1;
h1.YLim = [0 1.5];
h1.YTick = [0:0.1:1.5];
hold on
% plot(xlim, [ruleRT_control_mean ruleRT_control_mean],'r')
h1.YLabel.String = 'Response time (ms)';
h1.XTickLabel = {'S','F'};
h1.Title.String = 'no stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [sRT_means(2,1,3,1) sRT_means(2,1,3,2); sRT_means(2,2,3,1) sRT_means(2,2,3,2)], [sRT_sems(2,1,3,1) sRT_sems(2,1,3,2); sRT_sems(2,2,3,1) sRT_sems(2,2,3,2)], 'k', 'linestyle', 'none');
clear x

h2 = subplot(1,3,2);
subplot(1,3,2),bar([sRT_means(2,1,1,1) sRT_means(2,1,1,2); sRT_means(2,2,1,1) sRT_means(2,2,1,2)])
h2.Children(1).BarWidth = 1;
h2.YLim = [0 1.5];
h2.YTick = [0:0.1:1.5];
hold on
% plot(xlim, [ruleRT_control_mean ruleRT_control_mean],'r')
h2.XTickLabel = {'S','F'};
h2.Title.String = 'early stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [sRT_means(2,1,1,1) sRT_means(2,1,1,2); sRT_means(2,2,1,1) sRT_means(2,2,1,2)], [sRT_sems(2,1,1,1) sRT_sems(2,1,1,2); sRT_sems(2,2,1,1) sRT_sems(2,2,1,2)], 'k', 'linestyle', 'none');
clear x

h3 = subplot(1,3,3);
subplot(1,3,3),bar([sRT_means(2,1,2,1) sRT_means(2,1,2,2); sRT_means(2,2,2,1) sRT_means(2,2,2,2)])
h3.Children(1).BarWidth = 1;
h3.YLim = [0 1.5];
h3.YTick = [0:0.1:1.5];
hold on
% plot(xlim, [ruleRT_control_mean ruleRT_control_mean],'r')
h3.XTickLabel = {'S','F'};
h3.Title.String = 'late stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [sRT_means(2,1,2,1) sRT_means(2,1,2,2); sRT_means(2,2,2,1) sRT_means(2,2,2,2)], [sRT_sems(2,1,2,1) sRT_sems(2,1,2,2); sRT_sems(2,2,2,1) sRT_sems(2,2,2,2)], 'k', 'linestyle', 'none');
clear x

%just drag this shit to a good place
lh = legend('PMd','Vertex');
lh.Position = [0.4939 0.0654 0.0474 0.0395];

%set global title
set(gcf,'NextPlot','add');
axes;
htitle = title(sprintf('Stim RTs, instructed. n = %d',s));
set(gca,'Visible','off');
set(htitle,'Visible','on');
htitle.Position = [0.5 1.04 0.5];