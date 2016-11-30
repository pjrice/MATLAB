function RR_TMS_3dbarplot(cond1,cond2,RTs,err_trial_idx,a)

%cond1, cond2, and err_trial idx assumed to be block X subject cells
%containing column vectors of trial condition indexes (in the case of
%cond1/2) or error trials (in the case of err_trial_idx; 1==success trial)
%a is the switch to plot either the error trials(0) or success trials (1)

% Argument management:
% arg5 is optional, assumes to plot success trials
% arg1/2/3/4 are mandatory
if nargin < 5
    
    a = 1;  %plot success trials
    
end

%blank either error or success trials
%since 1 indexes successes in err_trial_idx input, invert to plot them
if a==1
    
    err_trial_idx = cellfun(@(x) not(x), err_trial_idx, 'UniformOutput',false);
        
end

%now NaN the indexed trials
for s = 1:size(cond1,2)  %by subjects
    
    for b = 1:size(cond1,1)  %by blocks
        
        RTs(err_trial_idx{b,s},b,s) = NaN;
        
    end
end

%get indexes of the joint conditions
%3rd dimension of c12: 1. c1-1 + c2-1; 2. c1-1 + c2-2; 3. c1-1 + c2-3; 4. c1-2 + c2-1...  
c12 = cell(size(cond1,1),size(cond1,2),(size(cond1,3)*size(cond2,3)));
track=1;
for c1 = 1:size(cond1,3)  %by the first condition
    
    for c2 = 1:size(cond2,3)  %by the second condition
        
        for s = 1:size(cond1,2)  %by subjects
            
            for b = 1:size(cond1,1)  %by blocks
                
                c12{b,s,track} = intersect(cond1{b,s,c1},cond2{b,s,c2});
               
            end
        end
        track = track+1;
    end
end

%get means for the conditions
RTs_bycond = cell(size(c12,3),1);
for c = 1:size(c12,3)  %by number of condition combos
    
    RT_vec = nan(sum(sum(cellfun(@length, c12(:,:,c)))),1);
    track=1;
    for s = 1:size(cond1,2)  %by subjects
        
        for b = 1:size(cond1,1)
            
            RT_ph = RTs(c12{b,s,c},b,s);
            
            RT_vec(track:(track+length(RT_ph)-1)) = RT_ph;
            
            track = track+length(RT_ph);
            
            clear RT_ph
            
        end 
    end
    
    RTs_bycond{c} = RT_vec;
    
    clear RT_vec track
    
end

RT_means = cellfun(@(x) mean(x,'omitnan'), RTs_bycond);
RT_means = reshape(RT_means,size(cond2,3),size(cond1,3));
RT_sems = cellfun(@(x) sem(x), RTs_bycond);
RT_sems = reshape(RT_sems,size(cond2,3),size(cond1,3));

h = bar3(RT_means);
% Set hold to on to be able to add the error bars without overwriting the image
hold on;
for i = 1:size(RT_means, 1)
    
    for j = 1:size(RT_means, 2)
        
        % Check if the standard deviation is larger than 0
        if RT_sems(i, j) > 0
            
            % First, draw a line
            % Set the x coordinates for the line
            X = [j, j];
            
            % Set the y coordinates for the line
            Y = [i, i];
            
            % The endpoint of the line
            z_end = RT_means(i, j) + RT_sems(i, j);
            
            
            % Set the z coordinates for the line
            Z = [RT_means(i,j), z_end];
            
            % Draw a solid black line according to its coordinates
            plot3(X, Y, Z, 'k-');
            
            % Optionally you can also draw an end marker
            % In our case it has a width of 0.4
            X = [j - 0.2, j + 0.2];
            
            % Finally, the Z coordinates (Y does not change)
            Z = [z_end, z_end];
            
            % Plot the end marker
            plot3(X,Y,Z,'k-');
            
        end
    end
end

%set zlim so it is equal across plots
h(1).Parent.ZLim = [0 2.5];

%Label z axis
h(1).Parent.ZLabel.String = 'RT';

%get labels for x/y axes
c1label = input('Label for the first condition? ','s');
c2label = input('Label for the second condition? ','s');

%get tick labels for x/y axes
c1ticklabels = input('Labels for the first condition? ex: {''symbol''; ''finger''} ');
c2ticklabels = input('Labels for the second condition? ex: {''symbol''; ''finger''} ');

%get title label
titlelabel = input('Title for the plot? ','s');


h(1).Parent.XLabel.String = c1label;
h(1).Parent.YLabel.String = c2label;
h(1).Parent.XTickLabel = c1ticklabels;
h(1).Parent.YTickLabel = c2ticklabels;
h(1).Parent.Title.String = titlelabel;

    
    
    

    
    


        
        
        

            
            
            
            
