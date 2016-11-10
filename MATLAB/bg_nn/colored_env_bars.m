%possible environments for BG-inspired models
%make this into a function! General env maker

env1 = rand(8,8);

b1 = bar3(env1);
colormap jet
colorbar
caxis([0 1])
zlim([0 1])

%following colors individual bars by height
numBars = size(env1,1);
numSets = size(env1,2);

for i = 1:numSets
    
    zdata = ones(6*numBars,4);
    
    k = 1;
    
    for j = 0:6:(6*numBars-6)
        
        zdata(j+1:j+6,:) = env1(k,i);
        
        k = k+1;
        
    end
    
    set(b1(i),'Cdata',zdata)
    
end

%get means
k = 1;
for i = 1:4:8
    
    j = 1;
    for ii = 1:4:8
        
        env1_2(k,j) = mean(mean(env1(i:i+3,ii:ii+3)));
        
        j = j+1;
        
    end
    k = k+1;
end

b2 = bar3(env1_2);

colormap jet
colorbar
caxis([0 1])
zlim([0 1])

%following colors individual bars by height
numBars = size(env1_2,1);
numSets = size(env1_2,2);

for i = 1:numSets
    
    zdata = ones(6*numBars,4);
    
    k = 1;
    
    for j = 0:6:(6*numBars-6)
        
        zdata(j+1:j+6,:) = env1_2(k,i);
        
        k = k+1;
        
    end
    
    set(b2(i),'Cdata',zdata)
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k = 1;
for i = 1:2:8
    
    j = 1;
    for ii = 1:2:8
        
        env1_3(k,j) = mean(mean(env1(i:i+1,ii:ii+1)));
        
        j = j+1;
        
    end
    k = k+1;
end

b3 = bar3(env1_3);

colormap jet
colorbar
caxis([0 1])
zlim([0 1])

%following colors individual bars by height
numBars = size(env1_3,1);
numSets = size(env1_3,2);

for i = 1:numSets
    
    zdata = ones(6*numBars,4);
    
    k = 1;
    
    for j = 0:6:(6*numBars-6)
        
        zdata(j+1:j+6,:) = env1_3(k,i);
        
        k = k+1;
        
    end
    
    set(b3(i),'Cdata',zdata)
    
end






















