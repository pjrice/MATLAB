%maze paradigm for Gire lab

clear

% %filename?
% filename = 'C:\temp_patrick\data\';
% filename_append = input('Filename? ','s');
% filename = strcat(filename,filename_append);
% 
% %base path for images?
% % imgbasepath = 'C:\temp_patrick\RP_images\';
% % imgbasepath = 'P:\data\DRI\RP_images\';
imgbasepath = 'Z:\Work\UW\projects\MAZE\arrows\';

%which hand are we working with?
% hand = input('Which hand are we working with? 0 for left, 1 for right: ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % Open connection with TDT and begin program
% DA = actxcontrol('TDevAcc.X');
% 
% %initiates a connection with an OpenWorkbench server. The connection adds a client to the server
% DA.ConnectServer('Local');
% 
% %throws error if there was a problem connecting
% if DA.CheckServerConnection==0
%     error('Client application not connect to server')
% end
% 
% % DA.SetTankName('GIVEMETHEPATH');
% 
% tdt_datafile = DA.GetTankName;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Setup PTB with some default values
PsychDefaultSetup(2);

%give praise to rngesus and show our faith by seeding
%may not be used but what the hey
rng('shuffle')

%set screen num to secondary monitor if one is connected
screenNumber = max(Screen('Screens'));
% screenNumber = 1;  %weirdness with how tms task computer assigns window numbers

%define black, white and grey
white = WhiteIndex(screenNumber);
grey = white/2;
black = BlackIndex(screenNumber);
red = [1 0 0];

%Open the screen
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black, [], 32, 2);

%Flip to clear
Screen('Flip', window);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

%Query frame duration
ifi = Screen('GetFlipInterval', window);

%Set text size and font
Screen('TextSize', window, 60);
Screen('TextFont', window, 'Ariel');

%Query max priority level
topPriorityLevel = MaxPriority(window);

%Get center coordinates of window
[xcenter, ycenter] = RectCenter(windowRect);

%Set blend function for the screen
Screen('BlendFunction',window,'GL_SRC_ALPHA','GL_ONE_MINUS_SRC_ALPHA');

HideCursor

%load images
arrows.left.imgloc = strcat(imgbasepath,'left.png');
arrows.up.imgloc = strcat(imgbasepath,'up.png');
arrows.right.imgloc = strcat(imgbasepath,'right.png');
arrows.rleft.imgloc = strcat(imgbasepath,'left_red.png');
arrows.rup.imgloc = strcat(imgbasepath,'up_red.png');
arrows.rright.imgloc = strcat(imgbasepath,'right_red.png');

arrows.left.img = imread(arrows.left.imgloc);
arrows.up.img = imread(arrows.up.imgloc);
arrows.right.img = imread(arrows.right.imgloc);
arrows.rleft.img = imread(arrows.rleft.imgloc);
arrows.rup.img = imread(arrows.rup.imgloc);
arrows.rright.img = imread(arrows.rright.imgloc);

%make images into textures
arrows.left.texture = Screen('MakeTexture',window,arrows.left.img);
arrows.up.texture = Screen('MakeTexture',window,arrows.up.img);
arrows.right.texture = Screen('MakeTexture',window,arrows.right.img);
arrows.rleft.texture = Screen('MakeTexture',window,arrows.rleft.img);
arrows.rup.texture = Screen('MakeTexture',window,arrows.rup.img);
arrows.rright.texture = Screen('MakeTexture',window,arrows.rright.img);

% Get the size of the image (all should be same size)
[s1, s2, s3] = size(arrows.left.img);

%define the destination rectangle for the images
dstRect = [0 0 s1 s2];
updstRect = CenterRectOnPointd(dstRect, xCenter, yCenter*0.25);
leftdstRect = CenterRectOnPointd(dstRect, xCenter*0.25, yCenter);
rightdstRect = CenterRectOnPointd(dstRect, xCenter*1.75, yCenter);

% Here we check if the image is too big to fit on the screen and abort if
% it is
if s1 > screenYpixels || s2 > screenYpixels
    disp('ERROR! Image is too big to fit on the screen');
    sca;
    return;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----------------------------------------------------------------------
%                       Trial information
%----------------------------------------------------------------------

% numtrials = 30;
% numblocks = 2;
numtrials = 2;
numblocks = 2;

