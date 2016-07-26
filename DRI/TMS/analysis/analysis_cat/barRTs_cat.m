%ruleRTc/stimRTc contains concatenated rule/stimulus RTs for each
%subcondition for every subject
%in ruleRTc/stimRTc, columns are experimental (first column) and
%control conditions (second column). Rows are task subconditions:
%1. symbolic trials, no stimulation
%2. symbolic trials, early stimulation
%3. symbolic trials, late stimulation
%4. finger trials, no stim
%5. finger trials, early stim
%6. finger trials, late stim
%same shit for errxc with errors made

m_rRTc = cell2mat(cellfun(@(x) mean(x), ruleRTc, 'UniformOutput', false));
s_rRTc = cell2mat(cellfun(@(x) sem(x), ruleRTc, 'UniformOutput', false));

m_sRTc = cell2mat(cellfun(@(x) mean(x), stimRTc, 'UniformOutput', false));
s_sRTc = cell2mat(cellfun(@(x) sem(x), stimRTc, 'UniformOutput', false));

errRatexc = cell2mat(cellfun(@(x) sum(x)/length(x), errxc, 'UniformOutput', false));

clear c sc

%side by side plot; rule RTs
numgroups = 2;
numbars = 2;
groupwidth = min(0.8, numbars/(numbars+1.5));

%1
h = figure(1);
h1 = subplot(1,3,1);
subplot(1,3,1),bar(horzcat([m_rRTc(1,1);m_rRTc(4,1)],[m_rRTc(1,2);m_rRTc(4,2)]))
h1.Children(1).BarWidth = 1;
h1.YLim = [0 1.6];
h1.XTickLabel = {'S','F'};
h1.Title.String = 'Rule RTs, no stim';

hold on;
for i = 1:numbars
    x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, horzcat([m_rRTc(1,1);m_rRTc(4,1)],[m_rRTc(1,2);m_rRTc(4,2)]), horzcat([s_rRTc(1,1);s_rRTc(4,1)],[s_rRTc(1,2);s_rRTc(4,2)]), 'k', 'linestyle', 'none');

%2
h2 = subplot(1,3,2);
subplot(1,3,2),bar(horzcat([m_rRTc(2,1);m_rRTc(5,1)],[m_rRTc(2,2);m_rRTc(5,2)]))
h2.Children(1).BarWidth = 1;
h2.YLim = [0 1.6];
h2.XTickLabel = {'S','F'};
h2.Title.String = 'Rule RTs, early stim';

hold on;

errorbar(x, horzcat([m_rRTc(2,1);m_rRTc(5,1)],[m_rRTc(2,2);m_rRTc(5,2)]), horzcat([s_rRTc(2,1);s_rRTc(5,1)],[s_rRTc(2,2);s_rRTc(5,2)]), 'k', 'linestyle', 'none');

%3
h3 = subplot(1,3,3);
subplot(1,3,3),bar(horzcat([m_rRTc(3,1);m_rRTc(6,1)],[m_rRTc(3,2);m_rRTc(6,2)]))
h3.Children(1).BarWidth = 1;
h3.YLim = [0 1.6];
h3.XTickLabel = {'S','F'};
h3.Title.String = 'Rule RTs, late stim';

hold on;

errorbar(x, horzcat([m_rRTc(3,1);m_rRTc(6,1)],[m_rRTc(3,2);m_rRTc(6,2)]), horzcat([s_rRTc(3,1);s_rRTc(6,1)],[s_rRTc(3,2);s_rRTc(6,2)]), 'k', 'linestyle', 'none');

%just drag this shit to a good place
lh = legend('PMd','Vertex');
set(lh,'Location','BestOutside','Orientation','vertical')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%side by side plot; stim RTs
numgroups = 2;
numbars = 2;
groupwidth = min(0.8, numbars/(numbars+1.5));

%1
h = figure(2);
h1 = subplot(1,3,1);
subplot(1,3,1),bar(horzcat([m_sRTc(1,1);m_sRTc(4,1)],[m_sRTc(1,2);m_sRTc(4,2)]))
h1.Children(1).BarWidth = 1;
h1.YLim = [0 1.6];
h1.XTickLabel = {'S','F'};
h1.Title.String = 'Stim RTs, no stim';

