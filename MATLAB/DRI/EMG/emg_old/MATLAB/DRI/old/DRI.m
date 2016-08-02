%script to make task for Delayed Rule Instruction (DRI) paradigm
%Oct 2015 PJR


%clear workspace
close all
clear all
sca

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

%----------------------------------------------------------------------
%                       Timing Information
%----------------------------------------------------------------------

%Interstimulus interval, rule, and stimulus presentation time in seconds 
%and frames
%Inerstimulus delay defined in expt loop in order to be variable per trial
isiTimeSecs = 1;
isiTimeFrames = round(isiTimeSecs/ifi);

rpTimeSecs = 5;
rpTimeFrames = round(rpTimeSecs/ifi);

spTimeSecs = 5;
spTimeFrames = round(spTimeSecs/ifi);

%Number of frames to wait before re-drawing
waitframes = 1;

%----------------------------------------------------------------------
%                       Keyboard information
%----------------------------------------------------------------------

%Defined keyboard keys that are listened for.
%Skip actually defining right now because we don't know what keys to use
%Code to listen for keys commented out below

keychoices = ['A' 'S' 'D' 'F'];

escapeKey = KbName('ESCAPE');
aKey = KbName('a');
sKey = KbName('s');
dKey = KbName('d');
fKey = KbName('f');

%----------------------------------------------------------------------
%                       Trial information
%----------------------------------------------------------------------

%Number of trials
numtrials = 8;

%number of trials per condition
numIDtrials = numtrials*0.5;
numNIDtrials = numtrials*0.5;

%make matrix of condition combinations (ID/NID x structure x stim/ns)
condMatrixBase = [sort(repmat([0 1], 1, numtrials/2)); ...
    repmat([0 0 1 1], 1, numtrials/4); repmat([0 1], 1, numtrials/2)];

%randomize order of presentation
shuffler = Shuffle(1:numtrials);
condMatrixShuffled = condMatrixBase(:,shuffler);


%----------------------------------------------------------------------
%                     Make a response matrix
%----------------------------------------------------------------------

% This is an n row array; the first row will record ID or NID,
% 2nd: the brain structure we are "in", 3rd: whether
% stimulation occurred or not, 4th: the number that was
% presented, 5th: the key they were supposed to respond with, 6th: the key
% they actually responded with, 7th: the length of the interstimulus delay

respMat = {};

%add in info we already have
respMat = num2cell(condMatrixShuffled);

%make a matrix to contain timing info; first row is time when first
%fixation cross appears; 2nd is when rule is first presented; 3rd is when
%second fixation cross is presented; 4th is when stimulus is first
%presented; 5th is when a response is made (if one was made)

respMatTimes = nan(5,max(numtrials));


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


%----------------------------------------------------------------------
%                       Experimental loop
%----------------------------------------------------------------------

for trial = 1:numtrials
    
    %Cue to determine whether a response has been made
    respToBeMade = true;
    
    %determine stimulus and record what it is
    stimchoices = [1,9];
    stim = randi(stimchoices);
    respMat{4,trial} = stim;
    printstim = num2str(stim);
    
    %determine length of interstimulus delay (variable 1-2s) and record it
    
    isdTimeSecs = rand(1)+1;
    isdTimeFrames = round(isiTimeSecs/ifi);
    respMat{7,trial} = isdTimeSecs;
    
    %randomize reponse keys and record which one suject is supposed to
    %press
    keys = Shuffle(keychoices);
    printkeys = ['Press ' keys(1) ' if even, ' keys(2) ' if odd'];
    if mod(stim,2)
        respMat{5,trial} = keys(2);
    else
        respMat{5,trial} = keys(1);
    end
    
    % If this is the first trial we present a start screen and wait for a
    % key-press
    if trial == 1
        DrawFormattedText(window, 'Press Any Key To Begin',...
            'center', 'center', white);
        Screen('Flip', window);
        KbStrokeWait;
    end
    
    %Flip again to sync to vertical retrace at same time as drawing
    %fixation cross
    Screen('DrawLines', window, allCoords,...
        lineWidthPix, white, [xCenter yCenter], 2);
    vbl = Screen('Flip', window);
    
    % Now we present the isi interval with fixation point minus one frame
    % because we presented the fixation point once already when getting a
    % time stamp
    for frame = 1:isiTimeFrames - 1
        
        % Draw the fixation point
        Screen('DrawLines', window, allCoords,...
            lineWidthPix, white, [xCenter yCenter], 2);
        
        %Flip to the screen
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    end
    
   %present rule
    for frame = 1:rpTimeFrames
        
        if condMatrixShuffled(1,trial) == 0   %0==ID 1==NID
            
            DrawFormattedText(window, 'EVEN/ODD', 'center', 'center', white);
            
            vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
            
        else

            DrawFormattedText(window, printkeys, 'center', 'center', white);
            
            vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
            
        end
    end
    
    %fixate between rule presentation and stimulus presentation (aka
    %interstimulus delay)
    
    Screen('DrawLines', window, allCoords,...
        lineWidthPix, white, [xCenter yCenter], 2);
    
    vbl = Screen('Flip', window);
    
    for frame = 1:isdTimeFrames - 1
        
        % Draw the fixation point
        Screen('DrawLines', window, allCoords,...
            lineWidthPix, white, [xCenter yCenter], 2);
        
        %Flip to the screen
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    end
    

%present stimulus, record key pressed and RT

     spTimeFramescheck = 1;

    tStart = GetSecs;
    while respToBeMade == true && spTimeFramescheck<max(spTimeFrames)
        
        if condMatrixShuffled(1,trial) == 0     %0==ID 1==NID
            
            DrawFormattedText(window, printstim, 'center', 'center', white);
            DrawFormattedText(window, printkeys, 'center', screenYpixels*0.55, white);
            
            [keyIsDown,secs, keyCode] = KbCheck;
            if keyCode(escapeKey)
                ShowCursor;
                sca;
                return
            elseif keyCode(aKey)
                respMat{6,trial} = 'A';
                respToBeMade = false;
            elseif keyCode(sKey)
                respMat{6,trial} = 'S';
                respToBeMade = false;
            elseif keyCode(dKey)
                respMat{6,trial} = 'D';
                respToBeMade = false;
            elseif keyCode(fKey)
                respMat{6,trial} = 'F';
                respToBeMade = false;
            end
            
            vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
            
        else
            
            DrawFormattedText(window, printstim, 'center', 'center', white);
            
            [keyIsDown,secs, keyCode] = KbCheck;
            if keyCode(escapeKey)
                ShowCursor;
                sca;
                return
            elseif keyCode(aKey)
                respMat{6,trial} = 'A';
                respToBeMade = false;
            elseif keyCode(sKey)
                respMat{6,trial} = 'S';
                respToBeMade = false;
            elseif keyCode(dKey)
                respMat{6,trial} = 'D';
                respToBeMade = false;
            elseif keyCode(fKey)
                respMat{6,trial} = 'F';
                respToBeMade = false;
            end
            
            vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

        end
        
        spTimeFramescheck = spTimeFramescheck + 1;
    end
    tEnd = GetSecs;
    respMatTimes(5,trial) = tEnd - tStart;
    
    if spTimeFramescheck==300
        respMat{6,trial} = nan;
    end
    
    if trial == numtrials
        DrawFormattedText(window, 'Thanks for playing!',...
            'center', 'center', white);
        Screen('Flip', window);
        KbStrokeWait;
    end
    
    
end





















%WE FUCKED UP ABORT
KbStrokeWait;
sca;

