%DRI paradigm with EMG recordings
%largely selfpaced, unimanual, abstract other rule

%filename?
% filename = 'C:\temp_patrick\data\';
% filename_append = input('Filename? ','s');
% filename = strcat(filename,filename_append);

%base path for images?
% imgbasepath = 'C:\temp_patrick\RP_images\';
imgbasepath = 'Z:\data\DRI\RP_images\';
% imgbasepath = 'Z:\Work\UW\projects\RR_TMS\RP_images\';

%which hand are we working with?
hand = input('Which hand are we working with? 0 for left, 1 for right: ');

prac_cond = input('Practice which condition? 0==Symbols; 1==Fingers: ');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
%establish UDP link to TDT RZ box in order to mark timestamps
% udpobj = udp('127.0.0.1', 4012); %edit host and port after it's set up

%default output buffer size is 512 bytes, make sure the I/O buffers are large
%enough to handle the data being sent/received
%must set before object is open
% udpobj.OutputBufferSize = 8000; %in bytes

%open udp object
% fopen(udpobj)

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

if hand==1
    
    Finger_Textures{1} = Screen('MakeTexture', window, RI_img);
    Finger_Textures{2} = Screen('MakeTexture', window, RM_img);
    
elseif hand==0
    
    Finger_Textures{1} = Screen('MakeTexture', window, LI_img);
    Finger_Textures{2} = Screen('MakeTexture', window, LM_img);
    
else
    
    error('Hand variable set incorrectly!');
    
end

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----------------------------------------------------------------------
%                       Trial information
%----------------------------------------------------------------------

numtrials = 160;
% numtrials = 160;
numblocks = 2;

fingers{1} = 'INDEX';
fingers{2} = 'MIDDLE';
evenodd{1} = 'EVEN';
evenodd{2} = 'ODD';
symbols = ['A' 'B'];

