function x = geb_loc(numbars,numgroups)

%finds locations to plot error bars for grouped bar plots 
%numbars is the number of bars in a group
%numgroups is the number of groups of bars
%errorbar(x, [bars_data], [error_data], 'k', 'linestyle', 'none'); is
%function to overlay bars ontop of existing barplot
%bars_data is the sample means used for the barplot
%error_data is the sample errors of the means used

groupwidth = min(0.8, numbars/(numbars+1.5));

x = zeros(numgroups,numbars);

% Aligning error bar with individual bar
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end