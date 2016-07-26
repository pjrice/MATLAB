%self-paced DRI paradigm for ECoG patients
%bimanual
%two possible response keys

%which hand are we initially working with?

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

%----------------------------------------------------------------------
%                       Trial information
%----------------------------------------------------------------------

%Number of blocks
numblocks = 2;  %one for each hand

%Number of trials per block
numtrials = 8;

%make matrix of condition combinations (symbol/finger)
condMatrixBase = sort(repmat([0 1], 1, numtrials/2));

%make string arrays for randomized motor responses
fingers{1} = 'INDEX';
fingers{2} = 'MIDDLE';
evenodd{1} = 'EVEN';
evenodd{2} = 'ODD';
symbols = ['A' 'B'];

fingerchooser = [1 2];
evenoddchooser = [1 2];

%----------------------------------------------------------------------
%                       Timing Information
%----------------------------------------------------------------------

%hold time, intertrial interval, rule, and stimulus presentation time in seconds 
%and frames
%Inerstimulus delay defined in expt loop in order to be variable per trial
holdTimeSecs = 1;
holdTimeFrames = round(holdTimeSecs/ifi);

itiTimeSecs = 1.5;
itiTimeFrames = round(itiTimeSecs/ifi);

isdTimeSecs = zeros(numtrials,1);
isdTimeFrames = zeros(numtrials,1);

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

%----------------------------------------------------------------------
%                       Experimental loop
%----------------------------------------------------------------------

for block = 1:numblocks
    
    %randomize order of condition presentation and record it
    shuffler = Shuffle(1:numtrials);
    condMatrixShuffled = condMatrixBase(:,shuffler);
    
    condMat{block} = condMatrixShuffled;
    
    for trial = 1:numtrials
        
        %Cue to determine whether a response has been made
        respToBeMade = true;
        
        %record the hand that is being used
        respMat{1,trial,block} = hand;
        
        %determine stimulus and record what it is
        stimchoices = [1,9];
        stim = randi(stimchoices);
        respMat{2,trial,block} = stim;
        printstim_l1 = num2str(stim);
        
        %determine length of interstimulus delay (variable 1-2s) and record it
        %actual length of isd presentation determined by
        %isdTimeFrames*isi!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        %this is due to loop below for frame = 1:isdTimeFrames and the hardware
        %determined value of ifi
        %isdTimeFrames*isi for any given trial n should be equal to
        %respMatTimes(4,n)-respMatTimes(3,n)
        
        isdTimeSecs(trial,block) = rand(1)+1;
        isdTimeFrames(trial,block) = round(isdTimeSecs(trial,1)/ifi);
        respMat{3,trial,block} = isdTimeSecs(trial,block);
        
        % If this is the first trial we present a start screen and wait for a
        % key-press
        if trial == 1 && block == 1
            DrawFormattedText(window, 'Press Any Key To Begin',...
                'center', 'center', white);
            Screen('Flip', window);
            KbStrokeWait;
        end
        
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
        if condMatrixShuffled(1,trial) == 0  %0==symbols 1==fingers
            
            %decide which symbols are assigned to even/odd and record
            symbolchooser = Shuffle(symbols);
            evenoddchooser = Shuffle(evenoddchooser);
            
            printsymbols_l1 = [evenodd{evenoddchooser(1)} ' -> '...
                symbolchooser(1)];
            printsymbols_l2 = ['\n\n' evenodd{evenoddchooser(2)} ' -> '...
                symbolchooser(2)];
            printsymbols_l3 = ['\n\n\n\n Press any key to continue'];
            
            %even or odd in first row of rule presentation?
            respMat{4,trial,block} = evenodd{evenoddchooser(1)};
            
            %A or B in first row of rule presentation?
            respMat{5,trial,block} = symbolchooser(1);

            DrawFormattedText(window, [printsymbols_l1 printsymbols_l2 printsymbols_l3],...
                'center', 'center', white);
            [VBLTimestamp(trial,2,block),StimulusOnsetTime(trial,2,block),...
            FlipTimestamp(trial,2,block),Missed(trial,2,block),...
            Beampos(trial,2,block)] = Screen('Flip', window);
            KbStrokeWait;
            
        else
            
            %choose finger assigned to even/odd and record
            fingerchooser = Shuffle(fingerchooser);
            evenoddchooser = Shuffle(evenoddchooser);
            
            printfingers_l1 = [evenodd{evenoddchooser(1)} ' -> '...
                fingers{fingerchooser(1)}];
            printfingers_l2 = ['\n\n' evenodd{evenoddchooser(2)} ' -> '...
                fingers{fingerchooser(2)}];
            printfingers_l3 = ['\n\n\n\n Press any key to continue'];

            %even or odd in first row of rule presentation?
            respMat{4,trial,block} = evenodd{evenoddchooser(1)};
            
            %A or B in first row of rule presentation?
            respMat{5,trial,block} = fingers{fingerchooser(1)};
            
            DrawFormattedText(window, [printfingers_l1 printfingers_l2 printfingers_l3],...
                'center', 'center', white);
            [VBLTimestamp(trial,2,block),StimulusOnsetTime(trial,2,block),...
            FlipTimestamp(trial,2,block),Missed(trial,2,block),...
            Beampos(trial,2,block)] = Screen('Flip', window);
            KbStrokeWait;
            
        end
        
        %fixate between rule presentation and stimulus presentation (aka
        %interstimulus delay)
        
        Screen('DrawLines', window, allCoords,...
            lineWidthPix, white, [xCenter yCenter], 2);
        
        [VBLTimestamp(trial,3,block),StimulusOnsetTime(trial,3,block),...
            FlipTimestamp(trial,3,block),Missed(trial,3,block),...
            Beampos(trial,3,block)] = Screen('Flip', window);


        for frame = 1:isdTimeFrames(trial,block) - 1
            
            Screen('DrawLines', window, allCoords,...
                lineWidthPix, white, [xCenter yCenter], 2);
            
            Screen('Flip', window);
