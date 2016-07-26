
% for s = 1:2
%     
%     index = s:2:length(adblData_mat);
%     channels(s,:) = adblData_mat(1,index);
%     
% end


%useless intermediary step while figuring out processing stream.
%should consolidate in the future (never make channels_temp; just index
%adblData_mat for the zeros and cut them out)
for t = 1:numtrials
    
    for s = 1:2
    
    index = s:2:length(adblData_mat);
    channels_temp(t,:,s) = adblData_mat(t,index);
    
    end
    
end

%cut zeros out of the end of the stream (because we ask for 2x the number
%of samples we expect, and get somewhere around our expected #)
%throws an error message if the real data stream has a zero in it
for t = 1:numtrials
    
    index = find(channels_temp(t,:,1)==0);
    
    if index(end)-index(1) == length(index)-1
        
        channels{t,1} = channels_temp(t,1:index(1)-1,1);
        channels{t,2} = channels_temp(t,1:index(1)-1,2);
        
    else
        
        sprintf('Error! Some real values==0 for trial %d!', t)
        
    end
    
end

%get timestamps for each trial

for t = 1:numtrials
    
    %correct so that first timestamp is at time zero (trial start)
    events(t,:) = VBLTimestamp(t,:)-streamstart_time;
    events(t,:) = events(t,:)-events(t,1);
    
end

%convert to frames
events_frames = events*scanRate;

%plot traces with timestamps, rules, and stimuli

%MAKE THIS LOOP THROUGH TWO FINGERS

t = input('Which trial to plot? ');  %trial you want to plot
samsec = 1/scanRate;
xt = [0:30000/10:30000]; %assumes 10 sec recording @ 3kHz

%Index finger plot
subplot(2,1,1), plot(channels{t,1})
set(gca,'xticklabel',arrayfun(@num2str,xt*samsec,'un',0))
hold on
title('Index')
xlabel('Seconds')
ylabel('mV')

%Middle finger plot FOH
subplot(2,1,2), plot(channels{t,2})        
set(gca,'xticklabel',arrayfun(@num2str,xt*samsec,'un',0))
hold on
title('Middle (FOH LOL)')
xlabel('Seconds')
ylabel('mV')

I_plot = subplot(2,1,1);
M_plot = subplot(2,1,2);
both_ylims = [ylim(I_plot);ylim(M_plot)];
new_ylims = [min(both_ylims(:,1)) max(both_ylims(:,2))];

subplot(2,1,1), ylim(new_ylims)
subplot(2,1,2), ylim(new_ylims)
    
for e = 2:5
    
    subplot(2,1,1), plot([events_frames(t,e) events_frames(t,e)],new_ylims,'r')
    subplot(2,1,2), plot([events_frames(t,e) events_frames(t,e)],new_ylims,'r')
    
end

%choose trial and event, make emg trace centered +-500ms around event

tnum = input('Which trial to plot? ');
enum = input('Which event to plot(5 for resp)? ');

%get emg traces +-500 around event

trace_index = [int32(events_frames(tnum,enum))-500:int32(events_frames(tnum,enum))+500];

temptrace_I = channels{tnum,1}(trace_index);
temptrace_M = channels{tnum,2}(trace_index);

plot(temptrace_I)
hold on
plot(temptrace_M)
ylims = ylim;
plot([501 501],ylims,'k')
xlim([0 1000])
ylim(ylims)


%get stats like %correct, RTs

%get RTs overall

respTime = events(:,5) - events(:,4);
hist(respTime,20)
xlabel('RespTime')
ylabel('Freq')
title('Overall RespTimes')

%get RTs for each finger

actual_finger = cell2mat(cat(2,respMat(7,:)));
I_index = find(actual_finger=='S');
M_index = find(actual_finger=='A');

respTime_I = events(I_index,5) - events(I_index,4);
respTime_M = events(M_index,5) - events(M_index,4);

subplot(3,1,1), hist(respTime_I)
xlabel('RespTime')
ylabel('Freq')
title('Index finger RespTimes')

subplot(3,1,2), hist(respTime_M)
xlabel('RespTime')
ylabel('Freq')
title('Middle finger RespTimes (FOH!!!)')

I_plot = subplot(3,1,1);
M_plot = subplot(3,1,2);
both_xlims = [xlim(I_plot);xlim(M_plot)];
new_xlims = [min(both_xlims(:,1)) max(both_xlims(:,2))];

subplot(3,1,1), xlim(new_xlims)
subplot(3,1,2), xlim(new_xlims)

subplot(3,1,3), plot(respTime_I)
hold on
subplot(3,1,3), plot(respTime_M)
xlabel('Trial number')
ylabel('RespTime')
title('RespTimes per trial for both fingers')
legend Index Middle

%get RTs for each trialtype
%condMatrix: 0==symbols, 1==fingers

S_index = find(condMatrix==0);
F_index = find(condMatrix==1);

respTime_S = events(S_index,5) - events(S_index,4);
respTime_F = events(F_index,5) - events(F_index,4);

subplot(3,1,1), hist(respTime_S)
xlabel('RespTime')
ylabel('Freq')
title('Symbolic association trial RespTimes')

subplot(3,1,2), hist(respTime_F)
xlabel('RespTime')
ylabel('Freq')
title('Motor association tria RespTimes')

S_plot = subplot(3,1,1);
F_plot = subplot(3,1,2);
both_xlims = [xlim(S_plot);xlim(F_plot)];
new_xlims = [min(both_xlims(:,1)) max(both_xlims(:,2))];

subplot(3,1,1), xlim(new_xlims)
subplot(3,1,2), xlim(new_xlims)

subplot(3,1,3), plot(respTime_S)
hold on
subplot(3,1,3), plot(respTime_F)
xlabel('Trial number')
ylabel('RespTime')
title('RespTimes per trial for both fingers')
legend SymbolicAss MotorAss












%start working on RMS stuff; integrate into whole-trial vector plots above
%read up on RMS window sizes first

%let's try window sizes of 25, 50, 75, and 100ms
%pad with NaNs to makes all vectors divisible by these values
%try just str8 up rms and then try nanrms
%nanrms = sqrt(nanmean(x.^2));

%get channel lengths
c_lengths = cellfun(@length,channels);

%find out how much we have to pad by, set the value we pad with
padsizes = zeros(30,2);
padsizes(:,2) = 30000-c_lengths(:,1);
padval = nan;

%preallocate and pad dat ish

channels_padded = cell(size(channels));

for p = 1:length(padsizes)
    
    channels_padded{p,1} = padarray(channels{p,1},padsizes(p,:),padval,'post');
    channels_padded{p,2} = padarray(channels{p,2},padsizes(p,:),padval,'post');
    
end

%channels are padded to 30000; now step through them in different window
%sizes and calc rms


























figure

for t = 1:30
    
    subplot(5,6,t), plot(channels(t,:,1))
    hold on
    subplot(5,6,t), plot(channels(t,:,2))
    
end



















figure
hold on

for t = 1:16
    
    plot(channels(t,:))
    
end


for t = 1:4
    
    event_markers(t,:) = VBLTimestamp(t,:) - streamstart_time;
    event_markers(t,:) = event_markers(t,:) - event_markers(t,1);
    
    event_markers_frames(t,:) = event_markers(t,:)*scanRate;
    
end
    
    


figure

for t = 1:4
    
    subplot(2,2,t), plot(adblData_mat(t,:))
    ylimits = ylim;
    hold on
    
    for e = 2:5
        
        subplot(2,2,t), plot([event_markers_frames(t,e) event_markers_frames(t,e)],ylim,'r')
        
    end
    
    ylim(ylimits)
    
end

figure

for t = 1:4
    
    subplot(2,2,t), plot(channels(1,:,t))
    hold on
    subplot(2,2,t), plot(channels(2,:,t))
    
end