
zindex = find(adblData_mat==0);

adblData_mat(zindex) = [];

channels(1,:) = adblData_mat(1:2:end);
channels(2,:) = adblData_mat(2:2:end);

chan_adj(1,:) = channels(1,:) - mean(channels(1,:));
chan_adj(2,:) = channels(2,:) - mean(channels(2,:));

chan_rms(1,:) = winrms(chan_adj(1,:), 75, 0 , 1);
chan_rms(2,:) = winrms(chan_adj(2,:), 75, 0 , 1);







figure
subplot(2,1,1),plot(chan_adj(1,:))
hold on
subplot(2,1,2),plot(chan_adj(2,:))
hold on

if range(ylim(subplot(2,1,1))) > range(ylim(subplot(2,1,2)))
    
    ylims = ylim(subplot(2,1,1));
    subplot(2,1,2),ylim(ylims)
    
else
    
    ylims = ylim(subplot(2,1,2));
    subplot(2,1,1),ylim(ylims)
    
end

subplot(2,1,1),plot(chan_rms(1,:),'r')
subplot(2,1,2),plot(chan_rms(2,:),'r')

