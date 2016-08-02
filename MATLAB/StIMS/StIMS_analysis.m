%script to do cursory analysis of StIMS data

%ASSUMES CHANNEL 1 WAS LEFT ARM/HAND, CH2 RIGHT ARM/HAND

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%load the data

[fname,pathname,~] = uigetfile('*.mat', 'StIMS data file?');

load(strcat(pathname,fname))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%chop zeros off of raw EMG vector (because we requested twice the number of
%expected scans)


%get index of zeros in EMG vector
chop_index = find(adblData_mat==0);

%check to make sure there are no zeros in the real data - otherwise, this
%would chop at that point. Very dumb chop mechanism
if chop_index(end) - chop_index(1) == length(chop_index)-1
    
    emg_temp = adblData_mat(1,1:chop_index(1)-1);
    
else
    
    error('Error! Some real values==0! Get Patrick to stop being lazy and refine chop!')
    
end

%extract individual channels from chopped vector

emg_ch1 = emg_temp(1,1:2:end);
emg_ch2 = emg_temp(1,2:2:end);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%mean correct channels

emg_ch1 = emg_ch1 - mean(emg_ch1);
emg_ch2 = emg_ch2 - mean(emg_ch2);

%norm to std or MVC later


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%fft dat ish (full trace)

Fs = scanRate;
T = 1/Fs;
L = length(emg_ch1);
t = (0:L-1)*T;
fdom = Fs*(0:(L/2))/L;

fft_ch1 = fft(emg_ch1);
fft_ch2 = fft(emg_ch2);

%single-sided amplitude stuff
P2_ch1 = abs(fft_ch1/L);
P2_ch2 = abs(fft_ch2/L);

P1_ch1 = P2_ch1(1:L/2+1);
P1_ch2 = P2_ch2(1:L/2+1);

P1_ch1(2:end-1) = 2*P1_ch1(2:end-1);
P1_ch2(2:end-1) = 2*P1_ch2(2:end-1);

%PSD stuff
Pyy_ch1 = fft_ch1.*conj(fft_ch1)/L;
Pyy_ch2 = fft_ch2.*conj(fft_ch2)/L;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%plot dat ish

m = find(fdom>250 & fdom<251.1);

%Single-sided Amplitude Spectrum
figure(1)
h1 = subplot(2,1,1);plot(fdom(1:m(1)),P1_ch1(1:m(1)))
h2 = subplot(2,1,2);plot(fdom(1:m(1)),P1_ch2(1:m(1)))
h1.Title.String = 'Channel 1';
h1.XLabel.String = 'f(Hz)';
h1.YLabel.String = '|P1(f)|';
h2.Title.String = 'Channel 2';
h2.XLabel.String = 'f(Hz)';
h2.YLabel.String = '|P1(f)|';
%set global title
set(gcf,'NextPlot','add');
axes;
htitle = title('Single-sided Amplitude Spectrum, Full trace');
set(gca,'Visible','off');
set(htitle,'Visible','on');
htitle.Position = [0.5 1.04 0.5];

%Power Spectral Density
figure(2)
h1 = subplot(2,1,1);plot(fdom(1:m(1)),Pyy_ch1(1:m(1)))
h2 = subplot(2,1,2);plot(fdom(1:m(1)),Pyy_ch2(1:m(1)))
h1.Title.String = 'Channel 1';
h1.XLabel.String = 'f(Hz)';
h1.YLabel.String = 'Power';
h2.Title.String = 'Channel 2';
h2.XLabel.String = 'f(Hz)';
h2.YLabel.String = 'Power';
%set global title
set(gcf,'NextPlot','add');
axes;
htitle = title('Power Spectral Density, Full trace');
set(gca,'Visible','off');
set(htitle,'Visible','on');
htitle.Position = [0.5 1.04 0.5];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




