%DRI paradigm with EMG recordings
%largely selfpaced, unimanual, abstract other rule

%filename?
filename = 'C:\data\RR_TMS\data\';
filename_append = input('Filename? ','s');
filename = strcat(filename,filename_append);

%base path for images?
imgbasepath = 'C:\data\RR_TMS\RP_images\';

% %do we want to do a specific number of trials?
% tempnumtrials = input('Do we want to do a specific number of trials (must be even!)? If so, enter the number now, otherwise enter zero: ');
% 
% if tempnumtrials ~= 0;
%     
%     numtrials = tempnumtrials;
%     
% else
%     %how long is a single trial in seconds?
%     trialsecs = input('How long is a single trial in seconds? ');
%     
%     %how many minutes do we want to work?
%     seshlength = input('How many minutes do we want to work? ');
%     
%     %EZ trial num w/ given trial length and session length
%     %# of trials must be even due to poor choices in the past that I don't feel
%     %like fixing, so if numtrials is odd, subtract 1
%     numtrials = floor((seshlength*60)/trialsecs);
%     if mod(numtrials,2)==1
%         numtrials = numtrials-1;
%     end
% end

%which hand are we working with?
% hand = input('Which hand are we working with? 0 for left, 1 for right: ');
hand = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Make serial port visible to send TMS trigger command to magstim

magstim = serial('COM1', 'BaudRate', 9600, 'DataBits', 8, 'StopBits', 1, 'Parity', 'none', 'FlowControl', 'none', 'Terminator', '?');
fopen(magstim);

        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%setup LabJack U3
ljasm = NET.addAssembly('LJUDDotNet'); %Make the UD .NET assembly visible in MATLAB
ljudObj = LabJack.LabJackUD.LJUD;

i = 0;
k = 0;
ioType = 0;
channel = 0;
dblValue = 0;
dblCommBacklog = 0;
dblUDBacklog = 0;
scanRate = 3000;
% delay = 15; %in seconds - this is the maximum possible trial length
% numScans = 2*scanRate*delay;  %2x the expected # of scans
numScansRequested = 0;
% Variables to satisfy certain method signatures
dummyInt = 0;
dummyDouble = 0;
dummyDoubleArray = [0];

%Open the first found LabJack U3.
[ljerror, ljhandle] = ljudObj.OpenLabJack(LabJack.LabJackUD.DEVICE.U3, LabJack.LabJackUD.CONNECTION.USB, '0', true, 0);

%Start by using the pin_configuration_reset IOType so that all
%pin assignments are in the factory default condition.
ljudObj.ePut(ljhandle, LabJack.LabJackUD.IO.PIN_CONFIGURATION_RESET, 0, 0, 0);

%Configure FIO0 and FIO1  as analog, all else as digital.
%pass a value of b0000000000000011
%Note that for the last parameter we are forcing the value to an int32
%to ensure MATLAB converts the parameters correctly and uses the proper
%function overload.
ljudObj.ePut(ljhandle, LabJack.LabJackUD.IO.PUT_ANALOG_ENABLE_PORT, 0, 3, int32(16)); %chan 0 only

%Configure the stream:
%Set the scan rate.
ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.PUT_CONFIG, LabJack.LabJackUD.CHANNEL.STREAM_SCAN_FREQUENCY, scanRate, 0, 0);

%Give the driver a 30 second buffer (scanRate * 2 channels * 30 seconds).
%NOTE: REFINE BUFFER DURATION
ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.PUT_CONFIG, LabJack.LabJackUD.CHANNEL.STREAM_BUFFER_SIZE, scanRate*2*900, 0, 0);

%Configure reads to retrieve whatever data is available without waiting (wait mode LJ_swNONE).
LJ_swNONE = ljudObj.StringToConstant('LJ_swNONE');
ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.PUT_CONFIG, LabJack.LabJackUD.CHANNEL.STREAM_WAIT_MODE, LJ_swNONE, 0, 0);

%Define the scan list as AIN0 (defined above with PUT_ANALOG_ENABLE_PORT).
ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.CLEAR_STREAM_CHANNELS, 0, 0, 0, 0);
ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.ADD_STREAM_CHANNEL, 0, 0, 0, 0);
ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.ADD_STREAM_CHANNEL, 1, 0, 0, 0);

%Execute the list of requests.
ljudObj.GoOne(ljhandle);

