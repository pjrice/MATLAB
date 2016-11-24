function [c12,c13,c14,c23,c24,c34,c123,c124,c134,c234,c1234] = RR_TMS_intersect(cond1,cond2,cond3,cond4)

%function to find intersects of any four vectors containing index of trials
%in which that condition was active
%should spit out intersects of all combinations of 2, 3, and the global
%intersect of all 4
%handles matrices of trials X blocks X subjects

c12 = cell(size(cond1,2),size(cond1,3));
c13 = cell(size(cond1,2),size(cond1,3));
c14 = cell(size(cond1,2),size(cond1,3));
c23 = cell(size(cond1,2),size(cond1,3));
c24 = cell(size(cond1,2),size(cond1,3));
c34 = cell(size(cond1,2),size(cond1,3));

for s = 1:size(cond1,3)  %by subjects
    
    for b = 1:size(cond1,2)  %by blocks
        
        %pairs
        c12{b,s} = intersect(cond1(:,b,s),cond2(:,b,s));
        c13{b,s} = intersect(cond1(:,b,s),cond3(:,b,s));
        c14{b,s} = intersect(cond1(:,b,s),cond4(:,b,s));
        
        c23{b,s} = intersect(cond2(:,b,s),cond3(:,b,s));
        c24{b,s} = intersect(cond2(:,b,s),cond4(:,b,s));
        
        c34{b,s} = intersect(cond3(:,b,s),cond4(:,b,s));
        
    end
end

%triplets
c123 = cell(size(cond1,2),size(cond1,3));
c124 = cell(size(cond1,2),size(cond1,3));
c134 = cell(size(cond1,2),size(cond1,3));
c234 = cell(size(cond1,2),size(cond1,3));

for s = 1:size(cond1,3)  %by subjects
    
    for b = 1:size(cond1,2)  %by blocks
        
        c123{b,s} = intersect(c12{b,s},cond3(:,b,s));
        c124{b,s} = intersect(c12{b,s},cond4(:,b,s)); 
        c134{b,s} = intersect(c13{b,s},cond4(:,b,s));
        
        c234{b,s} = intersect(c23{b,s},cond4(:,b,s));
        
    end
end

%intersection of all four
c1234 = cell(size(cond1,2),size(cond1,3));

for s = 1:size(cond1,3)  %by subjects
    
    for b = 1:size(cond1,2)  %by blocks
        
        c1234{b,s} = intersect(c12{b,s},c34{b,s});
        
    end
end
