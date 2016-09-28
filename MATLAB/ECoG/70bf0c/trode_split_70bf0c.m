%script to be used for all 3 datasets from 70bf0c
%divide data from 70bf0c into files only containing channels from the same
%linear electrodes in order to despike, highpass, and common average
%reference in an easier manner

%sampling rate was equal across all channels
fs = ECO1.info.SamplingRateHz;

%ECO1
LLF_data = ECO1.data(:,1:12);
filename = 'Z:\Work\UW\projects\DRI\ECoG\70bf0c\brain\70bf0c_DRI_LLF.mat';
save(filename,'LLF_data','filename','channel_map','fs','-v7.3');
clear LLF_data

LPF_data = ECO1.data(:,13:22);
filename = 'Z:\Work\UW\projects\DRI\ECoG\70bf0c\brain\70bf0c_DRI_LPF.mat';
save(filename,'LPF_data','filename','channel_map','fs','-v7.3');
clear LPF_data

RLF_data = ECO1.data(:,23:end);
filename = 'Z:\Work\UW\projects\DRI\ECoG\70bf0c\brain\70bf0c_DRI_RLF.mat';
save(filename,'RLF_data','filename','channel_map','fs','-v7.3');
clear RLF_data


%ECO2
RMF_data = ECO2.data(:,1:10);
filename = 'Z:\Work\UW\projects\DRI\ECoG\70bf0c\brain\70bf0c_DRI_RMF.mat';
save(filename,'RMF_data','filename','channel_map','fs','-v7.3');
clear RMF_data

LAF_data = ECO2.data(:,11:18);
filename = 'Z:\Work\UW\projects\DRI\ECoG\70bf0c\brain\70bf0c_DRI_LAF.mat';
save(filename,'LAF_data','filename','channel_map','fs','-v7.3');
clear LAF_data

RPF_data = ECO2.data(:,19:26);
filename = 'Z:\Work\UW\projects\DRI\ECoG\70bf0c\brain\70bf0c_DRI_RPF.mat';
save(filename,'RPF_data','filename','channel_map','fs','-v7.3');
clear RPF_data

%channels 27-32 on ECO2 were empty


%ECO3
RAT_data = ECO3.data(:,1:8);
filename = 'Z:\Work\UW\projects\DRI\ECoG\70bf0c\brain\70bf0c_DRI_RAT.mat';
save(filename,'RAT_data','filename','channel_map','fs','-v7.3');
clear RAT_data

RMT_data = ECO3.data(:,9:16);
filename = 'Z:\Work\UW\projects\DRI\ECoG\70bf0c\brain\70bf0c_DRI_RMT.mat';
save(filename,'RMT_data','filename','channel_map','fs','-v7.3');
clear RMT_data

%channels 17:24 on ECO3 were empty - I made a mistake in plugging in the
%connectors

RPT_data = ECO3.data(:,25:32);
filename = 'Z:\Work\UW\projects\DRI\ECoG\70bf0c\brain\70bf0c_DRI_RPT.mat';
save(filename,'RPT_data','filename','channel_map','fs','-v7.3');
clear RPT_data

%ECO4 was empty

























