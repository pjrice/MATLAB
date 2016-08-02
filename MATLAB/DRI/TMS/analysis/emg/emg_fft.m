%Fourier transform data and look at it
%can also try spectrogram(x) for pretty looking plot

Fs = 3000;
T = 1/Fs;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%full trace - 

for b = 1:4
    
    for tt = 1:length(emg_proc)
        
        L = length(emg_proc{tt,b}(1,:));
        t = (0:L-1)*T;
        fdom{tt,b} = Fs*(0:(L/2))/L;
        
        emg_fft{tt,b,1} = fft(emg_proc{tt,b}(1,:));
        emg_fft{tt,b,2} = fft(emg_proc{tt,b}(2,:));
        
        P2{tt,b,1} = abs(emg_fft{tt,b,1}/L);
        P2{tt,b,2} = abs(emg_fft{tt,b,2}/L);
        
        P1{tt,b,1} = P2{tt,b,1}(1:L/2+1);
        P1{tt,b,2} = P2{tt,b,2}(1:L/2+1);
        
    end
end


m = find(fdom{tt,b}==250);

for tt = 1:60
    
    h = subplot(2,1,1);plot(fdom{tt,b}(1:m),P1{tt,b,1}(1:m))  %plot through 250Hz

    
    h.Title.String = sprintf('trial %d',tt);
    
    subplot(2,1,2),plot(fdom{tt,b}(1:m),P1{tt,b,2}(1:m))

    waitforbuttonpress
    
    close all
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%resp trace (1.5sec window around response)

for b = 1:4
    
    for tt = 1:length(resp_emg)
        
        L = length(resp_emg{tt,b,1});
        t = (0:L-1)*T;
        resp_fdom{tt,b} = Fs*(0:(L/2))/L;
        
        resp_emg_fft{tt,b,1} = fft(resp_emg{tt,b,1});
        resp_emg_fft{tt,b,2} = fft(resp_emg{tt,b,2});
        
        resp_P2{tt,b,1} = abs(resp_emg_fft{tt,b,1}/L);
        resp_P2{tt,b,2} = abs(resp_emg_fft{tt,b,2}/L);
        
        resp_P1{tt,b,1} = resp_P2{tt,b,1}(1:L/2+1);
        resp_P1{tt,b,2} = resp_P2{tt,b,2}(1:L/2+1);
        
    end
end

m = find(round(resp_fdom{tt,b})==250);

b=3;
for tt = 1:60
    
    h = subplot(2,1,1),plot(resp_fdom{tt,b}(1:m),resp_P1{tt,b,1}(1:m));

    h.Title.String = sprintf('trial %d',tt);
    
    subplot(2,1,2),plot(resp_fdom{tt,b}(1:m),resp_P1{tt,b,2}(1:m))

    waitforbuttonpress
    
    close all
    
end


spectrogram(resp_emg{tt,b,1},'yaxis')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%traces during stimulation - look for peaks in freq that aren't in non-stim
%just got the emg traces, now run fft on them

Fs = 3000;
T = 1/Fs;

for b = 1:4
    
    for tt = 1:length(es_emg)
        
        L = length(es_emg{tt,b,1});
        t = (0:L-1)*T;
        esls_fdom{tt,b} = Fs*(0:(L/2))/L;
        
        es_emg_fft{tt,b,1} = fft(es_emg{tt,b,1});
        es_emg_fft{tt,b,2} = fft(es_emg{tt,b,2});
        
        es_P2{tt,b,1} = abs(es_emg_fft{tt,b,1}/L);
        es_P2{tt,b,2} = abs(es_emg_fft{tt,b,2}/L);
        
        es_P1{tt,b,1} = es_P2{tt,b,1}(1:L/2+1);
        es_P1{tt,b,2} = es_P2{tt,b,2}(1:L/2+1);
        
        ls_emg_fft{tt,b,1} = fft(ls_emg{tt,b,1});
        ls_emg_fft{tt,b,2} = fft(ls_emg{tt,b,2});
        
        ls_P2{tt,b,1} = abs(ls_emg_fft{tt,b,1}/L);
        ls_P2{tt,b,2} = abs(ls_emg_fft{tt,b,2}/L);
        
        ls_P1{tt,b,1} = ls_P2{tt,b,1}(1:L/2+1);
        ls_P1{tt,b,2} = ls_P2{tt,b,2}(1:L/2+1);
        
    end
end
        
m = find(round(esls_fdom{tt,b})==250);

b=3;

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


es_indices = cat(1,es_index{:,b});

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








spectrogram(es_emg){tt,b,1},'yaxis')
        
for tt = 1:20
    
    h = subplot(2,1,1);plot(esls_fdom{tt,b}(1:m),ls_P1{tt,b,1}(1:m))  %plot through 250Hz
    hold on
    subplot(2,1,1),plot([10 10],[0 0.3])
    
    h.Title.String = sprintf('trial %d',tt);
    
    subplot(2,1,2),plot(esls_fdom{tt,b}(1:m),ls_P1{tt,b,2}(1:m))
    hold on
    subplot(2,1,2),plot([10 10],[0 0.3])
    
    waitforbuttonpress
    
    close all
    
end


b=3;
        
for tt = 1:20
    
    spectrogram(es_emg{tt,b,1},'yaxis')
    
    waitforbuttonpress
    
    close all
    
end
        
for tt = 1:20
    
    spectrogram(ls_emg{tt,b,1},'yaxis')
    
    waitforbuttonpress
    
    close all
    
end       
        

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        