hold on;
for i = 1:numbars
    x(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
end

errorbar(x, horzcat([m_sRTc(1,1);m_sRTc(4,1)],[m_sRTc(1,2);m_sRTc(4,2)]), horzcat([s_sRTc(1,1);s_sRTc(4,1)],[s_sRTc(1,2);s_sRTc(4,2)]), 'k', 'linestyle', 'none');

%2
h2 = subplot(1,3,2);
subplot(1,3,2),bar(horzcat([m_sRTc(2,1);m_sRTc(5,1)],[m_sRTc(2,2);m_sRTc(5,2)]))
h2.Children(1).BarWidth = 1;
h2.YLim = [0 1.6];
h2.XTickLabel = {'S','F'};
h2.Title.String = 'Stim RTs, early stim';

hold on;

errorbar(x, horzcat([m_sRTc(2,1);m_sRTc(5,1)],[m_sRTc(2,2);m_sRTc(5,2)]), horzcat([s_sRTc(2,1);s_sRTc(5,1)],[s_sRTc(2,2);s_sRTc(5,2)]), 'k', 'linestyle', 'none');

%3
h3 = subplot(1,3,3);
subplot(1,3,3),bar(horzcat([m_sRTc(3,1);m_sRTc(6,1)],[m_sRTc(3,2);m_sRTc(6,2)]))
h3.Children(1).BarWidth = 1;
h3.YLim = [0 1.6];
h3.XTickLabel = {'S','F'};
h3.Title.String = 'Stim RTs, late stim';

hold on;

errorbar(x, horzcat([m_sRTc(3,1);m_sRTc(6,1)],[m_sRTc(3,2);m_sRTc(6,2)]), horzcat([s_sRTc(3,1);s_sRTc(6,1)],[s_sRTc(3,2);s_sRTc(6,2)]), 'k', 'linestyle', 'none');

%just drag this shit to a good place
lh = legend('PMd','Vertex');
set(lh,'Location','BestOutside','Orientation','vertical')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%side by side plot; success rates
numgroups = 2;
numbars = 2;
groupwidth = min(0.8, numbars/(numbars+1.5));

%1
h = figure(3);
h1 = subplot(1,3,1);
subplot(1,3,1),bar(horzcat([errRatexc(1,1);errRatexc(4,1)],[errRatexc(1,2);errRatexc(4,2)]))
h1.Children(1).BarWidth = 1;
h1.YLim = [0 1.1];
h1.XTickLabel = {'S','F'};
h1.Title.String = 'Success rates, no stim';


%2
h2 = subplot(1,3,2);
subplot(1,3,2),bar(horzcat([errRatexc(2,1);errRatexc(5,1)],[errRatexc(2,2);errRatexc(5,2)]))
h2.Children(1).BarWidth = 1;
h2.YLim = [0 1.1];
h2.XTickLabel = {'S','F'};
h2.Title.String = 'Success rates, early stim';

hold on;

%3
h3 = subplot(1,3,3);
subplot(1,3,3),bar(horzcat([errRatexc(3,1);errRatexc(6,1)],[errRatexc(3,2);errRatexc(6,2)]))
h3.Children(1).BarWidth = 1;
h3.YLim = [0 1.1];
h3.XTickLabel = {'S','F'};
h3.Title.String = 'Success rates, late stim';

hold on;

%just drag this shit to a good place
lh = legend('PMd','Vertex');
set(lh,'Location','BestOutside','Orientation','vertical')
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

%plotting timestamps on emg traces

%the timestamps in seconds should be multiplied by the sampling rate
%in this case it was 3kHz and I forgot to import the variable that stored
%it and I'm lazy
ts_frames = ts_corr*3000;

%example to get vertical line on emg trace @ time of subject response:
% plot([ts_frames(1,9,1) ts_frames(1,9,1)],[-1.5 1])
    
%gets the emg traces in a window +-250ms around time of subj response
%+-750 frames to get 250ms @ 3kHz
test1 = emg_proc{1,1}(1,ts_frames(1,9,1)-750:ts_frames(1,9,1)+750);    
test2 = emg_proc{3,1}(1,ts_frames(3,9,1)-750:ts_frames(3,9,1)+750);    

%trying to make a pretty heatmap figure, getting close


for t = 1:size(emg,2)
    
    for tt = 1:length(emg)
        
        rule_emg{tt,t}(:,1) = emg_proc{tt,t}(1,ts_frames(tt,4,1):ts_frames(tt,6,1))';
        rule_emg{tt,t}(:,2) = emg_proc{tt,t}(2,ts_frames(tt,4,1):ts_frames(tt,6,1))';
        
        delay_emg{tt,t}(:,1) = emg_proc{tt,t}(1,ts_frames(tt,6,1):ts_frames(tt,8,1))';
        delay_emg{tt,t}(:,2) = emg_proc{tt,t}(2,ts_frames(tt,6,1):ts_frames(tt,8,1))';
        
        resp_emg{tt,t}(:,1) = emg_proc{tt,t}(1,ts_frames(tt,9,1)-750:ts_frames(tt,9,1)+750)';
        resp_emg{tt,t}(:,2) = emg_proc{tt,t}(2,ts_frames(tt,9,1)-750:ts_frames(tt,9,1)+750)';
       
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for tt = 1:length(emg)
    
    resp_emg1(:,tt) = emg_proc{tt,1}(1,ts_frames(tt,9,1)-750:ts_frames(tt,9,1)+750)';
    
end
testcorr = corr(resp_emg1);
imshow(testcorr,'Colormap', jet)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

resp_emg2 = nan(1501,60);
for tt = 1:length(f_trials)
    
    resp_emg2(:,tt) = emg_proc{s_trials(tt,1),1}(1,ts_frames(s_trials(tt,1),9,1)-750:ts_frames(s_trials(tt,1),9,1)+750)';
    resp_emg2(:,tt+30) = emg_proc{f_trials(tt,1),1}(1,ts_frames(s_trials(tt,1),9,1)-750:ts_frames(s_trials(tt,1),9,1)+750)';

    
end

testcorr2 = corr(resp_emg2);
imshow(testcorr2,'Colormap', jet)
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cond_index = cat(1,s_trials_ns,s_trials_es,s_trials_ls,f_trials_ns,f_trials_es,f_trials_ls);


resp_emg3 = nan(1501,60);
tracker = 0;
for i = 1:length(cond_index)
    
    ind_length = length(cond_index{i,1});
    
    for t = 1:ind_length
        
        resp_emg3(:,t+tracker) = emg_proc{cond_index{i,1}(t),1}(1,ts_frames(cond_index{i,1}(t),9,1)-750:ts_frames(cond_index{i,1}(t),9,1)+750)';
        
    end
    tracker = tracker+ind_length;
end
    
testcorr3 = corr(resp_emg3);
imshow(testcorr3,'Colormap', jet)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%from here: right now we are correlating all 60 trials in a block,
%regardless of whether the index or middle finger was used to respond

%so, only correlate trials that same finger was used to respond with,
%within block
%to do this use index of which finger was used (data{:,8}) and find same
%trials in cond_index (so you will essentially duplicate cond_index - one
%for index finger responses, one for middle finger responses)

%do this for blocks 2, 3, 4 individually

%then, concat blocks together so you have a one for PMd, one for vertex for
%each finger

%then concat those together so you have just one for each finger

%DONE FROM HERE UP

%optimal lag correlation functions?

%then do the same shit for the rule and delay phases

%COHERENCE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% mscohere(resp_emg3(:,1),resp_emg3(:,2))

%do it all for sliding window rms vectors maybe?

%read the emg analysis stuffs

cond_index = cat(1,s_trials_ns,s_trials_es,s_trials_ls,f_trials_ns,f_trials_es,f_trials_ls);


resp{1,1} = find(cell2mat(data{1,8}(s_trials_ns{1}))=='L');
resp{1,2} = find(cell2mat(data{1,8}(s_trials_ns{1}))=='R');

resp{2,1} = find(cell2mat(data{1,8}(s_trials_es{1}))=='L');
resp{2,2} = find(cell2mat(data{1,8}(s_trials_es{1}))=='R');

resp{3,1} = find(cell2mat(data{1,8}(s_trials_ls{1}))=='L');
resp{3,2} = find(cell2mat(data{1,8}(s_trials_ls{1}))=='R');

resp{4,1} = find(cell2mat(data{1,8}(f_trials_ns{1}))=='L');
resp{4,2} = find(cell2mat(data{1,8}(f_trials_ns{1}))=='R');

resp{5,1} = find(cell2mat(data{1,8}(f_trials_es{1}))=='L');
resp{5,2} = find(cell2mat(data{1,8}(f_trials_es{1}))=='R');

resp{6,1} = find(cell2mat(data{1,8}(f_trials_ls{1}))=='L');
resp{6,2} = find(cell2mat(data{1,8}(f_trials_ls{1}))=='R');

ts_frames = ts_corr*3000;

tlengths = sum(cellfun(@(x) length(x), resp));

resp_emg5 = nan(1501,tlengths(1));
tracker = 0;
for i = 1:length(cond_index)
    
    ind_length = length(cond_index{i,1}(resp{i,1}));
    
    for t = 1:ind_length
        
        resp_emg5(:,t+tracker) = emg_proc{cond_index{i,1}(resp{i,1}(t)),1}(1,ts_frames(cond_index{i,1}(resp{i,1}(t)),9,1)-750:ts_frames(cond_index{i,1}(resp{i,1}(t)),9,1)+750)';
        
    end
    tracker = tracker+ind_length;
end
    
testcorr5 = corr(resp_emg5);
imshow(testcorr5,'Colormap', jet)
%recheck that normed corr
%plots are the same as unnormed








        
