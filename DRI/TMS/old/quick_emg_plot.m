t = 4

subplot(2,1,1),plot(adblData_mat{t}(1:2:end))
subplot(2,1,2),plot(adblData_mat{t}(2:2:end))

y1 = subplot(2,1,1),ylim;
y2 = subplot(2,1,2),ylim;

if y1>y2
    subplot(2,1,2),ylim(y1.YLim)
else
    subplot(2,1,1),ylim(y2.YLim)
end
    
    