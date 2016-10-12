[b1,a1]=butter(4,100/(fs/2),'high');


filt = filtfilt(b1,a1,trial_data{1,1});

%list of filters applied with David and Andrea 9/28
% [b1,a1]=butter(4,300/(fs/2),'high');  %pass everything above 300Hz - looking for single unit
% [b1,a1]=butter(4,[300/(fs/2) 0.99]);  %bandpass between 300 and nyquist - single unit
% [b1,a1]=butter(4,100/(fs/2),'low');  %pass everything below 100Hz - looking @ LFP
% [b1,a1]=butter(4,100/(fs/2),'high');  %pass everything above 100Hz - thought passing above 300 might have missed single unit
% [b1,a1]=butter(2,[1/(fs/2) 100/(fs/2)]);  %bandpass between 1 and 100Hz - looking @ LFP