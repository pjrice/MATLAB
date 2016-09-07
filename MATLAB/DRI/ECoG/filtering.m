
%despike (remove artifacts) first
tester = despike(data.Wave.data(1,:));

tester = tester';

%mean correct first or filter first?
cmean = mean(tester);
tester = tester - cmean;

d = fdesign.lowpass('Fp,Fst,Ap,Ast',0.4,0.5,40,100);
Hd = design(d,'butter');
tester1 = filter(Hd,tester);

%remove line noise
%is not working???

% params.tapers = [3 5];
% params.Fs = data.Wave.fs;
% params.fpass = [0 params.Fs/2];
% params.pad = 0;
% params.err = 0;
% params.trialave = 0;
% 
% p = 0.05/length(tester1);
% plt = 'n';
% f0 = 60;
% 
% tester1 = rmlinesc(tester1,params,p,plt,f0);

%fft
Fs = data.Wave.fs;
T = 1/Fs;
L = length(tester1);
fdom = Fs*(0:(L/2))/L;

tester2 = fft(tester1);

P2 = abs(tester2/L);

P1 = P2(1:L/2+1);

P1(2:end-1) = 2*P1(2:end-1);

Pyy = tester2.*conj(tester2)/L;

%plot
f = min(find(fdom>=0.1));
m = min(find(fdom>=400));

plot(fdom(f:m), Pyy(f:m))

plot(fdom(f:m),P1(f:m))

