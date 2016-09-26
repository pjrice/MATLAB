
clear

%filename?
% filename = 'C:\temp_patrick\data\semantics\';
% filename_append = input('Filename? ','s');
% filename = strcat(filename,filename_append);

%base path for images?
% imgbasepath = 'C:\temp_patrick\RP_images\';
imgbasepath = 'Z:\Work\UW\projects\SEM\stimuli\';
% imgbasepath = 'Z:\Work\UW\projects\semantics\stimuli\';

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
stimuli.dwellings.castle.imgloc = strcat(imgbasepath,'castle.png');
stimuli.dwellings.house.imgloc = strcat(imgbasepath,'house.png');
stimuli.dwellings.igloo.imgloc = strcat(imgbasepath,'igloo.png');
stimuli.dwellings.tent.imgloc = strcat(imgbasepath,'tent.png');
stimuli.tools.hammer.imgloc = strcat(imgbasepath,'hammer.png');
stimuli.tools.pliers.imgloc = strcat(imgbasepath,'pliers.png');
stimuli.tools.saw.imgloc = strcat(imgbasepath,'saw.png');
stimuli.tools.screwdriver.imgloc = strcat(imgbasepath,'screwdriver.png');

stimuli.dwellings.castle.img = imread(stimuli.dwellings.castle.imgloc);
stimuli.dwellings.house.img = imread(stimuli.dwellings.house.imgloc);
stimuli.dwellings.igloo.img = imread(stimuli.dwellings.igloo.imgloc);
stimuli.dwellings.tent.img = imread(stimuli.dwellings.tent.imgloc);
stimuli.tools.hammer.img = imread(stimuli.tools.hammer.imgloc);
stimuli.tools.pliers.img = imread(stimuli.tools.pliers.imgloc);
stimuli.tools.saw.img = imread(stimuli.tools.saw.imgloc);
stimuli.tools.screwdriver.img = imread(stimuli.tools.screwdriver.imgloc);

% Make images into textures
stimuli.dwellings.castle.texture = Screen('MakeTexture', window, stimuli.dwellings.castle.img);
stimuli.dwellings.house.texture = Screen('MakeTexture', window, stimuli.dwellings.house.img);
stimuli.dwellings.igloo.texture = Screen('MakeTexture', window, stimuli.dwellings.igloo.img);
stimuli.dwellings.tent.texture = Screen('MakeTexture', window, stimuli.dwellings.tent.img);
stimuli.tools.hammer.texture = Screen('MakeTexture', window, stimuli.tools.hammer.img);
stimuli.tools.pliers.texture = Screen('MakeTexture', window, stimuli.tools.pliers.img);
stimuli.tools.saw.texture = Screen('MakeTexture', window, stimuli.tools.saw.img);
stimuli.tools.screwdriver.texture = Screen('MakeTexture', window, stimuli.tools.screwdriver.img);

% Get the size of the image (all should be same size)
[s1, s2, s3] = size(stimuli.dwellings.castle.img);

%define the destination rectangle for the images
dstRect = [0 0 s1 s2];
dstRect = CenterRectOnPointd(dstRect, xCenter, yCenter);

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
numtrials = 48;
numblocks = 1;

%init data matrices
timestamps = nan(numtrials,5,numblocks);
subj_resp = cell(numtrials,numblocks);

%make stimuli references for later presentation
cats = fieldnames(stimuli);

for i = 1:length(cats)
    
    if ~exist('things')
    
        things = fieldnames(stimuli.(matlab.lang.makeValidName(cats{i})));
        
    else
        
        things = cat(1,things,fieldnames(stimuli.(matlab.lang.makeValidName(cats{i}))));
        
    end
    
end

