

zinds = cellfun(@(x) find(x==0), adblData_mat, 'UniformOutput', 0);

raw_chan = adblData_mat(:,1);

for z = 1:length(raw_chan)
    
    raw_chan{z}(zinds{z}) = [];
    
end

for z = 1:length(raw_chan)
    
    split_chan{z}(1,:) = raw_chan{z}(1:2:end);
    split_chan{z}(2,:) = raw_chan{z}(2:2:end);

end

chan_means = cellfun(@(x) nanmean(x,2), split_chan, 'UniformOutput',0);

chan_adj = gsubtract(split_chan,chan_means);

for z = 1:length(chan_adj)
    
    chan_rms{z}(1,:) = winrms(chan_adj{z}(1,:),75,0,1);
    chan_rms{z}(2,:) = winrms(chan_adj{z}(2,:),75,0,1);
    
end

trial = 1;

figure
subplot(2,1,1),plot(chan_adj{trial}(1,:))
hold on
subplot(2,1,2),plot(chan_adj{trial}(2,:))
hold on

if range(ylim(subplot(2,1,1))) > range(ylim(subplot(2,1,2)))
    
    ylims = ylim(subplot(2,1,1));
    subplot(2,1,2),ylim(ylims)
    
else
    
    ylims = ylim(subplot(2,1,2));
    subplot(2,1,1),ylim(ylims)
    
end

subplot(2,1,1),plot(chan_rms{trial}(1,:),'r')
subplot(2,1,2),plot(chan_rms{trial}(2,:),'r')
