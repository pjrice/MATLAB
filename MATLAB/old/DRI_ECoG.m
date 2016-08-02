%DRI paradigm with EMG recordings
%largely selfpaced, unimanual, abstract other rule

clear %Clear the MATLAB variables

%which hand are we working with?

hand = input('Which hand are we working with? 0 for left, 1 for right: ');
   
%Setup PTB with some default values
PsychDefaultSetup(2);

%give praise to rngesus and show our faith by seeding
%may not be used but what the hey
rng('shuffle')

%set screen num to secondary monitor if one is connected
screenNumber = max(Screen('Screens'));

%define black, white and grey
white = WhiteIndex(screenNumber);
grey = white/2;
black = BlackIndex(screenNumber);

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %DOING TDT THANGS
% 
% % Open connection with TDT and begin program
% DA = actxcontrol('TDevAcc.X');
% DA.ConnectServer('Local'); %initiates a connection with an OpenWorkbench server. The connection adds a client to the server
% 
% if DA.CheckServerConnection ~= 1 %checks that the server is connected to OpenWorkbench
%     error('Client application (i.e. OpenWorkbench) is not connected to server');
% end
% 
% % Disarm the stim
% DA.SetTargetVal('RZ5D.ArmSystem', 0);
% DA.SetTargetVal('RZ5D.IsArmed', 0);
% 
% %if OpenWorkbench is not in Record mode, then this will set it to record
% %record timestamp when DA.GetSysMode==3
% if DA.GetSysMode ~= 3
%     DA.SetSysMode(3);
%     
%     while DA.GetSysMode ~= 3
%         pause(.1)  %I guess this is for the roundtrip for matlab->change value in TDT->TDT report new value to matlab?
%     end
%     
%     %get the timestamp once DA.GetSysMode==3
%     %have to do this after PTB starts so GetSecs works
%     
%     ECoG_record_starttime = GetSecs;
%     
%     % Disarm the stim - MAY NOT NEED TO DO THIS!
%     %system already disarmed on lines 23-24? Does setting it to record
%     %re-arm the system?
%     DA.SetTargetVal('RZ5D.ArmSystem', 0);
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----------------------------------------------------------------------
%                       Trial information
%----------------------------------------------------------------------

numblocks = 1;
numtrials = 16;
stimchoices = [1,9];

fingers{1} = 'INDEX';
fingers{2} = 'MIDDLE';
evenodd{1} = 'EVEN';
evenodd{2} = 'ODD';
symbols = ['A' 'B'];

%load images
A_imgloc = 'C:\Users\ausma_000\Documents\MATLAB\RP_images\A.png';
B_imgloc = 'C:\Users\ausma_000\Documents\MATLAB\RP_images\B.png';
LI_imgloc = 'C:\Users\ausma_000\Documents\MATLAB\RP_images\L_Index.png';
LM_imgloc = 'C:\Users\ausma_000\Documents\MATLAB\RP_images\L_Middle.png';
RI_imgloc = 'C:\Users\ausma_000\Documents\MATLAB\RP_images\R_Index.png';
RM_imgloc = 'C:\Users\ausma_000\Documents\MATLAB\RP_images\R_Middle.png';

A_img = imread(A_imgloc);
B_img = imread(B_imgloc);
LI_img = imread(LI_imgloc);
LM_img = imread(LM_imgloc);
RI_img = imread(RI_imgloc);
RM_img = imread(RM_imgloc);

% Make the image into a texture
Symbol_Textures{1} = Screen('MakeTexture', window, A_img);
Symbol_Textures{2} = Screen('MakeTexture', window, B_img);
Finger_Textures{1} = Screen('MakeTexture', window, LI_img);
Finger_Textures{2} = Screen('MakeTexture', window, LM_img);
Finger_Textures{3} = Screen('MakeTexture', window, RI_img);
Finger_Textures{4} = Screen('MakeTexture', window, RM_img);

% Get the size of the image (all should be same size)
[s1, s2, s3] = size(A_img);

%define the destination rectangle for the images
dstRect = [0 0 s1 s2];
dstRect = CenterRectOnPointd(dstRect, xCenter, yCenter*1.35);

