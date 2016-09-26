%script to be used for all 3 datasets from 70bf0c
%divide data from 70bf0c into files only containing channels from the same
%linear electrodes in order to despike, highpass, and common average
%reference in an easier manner

%sampling rate was equal across all channels
fs = data.ECO1.fs;

%ECO1
LLF_data = data.ECO1.data(1:12,:);
filename = 'Z:\Work\UW\projects\MAZE\ECoG\70bf0c\brain\70bf0c_MAZE_LLF.mat';
save(filename,'LLF_data','filename','channel_map','fs');
clear LLF_data

LPF_data = data.ECO1.data(13:22,:);
filename = 'Z:\Work\UW\projects\MAZE\ECoG\70bf0c\brain\70bf0c_MAZE_LPF.mat';
save(filename,'LPF_data','filename','channel_map','fs');
clear LPF_data

RLF_data = data.ECO1.data(23:end,:);
filename = 'Z:\Work\UW\projects\MAZE\ECoG\70bf0c\brain\70bf0c_MAZE_RLF.mat';
save(filename,'RLF_data','filename','channel_map','fs');
clear RLF_data


%ECO2
RMF_data = data.ECO2.data(1:10,:);
filename = 'Z:\Work\UW\projects\MAZE\ECoG\70bf0c\brain\70bf0c_MAZE_RMF.mat';
save(filename,'RMF_data','filename','channel_map','fs');
clear RMF_data

LAF_data = data.ECO2.data(11:18,:);
filename = 'Z:\Work\UW\projects\MAZE\ECoG\70bf0c\brain\70bf0c_MAZE_LAF.mat';
save(filename,'LAF_data','filename','channel_map','fs');
clear LAF_data

RPF_data = data.ECO2.data(19:26,:);
filename = 'Z:\Work\UW\projects\MAZE\ECoG\70bf0c\brain\70bf0c_MAZE_RPF.mat';
save(filename,'RPF_data','filename','channel_map','fs');
clear RPF_data

%channels 27-32 on ECO2 were empty


%ECO3
RAT_data = data.ECO3.data(1:8,:);
filename = 'Z:\Work\UW\projects\MAZE\ECoG\70bf0c\brain\70bf0c_MAZE_RAT.mat';
save(filename,'RAT_data','filename','channel_map','fs');
clear RAT_data

RMT_data = data.ECO3.data(9:16,:);
filename = 'Z:\Work\UW\projects\MAZE\ECoG\70bf0c\brain\70bf0c_MAZE_RMT.mat';
save(filename,'RMT_data','filename','channel_map','fs');
clear RMT_data

%channels 17:24 on ECO3 were empty - I made a mistake in plugging in the
%connectors

RPT_data = data.ECO3.data(25:32,:);
filename = 'Z:\Work\UW\projects\MAZE\ECoG\70bf0c\brain\70bf0c_MAZE_RPT.mat';
save(filename,'RPT_data','filename','channel_map','fs');
clear RPT_data

%ECO4 was empty

























