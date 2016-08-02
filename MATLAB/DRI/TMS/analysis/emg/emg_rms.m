
%get RMS of emg at different trial phases
%sum RMS values and divide by window length to get "mean motor activity"
%over trial phase

%some vectors are slightly different lengths - get values so as to trim to
%the most frequently occuring vector length later on
for b = 1:4
    
    for t = 1:length(emg_proc)
        
        delay_lengths(t,b) = length(ts_frames(t,6,b):ts_frames(t,8,b));
        rule_lengths(t,b) = length(ts_frames(t,4,b):ts_frames(t,6,b));
        
    end
end

%most frequently occuring vector length
delay_length = mode(mode(delay_lengths));
rule_length = mode(mode(rule_lengths));




%get emg traces for different trial phases
for b = 1:4
    
    for t = 1:length(emg_proc)
        
        rtrim = length(ts_frames(t,4,b):ts_frames(t,6,b)) - rule_length;
        dtrim = length(ts_frames(t,6,b):ts_frames(t,8,b)) - delay_length;
        
        rule_emg{t,b,1} = emg_proc{t,b}(1,ts_frames(t,4,b):ts_frames(t,6,b)-rtrim);
        rule_emg{t,b,2} = emg_proc{t,b}(2,ts_frames(t,4,b):ts_frames(t,6,b)-rtrim);
        
        delay_emg{t,b,1} = emg_proc{t,b}(1,ts_frames(t,6,b):ts_frames(t,8,b)-dtrim);
        delay_emg{t,b,2} = emg_proc{t,b}(2,ts_frames(t,6,b):ts_frames(t,8,b)-dtrim);
        
        resp_emg{t,b,1} = emg_proc{t,b}(1,ts_frames(t,9,b)-750:ts_frames(t,9,b)+750);
        resp_emg{t,b,2} = emg_proc{t,b}(2,ts_frames(t,9,b)-750:ts_frames(t,9,b)+750);
        
    end
end


es_index = cat(1,s_trials_es,f_trials_es);
ls_index = cat(1,s_trials_ls,f_trials_ls);

for b = 1:4
    
    for t = 1:length(cat(1,es_index{:,b}))
        
        es_indices = cat(1,es_index{:,b});
        ls_indices = cat(1,ls_index{:,b});
        
        es_emg{t,b,1} = emg_proc{es_indices(t),b}(1,ts_frames(es_indices(t),3,b)-1500:ts_frames(es_indices(t),3,b)+1500);
        es_emg{t,b,2} = emg_proc{es_indices(t),b}(2,ts_frames(es_indices(t),3,b)-1500:ts_frames(es_indices(t),3,b)+1500);
        
        ls_emg{t,b,1} = emg_proc{ls_indices(t),b}(1,ts_frames(ls_indices(t),7,b)-1500:ts_frames(ls_indices(t),7,b)+1500);
        ls_emg{t,b,2} = emg_proc{ls_indices(t),b}(2,ts_frames(ls_indices(t),7,b)-1500:ts_frames(ls_indices(t),7,b)+1500);
        
    end
end

        
        




%get window length and overlap in frames for winrms

windowlength = 50;  %in samples
overlap = 40;  %in samples

rule_rms = cellfun(@(x) winrms(x,windowlength,overlap,0), rule_emg, 'UniformOutput', false);
delay_rms = cellfun(@(x) winrms(x,windowlength,overlap,0), delay_emg, 'UniformOutput', false);
resp_rms = cellfun(@(x) winrms(x,windowlength,overlap,0), resp_emg, 'UniformOutput', false);


for b = 1:4
    
    for t = 1:length(emg_proc)
        
        emg_rms{t,b}(1,:) = winrms(emg_proc{t,b}(1,:),windowlength,overlap,0);
        emg_rms{t,b}(2,:) = winrms(emg_proc{t,b}(2,:),windowlength,overlap,0);
        
    end
end

resp_rms_proc = cell2mat(cellfun(@(x) sum(x)/length(x), resp_rms, 'UniformOutput', false));

cond_index = cat(1,s_trials_ns,s_trials_es,s_trials_ls,f_trials_ns,f_trials_es,f_trials_ls);

