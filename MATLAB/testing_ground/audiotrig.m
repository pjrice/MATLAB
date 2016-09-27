clear

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

%Init audio for timestamping
% InitializePsychSound
InitializePsychSound(1)  %for really low latency

soundfilename = 'Z:\Work\UW\projects\DRI\ECoG\1volt.wav';
[sounddata,soundfreq] = audioread(soundfilename);
nrchannels = 1;  %file is mono, not stereo
reps = 1;  %only play the sound once each time it is called
pahandle = PsychPortAudio('Open', [], [], 1, soundfreq, nrchannels);
PsychPortAudio('FillBuffer', pahandle, sounddata');


HideCursor


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% outfile = fopen('latencytest.txt', 'w');
% soundfilename = 'Z:\Work\UW\projects\DRI\ECoG\1volt.wav';
% [sounddata,soundfreq] = audioread(soundfilename);
% t1 = GetSecs;
% sound(sounddata,soundfreq);
% t2 = GetSecs;
% latency = t2-t1;
% fprintf(outfile,'%s,%2.4f/n',soundfilename,latency);

%send the "sound" as event timestamp
t1 = PsychPortAudio('Start', pahandle, reps, 0, 1);
PsychPortAudio('Stop', pahandle);


DrawFormattedText(window, 'Press any key to begin',...
    'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;

t2 = PsychPortAudio('Start', pahandle, reps, 0, 1);
PsychPortAudio('Stop', pahandle);


DrawFormattedText(window, 'Play the sound',...
    'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;

t3 = PsychPortAudio('Start', pahandle, reps, 0, 1);
PsychPortAudio('Stop', pahandle);


PsychPortAudio('Close');
ShowCursor;
sca;

