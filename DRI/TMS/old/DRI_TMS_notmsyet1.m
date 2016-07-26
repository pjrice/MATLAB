%DRI paradigm with EMG recordings
%largely selfpaced, unimanual, abstract other rule

%filename?
filename = input('Filename? Full Path+.mat! ','s');

%base path for images?
% imgbasepath = input('Base path for image? Including the last wack! ','s');
imgbasepath = 'C:\Users\ausma_000\Desktop\RR_Project\RP_images\';

%do we want to do a specific number of trials?
tempnumtrials = input('Do we want to do a specific number of trials (must be even!)? If so, enter the number now, otherwise enter zero: ');

if tempnumtrials ~= 0;
    
    numtrials = tempnumtrials;
    
else
    %how long is a single trial in seconds?
    trialsecs = input('How long is a single trial in seconds? ');
    
    %how many minutes do we want to work?
    seshlength = input('How many minutes do we want to work? ');
    
    %EZ trial num w/ given trial length and session length
    %# of trials must be even due to poor choices in the past that I don't feel
    %like fixing, so if numtrials is odd, subtract 1
    numtrials = floor((seshlength*60)/trialsecs);
    if mod(numtrials,2)==1
        numtrials = numtrials-1;
    end
end

%which hand are we working with?
hand = input('Which hand are we working with? 0 for left, 1 for right: ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Make serial port visible to send TMS trigger command to magstim

% magstim = serial('COM1', 'BaudRate', 9600, 'DataBits', 8, 'StopBits', 1, 'Parity', 'none', 'FlowControl', 'none', 'Terminator', '?');
% fopen(magstim);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
delay = 24; %in seconds - this is the maximum possible trial length
numScans = 2*scanRate*delay;  %2x the expected # of scans
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
ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.PUT_CONFIG, LabJack.LabJackUD.CHANNEL.STREAM_BUFFER_SIZE, scanRate*2*30, 0, 0);

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

%----------------------------------------------------------------------
%                       Trial information
%----------------------------------------------------------------------

numblocks = 1;
%number of trials gotten above in prompts
stimchoices = [1,9];

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

rpsp = zeros(1,numtrials);
rpsp(numtrials/2+1:end) = 1;

chooser = [1 2];

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
        
        %decide which trials are rTMS before rule presentation and which
        %trials are rTMS before stimulus presentation
        %0==TMS before RP; 1==TMS before SP
        rpspchooser(:,block) = Shuffle(rpsp)';
        
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
spTimeSecs = 10;
spTimeFrames = round(spTimeSecs/ifi);

%ISD
isdTimeSecs = 2;
isdTimeFrames = round(isdTimeSecs/ifi);

%max trial length for length of EMG recordings
max_tlength = holdTimeSecs + 2*spTimeSecs + isdTimeSecs + 1;  %seconds; CHANGE VALUE 'DELAY' ABOVE FOR EMG
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
adblData_mat = zeros(numtrials,2*numScans,numblocks);

%present black screen until subject is ready; press any key to continue
Screen('FillRect',window,black);
Screen('Flip', window);
KbStrokeWait;

%Start the EMG data stream.
[ljerror, dblValue] = ljudObj.eGet(ljhandle, LabJack.LabJackUD.IO.START_STREAM, 0, 0, 0);