%randomize presentation
%assumes there is an equal number of things in each category
%requires the number of trials to be a multiple of the total number of things
%stim_inds: indices of stimuli for each trial;
%first column denotes whether the word (1) or picture (2) form will be 
%presented;
%second column denotes the category (aka cats{stim_inds(i,2)});
%third column denotes the thing (aka things{stim_inds(i,3)})
stim_inds = cat(2,sort(repmat([1:length(cats)]',length(things)/length(cats),1)),[1:length(things)]');
stim_inds = repmat(stim_inds,numtrials/length(stim_inds),1);
stim_inds = cat(2,sort(repmat([1 2]',numtrials/2,1)),stim_inds);
stim_inds = Shuffle(stim_inds,2);

%----------------------------------------------------------------------
%                       Timing Information
%----------------------------------------------------------------------

%hold time, rule presentation, ISD, and stimulus presentation time in seconds and frames

%hold time
holdTimeSecs = 1.5;
holdTimeFrames = round(holdTimeSecs/ifi);

%maximum rule and stimulus/response presentation length
spTimeSecs = 5;
spTimeFrames = round(spTimeSecs/ifi);

%Number of frames to wait before re-drawing
waitframes = 1;

%----------------------------------------------------------------------
%                       Keyboard information
%----------------------------------------------------------------------

%Defined keyboard keys that are listened for.

keychoices = ['A' 'L'];

escapeKey = KbName('ESCAPE');

aKey = KbName('a');  %assigned to "dwelling" response
lKey = KbName('l');  %assigned to "tool" response

%----------------------------------------------------------------------
%                       Fixation Cross
%----------------------------------------------------------------------

% Here we set the size of the arms of our fixation cross
fixCrossDimPix = 40;

% Now we set the coordinates (these are all relative to zero we will let
% the drawing routine center the cross in the center of our monitor for us)

%fixation cross coordinates
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];

fixCoords = [xCoords; yCoords];

% Set the line width for our fixation cross
lineWidthPix = 4;

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

%present until subject is ready; press any key to continue
DrawFormattedText(window, 'Press any key to begin',...
    'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;

%try a couple of different timestamping methods
streamstart_time = GetSecs;
tic
for block = 1:numblocks
    
    for trial = 1:numtrials
        
        %timestamp trial start
        timestamps(trial,1,block) = GetSecs;
        
        %Cue to determine whether a response has been made
        respToBeMade = true;
        whichButton = 0;
        
        %Flip again to sync to vertical retrace at same time as drawing
        %fixation cross
        %timestamp fix presentation
        Screen('DrawLines', window, fixCoords,...
            lineWidthPix, white, [xCenter yCenter], 2);
        [timestamps(trial,2,block),~,~,~,~] = Screen('Flip', window);
        
        % Now we present the hold interval with fixation point minus one frame
        % because we presented the fixation point once already when getting a
        % time stamp
        for frame = 1:holdTimeFrames - 1
            
            % Draw the fixation point
            Screen('DrawLines', window, fixCoords,...
                lineWidthPix, white, [xCenter yCenter], 2);
            
            %Flip to the screen
            Screen('Flip', window);
        end
        
        if stim_inds(trial,1)==1  %present stimulus in word form
            
            %timestamp stimulus presentation
            DrawFormattedText(window, things{stim_inds(trial,3)},'center', 'center', white);
            [timestamps(trial,3,block),~,~,~,~] = Screen('Flip', window);
            
            spTimeFramescheck = 1;
            
            while spTimeFramescheck ~= spTimeFrames
                
                [keyIsDown,secs, keyCode] = KbCheck;
                if keyCode(escapeKey)
                    subj_resp{trial,block} = 'Esc';
                    ShowCursor;
                    sca;
                    return
                elseif keyCode(aKey) && isnan(timestamps(trial,4,block))
                    subj_resp{trial,block} = 'L';
                    timestamps(trial,4,block) = secs;
                    respToBeMade = false;
                elseif keyCode(lKey) && isnan(timestamps(trial,4,block))
                    subj_resp{trial,block} = 'R';
                    timestamps(trial,4,block) = secs;
                    respToBeMade = false;
                end
                
                DrawFormattedText(window, things{stim_inds(trial,3)},'center', 'center', white);
                Screen('Flip', window);
                
                spTimeFramescheck = spTimeFramescheck + 1;
                
            end
            
        else  %present stimulus in picture form
            
            Screen('DrawTexture', window, stimuli.(matlab.lang.makeValidName(cats{stim_inds(trial,2)})).(matlab.lang.makeValidName(things{stim_inds(trial,3)})).texture, [], dstRect, 0);
            [timestamps(trial,3,block),~,~,~,~] = Screen('Flip', window);
            
            spTimeFramescheck = 1;
            
            while spTimeFramescheck ~= spTimeFrames
                
                [keyIsDown,secs, keyCode] = KbCheck;
                if keyCode(escapeKey)
                    subj_resp{trial,block} = 'Esc';
                    ShowCursor;
                    sca;
                    return
                elseif keyCode(aKey) && isnan(timestamps(trial,4,block))
                    subj_resp{trial,block} = 'L';
                    timestamps(trial,4,block) = secs;
                    respToBeMade = false;
                elseif keyCode(lKey) && isnan(timestamps(trial,4,block))
                    subj_resp{trial,block} = 'R';
                    timestamps(trial,4,block) = secs;
                    respToBeMade = false;
                end
                
                Screen('DrawTexture', window, stimuli.(matlab.lang.makeValidName(cats{stim_inds(trial,2)})).(matlab.lang.makeValidName(things{stim_inds(trial,3)})).texture, [], dstRect, 0);
                Screen('Flip', window);
                
                spTimeFramescheck = spTimeFramescheck + 1;
                
            end   
        end
        %timestamp trial end, display trial number
        timestamps(trial,5,block) = GetSecs;
        disp(trial)
    end  
end
        

DrawFormattedText(window, 'Thanks for playing!',...
    'center', 'center', white);
Screen('Flip', window);

% %if OpenWorkbench is in Record mode, then this will set it to Standby
% %then stores the time of recording stop relative to the rest of the events
% %that occur
% if DA.GetSysMode ~= 1
%     
%     DA.SetSysMode(1);
%     
%     while DA.GetSysMode ~= 1
%         pause(.1)
%     end
%     
%     TDT_recording_stop = GetSecs;
%     
% %     % Disarm the stim - MAY NOT NEED TO DO THIS!
% %     DA.SetTargetVal('RZ5D.ArmSystem', 0);
% 
% end
% 
% % Close ActiveX connection:
% DA.CloseConnection
% if DA.CheckServerConnection == 0
%     display('Server was disconnected');
% end
% clear DA

KbStrokeWait;
ShowCursor;
sca;

save(filename)
           
        
        

        
        
            
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