%establish base vectors to repmat into proper size
%possible stimulus values
% stimchoices = repmat([2:9]',4,1);
stimchoices = repmat([2:9]',1,1);

%even/odd presentation
  %1==Even
evenoddchooser = repmat(cat(1,sort(repmat([1 2]',...
    length(stimchoices)/8,numblocks)),flipud(sort(repmat([1 2]',...
    length(stimchoices)/8,numblocks)))),2,1);

%A/B presentation; index/middle presentation
  %1==A or Index
symfinchooser = cat(1,repmat([1 1 2 2]',...
    length(stimchoices)/8,numblocks/2),flipud(repmat([1 1 2 2]',...
    length(stimchoices)/8,numblocks/2))); 

%placement of A and B on stimulus screen
%generate a set for each block because letter placement occurs in finger
%condition (even though it's meaningless)
  %1==A
abchooser = sort(repmat([1 2]',numtrials/2,numblocks));

%repmat base vectors to proper size
stimuli = repmat(stimchoices,numtrials/length(stimchoices),numblocks);
evenoddchooser = repmat(evenoddchooser,numtrials/length(evenoddchooser),numblocks/2);
symfinchooser = repmat(symfinchooser,numtrials/length(symfinchooser),numblocks/2);

%Shuffle the stimuli, then use the index of the shuffle to move the rest
%into the same postions (so trial presentation is randomized, but we don't
%lose our balancing)
%Shuffle shuffles columns of stimuli(trialXblock), s_index is index of
%shuffles for each column (aka each set of trials for a block)
[stimuli,s_index] = Shuffle(stimuli);
evenoddchooser = evenoddchooser(s_index);
symbolchooser = symfinchooser(s_index(:,1));
fingerchooser = symfinchooser(s_index(:,2));
abchooser = abchooser(s_index);

%generate "antiABchooser" to print the other character
for i = 1:numblocks
    
    for ii = 1:numtrials
        
        if abchooser(ii,i)==1
            
            antiabchooser(ii,i) = 2;
            
        else
            
            antiabchooser(ii,i) = 1;
            
        end
        
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%print stuff        
print_evenodd = evenodd(evenoddchooser);  
printstim_l1 = num2str(stimuli,'%1d');  
printstim_l2 = symbols(abchooser);
printstim_l3 = symbols(antiabchooser);


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

%Number of frames to wait before re-drawing
waitframes = 1;

%randomize itis/isis
itis = randi([60 210],numtrials,numblocks);
isis = randi([15 120],numtrials,numblocks);

%ISD
% isdTimeSecs = 2;
% isdTimeFrames = round(isdTimeSecs/ifi);
%we have psuedorandomized ISD (now called isis) to make sure they actually
%know the rule before they proceed; artificially inject some very short
%ISIs at random trials as true checks.

% short_isi = 15;
% 
% sym_ind = find(condMatrix==0);
% fin_ind = find(condMatrix==1);
% 
% inj_s = datasample(sym_ind,3,'Replace',false);
% inj_f = datasample(fin_ind,3,'Replace',false);
% 
% isis(inj_s) = short_isi;
% isis(inj_f) = short_isi;


%----------------------------------------------------------------------
%                       Keyboard information
%----------------------------------------------------------------------

%Defined keyboard keys that are listened for.

keychoices = ['A' 'S'];

escapeKey = KbName('ESCAPE');

if hand==1
    
    aKey = KbName('LeftArrow');  %"aKey" is actually left arrow
    sKey = KbName( 'RightArrow');  %"sKey" is actually right arrow
    spacebar = KbName('space');
    
elseif hand==0
    
    aKey = KbName('a');  %"aKey" is actually left arrow
    sKey = KbName( 'd');  %"sKey" is actually right arrow
    spacebar = KbName('Return');
    
else
    
    error('Hand variable set incorrectly!');
    
end

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
for block = 1
    
    for trial = 1:numtrials
        
%         fwrite(udpobj,trial,'int8','async');  %trial start - sends trial number so there's a way to track that on braindata
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
%         fwrite(udpobj,2,'int8','async');  %fixation onset

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
        if mod(block,2) == prac_cond
            
            DrawFormattedText(window, print_evenodd{trial,block},...
                'center', 'center', white);
            Screen('DrawTexture', window,...
                Finger_Textures{fingerchooser(trial)}, [], dstRect, 0);
            [timestamps(trial,4,block),StimulusOnsetTime(trial,2,block),...
                FlipTimestamp(trial,2,block),Missed(trial,2,block),...
                Beampos(trial,2,block)] = Screen('Flip', window);
%             fwrite(udpobj,4,'int8','async');  %rule presentation
            
            spTimeFramescheck = 1;
            
            while respToBeMade == true
                
                DrawFormattedText(window, print_evenodd{trial,block},...
                    'center', 'center', white);
                Screen('DrawTexture', window,...
                    Finger_Textures{fingerchooser(trial)}, [], dstRect, 0);
                Screen('Flip', window);
                
                [keyIsDown,secs, keyCode] = KbCheck;
                
                if keyCode(spacebar)
%                     fwrite(udpobj,5,'int8','async');  %rule response
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

            DrawFormattedText(window, print_evenodd{trial,block},...
                'center', 'center', white);
            Screen('DrawTexture', window,...
                Symbol_Textures{symbolchooser(trial)}, [], dstRect, 0);
            [timestamps(trial,4,block),StimulusOnsetTime(trial,2,block),...
                FlipTimestamp(trial,2,block),Missed(trial,2,block),...
                Beampos(trial,2,block)] = Screen('Flip', window);
%             fwrite(udpobj,4,'int8','async');  %rule presentation
            
            spTimeFramescheck = 1;
            
            while respToBeMade == true
                
                DrawFormattedText(window, print_evenodd{trial,block},...
                    'center', 'center', white);
                Screen('DrawTexture', window,...
                    Symbol_Textures{symbolchooser(trial)}, [], dstRect, 0);
                Screen('Flip', window);
                
                [keyIsDown,secs, keyCode] = KbCheck;
                
                if keyCode(spacebar)
%                     fwrite(udpobj,5,'int8','async');  %rule response
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
%         fwrite(udpobj,6,'int8','async');  %delay fix
        
        
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
%         fwrite(udpobj,8,'int8','async');  %stimulus presentation
        
        
        spTimeFramescheck = 1;
        
        while respToBeMade == true
            
            [keyIsDown,secs, keyCode] = KbCheck;
            if keyCode(escapeKey)
                subj_resp{trial,block} = 'Esc';
                ShowCursor;
                sca;
                return
            elseif keyCode(aKey)
%                 fwrite(udpobj,9,'int8','async');  %stimulus response
                subj_resp{trial,block} = 'L';
                timestamps(trial,9,block) = secs;
                respToBeMade = false;
            elseif keyCode(sKey)
%                 fwrite(udpobj,9,'int8','async');  %stimulus response
                subj_resp{trial,block} = 'R';
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
%         fwrite(udpobj,10,'int8','async');  %ITI onset
        
        for frame = 1:1:itis(trial,block) - 1
            
            Screen('FillRect',window,black);
            Screen('Flip', window);
            
        end
        
        disp(trial)
        
%         fwrite(udpobj,11,'int8','async');  %trial end
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

% fclose(udpobj);

clear udpobj