%try a couple of different timestamping methods
streamstart_time = GetSecs;
tic
for block = 1:numblocks
    
    for trial = 1:numtrials
        
        if rpspchooser(trial,block)==0  %TMS before rule presentation
            
            trialstart_time(trial,block) = GetSecs;
            
            %Cue to determine whether a response has been made
            respToBeMade = true;
            
            %record the hand that is being used
            respMat{1,trial,block} = hand;
            
            %Flip again to sync to vertical retrace at same time as drawing
            %fixation cross
            Screen('DrawLines', window, fixCoords,...
                lineWidthPix, white, [xCenter yCenter], 2);
            [VBLTimestamp(trial,1,block),StimulusOnsetTime(trial,1,block),...
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
            
%             fwrite(magstim,0)  %trigger TMS as soon as rule is presented
            
            if condMatrix(trial,block) == 0  %0==symbols 1==fingers
                
                DrawFormattedText(window, print_evenodd{trial,block},...
                    'center', 'center', white);
                Screen('DrawTexture', window,...
                    Symbol_Textures{symbolchooser{trial,block}(1)}, [], dstRect, 0);
                [VBLTimestamp(trial,2,block),StimulusOnsetTime(trial,2,block),...
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
                        
                    end
                    
                    spTimeFramescheck = spTimeFramescheck + 1;
                    
                end
                
            else  %fingers
                
                DrawFormattedText(window, print_evenodd{trial,block},...
                    'center', 'center', white);
                Screen('DrawTexture', window,...
                    Finger_Textures{fingerchooser{trial,block}(1)}, [], dstRect, 0);
                [VBLTimestamp(trial,2,block),StimulusOnsetTime(trial,2,block),...
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
                        
                    end
                    
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
            
            %determine length of ITI based off of trial timing so that
            %total length of trial is 10 seconds
            
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
            
            trialstop_time(trial,block) = GetSecs;  %relative to streamstart_time
            realtime(trial,block) = toc;  %relative to tic
            
            %Init array to store EMG data
                    adblData = NET.createArray('System.Double', 2*numScans);  %Max buffer size (#channels*numScansRequested)
            
                    %Read the data.  We will request twice the number we expect, to
                    %make sure we get everything that is available.
                    %Note that the array we pass must be sized to hold enough SAMPLES, and
                    %the Value we pass specifies the number of SCANS to read.
                    numScansRequested = numScans;
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
            
                    adblData_mat(trial,:,block) = adblData.double;
            
                    clear adblData
            
            
            
        else  %TMS before stim presentation
            
            
            trialstart_time(trial,block) = GetSecs;
            
            %Cue to determine whether a response has been made
            respToBeMade = true;
            
            %record the hand that is being used
            respMat{1,trial,block} = hand;
            
            %Flip again to sync to vertical retrace at same time as drawing
            %fixation cross
            Screen('DrawLines', window, fixCoords,...
                lineWidthPix, white, [xCenter yCenter], 2);
            [VBLTimestamp(trial,1,block),StimulusOnsetTime(trial,1,block),...
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
                
                while respToBeMade == true && spTimeFramescheck<spTimeFrames
                    
                    DrawFormattedText(window, print_evenodd{trial,block},...
                        'center', 'center', white);
                    Screen('DrawTexture', window,...
                        Symbol_Textures{symbolchooser{trial,block}(1)}, [], dstRect, 0);
                    Screen('Flip', window);
                    
                    [keyIsDown,secs, keyCode] = KbCheck;
                    
                    if spTimeFramescheck>30 && keyCode(spacebar)
                        
                        respToBeMade = false;
                        
                    end
                    
                    spTimeFramescheck = spTimeFramescheck + 1;
                    
                end
                
            else  %fingers
                
                DrawFormattedText(window, print_evenodd{trial,block},...
                    'center', 'center', white);
                Screen('DrawTexture', window,...
                    Finger_Textures{fingerchooser{trial,block}(1)}, [], dstRect, 0);
                [VBLTimestamp(trial,2,block),StimulusOnsetTime(trial,2,block),...
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
                        
                    end
                    
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
            
%             fwrite(magstim,0)  %trigger TMS as soon as stimulus is presented
            
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
            
            %determine length of ITI based off of trial timing so that
            %total length of trial is 10 seconds
            
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
            
            
            trialstop_time(trial,block) = GetSecs;  %relative to streamstart_time
            realtime(trial,block) = toc;  %relative to tic
            
            %Init array to store EMG data
                    adblData = NET.createArray('System.Double', 2*numScans);  %Max buffer size (#channels*numScansRequested)
            
                    %Read the data.  We will request twice the number we expect, to
                    %make sure we get everything that is available.
                    %Note that the array we pass must be sized to hold enough SAMPLES, and
                    %the Value we pass specifies the number of SCANS to read.
                    numScansRequested = numScans;
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
            
                    adblData_mat(trial,:,block) = adblData.double;
            
                    clear adblData
            
        end
        

        
    end
    
end

% fclose(magstim);

DrawFormattedText(window, 'Thanks for playing!',...
    'center', 'center', white);
Screen('Flip', window);

KbStrokeWait;
ShowCursor;
sca;

clear e eNet ljasm ljerror ljudObj magstim

save(filename)