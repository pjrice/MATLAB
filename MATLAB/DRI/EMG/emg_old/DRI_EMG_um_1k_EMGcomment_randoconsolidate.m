%DRI paradigm with EMG recordings
%largely selfpaced, unimanual, abstract other rule

clear %Clear the MATLAB variables

%which hand are we working with?

hand = input('Which hand are we working with? 0 for left, 1 for right: ');

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
numScans = 144000;  %2x the expected # of scans (2*scanRate*delayms/1000)
numScansRequested = 0;
loopAmount = 1; %Number of times to loop and read stream data
% Variables to satisfy certain method signatures
dummyInt = 0;
dummyDouble = 0;
dummyDoubleArray = [0];

%Open the first found LabJack U3.
[ljerror, ljhandle] = ljudObj.OpenLabJack(LabJack.LabJackUD.DEVICE.U3, LabJack.LabJackUD.CONNECTION.USB, '0', true, 0);

%Start by using the pin_configuration_reset IOType so that all
%pin assignments are in the factory default condition.
ljudObj.ePut(ljhandle, LabJack.LabJackUD.IO.PIN_CONFIGURATION_RESET, 0, 0, 0);

%Configure FIO0  as analog, all else as digital.
%pass a value of b0000000000000001
%Note that for the last parameter we are forcing the value to an int32
%to ensure MATLAB converts the parameters correctly and uses the proper
%function overload.
ljudObj.ePut(ljhandle, LabJack.LabJackUD.IO.PUT_ANALOG_ENABLE_PORT, 0, 1, int32(16)); %chan 0 only

%Configure the stream:
%Set the scan rate.
ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.PUT_CONFIG, LabJack.LabJackUD.CHANNEL.STREAM_SCAN_FREQUENCY, scanRate, 0, 0);

%Give the driver a 30 second buffer (scanRate * 1 channels * 30 seconds).
%NOTE: REFINE BUFFER DURATION
ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.PUT_CONFIG, LabJack.LabJackUD.CHANNEL.STREAM_BUFFER_SIZE, scanRate*1*30, 0, 0);

%Configure reads to retrieve whatever data is available without waiting (wait mode LJ_swNONE).
LJ_swNONE = ljudObj.StringToConstant('LJ_swNONE');
ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.PUT_CONFIG, LabJack.LabJackUD.CHANNEL.STREAM_WAIT_MODE, LJ_swNONE, 0, 0);

%Define the scan list as AIN0 (defined above with PUT_ANALOG_ENABLE_PORT).
ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.CLEAR_STREAM_CHANNELS, 0, 0, 0, 0);
ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.ADD_STREAM_CHANNEL, 0, 0, 0, 0);

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

% %Number of blocks
% numblocks = 1;
% 
% %Number of trials per block
% %USE THIS AS AN EQUIVALENT TO LOOPAMOUNT IN ORDER TO GET AN EMG TRACE PER
% %TRIAL
% numtrials = 8;
% 
% %make matrix of condition combinations (symbol/finger)
% condMatrixBase = sort(repmat([0 1], 1, numtrials/2));
% 
% %make string arrays for randomized motor responses
% fingers{1} = 'INDEX';
% fingers{2} = 'MIDDLE';
% evenodd{1} = 'EVEN';
% evenodd{2} = 'ODD';
% symbols = ['A' 'B'];
% 
% fingerchooser = [1 2];
% evenoddchooser = [1 2];

numblocks = 1;
numtrials = 16;
stimchoices = [1,9];

fingers{1} = 'INDEX';
fingers{2} = 'MIDDLE';
evenodd{1} = 'EVEN';
evenodd{2} = 'ODD';
symbols = ['A' 'B'];

fingerchoosertemp = [1 2];
evenoddchoosertemp = [1 2];

