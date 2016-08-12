%numgroups== number of groups of bars
%numbars = number of bars in a group
numgroups = 2;
numbars = 2;
groupwidth = min(0.8, numbars/(numbars+1.5));

%my plotting stuff for context
% h = figure(1);
% h1 = subplot(1,3,1);
% subplot(1,3,1),bar([sRT_means(1,1,3,1) sRT_means(1,1,3,2); sRT_means(1,2,3,1) sRT_means(1,2,3,2)])
% h1.Children(1).BarWidth = 1;
% h1.YLim = [0 1.5];
% h1.YTick = [0:0.1:1.5];
% hold on
% % plot(xlim, [ruleRT_control_mean ruleRT_control_mean],'r')
% h1.YLabel.String = 'Response time (ms)';
% h1.XTickLabel = {'S','F'};
% h1.Title.String = 'no stim';

%finds locations to center bars
hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end


%bars_data==mean values you're plotting
%error_data==the std, sem, whatever error
errorbar(x, [bars_data], [error_data], 'k', 'linestyle', 'none');
clear x