
for tt = 1:20
    
    h = subplot(2,1,1);plot(esls_fdom{tt,b}(1:m),es_P1{tt,b,1}(1:m))  %plot through 250Hz
    hold on
    subplot(2,1,1),plot([10 10],[0 0.3])
    
    h.Title.String = sprintf('trial %d',tt);
    
    subplot(2,1,2),plot(emg_proc{es_indices(tt),b,1}(1,:))
    hold on
    subplot(2,1,2),plot([10 10],[0 0.3])

    waitforbuttonpress
    
    close all
    
end




t=44;
tt=8;
b=3;
m = find(round(esls_fdom{tt,b})==250);
n = find(round(resp_fdom{t,b})==250);


h1 = subplot(2,2,1);
plot(esls_fdom{tt,b}(1:m),es_P1{tt,b,1}(1:m))  %plot through 250Hz
hold on
subplot(2,2,1),plot([10 10],[0 0.3])
h1.Title.String = 'Single-sided amplitude spectrum; stimulation window; trial 44, block 3';
h1.XLabel.String = 'f(Hz)';
h1.YLabel.String = 'Amplitude';

h2 = subplot(2,2,2);
plot(emg_proc{es_indices(tt),b,1}(1,:))
hold on
subplot(2,2,2),plot([0 length(emg_proc{es_indices(tt),b,1}(2,:))],[0 0],'k')
h2.Title.String = 'Full EMG trace; trial 44, block 3';
h2.YLabel.String = 'microvolts';
h2.XLabel.String = 'seconds'
h2.XLim = [0 length(emg_proc{es_indices(tt),b,1}(2,:))];
h2.YLim = [-40 40];
h2.XTick = [0:3000:36000];
h2.XTickLabel = xticklabels;


h3 = subplot(2,2,3);
plot(resp_fdom{t,b}(1:n),resp_P1{t,b,1}(1:n))
hold on
subplot(2,2,3),plot([10 10],[0 0.3])
h3.Title.String = 'Single-sided amplitude spectrum; response window; trial 44, block 3';
h3.YLim = [0 0.4];
h3.XLabel.String = 'f(Hz)';
h3.YLabel.String = 'Amplitude';

h4 = subplot(2,2,4);
plot(resp_emg{es_indices(tt),b,1})
hold on
plot(resp_rms{es_indices(tt),b,1},'r')
plot([0 length(resp_emg{es_indices(tt),b,2}(1,:))],[0 0],'k')
plot([750 750],[-2.5 2.5],'k')
h4.Title.String = 'Response window EMG trace; trial 44, block 3';
h4.YLabel.String = 'microvolts';
h4.XLabel.String = 'ms relative to response';
h4.YLim = [-2.5 2.5];
h4.XLim = [0 1500];
h4.XTick = [0:150:1500];
h4.XTickLabel = xticklabels1;

h0 = axes;
h0.Title.String = '2406; Odd->A; B 5 A; correct';
h0.Visible = 'off';
h0.Title.Visible = 'on';
h0.Title.Position = [0.5000 1.04 0.5000];




xticklabels1{1,1} = '-750';
xticklabels1{2,1} = '-600';
xticklabels1{3,1} = '-450';
xticklabels1{4,1} = '-300';
xticklabels1{5,1} = '-150';
xticklabels1{6,1} = '0';
xticklabels1{7,1} = '150';
xticklabels1{8,1} = '300';
xticklabels1{9,1} = '450';
xticklabels1{10,1} = '600';
xticklabels1{11,1} = '750';


xticklabels{1,1} = '0';
xticklabels{2,1} = '1';
xticklabels{3,1} = '2';
xticklabels{4,1} = '3';
xticklabels{5,1} = '4';
xticklabels{6,1} = '5';
xticklabels{7,1} = '6';
xticklabels{8,1} = '7';
xticklabels{9,1} = '8';
xticklabels{10,1} = '9';
xticklabels{11,1} = '10';
xticklabels{12,1} = '11';
xticklabels{13,1} = '12';



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t=42;
tt=8;
b=3;
m = find(round(esls_fdom{tt,b})==250);
n = find(round(resp_fdom{t,b})==250);


