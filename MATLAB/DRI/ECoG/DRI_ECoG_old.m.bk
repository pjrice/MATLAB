%DRI paradigm with EMG recordings
%largely selfpaced, unimanual, abstract other rule

%filename?
filename = 'C:\temp_patrick\data\';
filename_append = input('Filename? ','s');
filename = strcat(filename,filename_append);

%base path for images?
% imgbasepath = 'C:\temp_patrick\RP_images\';
imgbasepath = 'P:\data\DRI\RP_images\';

%which hand are we working with?
hand = input('Which hand are we working with? 0 for left, 1 for right: ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
%establish UDP link to TDT RZ box in order to mark timestamps
udpobj = udp('127.0.0.1', 4012); %edit host and port after it's set up

%default output buffer size is 512 bytes, make sure the I/O buffers are large
%enough to handle the data being sent/received
%must set before object is open
% udpobj.OutputBufferSize = 8000; %in bytes

%open udp object
fopen(udpobj)

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----------------------------------------------------------------------
%                       Trial information
%----------------------------------------------------------------------

numblocks = 1;
numtrials = 6;

stimchoices = [2,9];

fingers{1} = 'INDEX';
fingers{2} = 'MIDDLE';
evenodd{1} = 'EVEN';
evenodd{2} = 'ODD';
symbols = ['A' 'B'];

%load images
A_imgloc = strcat(imgbasepath,'A.png');
B_imgloc = strcat(imgbasepath,'B.png');
LI_imgloc = strcat(imgbasepath,'L_Index.png');
LM_imgloc = strcat(imgbasepath,'L_Middle.png');
RI_imgloc = strcat(imgbasepath,'R_Index.png');
RM_imgloc = strcat(imgbasepath,'R_Middle.png');

A_img = imread(A_imgloc);
B_img = imread(B_imgloc);
LI_img = imread(LI_imgloc);
LM_img = imread(LM_imgloc);
RI_img = imread(RI_imgloc);
RM_img = imread(RM_imgloc);

% Make the image into a texture
Symbol_Textures{1} = Screen('MakeTexture', window, A_img);
Symbol_Textures{2} = Screen('MakeTexture', window, B_img);
Finger_Textures{1} = Screen('MakeTexture', window, RI_img);
Finger_Textures{2} = Screen('MakeTexture', window, RM_img);
Finger_Textures{3} = Screen('MakeTexture', window, LI_img);
Finger_Textures{4} = Screen('MakeTexture', window, LM_img);

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

%randomize itis/isis
itis = randi([60 210],numtrials,numblocks);
isis = randi([15 120],numtrials,numblocks);


%randomize trial stuffs
for block = 1:numblocks
    
    %randomize order of condition presentation and record it
    condMatrixtemp = sort(repmat([0 1], 1, numtrials/2));
    condMatrix(:,block) = condMatrixtemp(:,Shuffle(1:numtrials))'; %0==symbols 1==fingers
    
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
spTimeSecs = 5;
spTimeFrames = round(spTimeSecs/ifi);

%ISD
% isdTimeSecs = 2;
% isdTimeFrames = round(isdTimeSecs/ifi);
%we have psuedorandomized ISD (now called isis) to make sure they actually
%know the rule before they proceed; artificially inject some very short
%ISIs at random trials as true checks.

short_isi = 15;

sym_ind = find(condMatrix==0);
fin_ind = find(condMatrix==1);

inj_s = datasample(sym_ind,3,'Replace',false);
inj_f = datasample(fin_ind,3,'Replace',false);

isis(inj_s) = short_isi;
isis(inj_f) = short_isi;

%Number of frames to wait before re-drawing
waitframes = 1;


%----------------------------------------------------------------------
%                       Keyboard information
%----------------------------------------------------------------------

%Defined keyboard keys that are listened for.

keychoices = ['A' 'S'];

escapeKey = KbName('ESCAPE');
aKey = KbName('LeftArrow');  %"aKey" is actually left arrow
sKey = KbName( 'RightArrow');  %"sKey" is actually right arrow
spacebar = KbName('space');

%----------------------------------------------------------------------
%                     Make a response matrix
%----------------------------------------------------------------------

% This is an ntrials x n x nblocks array for event timestamps
%rows are trials, columns:
%1st: trial start
%2nd: first fixation presentation
%3rd: timestamp for early stimulations
%4th: rule presentation
%5th: timestamp of self pacing through rule instruction
%6th: second fixation presentation
%7th: timestamp for late stimulations
%8th: stimulus presentation
%9th: timestamp of subject's response
%10th: ITI presentation
%11th: trial stop
%12th: 

timestamps = nan(numtrials,11,numblocks);

%Timing matrices - VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed,
%Beampos are all output by Screen('Flip') - see 'Screen Flip?' for details.
%Columns are consistent across these five matrices - they are: (1)hold
%period onset; (2)rule presentation onset; (3)delay period onset;
%(4)stimulus presentation onset; (5)ITI onset

% VBLTimestamp = nan(numtrials,5,numblocks);  %is now timestamps
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

%fixation cross coordinates
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];

