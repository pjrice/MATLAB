function y = winrms(signal, windowlength, overlap, nanpad)

%gets sliding window rms of signal vector
%signal is 1-D vector
%windowlength is length of RMS window in samples
%overlap is number of samples to overlap adjacent windows (0 for no
%overlap)
% nanpad is flag for nan padding the end of the data (0 for no, 1 for yes)

delta = windowlength - overlap;

indices = 1:delta:length(signal);

%nanpad signal
if length(signal) - indices(end) +1 < windowlength
    if nanpad
        signal(end+1:indices(end)+windowlength-1) = nan;
    else
        indices = indices(1:find(indices+windowlength-1 <= length(signal), 1, 'last'));
    end
end

y = zeros(1, length(indices));
%square samples
signal = signal.^2;

index = 0;

for i = indices
    index = index+1;
    %nanmean and take sqrt of each window
    z(index) = sqrt(nanmean(signal(i:i+windowlength-1)));
end

%upsample using interp to match length of original vector
y = interp(z, delta);