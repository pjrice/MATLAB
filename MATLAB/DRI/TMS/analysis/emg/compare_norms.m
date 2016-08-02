

for b = 1:4
    
    for t = 1:60
        
        h1 = subplot(4,1,1);
        plot(emg_temp1{t,b,1})
        
        h2 = subplot(4,1,2);
        plot(emg_shitty{t,b,1})
        
        h3 = subplot(4,1,3);
        plot(emg_stdnorm{t,b,1})
        
        h4 = subplot(4,1,4);
        plot(emg_mmnorm{t,b,1})
        h4.YLim = [-0.5 0.5];
        
        waitforbuttonpress
        
    end
end

b=2;