%additional diagonal line coordinates for asterisk
a1Coords = [-fixCrossDimPix*.75 fixCrossDimPix*.75 -fixCrossDimPix*.75 fixCrossDimPix*.75];
a2Coords = [fixCrossDimPix*.75 -fixCrossDimPix*.75 -fixCrossDimPix*.75 fixCrossDimPix*.75];

%fix==fixation cross; all==asterisk
fixCoords = [xCoords; yCoords];
allCoords = [xCoords a1Coords; yCoords a2Coords];

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
adblData_mat = cell(numtrials,numblocks);
subj_resp = cell(numtrials,numblocks);

%present black screen until subject is ready; press any key to continue
Screen('FillRect',window,black);
Screen('Flip', window);
KbStrokeWait;

%try a couple of different timestamping methods
streamstart_time = GetSecs;
tic
for block = 1:numblocks
    
    for trial = 1:numtrials
        
        fwrite(udpobj,trial,'int8','async');  %trial start - sends trial number so there's a way to track that on braindata
        timestamps(trial,1,block) = GetSecs;
        
        %Cue to determine whether a response has been made
        respToBeMade = true;
        whichButton = 0;
  
        
        
        %Flip again to sync to vertical retrace at same time as drawing
        %fixation cross
        Screen('DrawLines', window, fixCoords,...
            lineWidthPix, white, [xCenter yCenter], 2);
        [timestamps(trial,2,block),StimulusOnsetTime(trial,1,block),...
            FlipTimestamp(trial,1,block),Missed(trial,1,block),...
            Beampos(trial,1,block)] = Screen('Flip', window);
        fwrite(udpobj,2,'int8','async');  %fixation onset
        
        
        
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
        
        %skipping timestamps(trial,3,block) because that was early
        %stimulation timestamp in TMS data
        
        %present rule
        if condMatrix(trial,block) == 0  %0==symbols 1==fingers
            
            DrawFormattedText(window, print_evenodd{trial,block},...
                'center', 'center', white);
            Screen('DrawTexture', window,...
                Symbol_Textures{symbolchooser{trial,block}(1)}, [], dstRect, 0);
            [timestamps(trial,4,block),StimulusOnsetTime(trial,2,block),...
                FlipTimestamp(trial,2,block),Missed(trial,2,block),...
                Beampos(trial,2,block)] = Screen('Flip', window);
            fwrite(udpobj,4,'int8','async');  %rule presentation
            
            spTimeFramescheck = 1;
            
            while respToBeMade == true
                
                DrawFormattedText(window, print_evenodd{trial,block},...
                    'center', 'center', white);
                Screen('DrawTexture', window,...
                    Symbol_Textures{symbolchooser{trial,block}(1)}, [], dstRect, 0);
                Screen('Flip', window);
                
                [keyIsDown,secs, keyCode] = KbCheck;
                
                if keyCode(spacebar)
                    fwrite(udpobj,5,'int8','async');  %rule response
                    respToBeMade = false;
                    timestamps(trial,5,block) = GetSecs;
                    
                elseif keyCode(escapeKey)
                    
                    ShowCursor;
                    sca;
                    return
                    
                end

                spTimeFramescheck = spTimeFramescheck + 1;
                
            end
            
        else
            %fingers
            DrawFormattedText(window, print_evenodd{trial,block},...
                'center', 'center', white);
            Screen('DrawTexture', window,...
                Finger_Textures{fingerchooser{trial,block}(1)}, [], dstRect, 0);
            [timestamps(trial,4,block),StimulusOnsetTime(trial,2,block),...
                FlipTimestamp(trial,2,block),Missed(trial,2,block),...
                Beampos(trial,2,block)] = Screen('Flip', window);
            fwrite(udpobj,4,'int8','async');  %rule presentation
            
            spTimeFramescheck = 1;
            
            while respToBeMade == true
                
                DrawFormattedText(window, print_evenodd{trial,block},...
                    'center', 'center', white);
                Screen('DrawTexture', window,...
                    Finger_Textures{fingerchooser{trial,block}(1)}, [], dstRect, 0);
                Screen('Flip', window);
                
                [keyIsDown,secs, keyCode] = KbCheck;
                
                if keyCode(spacebar)
                    fwrite(udpobj,5,'int8','async');  %rule response
                    respToBeMade = false;
                    timestamps(trial,5,block) = GetSecs;
                    
                elseif keyCode(escapeKey)
                    
                    ShowCursor;
                    sca;
                    return
                    
                end

                spTimeFramescheck = spTimeFramescheck + 1;
                
            end
            
        end
        
        true_SPTF(trial,block) = spTimeFramescheck;
        
        %fixate between rule presentation and stimulus presentation (aka
        %interstimulus delay)
        
        Screen('DrawLines', window, allCoords,...
            lineWidthPix, white, [xCenter yCenter], 2);
        
        [timestamps(trial,6,block),StimulusOnsetTime(trial,3,block),...
            FlipTimestamp(trial,3,block),Missed(trial,3,block),...
            Beampos(trial,3,block)] = Screen('Flip', window);
        fwrite(udpobj,6,'int8','async');  %delay fix
        
        
        for frame = 1:isis(trial,block) - 1
            
            Screen('DrawLines', window, allCoords,...
                lineWidthPix, white, [xCenter yCenter], 2);
            
            Screen('Flip', window);
            
        end
        
        %skipping timestamps(trial,7,block) because that was late
        %stimulation timestamp in TMS data
        
        %present stimulus, record key pressed and RT
        
        respToBeMade = true;
        
        DrawFormattedText(window, printstim_l1(trial,block), 'center',...
            'center', white);
        DrawFormattedText(window, printstim_l2(trial,block),...
            screenXpixels*0.25, screenYpixels*0.75, white);
        DrawFormattedText(window, printstim_l3(trial,block),...
            screenXpixels*0.75, screenYpixels*0.75, white);
        
        [timestamps(trial,8,block),StimulusOnsetTime(trial,4,block),...
            FlipTimestamp(trial,4,block),Missed(trial,4,block),...
            Beampos(trial,4,block)] = Screen('Flip', window);
        fwrite(udpobj,8,'int8','async');  %stimulus presentation
        
        
        spTimeFramescheck = 1;
        
        while respToBeMade == true
            
            [keyIsDown,secs, keyCode] = KbCheck;
            if keyCode(escapeKey)
                subj_resp{trial} = 'Esc';
                ShowCursor;
                sca;
                return
            elseif keyCode(aKey)
                fwrite(udpobj,9,'int8','async');  %stimulus response
                subj_resp{trial} = 'L';
                timestamps(trial,9,block) = secs;
                respToBeMade = false;
            elseif keyCode(sKey)
                fwrite(udpobj,9,'int8','async');  %stimulus response
                subj_resp{trial} = 'R';
                timestamps(trial,9,block) = secs;
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

        Screen('FillRect',window,black);
        [timestamps(trial,10,block),StimulusOnsetTime(trial,5,block),...
            FlipTimestamp(trial,5,block),Missed(trial,5,block),...
            Beampos(trial,5,block)] = Screen('Flip', window);
        fwrite(udpobj,10,'int8','async');  %ITI onset
        
        for frame = 1:1:itis(trial,block) - 1
            
            Screen('FillRect',window,black);
            Screen('Flip', window);
            
        end
        
        disp(trial)
        
        fwrite(udpobj,11,'int8','async');  %trial end
        timestamps(trial,11,block) = GetSecs;  %relative to streamstart_time
        realtime(trial,block) = toc;  %relative to tic
 
    end    
end

DrawFormattedText(window, 'Thanks for playing!',...
    'center', 'center', white);
Screen('Flip', window);

KbStrokeWait;
ShowCursor;
sca;

fclose(udpobj);

clear udpobj

save(filename)