
%script for prime masking idea, where letters appear/disappear in colors

sca
clear

numtrials = 5;
whites = 1;

rand_cloc = input('Randomize placement of colors? y/n [y]: ','s');

%Setup PTB with some default values
PsychDefaultSetup(2);

%set screen num to secondary monitor if one is connected
screenNumber = max(Screen('Screens'));
% screenNumber = 1;  %weirdness with how tms task computer assigns window numbers

%define colors
%to reference colors from cvars/bwgvars: colors.(cvars{n})
bwgvars = {'black,','white','grey'};
cvars = {'red','orange','yellow','green','blue','indigo','violet'};

colors.white = WhiteIndex(screenNumber);
colors.grey = colors.white/2;
colors.black = BlackIndex(screenNumber);

colors.red = [1 0 0];
colors.orange = [1 0.35 0];
colors.yellow = [1 1 0];
colors.green = [0 1 0];
colors.blue = [0 0 1];
colors.indigo = [0.25 0 1];
colors.violet = [0.75 0 1];

blue = [0 0 1];

%slightly altered to print priming letters
colors(2).red = [0.95 0 0];
colors(2).orange = [0.95 0.35 0];
colors(2).yellow = [0.95 1 0];
colors(2).green = [0 0.95 0];
colors(2).blue = [0 0 0.95];
colors(2).indigo = [0.25 0 0.95];
colors(2).violet = [0.75 0 0.95];

% colors(2).red = [0.5 0 0];
% colors(2).orange = [0.5 0.35 0];
% colors(2).yellow = [0.5 1 0];
% colors(2).green = [0 0.5 0];
% colors(2).blue = [0 0 0.5];
% colors(2).indigo = [0.25 0 0.5];
% colors(2).violet = [0.75 0 0.5];

%randomize color placement if necessary
if isempty(rand_cloc) || rand_cloc=='y'
    
    color_mat = cat(2,colors(1).red',colors(1).orange',colors(1).yellow',...
        colors(1).green',colors(1).blue',colors(1).indigo',colors(1).violet');
        
    color_mats = cell(numtrials,1);
    
    for i = 1:numtrials
        
        cm_idx(i,:) = randperm(size(color_mat,2));
        
        color_mats{i} = color_mat(:,cm_idx(i,:));
        
    end
     
elseif rand_cloc=='n'
    
    color_mat = cat(2,colors(1).red',colors(1).orange',colors(1).yellow',...
        colors(1).green',colors(1).blue',colors(1).indigo',colors(1).violet');
    
    cm_idx = repmat([1 2 3 4 5 6 7],numtrials,1);
    color_mats = cell(numtrials,1);
    color_mats(:) = {color_mat};
    
else
    error('y or n')
end


%Open the screen
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, colors.black, [], 32, 2);

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

%define the destination rectangles for the colored rectangles
dstRect = [0 0 screenXpixels/8 screenXpixels/8];
dstRect1 = CenterRectOnPointd(dstRect, xCenter*0.25, yCenter);
dstRect2 = CenterRectOnPointd(dstRect, xCenter*0.5, yCenter);
dstRect3 = CenterRectOnPointd(dstRect, xCenter*0.75, yCenter);
dstRectcent = CenterRectOnPointd(dstRect, xCenter, yCenter);
dstRect4 = CenterRectOnPointd(dstRect, xCenter*1.25, yCenter);
dstRect5 = CenterRectOnPointd(dstRect, xCenter*1.5, yCenter);
dstRect6 = CenterRectOnPointd(dstRect, xCenter*1.75, yCenter);

rect_mat = cat(2,dstRect1',dstRect2',dstRect3',dstRectcent',dstRect4',dstRect5',dstRect6');

%define the destination rectangles for the letters
A = Screen('TextBounds',window,'A');

loc1 = CenterRectOnPointd(A,xCenter*0.25, yCenter);
loc2 = CenterRectOnPointd(A,xCenter*0.5, yCenter);
loc3 = CenterRectOnPointd(A,xCenter*0.75, yCenter);
loc4 = CenterRectOnPointd(A,xCenter, yCenter);
loc5 = CenterRectOnPointd(A,xCenter*1.25, yCenter);
loc6 = CenterRectOnPointd(A,xCenter*1.5, yCenter);
loc7 = CenterRectOnPointd(A,xCenter*1.75, yCenter);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%want to try to use Screen('FillRect') command once to print all rectangles
%while still maintaining ability to randomize colors referenced from
%structure colors

% for trial = 1:numtrials
% 
%     Screen('FillRect',window,color_mats{trial},rect_mat);
% %     Screen('FillRect',window,whites,rect_mat);
%     Screen('DrawText',window,'A',loc1(1),loc1(2),colors(2).(cvars{cm_idx(trial,1)}));
%     Screen('DrawText',window,'B',loc2(1),loc2(2),colors(2).(cvars{cm_idx(trial,2)}));
%     Screen('DrawText',window,'C',loc3(1),loc3(2),colors(2).(cvars{cm_idx(trial,3)}));
%     Screen('DrawText',window,'D',loc4(1),loc4(2),colors(2).(cvars{cm_idx(trial,4)}));
%     Screen('DrawText',window,'E',loc5(1),loc5(2),colors(2).(cvars{cm_idx(trial,5)}));
%     Screen('DrawText',window,'F',loc6(1),loc6(2),colors(2).(cvars{cm_idx(trial,6)}));
%     Screen('DrawText',window,'G',loc7(1),loc7(2),colors(2).(cvars{cm_idx(trial,7)}));
%     Screen('Flip',window);
%     KbStrokeWait;
% 
% end

Screen('FillRect',window,colors(1).blue)
Screen('Flip',window);
KbStrokeWait;




ShowCursor;
sca;


