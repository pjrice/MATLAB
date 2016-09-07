
load('Z:\Work\UW\projects\ECoG\data\patient1\patient1_brain.mat');
load('Z:\Work\UW\projects\ECoG\data\patient_1_behav.mat')

% filtered_data = TDTdigitalfilter(data.Wave, [1 150]);

ts_corr = gsubtract(timestamps,TDT_recording_start);

ts_samples = ts_corr*data.Wave.fs;


for c = 1:size(data.Wave.data,1)
    
    for t = 1:length(ts_samples)
        
        for b = 1:size(ts_samples,3)
            
            data_pt{c,t,b} = filtered_data.data(c,ts_samples(t,1,b):ts_samples(t,11,b));
            
        end
    end
end

Fs = data.Wave.fs;
T = 1/Fs;

for c = 1:size(data_pt,1)
    
    for t = 1:size(data_pt,2)
        
        for b = 1:size(data_pt,3)
            
            L = length(data_pt{c,t,b});
            tt = (0:L-1)*T;
            fdom{c,t,b} = Fs*(0:(L/2))/L;
            
            data_fft{c,t,b} = fft(data_pt{c,t,b});
            
            P2{c,t,b} = abs(data_fft{c,t,b}/L);
            
            P1{c,t,b} = P2{c,t,b}(1:L/2+1);
            
            P1{c,t,b}(2:end-1) = 2*P1{c,t,b}(2:end-1);
            
            Pyy{c,t,b} = data_fft{c,t,b}.*conj(data_fft{c,t,b})/L;
            
        end
    end
end


for b = 1:size(data_pt,3)
    
    for t = 1:size(data_pt,2)
        
        for c = 1:size(data_pt,1)
            
            m = find(fdom{c,t,b}>250 & fdom{c,t,b}<250.1);
            
            h = plot(fdom{c,t,b}(1:m(1)),Pyy{c,t,b}(1:m(1)));
            
            h.Parent.Title.String = sprintf('Channel %d',c);
            
            waitforbuttonpress
            
            close all
            
        end
    end
end
    
            
            



















m = find(fdom>250 & fdom<251.1);

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


for tt = 1:20
    
    h = subplot(2,1,1);plot(esls_fdom{tt,b}(1:m),es_P1{tt,b,1}(1:m))  %plot through 250Hz
    hold on
    subplot(2,1,1),plot([10 10],[0 0.3])
    
    h.Title.String = sprintf('trial %d',tt);
    
    subplot(2,1,2),plot(esls_fdom{tt,b}(1:m),es_P1{tt,b,2}(1:m))
    hold on
    subplot(2,1,2),plot([10 10],[0 0.3])

    waitforbuttonpress
    
    close all
    
end


for c = 1:128
    
    plot(data.Wave.data(c,:))
    
    waitforbuttonpress
    
    close all
    
end









            
            


