for t = 1:size(emg,2)
    
    for tt = 1:length(emg)
        
        index1 = find(emg{tt,t}(1:2:end)==0);
        index2 = find(emg{tt,t}(2:2:end)==0);
        
        if index1(end)-index1(1) == length(index1)-1
            
            emg_proc{tt,t}(:,1) = emg{tt,t}(1,1:index1(1)-1); %indexing is in halved vectors but you are trying to pull from the full vector
            emg_proc{tt,t}(:,2) = emg{tt,t}(1,1:index2(1)-1);
            
        end
    end
end


%splice zeros off of vectors first, then reference channels out? Not bad
            
            %channels_temp(t,1:index(1)-1,1);
%         emg_proc{tt,t}(:,1) = emg{tt,t}(1:2:end);
%         emg_proc{tt,t}(:,2) = emg{tt,t}(2:2:end);


tester = find(emg{1,1}==0);

index(end)-index(1) == length(index)-1


%this is the good shit right here boy
indices = cellfun(@(x) find(x==0), emg, 'UniformOutput', false);
for t = 1:size(emg,2)
    
    for tt = 1:length(emg)
        
        if indices{tt,t}(end)-indices{tt,t}(1) == length(indices{tt,t})-1
            
            emg_temp{tt,t} = emg{tt,t}(1,1:indices{tt,t}(1)-1);
            
        else
            
            sprintf('Error! Some real values==0 for trial %d!', tt)
            
        end
        
        emg_proc{tt,t}(1,:) = emg_temp{tt,t}(1:2:end)-mean(emg_temp{tt,t}(1:2:end));
        emg_proc{tt,t}(2,:) = emg_temp{tt,t}(2:2:end)-mean(emg_temp{tt,t}(2:2:end));
    end
end

%for concatenated data (aka multiple subjects)
indices = cellfun(@(x) find(x==0), emg_cat, 'UniformOutput', false);
for t = 1:size(emg_cat,2)
    
    for tt = 1:length(emg_cat)
        
        if indices{tt,t,f}(end)-indices{tt,t,f}(1) == length(indices{tt,t,f})-1
            
            emg_temp{tt,t,f} = emg_cat{tt,t,f}(1,1:indices{tt,t,f}(1)-1);
            
        else
            
            sprintf('Error! Some real values==0 for trial %d!', tt)
            
        end
        
        emg_proc{tt,t,f}(1,:) = emg_temp{tt,t,f}(1:2:end)-mean(emg_temp{tt,t,f}(1:2:end));
        emg_proc{tt,t,f}(2,:) = emg_temp{tt,t,f}(2:2:end)-mean(emg_temp{tt,t,f}(2:2:end));
    end
end        
        
        
        
        
        
        
        
        
        