% Here we check if the image is too big to fit on the screen and abort if
% it is
if s1 > screenYpixels || s2 > screenYpixels
    disp('ERROR! Image is too big to fit on the screen');
    sca;
    return;
end



chooser = [1 2];

%randomize trial stuffs
for block = 1:numblocks
    
    %randomize order of condition presentation and record it
    condMatrixtemp = sort(repmat([0 1], 1, numtrials/2));
    condMatrix(:,block) = condMatrixtemp(:,Shuffle(1:numtrials))';
    
    for trial = 1:numtrials
        
        %determine stimulus and record what it is
        stim(trial,block) = randi(stimchoices);
        printstim_l1(trial,block) = num2str(stim(trial,block));
        
        %decide which symbols/fingers are assigned to even/odd and record
        evenoddchooser{trial,block} = Shuffle(chooser);  %1==Even
        symbolchooser{trial,block} = Shuffle(chooser);  %1==A
        fingerchooser{trial,block} = Shuffle(chooser);  %1==Index
        abchooser{trial,block} = Shuffle(chooser);  %1==A
        
        %make strings to present
        %decide whether to print even or odd
        print_evenodd{trial,block} = [evenodd{evenoddchooser{trial,block}(1)}];

        %determine placement of A and B on screen
        printstim_l2(trial,block) = symbols(abchooser{trial,block}(1)); %prints on left of screen
        printstim_l3(trial,block) = symbols(abchooser{trial,block}(2)); %prints on right of screen

    end
end
%----------------------------------------------------------------------
%                       Timing Information
%----------------------------------------------------------------------

%hold time, rule presentation, ISD, and stimulus presentation time in seconds and frames

%hold time
holdTimeSecs = 1;
holdTimeFrames = round(holdTimeSecs/ifi);

%maximum rule and stimulus/response presentation length
spTimeSecs = 6;
spTimeFrames = round(spTimeSecs/ifi);

%ISD
isdTimeSecs = 2;
isdTimeFrames = round(isdTimeSecs/ifi);

%max trial length for length of EMG recordings
max_tlength = 16;  %seconds; CHANGE VALUE 'DELAY' ABOVE FOR EMG
max_tlength_frames = round(max_tlength/ifi);  %frames

%Number of frames to wait before re-drawing
waitframes = 1;


%----------------------------------------------------------------------
%                       Keyboard information
%----------------------------------------------------------------------

%Defined keyboard keys that are listened for.

keychoices = ['A' 'S'];

escapeKey = KbName('ESCAPE');
aKey = KbName('a');
sKey = KbName('s');
spacebar = KbName('space');

%----------------------------------------------------------------------
%                     Make a response matrix
%----------------------------------------------------------------------

% This is an n x ntrials x nblocks array
%the first row will record the hand the subject is working with - (0)left
    %or (1) right
%2nd: the stimulus value that was presented
%3rd: length of interstimulus delay
%4th: whether even or odd was in the first line of the rule 
%5th: whether A or B/Index or Middle was in the first line of the rule
%6th: symbol assigned to left side during stimulus presentation
%7th: key that the subject pressed for response
%8th: 
%9th: 
%10th: 
%11th: 
%12th: 

respMat = {};

%Timing matrices - VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed,
%Beampos are all output by Screen('Flip') - see 'Screen Flip?' for details.
%Columns are consistent across these five matrices - they are: (1)hold
%period onset; (2)rule presentation onset; (3)delay period onset;
%(4)stimulus presentation onset; (5)ITI onset

VBLTimestamp = nan(numtrials,5,numblocks);
StimulusOnsetTime = nan(numtrials,5,numblocks);
FlipTimestamp = nan(numtrials,5,numblocks);
Missed = nan(numtrials,5,numblocks);
Beampos = nan(numtrials,5,numblocks);

%respTime is the time that the key was pressed for response

respTime = nan(numtrials,numblocks);

%----------------------------------------------------------------------
%                       Fixation Cross
%----------------------------------------------------------------------

% Here we set the size of the arms of our fixation cross
fixCrossDimPix = 40;

