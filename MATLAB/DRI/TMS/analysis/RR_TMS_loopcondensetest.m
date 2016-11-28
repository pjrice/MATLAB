



evenodd = cell(size(data_cat,1),size(data_cat,3));

for s = 1:size(data_cat,3)
    
    for b = 1:size(data_cat,1)
        
        evenodd{b,s} = cell2mat(data_cat{b,2,s});
        evenodd{b,s}(:,2) = [];
        evenodd{b,s} = evenodd{b,s}-1; %0==Even; 1==Odd
        
    end
end

%data{1,6,1} for actual stimulus number
%do the mod trick to determine even/odd

evenodd_stim = cell(size(data_cat,1),size(data_cat,3));

for s = 1:size(data_cat,3)
    
    for b = 1:size(data_cat,1)
        
        evenodd_stim{b,s} = data_cat{b,6,s};
        evenodd_stim{b,s} = mod(evenodd_stim{b,s},2); %0==Even; 1==Odd
        
    end
end

finger = cell(size(data_cat,1),size(data_cat,3));

for s = 1:size(data_cat,3)
    
    for b = 1:size(data_cat,1)
        
        finger{b,s} = cell2mat(data_cat{b,3,s});
        finger{b,s}(:,2) = [];
        finger{b,s} = finger{b,s}-1; %0==Index; 1==Middle
        
    end
end

%determine whether A or B was displayed for symbol trials
symbol = cell(size(data_cat,1),size(data_cat,3));

for s = 1:size(data_cat,3)
    
    for b = 1:size(data_cat,1)
        
        symbol{b,s} = cell2mat(data_cat{b,4,s});
        symbol{b,s}(:,2) = [];
        symbol{b,s} = symbol{b,s}-1; %0==Index; 1==Middle
        
    end
end

%determine whether A was on left or right side
ab = cell(size(data_cat,1),size(data_cat,3));

for s = 1:size(data_cat,3)
    
    for b = 1:size(data_cat,1)
        
        ab{b,s} = cell2mat(data_cat{b,4,s});
        ab{b,s}(:,2) = [];
        ab{b,s} = ab{b,s}-1; %0==Index; 1==Middle
        
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

evenodd = cell(size(data_cat,1),size(data_cat,3));
evenodd_stim = cell(size(data_cat,1),size(data_cat,3));
finger = cell(size(data_cat,1),size(data_cat,3));
symbol = cell(size(data_cat,1),size(data_cat,3));
ab = cell(size(data_cat,1),size(data_cat,3));

for s = 1:size(data_cat,3)
    
    for b = 1:size(data_cat,1)
        
        evenodd{b,s} = cell2mat(data_cat{b,2,s});
        evenodd{b,s}(:,2) = [];
        evenodd{b,s} = evenodd{b,s}-1; %0==Even; 1==Odd
        
        evenodd_stim{b,s} = data_cat{b,6,s};
        evenodd_stim{b,s} = mod(evenodd_stim{b,s},2); %0==Even; 1==Odd
        
        finger{b,s} = cell2mat(data_cat{b,3,s});
        finger{b,s}(:,2) = [];
        finger{b,s} = finger{b,s}-1; %0==Index; 1==Middle
        
        symbol{b,s} = cell2mat(data_cat{b,4,s});
        symbol{b,s}(:,2) = [];
        symbol{b,s} = symbol{b,s}-1; %0==Index; 1==Middle
        
        ab{b,s} = cell2mat(data_cat{b,4,s});
        ab{b,s}(:,2) = [];
        ab{b,s} = ab{b,s}-1; %0==Index; 1==Middle
        
    end
end



