h1 = subplot(2,2,1);
plot(esls_fdom{tt,b}(1:m),ls_P1{tt,b,1}(1:m))  %plot through 250Hz
hold on
subplot(2,2,1),plot([10 10],[0 0.3])
h1.Title.String = 'Single-sided amplitude spectrum; stimulation window; trial 42, block 3';
h1.XLabel.String = 'f(Hz)';
h1.YLabel.String = 'Amplitude';

h2 = subplot(2,2,2);
plot(emg_proc{ls_indices(tt),b,1}(1,:))
hold on
subplot(2,2,2),plot([0 length(emg_proc{ls_indices(tt),b,1}(2,:))],[0 0],'k')
h2.Title.String = 'Full EMG trace; trial 42, block 3';
h2.YLabel.String = 'microvolts';
h2.XLabel.String = 'seconds'
h2.XLim = [0 length(emg_proc{ls_indices(tt),b,1}(2,:))];
h2.YLim = [-40 40];
h2.XTick = [0:3000:36000];
h2.XTickLabel = xticklabels;


h3 = subplot(2,2,3);
plot(resp_fdom{t,b}(1:n),resp_P1{t,b,1}(1:n))
hold on
subplot(2,2,3),plot([10 10],[0 0.3])
h3.Title.String = 'Single-sided amplitude spectrum; response window; trial 42, block 3';
h3.YLim = [0 0.4];
h3.XLabel.String = 'f(Hz)';
h3.YLabel.String = 'Amplitude';

h4 = subplot(2,2,4);
plot(resp_emg{ls_indices(tt),b,1})
hold on
plot(resp_rms{ls_indices(tt),b,1},'r')
plot([0 length(resp_emg{ls_indices(tt),b,2}(1,:))],[0 0],'k')
plot([750 750],[-2.5 2.5],'k')
h4.Title.String = 'Response window EMG trace; trial 42, block 3';
h4.YLabel.String = 'microvolts';
h4.XLabel.String = 'ms relative to response';
h4.YLim = [-8 8];
h4.XLim = [0 1500];
h4.XTick = [0:150:1500];
h4.XTickLabel = xticklabels1;

h0 = axes;
h0.Title.String = '2406; Even->B; B 5 A; correct';
h0.Visible = 'off';
h0.Title.Visible = 'on';
h0.Title.Position = [0.5000 1.04 0.5000];




xticklabels1{1,1} = '-750';
xticklabels1{2,1} = '-600';
xticklabels1{3,1} = '-450';
xticklabels1{4,1} = '-300';
xticklabels1{5,1} = '-150';
xticklabels1{6,1} = '0';
xticklabels1{7,1} = '150';
xticklabels1{8,1} = '300';
xticklabels1{9,1} = '450';
xticklabels1{10,1} = '600';
xticklabels1{11,1} = '750';


xticklabels{1,1} = '0';
xticklabels{2,1} = '1';
xticklabels{3,1} = '2';
xticklabels{4,1} = '3';
xticklabels{5,1} = '4';
xticklabels{6,1} = '5';
xticklabels{7,1} = '6';
xticklabels{8,1} = '7';
xticklabels{9,1} = '8';
xticklabels{10,1} = '9';
xticklabels{11,1} = '10';
xticklabels{12,1} = '11';
xticklabels{13,1} = '12';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t=41;
tt=7;
b=2;
m = find(round(esls_fdom{tt,b})==250);
n = find(round(resp_fdom{t,b})==250);


h1 = subplot(2,2,1);
plot(esls_fdom{tt,b}(1:m),ls_P1{tt,b,1}(1:m))  %plot through 250Hz
hold on
subplot(2,2,1),plot([10 10],[0 0.3])
h1.Title.String = 'Single-sided amplitude spectrum; stimulation window; trial 41, block 2';
h1.XLabel.String = 'f(Hz)';
h1.YLabel.String = 'Amplitude';

