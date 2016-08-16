
%script for prime masking idea, where letters "fade" in and out of colors

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
orange = [1 0.35 0];
yellow = [1 1 0];
green = [0 1 0];
blue = [0 0 1];
indigo = [0.25 0 1];
violet = [0.75 0 1];

%roy g biv

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get the size of the image (all should be same size)
% [s1, s2, s3] = size(A_img);

%define the destination rectangle for the images
dstRect = [0 0 100 100];
dstRect = CenterRectOnPointd(dstRect, xCenter, yCenter*1.35);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Screen('FillRect',window,black);
Screen('FillRect',window,blue,dstRect);
Screen('Flip', window);
KbStrokeWait;

% Screen('FillRect',window,white);
% Screen('Flip', window);
% KbStrokeWait;
% 
% Screen('FillRect',window,blue);
% Screen('Flip', window);
% KbStrokeWait;
% 
% Screen('FillRect',window,test1);
% Screen('Flip', window);
% KbStrokeWait;
% 
% Screen('FillRect',window,test2);
% Screen('Flip', window);
% KbStrokeWait;
% 
% Screen('FillRect',window,test3);
% Screen('Flip', window);
% KbStrokeWait;
% 
% Screen('FillRect',window,test4);
% Screen('Flip', window);
% KbStrokeWait;
% 
% Screen('FillRect',window,test5);
% Screen('Flip', window);
% KbStrokeWait;
% 
% Screen('FillRect',window,test6);
% Screen('Flip', window);
% KbStrokeWait;

ShowCursor;
sca;