%             vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

        end

        %present stimulus, record key pressed and RT
        
        %determine placement of A and B on screen
        %reuse fingerchooser, reshuffle so subjects can't determine spatial
        %location from rule presentation (even though it means nothing in
        %that condition), record symbol on left side of stimulus screen
        
        fingerchooser = Shuffle(fingerchooser);
        printstim_l2 = symbols(fingerchooser(1)); %prints on left of screen
        printstim_l3 = symbols(fingerchooser(2)); %prints on right of screen
        respMat{6,trial,block} = printstim_l2;
        
        DrawFormattedText(window, printstim_l1, 'center',...
            'center', white);
        DrawFormattedText(window, printstim_l2,...
            screenXpixels*0.25, screenYpixels*0.75, white);
        DrawFormattedText(window, printstim_l3,...
            screenXpixels*0.75, screenYpixels*0.75, white);
        
        [VBLTimestamp(trial,4,block),StimulusOnsetTime(trial,4,block),...
            FlipTimestamp(trial,4,block),Missed(trial,4,block),...
            Beampos(trial,4,block)] = Screen('Flip', window);
        
%         [VBLTimestamp(trial,4,block),StimulusOnsetTime(trial,4,block),...
%             FlipTimestamp(trial,4,block),Missed(trial,4,block),...
%             Beampos(trial,4,block)] = Screen('Flip', window);

        tic
        while respToBeMade == true
            
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
            

        end
        x(trial,block) = toc;
        
        if trial == numtrials && block == numblocks

            DrawFormattedText(window, 'Thanks for playing!',...
                'center', 'center', white);
                [VBLTimestamp(trial,5,block),StimulusOnsetTime(trial,5,block),...
                    FlipTimestamp(trial,5,block),Missed(trial,5,block),...
                    Beampos(trial,5,block)] = Screen('Flip', window);
            KbStrokeWait;
            ShowCursor;
            sca;
            
        elseif trial == numtrials && block ~= numblocks
            
            DrawFormattedText(window, 'Switch Hands \n\n Press Any Key To Continue',...
                'center', 'center', white);
            Screen('Flip', window);
            KbStrokeWait;
            
            if hand == 0
                hand = 1;
            else
                hand = 0;
            end
            
        else
            
            Screen('FillRect',window,black);
            [VBLTimestamp(trial,5,block),StimulusOnsetTime(trial,5,block),...
                FlipTimestamp(trial,5,block),Missed(trial,5,block),...
                Beampos(trial,5,block)] = Screen('Flip', window);
            
            for frame = 1:1:itiTimeFrames - 1
                
                Screen('FillRect',window,black);
                Screen('Flip', window);
                
            end
            
        end
        
    end
    
end






