%init data matrices
timestamps = nan(numtrials,4,numblocks); %|trial start|disp of "Enter"|resp to enter|trial stop|
stepper_ts = cell(numtrials,100,2,numblocks); %third dimension: 1st: display of just entered room; 2nd: resp to proceed
subj_resp = cell(numtrials,100,numblocks);
progression = nan(numtrials,100,numblocks);
gold_progression = nan(numtrials,100,numblocks);
facing_mem = cell(numtrials,100,numblocks);

%build the maze
room_nums = flipud(rot90(reshape([1:36],6,6)));  %assign numbers to rooms
[roomrows,roomcols] = size(room_nums);
foyer = 34;  %room you are looking at at start
[a,b] = find(room_nums==foyer);

%gain/loss values
gainvalues = [1 1 1 5 5 5 10 10 10 25 25 25 50 50 50 100 100 100];
lossvalues = gainvalues*-1;

%hardcode gain/loss values to room numbers for solvable condition (aka
%create an optimal path through the maze)
actual_path_gvals = [1 5 1 10 5 50 25 10 100 50 5 25 10 1 25 100 50 100]; %from entrance, this is the order of gains
actual_path_grooms = [34 35 36 30 29 23 17 18 12 6 5 4 10 9 15 14 13 7];
actual_path = [actual_path_grooms',actual_path_gvals'];