%Get all the results just to check for errors.
    [ljerror, ioType, channel, dblValue, dummyInt, dummyDbl] = ljudObj.GetFirstResult(ljhandle, ioType, channel, dblValue, dummyInt, dummyDouble);
    finished = false;
    while finished == false
        try
            [ljerror, ioType, channel, dblValue, dummyInt, dummyDbl] = ljudObj.GetNextResult(ljhandle, ioType, channel, dblValue, dummyInt, dummyDouble);
        catch e
            if(isa(e, 'NET.NetException'))
                eNet = e.ExceptionObject;
                if(isa(eNet, 'LabJack.LabJackUD.LabJackUDException'))
                    if(eNet.LJUDError == LabJack.LabJackUD.LJUDERROR.NO_MORE_DATA_AVAILABLE)
                        finished = true;
                    end
                end
            end
            %Report non NO_MORE_DATA_AVAILABLE error.
            if(finished == false)
                throw(e)
            end
        end
    end

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
numtrials = 60;

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


%pseudorandomize early/late/no stim trials so that each occurs in a stretch
%of three trials but the order within that "block" is randomized
rpspns = zeros(numtrials,numblocks);

for y = 1:numblocks
    
    for z = 1:3:length(rpspns)-2
        
        rpspns(z:z+2,y) = Shuffle([0;1;2]);  %0==early; 1==late; 2==no stim
        
    end
end


chooser = [1 2];

%randomize itis/isis (not the fuccboi kind)
itis = randi([300 480],numtrials,numblocks);
isis = randi([15 120],numtrials,numblocks);
%get second set of longer itis in the case of late->early stimulation
long_itis = randi([480 540],numtrials,numblocks);

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

%MAKE SURE SHORTER ISIS ARE ACCOUNTED FOR IN THE ITIS - CURRENTLY ASSUMED
%DELAY IS 2 SECONDS, SO MAKING IT SHORTER RISKS BAD STIM INTERVALS

%max trial length for length of EMG recordings
% max_tlength = holdTimeSecs + 2*spTimeSecs + isdTimeSecs + 1;  %seconds; CHANGE VALUE 'DELAY' ABOVE FOR EMG
% max_tlength_frames = round(max_tlength/ifi);  %frames

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

% Start the EMG data stream.
[ljerror, dblValue] = ljudObj.eGet(ljhandle, LabJack.LabJackUD.IO.START_STREAM, 0, 0, 0);

