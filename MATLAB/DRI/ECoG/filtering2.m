data_in = data.Wave.data(53,:);    
data_in = double(data_in);

[b,a] = butter(4,300/data.Wave.fs,'high');
    qdata = filtfilt(b,a,data_in);
    

    
    
    Fs = data.Wave.fs;
T = 1/Fs;
L = length(qdata);
fdom = Fs*(0:(L/2))/L;
tester2 = fft(qdata);

tester2(520000:530000) = 0;
tester2(310000:320000) = 0;
tester2(230000:240000) = 0;
tester2(210000:220000) = 0;

P2 = abs(tester2/L);

P1 = P2(1:L/2+1);

P1(2:end-1) = 2*P1(2:end-1);

Pyy = tester2.*conj(tester2)/L;

plot(fdom,Pyy(1:end/2+1))


int32(3.147e6)

inv_fft = real(ifft(tester2));



tester2(520000:530000) = 0;
tester2(310000:320000) = 0;
tester2(230000:240000) = 0;
tester2(210000:220000) = 0;