loss_rooms = room_nums(find(ismember(room_nums,actual_path_grooms)==0));
loss_values = [-1 -100 -5 -50 -25 -50 -10 -25 -5 -100 -5 -10 -1 -25 -50 -1 -10 -100];
loss_path = [loss_rooms,loss_values'];

%make randomized gain/loss room assignments for each trial in random condition
values = sort(cat(2,gainvalues,lossvalues));
rooms = [1:36];
ran_room_vals = cell(numtrials,1);

for i = 1:numtrials
    
    ran_room_vals{i,1} = Shuffle([rooms',values']);
    
end


%give the subject some money to start with so that losing some isn't as bad
%sum(gainvalues) = 573, so 600 is enough that we never finish with neg
%done in task loop to reinit starting gold per trial


%----------------------------------------------------------------------
%                       Timing Information
%----------------------------------------------------------------------

%hold time, rule presentation, ISD, and stimulus presentation time in seconds and frames

%hold time
holdTimeSecs = 1.5;
holdTimeFrames = round(holdTimeSecs/ifi);

%maximum maze presentation length
spTimeSecs = 10;
spTimeFrames = round(spTimeSecs/ifi);

%number of frames to present room transition
transition_frames = 30;

%Number of frames to wait before re-drawing
waitframes = 1;

%----------------------------------------------------------------------
%                       Keyboard information
%----------------------------------------------------------------------

%Defined keyboard keys that are listened for.

% keychoices = ['A' 'L'];

escapeKey = KbName('ESCAPE');

% lKey = KbName('LeftArrow');  %choose the left door
% fKey = KbName('UpArrow');  %choose the door directly ahead (f for forward)
% rKey = KbName('RightArrow');  %choose the right door

%----------------------------------------------------------------------
%                       Task Loop
%----------------------------------------------------------------------

%wait until recording has started
DrawFormattedText(window, 'Please wait',...
    'center', 'center', white);
Screen('Flip', window);

%if OpenWorkbench is not in Record mode, then this will set it to record
%then stores the time of recording start relative to the rest of the events
%that occur
% if DA.GetSysMode ~= 3
%     
%     DA.SetSysMode(3);
%     
%     while DA.GetSysMode ~= 3
%         pause(.1)
%     end
%     
%     TDT_recording_start = GetSecs;
%     
% %     % Disarm the stim - MAY NOT NEED TO DO THIS!
% %     DA.SetTargetVal('RZ5D.ArmSystem', 0);
% 
% end

%Instructions
DrawFormattedText(window, 'You will be given thirty seconds to \n\n navigate a maze filled with \n\n gold. The objective is to \n\n collect as much gold as possible \n\n in the allotted time. \n\n Press any key to continue.',...
    'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;

DrawFormattedText(window, 'All rooms are square. \n\n Some rooms will gain you gold, \n\n and some rooms will lose you gold.  \n\n Press any key to continue.',...
    'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;

DrawFormattedText(window, 'An arrow indicates that you can choose \n\n to progess into that room. \n\n Left arrows are rooms to your left; \n\n right arrows are rooms to your right; \n\n upwards arrows are rooms directly in front of you. \n\n Press any key to continue.',...
    'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;

DrawFormattedText(window, 'A helpful hint: \n\n Your perspective is such that the door \n\n you just went through is always at your back. \n\n Press any key to begin!',...
    'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;


% %present until subject is ready; press any key to continue
% DrawFormattedText(window, 'Press any key to begin',...
%     'center', 'center', white);
% Screen('Flip', window);
% KbStrokeWait;

% %present first frame of entrance room here
% Screen('DrawTexture',window,arrows.left.texture,[],leftdstRect,0);
% Screen('DrawTexture',window,arrows.up.texture,[],updstRect,0);
% Screen('DrawTexture',window,arrows.right.texture,[],rightdstRect,0);
% Screen('Flip',window);
% 
% pause(3)
% 
% ShowCursor;
% sca;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%try a couple of different timestamping methods
streamstart_time = GetSecs;
tic

for block = 1:numblocks
    
    if block == 1
    
        for trial = 1:numtrials
            
            %timestamp trial start
            timestamps(trial,1,block) = GetSecs;
            
            %reinit for trial>1
            respToBeMade = true;
            facing = 'up';  %direction you are facing (from topdown observer) at start
            facing_mem{trial,1,block} = facing;
            spTimeFramescheck = 1;
            current_gold = 600;
            gold_progression(trial,1,block) = current_gold;
            
            %present until subject is ready; press any key to continue
            DrawFormattedText(window, sprintf('Enter the dungeon when you are ready! \n You currently have %d gold.',current_gold),...
                'center', 'center', white);
            Screen('DrawTexture',window,arrows.up.texture,[],updstRect,0);
            fKey = KbName('UpArrow');  %choose the door directly ahead (f for forward)
            [timestamps(trial,2,block),~,~,~,~] = Screen('Flip', window);
            
            while respToBeMade == true
                
                [keyIsDown,secs, keyCode] = KbCheck;
                if keyCode(escapeKey)
                    subj_resp{trial,1,block} = 'E';
                    ShowCursor;
                    sca;
                    return
                elseif keyCode(fKey)
                    subj_resp{trial,1,block} = 'F';
                    timestamps(trial,3,block) = secs;
                    respToBeMade = false;
                    roomnum = foyer;
                    for frame = 1:transition_frames
                        Screen('DrawTexture',window,arrows.rup.texture,[],updstRect,0);
                        Screen('Flip',window);
                    end
                end
            end
            
            while spTimeFramescheck < spTimeFrames
                
                for stepper = 2:size(progression,2)
                    
                    if spTimeFramescheck >= spTimeFrames
                        break
                    end
                    
                    %init these as silenced (5 is unused in keyboard
                    %assignment)
                    %only enable arrow keys if arrow is displayed (a bit later)
                    lKey = 5;  %choose the left door
                    fKey = 5;  %choose the door directly ahead (f for forward)
                    rKey = 5;  %choose the right door
                    
                    %get the current room and store the progression
                    if stepper ~= 2
                        roomnum = room_nums(a,b);
                        progression(trial,stepper,block) = roomnum;
                    elseif stepper==2
                        progression(trial,stepper,block) = roomnum;
                    end
                    
%                     roomnum = room_nums(a,b);
%                     progression(trial,stepper,block) = roomnum;
                    facing_mem{trial,stepper,block} = facing;
                    
                    %get gain/loss of room and value to print
                    if ~isempty(find(actual_path(:,1)==roomnum))
                        
                        word = 'gain';
                        gainloss = actual_path(find(actual_path(:,1)==roomnum),2);
                        current_gold = current_gold + actual_path(find(actual_path(:,1)==roomnum),2);
                        gold_progression(trial,stepper,block) = current_gold;
                    else
                        
                        word = 'lost';
                        gainloss = loss_path(find(loss_path(:,1)==roomnum),2);
                        current_gold = current_gold + loss_path(find(loss_path(:,1)==roomnum),2);
                        gold_progression(trial,stepper,block) = current_gold;
                    end
                    
                    %search for rooms around us
                    [r,c] = find(roomnum==room_nums);
                    switch facing
                        case 'left'
                            r1 = r+1;
                            c1 = c;
                            
                            r2 = r;
                            c2 = c-1;
                            
                            r3 = r-1;
                            c3 = c;
                        case 'up'
                            r1 = r;
                            c1 = c-1;
                            
                            r2 = r-1;
                            c2 = c;
                            
                            r3 = r;
                            c3 = c+1;
                        case 'right'
                            r1 = r-1;
                            c1 = c;
                            
                            r2 = r;
                            c2 = c+1;
                            
                            r3 = r+1;
                            c3 = c;
                        case 'down'
                            r1 = r;
                            c1 = c+1;
                            
                            r2 = r+1;
                            c2 = c;
                            
                            r3 = r;
                            c3 = c-1;
                    end
                    
                    
                    %Cue to determine whether a response has been made
                    respToBeMade = true;
                    
                    %present first frame of entrance room here, get timestamp of
                    %presentation
                    %only present arrow if the room it leads to actually exists
                    %only enable arrow keys if arrow is displayed
                    if r1 >= 1 && r1 <= roomrows && c1 >= 1 && c1 <= roomcols
                        Screen('DrawTexture',window,arrows.left.texture,[],leftdstRect,0);
                        lKey = KbName('LeftArrow');  %choose the left door
                    end
                    if r2 >= 1 && r2 <= roomrows && c2 >= 1 && c2 <= roomcols
                        Screen('DrawTexture',window,arrows.up.texture,[],updstRect,0);
                        fKey = KbName('UpArrow');  %choose the door directly ahead (f for forward)
                    end
                    if r3 >= 1 && r3 <= roomrows && c3 >= 1 && c3 <= roomcols
                        Screen('DrawTexture',window,arrows.right.texture,[],rightdstRect,0);
                        rKey = KbName('RightArrow');  %choose the right door
                    end
                    if stepper==2 || isempty(find(progression(trial,1:stepper-1,block)==roomnum,1))
                        DrawFormattedText(window, sprintf('You %s %d gold! \n\n You currently have %d gold.',word,gainloss,current_gold),...
                            'center', 'center', white);
                    else
                        DrawFormattedText(window, 'You have been here before. \n\n There is no more gold to find here!',...
                            'center', 'center', white);
                    end
                    [stepper_ts{trial,stepper,1,block},~,~,~,~] = Screen('Flip',window); %timestamps initial display of room
                    
                    while respToBeMade == true && spTimeFramescheck < spTimeFrames
                        
                        [keyIsDown,secs, keyCode] = KbCheck;
                        if keyCode(escapeKey)
                            subj_resp{trial,stepper,block} = 'E';
                            ShowCursor;
                            sca;
                            return
                        elseif keyCode(lKey)
                            subj_resp{trial,stepper,block} = 'L';
                            stepper_ts{trial,stepper,2,block} = secs; %timestamps subject response
                            respToBeMade = false;
                            switch facing
                                case 'left'
                                    [a,b] = find(room_nums==roomnum+6);
                                    facing = 'down';
                                case 'up'
                                    [a,b] = find(room_nums==roomnum-1);
                                    facing = 'left';
                                case 'right'
                                    [a,b] = find(room_nums==roomnum-6);
                                    facing = 'up';
                                case 'down'
                                    [a,b] = find(room_nums==roomnum+1);
                                    facing = 'right';
                            end
                            for frame = 1:transition_frames
                                
                                if r1 >= 1 && r1 <= roomrows && c1 >= 1 && c1 <= roomcols
                                    Screen('DrawTexture',window,arrows.rleft.texture,[],leftdstRect,0);
                                end
                                if r2 >= 1 && r2 <= roomrows && c2 >= 1 && c2 <= roomcols
                                    Screen('DrawTexture',window,arrows.up.texture,[],updstRect,0);
                                end
                                if r3 >= 1 && r3 <= roomrows && c3 >= 1 && c3 <= roomcols
                                    Screen('DrawTexture',window,arrows.right.texture,[],rightdstRect,0);
                                end
                                Screen('Flip',window);
                                spTimeFramescheck = spTimeFramescheck+1;
                                
                            end
                        elseif keyCode(fKey)
                            subj_resp{trial,stepper,block} = 'F';
                            stepper_ts{trial,stepper,2,block} = secs; %timestamps subject response
                            respToBeMade = false;
                            switch facing  %facing stays the same in this case
                                case 'left'
                                    [a,b] = find(room_nums==roomnum-1);
                                case 'up'
                                    [a,b] = find(room_nums==roomnum-6);
                                case 'right'
                                    [a,b] = find(room_nums==roomnum+1);
                                case 'down'
                                    [a,b] = find(room_nums==roomnum+6);
                            end
                            for frame = 1:transition_frames
                                
                                if r1 >= 1 && r1 <= roomrows && c1 >= 1 && c1 <= roomcols
                                    Screen('DrawTexture',window,arrows.left.texture,[],leftdstRect,0);
                                end
                                if r2 >= 1 && r2 <= roomrows && c2 >= 1 && c2 <= roomcols
                                    Screen('DrawTexture',window,arrows.rup.texture,[],updstRect,0);
                                end
                                if r3 >= 1 && r3 <= roomrows && c3 >= 1 && c3 <= roomcols
                                    Screen('DrawTexture',window,arrows.right.texture,[],rightdstRect,0);
                                end
                                Screen('Flip',window);
                                spTimeFramescheck = spTimeFramescheck+1;
                                
                            end
                        elseif keyCode(rKey)
                            subj_resp{trial,stepper,block} = 'R';
                            stepper_ts{trial,stepper,2,block} = secs; %timestamps subject response
                            respToBeMade = false;
                            switch facing
                                case 'left'
                                    [a,b] = find(room_nums==roomnum-6);
                                    facing = 'up';
                                case 'up'
                                    [a,b] = find(room_nums==roomnum+1);
                                    facing = 'right';
                                case 'right'
                                    [a,b] = find(room_nums==roomnum+6);
                                    facing = 'down';
                                case 'down'
                                    [a,b] = find(room_nums==roomnum-1);
                                    facing = 'left';
                            end
                            for frame = 1:transition_frames
                                
                                if r1 >= 1 && r1 <= roomrows && c1 >= 1 && c1 <= roomcols
                                    Screen('DrawTexture',window,arrows.left.texture,[],leftdstRect,0);
                                end
                                if r2 >= 1 && r2 <= roomrows && c2 >= 1 && c2 <= roomcols
                                    Screen('DrawTexture',window,arrows.up.texture,[],updstRect,0);
                                end
                                if r3 >= 1 && r3 <= roomrows && c3 >= 1 && c3 <= roomcols
                                    Screen('DrawTexture',window,arrows.rright.texture,[],rightdstRect,0);
                                end
                                Screen('Flip',window);
                                spTimeFramescheck = spTimeFramescheck+1;
                                
                            end
                        end
                        
                        %doing this forces the while loop to tick at the
                        %refresh rate of the monitor
                        if r1 >= 1 && r1 <= roomrows && c1 >= 1 && c1 <= roomcols
                            Screen('DrawTexture',window,arrows.left.texture,[],leftdstRect,0);
                        end
                        if r2 >= 1 && r2 <= roomrows && c2 >= 1 && c2 <= roomcols
                            Screen('DrawTexture',window,arrows.up.texture,[],updstRect,0);
                        end
                        if r3 >= 1 && r3 <= roomrows && c3 >= 1 && c3 <= roomcols
                            Screen('DrawTexture',window,arrows.right.texture,[],rightdstRect,0);
                        end
                        if  stepper==2 || isempty(find(progression(trial,1:stepper-1,block)==roomnum,1))
                            DrawFormattedText(window, sprintf('You %s %d gold! \n\n You currently have %d gold.',word,gainloss,current_gold),...
                                'center', 'center', white);
                        else
                            DrawFormattedText(window, 'You have been here before! \n\n There is no more gold to find here!',...
                                'center', 'center', white);
                        end
                        Screen('Flip',window);
                        
                        spTimeFramescheck = spTimeFramescheck+1;
                        
                    end
                    
                end
                
            end
            timestamps(trial,4,block) = GetSecs;
            if trial ~= numtrials
                for s = [5 4 3 2 1]
                    
                    for f = 1:60
                        
                        DrawFormattedText(window,sprintf('Next trial beginning in: \n %d \n\n You earned %d gold this run!',s,current_gold),'center','center',white);
                        Screen('Flip',window);
                        
                    end
                end
            else
                for s = [5 4 3 2 1]
                    
                    for f = 1:60
                        
                        DrawFormattedText(window,sprintf('This was the last run of this block! \n\n You earned %d gold this run!',s,current_gold),'center','center',white);
                        Screen('Flip',window);
                        
                    end
                end
            end
        end
    
    elseif block ==2
        
        for trial = 1:numtrials
            
            %timestamp trial start
            timestamps(trial,1,block) = GetSecs;
            
            %reinit for trial>1
            respToBeMade = true;
            facing = 'up';  %direction you are facing (from topdown observer) at start
            facing_mem{trial,1,block} = facing;
            spTimeFramescheck = 1;
            current_gold = 600;
            gold_progression(trial,1,block) = current_gold;
            
            %present until subject is ready; press any key to continue
            DrawFormattedText(window, sprintf('Enter the dungeon when you are ready! \n You currently have %d gold.',current_gold),...
                'center', 'center', white);
            Screen('DrawTexture',window,arrows.up.texture,[],updstRect,0);
            fKey = KbName('UpArrow');  %choose the door directly ahead (f for forward)
            [timestamps(trial,2,block),~,~,~,~] = Screen('Flip', window);
            
            while respToBeMade == true
                
                [keyIsDown,secs, keyCode] = KbCheck;
                if keyCode(escapeKey)
                    subj_resp{trial,1,block} = 'E';
                    ShowCursor;
                    sca;
                    return
                elseif keyCode(fKey)
                    subj_resp{trial,1,block} = 'F';
                    timestamps(trial,3,block) = secs;
                    respToBeMade = false;
                    roomnum = foyer;
                    for frame = 1:transition_frames
                        Screen('DrawTexture',window,arrows.rup.texture,[],updstRect,0);
                        Screen('Flip',window);
                    end
                end
            end
            
            while spTimeFramescheck < spTimeFrames
                
                for stepper = 2:size(progression,2)
                    
                    if spTimeFramescheck >= spTimeFrames
                        break
                    end
                    
                    %init these as silenced (5 is unused in keyboard
                    %assignment)
                    %only enable arrow keys if arrow is displayed (a bit later)
                    lKey = 5;  %choose the left door
                    fKey = 5;  %choose the door directly ahead (f for forward)
                    rKey = 5;  %choose the right door
                    
                    %get the current room and store the progression
                    if stepper ~= 2
                        roomnum = room_nums(a,b);
                        progression(trial,stepper,block) = roomnum;
                    elseif stepper==2
                        progression(trial,stepper,block) = roomnum;
                    end
                    
%                     roomnum = room_nums(a,b);
%                     progression(trial,stepper,block) = roomnum;
                    facing_mem{trial,stepper,block} = facing;
                    
                    %get gain/loss of room and value to print
                    if sign(ran_room_vals{trial,1}(find(ran_room_vals{trial,1}(:,1)==roomnum),2))==1 %#ok<*FNDSB>
                        
                        word = 'gain';
                        gainloss = ran_room_vals{trial,1}(find(ran_room_vals{trial,1}(:,1)==roomnum),2);
                        current_gold = current_gold + gainloss;
                        gold_progression(trial,stepper,block) = current_gold;
                        
                    elseif sign(ran_room_vals{trial,1}(find(ran_room_vals{trial,1}(:,1)==roomnum),2))==-1
                        
                        word = 'lost';
                        gainloss = ran_room_vals{trial,1}(find(ran_room_vals{trial,1}(:,1)==roomnum),2);
                        current_gold = current_gold + gainloss;
                        gold_progression(trial,stepper,block) = current_gold;
                        
                    end
                    
                    %search for rooms around us
                    [r,c] = find(roomnum==room_nums);
                    switch facing
                        case 'left'
                            r1 = r+1;
                            c1 = c;
                            
                            r2 = r;
                            c2 = c-1;
                            
                            r3 = r-1;
                            c3 = c;
                        case 'up'
                            r1 = r;
                            c1 = c-1;
                            
                            r2 = r-1;
                            c2 = c;
                            
                            r3 = r;
                            c3 = c+1;
                        case 'right'
                            r1 = r-1;
                            c1 = c;
                            
                            r2 = r;
                            c2 = c+1;
                            
                            r3 = r+1;
                            c3 = c;
                        case 'down'
                            r1 = r;
                            c1 = c+1;
                            
                            r2 = r+1;
                            c2 = c;
                            
                            r3 = r;
                            c3 = c-1;
                    end
                    
                    
                    %Cue to determine whether a response has been made
                    respToBeMade = true;
                    
                    %present first frame of entrance room here, get timestamp of
                    %presentation
                    %only present arrow if the room it leads to actually exists
                    %only enable arrow keys if arrow is displayed
                    if r1 >= 1 && r1 <= roomrows && c1 >= 1 && c1 <= roomcols
                        Screen('DrawTexture',window,arrows.left.texture,[],leftdstRect,0);
                        lKey = KbName('LeftArrow');  %choose the left door
                    end
                    if r2 >= 1 && r2 <= roomrows && c2 >= 1 && c2 <= roomcols
                        Screen('DrawTexture',window,arrows.up.texture,[],updstRect,0);
                        fKey = KbName('UpArrow');  %choose the door directly ahead (f for forward)
                    end
                    if r3 >= 1 && r3 <= roomrows && c3 >= 1 && c3 <= roomcols
                        Screen('DrawTexture',window,arrows.right.texture,[],rightdstRect,0);
                        rKey = KbName('RightArrow');  %choose the right door
                    end
                    if stepper==2 || isempty(find(progression(trial,1:stepper-1,block)==roomnum,1))
                        DrawFormattedText(window, sprintf('You %s %d gold! \n\n You currently have %d gold.',word,gainloss,current_gold),...
                            'center', 'center', white);
                    else
                        DrawFormattedText(window, 'You have been here before. \n\n There is no more gold to find here!',...
                            'center', 'center', white);
                    end
                    [stepper_ts{trial,stepper,1,block},~,~,~,~] = Screen('Flip',window); %timestamps initial display of room
                    
                    while respToBeMade == true && spTimeFramescheck < spTimeFrames
                        
                        [keyIsDown,secs, keyCode] = KbCheck;
                        if keyCode(escapeKey)
                            subj_resp{trial,stepper,block} = 'E';
                            ShowCursor;
                            sca;
                            return
                        elseif keyCode(lKey)
                            subj_resp{trial,stepper,block} = 'L';
                            stepper_ts{trial,stepper,2,block} = secs; %timestamps subject response
                            respToBeMade = false;
                            switch facing
                                case 'left'
                                    [a,b] = find(room_nums==roomnum+6);
                                    facing = 'down';
                                case 'up'
                                    [a,b] = find(room_nums==roomnum-1);
                                    facing = 'left';
                                case 'right'
                                    [a,b] = find(room_nums==roomnum-6);
                                    facing = 'up';
                                case 'down'
                                    [a,b] = find(room_nums==roomnum+1);
                                    facing = 'right';
                            end
                            for frame = 1:transition_frames
                                
                                if r1 >= 1 && r1 <= roomrows && c1 >= 1 && c1 <= roomcols
                                    Screen('DrawTexture',window,arrows.rleft.texture,[],leftdstRect,0);
                                end
                                if r2 >= 1 && r2 <= roomrows && c2 >= 1 && c2 <= roomcols
                                    Screen('DrawTexture',window,arrows.up.texture,[],updstRect,0);
                                end
                                if r3 >= 1 && r3 <= roomrows && c3 >= 1 && c3 <= roomcols
                                    Screen('DrawTexture',window,arrows.right.texture,[],rightdstRect,0);
                                end
                                Screen('Flip',window);
                                spTimeFramescheck = spTimeFramescheck+1;
                                
                            end
                        elseif keyCode(fKey)
                            subj_resp{trial,stepper,block} = 'F';
                            stepper_ts{trial,stepper,2,block} = secs; %timestamps subject response
                            respToBeMade = false;
                            switch facing  %facing stays the same in this case
                                case 'left'
                                    [a,b] = find(room_nums==roomnum-1);
                                case 'up'
                                    [a,b] = find(room_nums==roomnum-6);
                                case 'right'
                                    [a,b] = find(room_nums==roomnum+1);
                                case 'down'
                                    [a,b] = find(room_nums==roomnum+6);
                            end
                            for frame = 1:transition_frames
                                
                                if r1 >= 1 && r1 <= roomrows && c1 >= 1 && c1 <= roomcols
                                    Screen('DrawTexture',window,arrows.left.texture,[],leftdstRect,0);
                                end
                                if r2 >= 1 && r2 <= roomrows && c2 >= 1 && c2 <= roomcols
                                    Screen('DrawTexture',window,arrows.rup.texture,[],updstRect,0);
                                end
                                if r3 >= 1 && r3 <= roomrows && c3 >= 1 && c3 <= roomcols
                                    Screen('DrawTexture',window,arrows.right.texture,[],rightdstRect,0);
                                end
                                Screen('Flip',window);
                                spTimeFramescheck = spTimeFramescheck+1;
                                
                            end
                        elseif keyCode(rKey)
                            subj_resp{trial,stepper,block} = 'R';
                            stepper_ts{trial,stepper,2,block} = secs; %timestamps subject response
                            respToBeMade = false;
                            switch facing
                                case 'left'
                                    [a,b] = find(room_nums==roomnum-6);
                                    facing = 'up';
                                case 'up'
                                    [a,b] = find(room_nums==roomnum+1);
                                    facing = 'right';
                                case 'right'
                                    [a,b] = find(room_nums==roomnum+6);
                                    facing = 'down';
                                case 'down'
                                    [a,b] = find(room_nums==roomnum-1);
                                    facing = 'left';
                            end
                            for frame = 1:transition_frames
                                
                                if r1 >= 1 && r1 <= roomrows && c1 >= 1 && c1 <= roomcols
                                    Screen('DrawTexture',window,arrows.left.texture,[],leftdstRect,0);
                                end
                                if r2 >= 1 && r2 <= roomrows && c2 >= 1 && c2 <= roomcols
                                    Screen('DrawTexture',window,arrows.up.texture,[],updstRect,0);
                                end
                                if r3 >= 1 && r3 <= roomrows && c3 >= 1 && c3 <= roomcols
                                    Screen('DrawTexture',window,arrows.rright.texture,[],rightdstRect,0);
                                end
                                Screen('Flip',window);
                                spTimeFramescheck = spTimeFramescheck+1;
                                
                            end
                        end
                        
                        %doing this forces the while loop to tick at the
                        %refresh rate of the monitor
                        if r1 >= 1 && r1 <= roomrows && c1 >= 1 && c1 <= roomcols
                            Screen('DrawTexture',window,arrows.left.texture,[],leftdstRect,0);
                        end
                        if r2 >= 1 && r2 <= roomrows && c2 >= 1 && c2 <= roomcols
                            Screen('DrawTexture',window,arrows.up.texture,[],updstRect,0);
                        end
                        if r3 >= 1 && r3 <= roomrows && c3 >= 1 && c3 <= roomcols
                            Screen('DrawTexture',window,arrows.right.texture,[],rightdstRect,0);
                        end
                        if  stepper==2 || isempty(find(progression(trial,1:stepper-1,block)==roomnum,1))
                            DrawFormattedText(window, sprintf('You %s %d gold! \n\n You currently have %d gold.',word,gainloss,current_gold),...
                                'center', 'center', white);
                        else
                            DrawFormattedText(window, 'You have been here before! \n\n There is no more gold to find here!',...
                                'center', 'center', white);
                        end
                        Screen('Flip',window);
                        
                        spTimeFramescheck = spTimeFramescheck+1;
                        
                    end
                    
                end
                
            end
            timestamps(trial,4,block) = GetSecs;
            
            if trial ~= numtrials
                for s = [5 4 3 2 1]
                    
                    for f = 1:60
                        
                        DrawFormattedText(window,sprintf('Next trial beginning in: \n %d \n\n You earned %d gold this run!',s,current_gold),'center','center',white);
                        Screen('Flip',window);
                        
                    end
                end
            else
                for s = [5 4 3 2 1]
                    
                    for f = 1:60
                        
                        DrawFormattedText(window,sprintf('This was the last run! \n\n You earned %d gold this run!',s,current_gold),'center','center',white);
                        Screen('Flip',window);
                        
                    end
                end
            end
            
        end
    end   
end


DrawFormattedText(window, 'Thanks for playing!',...
    'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;

ShowCursor;
sca;

save(filename)
        
        
        

        


