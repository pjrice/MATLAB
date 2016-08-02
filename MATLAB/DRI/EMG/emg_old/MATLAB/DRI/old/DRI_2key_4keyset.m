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

%Interstimulus interval, intertrial interval, rule, and stimulus presentation time in seconds 
%and frames
%Inerstimulus delay defined in expt loop in order to be variable per trial
isiTimeSecs = 1;
isiTimeFrames = round(isiTimeSecs/ifi);

rpTimeSecs = 5;
rpTimeFrames = round(rpTimeSecs/ifi);

spTimeSecs = 5;
spTimeFrames = round(spTimeSecs/ifi);

itiTimeSecs = 3;
itiTimeFrames = round(itiTimeSecs/ifi);

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

%make string arrays for randomized motor responses
fingers{1} = 'INDEX';
fingers{2} = 'MIDDLE';
fingerchooser = [1 2];
symbols = ['A' 'B'];


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

%make a matrix to contain timing info; first row is time when the
%trial begins; 2nd is onset of rule presentation; 3rd is onset
%of the stimulus delay period; 4th is onset of stimulus presentation;
%5th is when a response is made (if one was made, if not, time of
%transistion to intertrial interval

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

isdTimeSecs = zeros(numtrials,1);
isdTimeFrames = zeros(numtrials,1);

for trial = 1:numtrials
    
    %Cue to determine whether a response has been made
    respToBeMade = true;

    %determine stimulus and record what it is
    stimchoices = [1,9];
    stim = randi(stimchoices);
    respMat{4,trial} = stim;
    printstim_l1 = num2str(stim);
    
    
    
    %determine length of interstimulus delay (variable 1-2s) and record it
    %actual length of isd presentation determined by
    %isdTimeFrames*isi!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    %this is due to loop below for frame = 1:isdTimeFrames and the hardware
    %determined value of ifi
    %isdTimeFrames*isi for any given trial n should be equal to
    %respMatTimes(4,n)-respMatTimes(3,n)
    
    isdTimeSecs(trial,1) = rand(1)+1;
    isdTimeFrames(trial,1) = round(isdTimeSecs(trial,1)/ifi);
    respMat{7,trial} = isdTimeSecs(trial,1);
    
    %randomize reponse keys and record which one suject is supposed to
    %press
    
%     keys = Shuffle(keychoices);
%     printkeys = ['Press ' keys(1) ' if even, ' keys(2) ' if odd'];
%     if mod(stim,2)
%         respMat{5,trial} = keys(2);
%     else
%         respMat{5,trial} = keys(1);
%     end
    
    
%     if mod(stim,2)
%         respMat{5,trial} = order(2);
%     else
%         respMat{5,trial} = order(1);
%     end
    
    
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
    respMatTimes(1,trial) = Screen('Flip', window);
    vbl = respMatTimes(1,trial);
    
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
    
    DrawFormattedText(window, 'EVEN/ODD', 'center', 'center', white);        
    respMatTimes(2,trial) = Screen('Flip', window);
    vbl = respMatTimes(2,trial);
    
   %present rule
    if condMatrixShuffled(1,trial) == 0   %0==ID 1==NID

        symbolchooser = Shuffle(symbols);
        printsymbols_l1 = ['EVEN -> ' symbolchooser(1)];
        printsymbols_l2 = ['\n\n ODD -> ' symbolchooser(2)];
        
        for frame = 1:rpTimeFrames

            if frame == 1
                
                DrawFormattedText(window, [printsymbols_l1 printsymbols_l2], 'center', 'center', white);        
                respMatTimes(2,trial) = Screen('Flip', window);
                vbl = respMatTimes(2,trial);
            else
      
                DrawFormattedText(window, [printsymbols_l1 printsymbols_l2], 'center', 'center', white);
                vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
                
            end
        end
            
    else
            
        fingerchooser = Shuffle(fingerchooser);
        printfingers_l1 = ['EVEN -> ' fingers{fingerchooser(1)}];
        printfingers_l2 = ['\n\n ODD -> ' fingers{fingerchooser(2)}];
                
        if mod(stim,2)
            respMat{5,trial} = fingers{fingerchooser(2)};
        else
            respMat{5,trial} = fingers{fingerchooser(1)};
        end
        
        for frame = 1:rpTimeFrames
                
            if frame == 1
                
                DrawFormattedText(window, [printfingers_l1 printfingers_l2], 'center', 'center', white);
                respMatTimes(2,trial) = Screen('Flip', window);
                vbl = respMatTimes(2,trial);
                
            else

                DrawFormattedText(window, [printfingers_l1 printfingers_l2], 'center', 'center', white);
                vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
                
            end
            
        end
    end
    
    %fixate between rule presentation and stimulus presentation (aka
    %interstimulus delay)
    
    Screen('DrawLines', window, allCoords,...
        lineWidthPix, white, [xCenter yCenter], 2);
    respMatTimes(3,trial) = Screen('Flip', window);
    vbl = respMatTimes(3,trial);
    
    for frame = 1:isdTimeFrames - 1
        
        % Draw the fixation point
        Screen('DrawLines', window, allCoords,...
            lineWidthPix, white, [xCenter yCenter], 2);
        
        %Flip to the screen
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    end
    

%present stimulus, record key pressed and RT

    %determine placement of A and B on screen
    %reuse fingerchooser, reshuffle so subjects can't determine spatial
    %location from rule presentation (even though it means nothing in
    %that condition)
    fingerchooser = Shuffle(fingerchooser);
    printstim_l2 = symbols(fingerchooser(1));
    printstim_l3 = symbols(fingerchooser(2));

    spTimeFramescheck = 1;

    tStart = GetSecs;
    while respToBeMade == true && spTimeFramescheck<max(spTimeFrames)
        
        if condMatrixShuffled(1,trial) == 0     %0==ID 1==NID
            
            if spTimeFramescheck == 1
                
                DrawFormattedText(window, printstim_l1, 'center', 'center', white);
                DrawFormattedText(window, printstim_l2, screenXpixels*0.25, screenYpixels*0.75, white);
                DrawFormattedText(window, printstim_l3, screenXpixels*0.75, screenYpixels*0.75, white);
            
                [keyIsDown,secs, keyCode] = KbCheck;
                if keyCode(escapeKey)
                    ShowCursor;
                    sca;
                    respMat{6,trial} = 'Esc';
                    respMatTimes(5,trial) = secs;
                    return
                elseif keyCode(aKey)
                    respMat{6,trial} = 'A';
                    respMatTimes(5,trial) = secs;
                    respToBeMade = false;
                elseif keyCode(sKey)
                    respMat{6,trial} = 'S';
                    respMatTimes(5,trial) = secs;
                    respToBeMade = false;
                elseif keyCode(dKey)
                    respMat{6,trial} = 'D';
                    respMatTimes(5,trial) = secs;
                    respToBeMade = false;
                elseif keyCode(fKey)
                    respMat{6,trial} = 'F';
                    respMatTimes(5,trial) = secs;
                    respToBeMade = false;
                end
                
                respMatTimes(4,trial) = Screen('Flip', window);
                vbl = respMatTimes(4,trial);
            
            else
            
                DrawFormattedText(window, printstim_l1, 'center', 'center', white);
                DrawFormattedText(window, printstim_l2, screenXpixels*0.25, screenYpixels*0.75, white);
                DrawFormattedText(window, printstim_l3, screenXpixels*0.75, screenYpixels*0.75, white);
            
                [keyIsDown,secs, keyCode] = KbCheck;
                if keyCode(escapeKey)
                    respMat{6,trial} = 'Esc';
                    respMatTimes(5,trial) = secs;
                    ShowCursor;
                    sca;
                    return
                elseif keyCode(aKey)
                    respMat{6,trial} = 'A';
                    respMatTimes(5,trial) = secs;
                    respToBeMade = false;
                elseif keyCode(sKey)
                    respMat{6,trial} = 'S';
                    respMatTimes(5,trial) = secs;
                    respToBeMade = false;
                elseif keyCode(dKey)
                    respMat{6,trial} = 'D';
                    respMatTimes(5,trial) = secs;
                    respToBeMade = false;
                elseif keyCode(fKey)
                    respMat{6,trial} = 'F';
                    respMatTimes(5,trial) = secs;
                    respToBeMade = false;
                end
            
                vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
                
            end
            
        else
            
            if spTimeFramescheck == 1
                
                DrawFormattedText(window, printstim_l1, 'center', 'center', white);
                DrawFormattedText(window, printstim_l2, screenXpixels*0.25, screenYpixels*0.75, white);
                DrawFormattedText(window, printstim_l3, screenXpixels*0.75, screenYpixels*0.75, white);
                
                [keyIsDown,secs, keyCode] = KbCheck;
                if keyCode(escapeKey)
                    respMat{6,trial} = 'Esc';
                    respMatTimes(5,trial) = secs;
                    ShowCursor;
                    sca;
                    return
                elseif keyCode(aKey)
                    respMat{6,trial} = 'A';
                    respMatTimes(5,trial) = secs;
                    respToBeMade = false;
                elseif keyCode(sKey)
                    respMat{6,trial} = 'S';
                    respMatTimes(5,trial) = secs;
                    respToBeMade = false;
                elseif keyCode(dKey)
                    respMat{6,trial} = 'D';
                    respMatTimes(5,trial) = secs;
                    respToBeMade = false;
                elseif keyCode(fKey)
                    respMat{6,trial} = 'F';
                    respMatTimes(5,trial) = secs;
                    respToBeMade = false;
                end
                
                respMatTimes(4,trial) = Screen('Flip', window);
                vbl = respMatTimes(4,trial);
                
            else
         
                DrawFormattedText(window, printstim_l1, 'center', 'center', white);
                DrawFormattedText(window, printstim_l2, screenXpixels*0.25, screenYpixels*0.75, white);
                DrawFormattedText(window, printstim_l3, screenXpixels*0.75, screenYpixels*0.75, white);
                
                [keyIsDown,secs, keyCode] = KbCheck;
                if keyCode(escapeKey)
                    respMat{6,trial} = 'Esc';
                    respMatTimes(5,trial) = secs;
                    ShowCursor;
                    sca;
                    return
                elseif keyCode(aKey)
                    respMat{6,trial} = 'A';
                    respMatTimes(5,trial) = secs;
                    respToBeMade = false;
                elseif keyCode(sKey)
                    respMat{6,trial} = 'S';
                    respMatTimes(5,trial) = secs;
                    respToBeMade = false;
                elseif keyCode(dKey)
                    respMat{6,trial} = 'D';
                    respMatTimes(5,trial) = secs;
                    respToBeMade = false;
                elseif keyCode(fKey)
                    respMat{6,trial} = 'F';
                    respMatTimes(5,trial) = secs;
                    respToBeMade = false;
                end
            
                vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
                
            end

        end
        
        spTimeFramescheck = spTimeFramescheck + 1;
    end
    tEnd = GetSecs;
    %respMatTimes(5,trial) = tEnd - tStart;
    
    if spTimeFramescheck==300
        respMat{6,trial} = nan;
    end    
    
    if trial == numtrials
        
        DrawFormattedText(window, 'Thanks for playing!',...
            'center', 'center', white);
        Screen('Flip', window);
        KbStrokeWait;
        
    else
        
        Screen('FillRect',window,black);
        vbl = Screen('Flip', window);
    
        for frame = 1:1:itiTimeFrames - 1
        
            Screen('FillRect',window,black);
            vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
        
        end
        
    end
    
    
end





















%WE FUCKED UP ABORT
KbStrokeWait;
sca;