for b = 1:4

    resp_index{1,b} = find(cell2mat(data{b,8}(s_trials_ns{b}))=='L');
    resp_middle{1,b} = find(cell2mat(data{b,8}(s_trials_ns{b}))=='R');
    
    resp_index{2,b} = find(cell2mat(data{b,8}(s_trials_es{b}))=='L');
    resp_middle{2,b} = find(cell2mat(data{b,8}(s_trials_es{b}))=='R');
    
    resp_index{3,b} = find(cell2mat(data{b,8}(s_trials_ls{b}))=='L');
    resp_middle{3,b} = find(cell2mat(data{b,8}(s_trials_ls{b}))=='R');
    
    resp_index{4,b} = find(cell2mat(data{b,8}(f_trials_ns{b}))=='L');
    resp_middle{4,b} = find(cell2mat(data{b,8}(f_trials_ns{b}))=='R');
    
    resp_index{5,b} = find(cell2mat(data{b,8}(f_trials_es{b}))=='L');
    resp_middle{5,b} = find(cell2mat(data{b,8}(f_trials_es{b}))=='R');
    
    resp_index{6,b} = find(cell2mat(data{b,8}(f_trials_ls{b}))=='L');
    resp_middle{6,b} = find(cell2mat(data{b,8}(f_trials_ls{b}))=='R');

end

%make actual trial index for each condition and index/middle fingers

for b = 1:4
    
    for c = 1:length(cond_index)
        
        condi_index{c,b} = cond_index{c,b}(resp_index{c,b});
        condi_middle{c,b} = cond_index{c,b}(resp_middle{c,b});
        
    end
end
        

for b = 1:2
    
    for c = 1:length(cond_index)
        
        means(c,b,1) = mean([resp_rms_proc(condi_index{c,b},b,1);resp_rms_proc(condi_index{c,b+2},b+2,1)]);
        means(c,b,2) = mean([resp_rms_proc(condi_middle{c,b},b,2);resp_rms_proc(condi_middle{c,b+2},b+2,2)]);
        sems(c,b,1) = sem([resp_rms_proc(condi_index{c,b},b,1);resp_rms_proc(condi_index{c,b+2},b+2,1)]);
        sems(c,b,2) = sem([resp_rms_proc(condi_middle{c,b},b,2);resp_rms_proc(condi_middle{c,b+2},b+2,2)]);
        
    end
end

%for 2406 to throw first block out
% for b = 1:2
%     
%     for c = 1:length(cond_index)
%         
%         means(c,b,1) = mean(resp_rms_proc(condi_index{c,b+2},b+2,1));
%         means(c,b,2) = mean([resp_rms_proc(condi_middle{c,b},b,2);resp_rms_proc(condi_middle{c,b+2},b+2,2)]);
%         sems(c,b,1) = sem(resp_rms_proc(condi_index{c,b+2},b+2,1));
%         sems(c,b,2) = sem([resp_rms_proc(condi_middle{c,b},b,2);resp_rms_proc(condi_middle{c,b+2},b+2,2)]);
%         
%     end
% end


%side by side plot; stim mean emg rms index finger
numgroups = 2;
numbars = 2;
groupwidth = min(0.8, numbars/(numbars+1.5));

h = figure(1);
h1 = subplot(1,3,1);
subplot(1,3,1),bar(horzcat(vertcat(means(1,1,1),means(4,1,1)),vertcat(means(1,2,1),means(4,2,1))))
h1.Children(1).BarWidth = 1;
h1.YLim = [0 3];
h1.XTickLabel = {'S','F'};
h1.Title.String = 'resp phase, mean emg rms, no stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, horzcat(vertcat(means(1,1,1),means(4,1,1)),vertcat(means(1,2,1),means(4,2,1))), horzcat(vertcat(sems(1,1,1),sems(4,1,1)),vertcat(sems(1,2,1),sems(4,2,1))), 'k', 'linestyle', 'none');
clear x

h2 = subplot(1,3,2);
subplot(1,3,2),bar(horzcat(vertcat(means(2,1,1),means(5,1,1)),vertcat(means(2,2,1),means(5,2,1))))
h2.Children(1).BarWidth = 1;
h2.YLim = [0 3];
h2.XTickLabel = {'S','F'};
h2.Title.String = 'resp phase, mean emg rms, early stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, horzcat(vertcat(means(2,1,1),means(5,1,1)),vertcat(means(2,2,1),means(5,2,1))), horzcat(vertcat(sems(2,1,1),sems(5,1,1)),vertcat(sems(2,2,1),sems(5,2,1))), 'k', 'linestyle', 'none');
clear x

h3 = subplot(1,3,3);
subplot(1,3,3),bar(horzcat(vertcat(means(3,1,1),means(6,1,1)),vertcat(means(3,2,1),means(6,2,1))))
h3.Children(1).BarWidth = 1;
h3.YLim = [0 3];
h3.XTickLabel = {'S','F'};
h3.Title.String = 'resp phase, mean emg rms, late stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, horzcat(vertcat(means(3,1,1),means(6,1,1)),vertcat(means(3,2,1),means(6,2,1))), horzcat(vertcat(sems(3,1,1),sems(6,1,1)),vertcat(sems(3,2,1),sems(6,2,1))), 'k', 'linestyle', 'none');
clear x

h0 = axes;
h0.Title.String = 'Index finger responses only';
h0.Visible = 'off';
h0.Title.Visible = 'on';
h0.Title.Position = [0.5000 1.04 0.5000];

