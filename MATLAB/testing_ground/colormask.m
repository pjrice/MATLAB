
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

test1 = [0.98 1 0];  %yellowish
test2 = [0 0.98 0];  %greenish
test3 = [0 0 0.98];  %blueish

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
dstRect = [0 0 screenXpixels/8 screenXpixels/8];
dstRect1 = CenterRectOnPointd(dstRect, xCenter*0.25, yCenter);
dstRect2 = CenterRectOnPointd(dstRect, xCenter*0.5, yCenter);
dstRect3 = CenterRectOnPointd(dstRect, xCenter*0.75, yCenter);
dstRectcent = CenterRectOnPointd(dstRect, xCenter, yCenter);
dstRect4 = CenterRectOnPointd(dstRect, xCenter*1.25, yCenter);
dstRect5 = CenterRectOnPointd(dstRect, xCenter*1.5, yCenter);
dstRect6 = CenterRectOnPointd(dstRect, xCenter*1.75, yCenter);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


C = Screen('TextBounds',window,'C');
A = Screen('TextBounds',window,'A');
T = Screen('TextBounds',window,'T');
C_loc = CenterRectOnPointd(normBR,xCenter*0.75, yCenter);
A_loc = CenterRectOnPointd(normBR,xCenter, yCenter);
T_loc = CenterRectOnPointd(normBR,xCenter*1.25, yCenter);

Screen('FillRect',window,black);
Screen('FillRect',window,red,dstRect1);
Screen('FillRect',window,orange,dstRect2);
Screen('FillRect',window,yellow,dstRect3);
Screen('FillRect',window,green,dstRectcent);
Screen('FillRect',window,blue,dstRect4);
Screen('FillRect',window,indigo,dstRect5);
Screen('FillRect',window,violet,dstRect6);
Screen('DrawText',window,'C',C_loc(1),C_loc(2),test1)
Screen('DrawText',window,'A',A_loc(1),A_loc(2),test2)
Screen('DrawText',window,'T',T_loc(1),T_loc(2),test3)
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


