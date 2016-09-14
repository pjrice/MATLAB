%maze paradigm for Gire lab

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

arrows.left.img = imread(arrows.left.imgloc);
arrows.up.img = imread(arrows.up.imgloc);
arrows.right.img = imread(arrows.right.imgloc);

%make images into textures
arrows.left.texture = Screen('MakeTexture',window,arrows.left.img);
arrows.up.texture = Screen('MakeTexture',window,arrows.up.img);
arrows.right.texture = Screen('MakeTexture',window,arrows.right.img);

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
numtrials = 2;
numblocks = 1;

%init data matrices
timestamps = nan(numtrials,5,numblocks);
subj_resp = cell(numtrials,numblocks);

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

%Number of frames to wait before re-drawing
waitframes = 1;

%----------------------------------------------------------------------
%                       Keyboard information
%----------------------------------------------------------------------

%Defined keyboard keys that are listened for.

% keychoices = ['A' 'L'];

escapeKey = KbName('ESCAPE');

lKey = KbName('LeftArrow');  %choose the left door
uKey = KbName('UpArrow');  %choose the door directly ahead
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
        
        spTimeFramescheck = 1;
        
        while spTimeFramescheck < spTimeFrames
        
            for room = 1:25  %5x5 room grid, 25 possible rooms
                
                %timestamp trial start
                timestamps(trial,1,block) = GetSecs;
                
                %Cue to determine whether a response has been made
                respToBeMade = true;
                whichButton = 0;
                
                %present first frame of entrance room here, get timestamp of
                %presentation
                Screen('DrawTexture',window,arrows.left.texture,[],leftdstRect,0);
                Screen('DrawTexture',window,arrows.up.texture,[],updstRect,0);
                Screen('DrawTexture',window,arrows.right.texture,[],rightdstRect,0);
                [timestamps(trial,2,block),~,~,~,~] = Screen('Flip',window);
                
                while respToBeMade == true && spTimeFramescheck < spTimeFrames
                    
                    [keyIsDown,secs, keyCode] = KbCheck;
                    if keyCode(escapeKey)
                        subj_resp{trial,block} = 'Esc';
                        ShowCursor;
                        sca;
                        return
                    elseif keyCode(lKey)
                        subj_resp{trial,block} = 'L';
                        timestamps(trial,3,block) = secs;
                        respToBeMade = false;
                        nextroom = 'left';
                    elseif keyCode(uKey)
                        subj_resp{trial,block} = 'U';
                        timestamps(trial,3,block) = secs;
                        respToBeMade = false;
                        nextroom = 'forward';
                    elseif keyCode(rKey)
                        subj_resp{trial,block} = 'R';
                        timestamps(trial,3,block) = secs;
                        respToBeMade = false;
                        nextroom = 'right';
                        pause(.1) %figure out a better way to do this
                    end
                    
                    %doing this forces the while loop to tick at the
                    %refresh rate of the monitor
                    Screen('DrawTexture',window,arrows.left.texture,[],leftdstRect,0);
                    Screen('DrawTexture',window,arrows.up.texture,[],updstRect,0);
                    Screen('DrawTexture',window,arrows.right.texture,[],rightdstRect,0);
                    [timestamps(trial,2,block),~,~,~,~] = Screen('Flip',window);
                    
                    spTimeFramescheck = spTimeFramescheck+1;
                    
                end
                
                disp(room)
                
            end
        
        end
        
%         switch nextroom
%             
%             case 'left'
%                 %do things
%             case 'forward'
%                 %do things
%             case 'right'
%                 %do things
%                 
%         end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    end
end


DrawFormattedText(window, 'Thanks for playing!',...
    'center', 'center', white);
Screen('Flip', window);
pause(2)


ShowCursor;
sca;
        
        
        

        


