

andrea_data = indices_all;
andrea_data(:,5) = errors_all;
andrea_data(:,6) = ruleRT_all;
andrea_data(:,7) = stimRT_all;

track = 0;
for w = 1:s
    
    sub_num(1+track:240+track) = w;
    
    track = track+240;
    
end

andrea_data(:,8) = sub_num;

csvwrite('andrea_data.csv',andrea_data)