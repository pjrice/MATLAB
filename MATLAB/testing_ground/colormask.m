
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
red1 = [0.98 0 0];

orange = [1 0.35 0];
orange1 = [0.98 0.35 0];

yellow = [1 1 0];
yellow1 = [0.98 1 0];  %yellowish

green = [0 1 0];
green1 = [0 0.98 0];  %greenish

blue = [0 0 1];
blue1 = [0 0 0.98];  %blueish

indigo = [0.25 0 1];
indigo1 = [0.25 0 0.98];

violet = [0.75 0 1];
violet1 = [0.75 0 0.98];


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


A = Screen('TextBounds',window,'A');

loc1 = CenterRectOnPointd(A,xCenter*0.25, yCenter);
loc2 = CenterRectOnPointd(A,xCenter*0.5, yCenter);
loc3 = CenterRectOnPointd(A,xCenter*0.75, yCenter);
loc4 = CenterRectOnPointd(A,xCenter, yCenter);
loc5 = CenterRectOnPointd(A,xCenter*1.25, yCenter);
loc6 = CenterRectOnPointd(A,xCenter*1.5, yCenter);
loc7 = CenterRectOnPointd(A,xCenter*1.75, yCenter);

Screen('FillRect',window,black);
Screen('FillRect',window,red,dstRect1);
Screen('FillRect',window,orange,dstRect2);
Screen('FillRect',window,yellow,dstRect3);
Screen('FillRect',window,green,dstRectcent);
Screen('FillRect',window,blue,dstRect4);
Screen('FillRect',window,indigo,dstRect5);
Screen('FillRect',window,violet,dstRect6);
Screen('Flip', window);

pause(1)

Screen('FillRect',window,black);
Screen('FillRect',window,red,dstRect1);
Screen('FillRect',window,orange,dstRect2);
Screen('FillRect',window,yellow,dstRect3);
Screen('FillRect',window,green,dstRectcent);
Screen('FillRect',window,blue,dstRect4);
Screen('FillRect',window,indigo,dstRect5);
Screen('FillRect',window,violet,dstRect6);
Screen('DrawText',window,'A',loc1(1),loc1(2),white);
Screen('DrawText',window,'B',loc2(1),loc2(2),white);
Screen('DrawText',window,'C',loc3(1),loc3(2),white);
Screen('DrawText',window,'D',loc4(1),loc4(2),white);
Screen('DrawText',window,'E',loc5(1),loc5(2),white);
Screen('DrawText',window,'F',loc6(1),loc6(2),white);
Screen('DrawText',window,'G',loc7(1),loc7(2),white);
Screen('Flip', window);
KbStrokeWait;

Screen('FillRect',window,black);
Screen('FillRect',window,red,dstRect1);
Screen('FillRect',window,orange,dstRect2);
Screen('FillRect',window,yellow,dstRect3);
Screen('FillRect',window,green,dstRectcent);
Screen('FillRect',window,blue,dstRect4);
Screen('FillRect',window,indigo,dstRect5);
Screen('FillRect',window,violet,dstRect6);
Screen('Flip', window);

pause(1)


ShowCursor;
sca;


