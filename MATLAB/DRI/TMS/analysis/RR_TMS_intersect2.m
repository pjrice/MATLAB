function c1234 = RR_TMS_intersect2(cond1,cond2,cond3,cond4)

%just intersect each page to eventually get fully intersected indices
track=1;
for c1 = 1:size(cond1,3)
    
    for c2 = 1:size(cond2,3)
        
        c12{track,1} = cellfun(@(x,y) intersect(x,y), cond1(:,:,c1), cond2(:,:,c2), 'UniformOutput', false);
        
        track = track+1;
        
    end
end

track=1;
for c12i = 1:size(c12,1)  
    
    for c3 = 1:size(cond3,3)
        
        c123{track,1} = cellfun(@(x,y) intersect(x,y), cond3(:,:,c3), c12{c12i,1}, 'UniformOutput', false);
        
        track = track+1;
    end
end


%c1234: columns are inferred/instructed
%rows:
%1. S-P-E
%2. S-P-L
%3. S-P-N
%4. S-V-E
%5. S-V-L
%6. S-V-N
%7. F-P-E
%8. F-P-L
%9. F-P-N
%10. F-V-E
%11. F-V-L
%12. F-V-N
for c4 = 1:size(cond4,3)
    
    for c123i = 1:size(c123,1)
        
        c1234{c123i,c4} = cellfun(@(x,y) intersect(x,y), cond4(:,:,c4),c123{c123i,1}, 'UniformOutput', false);
        
    end
end