printsymbols_l3 = ['\n\n\n\n Press spacebar to continue'];
printfingers_l3 = ['\n\n\n\n Press spacebar to continue'];

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
        symbolchooser{trial,block} = Shuffle(symbols);
        fingerchooser_1{trial,block} = Shuffle(fingerchoosertemp);
        fingerchooser_2{trial,block} = Shuffle(fingerchoosertemp);
        evenoddchooser_1{trial,block} = Shuffle(evenoddchoosertemp);
        evenoddchooser_2{trial,block} = Shuffle(evenoddchoosertemp);
        
        %determine length of interstimulus delays (variable 1-2s) and record it
        %actual length of isd presentation determined by
        %isdTimeFrames*isi!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        %this is due to loop below for frame = 1:isdTimeFrames and the hardware
        %determined value of ifi
        isdTimeSecs(trial,block) = rand(1)+1;
        isdTimeFrames(trial,block) = round(isdTimeSecs(trial,1)/ifi);
        
        %make strings to present
        %decide which symbols are assigned to even/odd and record
        printsymbols_l1{trial,block} = [evenodd{evenoddchooser_1{trial,block}(1)} ' -> '...
            symbolchooser{trial,block}(1)];
        printsymbols_l2{trial,block} = ['\n\n' evenodd{evenoddchooser_1{trial,block}(2)} ' -> '...
            symbolchooser{trial,block}(2)];
        
        %choose finger assigned to even/odd and record
        printfingers_l1{trial,block} = [evenodd{evenoddchooser_1{trial,block}(1)} ' -> '...
            fingers{fingerchooser_1{trial,block}(1)}];
        printfingers_l2{trial,block} = ['\n\n' evenodd{evenoddchooser_1{trial,block}(2)} ' -> '...
            fingers{fingerchooser_1{trial,block}(2)}];
        
        %determine placement of A and B on screen
        %reuse fingerchooser, reshuffle so subjects can't determine spatial
        %location from rule presentation (even though it means nothing in
        %that condition), record symbol on left side of stimulus screen
        
        printstim_l2(trial,block) = symbols(fingerchooser_2{trial,block}(1)); %prints on left of screen
        printstim_l3(trial,block) = symbols(fingerchooser_2{trial,block}(2)); %prints on right of screen
        
        
        
 
    end
end
%----------------------------------------------------------------------
%                       Timing Information
%----------------------------------------------------------------------

%hold time, intertrial interval, rule, and stimulus presentation time in seconds 
%and frames
%Interstimulus delay defined in expt loop in order to be variable per trial
holdTimeSecs = 1;
holdTimeFrames = round(holdTimeSecs/ifi);

%maximum rule and stimulus/response presentation length
spTimeSecs = 10;
spTimeFrames = round(spTimeSecs/ifi);

%max trial length for length of EMG recordings
max_tlength = 24;  %seconds
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
%preaccolate arrays because I pretend to be good at coding
trialstart_time = zeros(numtrials,numblocks);
true_SPTF = zeros(numtrials,numblocks);
true_RPTF = zeros(numtrials,numblocks);
time_passed = zeros(numtrials,numblocks);
time_remaining = zeros(numtrials,numblocks);
trialstop_time = zeros(numtrials,numblocks);
realtime = zeros(numtrials,numblocks);
adblData_mat = zeros(numtrials,numScans,numblocks);


%Start the EMG data stream.
[ljerror, dblValue] = ljudObj.eGet(ljhandle, LabJack.LabJackUD.IO.START_STREAM, 0, 0, 0);

%try a couple of different timestamping methods
streamstart_time = GetSecs;
tic
for block = 1:numblocks
    
    for trial = 1:numtrials
        
        trialstart_time(trial,block) = GetSecs;
        
        %Cue to determine whether a response has been made
        respToBeMade = true;
        
        %record the hand that is being used
%         respMat{1,trial,block} = hand;
        
