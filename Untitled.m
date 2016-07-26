

for i = 1:length(data_cat)
    
    for ii = 1:4
        
        if length(data_cat{i,ii})==0
            
            data_cat{i,ii} = [];
            
        else
            
            data_cat{i,ii} = str2num(data_cat{i,ii});
            
        end
    end
end
    

for i = 1:length(data_cat)
    
    for ii = 1:4
        
        index(i,ii) = ~isempty(data_cat{i,ii});
        
    end
end

index1 = sum(index,2);
indices = find(index1==4);


