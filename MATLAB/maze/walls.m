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

HideCursor

%----------------------------------------------------------------------
%                       Fixation Cross
%----------------------------------------------------------------------

%setting the length of the lines
ceilhorz1 = round(screenXpixels/5);

wallvert1 = round(screenYpixels/4);
wallvert2 = round(screenYpixels/4);

wcdiag1 = round(screenXpixels/8);

doorhorz = round(screenXpixels/25);
doorvert = round(screenXpixels/16);
doordiag1 = round(screenXpixels/37);

%setting the screen coordinates of the lines
ch1_x = [-ceilhorz1 ceilhorz1 0 0];
ch1_y = [0 0 0 0];
ch1Coords = [ch1_x; ch1_y];

wv1_x = [0 0 0 0];
wv1_y = [0 0 -wallvert1 wallvert1];
wv1Coords = [wv1_x; wv1_y];

wv2_x = [0 0 0 0];
wv2_y = [0 0 -wallvert2 wallvert2];
wv2Coords = [wv2_x; wv2_y];

wcd1_xy = [-wcdiag1 wcdiag1 -wcdiag1 wcdiag1];
diag1Coords = [ch1_y wcd1_xy; ch1_y wcd1_xy];

wcd2_xy = [-wcdiag1 wcdiag1 -wcdiag1 wcdiag1];
diag2Coords = [ch1_y -wcd1_xy; -ch1_y wcd1_xy];

dh1_x = [-doorhorz doorhorz 0 0];
dh1_y = [0 0 0 0];
dh1Coords = [dh1_x; dh1_y];

dv1_x = [0 0 0 0];
dv1_y = [0 0 -doorvert doorvert];
dv1Coords = [dv1_x; dv1_y];

dd1_xy = [-doordiag1 doordiag1 -doordiag1 doordiag1];
ddiag1Coords = [ch1_y dd1_xy; ch1_y dd1_xy];
ddiag2Coords = [ch1_y -dd1_xy; -ch1_y dd1_xy];

%setting the line width for wall outlines
lineWidthPix = 4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DrawFormattedText(window, 'Press any key to begin',...
    'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;

%ceiling horizontal
Screen('DrawLines', window, ch1Coords,lineWidthPix, white, [xCenter yCenter*0.25], 2);
Screen('DrawLines', window, ch1Coords,lineWidthPix, white, [xCenter yCenter*1.25], 2);

%wall verticals
Screen('DrawLines', window, wv1Coords,lineWidthPix, white, [xCenter*0.6 yCenter*0.75], 2);
Screen('DrawLines', window, wv1Coords,lineWidthPix, white, [xCenter*1.4 yCenter*0.75], 2);

Screen('DrawLines', window, wv2Coords,lineWidthPix, white, [xCenter*0.1 yCenter*1.64], 2);
Screen('DrawLines', window, wv2Coords,lineWidthPix, white, [xCenter*1.9 yCenter*1.64], 2);

%wall/ceiling diagonals
Screen('DrawLines', window, diag1Coords,lineWidthPix, white, [xCenter*1.65 yCenter*0.7], 2);
Screen('DrawLines', window, diag2Coords,lineWidthPix, white, [xCenter*0.35 yCenter*0.7], 2);

Screen('DrawLines', window, diag1Coords,lineWidthPix, white, [xCenter*1.65 yCenter*1.7], 2);
Screen('DrawLines', window, diag2Coords,lineWidthPix, white, [xCenter*0.35 yCenter*1.7], 2);

%door horizontal
Screen('DrawLines', window, dh1Coords,lineWidthPix, white, [xCenter yCenter*0.8], 2);

%door verticals
Screen('DrawLines', window, dv1Coords,lineWidthPix, white, [xCenter*0.919 yCenter*1.02], 2);
Screen('DrawLines', window, dv1Coords,lineWidthPix, white, [xCenter*1.081 yCenter*1.02], 2);

Screen('DrawLines', window, dv1Coords,lineWidthPix, white, [xCenter*0.5 yCenter*1.2], 2);
Screen('DrawLines', window, dv1Coords,lineWidthPix, white, [xCenter*1.5 yCenter*1.2], 2);

Screen('DrawLines', window, dv1Coords,lineWidthPix, white, [xCenter*0.4 yCenter*1.39], 2);
Screen('DrawLines', window, dv1Coords,lineWidthPix, white, [xCenter*1.6 yCenter*1.39], 2);

%door diagonals
Screen('DrawLines', window, ddiag1Coords,lineWidthPix, white, [xCenter*1.55 yCenter*1.07], 2);
Screen('DrawLines', window, ddiag2Coords,lineWidthPix, white, [xCenter*0.45 yCenter*1.07], 2);


Screen('Flip', window);
KbStrokeWait;
ShowCursor;
sca;








