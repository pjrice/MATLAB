%code to check post-hoc if there were any inter-TMSstim-intervals less than
%eight seconds in length - if so we have a problem

allstims = ts(:,3,:);

[i1 i2 i3] = find(~isnan(ts(:,7,:)));


track = 0;
for b = 1:4
    
    allstims(i1(1+track:20+track),:,b) = ts(i1(1+track:20+track),7,b);
    
    track = track+20;
    
end
    
stim_timing = diff(allstims);   

check = find(stim_timing<8);

if isempty(check)
    
    disp('It''s all good homie :)')
    
else
    
    disp('We have a fucking problem!')
    
end
