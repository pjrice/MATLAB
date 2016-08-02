fuckit_all(1:end,4) = nan;
fuckit_all(1:240,4) = 1;
fuckit_all(241:480,4) = 2;
fuckit_all(481:720,4) = 3;

for s = 1:3
    
    index{1,1,s} = find(fuckit_all(:,1)==0 & fuckit_all(:,2)==2 & fuckit_all(:,4)==s);
    index{1,2,s} = find(fuckit_all(:,1)==0 & fuckit_all(:,2)~=2 & fuckit_all(:,3)==1 & fuckit_all(:,4)==s);
    index{2,1,s} = find(fuckit_all(:,1)==1 & fuckit_all(:,2)==2 & fuckit_all(:,4)==s);
    index{2,2,s} = find(fuckit_all(:,1)==1 & fuckit_all(:,2)~=2 & fuckit_all(:,3)==1 & fuckit_all(:,4)==s);
    
end

for s = 1:3
    
    subj_sr(1,1,s) = sum(errors_all(index{1,1,s}))/length(errors_all(index{1,1,s}));
    subj_sr(1,2,s) = sum(errors_all(index{1,2,s}))/length(errors_all(index{1,2,s}));
    subj_sr(2,1,s) = sum(errors_all(index{2,1,s}))/length(errors_all(index{2,1,s}));
    subj_sr(2,2,s) = sum(errors_all(index{2,2,s}))/length(errors_all(index{2,2,s}));
    
end

ssr_means = nanmean(subj_sr,3);
ssr_sems = nanstd(subj_sr,0,3)/sqrt(size(subj_sr,3));

numgroups = 2;
numbars = 2;
groupwidth = min(0.8, numbars/(numbars+1.5));

h = figure(1);
h1 = subplot(1,3,2);
subplot(1,3,2),bar([ssr_means(1,1) ssr_means(1,2); ssr_means(2,1) ssr_means(2,2)])
h1.Children(1).BarWidth = 1;
h1.YLim = [0 1.05];
h1.YTick = [0:0.1:1];
h1.YLabel.String = 'Success Rate';
h1.XTickLabel = {'S','F'};
h1.Title.String = 'Success Rate';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, [ssr_means(1,1) ssr_means(1,2); ssr_means(2,1) ssr_means(2,2)], [ssr_sems(1,1) ssr_sems(1,2); ssr_sems(2,1) ssr_sems(2,2)], 'k', 'linestyle', 'none');
clear x

lh = legend('No stimulation','Vertex');
lh.Position = [0.4939 0.0654 0.0474 0.0395];
    