% Now we set the coordinates (these are all relative to zero we will let
% the drawing routine center the cross in the center of our monitor for us)
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
allCoords = [xCoords; yCoords];

% Set the line width for our fixation cross
lineWidthPix = 4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%preallocate arrays because I pretend to be good at coding
trialstart_time = zeros(numtrials,numblocks);
true_SPTF = zeros(numtrials,numblocks);
true_RPTF = zeros(numtrials,numblocks);
time_passed = zeros(numtrials,numblocks);
time_remaining = zeros(numtrials,numblocks);
trialstop_time = zeros(numtrials,numblocks);
realtime = zeros(numtrials,numblocks);


%try a couple of different timestamping methods
streamstart_time = GetSecs;
tic
for block = 1:numblocks
    
    for trial = 1:numtrials
        
        trialstart_time(trial,block) = GetSecs;
        
        %Cue to determine whether a response has been made
        respToBeMade = true;
        
        %record the hand that is being used
        respMat{1,trial,block} = hand;
        
        %Flip again to sync to vertical retrace at same time as drawing
        %fixation cross
        Screen('DrawLines', window, allCoords,...
            lineWidthPix, white, [xCenter yCenter], 2);
        [VBLTimestamp(trial,1,block),StimulusOnsetTime(trial,1,block),...
            FlipTimestamp(trial,1,block),Missed(trial,1,block),...
            Beampos(trial,1,block)] = Screen('Flip', window);
        
        
        % Now we present the hold interval with fixation point minus one frame
        % because we presented the fixation point once already when getting a
        % time stamp
        for frame = 1:holdTimeFrames - 1
            
            % Draw the fixation point
            Screen('DrawLines', window, allCoords,...
                lineWidthPix, white, [xCenter yCenter], 2);
            
            %Flip to the screen
