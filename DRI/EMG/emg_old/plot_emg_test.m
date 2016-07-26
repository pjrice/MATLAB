


emg_trace{1} = adblData_mat(1,1:71800);
emg_trace{2} = adblData_mat(2,1:68100);
emg_trace{3} = adblData_mat(3,1:65800);
emg_trace{4} = adblData_mat(4,1:67500);
emg_trace{5} = adblData_mat(5,1:62300);
emg_trace{6} = adblData_mat(6,1:66600);
emg_trace{7} = adblData_mat(7,1:67200);
emg_trace{8} = adblData_mat(8,1:72000);
emg_trace{9} = adblData_mat(9,1:65300);
emg_trace{10} = adblData_mat(10,1:67200);
emg_trace{11} = adblData_mat(11,1:64000);
emg_trace{12} = adblData_mat(12,1:59900);
emg_trace{13} = adblData_mat(13,1:68700);
emg_trace{14} = adblData_mat(14,1:62300);
emg_trace{15} = adblData_mat(15,1:61500);
emg_trace{16} = adblData_mat(16,1:21400);

emg_trace{16}(21401:30000) = 0;

for trial = 1:16
    
    for event = 1:5
        
        %relative from stream start
        rel_ts(trial,event) = VBLTimestamp(trial,event) - streamstart_time;
        
    end
    
    %corrected so that fix cross is time zero and is in samples/sec
    rel_ts_corrected(trial,:) = (rel_ts(trial,:) - rel_ts(trial,1))*3000; 
    
end





t = 1;
figure
hold on
ylim([-0.3,0.5])
plot(emg_trace{t}(1:30000))

for e = 2:5
    
    plot([rel_ts_corrected(t,e),rel_ts_corrected(t,e)],[-0.3,0.5],'r')
    
end

figure

for t = 1:16

    subplot(4,4,t)
    hold on
    plot(emg_trace{t}(1:30000))
    ylim([-0.3,0.5])
    title(strcat('Trial ',num2str(t)))
    
    for e = 2:5
    
        plot([rel_ts_corrected(t,e),rel_ts_corrected(t,e)],[-0.3,0.5],'r')
    
    end
    
end

for t = 1:16
    
    if condMatrix(t)==0  %0==symvbols 1==fingers
        
        actual_present{t,1} = printsymbols_l1{t};
        
    else
        
        actual_present{t,1} = printfingers_l1{t};
        
    end
    
end
        
        
    
    