%try a couple of different timestamping methods
streamstart_time = GetSecs;
tic
for block = 1:numblocks
    
    for trial = 1:numtrials
        
        timestamps(trial,1,block) = GetSecs;
        
        %Cue to determine whether a response has been made
        respToBeMade = true;
        
        whichButton = 0;
        
        %record the hand that is being used
        respMat{1,trial,block} = hand;
        
        %Flip again to sync to vertical retrace at same time as drawing
        %fixation cross
        Screen('DrawLines', window, fixCoords,...
            lineWidthPix, white, [xCenter yCenter], 2);
        [timestamps(trial,2,block),StimulusOnsetTime(trial,1,block),...
            FlipTimestamp(trial,1,block),Missed(trial,1,block),...
            Beampos(trial,1,block)] = Screen('Flip', window);
        
        
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
        
        %present rule
        
        if rpspns(trial,block)==0
            
            fwrite(magstim,0)  %trigger TMS as soon as rule is presented
            timestamps(trial,3,block) = GetSecs;
            timestamps(trial,7,block) = nan;
            
        end
        %
        if condMatrix(trial,block) == 0  %0==symbols 1==fingers
            
            DrawFormattedText(window, print_evenodd{trial,block},...
                'center', 'center', white);
            Screen('DrawTexture', window,...
                Symbol_Textures{symbolchooser{trial,block}(1)}, [], dstRect, 0);
            [timestamps(trial,4,block),StimulusOnsetTime(trial,2,block),...
                FlipTimestamp(trial,2,block),Missed(trial,2,block),...
                Beampos(trial,2,block)] = Screen('Flip', window);
            
            spTimeFramescheck = 1;
            
            while respToBeMade == true && spTimeFramescheck<spTimeFrames
                
                DrawFormattedText(window, print_evenodd{trial,block},...
                    'center', 'center', white);
                Screen('DrawTexture', window,...
                    Symbol_Textures{symbolchooser{trial,block}(1)}, [], dstRect, 0);
                Screen('Flip', window);
                
                [keyIsDown,secs, keyCode] = KbCheck;
                
                if spTimeFramescheck>30 && keyCode(spacebar)
                    
                    respToBeMade = false;
                    timestamps(trial,5,block) = GetSecs;
                    
                elseif spTimeFramescheck>30 && keyCode(escapeKey)
                    
                    ShowCursor;
                    sca;
                    return
                    
                end
                
                spTimeFramescheck = spTimeFramescheck + 1;
                
            end
            
        else  %fingers
            
            DrawFormattedText(window, print_evenodd{trial,block},...
                'center', 'center', white);
            Screen('DrawTexture', window,...
                Finger_Textures{fingerchooser{trial,block}(1)}, [], dstRect, 0);
            [timestamps(trial,4,block),StimulusOnsetTime(trial,2,block),...
                FlipTimestamp(trial,2,block),Missed(trial,2,block),...
                Beampos(trial,2,block)] = Screen('Flip', window);
            
            spTimeFramescheck = 1;
            
            while respToBeMade == true && spTimeFramescheck<spTimeFrames
                
                DrawFormattedText(window, print_evenodd{trial,block},...
                    'center', 'center', white);
                Screen('DrawTexture', window,...
                    Finger_Textures{fingerchooser{trial,block}(1)}, [], dstRect, 0);
                Screen('Flip', window);
                
                [keyIsDown,secs, keyCode] = KbCheck;
                
                if spTimeFramescheck>30 && keyCode(spacebar)
                    
                    respToBeMade = false;
                    timestamps(trial,5,block) = GetSecs;
                    
                elseif spTimeFramescheck>30 && keyCode(escapeKey)
                    
                    ShowCursor;
                    sca;
                    return
                    
                end
                
                spTimeFramescheck = spTimeFramescheck + 1;
                
            end
            
        end
        
        true_SPTF(trial,block) = spTimeFramescheck;
        
        if true_SPTF(trial,block)==spTimeFrames
            
            Screen('FillRect',window,red);
            DrawFormattedText(window, 'Warning! No response detected! \n \n Press any key to continue',...
                'center', 'center', white);
            Screen('Flip', window);
            KbStrokeWait;
            
            Screen('FillRect',window,black);
            Screen('Flip', window);
            
            for frame = 1:480 - 1
                
                Screen('FillRect',window,black);
                Screen('Flip', window);
                
            end
            
            continue
        end
        
        %fixate between rule presentation and stimulus presentation (aka
        %interstimulus delay)
        
        Screen('DrawLines', window, allCoords,...
            lineWidthPix, white, [xCenter yCenter], 2);
        
        [timestamps(trial,6,block),StimulusOnsetTime(trial,3,block),...
            FlipTimestamp(trial,3,block),Missed(trial,3,block),...
            Beampos(trial,3,block)] = Screen('Flip', window);
        
        
        for frame = 1:isis(trial,block) - 1
            
            Screen('DrawLines', window, allCoords,...
                lineWidthPix, white, [xCenter yCenter], 2);
            
            Screen('Flip', window);
            
        end
        
        %present stimulus, record key pressed and RT
        
        respToBeMade = true;
        
        if rpspns(trial,block)==1
            
            fwrite(magstim,0)  %trigger TMS as soon as stimulus is presented
            timestamps(trial,7,block) = GetSecs;
            timestamps(trial,3,block) = nan;
            
        end
        
        DrawFormattedText(window, printstim_l1(trial,block), 'center',...
            'center', white);
        DrawFormattedText(window, printstim_l2(trial,block),...
            screenXpixels*0.25, screenYpixels*0.75, white);
        DrawFormattedText(window, printstim_l3(trial,block),...
            screenXpixels*0.75, screenYpixels*0.75, white);
        
        [timestamps(trial,8,block),StimulusOnsetTime(trial,4,block),...
            FlipTimestamp(trial,4,block),Missed(trial,4,block),...
            Beampos(trial,4,block)] = Screen('Flip', window);
        
        
        spTimeFramescheck = 1;
        
        while respToBeMade == true && spTimeFramescheck<spTimeFrames-1
            
            [keyIsDown,secs, keyCode] = KbCheck;
            if keyCode(escapeKey) && spTimeFramescheck>30
                subj_resp{trial} = 'Esc';
                timestamps(trial,9,block) = secs;
                ShowCursor;
                sca;
                return
            elseif keyCode(aKey) && spTimeFramescheck>30
                subj_resp{trial} = 'L';
                timestamps(trial,9,block) = secs;
                respToBeMade = false;
            elseif keyCode(sKey) && spTimeFramescheck>30
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
        
        %determine length of ITI based off of trial timing so that
        %total length of trial is 10 seconds
        
        time_passed(trial,block) = holdTimeFrames+true_SPTF(trial,block)+isis(trial,block)+true_RPTF(trial,block);  %in frames
        
        time_passed_secs(trial,block) = time_passed(trial,block)*(1/60);
        tps_ceil(trial,block) = ceil(time_passed_secs(trial,block));
        time_offset(trial,block) = (tps_ceil(trial,block) - time_passed_secs(trial,block))/(1/60); %this is the number of frames to add to time_passed to make time_passed be a whole number of seconds
        
        %             time_offset(trial,block) = (ceil(time_passed(trial,block)*ifi) - time_passed(trial,block)*ifi)/ifi;
        
        %     time_remaining(trial,block) = time_offset(trial,block) + 60;
        
        if trial<numtrials && rpspns(trial,block)==1 && rpspns(trial+1,block)==0
            
            time_remaining(trial,block) = time_offset(trial,block) + (120-isis(trial,block)) + long_itis(trial,block);
            
        else
            
            time_remaining(trial,block) = time_offset(trial,block) + (120-isis(trial,block)) + itis(trial,block);
            
        end
        
        Screen('FillRect',window,black);
        [timestamps(trial,10,block),StimulusOnsetTime(trial,5,block),...
            FlipTimestamp(trial,5,block),Missed(trial,5,block),...
            Beampos(trial,5,block)] = Screen('Flip', window);
        
        for frame = 1:1:time_remaining(trial,block) - 1
            
            Screen('FillRect',window,black);
            Screen('Flip', window);
            
        end
        
        if rpspns(trial,block)==2
            
            timestamps(trial,3,block) = nan;
            timestamps(trial,7,block) = nan;
            
        end
        
        delay = (time_passed(trial,block)+time_remaining(trial,block))*(1/60); %in seconds - this was the length of the trial
        numScans = 2*scanRate*delay;  %2x the expected # of scans
        
        %Init array to store EMG data
        adblData = NET.createArray('System.Double', 2*numScans);  %Max buffer size (#channels*numScansRequested)
        
        %Read the data.  We will request twice the number we expect, to
        %make sure we get everything that is available.
        %Note that the array we pass must be sized to hold enough SAMPLES, and
        %the Value we pass specifies the number of SCANS to read.
        numScansRequested = int32(numScans);
        %Use eGetPtr when reading arrays in 64-bit applications. Also
        %works for 32-bits.
        [ljerror, numScansRequested(trial,block)] = ljudObj.eGetPtr(ljhandle, LabJack.LabJackUD.IO.GET_STREAM_DATA, LabJack.LabJackUD.CHANNEL.ALL_CHANNELS, numScansRequested, adblData);
        
        %Retrieve the current backlog.  The UD driver retrieves stream data from
        %the U3 in the background, but if the computer is too slow for some reason
        %the driver might not be able to read the data as fast as the U3 is
        %acquiring it, and thus there will be data left over in the U3 buffer.
        [ljerror, dblCommBacklog] = ljudObj.eGet(ljhandle, LabJack.LabJackUD.IO.GET_CONFIG, LabJack.LabJackUD.CHANNEL.STREAM_BACKLOG_COMM, dblCommBacklog, dummyDoubleArray);
        disp(['Comm Backlog = ' num2str(dblCommBacklog)])
        
        [ljerror, dblUDBacklog] = ljudObj.eGet(ljhandle, LabJack.LabJackUD.IO.GET_CONFIG, LabJack.LabJackUD.CHANNEL.STREAM_BACKLOG_UD, dblUDBacklog, dummyDoubleArray);
        disp(['UD Backlog = ' num2str(dblUDBacklog) sprintf('\n')])
        
        adblData_mat{trial,block} = adblData.double;
        
        clear adblData
    
        disp(trial)
        
        timestamps(trial,11,block) = GetSecs;  %relative to streamstart_time
        realtime(trial,block) = toc;  %relative to tic
 
    end
    
    
    if block<numblocks
        
        %wait for me to fuck with the coil you mark-ass trick
        DrawFormattedText(window, 'Please wait!',...
            'center', 'center', white);
        Screen('Flip', window);
        
        KbStrokeWait;
        
        DrawFormattedText(window, 'Are you sure you want to continue?',...
            'center', 'center', white);
        Screen('Flip', window);
        
        %Stop the EMG data stream.
        [ljerror, dblValue] = ljudObj.eGet(ljhandle, LabJack.LabJackUD.IO.STOP_STREAM, 0, 0, 0);
        
        KbStrokeWait;
        
    end
    
    
end

fclose(magstim);

DrawFormattedText(window, 'Thanks for playing!',...
    'center', 'center', white);
Screen('Flip', window);

KbStrokeWait;
ShowCursor;
sca;

clear e eNet ljasm ljerror ljudObj magstim

save(filename)