%             vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
            Screen('Flip', window);
        end
        
        %present rule
        
        if condMatrix(trial,block) == 0  %0==symbols 1==fingers
            
            DrawFormattedText(window, print_evenodd{trial,block},...
                'center', 'center', white);
            Screen('DrawTexture', window,...
                Symbol_Textures{symbolchooser{trial,block}(1)}, [], dstRect, 0);
            [VBLTimestamp(trial,2,block),StimulusOnsetTime(trial,2,block),...
                FlipTimestamp(trial,2,block),Missed(trial,2,block),...
                Beampos(trial,2,block)] = Screen('Flip', window);
            
            spTimeFramescheck = 1;
            
            while spTimeFramescheck<spTimeFrames
            
                DrawFormattedText(window, print_evenodd{trial,block},...
                    'center', 'center', white);
                Screen('DrawTexture', window,...
                    Symbol_Textures{symbolchooser{trial,block}(1)}, [], dstRect, 0);
                Screen('Flip', window);
                
                spTimeFramescheck = spTimeFramescheck + 1;
            
            end
            
        else
                    
            DrawFormattedText(window, print_evenodd{trial,block},...
                'center', 'center', white);
            Screen('DrawTexture', window,...
                Finger_Textures{fingerchooser{trial,block}(1)}, [], dstRect, 0);
            [VBLTimestamp(trial,2,block),StimulusOnsetTime(trial,2,block),...
                FlipTimestamp(trial,2,block),Missed(trial,2,block),...
                Beampos(trial,2,block)] = Screen('Flip', window);
            
            spTimeFramescheck = 1;
            
            while spTimeFramescheck<spTimeFrames
                
                DrawFormattedText(window, print_evenodd{trial,block},...
                    'center', 'center', white);
                Screen('DrawTexture', window,...
                    Finger_Textures{fingerchooser{trial,block}(1)}, [], dstRect, 0);
                Screen('Flip', window);
                
                spTimeFramescheck = spTimeFramescheck + 1;
                
            end
            
        end
        
        true_SPTF(trial,block) = spTimeFramescheck;
        
        %fixate between rule presentation and stimulus presentation (aka
        %interstimulus delay)
        
        Screen('DrawLines', window, allCoords,...
            lineWidthPix, white, [xCenter yCenter], 2);
        
        [VBLTimestamp(trial,3,block),StimulusOnsetTime(trial,3,block),...
            FlipTimestamp(trial,3,block),Missed(trial,3,block),...
            Beampos(trial,3,block)] = Screen('Flip', window);


        for frame = 1:isdTimeFrames - 1
            
            Screen('DrawLines', window, allCoords,...
                lineWidthPix, white, [xCenter yCenter], 2);
            
            Screen('Flip', window);

        end

        %present stimulus, record key pressed and RT
        
        respToBeMade = true;
        
        DrawFormattedText(window, printstim_l1(trial,block), 'center',...
            'center', white);
        DrawFormattedText(window, printstim_l2(trial,block),...
            screenXpixels*0.25, screenYpixels*0.75, white);
        DrawFormattedText(window, printstim_l3(trial,block),...
            screenXpixels*0.75, screenYpixels*0.75, white);
        
        [VBLTimestamp(trial,4,block),StimulusOnsetTime(trial,4,block),...
            FlipTimestamp(trial,4,block),Missed(trial,4,block),...
            Beampos(trial,4,block)] = Screen('Flip', window);
        

        spTimeFramescheck = 1;
        
        while respToBeMade == true && spTimeFramescheck<spTimeFrames-1
            
            [keyIsDown,secs, keyCode] = KbCheck;
            if keyCode(escapeKey)
                respMat{7,trial} = 'Esc';
                respTime(trial,block) = secs;
                ShowCursor;
                sca;
                return
            elseif keyCode(aKey)
                respMat{7,trial} = 'A';
                respTime(trial,block) = secs;
                respToBeMade = false;
            elseif keyCode(sKey)
                respMat{7,trial} = 'S';
                respTime(trial,block) = secs;
                respToBeMade = false;
            end
            
            DrawFormattedText(window, printstim_l1(trial,block), 'center',...
                'center', white);
            DrawFormattedText(window, printstim_l2(trial,block),...
                screenXpixels*0.25, screenYpixels*0.75, white);
            DrawFormattedText(window, printstim_l3(trial,block),...
                screenXpixels*0.75, screenYpixels*0.75, white);
            Screen('Flip', window);
            
            spTimeFramescheck = spTimeFramescheck + 1;
            
        end
        
        true_RPTF(trial,block) = spTimeFramescheck + 1;
        
        if trial == numtrials

            DrawFormattedText(window, 'Thanks for playing!',...
                'center', 'center', white);
                [VBLTimestamp(trial,5,block),StimulusOnsetTime(trial,5,block),...
                    FlipTimestamp(trial,5,block),Missed(trial,5,block),...
                    Beampos(trial,5,block)] = Screen('Flip', window);
                
            time_passed(trial,block) = holdTimeFrames+true_SPTF(trial,block)+isdTimeFrames+true_RPTF(trial,block);  %in frames
            time_remaining(trial,block) = max_tlength_frames - time_passed(trial,block);
            
            KbStrokeWait;
            ShowCursor;
            sca;
            
        else
            
            %determine length of ITI based off of trial timing so that
            %total length of trial is 24 seconds
            
            time_passed(trial,block) = holdTimeFrames+true_SPTF(trial,block)+isdTimeFrames+true_RPTF(trial,block);  %in frames
            time_remaining(trial,block) = max_tlength_frames - time_passed(trial,block)-1;  %in frames - this is the number of frames we want to present ITI for
            
            Screen('FillRect',window,black);
            [VBLTimestamp(trial,5,block),StimulusOnsetTime(trial,5,block),...
                FlipTimestamp(trial,5,block),Missed(trial,5,block),...
                Beampos(trial,5,block)] = Screen('Flip', window);
            
            for frame = 1:1:time_remaining(trial,block) - 1
                
                Screen('FillRect',window,black);
                Screen('Flip', window);
                
            end
            
        end
        
        trialstop_time(trial,block) = GetSecs;  %relative to streamstart_time
        realtime(trial,block) = toc;  %relative to tic
        
    end
    
end

clear e eNet ljasm ljerror ljudObj