%just drag this shit to a good place
lh = legend('PMd','Vertex');
set(lh,'Location','BestOutside','Orientation','vertical')



%side by side plot; stim mean emg rms middle finger
numgroups = 2;
numbars = 2;
groupwidth = min(0.8, numbars/(numbars+1.5));

h = figure(1);
h1 = subplot(1,3,1);
subplot(1,3,1),bar(horzcat(vertcat(means(1,1,2),means(4,1,2)),vertcat(means(1,2,2),means(4,2,2))))
h1.Children(1).BarWidth = 1;
h1.YLim = [0 3];
h1.XTickLabel = {'S','F'};
h1.Title.String = 'resp phase, mean emg rms, no stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, horzcat(vertcat(means(1,1,2),means(4,1,2)),vertcat(means(1,2,2),means(4,2,2))), horzcat(vertcat(sems(1,1,2),sems(4,1,2)),vertcat(sems(1,2,2),sems(4,2,2))), 'k', 'linestyle', 'none');
clear x

h2 = subplot(1,3,2);
subplot(1,3,2),bar(horzcat(vertcat(means(2,1,2),means(5,1,2)),vertcat(means(2,2,2),means(5,2,2))))
h2.Children(1).BarWidth = 1;
h2.YLim = [0 3];
h2.XTickLabel = {'S','F'};
h2.Title.String = 'resp phase, mean emg rms, early stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, horzcat(vertcat(means(2,1,2),means(5,1,2)),vertcat(means(2,2,2),means(5,2,2))), horzcat(vertcat(sems(2,1,2),sems(5,1,2)),vertcat(sems(2,2,2),sems(5,2,2))), 'k', 'linestyle', 'none');
clear x

h3 = subplot(1,3,3);
subplot(1,3,3),bar(horzcat(vertcat(means(3,1,2),means(6,1,2)),vertcat(means(3,2,2),means(6,2,2))))
h3.Children(1).BarWidth = 1;
h3.YLim = [0 3];
h3.XTickLabel = {'S','F'};
h3.Title.String = 'resp phase, mean emg rms, late stim';

hold on;
for i = 1:numbars
      x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, horzcat(vertcat(means(3,1,2),means(6,1,2)),vertcat(means(3,2,2),means(6,2,2))), horzcat(vertcat(sems(3,1,2),sems(6,1,2)),vertcat(sems(3,2,2),sems(6,2,2))), 'k', 'linestyle', 'none');
clear x

h0 = axes;
h0.Title.String = 'Middle finger responses only';
h0.Visible = 'off';
h0.Title.Visible = 'on';
h0.Title.Position = [0.5000 1.04 0.5000];

%just drag this shit to a good place
lh = legend('PMd','Vertex');
set(lh,'Location','BestOutside','Orientation','vertical')











for t = 1:60
    
    %plot index
    subplot(2,1,1),plot(resp_emg{t,1,1})
    hold on
    subplot(2,1,1),plot(resp_rms{t,1,1})
    subplot(2,1,1),plot([0 1600],[0 0],'k')
    subplot(2,1,1),ylim([-20 20])
     
    title(sprintf('trial %d',t))
    
    %plot middle
    subplot(2,1,2),plot(resp_emg{t,1,2})
    hold on
    subplot(2,1,2),plot(resp_rms{t,1,2})
    subplot(2,1,2),plot([0 1600],[0 0],'k')
    subplot(2,1,2),ylim([-20 20])
    
    waitforbuttonpress
    
    close all
    
end


b=2;

for t = 1:60
    
    subplot(2,1,1),plot(emg_proc{t,b}(1,:))
    hold on
    subplot(2,1,1),plot(emg_rms{t,b}(1,:))
    subplot(2,1,1),plot([0 length(emg_proc{t,b}(1,:))],[0 0],'k')
    subplot(2,1,1),plot([ts_frames(t,3,b) ts_frames(t,3,b)],[-20 20],'k')
    subplot(2,1,1),plot([ts_frames(t,7,b) ts_frames(t,7,b)],[-20 20],'k')
    subplot(2,1,1),ylim([-20 20])
    
    title(sprintf('trial %d',t))
    
    subplot(2,1,2),plot(emg_proc{t,b}(2,:))
    hold on
    subplot(2,1,2),plot(emg_rms{t,b}(2,:))
    subplot(2,1,2),plot([0 length(emg_proc{t,b}(1,:))],[0 0],'k')
    subplot(2,1,2),plot([ts_frames(t,3,b) ts_frames(t,3,b)],[-20 20],'k')
    subplot(2,1,2),plot([ts_frames(t,7,b) ts_frames(t,7,b)],[-20 20],'k')
    subplot(2,1,2),ylim([-20 20])
    
    
    waitforbuttonpress
    
    close all
    
end























