%fucking stupid

scores = cell(0);

%copy scores from csv now - names in scores{:,1}, quiz scores in
%scores{:,2}


%assumes quiz was out of 10 points, gets %
%this is a pointless step
for s = 1:length(scores)
    
    scores{s,3} = scores{s,2}/10;
    
end


%converts to 1-3 scale
for s = 1:length(scores)
    
    if isempty(scores{s,3})
        
        scores{s,4} = [];
        
    else
        
        if scores{s,3}<0.5
            
            scores{s,4} = 1;
            
        elseif scores{s,3}>=0.5 && scores{s,3}<0.8
            
            scores{s,4} = 2;
            
        elseif scores{s,3}>=0.8
            
            scores{s,4} = 3;
            
        end
    
    end
 
end

mean_raw = mean(cell2mat(scores(:,2)))
mean_adj = mean(cell2mat(scores(:,4)))

med_raw = median(cell2mat(scores(:,2)))
med_adj = median(cell2mat(scores(:,4)))

mode_raw = mode(cell2mat(scores(:,2)))
mode_adj = mode(cell2mat(scores(:,4)))

se_raw = std(cell2mat(scores(:,2)))/sqrt(length(cell2mat(scores(:,2))))
se_adj = std(cell2mat(scores(:,4)))/sqrt(length(cell2mat(scores(:,2))))

xcenter_raw = 0:10;
figure
hist(cell2mat(scores(:,2)),xcenter_raw)


xcenter_adj = 1:3;
figure
hist(cell2mat(scores(:,4)),xcenter_adj)




% filename = 'C:\Users\Patrick\OneDrive\Documents\2016\Winter Quarter\Psych355 (TA)\sessions\quiz2.mat';
% save(filename)