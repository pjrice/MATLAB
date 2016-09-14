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

% numtrials = 8;
numtrials = 1;
numblocks = 1;

%init data matrices
timestamps = nan(numtrials,5,numblocks);
subj_resp = cell(numtrials,numblocks);
progression = nan(1,100);

%build the maze
room_nums = flipud(rot90(reshape([1:36],6,6)));  %assign numbers to rooms
[roomrows,roomcols] = size(room_nums);
radial_rooms = [1:8];  %extra 8 rooms; [37:44]?
foyer = 32;  %room you start in
progression(1) = foyer;
[a,b] = find(room_nums==foyer);



%----------------------------------------------------------------------
%                       Timing Information
%----------------------------------------------------------------------

%hold time, rule presentation, ISD, and stimulus presentation time in seconds and frames

%hold time
holdTimeSecs = 1.5;
holdTimeFrames = round(holdTimeSecs/ifi);

%maximum maze presentation length
spTimeSecs = 30;
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

lKey = KbName('LeftArrow');  %choose the left door
fKey = KbName('UpArrow');  %choose the door directly ahead (f for forward)
rKey = KbName('RightArrow');  %choose the right door

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
DrawFormattedText(window, 'You will be given thirty seconds to \n\n navigate a maze filled with \n\n treasure. The objective is to \n\n collect as much treasure as possible \n\n in the allotted time. \n\n Press left arrow to go left, \n\n right arrow to go right, \n\n and up arrow to go straight. \n\n Good Luck!',...
    'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;

%present until subject is ready; press any key to continue
DrawFormattedText(window, 'Press any key to begin',...
    'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;

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
    
    for trial = 1:numtrials
        
        %timestamp trial start
        timestamps(trial,1,block) = GetSecs;
        
        roomnum = foyer;
        facing = 'up';  %direction you are facing (from topdown observer) at start
        spTimeFramescheck = 1;
        
        while spTimeFramescheck < spTimeFrames
        
            for step = 1:length(progression)
                
                %get the current room and store the progression
                if step ~= 1
                    roomnum = room_nums(a,b);
                    progression(step) = roomnum;
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
                whichButton = 0;
                
                %present first frame of entrance room here, get timestamp of
                %presentation
                if r1 >= 1 && r1 <= roomrows && c1 >= 1 && c1 <= roomcols
                    Screen('DrawTexture',window,arrows.left.texture,[],leftdstRect,0);
                end
                if r2 >= 1 && r2 <= roomrows && c2 >= 1 && c2 <= roomcols
                    Screen('DrawTexture',window,arrows.up.texture,[],updstRect,0);
                end
                if r3 >= 1 && r3 <= roomrows && c3 >= 1 && c3 <= roomcols
                    Screen('DrawTexture',window,arrows.right.texture,[],rightdstRect,0);
                end
                if step==1 || isempty(find(progression(1:step-1)==roomnum,1))
                    DrawFormattedText(window, 'You HAVE NOT been here before!',...
                        'center', 'center', white);
                else
                    DrawFormattedText(window, 'You have been here before!',...
                        'center', 'center', white);
                end
                [timestamps(trial,2,block),~,~,~,~] = Screen('Flip',window);
                
                while respToBeMade == true && spTimeFramescheck < spTimeFrames
                    
                    [keyIsDown,secs, keyCode] = KbCheck;
                    if keyCode(escapeKey)
                        subj_resp{trial,block}(step) = 'E';
                        ShowCursor;
                        sca;
                        return
                    elseif keyCode(lKey)
                        subj_resp{trial,block}(step) = 'L';
                        timestamps(trial,3,block) = secs;
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
                        subj_resp{trial,block}(step) = 'F';
                        timestamps(trial,3,block) = secs;
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
                        subj_resp{trial,block}(step) = 'R';
                        timestamps(trial,3,block) = secs;
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
                    if  step==1 || isempty(find(progression(1:step-1)==roomnum,1))
                        DrawFormattedText(window, 'You HAVE NOT been here before!',...
                            'center', 'center', white);
                    else
                        DrawFormattedText(window, 'You have been here before!',...
                            'center', 'center', white);
                    end
                    Screen('Flip',window);
                    
                    spTimeFramescheck = spTimeFramescheck+1;
                    
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
        
        
        

        