h2 = subplot(2,2,2);
plot(emg_proc{ls_indices(tt),b,1}(1,:))
hold on
subplot(2,2,2),plot([0 length(emg_proc{ls_indices(tt),b,1}(2,:))],[0 0],'k')
h2.Title.String = 'Full EMG trace; trial 41, block 2';
h2.YLabel.String = 'microvolts';
h2.XLabel.String = 'seconds'
h2.XLim = [0 length(emg_proc{ls_indices(tt),b,1}(2,:))];
h2.YLim = [-40 40];
h2.XTick = [0:3000:36000];
h2.XTickLabel = xticklabels;


h3 = subplot(2,2,3);
plot(resp_fdom{t,b}(1:n),resp_P1{t,b,1}(1:n))
hold on
subplot(2,2,3),plot([10 10],[0 0.3])
h3.Title.String = 'Single-sided amplitude spectrum; response window; trial 41, block 2';
h3.YLim = [0 0.4];
h3.XLabel.String = 'f(Hz)';
h3.YLabel.String = 'Amplitude';

h4 = subplot(2,2,4);
plot(resp_emg{ls_indices(tt),b,1})
hold on
plot(resp_rms{ls_indices(tt),b,1},'r')
plot([0 length(resp_emg{ls_indices(tt),b,2}(1,:))],[0 0],'k')
plot([750 750],[-2.5 2.5],'k')
h4.Title.String = 'Response window EMG trace; trial 41, block 2';
h4.YLabel.String = 'microvolts';
h4.XLabel.String = 'ms relative to response';
h4.YLim = [-8 8];
h4.XLim = [0 1500];
h4.XTick = [0:150:1500];
h4.XTickLabel = xticklabels1;

h0 = axes;
h0.Title.String = '1822; Even->B; B 2 A; correct';
h0.Visible = 'off';
h0.Title.Visible = 'on';
h0.Title.Position = [0.5000 1.04 0.5000];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t=58;
tt=20;
b=2;
m = find(round(esls_fdom{tt,b})==250);
n = find(round(resp_fdom{t,b})==250);


h1 = subplot(2,2,1);
plot(esls_fdom{tt,b}(1:m),es_P1{tt,b,1}(1:m))  %plot through 250Hz
hold on
subplot(2,2,1),plot([10 10],[0 0.3])
h1.Title.String = 'Single-sided amplitude spectrum; stimulation window; trial 58, block 2';
h1.XLabel.String = 'f(Hz)';
h1.YLabel.String = 'Amplitude';

h2 = subplot(2,2,2);
plot(emg_proc{es_indices(tt),b,1}(1,:))
hold on
subplot(2,2,2),plot([0 length(emg_proc{es_indices(tt),b,1}(2,:))],[0 0],'k')
h2.Title.String = 'Full EMG trace; trial 58, block 2';
h2.YLabel.String = 'microvolts';
h2.XLabel.String = 'seconds'
h2.XLim = [0 length(emg_proc{es_indices(tt),b,1}(2,:))];
h2.YLim = [-40 40];
h2.XTick = [0:3000:36000];
h2.XTickLabel = xticklabels;


h3 = subplot(2,2,3);
plot(resp_fdom{t,b}(1:n),resp_P1{t,b,1}(1:n))
hold on
subplot(2,2,3),plot([10 10],[0 0.3])
h3.Title.String = 'Single-sided amplitude spectrum; response window; trial 58, block 2';
h3.YLim = [0 0.4];
h3.XLabel.String = 'f(Hz)';
h3.YLabel.String = 'Amplitude';

h4 = subplot(2,2,4);
plot(resp_emg{es_indices(tt),b,1})
hold on
plot(resp_rms{es_indices(tt),b,1},'r')
plot([0 length(resp_emg{es_indices(tt),b,2}(1,:))],[0 0],'k')
plot([750 750],[-2.5 2.5],'k')
h4.Title.String = 'Response window EMG trace; trial 58, block 2';
h4.YLabel.String = 'microvolts';
h4.XLabel.String = 'ms relative to response';
h4.YLim = [-2.5 2.5];
h4.XLim = [0 1500];
h4.XTick = [0:150:1500];
h4.XTickLabel = xticklabels1;

h0 = axes;
h0.Title.String = '2406; Odd->Middle; 2; correct';
h0.Visible = 'off';
h0.Title.Visible = 'on';
h0.Title.Position = [0.5000 1.04 0.5000];