%         % If this is the first trial we present a start screen and wait for a
%         % key-press
%         if trial == 1
%             DrawFormattedText(window, 'Press Any Key To Begin',...
%                 'center', 'center', white);
%             Screen('Flip', window);
%             KbStrokeWait;
%         end
        
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
            
            DrawFormattedText(window, [printsymbols_l1{trial,block} printsymbols_l2{trial,block} printsymbols_l3],...
                'center', 'center', white);
            [VBLTimestamp(trial,2,block),StimulusOnsetTime(trial,2,block),...
                FlipTimestamp(trial,2,block),Missed(trial,2,block),...
                Beampos(trial,2,block)] = Screen('Flip', window);
            
            spTimeFramescheck = 1;
            
            while respToBeMade == true && spTimeFramescheck<spTimeFrames-1
                
                [keyIsDown,secs,keyCode] = KbCheck;
                if keyCode(spacebar)
                    %respMat,respTime entries
                    respToBeMade = false;
                end
            
                DrawFormattedText(window, [printsymbols_l1{trial,block} printsymbols_l2{trial,block} printsymbols_l3],...
                    'center', 'center', white);
                Screen('Flip', window);
                
                spTimeFramescheck = spTimeFramescheck + 1;
            
            end
            
        else
                    
            DrawFormattedText(window, [printfingers_l1{trial,block} printfingers_l2{trial,block} printfingers_l3],...
                'center', 'center', white);
            [VBLTimestamp(trial,2,block),StimulusOnsetTime(trial,2,block),...
                FlipTimestamp(trial,2,block),Missed(trial,2,block),...
                Beampos(trial,2,block)] = Screen('Flip', window);
            
            spTimeFramescheck = 1;
            
            while respToBeMade == true && spTimeFramescheck<spTimeFrames-1
                
                [keyIsDown,secs,keyCode] = KbCheck;
                if keyCode(spacebar)
                    %respMat,respTime entries
                    respToBeMade = false;
                end
                
                DrawFormattedText(window, [printfingers_l1{trial,block} printfingers_l2{trial,block} printfingers_l3],...
                    'center', 'center', white);
                Screen('Flip', window);
                
                spTimeFramescheck = spTimeFramescheck + 1;
                
            end
            
        end
        
        true_SPTF(trial,block) = spTimeFramescheck + 1;
        
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
        
%         [VBLTimestamp(trial,4,block),StimulusOnsetTime(trial,4,block),...
%             FlipTimestamp(trial,4,block),Missed(trial,4,block),...
%             Beampos(trial,4,block)] = Screen('Flip', window);

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
                
            time_passed(trial,block) = holdTimeFrames+true_SPTF(trial,block)+isdTimeFrames(trial,block)+true_RPTF(trial,block);  %in frames
            time_remaining(trial,block) = max_tlength_frames - time_passed(trial,block);
            
            KbStrokeWait;
            ShowCursor;
            sca;
            
        else
            
            %determine length of ITI based off of trial timing so that
            %total length of trial is 24 seconds
            
            time_passed(trial,block) = holdTimeFrames+true_SPTF(trial,block)+isdTimeFrames(trial,block)+true_RPTF(trial,block);  %in frames
            time_remaining(trial,block) = max_tlength_frames - time_passed(trial,block);  %in frames - this is the number of frames we want to present ITI for
            
            Screen('FillRect',window,black);
            [VBLTimestamp(trial,5,block),StimulusOnsetTime(trial,5,block),...
                FlipTimestamp(trial,5,block),Missed(trial,5,block),...
                Beampos(trial,5,block)] = Screen('Flip', window);
            
            for frame = 1:1:time_remaining - 1
                
                Screen('FillRect',window,black);
                Screen('Flip', window);
                
            end
            
        end
        
        trialstop_time(trial,block) = GetSecs;  %relative to streamstart_time
        realtime(trial,block) = toc;  %relative to tic
        
        %Init array to store EMG data
        adblData = NET.createArray('System.Double', 1*numScans);  %Max buffer size (#channels*numScansRequested)
        
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

%Stop the EMG data stream
ljudObj.eGet(ljhandle, LabJack.LabJackUD.IO.STOP_STREAM, 0, 0, 0);

clear e eNet ljasm ljerror ljudObj
